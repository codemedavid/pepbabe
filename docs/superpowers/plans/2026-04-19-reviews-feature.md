# Reviews Feature Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add an admin-curated review system with image/text reviews, a public reviews page, and linked reviews in product bottom sheets.

**Architecture:** Two Supabase tables (`reviews` + `review_products` join table), a `useReviews` hook for CRUD + real-time, a `ReviewsManager` admin component, a `ReviewsPage` public page, and a reviews section injected into `ProductDetailModal`.

**Tech Stack:** React 18, TypeScript, Supabase (Postgres + Storage), Tailwind CSS, Vite, React Router DOM

---

## File Structure

| File | Purpose |
|------|---------|
| Create: `src/types/review.ts` | Review and ReviewProduct TypeScript interfaces |
| Create: `src/hooks/useReviews.ts` | Supabase CRUD hook with real-time subscriptions |
| Create: `src/components/ReviewsManager.tsx` | Admin CRUD panel for reviews |
| Create: `src/components/ReviewsPage.tsx` | Public masonry reviews page |
| Modify: `src/components/AdminDashboard.tsx` | Add reviews tab + quick action button |
| Modify: `src/components/ProductDetailModal.tsx` | Add linked reviews section |
| Modify: `src/App.tsx` | Add `/reviews` route |

---

### Task 1: Create Supabase Tables

**Files:**
- No code files — database setup via Supabase SQL editor

- [ ] **Step 1: Create `reviews` table**

Run in Supabase SQL editor:

```sql
CREATE TABLE reviews (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text,
  content text,
  image_url text,
  review_type text NOT NULL DEFAULT 'testimonial' CHECK (review_type IN ('testimonial', 'result_photo')),
  featured boolean NOT NULL DEFAULT false,
  created_at timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Allow public read" ON reviews FOR SELECT USING (true);
CREATE POLICY "Allow all for anon" ON reviews FOR ALL USING (true);
```

- [ ] **Step 2: Create `review_products` join table**

```sql
CREATE TABLE review_products (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  review_id uuid NOT NULL REFERENCES reviews(id) ON DELETE CASCADE,
  product_id uuid NOT NULL REFERENCES products(id) ON DELETE CASCADE,
  UNIQUE(review_id, product_id)
);

ALTER TABLE review_products ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Allow public read" ON review_products FOR SELECT USING (true);
CREATE POLICY "Allow all for anon" ON review_products FOR ALL USING (true);
```

- [ ] **Step 3: Verify tables exist**

Run in SQL editor:
```sql
SELECT * FROM reviews LIMIT 0;
SELECT * FROM review_products LIMIT 0;
```
Expected: empty result sets with correct columns.

- [ ] **Step 4: Create storage bucket for review images**

In Supabase Dashboard > Storage, create a new public bucket named `review-images`. Or run:
```sql
INSERT INTO storage.buckets (id, name, public) VALUES ('review-images', 'review-images', true);
CREATE POLICY "Allow public read on review-images" ON storage.objects FOR SELECT USING (bucket_id = 'review-images');
CREATE POLICY "Allow public upload on review-images" ON storage.objects FOR INSERT WITH CHECK (bucket_id = 'review-images');
CREATE POLICY "Allow public delete on review-images" ON storage.objects FOR DELETE USING (bucket_id = 'review-images');
```

---

### Task 2: Create TypeScript Types

**Files:**
- Create: `src/types/review.ts`

- [ ] **Step 1: Create review types file**

```typescript
// src/types/review.ts
export interface Review {
  id: string;
  title: string | null;
  content: string | null;
  image_url: string | null;
  review_type: 'testimonial' | 'result_photo';
  featured: boolean;
  created_at: string;
}

export interface ReviewProduct {
  id: string;
  review_id: string;
  product_id: string;
}

export interface ReviewWithProducts extends Review {
  linked_product_ids: string[];
}
```

- [ ] **Step 2: Commit**

```bash
git add src/types/review.ts
git commit -m "feat(reviews): add TypeScript types for reviews"
```

---

### Task 3: Create useReviews Hook

**Files:**
- Create: `src/hooks/useReviews.ts`

This follows the same pattern as `src/hooks/useMenu.ts` — Supabase queries with real-time subscriptions.

- [ ] **Step 1: Create the hook file**

```typescript
// src/hooks/useReviews.ts
import { useState, useEffect } from 'react';
import { supabase } from '../lib/supabase';
import type { Review, ReviewWithProducts } from '../types/review';

export function useReviews() {
  const [reviews, setReviews] = useState<ReviewWithProducts[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    fetchReviews();

    const channelId = `reviews-realtime-${Date.now()}`;
    const channel = supabase
      .channel(channelId)
      .on(
        'postgres_changes',
        { event: '*', schema: 'public', table: 'reviews' },
        () => fetchReviews()
      )
      .on(
        'postgres_changes',
        { event: '*', schema: 'public', table: 'review_products' },
        () => fetchReviews()
      )
      .subscribe();

    return () => {
      supabase.removeChannel(channel);
    };
  }, []);

  async function fetchReviews() {
    try {
      setLoading(true);
      const { data: reviewsData, error: reviewsError } = await supabase
        .from('reviews')
        .select('*')
        .order('featured', { ascending: false })
        .order('created_at', { ascending: false });

      if (reviewsError) throw reviewsError;

      const { data: linksData, error: linksError } = await supabase
        .from('review_products')
        .select('*');

      if (linksError) throw linksError;

      const enriched: ReviewWithProducts[] = (reviewsData || []).map((r) => ({
        ...r,
        linked_product_ids: (linksData || [])
          .filter((lnk) => lnk.review_id === r.id)
          .map((lnk) => lnk.product_id),
      }));

      setReviews(enriched);
      setError(null);
    } catch (err: any) {
      console.error('Error fetching reviews:', err);
      setError(err.message);
    } finally {
      setLoading(false);
    }
  }

  async function addReview(
    review: Omit<Review, 'id' | 'created_at'>,
    productIds: string[]
  ) {
    const { data, error } = await supabase
      .from('reviews')
      .insert([review])
      .select()
      .single();

    if (error) throw error;

    if (productIds.length > 0) {
      const links = productIds.map((pid) => ({
        review_id: data.id,
        product_id: pid,
      }));
      const { error: linkError } = await supabase
        .from('review_products')
        .insert(links);
      if (linkError) throw linkError;
    }

    await fetchReviews();
    return data;
  }

  async function updateReview(
    id: string,
    updates: Partial<Omit<Review, 'id' | 'created_at'>>,
    productIds: string[]
  ) {
    const { error } = await supabase
      .from('reviews')
      .update(updates)
      .eq('id', id);

    if (error) throw error;

    // Replace product links: delete old, insert new
    const { error: delError } = await supabase
      .from('review_products')
      .delete()
      .eq('review_id', id);

    if (delError) throw delError;

    if (productIds.length > 0) {
      const links = productIds.map((pid) => ({
        review_id: id,
        product_id: pid,
      }));
      const { error: linkError } = await supabase
        .from('review_products')
        .insert(links);
      if (linkError) throw linkError;
    }

    await fetchReviews();
  }

  async function deleteReview(id: string) {
    const { error } = await supabase.from('reviews').delete().eq('id', id);
    if (error) throw error;
    await fetchReviews();
  }

  async function getReviewsForProduct(productId: string): Promise<Review[]> {
    const { data: links, error: linkErr } = await supabase
      .from('review_products')
      .select('review_id')
      .eq('product_id', productId);

    if (linkErr) throw linkErr;
    if (!links || links.length === 0) return [];

    const reviewIds = links.map((l) => l.review_id);
    const { data, error: revErr } = await supabase
      .from('reviews')
      .select('*')
      .in('id', reviewIds)
      .order('featured', { ascending: false })
      .order('created_at', { ascending: false });

    if (revErr) throw revErr;
    return data || [];
  }

  return {
    reviews,
    loading,
    error,
    addReview,
    updateReview,
    deleteReview,
    getReviewsForProduct,
    refreshReviews: fetchReviews,
  };
}
```

- [ ] **Step 2: Commit**

```bash
git add src/hooks/useReviews.ts
git commit -m "feat(reviews): add useReviews hook with CRUD and real-time"
```

---

### Task 4: Create ReviewsManager Admin Component

**Files:**
- Create: `src/components/ReviewsManager.tsx`

Follows the same CRUD pattern as `src/components/COAManager.tsx`.

- [ ] **Step 1: Create ReviewsManager component**

```tsx
// src/components/ReviewsManager.tsx
import React, { useState, useEffect } from 'react';
import { Plus, Edit2, Trash2, Save, X, ArrowLeft, Star, MessageSquare, Image as ImageIcon } from 'lucide-react';
import { useReviews } from '../hooks/useReviews';
import { useMenu } from '../hooks/useMenu';
import ImageUpload from './ImageUpload';
import type { ReviewWithProducts } from '../types/review';

interface ReviewsManagerProps {
  onBack?: () => void;
}

const ReviewsManager: React.FC<ReviewsManagerProps> = ({ onBack }) => {
  const { reviews, loading, addReview, updateReview, deleteReview } = useReviews();
  const { products } = useMenu();
  const [editingId, setEditingId] = useState<string | null>(null);
  const [isAdding, setIsAdding] = useState(false);
  const [formData, setFormData] = useState({
    title: '',
    content: '',
    image_url: '',
    review_type: 'testimonial' as 'testimonial' | 'result_photo',
    featured: false,
  });
  const [selectedProductIds, setSelectedProductIds] = useState<string[]>([]);
  const [isProcessing, setIsProcessing] = useState(false);

  const resetForm = () => {
    setFormData({
      title: '',
      content: '',
      image_url: '',
      review_type: 'testimonial',
      featured: false,
    });
    setSelectedProductIds([]);
    setEditingId(null);
    setIsAdding(false);
  };

  const handleEdit = (review: ReviewWithProducts) => {
    setFormData({
      title: review.title || '',
      content: review.content || '',
      image_url: review.image_url || '',
      review_type: review.review_type,
      featured: review.featured,
    });
    setSelectedProductIds(review.linked_product_ids);
    setEditingId(review.id);
    setIsAdding(false);
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!formData.content && !formData.image_url) {
      alert('Please provide either review text or an image.');
      return;
    }

    setIsProcessing(true);
    try {
      const reviewPayload = {
        title: formData.title || null,
        content: formData.content || null,
        image_url: formData.image_url || null,
        review_type: formData.review_type,
        featured: formData.featured,
      };

      if (editingId) {
        await updateReview(editingId, reviewPayload, selectedProductIds);
      } else {
        await addReview(reviewPayload, selectedProductIds);
      }
      resetForm();
    } catch (err: any) {
      alert('Error saving review: ' + err.message);
    } finally {
      setIsProcessing(false);
    }
  };

  const handleDelete = async (id: string) => {
    if (!confirm('Delete this review?')) return;
    try {
      await deleteReview(id);
    } catch (err: any) {
      alert('Error deleting review: ' + err.message);
    }
  };

  const toggleProductSelection = (productId: string) => {
    setSelectedProductIds((prev) =>
      prev.includes(productId)
        ? prev.filter((id) => id !== productId)
        : [...prev, productId]
    );
  };

  return (
    <div className="min-h-screen bg-gray-50 p-4">
      <div className="max-w-4xl mx-auto">
        {/* Header */}
        <div className="flex items-center justify-between mb-6">
          <div className="flex items-center gap-3">
            {onBack && (
              <button
                onClick={onBack}
                className="p-2 hover:bg-gray-100 rounded-lg transition-colors"
              >
                <ArrowLeft className="w-5 h-5 text-gray-600" />
              </button>
            )}
            <div>
              <h1 className="text-2xl font-bold text-gray-900">Reviews Manager</h1>
              <p className="text-sm text-gray-500">{reviews.length} reviews</p>
            </div>
          </div>
          {!isAdding && !editingId && (
            <button
              onClick={() => setIsAdding(true)}
              className="flex items-center gap-2 px-4 py-2 bg-teal-600 text-white rounded-lg hover:bg-teal-700 transition-colors text-sm font-medium"
            >
              <Plus className="w-4 h-4" />
              Add Review
            </button>
          )}
        </div>

        {/* Form */}
        {(isAdding || editingId) && (
          <form onSubmit={handleSubmit} className="bg-white rounded-2xl p-6 border border-gray-200 shadow-sm mb-6">
            <h2 className="text-lg font-semibold text-gray-900 mb-4">
              {editingId ? 'Edit Review' : 'Add New Review'}
            </h2>

            <div className="space-y-4">
              {/* Title */}
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Title (optional)</label>
                <input
                  type="text"
                  value={formData.title}
                  onChange={(e) => setFormData({ ...formData, title: e.target.value })}
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-teal-500 focus:border-transparent text-sm"
                  placeholder="e.g. Amazing results!"
                />
              </div>

              {/* Content */}
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Review Text (optional)</label>
                <textarea
                  value={formData.content}
                  onChange={(e) => setFormData({ ...formData, content: e.target.value })}
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-teal-500 focus:border-transparent text-sm"
                  rows={4}
                  placeholder="Customer review text..."
                />
              </div>

              {/* Image Upload */}
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Review Image (optional)</label>
                <ImageUpload
                  currentImage={formData.image_url || null}
                  onImageChange={(url) => setFormData({ ...formData, image_url: url || '' })}
                  folder="review-images"
                />
              </div>

              {/* Review Type */}
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Review Type</label>
                <select
                  value={formData.review_type}
                  onChange={(e) => setFormData({ ...formData, review_type: e.target.value as 'testimonial' | 'result_photo' })}
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-teal-500 focus:border-transparent text-sm"
                >
                  <option value="testimonial">Testimonial</option>
                  <option value="result_photo">Result Photo</option>
                </select>
              </div>

              {/* Featured Toggle */}
              <label className="flex items-center gap-2 cursor-pointer">
                <input
                  type="checkbox"
                  checked={formData.featured}
                  onChange={(e) => setFormData({ ...formData, featured: e.target.checked })}
                  className="w-4 h-4 text-teal-600 rounded border-gray-300 focus:ring-teal-500"
                />
                <span className="text-sm font-medium text-gray-700">Featured Review</span>
              </label>

              {/* Product Linker */}
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Link to Products (optional)</label>
                <div className="border border-gray-300 rounded-lg max-h-48 overflow-y-auto p-2 space-y-1">
                  {products.map((product) => (
                    <label
                      key={product.id}
                      className={`flex items-center gap-2 px-3 py-2 rounded-lg cursor-pointer transition-colors text-sm ${
                        selectedProductIds.includes(product.id)
                          ? 'bg-teal-50 border border-teal-200'
                          : 'hover:bg-gray-50'
                      }`}
                    >
                      <input
                        type="checkbox"
                        checked={selectedProductIds.includes(product.id)}
                        onChange={() => toggleProductSelection(product.id)}
                        className="w-4 h-4 text-teal-600 rounded border-gray-300 focus:ring-teal-500"
                      />
                      <span className="text-gray-700">{product.name}</span>
                    </label>
                  ))}
                  {products.length === 0 && (
                    <p className="text-sm text-gray-400 text-center py-2">No products available</p>
                  )}
                </div>
              </div>
            </div>

            {/* Actions */}
            <div className="flex items-center gap-3 mt-6">
              <button
                type="submit"
                disabled={isProcessing}
                className="flex items-center gap-2 px-4 py-2 bg-teal-600 text-white rounded-lg hover:bg-teal-700 transition-colors text-sm font-medium disabled:opacity-50"
              >
                <Save className="w-4 h-4" />
                {isProcessing ? 'Saving...' : editingId ? 'Update Review' : 'Save Review'}
              </button>
              <button
                type="button"
                onClick={resetForm}
                className="flex items-center gap-2 px-4 py-2 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 transition-colors text-sm font-medium"
              >
                <X className="w-4 h-4" />
                Cancel
              </button>
            </div>
          </form>
        )}

        {/* Reviews List */}
        {loading ? (
          <p className="text-center text-gray-500 py-12">Loading reviews...</p>
        ) : reviews.length === 0 ? (
          <div className="text-center py-12 bg-white rounded-2xl border border-gray-200">
            <MessageSquare className="w-12 h-12 text-gray-300 mx-auto mb-3" />
            <p className="text-gray-500">No reviews yet. Add your first review!</p>
          </div>
        ) : (
          <div className="space-y-3">
            {reviews.map((review) => (
              <div
                key={review.id}
                className="bg-white rounded-xl border border-gray-200 p-4 shadow-sm"
              >
                <div className="flex gap-4">
                  {/* Thumbnail */}
                  {review.image_url && (
                    <img
                      src={review.image_url}
                      alt={review.title || 'Review'}
                      className="w-20 h-20 rounded-lg object-cover flex-shrink-0"
                    />
                  )}

                  {/* Content */}
                  <div className="flex-1 min-w-0">
                    <div className="flex items-center gap-2 mb-1">
                      {review.featured && (
                        <span className="text-xs font-medium bg-amber-100 text-amber-700 px-2 py-0.5 rounded-full">Featured</span>
                      )}
                      <span className="text-xs font-medium bg-gray-100 text-gray-600 px-2 py-0.5 rounded-full capitalize">
                        {review.review_type.replace('_', ' ')}
                      </span>
                    </div>
                    {review.title && (
                      <p className="font-semibold text-gray-900 text-sm">{review.title}</p>
                    )}
                    {review.content && (
                      <p className="text-gray-600 text-sm line-clamp-2 mt-1">{review.content}</p>
                    )}
                    {review.linked_product_ids.length > 0 && (
                      <p className="text-xs text-teal-600 mt-1">
                        Linked to {review.linked_product_ids.length} product{review.linked_product_ids.length > 1 ? 's' : ''}
                      </p>
                    )}
                  </div>

                  {/* Actions */}
                  <div className="flex items-start gap-1 flex-shrink-0">
                    <button
                      onClick={() => handleEdit(review)}
                      className="p-2 text-gray-400 hover:text-teal-600 hover:bg-teal-50 rounded-lg transition-colors"
                    >
                      <Edit2 className="w-4 h-4" />
                    </button>
                    <button
                      onClick={() => handleDelete(review.id)}
                      className="p-2 text-gray-400 hover:text-red-600 hover:bg-red-50 rounded-lg transition-colors"
                    >
                      <Trash2 className="w-4 h-4" />
                    </button>
                  </div>
                </div>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
};

export default ReviewsManager;
```

- [ ] **Step 2: Commit**

```bash
git add src/components/ReviewsManager.tsx
git commit -m "feat(reviews): add ReviewsManager admin component"
```

---

### Task 5: Wire ReviewsManager into AdminDashboard

**Files:**
- Modify: `src/components/AdminDashboard.tsx`

- [ ] **Step 1: Add import at line 20 (after ProtocolManager import)**

Add after line 20 (`import ProtocolManager from './ProtocolManager';`):

```typescript
import ReviewsManager from './ReviewsManager';
```

- [ ] **Step 2: Add 'reviews' to currentView union type at line 31**

Change line 31 from:
```typescript
const [currentView, setCurrentView] = useState<'dashboard' | 'products' | 'add' | 'edit' | 'categories' | 'payments' | 'inventory' | 'orders' | 'shipping' | 'coa' | 'faq' | 'settings' | 'promo-codes' | 'couriers' | 'protocols'>('dashboard');
```
To:
```typescript
const [currentView, setCurrentView] = useState<'dashboard' | 'products' | 'add' | 'edit' | 'categories' | 'payments' | 'inventory' | 'orders' | 'shipping' | 'coa' | 'faq' | 'settings' | 'promo-codes' | 'couriers' | 'protocols' | 'reviews'>('dashboard');
```

- [ ] **Step 3: Add reviews view handler after the FAQ view block (after line 1314)**

Insert after the FAQ view block (after line 1314 `}`):

```tsx
  // Reviews View
  if (currentView === 'reviews') {
    return (
      <div className="min-h-screen bg-gray-50">
        <ReviewsManager onBack={() => setCurrentView('dashboard')} />
      </div>
    );
  }
```

- [ ] **Step 4: Add quick action button in the dashboard grid**

Insert before the closing `</div>` of the quick actions grid (before line 1637):

```tsx
                <button
                  onClick={() => setCurrentView('reviews')}
                  className="group flex items-center gap-3 p-3 text-left hover:bg-gray-50 rounded-xl transition-all border border-transparent hover:border-gray-200"
                >
                  <div className="w-10 h-10 rounded-lg bg-pink-50 flex items-center justify-center group-hover:scale-110 transition-transform duration-300">
                    <Star className="h-5 w-5 text-pink-600" />
                  </div>
                  <div>
                    <span className="block text-sm font-semibold text-gray-900 group-hover:text-pink-600 transition-colors">Reviews</span>
                    <span className="text-xs text-gray-500">Manage testimonials</span>
                  </div>
                </button>
```

- [ ] **Step 5: Add `Star` to the lucide-react import at line 2**

Add `Star` to the destructured import from `lucide-react` at line 2 (if not already present).

- [ ] **Step 6: Commit**

```bash
git add src/components/AdminDashboard.tsx
git commit -m "feat(reviews): wire ReviewsManager into admin dashboard"
```

---

### Task 6: Create Public ReviewsPage

**Files:**
- Create: `src/components/ReviewsPage.tsx`

- [ ] **Step 1: Create ReviewsPage component**

```tsx
// src/components/ReviewsPage.tsx
import React from 'react';
import { ArrowLeft, MessageSquare } from 'lucide-react';
import { useNavigate } from 'react-router-dom';
import { useReviews } from '../hooks/useReviews';

const ReviewsPage: React.FC = () => {
  const { reviews, loading } = useReviews();
  const navigate = useNavigate();

  return (
    <div
      className="min-h-screen font-sans"
      style={{ background: '#FFFBFD' }}
    >
      {/* Header */}
      <div
        className="sticky top-0 z-40 backdrop-blur-md border-b"
        style={{
          background: 'rgba(255,251,253,0.92)',
          borderColor: 'rgba(44,27,46,0.08)',
        }}
      >
        <div className="max-w-3xl mx-auto px-4 py-3 flex items-center gap-3">
          <button
            onClick={() => navigate('/')}
            className="p-2 rounded-xl transition-colors"
            style={{ color: '#75607C' }}
          >
            <ArrowLeft className="w-5 h-5" />
          </button>
          <h1
            className="text-lg font-bold tracking-tight"
            style={{ fontFamily: "'Cormorant Garamond', serif", color: '#2C1B2E' }}
          >
            Customer Reviews
          </h1>
        </div>
      </div>

      {/* Content */}
      <div className="max-w-3xl mx-auto px-4 py-6">
        {loading ? (
          <p className="text-center py-12" style={{ color: '#75607C' }}>Loading reviews...</p>
        ) : reviews.length === 0 ? (
          <div className="text-center py-16">
            <MessageSquare className="w-12 h-12 mx-auto mb-3" style={{ color: '#BFB3C3' }} />
            <p style={{ color: '#75607C' }}>No reviews yet.</p>
          </div>
        ) : (
          <div
            className="columns-1 sm:columns-2 lg:columns-3 gap-4"
            style={{ columnFill: 'balance' }}
          >
            {reviews.map((review) => (
              <div
                key={review.id}
                className="break-inside-avoid mb-4 rounded-2xl overflow-hidden border"
                style={{
                  background: '#FFFFFF',
                  borderColor: 'rgba(44,27,46,0.07)',
                }}
              >
                {/* Image */}
                {review.image_url && (
                  <img
                    src={review.image_url}
                    alt={review.title || 'Review'}
                    className="w-full object-cover"
                    loading="lazy"
                  />
                )}

                {/* Text Content */}
                {(review.title || review.content) && (
                  <div className="p-4">
                    {review.title && (
                      <h3
                        className="font-semibold text-sm mb-1"
                        style={{ fontFamily: "'Cormorant Garamond', serif", color: '#2C1B2E' }}
                      >
                        {review.title}
                      </h3>
                    )}
                    {review.content && (
                      <p
                        className="text-sm leading-relaxed"
                        style={{ fontFamily: "'DM Sans', sans-serif", color: '#75607C' }}
                      >
                        {review.content}
                      </p>
                    )}
                  </div>
                )}

                {/* Badge */}
                <div className="px-4 pb-3">
                  <span
                    className="text-[10px] font-semibold uppercase tracking-wider px-2 py-0.5 rounded-full"
                    style={{
                      background: review.review_type === 'testimonial' ? '#FFF0F5' : '#F0FAF5',
                      color: review.review_type === 'testimonial' ? '#E87898' : '#349E72',
                    }}
                  >
                    {review.review_type === 'testimonial' ? 'Testimonial' : 'Result'}
                  </span>
                </div>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
};

export default ReviewsPage;
```

- [ ] **Step 2: Commit**

```bash
git add src/components/ReviewsPage.tsx
git commit -m "feat(reviews): add public ReviewsPage with masonry layout"
```

---

### Task 7: Add /reviews Route to App.tsx

**Files:**
- Modify: `src/App.tsx`

- [ ] **Step 1: Add lazy import for ReviewsPage**

Add after line 19 (`const ProtocolGuide = lazy(...)`):

```typescript
const ReviewsPage = lazy(() => import('./components/ReviewsPage'));
```

- [ ] **Step 2: Add route**

Add inside the `<Routes>` block, after the `/protocols` route (after line 114):

```tsx
                    <Route path="/reviews" element={<ReviewsPage />} />
```

- [ ] **Step 3: Commit**

```bash
git add src/App.tsx
git commit -m "feat(reviews): add /reviews route"
```

---

### Task 8: Add Reviews Section to ProductDetailModal

**Files:**
- Modify: `src/components/ProductDetailModal.tsx`

- [ ] **Step 1: Add imports**

Add to the existing imports at the top of the file:

```typescript
import { useNavigate } from 'react-router-dom';
```

Add a new import for the hook:

```typescript
import { useReviews } from '../hooks/useReviews';
```

Add `MessageSquare` to the lucide-react import if not already present.

- [ ] **Step 2: Add state and data fetching inside the component**

Inside the component function, add after the existing state declarations:

```typescript
  const { getReviewsForProduct } = useReviews();
  const navigate = useNavigate();
  const [productReviews, setProductReviews] = useState<any[]>([]);

  useEffect(() => {
    if (product.id) {
      getReviewsForProduct(product.id).then(setProductReviews).catch(console.error);
    }
  }, [product.id]);
```

- [ ] **Step 3: Add reviews section in the JSX**

Insert after the Technical Details closing `</div>` (after line 559) and before the bottom safe area spacer (line 561 `<div className="h-4" />`):

```tsx
              {/* ── Customer Reviews ─────────────────────── */}
              {productReviews.length > 0 && (
                <div className="mt-4">
                  <p
                    className="font-sans text-[11px] font-semibold uppercase tracking-widest mb-3 px-1"
                    style={{ color: '#9A8AA0' }}
                  >
                    Customer Reviews
                  </p>
                  <div className="space-y-2">
                    {productReviews.slice(0, 3).map((review) => (
                      <div
                        key={review.id}
                        className="flex items-center gap-3 rounded-xl p-3"
                        style={{
                          background: '#FAF7FB',
                          border: '1px solid rgba(44,27,46,0.07)',
                        }}
                      >
                        {review.image_url && (
                          <img
                            src={review.image_url}
                            alt={review.title || 'Review'}
                            className="w-12 h-12 rounded-lg object-cover flex-shrink-0"
                          />
                        )}
                        <div className="flex-1 min-w-0">
                          {review.title && (
                            <p
                              className="text-xs font-semibold truncate"
                              style={{ color: '#2C1B2E' }}
                            >
                              {review.title}
                            </p>
                          )}
                          {review.content && (
                            <p
                              className="text-xs line-clamp-2"
                              style={{ color: '#75607C' }}
                            >
                              {review.content}
                            </p>
                          )}
                        </div>
                      </div>
                    ))}
                  </div>
                  <button
                    onClick={() => {
                      onClose();
                      navigate('/reviews');
                    }}
                    className="w-full mt-3 py-2.5 rounded-xl text-xs font-semibold transition-colors"
                    style={{
                      background: '#FFF0F5',
                      color: '#E87898',
                    }}
                  >
                    See All Reviews
                  </button>
                </div>
              )}
```

- [ ] **Step 4: Commit**

```bash
git add src/components/ProductDetailModal.tsx
git commit -m "feat(reviews): show linked reviews in product bottom sheet"
```

---

### Task 9: Verify and Test End-to-End

- [ ] **Step 1: Start dev server**

```bash
npm run dev
```

Expected: App starts without errors.

- [ ] **Step 2: Verify admin panel**

1. Navigate to `/admin`
2. Confirm "Reviews" button appears in quick actions
3. Click it — ReviewsManager should render
4. Add a review with text + image, link to a product
5. Confirm it appears in the reviews list

- [ ] **Step 3: Verify public reviews page**

1. Navigate to `/reviews`
2. Confirm the review you added appears in masonry grid
3. Check responsive layout (1/2/3 columns)

- [ ] **Step 4: Verify product bottom sheet**

1. Navigate to `/` and click a product you linked the review to
2. Scroll down in the bottom sheet
3. Confirm "Customer Reviews" section shows with the linked review
4. Confirm "See All Reviews" button navigates to `/reviews`

- [ ] **Step 5: Final commit**

```bash
git add -A
git commit -m "feat(reviews): complete reviews feature implementation"
```

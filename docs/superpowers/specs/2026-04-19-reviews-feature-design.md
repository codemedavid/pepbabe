# Reviews Feature Design

## Overview

Admin-curated review system for Biorich. Admins create reviews (text and/or image), optionally link them to products, and they appear on a public reviews page and within product bottom sheets.

## Data Model

### `reviews` table

| Column      | Type         | Nullable | Default        | Notes                              |
|-------------|--------------|----------|----------------|------------------------------------|
| id          | uuid (PK)    | no       | gen_random_uuid() | auto-generated                  |
| title       | text         | yes      | null           | optional short heading             |
| content     | text         | yes      | null           | text review body                   |
| image_url   | text         | yes      | null           | Supabase storage URL               |
| review_type | text         | no       | 'testimonial'  | 'testimonial' or 'result_photo'    |
| featured    | boolean      | no       | false          | highlight on reviews page          |
| created_at  | timestamptz  | no       | now()          | auto                               |

Constraint: at least one of `content` or `image_url` must be non-null (enforced in UI).

### `review_products` join table

| Column     | Type      | Nullable | Notes                        |
|------------|-----------|----------|------------------------------|
| id         | uuid (PK) | no       | gen_random_uuid()            |
| review_id  | uuid (FK) | no       | references reviews(id) ON DELETE CASCADE |
| product_id | uuid (FK) | no       | references products(id) ON DELETE CASCADE |

Unique constraint on `(review_id, product_id)`.

### Storage

Images uploaded to existing `menu-images` bucket (or a new `review-images` bucket). Reuses the existing `useImageUpload` hook.

## Admin Panel — Reviews Manager

New tab in `AdminDashboard.tsx` alongside existing managers.

### Features

- **Create/Edit form:**
  - Title (optional text input)
  - Content (optional textarea)
  - Image upload (reusing `ImageUpload` component)
  - Review type dropdown: "Testimonial" | "Result Photo"
  - Featured toggle (checkbox)
  - Product linker: multi-select dropdown of all products to associate
- **Reviews table:**
  - Columns: image thumbnail, title/content preview, type badge, linked products, featured badge, actions
  - Edit and delete actions
  - Delete removes review and cascading join rows
- **Validation:** must provide at least content or image before saving

## Public Reviews Page (`/reviews`)

### Layout

- Route: `/reviews`
- Masonry-style grid of review cards
- Each card displays:
  - Image (if present) — fills card top
  - Title (if present) — bold heading
  - Content (if present) — text below
  - Type badge (testimonial vs result photo)
- Responsive: 1 column mobile, 2 columns tablet, 3 columns desktop
- Sorted by newest first, featured reviews pinned to top

### Navigation

- Add "Reviews" link to site navigation (Header/MobileNav)

## Product Bottom Sheet Integration

### Location

Bottom of `ProductDetailModal.tsx`, after existing content, before the add-to-cart button area.

### Behavior

- Query `review_products` join table for the current product's ID
- Show up to 3 linked reviews as compact cards (small image thumbnail + text snippet)
- "See all reviews" link navigates to `/reviews`
- Section hidden if no linked reviews exist for the product

## New Files

| File | Purpose |
|------|---------|
| `src/types/review.ts` | TypeScript interfaces for Review and ReviewProduct |
| `src/hooks/useReviews.ts` | Supabase CRUD hook with real-time subscriptions |
| `src/components/ReviewsManager.tsx` | Admin CRUD panel |
| `src/components/ReviewsPage.tsx` | Public reviews page |

## Existing File Changes

| File | Change |
|------|--------|
| `src/components/AdminDashboard.tsx` | Add Reviews Manager tab |
| `src/components/ProductDetailModal.tsx` | Add linked reviews section |
| `src/App.tsx` | Add `/reviews` route |
| `src/components/Header.tsx` or navigation | Add Reviews nav link |

## Styling

Follows existing project theme:
- Mint (#4BB88A) for action/primary elements
- Pink (#F2A0B8) for decorative accents
- Cream (#FFFBFD) backgrounds
- Cormorant Garamond headings, DM Sans body text
- Consistent with existing card/modal patterns

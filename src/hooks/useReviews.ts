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

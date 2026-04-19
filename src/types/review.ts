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

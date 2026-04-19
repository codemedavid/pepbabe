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

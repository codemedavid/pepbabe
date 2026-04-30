import React, { useEffect, useState } from 'react';
import { ArrowRight, Zap, Sparkles, Heart } from 'lucide-react';

interface HeroProps {
  onShopAll: () => void;
}

const Hero: React.FC<HeroProps> = ({ onShopAll }) => {
  const [visible, setVisible] = useState(false);

  useEffect(() => {
    const t = setTimeout(() => setVisible(true), 80);
    return () => clearTimeout(t);
  }, []);

  return (
    <section className="relative overflow-hidden" style={{ background: 'linear-gradient(180deg, #FFF7FB 0%, #FFEAF3 50%, #E3F1FE 100%)' }}>

      {/* ── Holographic decorative blobs ── */}
      {/* Pink — top left */}
      <div
        className="absolute -top-40 -left-40 w-[550px] h-[550px] rounded-full opacity-50 pointer-events-none"
        style={{
          background: 'radial-gradient(circle at 40% 40%, #F9B7D2 0%, transparent 68%)',
          filter: 'blur(60px)',
        }}
      />
      {/* Light blue — bottom right */}
      <div
        className="absolute -bottom-32 -right-32 w-[480px] h-[480px] rounded-full opacity-50 pointer-events-none"
        style={{
          background: 'radial-gradient(circle at 60% 60%, #A5CFF7 0%, transparent 68%)',
          filter: 'blur(55px)',
        }}
      />
      {/* Pink shimmer — top right */}
      <div
        className="absolute top-16 right-[12%] w-[220px] h-[220px] rounded-full opacity-30 pointer-events-none animate-float"
        style={{
          background: 'radial-gradient(circle, #F593BC, transparent 70%)',
          filter: 'blur(32px)',
        }}
      />
      {/* Lavender — mid left */}
      <div
        className="absolute top-1/2 -left-10 w-[200px] h-[200px] rounded-full opacity-25 pointer-events-none"
        style={{
          background: 'radial-gradient(circle, #C7B6E8, transparent 70%)',
          filter: 'blur(40px)',
        }}
      />

      {/* ── Sparkle accents ── */}
      <div className="absolute top-[18%] left-[8%] pointer-events-none animate-float" style={{ animationDelay: '0.5s' }}>
        <Sparkles className="w-6 h-6" style={{ color: '#F593BC', opacity: 0.6 }} />
      </div>
      <div className="absolute top-[28%] right-[18%] pointer-events-none animate-float" style={{ animationDelay: '1.5s' }}>
        <Sparkles className="w-4 h-4" style={{ color: '#82BBF0', opacity: 0.6 }} />
      </div>
      <div className="absolute bottom-[24%] left-[15%] pointer-events-none animate-float" style={{ animationDelay: '2.5s' }}>
        <Heart className="w-5 h-5" style={{ color: '#F5A0BE', opacity: 0.5 }} fill="#F5A0BE" />
      </div>

      {/* ── Main content ── */}
      <div className="relative z-10 container mx-auto px-5 md:px-8 py-24 md:py-32 lg:py-36">
        <div className="max-w-3xl mx-auto text-center flex flex-col items-center">

          {/* Logo medallion */}
          <div
            className={`mb-8 transition-all duration-700 ${visible ? 'opacity-100 translate-y-0 scale-100' : 'opacity-0 translate-y-4 scale-95'}`}
            style={{ transitionDelay: '0ms' }}
          >
            <img
              src="/pepbabe-logo.jpg"
              alt="Pepbabe"
              className="h-32 md:h-40 w-auto object-contain mx-auto rounded-3xl"
              style={{
                boxShadow: '0 12px 48px rgba(245,160,190,0.40), 0 4px 16px rgba(124,182,232,0.30)',
              }}
            />
          </div>

          {/* Eyebrow badge */}
          <div
            className={`mb-6 transition-all duration-700 ${visible ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-4'}`}
            style={{ transitionDelay: '120ms' }}
          >
            <span
              className="inline-flex items-center gap-2 text-xs font-sans font-medium px-5 py-2.5 rounded-full tracking-widest uppercase"
              style={{
                background: 'linear-gradient(90deg, rgba(245,160,190,0.15), rgba(124,182,232,0.15))',
                color: '#8B4423',
                border: '1px solid rgba(245,160,190,0.35)',
              }}
            >
              <Sparkles className="w-3.5 h-3.5" />
              Pepbabe — Peptide Power, Babe Energy
            </span>
          </div>

          {/* Headline */}
          <h1
            className={`font-heading font-light mb-6 transition-all duration-700 ${visible ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-6'}`}
            style={{
              fontSize: 'clamp(3rem, 7.5vw, 5.5rem)',
              lineHeight: 1.05,
              letterSpacing: '-0.02em',
              color: '#5B2828',
              transitionDelay: '200ms',
            }}
          >
            Glow Up with Us,{' '}
            <em
              className="not-italic holo-text"
              style={{ fontStyle: 'italic' }}
            >
              Babe!
            </em>
          </h1>

          {/* Subtitle */}
          <p
            className={`font-sans font-light leading-relaxed mb-10 max-w-xl transition-all duration-700 ${visible ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-6'}`}
            style={{ fontSize: '1.125rem', color: '#7E3434', transitionDelay: '280ms' }}
          >
            We deliver peptides for the modern babe nationwide across the Philippines.
          </p>

          {/* CTAs */}
          <div
            className={`flex flex-col sm:flex-row gap-3 mb-14 w-full sm:w-auto transition-all duration-700 ${visible ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-6'}`}
            style={{ transitionDelay: '360ms' }}
          >
            <button onClick={onShopAll} className="btn-mint px-9 py-4 text-sm">
              Shop Peptides
              <ArrowRight className="w-4 h-4 ml-1" />
            </button>
            <a href="/protocols" className="btn-pink px-9 py-4 text-sm">
              View Protocols
            </a>
          </div>

          {/* Trust pills */}
          <div
            className={`flex flex-wrap justify-center gap-3 transition-all duration-700 ${visible ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-6'}`}
            style={{ transitionDelay: '440ms' }}
          >
            {[
              { icon: Zap,     label: 'Same-Day Dispatch' },
              { icon: Heart,   label: 'PH Nationwide Delivery' },
            ].map(({ icon: Icon, label }) => (
              <div
                key={label}
                className="flex items-center gap-2 text-xs font-sans font-medium px-4 py-2 rounded-full"
                style={{
                  background: 'white',
                  border: '1px solid rgba(245,160,190,0.30)',
                  color: '#7E3434',
                  boxShadow: '0 1px 4px rgba(245,160,190,0.12)',
                }}
              >
                <Icon className="w-3.5 h-3.5 flex-shrink-0" style={{ color: '#E25C95' }} />
                {label}
              </div>
            ))}
          </div>
        </div>
      </div>

    </section>
  );
};

export default Hero;

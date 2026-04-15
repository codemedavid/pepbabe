import React, { useEffect, useState } from 'react';
import { ArrowRight, Shield, Zap, Award, Leaf } from 'lucide-react';

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
    <section className="relative overflow-hidden" style={{ background: '#FFFBFD' }}>

      {/* ── Decorative blobs ── */}
      {/* Soft pink — top left */}
      <div
        className="absolute -top-40 -left-40 w-[550px] h-[550px] rounded-full opacity-40 pointer-events-none"
        style={{
          background: 'radial-gradient(circle at 40% 40%, #F9C4D8 0%, transparent 68%)',
          filter: 'blur(60px)',
        }}
      />
      {/* Mint — bottom right */}
      <div
        className="absolute -bottom-32 -right-32 w-[480px] h-[480px] rounded-full opacity-35 pointer-events-none"
        style={{
          background: 'radial-gradient(circle at 60% 60%, #AAE5CC 0%, transparent 68%)',
          filter: 'blur(55px)',
        }}
      />
      {/* Pink accent — top right */}
      <div
        className="absolute top-16 right-[12%] w-[220px] h-[220px] rounded-full opacity-20 pointer-events-none animate-float"
        style={{
          background: 'radial-gradient(circle, #F5A8C5, transparent 70%)',
          filter: 'blur(32px)',
        }}
      />
      {/* Mint accent — mid left */}
      <div
        className="absolute top-1/2 -left-10 w-[200px] h-[200px] rounded-full opacity-18 pointer-events-none"
        style={{
          background: 'radial-gradient(circle, #7DD8B3, transparent 70%)',
          filter: 'blur(40px)',
        }}
      />

      {/* ── Decorative petal shapes ── */}
      <svg
        className="absolute top-10 right-[6%] w-52 h-52 pointer-events-none"
        style={{ opacity: 0.07 }}
        viewBox="0 0 200 200" fill="none"
      >
        <ellipse cx="100" cy="55"  rx="30" ry="52" fill="#F2A0B8" transform="rotate(0 100 100)" />
        <ellipse cx="100" cy="55"  rx="30" ry="52" fill="#F2A0B8" transform="rotate(60 100 100)" />
        <ellipse cx="100" cy="55"  rx="30" ry="52" fill="#F2A0B8" transform="rotate(120 100 100)" />
        <ellipse cx="100" cy="55"  rx="30" ry="52" fill="#4BB88A" transform="rotate(180 100 100)" />
        <ellipse cx="100" cy="55"  rx="30" ry="52" fill="#4BB88A" transform="rotate(240 100 100)" />
        <ellipse cx="100" cy="55"  rx="30" ry="52" fill="#4BB88A" transform="rotate(300 100 100)" />
        <circle cx="100" cy="100" r="14" fill="#F2A0B8" />
      </svg>

      <svg
        className="absolute bottom-12 left-[5%] w-32 h-32 pointer-events-none"
        style={{ opacity: 0.06 }}
        viewBox="0 0 120 120" fill="none"
      >
        <circle cx="60" cy="60" r="55" stroke="#4BB88A" strokeWidth="1.5" />
        <circle cx="60" cy="60" r="38" stroke="#F2A0B8" strokeWidth="1" />
        <circle cx="60" cy="60" r="20" stroke="#4BB88A" strokeWidth="1" />
        <circle cx="60" cy="60" r="4"  fill="#F2A0B8" />
      </svg>

      {/* ── Main content ── */}
      <div className="relative z-10 container mx-auto px-5 md:px-8 py-24 md:py-32 lg:py-36">
        <div className="max-w-3xl mx-auto text-center flex flex-col items-center">

          {/* Eyebrow badge */}
          <div
            className={`mb-8 transition-all duration-700 ${visible ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-4'}`}
            style={{ transitionDelay: '0ms' }}
          >
            <span
              className="inline-flex items-center gap-2 text-xs font-sans font-medium px-5 py-2.5 rounded-full tracking-widest uppercase"
              style={{ background: 'rgba(75,184,138,0.1)', color: '#349E72', border: '1px solid rgba(75,184,138,0.25)' }}
            >
              <Leaf className="w-3.5 h-3.5" />
              Peptherapy PH — Premium Peptides
            </span>
          </div>

          {/* Headline */}
          <h1
            className={`font-heading font-light mb-6 transition-all duration-700 ${visible ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-6'}`}
            style={{
              fontSize: 'clamp(3rem, 7.5vw, 5.5rem)',
              lineHeight: 1.05,
              letterSpacing: '-0.02em',
              color: '#2C1B2E',
              transitionDelay: '100ms',
            }}
          >
            Your Path to{' '}
            <em
              className="not-italic"
              style={{
                background: 'linear-gradient(135deg, #E87898, #F2A0B8)',
                WebkitBackgroundClip: 'text',
                WebkitTextFillColor: 'transparent',
                backgroundClip: 'text',
                fontStyle: 'italic',
              }}
            >
              Better Health
            </em>
            {' '}&amp;{' '}
            <span style={{ color: '#4BB88A' }}>Vitality</span>
          </h1>

          {/* Subtitle */}
          <p
            className={`font-sans font-light leading-relaxed mb-10 max-w-xl transition-all duration-700 ${visible ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-6'}`}
            style={{ fontSize: '1.125rem', color: '#75607C', transitionDelay: '180ms' }}
          >
            Pharmaceutical-grade peptides, third-party tested and delivered nationwide. Trusted by health professionals across the Philippines.
          </p>

          {/* CTAs */}
          <div
            className={`flex flex-col sm:flex-row gap-3 mb-14 w-full sm:w-auto transition-all duration-700 ${visible ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-6'}`}
            style={{ transitionDelay: '260ms' }}
          >
            <button onClick={onShopAll} className="btn-mint px-9 py-4 text-sm">
              Explore Products
              <ArrowRight className="w-4 h-4 ml-1" />
            </button>
            <a href="/protocols" className="btn-pink px-9 py-4 text-sm">
              View Protocols
            </a>
          </div>

          {/* Trust pills */}
          <div
            className={`flex flex-wrap justify-center gap-3 transition-all duration-700 ${visible ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-6'}`}
            style={{ transitionDelay: '340ms' }}
          >
            {[
              { icon: Shield,  label: '99%+ Purity Guaranteed' },
              { icon: Zap,     label: 'Same-Day Dispatch' },
              { icon: Award,   label: 'Lab Certified' },
              { icon: Leaf,    label: 'PH Nationwide Delivery' },
            ].map(({ icon: Icon, label }) => (
              <div
                key={label}
                className="flex items-center gap-2 text-xs font-sans font-medium px-4 py-2 rounded-full"
                style={{ background: 'white', border: '1px solid rgba(44,27,46,0.08)', color: '#5A4760', boxShadow: '0 1px 4px rgba(44,27,46,0.05)' }}
              >
                <Icon className="w-3.5 h-3.5 flex-shrink-0" style={{ color: '#4BB88A' }} />
                {label}
              </div>
            ))}
          </div>
        </div>
      </div>

      {/* ── Stats bar ── */}
      <div
        className={`relative z-10 border-t transition-all duration-700 ${visible ? 'opacity-100' : 'opacity-0'}`}
        style={{ borderColor: 'rgba(242,160,184,0.25)', background: 'white', transitionDelay: '400ms' }}
      >
        <div className="container mx-auto px-5 md:px-8 py-7">
          <div className="grid grid-cols-2 md:grid-cols-4 gap-6 text-center">
            {[
              { value: '99%+',   label: 'Purity Rate',     color: '#E87898' },
              { value: '500+',   label: 'Happy Clients',   color: '#4BB88A' },
              { value: '20+',    label: 'Peptide SKUs',    color: '#E87898' },
              { value: '24hr',   label: 'Average Dispatch',color: '#4BB88A' },
            ].map(({ value, label, color }) => (
              <div key={label} className="flex flex-col items-center gap-1">
                <span
                  className="font-heading font-semibold"
                  style={{ fontSize: '1.85rem', color, letterSpacing: '-0.02em' }}
                >
                  {value}
                </span>
                <span className="font-sans text-xs font-medium" style={{ color: '#9A8AA0', letterSpacing: '0.04em' }}>
                  {label}
                </span>
              </div>
            ))}
          </div>
        </div>
      </div>
    </section>
  );
};

export default Hero;

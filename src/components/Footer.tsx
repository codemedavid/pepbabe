import React from 'react';
import { FlaskConical, Truck, HelpCircle, FileText, BookOpen, Leaf, Mail } from 'lucide-react';

const Footer: React.FC = () => {
  return (
    <footer style={{ background: '#2C1B2E' }}>

      {/* ── Pink-to-mint decorative top edge ── */}
      <div
        className="h-1 w-full"
        style={{ background: 'linear-gradient(90deg, #F9C4D8, #F2A0B8, #AAE5CC, #7DD8B3, #AAE5CC, #F2A0B8, #F9C4D8)' }}
      />

      {/* ── Main content ── */}
      <div className="container mx-auto px-5 md:px-8 pt-16 pb-10">
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-10 lg:gap-8">

          {/* Brand column */}
          <div className="lg:col-span-1">
            <img
              src="/logo.png"
              alt="Peptherapy PH"
              className="h-12 w-auto object-contain mb-5"
              style={{ filter: 'brightness(0) invert(1)' }}
            />
            <p className="font-sans text-sm leading-relaxed mb-5" style={{ color: 'rgba(255,255,255,0.45)' }}>
              Peptherapy PH — your trusted source for pharmaceutical-grade peptides in the Philippines. Health & vitality, backed by science.
            </p>
            <div className="flex items-center gap-2 text-xs font-sans" style={{ color: 'rgba(255,255,255,0.35)' }}>
              <Leaf className="w-3.5 h-3.5" style={{ color: '#7DD8B3' }} />
              99%+ Purity on every product
            </div>
          </div>

          {/* Products */}
          <div>
            <h4 className="font-sans font-semibold text-sm mb-5 tracking-wide" style={{ color: 'rgba(255,255,255,0.9)' }}>
              Products
            </h4>
            <ul className="space-y-3">
              {['Weight Management', 'Performance Peptides', 'Recovery & Repair', 'Anti-Aging', 'Cognitive Support'].map(item => (
                <li key={item}>
                  <a
                    href="#"
                    className="font-sans text-sm transition-colors"
                    style={{ color: 'rgba(255,255,255,0.4)' }}
                    onMouseEnter={e => { (e.currentTarget as HTMLAnchorElement).style.color = '#AAE5CC'; }}
                    onMouseLeave={e => { (e.currentTarget as HTMLAnchorElement).style.color = 'rgba(255,255,255,0.4)'; }}
                  >
                    {item}
                  </a>
                </li>
              ))}
            </ul>
          </div>

          {/* Resources */}
          <div>
            <h4 className="font-sans font-semibold text-sm mb-5 tracking-wide" style={{ color: 'rgba(255,255,255,0.9)' }}>
              Resources
            </h4>
            <ul className="space-y-3">
              {[
                { icon: BookOpen,    label: 'Protocols',      href: '/protocols' },
                { icon: FileText,    label: 'COA Documents',  href: '/coa' },
                { icon: HelpCircle,  label: 'FAQ',            href: '/faq' },
                { icon: Truck,       label: 'Track Order',    href: '/track-order' },
                { icon: FlaskConical,label: 'Product Catalog',href: '/' },
              ].map(({ icon: Icon, label, href }) => (
                <li key={label}>
                  <a
                    href={href}
                    className="flex items-center gap-2 font-sans text-sm transition-colors group"
                    style={{ color: 'rgba(255,255,255,0.4)' }}
                    onMouseEnter={e => { (e.currentTarget as HTMLAnchorElement).style.color = '#F9C4D8'; }}
                    onMouseLeave={e => { (e.currentTarget as HTMLAnchorElement).style.color = 'rgba(255,255,255,0.4)'; }}
                  >
                    <Icon className="w-3.5 h-3.5 flex-shrink-0" style={{ color: 'rgba(255,255,255,0.2)' }} />
                    {label}
                  </a>
                </li>
              ))}
            </ul>
          </div>

          {/* Newsletter */}
          <div>
            <h4 className="font-sans font-semibold text-sm mb-5 tracking-wide" style={{ color: 'rgba(255,255,255,0.9)' }}>
              Stay Updated
            </h4>
            <p className="font-sans text-sm leading-relaxed mb-4" style={{ color: 'rgba(255,255,255,0.4)' }}>
              New peptides, protocols, and exclusive offers — delivered to your inbox.
            </p>
            <div className="flex gap-2 mb-2">
              <input
                type="email"
                placeholder="your@email.com"
                className="flex-1 min-w-0 text-sm font-sans px-3.5 py-2.5 rounded-xl focus:outline-none transition-colors"
                style={{
                  background: 'rgba(255,255,255,0.07)',
                  border: '1px solid rgba(255,255,255,0.12)',
                  color: 'white',
                }}
                onFocus={e => { (e.currentTarget as HTMLInputElement).style.borderColor = 'rgba(170,229,204,0.4)'; }}
                onBlur={e => { (e.currentTarget as HTMLInputElement).style.borderColor = 'rgba(255,255,255,0.12)'; }}
              />
              <button
                className="w-10 h-10 flex-shrink-0 flex items-center justify-center rounded-xl text-white transition-colors"
                style={{ background: '#4BB88A' }}
                onMouseEnter={e => { (e.currentTarget as HTMLButtonElement).style.background = '#349E72'; }}
                onMouseLeave={e => { (e.currentTarget as HTMLButtonElement).style.background = '#4BB88A'; }}
                aria-label="Subscribe"
              >
                <Mail className="w-4 h-4" />
              </button>
            </div>
            <p className="font-sans text-[11px]" style={{ color: 'rgba(255,255,255,0.22)' }}>
              No spam. Unsubscribe anytime.
            </p>
          </div>
        </div>
      </div>

      {/* ── Bottom bar ── */}
      <div style={{ borderTop: '1px solid rgba(255,255,255,0.06)' }}>
        <div className="container mx-auto px-5 md:px-8 py-5 flex flex-col sm:flex-row items-center justify-between gap-3">
          <p className="font-sans text-xs" style={{ color: 'rgba(255,255,255,0.28)' }}>
            © {new Date().getFullYear()} Peptherapy PH. All rights reserved.
          </p>
          <div className="flex items-center gap-5">
            {['Privacy Policy', 'Terms of Service', 'Shipping Policy'].map(item => (
              <a
                key={item}
                href="#"
                className="font-sans text-xs transition-colors"
                style={{ color: 'rgba(255,255,255,0.28)' }}
                onMouseEnter={e => { (e.currentTarget as HTMLAnchorElement).style.color = 'rgba(255,255,255,0.55)'; }}
                onMouseLeave={e => { (e.currentTarget as HTMLAnchorElement).style.color = 'rgba(255,255,255,0.28)'; }}
              >
                {item}
              </a>
            ))}
          </div>
        </div>
      </div>
    </footer>
  );
};

export default Footer;

import React from 'react';
import { Truck, Bike, Check, X, Clock, Package } from 'lucide-react';

const ShippingSchedule: React.FC = () => {
  return (
    <section
      className="py-16 md:py-20"
      style={{ background: 'linear-gradient(180deg, #FFF7FB 0%, #FFEAF3 100%)' }}
    >
      <div className="container mx-auto px-5 md:px-8">
        {/* Section header */}
        <div className="text-center max-w-2xl mx-auto mb-12">
          <p className="section-label mb-2">Shipping Schedule</p>
          <div className="divider mx-auto mb-4" />
          <h2
            className="font-heading font-light mb-4"
            style={{
              fontSize: 'clamp(1.9rem, 3.5vw, 2.75rem)',
              color: '#5B2828',
              letterSpacing: '-0.02em',
            }}
          >
            PH Nationwide Delivery
          </h2>
          <p
            className="font-sans font-light"
            style={{ fontSize: '1rem', color: '#7E3434' }}
          >
            Kindly plan your orders accordingly.
          </p>
        </div>

        {/* Courier cards */}
        <div className="grid md:grid-cols-2 gap-6 max-w-4xl mx-auto">
          {/* J&T Card */}
          <div
            className="rounded-3xl p-7 md:p-8"
            style={{
              background: 'white',
              border: '1px solid rgba(245,160,190,0.30)',
              boxShadow: '0 4px 16px rgba(245,160,190,0.12)',
            }}
          >
            <div className="flex items-center gap-3 mb-5">
              <div
                className="w-11 h-11 rounded-2xl flex items-center justify-center flex-shrink-0"
                style={{ background: 'linear-gradient(135deg, #FFEAF3, #E3F1FE)' }}
              >
                <Truck className="w-5 h-5" style={{ color: '#E25C95' }} />
              </div>
              <h3
                className="font-heading font-semibold"
                style={{ fontSize: '1.5rem', color: '#5B2828', letterSpacing: '-0.01em' }}
              >
                J&amp;T Express
              </h3>
            </div>

            <ul className="space-y-2.5 mb-5">
              <li className="flex items-start gap-2.5 font-sans text-sm" style={{ color: '#5B2828' }}>
                <Check className="w-4 h-4 mt-0.5 flex-shrink-0" style={{ color: '#3FA980' }} />
                <span>Tuesday, Thursday and Saturday</span>
              </li>
              <li className="flex items-start gap-2.5 font-sans text-sm" style={{ color: '#5B2828' }}>
                <Clock className="w-4 h-4 mt-0.5 flex-shrink-0" style={{ color: '#5294D5' }} />
                <span>Cut-off 12pm</span>
              </li>
              <li className="flex items-start gap-2.5 font-sans text-sm" style={{ color: '#5B2828' }}>
                <Package className="w-4 h-4 mt-0.5 flex-shrink-0" style={{ color: '#E25C95' }} />
                <span>Pick up 4–5pm</span>
              </li>
              <li className="flex items-start gap-2.5 font-sans text-sm" style={{ color: '#7E3434' }}>
                <X className="w-4 h-4 mt-0.5 flex-shrink-0" style={{ color: '#C45252' }} />
                <span>No pick up on Sundays</span>
              </li>
            </ul>

            <p
              className="font-sans text-xs italic mb-4"
              style={{ color: '#7E3434' }}
            >
              Our small box fits perfectly in J&amp;T medium pouch.
            </p>

            <div
              className="rounded-2xl p-4"
              style={{ background: '#FFF7FB', border: '1px solid rgba(245,160,190,0.20)' }}
            >
              <div className="grid grid-cols-3 gap-2 text-center">
                {[
                  { region: 'Luzon', price: '₱120' },
                  { region: 'Visayas', price: '₱150' },
                  { region: 'Mindanao', price: '₱200' },
                ].map(({ region, price }) => (
                  <div key={region} className="flex flex-col gap-0.5">
                    <span
                      className="font-sans text-[11px] uppercase font-medium tracking-wider"
                      style={{ color: '#8B3A3A' }}
                    >
                      {region}
                    </span>
                    <span
                      className="font-heading font-semibold"
                      style={{ fontSize: '1.05rem', color: '#E25C95' }}
                    >
                      {price}
                    </span>
                  </div>
                ))}
              </div>
            </div>
          </div>

          {/* Lalamove Card */}
          <div
            className="rounded-3xl p-7 md:p-8"
            style={{
              background: 'white',
              border: '1px solid rgba(124,182,232,0.30)',
              boxShadow: '0 4px 16px rgba(124,182,232,0.12)',
            }}
          >
            <div className="flex items-center gap-3 mb-5">
              <div
                className="w-11 h-11 rounded-2xl flex items-center justify-center flex-shrink-0"
                style={{ background: 'linear-gradient(135deg, #E3F1FE, #FFEAF3)' }}
              >
                <Bike className="w-5 h-5" style={{ color: '#5294D5' }} />
              </div>
              <h3
                className="font-heading font-semibold"
                style={{ fontSize: '1.5rem', color: '#5B2828', letterSpacing: '-0.01em' }}
              >
                Lalamove
              </h3>
            </div>

            <ul className="space-y-2.5 mb-5">
              <li className="flex items-start gap-2.5 font-sans text-sm" style={{ color: '#5B2828' }}>
                <Check className="w-4 h-4 mt-0.5 flex-shrink-0" style={{ color: '#3FA980' }} />
                <span>Monday to Friday</span>
              </li>
              <li className="flex items-start gap-2.5 font-sans text-sm" style={{ color: '#5B2828' }}>
                <Check className="w-4 h-4 mt-0.5 flex-shrink-0" style={{ color: '#3FA980' }} />
                <span>We will send you a form to fill out</span>
              </li>
              <li className="flex items-start gap-2.5 font-sans text-sm" style={{ color: '#5B2828' }}>
                <Clock className="w-4 h-4 mt-0.5 flex-shrink-0" style={{ color: '#5294D5' }} />
                <span>Starts at 3pm onwards</span>
              </li>
              <li className="flex items-start gap-2.5 font-sans text-sm" style={{ color: '#7E3434' }}>
                <X className="w-4 h-4 mt-0.5 flex-shrink-0" style={{ color: '#C45252' }} />
                <span>No deliveries on Sundays</span>
              </li>
            </ul>

            <div
              className="rounded-2xl p-4"
              style={{ background: '#F4F9FE', border: '1px solid rgba(124,182,232,0.20)' }}
            >
              <p
                className="font-sans text-sm text-center"
                style={{ color: '#5B2828' }}
              >
                Same-day delivery within Metro Manila.
                <br />
                <span className="text-xs" style={{ color: '#7E3434' }}>
                  Rates calculated based on distance.
                </span>
              </p>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
};

export default ShippingSchedule;

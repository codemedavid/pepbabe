import React, { useState, useRef } from 'react';
import MenuItemCard from './MenuItemCard';
import Hero from './Hero';
import ProductDetailModal from './ProductDetailModal';
import type { Product, ProductVariation, CartItem } from '../types';
import { Search, SlidersHorizontal, Package, FlaskConical, ShieldCheck, Truck, BadgeCheck, Microscope, ArrowRight } from 'lucide-react';

interface MenuProps {
  menuItems: Product[];
  addToCart: (product: Product, variation?: ProductVariation, quantity?: number) => void;
  cartItems: CartItem[];
  updateQuantity: (index: number, quantity: number) => void;
}

const WHY_ITEMS = [
  {
    icon: FlaskConical,
    title: 'Pharmaceutical Grade',
    desc: 'Every peptide is synthesized to pharmaceutical-grade standards with verified purity certificates from accredited labs.',
    iconColor: '#4BB88A',
    iconBg: '#F0FAF5',
    accent: '#4BB88A',
  },
  {
    icon: ShieldCheck,
    title: 'Third-Party Tested',
    desc: 'Independent COA testing on every batch ensures what is on the label is exactly what you receive — nothing more, nothing less.',
    iconColor: '#E87898',
    iconBg: '#FFF0F5',
    accent: '#E87898',
  },
  {
    icon: Truck,
    title: 'Nationwide Delivery',
    desc: 'Fast, discreet delivery across all regions of the Philippines with real-time order tracking from dispatch to your door.',
    iconColor: '#4BB88A',
    iconBg: '#F0FAF5',
    accent: '#4BB88A',
  },
  {
    icon: BadgeCheck,
    title: 'Expert Protocols',
    desc: 'Access evidence-based dosing guides, reconstitution protocols, and storage best practices developed with medical professionals.',
    iconColor: '#E87898',
    iconBg: '#FFF0F5',
    accent: '#E87898',
  },
  {
    icon: Microscope,
    title: 'Research-Backed',
    desc: 'Our catalog features only peptides with established research profiles, ensuring your wellness journey is built on science.',
    iconColor: '#4BB88A',
    iconBg: '#F0FAF5',
    accent: '#4BB88A',
  },
  {
    icon: Package,
    title: 'Secure Packaging',
    desc: 'Temperature-controlled packaging and cold-chain logistics protect peptide integrity from our facility to your hands.',
    iconColor: '#E87898',
    iconBg: '#FFF0F5',
    accent: '#E87898',
  },
];

const Menu: React.FC<MenuProps> = ({ menuItems, addToCart, cartItems }) => {
  const [searchQuery, setSearchQuery]   = useState('');
  const [sortBy, setSortBy]             = useState<'name' | 'price' | 'purity'>('name');
  const [selectedProduct, setSelectedProduct] = useState<Product | null>(null);
  const productsRef = useRef<HTMLDivElement | null>(null);

  const filteredProducts = menuItems.filter(product =>
    product.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
    product.description.toLowerCase().includes(searchQuery.toLowerCase())
  );

  const sortedProducts = [...filteredProducts].sort((a, b) => {
    if (a.name === 'Tirzepatide') return -1;
    if (b.name === 'Tirzepatide') return 1;
    if (a.featured && !b.featured) return -1;
    if (!a.featured && b.featured) return 1;
    switch (sortBy) {
      case 'name':  return a.name.localeCompare(b.name);
      case 'price': return a.base_price - b.base_price;
      case 'purity':return b.purity_percentage - a.purity_percentage;
      default:      return 0;
    }
  });

  const getCartQuantity = (productId: string, variationId?: string) =>
    cartItems
      .filter(item =>
        item.product.id === productId &&
        (variationId ? item.variation?.id === variationId : !item.variation)
      )
      .reduce((sum, item) => sum + item.quantity, 0);

  return (
    <>
      {selectedProduct && (
        <ProductDetailModal
          product={selectedProduct}
          onClose={() => setSelectedProduct(null)}
          onAddToCart={(product, variation, quantity) => addToCart(product, variation, quantity)}
        />
      )}

      <div className="min-h-screen" style={{ background: '#FFFBFD' }}>

        {/* ── Hero ── */}
        <Hero onShopAll={() => productsRef.current?.scrollIntoView({ behavior: 'smooth', block: 'start' })} />

  

        {/* ── Products Section ── */}
        <section
          className="py-20 md:py-24"
          ref={productsRef}
          style={{ background: '#FFF8FB' }}
        >
          <div className="container mx-auto px-5 md:px-8">

            {/* Section header */}
            <div className="flex flex-col md:flex-row md:items-end justify-between gap-6 mb-12">
              <div>
                <p className="section-label mb-2">Catalog</p>
                <div className="divider mb-4" style={{ margin: '0 0 1rem 0' }} />
                <h2
                  className="font-heading font-light"
                  style={{ fontSize: 'clamp(1.9rem, 3.5vw, 2.75rem)', color: '#2C1B2E' }}
                >
                  Our Peptide Collection
                </h2>
              </div>

              {/* Search + Sort */}
              <div className="flex flex-col sm:flex-row gap-3 w-full md:w-auto md:max-w-[400px]">
                <div className="relative flex-1">
                  <Search className="absolute left-3.5 top-1/2 -translate-y-1/2 w-4 h-4" style={{ color: '#BFB3C3' }} />
                  <input
                    type="text"
                    placeholder="Search peptides..."
                    value={searchQuery}
                    onChange={e => setSearchQuery(e.target.value)}
                    className="input-field pl-10 h-11 text-sm"
                  />
                </div>
                <div
                  className="flex items-center gap-2 bg-white px-4 h-11 min-w-[156px] rounded-xl"
                  style={{ border: '1px solid rgba(44,27,46,0.09)' }}
                >
                  <SlidersHorizontal className="w-3.5 h-3.5 flex-shrink-0" style={{ color: '#BFB3C3' }} />
                  <select
                    value={sortBy}
                    onChange={e => setSortBy(e.target.value as 'name' | 'price' | 'purity')}
                    className="flex-1 bg-transparent text-sm font-sans font-medium focus:outline-none"
                    style={{ color: '#5A4760' }}
                  >
                    <option value="name">Sort: Name</option>
                    <option value="price">Sort: Price</option>
                    <option value="purity">Sort: Purity</option>
                  </select>
                </div>
              </div>
            </div>

            {/* Results count */}
            <div className="mb-7 flex items-center gap-2 flex-wrap">
              <span className="font-sans text-xs font-medium uppercase tracking-wider" style={{ color: '#BFB3C3' }}>
                {sortedProducts.length} {sortedProducts.length === 1 ? 'product' : 'products'}
              </span>
              {searchQuery && (
                <>
                  <span style={{ color: '#DDD5E0' }}>·</span>
                  <span className="font-sans text-xs" style={{ color: '#75607C' }}>
                    Results for <strong style={{ color: '#2C1B2E' }}>"{searchQuery}"</strong>
                  </span>
                  <button
                    onClick={() => setSearchQuery('')}
                    className="font-sans text-xs font-medium hover:underline"
                    style={{ color: '#4BB88A' }}
                  >
                    Clear
                  </button>
                </>
              )}
            </div>

            {/* Grid */}
            {sortedProducts.length === 0 ? (
              <div className="text-center py-24">
                <div className="bg-white rounded-2xl p-14 max-w-sm mx-auto"
                  style={{ border: '1px solid rgba(44,27,46,0.07)' }}>
                  <div className="w-16 h-16 rounded-2xl flex items-center justify-center mx-auto mb-5"
                    style={{ background: '#FFF0F5' }}>
                    <Package className="w-8 h-8" style={{ color: '#F9C4D8' }} />
                  </div>
                  <h3 className="font-heading font-semibold text-lg mb-2" style={{ color: '#2C1B2E' }}>No products found</h3>
                  <p className="font-sans text-sm mb-6" style={{ color: '#75607C' }}>
                    {searchQuery ? `No results for "${searchQuery}".` : 'No products available right now.'}
                  </p>
                  {searchQuery && (
                    <button onClick={() => setSearchQuery('')} className="btn-mint text-sm py-2.5 px-6">
                      Clear Search
                    </button>
                  )}
                </div>
              </div>
            ) : (
              <div className="grid grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4 md:gap-5">
                {sortedProducts.map(product => (
                  <MenuItemCard
                    key={product.id}
                    product={product}
                    cartQuantity={getCartQuantity(product.id)}
                    onProductClick={setSelectedProduct}
                    onAddToCart={addToCart}
                  />
                ))}
              </div>
            )}
          </div>
        </section>

        {/* ── CTA Banner — soft luxury gradient ── */}
        <section className="py-20 md:py-24 relative overflow-hidden">
          {/* Gradient background — pink to mint */}
          <div
            className="absolute inset-0"
            style={{ background: 'linear-gradient(135deg, #FFF0F5 0%, #FDDAEA 35%, #D5F2E5 75%, #F0FAF5 100%)' }}
          />

          {/* Decorative blobs */}
          <div className="absolute -top-20 -left-20 w-80 h-80 rounded-full pointer-events-none"
            style={{ background: 'radial-gradient(circle, #F9C4D8, transparent 65%)', opacity: 0.5, filter: 'blur(40px)' }} />
          <div className="absolute -bottom-20 -right-20 w-80 h-80 rounded-full pointer-events-none"
            style={{ background: 'radial-gradient(circle, #AAE5CC, transparent 65%)', opacity: 0.45, filter: 'blur(40px)' }} />

          <div className="relative z-10 container mx-auto px-5 md:px-8 text-center max-w-2xl">
            <p className="section-label mb-4">Get Started</p>
            <div className="divider mb-6" />
            <h2
              className="font-heading font-light mb-5"
              style={{ fontSize: 'clamp(1.9rem, 4vw, 3rem)', color: '#2C1B2E' }}
            >
              Ready to start your<br />
              <em className="italic" style={{ color: '#E87898' }}>peptide journey?</em>
            </h2>
            <p className="font-sans text-sm leading-relaxed mb-9" style={{ color: '#75607C' }}>
              Browse our full catalog of pharmaceutical-grade peptides, read dosing protocols, and order with confidence — shipped fast, anywhere in the Philippines.
            </p>
            <div className="flex flex-col sm:flex-row gap-3 justify-center">
              <button
                onClick={() => productsRef.current?.scrollIntoView({ behavior: 'smooth', block: 'start' })}
                className="btn-mint px-9 py-4"
              >
                Shop All Products
                <ArrowRight className="w-4 h-4" />
              </button>
              <a href="/protocols" className="btn-outline px-9 py-4">
                View Protocols
              </a>
            </div>
          </div>
        </section>

      </div>
    </>
  );
};

export default Menu;

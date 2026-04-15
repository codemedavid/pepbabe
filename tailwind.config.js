/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        // ── Peptherapy PH — Simple Luxury ──
        'theme-bg':   '#FFFBFD',
        'theme-text': '#2C1B2E',

        // Soft Pink (blush — decorative, warmth)
        'pink': {
          DEFAULT: '#F2A0B8',
          50:  '#FFF8FB',
          100: '#FFEEF5',
          200: '#FDDAEA',
          300: '#F9C4D8',
          400: '#F5A8C5',
          500: '#F2A0B8',
          600: '#E87898',
          700: '#D45070',
          800: '#B03050',
          900: '#7A1530',
        },

        // Mint Green (action, freshness, health)
        'mint': {
          DEFAULT: '#4BB88A',
          50:  '#F0FAF5',
          100: '#D5F2E5',
          200: '#AAE5CC',
          300: '#7DD8B3',
          400: '#5CC99C',
          500: '#4BB88A',
          600: '#349E72',
          700: '#26805C',
          800: '#1A6145',
          900: '#0F3F2C',
        },

        // Neutral — warm plum-tinted charcoal
        'charcoal': {
          DEFAULT: '#2C1B2E',
          50:  '#FAF7FB',
          100: '#F0ECF2',
          200: '#DDD5E0',
          300: '#BFB3C3',
          400: '#9A8AA0',
          500: '#75607C',
          600: '#5A4760',
          700: '#3F2E45',
          800: '#321D35',
          900: '#2C1B2E',
        },

        // Utility
        'cream':       '#FFFBFD',
        'warm-white':  '#FFF6F9',
        'surface':     '#FFF0F5',
        'surface-mint':'#F0FAF5',
        'gold':        '#C9A84C',
      },

      fontFamily: {
        sans:    ['"DM Sans"', 'sans-serif'],
        heading: ['"Cormorant Garamond"', 'Georgia', 'serif'],
        serif:   ['"Cormorant Garamond"', 'Georgia', 'serif'],
        display: ['"Cormorant Garamond"', 'Georgia', 'serif'],
      },

      fontSize: {
        'display-xl': ['clamp(3rem, 7vw, 5.5rem)', { lineHeight: '1.05', letterSpacing: '-0.02em' }],
        'display-lg': ['clamp(2.2rem, 5vw, 3.8rem)', { lineHeight: '1.08', letterSpacing: '-0.015em' }],
        'display-md': ['clamp(1.8rem, 3.5vw, 2.8rem)', { lineHeight: '1.12', letterSpacing: '-0.01em' }],
      },

      boxShadow: {
        'xs':      '0 1px 2px rgba(44,27,46,0.05)',
        'sm':      '0 2px 6px rgba(44,27,46,0.07)',
        'DEFAULT': '0 2px 12px rgba(44,27,46,0.08)',
        'md':      '0 4px 20px rgba(44,27,46,0.09)',
        'lg':      '0 8px 36px rgba(44,27,46,0.10)',
        'pink':    '0 6px 24px rgba(242,160,184,0.28)',
        'mint':    '0 6px 24px rgba(75,184,138,0.28)',
        'card':    '0 0 0 1px rgba(44,27,46,0.06), 0 4px 18px rgba(44,27,46,0.07)',
      },

      borderRadius: {
        'none':  '0',
        'sm':    '0.375rem',
        DEFAULT: '0.625rem',
        'md':    '0.875rem',
        'lg':    '1.125rem',
        'xl':    '1.5rem',
        '2xl':   '2rem',
        '3xl':   '2.75rem',
        'full':  '9999px',
      },

      animation: {
        'fadeIn':    'fadeIn 0.8s ease-out',
        'slideUp':   'slideUp 0.7s ease-out',
        'float':     'float 8s ease-in-out infinite',
        'pulse-slow':'pulse 5s cubic-bezier(0.4,0,0.6,1) infinite',
      },

      keyframes: {
        fadeIn: {
          '0%':   { opacity: '0', transform: 'translateY(16px)' },
          '100%': { opacity: '1', transform: 'translateY(0)' },
        },
        slideUp: {
          '0%':   { opacity: '0', transform: 'translateY(28px)' },
          '100%': { opacity: '1', transform: 'translateY(0)' },
        },
        float: {
          '0%,100%': { transform: 'translateY(0)' },
          '50%':     { transform: 'translateY(-14px)' },
        },
      },
    },
  },
  plugins: [],
}

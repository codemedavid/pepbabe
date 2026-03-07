/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        // The Babe Studio - Luxury Biotech Theme
        'theme-bg': '#FFFFFF',           // Pure White
        'theme-text': '#1E1E1E',         // Luxury Dark text

        // Primary Palette - Rose Gold
        'brand': {
          DEFAULT: '#CFA07A', // Rose Gold
          50: '#FDF9F7',
          100: '#F9F1EB',
          200: '#E7C6B1',     // Soft Rose Gold
          300: '#DFB49A',
          400: '#CFA07A',     // Primary Rose Gold
          500: '#BB855B',
          600: '#A66B41',
          700: '#8C5A44',     // Deep Copper
          800: '#734A38',
          900: '#5C3C2E',
        },

        // Secondary & Neutral
        'charcoal': {
          DEFAULT: '#1E1E1E',
          50: '#F7F7F7',      // Soft Gray
          100: '#EEEEEE',
          200: '#D9D9D9',
          300: '#B0B0B0',
          400: '#858585',
          500: '#595959',
          600: '#4D4D4D',
          700: '#3D3D3D',
          800: '#2E2E2E',
          900: '#1E1E1E',     // Luxury Dark
        },

        // Backgrounds & Accents
        'cream': '#FFFFFF',
        'blush-light': '#F4E3DA', // Light Rose Accent
        'warm-white': '#FDFDFD',
      },
      fontFamily: {
        sans: ['Inter', 'sans-serif'],
        heading: ['Playfair Display', 'serif'],
        serif: ['Playfair Display', 'serif'],
      },
      boxShadow: {
        'sm': '0 1px 2px 0 rgba(0, 0, 0, 0.03)',
        'DEFAULT': '0 1px 3px 0 rgba(0, 0, 0, 0.05), 0 1px 2px 0 rgba(0, 0, 0, 0.03)',
        'md': '0 4px 6px -1px rgba(0, 0, 0, 0.05), 0 2px 4px -1px rgba(0, 0, 0, 0.03)',
        'lg': '0 10px 15px -3px rgba(0, 0, 0, 0.05), 0 4px 6px -2px rgba(0, 0, 0, 0.02)',
        // Soft white card shadow
        'soft': '0 4px 20px rgba(0, 0, 0, 0.04), 0 2px 8px rgba(0, 0, 0, 0.02)',
        'luxury': '0 8px 30px rgba(0, 0, 0, 0.08), 0 4px 10px rgba(0, 0, 0, 0.04)',
      },
      borderRadius: {
        'none': '0',
        'sm': '0.25rem',
        'DEFAULT': '0.5rem',
        'md': '0.75rem',
        'lg': '1rem',
        'xl': '1.25rem',
        '2xl': '1.5rem',
        'full': '9999px',
      },
      animation: {
        'fadeIn': 'fadeIn 0.6s ease-out',
        'slideUp': 'slideUp 0.5s ease-out',
        'float': 'float 6s ease-in-out infinite',
      },
      keyframes: {
        fadeIn: {
          '0%': { opacity: '0', transform: 'translateY(10px)' },
          '100%': { opacity: '1', transform: 'translateY(0)' },
        },
        slideUp: {
          '0%': { opacity: '0', transform: 'translateY(20px)' },
          '100%': { opacity: '1', transform: 'translateY(0)' },
        },
        float: {
          '0%, 100%': { transform: 'translateY(0px)' },
          '50%': { transform: 'translateY(-10px)' },
        },
      },
    },
  },
  plugins: [],
}

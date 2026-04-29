-- ============================================================================
-- Pepbabe — Insert/Update product prices (PHP ₱)
-- Idempotent: inserts if missing, updates price if already present.
-- Run in Supabase SQL Editor.
-- ============================================================================

-- 1) Make sure required categories exist
INSERT INTO public.categories (name, icon, sort_order, active)
SELECT v.name, v.icon, v.sort_order, true
FROM (VALUES
  ('Peptides',            'FlaskConical', 1),
  ('Weight Management',   'Scale',        2),
  ('Beauty & Anti-Aging', 'Sparkles',     3),
  ('Wellness & Vitality', 'Heart',        4),
  ('Fat Dissolvers',      'Droplet',      9)
) AS v(name, icon, sort_order)
WHERE NOT EXISTS (SELECT 1 FROM public.categories c WHERE c.name = v.name);

-- 2) Upsert products (insert if missing, update price if present)
WITH catalog(name, description, base_price, category_name, featured, stock) AS (
  VALUES
    ('Tirzepatide 15mg (Tr15)',     'Dual GIP/GLP-1 receptor agonist for weight management. 15mg vial.',                    2000.00, 'Weight Management',   true, 50),
    ('Tirzepatide 30mg (Tr30)',     'Dual GIP/GLP-1 receptor agonist for weight management. 30mg vial.',                    2500.00, 'Weight Management',   true, 50),
    ('Tirzepatide 60mg (TR60)',     'High-dose dual GIP/GLP-1 receptor agonist. 60mg vial.',                                4500.00, 'Weight Management',   true, 30),
    ('GHK-Cu 100mg (Ghk100)',       'Copper peptide for skin regeneration and anti-aging. 100mg vial.',                     2000.00, 'Beauty & Anti-Aging', true, 40),
    ('Cagrilintide 10mg (Cagri10)', 'Long-acting amylin analogue for appetite suppression. 10mg vial.',                     3500.00, 'Weight Management',   true, 30),
    ('Glutathione 1500mg (Gtt1500)','High-potency glutathione for skin brightening and antioxidant support. 1500mg vial.', 2100.00, 'Beauty & Anti-Aging', true, 50),
    ('Retatrutide 20mg (Reta20)',   'Triple agonist (GLP-1/GIP/glucagon) for advanced weight management. 20mg vial.',       2500.00, 'Weight Management',   true, 30),
    ('Retatrutide 30mg (Reta30)',   'High-dose triple agonist (GLP-1/GIP/glucagon). 30mg vial.',                            3500.00, 'Weight Management',   true, 25),
    ('NAD+ 100mg (Nad100)',         'Nicotinamide adenine dinucleotide for cellular energy and longevity. 100mg vial.',     2000.00, 'Wellness & Vitality', true, 40),
    ('KPV 10mg (Kpv10)',            'Tripeptide with anti-inflammatory and gut-healing properties. 10mg vial.',             1900.00, 'Peptides',            false,40),
    ('Lemon Bottle',                'Premium advanced lipolysis solution for targeted fat dissolving.',                     1600.00, 'Fat Dissolvers',      true, 40),
    ('Fat Blaster',                 'Targeted fat dissolver for stubborn fat areas. Lipolytic body contouring solution.',   2500.00, 'Fat Dissolvers',      true, 30),
    ('AOD-9604 5mg (AOD 5mg)',      'Modified fragment of human growth hormone targeting fat metabolism. 5mg vial.',        2200.00, 'Weight Management',   true, 30)
)
INSERT INTO public.products
  (name, description, base_price, category, available, featured, stock_quantity, purity_percentage, storage_conditions)
SELECT
  c.name, c.description, c.base_price,
  (SELECT id::text FROM public.categories WHERE name = c.category_name LIMIT 1),
  true, c.featured, c.stock, 99.0, 'Store at -20°C'
FROM catalog c
WHERE NOT EXISTS (SELECT 1 FROM public.products p WHERE p.name = c.name);

-- 3) Force-update prices for any rows that already existed
UPDATE public.products SET base_price = 2000.00, updated_at = NOW() WHERE name = 'Tirzepatide 15mg (Tr15)';
UPDATE public.products SET base_price = 2500.00, updated_at = NOW() WHERE name = 'Tirzepatide 30mg (Tr30)';
UPDATE public.products SET base_price = 4500.00, updated_at = NOW() WHERE name = 'Tirzepatide 60mg (TR60)';
UPDATE public.products SET base_price = 2000.00, updated_at = NOW() WHERE name = 'GHK-Cu 100mg (Ghk100)';
UPDATE public.products SET base_price = 3500.00, updated_at = NOW() WHERE name = 'Cagrilintide 10mg (Cagri10)';
UPDATE public.products SET base_price = 2100.00, updated_at = NOW() WHERE name = 'Glutathione 1500mg (Gtt1500)';
UPDATE public.products SET base_price = 2500.00, updated_at = NOW() WHERE name = 'Retatrutide 20mg (Reta20)';
UPDATE public.products SET base_price = 3500.00, updated_at = NOW() WHERE name = 'Retatrutide 30mg (Reta30)';
UPDATE public.products SET base_price = 2000.00, updated_at = NOW() WHERE name = 'NAD+ 100mg (Nad100)';
UPDATE public.products SET base_price = 1900.00, updated_at = NOW() WHERE name = 'KPV 10mg (Kpv10)';
UPDATE public.products SET base_price = 1600.00, updated_at = NOW() WHERE name = 'Lemon Bottle';
UPDATE public.products SET base_price = 2500.00, updated_at = NOW() WHERE name = 'Fat Blaster';
UPDATE public.products SET base_price = 2200.00, updated_at = NOW() WHERE name = 'AOD-9604 5mg (AOD 5mg)';

-- 4) Verify
SELECT name, base_price, category, available, featured, stock_quantity
FROM public.products
WHERE name IN (
  'Tirzepatide 15mg (Tr15)','Tirzepatide 30mg (Tr30)','Tirzepatide 60mg (TR60)',
  'GHK-Cu 100mg (Ghk100)','Cagrilintide 10mg (Cagri10)','Glutathione 1500mg (Gtt1500)',
  'Retatrutide 20mg (Reta20)','Retatrutide 30mg (Reta30)','NAD+ 100mg (Nad100)',
  'KPV 10mg (Kpv10)','Lemon Bottle','Fat Blaster','AOD-9604 5mg (AOD 5mg)'
)
ORDER BY name;

-- =============================================================================
-- Pricelist Products Migration
-- Source: Peptides Pricelist + Combo Pricelist (April 2026)
-- =============================================================================

-- Clear existing product data before reinserting
DELETE FROM product_variations;
DELETE FROM products;
DELETE FROM categories;

-- =============================================================================
-- CATEGORIES
-- =============================================================================
INSERT INTO categories (id, name, icon, sort_order, active) VALUES
  (gen_random_uuid(), 'Tirzepatide / Retatrutide', 'Flame',     1, true),
  (gen_random_uuid(), 'GHK-CU',                   'Diamond',   2, true),
  (gen_random_uuid(), 'Other Peptides',            'Dna',       3, true),
  (gen_random_uuid(), 'Combos',                    'Package',   4, true);

-- =============================================================================
-- PRODUCTS + VARIATIONS
-- =============================================================================
DO $$
DECLARE
  tirz_cat    TEXT;
  ghk_cat     TEXT;
  other_cat   TEXT;
  combo_cat   TEXT;

  -- product IDs for variation linking
  tirz_id       UUID;
  retat_id      UUID;
  ghkcu_id      UUID;
  cagri_id      UUID;
  gluta_id      UUID;
  lipob12_id    UUID;
  lipofat_id    UUID;
  nad_id        UUID;
  motc_id       UUID;
  ss31_id       UUID;
  ephitalon_id  UUID;
  kpv_id        UUID;
  tesam_id      UUID;
  aod_id        UUID;
  amino_id      UUID;
  hhb_id        UUID;
  selank_id     UUID;
  semax_id      UUID;
BEGIN
  SELECT id::TEXT INTO tirz_cat  FROM categories WHERE name = 'Tirzepatide / Retatrutide';
  SELECT id::TEXT INTO ghk_cat   FROM categories WHERE name = 'GHK-CU';
  SELECT id::TEXT INTO other_cat FROM categories WHERE name = 'Other Peptides';
  SELECT id::TEXT INTO combo_cat FROM categories WHERE name = 'Combos';

  -- -------------------------------------------------------------------------
  -- TIRZEPATIDE / RETATRUTIDE
  -- Complete Set: 6 Insulin Syringes, 1 Recon Syringe, 12 Alcohol Pads, Guide
  -- -------------------------------------------------------------------------

  -- Tirzepatide (parent product — cheapest variant is the base price)
  INSERT INTO products (name, description, category, base_price, purity_percentage, featured, available, stock_quantity, inclusions)
  VALUES (
    'Tirzepatide',
    'Dual GIP/GLP-1 receptor agonist for effective weight management. Each complete set includes mixing supplies and usage guide.',
    tirz_cat, 2500.00, 99.0, true, true, 50,
    ARRAY['6 Insulin Syringes', '1 Recon Syringe', '12 Alcohol Pads', 'Guide']
  ) RETURNING id INTO tirz_id;

  INSERT INTO product_variations (product_id, name, quantity_mg, price, stock_quantity) VALUES
    (tirz_id, 'Tirzepatide 15mg', 15,  2500.00, 50),
    (tirz_id, 'Tirzepatide 30mg', 30,  3500.00, 50);

  -- Retatrutide
  INSERT INTO products (name, description, category, base_price, purity_percentage, featured, available, stock_quantity, inclusions)
  VALUES (
    'Retatrutide',
    'Triple GIP/GLP-1/glucagon receptor agonist for advanced weight and metabolic management. Each complete set includes mixing supplies and usage guide.',
    tirz_cat, 3000.00, 99.0, true, true, 50,
    ARRAY['6 Insulin Syringes', '1 Recon Syringe', '12 Alcohol Pads', 'Guide']
  ) RETURNING id INTO retat_id;

  INSERT INTO product_variations (product_id, name, quantity_mg, price, stock_quantity) VALUES
    (retat_id, 'Retatrutide 10mg', 10, 3000.00, 50),
    (retat_id, 'Retatrutide 20mg', 20, 3500.00, 50),
    (retat_id, 'Retatrutide 30mg', 30, 4000.00, 50);

  -- -------------------------------------------------------------------------
  -- GHK-CU
  -- Complete Set: 25 Insulin Syringes, 1 Recon Syringe, 50 Alcohol Pads, Guide
  -- -------------------------------------------------------------------------
  INSERT INTO products (name, description, category, base_price, purity_percentage, featured, available, stock_quantity, inclusions)
  VALUES (
    'GHK-Cu',
    'Copper peptide complex for skin rejuvenation, collagen synthesis, wound healing, and anti-aging benefits. Each complete set includes mixing supplies and usage guide.',
    ghk_cat, 1800.00, 99.0, true, true, 40,
    ARRAY['25 Insulin Syringes', '1 Recon Syringe', '50 Alcohol Pads', 'Guide']
  ) RETURNING id INTO ghkcu_id;

  INSERT INTO product_variations (product_id, name, quantity_mg, price, stock_quantity) VALUES
    (ghkcu_id, 'GHK-Cu 50mg',  50,  1800.00, 40),
    (ghkcu_id, 'GHK-Cu 100mg', 100, 2200.00, 40);

  -- -------------------------------------------------------------------------
  -- OTHER PEPTIDES
  -- Complete Set: 10 Insulin Syringes, 1 Recon Syringe, 20 Alcohol Pads, Guide
  -- -------------------------------------------------------------------------

  -- Cagrilintide
  INSERT INTO products (name, description, category, base_price, purity_percentage, featured, available, stock_quantity, inclusions)
  VALUES (
    'Cagrilintide',
    'Next-generation amylin analogue for appetite regulation and metabolic support.',
    other_cat, 2200.00, 99.0, false, true, 30,
    ARRAY['10 Insulin Syringes', '1 Recon Syringe', '20 Alcohol Pads', 'Guide']
  ) RETURNING id INTO cagri_id;
  INSERT INTO product_variations (product_id, name, quantity_mg, price, stock_quantity) VALUES
    (cagri_id, 'Cagrilintide 5mg', 5, 2200.00, 30);

  -- Glutathione
  INSERT INTO products (name, description, category, base_price, purity_percentage, featured, available, stock_quantity, inclusions)
  VALUES (
    'Glutathione',
    'Master antioxidant peptide supporting skin brightening, detoxification, and immune function.',
    other_cat, 2100.00, 99.0, false, true, 40,
    ARRAY['10 Insulin Syringes', '1 Recon Syringe', '20 Alcohol Pads', 'Guide']
  ) RETURNING id INTO gluta_id;
  INSERT INTO product_variations (product_id, name, quantity_mg, price, stock_quantity) VALUES
    (gluta_id, 'Glutathione 1500mg', 1500, 2100.00, 40);

  -- Lipo C B12
  INSERT INTO products (name, description, category, base_price, purity_percentage, featured, available, stock_quantity, inclusions)
  VALUES (
    'Lipo C B12',
    'Lipotropic Vitamin C and B12 blend supporting fat metabolism, energy, and overall vitality.',
    other_cat, 1800.00, 99.0, false, true, 40,
    ARRAY['10 Insulin Syringes', '1 Recon Syringe', '20 Alcohol Pads', 'Guide']
  ) RETURNING id INTO lipob12_id;
  INSERT INTO product_variations (product_id, name, quantity_mg, price, stock_quantity) VALUES
    (lipob12_id, 'Lipo C B12 10ml', 10, 1800.00, 40);

  -- Lipo C Fat Blaster
  INSERT INTO products (name, description, category, base_price, purity_percentage, featured, available, stock_quantity, inclusions)
  VALUES (
    'Lipo C Fat Blaster',
    'Advanced lipotropic fat-burning blend for enhanced body composition and metabolic support.',
    other_cat, 2200.00, 99.0, false, true, 40,
    ARRAY['10 Insulin Syringes', '1 Recon Syringe', '20 Alcohol Pads', 'Guide']
  ) RETURNING id INTO lipofat_id;
  INSERT INTO product_variations (product_id, name, quantity_mg, price, stock_quantity) VALUES
    (lipofat_id, 'Lipo C Fat Blaster', 0, 2200.00, 40);

  -- NAD+
  INSERT INTO products (name, description, category, base_price, purity_percentage, featured, available, stock_quantity, inclusions)
  VALUES (
    'NAD+',
    'Nicotinamide adenine dinucleotide for cellular energy production, DNA repair, and longevity support.',
    other_cat, 2500.00, 99.0, true, true, 30,
    ARRAY['10 Insulin Syringes', '1 Recon Syringe', '20 Alcohol Pads', 'Guide']
  ) RETURNING id INTO nad_id;
  INSERT INTO product_variations (product_id, name, quantity_mg, price, stock_quantity) VALUES
    (nad_id, 'NAD+ 500mg', 500, 2500.00, 30);

  -- MOT-C
  INSERT INTO products (name, description, category, base_price, purity_percentage, featured, available, stock_quantity, inclusions)
  VALUES (
    'MOT-C',
    'Mitochondrial-derived peptide for metabolic optimization, fat oxidation, and cellular health.',
    other_cat, 2100.00, 99.0, false, true, 35,
    ARRAY['10 Insulin Syringes', '1 Recon Syringe', '20 Alcohol Pads', 'Guide']
  ) RETURNING id INTO motc_id;
  INSERT INTO product_variations (product_id, name, quantity_mg, price, stock_quantity) VALUES
    (motc_id, 'MOT-C 10mg', 10, 2100.00, 35),
    (motc_id, 'MOT-C 40mg', 40, 2900.00, 35);

  -- SS-31
  INSERT INTO products (name, description, category, base_price, purity_percentage, featured, available, stock_quantity, inclusions)
  VALUES (
    'SS-31',
    'Mitochondria-targeting antioxidant peptide for cellular protection, energy, and anti-aging support.',
    other_cat, 2100.00, 99.0, false, true, 35,
    ARRAY['10 Insulin Syringes', '1 Recon Syringe', '20 Alcohol Pads', 'Guide']
  ) RETURNING id INTO ss31_id;
  INSERT INTO product_variations (product_id, name, quantity_mg, price, stock_quantity) VALUES
    (ss31_id, 'SS-31 10mg', 10, 2100.00, 35),
    (ss31_id, 'SS-31 50mg', 50, 3600.00, 35);

  -- Epitalon
  INSERT INTO products (name, description, category, base_price, purity_percentage, featured, available, stock_quantity, inclusions)
  VALUES (
    'Epitalon',
    'Telomerase-activating tetrapeptide for anti-aging, longevity, and circadian rhythm regulation.',
    other_cat, 2400.00, 99.0, false, true, 30,
    ARRAY['10 Insulin Syringes', '1 Recon Syringe', '20 Alcohol Pads', 'Guide']
  ) RETURNING id INTO ephitalon_id;
  INSERT INTO product_variations (product_id, name, quantity_mg, price, stock_quantity) VALUES
    (ephitalon_id, 'Epitalon 50mg', 50, 2400.00, 30);

  -- KPV
  INSERT INTO products (name, description, category, base_price, purity_percentage, featured, available, stock_quantity, inclusions)
  VALUES (
    'KPV',
    'Anti-inflammatory tripeptide supporting skin health, gut healing, and immune modulation.',
    other_cat, 2000.00, 99.0, false, true, 35,
    ARRAY['10 Insulin Syringes', '1 Recon Syringe', '20 Alcohol Pads', 'Guide']
  ) RETURNING id INTO kpv_id;
  INSERT INTO product_variations (product_id, name, quantity_mg, price, stock_quantity) VALUES
    (kpv_id, 'KPV 10mg', 10, 2000.00, 35);

  -- Tesamorelin
  INSERT INTO products (name, description, category, base_price, purity_percentage, featured, available, stock_quantity, inclusions)
  VALUES (
    'Tesamorelin',
    'Growth hormone-releasing factor analogue for body composition, visceral fat reduction, and metabolic support.',
    other_cat, 2800.00, 99.0, false, true, 30,
    ARRAY['10 Insulin Syringes', '1 Recon Syringe', '20 Alcohol Pads', 'Guide']
  ) RETURNING id INTO tesam_id;
  INSERT INTO product_variations (product_id, name, quantity_mg, price, stock_quantity) VALUES
    (tesam_id, 'Tesamorelin 10mg', 10, 2800.00, 30);

  -- AOD
  INSERT INTO products (name, description, category, base_price, purity_percentage, featured, available, stock_quantity, inclusions)
  VALUES (
    'AOD',
    'Anti-obesity peptide fragment derived from human growth hormone for targeted fat metabolism.',
    other_cat, 2200.00, 99.0, false, true, 35,
    ARRAY['10 Insulin Syringes', '1 Recon Syringe', '20 Alcohol Pads', 'Guide']
  ) RETURNING id INTO aod_id;
  INSERT INTO product_variations (product_id, name, quantity_mg, price, stock_quantity) VALUES
    (aod_id, 'AOD 5mg', 5, 2200.00, 35);

  -- 5 Amino 1MQ
  INSERT INTO products (name, description, category, base_price, purity_percentage, featured, available, stock_quantity, inclusions)
  VALUES (
    '5 Amino 1MQ',
    'NNMT inhibitor for metabolic enhancement, fat cell reduction, and cellular energy optimization.',
    other_cat, 2100.00, 99.0, false, true, 35,
    ARRAY['10 Insulin Syringes', '1 Recon Syringe', '20 Alcohol Pads', 'Guide']
  ) RETURNING id INTO amino_id;
  INSERT INTO product_variations (product_id, name, quantity_mg, price, stock_quantity) VALUES
    (amino_id, '5 Amino 1MQ 50mg', 50, 2100.00, 35);

  -- HHB
  INSERT INTO products (name, description, category, base_price, purity_percentage, featured, available, stock_quantity, inclusions)
  VALUES (
    'HHB',
    'Premium peptide blend for hormonal balance, health, and well-being.',
    other_cat, 2200.00, 99.0, false, true, 30,
    ARRAY['10 Insulin Syringes', '1 Recon Syringe', '20 Alcohol Pads', 'Guide']
  ) RETURNING id INTO hhb_id;
  INSERT INTO product_variations (product_id, name, quantity_mg, price, stock_quantity) VALUES
    (hhb_id, 'HHB 10ml', 10, 2200.00, 30);

  -- Selank
  INSERT INTO products (name, description, category, base_price, purity_percentage, featured, available, stock_quantity, inclusions)
  VALUES (
    'Selank',
    'Anxiolytic nootropic peptide for stress relief, mood stabilization, and cognitive enhancement.',
    other_cat, 2100.00, 99.0, false, true, 40,
    ARRAY['10 Insulin Syringes', '1 Recon Syringe', '20 Alcohol Pads', 'Guide']
  ) RETURNING id INTO selank_id;
  INSERT INTO product_variations (product_id, name, quantity_mg, price, stock_quantity) VALUES
    (selank_id, 'Selank 10mg', 10, 2100.00, 40);

  -- Semax
  INSERT INTO products (name, description, category, base_price, purity_percentage, featured, available, stock_quantity, inclusions)
  VALUES (
    'Semax',
    'Nootropic peptide for enhanced cognitive function, focus, neuroprotection, and mental clarity.',
    other_cat, 2100.00, 99.0, false, true, 40,
    ARRAY['10 Insulin Syringes', '1 Recon Syringe', '20 Alcohol Pads', 'Guide']
  ) RETURNING id INTO semax_id;
  INSERT INTO product_variations (product_id, name, quantity_mg, price, stock_quantity) VALUES
    (semax_id, 'Semax 10mg', 10, 2100.00, 40);

  -- -------------------------------------------------------------------------
  -- COMBOS
  -- Tirzepatide Combos
  -- -------------------------------------------------------------------------
  INSERT INTO products (name, description, category, base_price, available, stock_quantity, inclusions) VALUES
    ('Tirzepatide 15mg + Lipo C B12',   'Combo: Tirzepatide 15mg paired with Lipo C B12 10ml. Complete set includes mixing supplies.',   combo_cat, 2800.00, true, 30, ARRAY['Mixing Supplies', 'Usage Guide']),
    ('Tirzepatide 30mg + Lipo C B12',   'Combo: Tirzepatide 30mg paired with Lipo C B12 10ml. Complete set includes mixing supplies.',   combo_cat, 3800.00, true, 30, ARRAY['Mixing Supplies', 'Usage Guide']),
    ('Tirzepatide 15mg + Fat Blaster',  'Combo: Tirzepatide 15mg paired with Lipo C Fat Blaster. Complete set includes mixing supplies.', combo_cat, 3000.00, true, 30, ARRAY['Mixing Supplies', 'Usage Guide']),
    ('Tirzepatide 30mg + Fat Blaster',  'Combo: Tirzepatide 30mg paired with Lipo C Fat Blaster. Complete set includes mixing supplies.', combo_cat, 4000.00, true, 30, ARRAY['Mixing Supplies', 'Usage Guide']),
    ('Tirzepatide 15mg + GHK-CU 50mg', 'Combo: Tirzepatide 15mg paired with GHK-Cu 50mg. Complete set includes mixing supplies.',       combo_cat, 2800.00, true, 30, ARRAY['Mixing Supplies', 'Usage Guide']),
    ('Tirzepatide 30mg + GHK-CU 50mg', 'Combo: Tirzepatide 30mg paired with GHK-Cu 50mg. Complete set includes mixing supplies.',       combo_cat, 3800.00, true, 30, ARRAY['Mixing Supplies', 'Usage Guide']),
    ('Tirzepatide 15mg + NAD+ 500mg',  'Combo: Tirzepatide 15mg paired with NAD+ 500mg. Complete set includes mixing supplies.',        combo_cat, 3200.00, true, 30, ARRAY['Mixing Supplies', 'Usage Guide']),
    ('Tirzepatide 30mg + NAD+ 500mg',  'Combo: Tirzepatide 30mg paired with NAD+ 500mg. Complete set includes mixing supplies.',        combo_cat, 4200.00, true, 30, ARRAY['Mixing Supplies', 'Usage Guide']);

  -- Retatrutide Combos
  INSERT INTO products (name, description, category, base_price, available, stock_quantity, inclusions) VALUES
    ('Retatrutide 10mg + Cagrilintide 5mg', 'Combo: Retatrutide 10mg + Cagrilintide 5mg. Complete set includes mixing supplies.',  combo_cat, 4000.00, true, 25, ARRAY['Mixing Supplies', 'Usage Guide']),
    ('Retatrutide 20mg + Cagrilintide 5mg', 'Combo: Retatrutide 20mg + Cagrilintide 5mg. Complete set includes mixing supplies.',  combo_cat, 4500.00, true, 25, ARRAY['Mixing Supplies', 'Usage Guide']),
    ('Retatrutide 10mg + Lipo C B12',       'Combo: Retatrutide 10mg + Lipo C B12 10ml. Complete set includes mixing supplies.',   combo_cat, 3500.00, true, 25, ARRAY['Mixing Supplies', 'Usage Guide']),
    ('Retatrutide 20mg + Lipo C B12',       'Combo: Retatrutide 20mg + Lipo C B12 10ml. Complete set includes mixing supplies.',   combo_cat, 4000.00, true, 25, ARRAY['Mixing Supplies', 'Usage Guide']),
    ('Retatrutide 30mg + Lipo V B12',       'Combo: Retatrutide 30mg + Lipo V B12. Complete set includes mixing supplies.',        combo_cat, 4500.00, true, 25, ARRAY['Mixing Supplies', 'Usage Guide']),
    ('Retatrutide 10mg + Fat Blaster',      'Combo: Retatrutide 10mg + Lipo C Fat Blaster. Complete set includes mixing supplies.', combo_cat, 3800.00, true, 25, ARRAY['Mixing Supplies', 'Usage Guide']),
    ('Retatrutide 20mg + Fat Blaster',      'Combo: Retatrutide 20mg + Lipo C Fat Blaster. Complete set includes mixing supplies.', combo_cat, 4300.00, true, 25, ARRAY['Mixing Supplies', 'Usage Guide']),
    ('Retatrutide 30mg + Fat Blaster',      'Combo: Retatrutide 30mg + Lipo C Fat Blaster. Complete set includes mixing supplies.', combo_cat, 4800.00, true, 25, ARRAY['Mixing Supplies', 'Usage Guide']),
    ('Retatrutide 10mg + GHK-CU 50mg',     'Combo: Retatrutide 10mg + GHK-Cu 50mg. Complete set includes mixing supplies.',       combo_cat, 4000.00, true, 25, ARRAY['Mixing Supplies', 'Usage Guide']),
    ('Retatrutide 20mg + GHK-CU 50mg',     'Combo: Retatrutide 20mg + GHK-Cu 50mg. Complete set includes mixing supplies.',       combo_cat, 4500.00, true, 25, ARRAY['Mixing Supplies', 'Usage Guide']),
    ('Retatrutide 30mg + GHK-CU 50mg',     'Combo: Retatrutide 30mg + GHK-Cu 50mg. Complete set includes mixing supplies.',       combo_cat, 5000.00, true, 25, ARRAY['Mixing Supplies', 'Usage Guide']);

  -- Other Combos
  INSERT INTO products (name, description, category, base_price, available, stock_quantity, inclusions) VALUES
    ('GHK-CU 50mg + NAD+ 500mg',         'Combo: GHK-Cu 50mg + NAD+ 500mg. Complete set includes mixing supplies.',             combo_cat, 3300.00, true, 25, ARRAY['Mixing Supplies', 'Usage Guide']),
    ('GHK-CU 50mg + Glutathione 1500mg', 'Combo: GHK-Cu 50mg + Glutathione 1500mg. Complete set includes mixing supplies.',     combo_cat, 2900.00, true, 25, ARRAY['Mixing Supplies', 'Usage Guide']),
    ('NAD+ 500mg + Glutathione 1500mg',  'Combo: NAD+ 500mg + Glutathione 1500mg. Complete set includes mixing supplies.',      combo_cat, 3600.00, true, 25, ARRAY['Mixing Supplies', 'Usage Guide']),
    ('GHK-CU 50mg + KPV 10mg',           'Combo: GHK-Cu 50mg + KPV 10mg. Complete set includes mixing supplies.',              combo_cat, 2800.00, true, 25, ARRAY['Mixing Supplies', 'Usage Guide']),
    ('Tesamorelin 10mg + AOD 5mg',        'Combo: Tesamorelin 10mg + AOD 5mg. Complete set includes mixing supplies.',          combo_cat, 4000.00, true, 25, ARRAY['Mixing Supplies', 'Usage Guide']),
    ('Tesamorelin 10mg + 5 Amino-1MQ',   'Combo: Tesamorelin 10mg + 5 Amino-1MQ 50mg. Complete set includes mixing supplies.', combo_cat, 3900.00, true, 25, ARRAY['Mixing Supplies', 'Usage Guide']),
    ('SS-31 10mg + MOT-C 10mg',          'Combo: SS-31 10mg + MOT-C 10mg. Complete set includes mixing supplies.',             combo_cat, 3200.00, true, 25, ARRAY['Mixing Supplies', 'Usage Guide']),
    ('SS-31 10mg + MOT-C 40mg',          'Combo: SS-31 10mg + MOT-C 40mg. Complete set includes mixing supplies.',             combo_cat, 4000.00, true, 25, ARRAY['Mixing Supplies', 'Usage Guide']),
    ('SS-31 50mg + MOT-C 10mg',          'Combo: SS-31 50mg + MOT-C 10mg. Complete set includes mixing supplies.',             combo_cat, 4700.00, true, 25, ARRAY['Mixing Supplies', 'Usage Guide']),
    ('SS-31 50mg + MOT-C 40mg',          'Combo: SS-31 50mg + MOT-C 40mg. Complete set includes mixing supplies.',             combo_cat, 5500.00, true, 25, ARRAY['Mixing Supplies', 'Usage Guide']);

END $$;

-- =============================================================================
-- VERIFY
-- =============================================================================
SELECT
  c.name AS category,
  p.name,
  p.base_price,
  p.available
FROM products p
JOIN categories c ON c.id::TEXT = p.category
ORDER BY c.sort_order, p.base_price;

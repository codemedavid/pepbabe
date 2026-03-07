-- ==============================================================================
-- SQL script to add requested products to Supabase
-- Please run this script in your Supabase SQL Editor.
-- Prices are placeholders (set to 0.00 or standard placeholder limits). Please
-- update them via your Admin page later.
-- ==============================================================================

-- 1. Ensure the 'Fat Dissolvers' category exists for Lemon Bottle and Aqualyx
INSERT INTO categories (id, name, icon, sort_order, active)
SELECT gen_random_uuid(), 'Fat Dissolvers', '💧', 6, true
WHERE NOT EXISTS (SELECT 1 FROM categories WHERE name = 'Fat Dissolvers');

-- 2. Insert the products

-- Vial Case
INSERT INTO products (name, description, base_price, category, available, featured, stock_quantity)
VALUES (
  'Vial Case', 
  'Secure protective storage case for your vials.', 
  15.00, 
  (SELECT id::text FROM categories WHERE name = 'Add-Ons' LIMIT 1), 
  true, 
  false, 
  100
);

-- Vial Openers
INSERT INTO products (name, description, base_price, category, available, featured, stock_quantity)
VALUES (
  'Vial Opener', 
  'Easy-to-use opener tool for safely uncapping vials.', 
  10.00, 
  (SELECT id::text FROM categories WHERE name = 'Add-Ons' LIMIT 1), 
  true, 
  false, 
  100
);

-- Peptide Mixing Organizer
INSERT INTO products (name, description, base_price, category, available, featured, stock_quantity)
VALUES (
  'Peptide Mixing Organizer', 
  'Convenient organizer tray or station to keep all your mixing supplies tidy.', 
  25.00, 
  (SELECT id::text FROM categories WHERE name = 'Add-Ons' LIMIT 1), 
  true, 
  false, 
  50
);

-- Reusable Insulin Pens
INSERT INTO products (name, description, base_price, category, available, featured, stock_quantity)
VALUES (
  'Reusable Insulin Pen', 
  'High-quality, durable reusable pen for precise administration.', 
  45.00, 
  (SELECT id::text FROM categories WHERE name = 'Add-Ons' LIMIT 1), 
  true, 
  true, 
  50
);

-- Syringes
INSERT INTO products (name, description, base_price, category, available, featured, stock_quantity)
VALUES (
  'Insulin Syringes (100pcs)', 
  'Pack of 100 high-grade, standard sterile syringes.', 
  20.00, 
  (SELECT id::text FROM categories WHERE name = 'Add-Ons' LIMIT 1), 
  true, 
  false, 
  200
);

-- Insulin Needles
INSERT INTO products (name, description, base_price, category, available, featured, stock_quantity)
VALUES (
  'Insulin Needles (100pcs)', 
  'Pack of 100 ultra-fine replacement needles.', 
  25.00, 
  (SELECT id::text FROM categories WHERE name = 'Add-Ons' LIMIT 1), 
  true, 
  false, 
  200
);

-- Alcohol Pads
INSERT INTO products (name, description, base_price, category, available, featured, stock_quantity)
VALUES (
  'Alcohol Prep Pads (100pcs)', 
  'Sterile 70% isopropyl alcohol pads for safe preparation.', 
  5.00, 
  (SELECT id::text FROM categories WHERE name = 'Add-Ons' LIMIT 1), 
  true, 
  false, 
  500
);

-- Numbing Cream
INSERT INTO products (name, description, base_price, category, available, featured, stock_quantity)
VALUES (
  'Topical Numbing Cream', 
  'Fast-acting topical numbing cream for pain-free administration.', 
  18.00, 
  (SELECT id::text FROM categories WHERE name = 'Add-Ons' LIMIT 1), 
  true, 
  false, 
  50
);

-- Serum Bottle
INSERT INTO products (name, description, base_price, category, available, featured, stock_quantity)
VALUES (
  'Empty Serum Bottle', 
  'Sterile empty glass serum bottles for storing your formulations.', 
  8.00, 
  (SELECT id::text FROM categories WHERE name = 'Add-Ons' LIMIT 1), 
  true, 
  false, 
  100
);

-- Nasal Spray Bottle
INSERT INTO products (name, description, base_price, category, available, featured, stock_quantity)
VALUES (
  'Nasal Spray Bottle', 
  'Empty refillable nasal spray bottle for localized administration.', 
  5.00, 
  (SELECT id::text FROM categories WHERE name = 'Add-Ons' LIMIT 1), 
  true, 
  false, 
  150
);

-- Lemon Bottle
INSERT INTO products (name, description, base_price, category, available, featured, stock_quantity)
VALUES (
  'Lemon Bottle (Fat Dissolver)', 
  'Premium advanced lipolysis solution for targeted fat dissolving.', 
  150.00, 
  (SELECT id::text FROM categories WHERE name = 'Fat Dissolvers' LIMIT 1), 
  true, 
  true, 
  30
);

-- Aqualyx
INSERT INTO products (name, description, base_price, category, available, featured, stock_quantity)
VALUES (
  'Aqualyx (Fat Dissolver)', 
  'Injectable compound solution for localized fat reduction.', 
  180.00, 
  (SELECT id::text FROM categories WHERE name = 'Fat Dissolvers' LIMIT 1), 
  true, 
  true, 
  30
);

-- =====================================================================
-- Peptide Pulse / Peptherapy PH — Full Supabase Migration
-- Source project_ref: otgtvdyvfuxdygtvhote
-- Generated: 2026-05-01
-- Includes: schema (12 tables) + all data
-- =====================================================================

BEGIN;

-- Required extensions
CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp" SCHEMA extensions;

-- ---------------------------------------------------------------------
-- DROP (safe re-run). Comment out if doing a fresh install.
-- ---------------------------------------------------------------------
DROP TABLE IF EXISTS public.protocols CASCADE;
DROP TABLE IF EXISTS public.product_variations CASCADE;
DROP TABLE IF EXISTS public.orders CASCADE;
DROP TABLE IF EXISTS public.promo_codes CASCADE;
DROP TABLE IF EXISTS public.products CASCADE;
DROP TABLE IF EXISTS public.categories CASCADE;
DROP TABLE IF EXISTS public.payment_methods CASCADE;
DROP TABLE IF EXISTS public.shipping_locations CASCADE;
DROP TABLE IF EXISTS public.couriers CASCADE;
DROP TABLE IF EXISTS public.site_settings CASCADE;
DROP TABLE IF EXISTS public.coa_reports CASCADE;
DROP TABLE IF EXISTS public.faqs CASCADE;

-- =====================================================================
-- SCHEMA
-- =====================================================================

-- categories
CREATE TABLE public.categories (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name        text NOT NULL,
  icon        text,
  sort_order  integer DEFAULT 0,
  active      boolean DEFAULT true,
  created_at  timestamptz NOT NULL DEFAULT timezone('utc'::text, now()),
  updated_at  timestamptz NOT NULL DEFAULT timezone('utc'::text, now())
);

-- products
CREATE TABLE public.products (
  id                  uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name                text NOT NULL,
  description         text,
  category            text DEFAULT 'Uncategorized',
  base_price          numeric NOT NULL DEFAULT 0,
  discount_price      numeric,
  discount_start_date timestamptz,
  discount_end_date   timestamptz,
  discount_active     boolean DEFAULT false,
  purity_percentage   numeric DEFAULT 99.0,
  molecular_weight    text,
  cas_number          text,
  sequence            text,
  storage_conditions  text DEFAULT 'Store at -20°C',
  inclusions          text[],
  stock_quantity      integer DEFAULT 0,
  available           boolean DEFAULT true,
  featured            boolean DEFAULT false,
  image_url           text,
  safety_sheet_url    text,
  created_at          timestamptz NOT NULL DEFAULT timezone('utc'::text, now()),
  updated_at          timestamptz NOT NULL DEFAULT timezone('utc'::text, now())
);

-- product_variations
CREATE TABLE public.product_variations (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  product_id      uuid REFERENCES public.products(id) ON DELETE CASCADE,
  name            text NOT NULL,
  quantity_mg     numeric NOT NULL DEFAULT 0,
  price           numeric NOT NULL DEFAULT 0,
  discount_price  numeric,
  discount_active boolean DEFAULT false,
  stock_quantity  integer DEFAULT 0,
  created_at      timestamptz NOT NULL DEFAULT timezone('utc'::text, now())
);

-- site_settings
CREATE TABLE public.site_settings (
  id          text PRIMARY KEY,
  value       text NOT NULL,
  type        text NOT NULL DEFAULT 'text',
  description text,
  updated_at  timestamptz DEFAULT now()
);

-- payment_methods
CREATE TABLE public.payment_methods (
  id             uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name           text NOT NULL,
  account_number text,
  account_name   text,
  qr_code_url    text,
  active         boolean DEFAULT true,
  sort_order     integer DEFAULT 0,
  created_at     timestamptz NOT NULL DEFAULT timezone('utc'::text, now()),
  updated_at     timestamptz NOT NULL DEFAULT timezone('utc'::text, now())
);

-- shipping_locations
CREATE TABLE public.shipping_locations (
  id          text PRIMARY KEY,
  name        text NOT NULL,
  fee         numeric NOT NULL DEFAULT 0,
  is_active   boolean NOT NULL DEFAULT true,
  order_index integer NOT NULL DEFAULT 1,
  created_at  timestamptz DEFAULT now(),
  updated_at  timestamptz DEFAULT now()
);

-- couriers
CREATE TABLE public.couriers (
  id                    uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  code                  text UNIQUE NOT NULL,
  name                  text NOT NULL,
  tracking_url_template text,
  is_active             boolean DEFAULT true,
  sort_order            integer DEFAULT 0,
  created_at            timestamptz DEFAULT now()
);

-- promo_codes
CREATE TABLE public.promo_codes (
  id                  uuid PRIMARY KEY DEFAULT extensions.uuid_generate_v4(),
  code                text UNIQUE NOT NULL,
  discount_type       text NOT NULL CHECK (discount_type = ANY (ARRAY['percentage'::text, 'fixed'::text])),
  discount_value      numeric NOT NULL,
  min_purchase_amount numeric DEFAULT 0,
  max_discount_amount numeric,
  start_date          timestamptz,
  end_date            timestamptz,
  usage_limit         integer,
  usage_count         integer DEFAULT 0,
  active              boolean DEFAULT true,
  created_at          timestamptz DEFAULT now(),
  updated_at          timestamptz DEFAULT now()
);

-- orders
CREATE TABLE public.orders (
  id                  uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  customer_name       text NOT NULL,
  customer_email      text NOT NULL,
  customer_phone      text NOT NULL,
  contact_method      text DEFAULT 'phone',
  shipping_address    text NOT NULL,
  shipping_city       text,
  shipping_state      text,
  shipping_zip_code   text,
  shipping_country    text DEFAULT 'Philippines',
  shipping_barangay   text,
  shipping_region     text,
  shipping_location   text,
  courier_id          uuid,
  shipping_fee        numeric DEFAULT 0,
  order_items         jsonb NOT NULL,
  subtotal            numeric,
  total_price         numeric NOT NULL,
  pricing_mode        text DEFAULT 'PHP',
  payment_method_id   text,
  payment_method_name text,
  payment_status      text DEFAULT 'pending',
  payment_proof_url   text,
  promo_code_id       uuid REFERENCES public.promo_codes(id),
  promo_code          text,
  discount_applied    numeric DEFAULT 0,
  order_status        text DEFAULT 'new',
  notes               text,
  admin_notes         text,
  tracking_number     text,
  tracking_courier    text,
  shipping_provider   text,
  shipping_note       text,
  shipped_at          timestamptz,
  created_at          timestamptz DEFAULT now(),
  updated_at          timestamptz DEFAULT now(),
  order_number        text
);

-- coa_reports
CREATE TABLE public.coa_reports (
  id                uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  product_name      text NOT NULL,
  batch             text,
  test_date         date NOT NULL,
  purity_percentage numeric NOT NULL,
  quantity          text NOT NULL,
  task_number       text NOT NULL,
  verification_key  text NOT NULL,
  image_url         text NOT NULL,
  featured          boolean DEFAULT false,
  manufacturer      text DEFAULT 'Peptide Pulse',
  laboratory        text DEFAULT 'Janoshik Analytical',
  created_at        timestamptz DEFAULT now(),
  updated_at        timestamptz DEFAULT now()
);

-- faqs
CREATE TABLE public.faqs (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  question    text NOT NULL,
  answer      text NOT NULL,
  category    text NOT NULL DEFAULT 'GENERAL',
  order_index integer NOT NULL DEFAULT 1,
  is_active   boolean NOT NULL DEFAULT true,
  created_at  timestamptz DEFAULT now(),
  updated_at  timestamptz DEFAULT now()
);

-- protocols
CREATE TABLE public.protocols (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name         text NOT NULL,
  category     text NOT NULL,
  dosage       text NOT NULL,
  frequency    text NOT NULL,
  duration     text NOT NULL,
  notes        text[] DEFAULT '{}'::text[],
  storage      text NOT NULL,
  sort_order   integer DEFAULT 0,
  active       boolean DEFAULT true,
  product_id   uuid REFERENCES public.products(id) ON DELETE SET NULL,
  image_url    text,
  created_at   timestamptz DEFAULT now(),
  updated_at   timestamptz DEFAULT now(),
  content_type text NOT NULL DEFAULT 'text',
  file_url     text
);

ALTER TABLE public.protocols ENABLE ROW LEVEL SECURITY;

-- =====================================================================
-- DATA
-- =====================================================================

-- categories
INSERT INTO public.categories (id, name, icon, sort_order, active) VALUES
('c0a80121-0001-4e78-94f8-585d77059001','Peptides','FlaskConical',1,true),
('c0a80121-0002-4e78-94f8-585d77059002','Weight Management','Scale',2,true),
('c0a80121-0003-4e78-94f8-585d77059003','Beauty & Anti-Aging','Sparkles',3,true),
('c0a80121-0004-4e78-94f8-585d77059004','Wellness & Vitality','Heart',4,true),
('c0a80121-0005-4e78-94f8-585d77059005','GLP-1 Agonists','Pill',5,true),
('c0a80121-0006-4e78-94f8-585d77059006','Insulin Pens','Syringe',6,true),
('c0a80121-0007-4e78-94f8-585d77059007','Accessories','Package',7,true),
('c0a80121-0008-4e78-94f8-585d77059008','Bundles & Kits','Gift',8,true),
('6c7560ae-af6f-450d-9cfd-c481e76a93a5','Fat Dissolvers','Droplet',9,true);

-- products
INSERT INTO public.products (id, name, description, category, base_price, discount_active, purity_percentage, storage_conditions, stock_quantity, available, featured) VALUES
('b62a61ba-f7f3-4730-ab07-1277ce907c44','AOD-9604 5mg (AOD 5mg)','Modified fragment of human growth hormone targeting fat metabolism. 5mg vial.','c0a80121-0002-4e78-94f8-585d77059002',2200.00,false,99.00,'Store at -20°C',30,true,true),
('4cd5f842-d8b6-456c-abe2-587612d7d6ba','Cagrilintide 10mg (Cagri10)','Long-acting amylin analogue for appetite suppression. 10mg vial.','c0a80121-0002-4e78-94f8-585d77059002',3500.00,false,99.00,'Store at -20°C',30,true,true),
('fae20e80-7d51-47fb-8054-4e066c3c0c1e','Fat Blaster','Targeted fat dissolver for stubborn fat areas. Lipolytic body contouring solution.','6c7560ae-af6f-450d-9cfd-c481e76a93a5',2500.00,false,99.00,'Store at -20°C',30,true,true),
('8e7e032b-5a70-4569-b891-81159085f117','GHK-Cu 100mg (Ghk100)','Copper peptide for skin regeneration and anti-aging. 100mg vial.','c0a80121-0003-4e78-94f8-585d77059003',2000.00,false,99.00,'Store at -20°C',40,true,true),
('4ac76f75-ee3b-472b-9cd7-066251ba28b5','Glutathione 1500mg (Gtt1500)','High-potency glutathione for skin brightening and antioxidant support. 1500mg vial.','c0a80121-0003-4e78-94f8-585d77059003',2100.00,false,99.00,'Store at -20°C',50,true,true),
('efbc17c3-0b0f-435e-9c34-6e666541688d','KPV 10mg (Kpv10)','Tripeptide with anti-inflammatory and gut-healing properties. 10mg vial.','c0a80121-0001-4e78-94f8-585d77059001',1900.00,false,99.00,'Store at -20°C',40,true,false),
('a7366e48-63f4-44ae-8772-b05ac03413c7','Lemon Bottle','Premium advanced lipolysis solution for targeted fat dissolving.','6c7560ae-af6f-450d-9cfd-c481e76a93a5',1600.00,false,99.00,'Store at -20°C',40,true,true),
('d0b81e69-fc07-478f-8fb7-d913b887a5fa','NAD+ 100mg (Nad100)','Nicotinamide adenine dinucleotide for cellular energy and longevity. 100mg vial.','c0a80121-0004-4e78-94f8-585d77059004',2000.00,false,99.00,'Store at -20°C',40,true,true),
('da63295e-68e3-45ec-9256-a7745eda3024','Retatrutide 20mg (Reta20)','Triple agonist (GLP-1/GIP/glucagon) for advanced weight management. 20mg vial.','c0a80121-0002-4e78-94f8-585d77059002',2500.00,false,99.00,'Store at -20°C',30,true,true),
('e5698efc-70e3-4d20-b5ed-cc58b3c38d04','Retatrutide 30mg (Reta30)','High-dose triple agonist (GLP-1/GIP/glucagon). 30mg vial.','c0a80121-0002-4e78-94f8-585d77059002',3500.00,false,99.00,'Store at -20°C',25,true,true),
('a1a20002-0002-4e78-94f8-585d77059002','Tirzepatide 10mg','Double-strength formulation.','c0a80121-0002-4e78-94f8-585d77059002',3200.00,false,99.00,'Store at -20°C',50,true,true),
('a1a20003-0003-4e78-94f8-585d77059003','Tirzepatide 15mg','High-potency formulation.','c0a80121-0002-4e78-94f8-585d77059002',4500.00,false,99.00,'Store at -20°C',50,true,true),
('4526b7b0-98ae-4450-9c4d-8ed2f5e4e314','Tirzepatide 15mg (Tr15)','Dual GIP/GLP-1 receptor agonist for weight management. 15mg vial.','c0a80121-0002-4e78-94f8-585d77059002',2000.00,false,99.00,'Store at -20°C',50,true,true),
('850a7ab4-415a-4acf-8b87-4a014768e598','Tirzepatide 30mg (Tr30)','Dual GIP/GLP-1 receptor agonist for weight management. 30mg vial.','c0a80121-0002-4e78-94f8-585d77059002',2500.00,false,99.00,'Store at -20°C',50,true,true),
('a1a20001-0001-4e78-94f8-585d77059001','Tirzepatide 5mg','Lab tested for 99%+ purity.','c0a80121-0002-4e78-94f8-585d77059002',1800.00,false,99.00,'Store at -20°C',50,true,true),
('726104bd-5fdf-48d7-a9db-37bac4627509','Tirzepatide 60mg (TR60)','High-dose dual GIP/GLP-1 receptor agonist. 60mg vial.','c0a80121-0002-4e78-94f8-585d77059002',4500.00,false,99.00,'Store at -20°C',30,true,true);

-- product_variations
INSERT INTO public.product_variations (id, product_id, name, quantity_mg, price, discount_active, stock_quantity) VALUES
('fa309901-3f5d-447b-93c0-a2a4f11be653','a1a20001-0001-4e78-94f8-585d77059001','Vials Only',0.00,1800.00,false,50),
('f0f638d5-f9ed-464f-96f6-38b082e9c58f','a1a20001-0001-4e78-94f8-585d77059001','Complete Set',0.00,2300.00,false,30),
('180241c6-8233-41f2-b7d0-5360c4eb0b73','a1a20002-0002-4e78-94f8-585d77059002','Vials Only',0.00,3200.00,false,50),
('d08ad917-ae9b-4c16-81cd-3f66871696a5','a1a20002-0002-4e78-94f8-585d77059002','Complete Set',0.00,3700.00,false,30);

-- site_settings
INSERT INTO public.site_settings (id, value, type, description) VALUES
('site_name','Peptide Pulse','text','The name of the website'),
('site_logo','/assets/logo.jpeg','image','The logo image URL for the site'),
('site_description','Premium Peptide Solutions','text','Short description of the site'),
('currency','₱','text','Currency symbol for prices'),
('hero_title_prefix','Premium','text','Hero title prefix'),
('hero_title_highlight','Peptides','text','Hero title highlighted word'),
('hero_title_suffix','& Essentials','text','Hero title suffix'),
('coa_page_enabled','false','boolean','Enable/disable the COA page');

-- payment_methods
INSERT INTO public.payment_methods (id, name, account_number, account_name, active, sort_order) VALUES
('0a0b0001-0001-4e78-94f8-585d77059001','GCash','','Peptide Pulse',true,1),
('0a0b0002-0002-4e78-94f8-585d77059002','BDO','','Peptide Pulse',true,2),
('0a0b0003-0003-4e78-94f8-585d77059003','Security Bank','','Peptide Pulse',true,3);

-- shipping_locations
INSERT INTO public.shipping_locations (id, name, fee, is_active, order_index) VALUES
('NCR','NCR (Metro Manila)',75.00,true,1),
('LBC_METRO_MANILA','LBC - Metro Manila',150.00,true,1),
('LUZON','Luzon (Outside NCR)',100.00,true,2),
('LBC_LUZON','LBC - Luzon (Provincial)',200.00,true,2),
('VISAYAS_MINDANAO','Visayas & Mindanao',130.00,true,3),
('LBC_VISMIN','LBC - Visayas & Mindanao',250.00,true,3),
('JNT_METRO_MANILA','J&T - Metro Manila',120.00,true,4),
('JNT_PROVINCIAL','J&T - Provincial',180.00,true,5),
('LALAMOVE_STANDARD','Lalamove (Book Yourself / Rider)',0.00,true,6),
('MAXIM_STANDARD','Maxim (Book Yourself / Rider)',0.00,true,7);

-- couriers
INSERT INTO public.couriers (code, name, tracking_url_template, is_active, sort_order) VALUES
('lbc','LBC Express','https://www.lbcexpress.com/track/?tracking_no={tracking}',true,0),
('jnt','J&T Express','https://www.jtexpress.ph/index/query/gzquery.html?bills={tracking}',true,0),
('lalamove','Lalamove',NULL,true,0),
('grab','Grab Express',NULL,true,0),
('maxim','Maxim',NULL,true,0);

-- protocols
INSERT INTO public.protocols (id, name, category, dosage, frequency, duration, notes, storage, sort_order, active, content_type) VALUES
('25f1daee-a8cf-495d-bb37-5e83f7cf0062','Tirzepetide 15MG Protocol','Weight Management','2.5mg - 7.5mg weekly (dose based on vial size)','Once weekly on the same day','12-16 weeks per cycle',ARRAY['Start with 2.5mg for first 4 weeks','Increase by 2.5mg every 4 weeks as tolerated','This is the 15mg vial - yields multiple doses','Inject subcutaneously in abdomen, thigh, or upper arm','Take with or without food','Rotate injection sites'],'Refrigerate at 2-8°C. Once in use, can be kept at room temperature for up to 21 days.',1,true,'text'),
('e89482e6-4bf6-48be-a4aa-24c070ccae01','Tirzepetide 30MG Protocol','Weight Management','5mg - 15mg weekly (higher dose vial)','Once weekly on the same day','12-16 weeks per cycle',ARRAY['Start with 5mg for first 4 weeks if experienced','Increase by 2.5-5mg every 4 weeks as tolerated','Maximum dose is 15mg weekly','This larger vial offers more flexibility','Inject subcutaneously','May cause nausea initially - eat smaller meals'],'Refrigerate at 2-8°C.',2,true,'text'),
('0eef4143-dad2-4d07-b646-7d7dde2225a7','NAD+ 500MG Protocol','Longevity & Anti-Aging','100mg - 250mg daily','Once daily, preferably morning','8-12 weeks per cycle',ARRAY['Start with 100mg and increase gradually','Subcutaneous or intramuscular injection','Higher dose vial allows extended use','Take in morning to avoid sleep disruption','Supports cellular energy and repair','Some initial flushing is normal'],'Refrigerate after reconstitution. Protect from light.',3,true,'text'),
('f325e2f1-517d-45b7-a00f-fd21a9e64b9e','GHK CU 50MG Protocol','Beauty & Regeneration','1mg - 2mg daily','Once daily','8-12 weeks per cycle',ARRAY['Can be used topically or via injection','Promotes collagen synthesis','Supports skin elasticity and wound healing','Also used for hair regrowth','Copper peptide with many benefits','Safe for long-term use'],'Refrigerate after reconstitution.',4,true,'text'),
('34bb978d-2358-4e97-b168-92171a472e21','GHK CU 100MG Protocol','Beauty & Regeneration','2mg - 3mg daily','Once daily','8-12 weeks per cycle',ARRAY['Higher concentration for extended protocols','Excellent for anti-aging protocols','Can inject near treatment area','Supports tissue repair','Works synergistically with other peptides','Monitor for copper sensitivity'],'Refrigerate after reconstitution.',5,true,'text'),
('09fbeac8-1424-4dfa-9721-e0aa6b82d4a1','DSIP 5MG Protocol','Sleep & Recovery','100mcg - 300mcg before bed','Once daily, 30 min before sleep','2-4 weeks per cycle',ARRAY['Start with 100mcg to assess tolerance','Promotes deep, restorative sleep','Do not combine with other sedatives','Effects build over several days','Take 2-4 week breaks between cycles','Subcutaneous injection preferred'],'Refrigerate after reconstitution.',6,true,'text'),
('2a8436c5-5467-4a82-ad4d-ab7a21d2c96a','DSIP 15MG Protocol','Sleep & Recovery','200mcg - 400mcg before bed','Once daily, 30 min before sleep','4-6 weeks per cycle',ARRAY['Larger vial for extended sleep support','Gradually increase dose as needed','Supports natural sleep architecture','May help with stress-related insomnia','Avoid alcohol when using','Take breaks to prevent tolerance'],'Refrigerate after reconstitution.',7,true,'text'),
('6d8a0bb6-2ad7-44c9-9824-dabf2e9bd2ce','Glutathione 1500MG Protocol','Detox & Skin Brightening','200mg - 500mg every other day','3-4 times weekly','8-12 weeks per cycle',ARRAY['Master antioxidant for detoxification','Skin brightening and evening tone','Can inject subcutaneously or intramuscularly','Often combined with Vitamin C','Supports liver function','Results visible after 4-6 weeks'],'Refrigerate. Protect from light and heat.',8,true,'text'),
('0e110e03-2731-4c89-aadd-cac62bd353ae','Lipo C with B12 Protocol','Fat Burning & Energy','1ml injection','2-3 times weekly','Ongoing or 8-12 week cycles',ARRAY['Lipotropic injection for fat metabolism','Boosts energy and metabolism','Inject intramuscularly in thigh or buttock','Best combined with exercise program','Supports liver fat processing','B12 provides energy boost'],'Refrigerate. Protect from light.',9,true,'text'),
('b84d5db9-f0ff-41bf-83a4-60c51152a7ba','SS31 10MG Protocol','Mitochondrial Health','5mg - 10mg daily','Once daily','4-6 weeks per cycle',ARRAY['Targets inner mitochondrial membrane','Protects against oxidative stress','Supports cellular energy production','Inject subcutaneously','Best taken in morning','Take 4-week breaks between cycles'],'Refrigerate. Protect from light.',10,true,'text'),
('86ae06d5-410b-4285-8186-5b1c4e3e1a16','SS31 50MG Protocol','Mitochondrial Health','10mg - 20mg daily','Once daily','4-8 weeks per cycle',ARRAY['Higher dose for intensive protocols','Advanced mitochondrial support','Anti-aging at cellular level','Monitor energy levels','May enhance exercise performance','Rotate injection sites'],'Refrigerate. Protect from light.',11,true,'text'),
('35ef999d-5876-4273-81f6-249b64ab9da8','MOTS C 10MG Protocol','Metabolic Health','5mg twice weekly','Twice weekly (e.g., Mon/Thu)','8-12 weeks per cycle',ARRAY['Mitochondrial-derived peptide','Improves insulin sensitivity','Enhances exercise capacity','Take before exercise for best results','Supports metabolic health','Intramuscular or subcutaneous'],'Refrigerate after reconstitution.',12,true,'text'),
('cb2988c8-cbac-4952-bdf0-c7f9067d38c5','MOTS C 40MG Protocol','Metabolic Health','10mg twice weekly','Twice weekly (e.g., Mon/Thu)','8-12 weeks per cycle',ARRAY['Higher dose for intensive protocols','Enhanced metabolic optimization','Great for athletes and active users','Best taken pre-workout','Supports weight management','Monitor blood glucose if diabetic'],'Refrigerate after reconstitution.',13,true,'text'),
('e97bec95-e9a8-44d0-a212-b86e0aac9b61','KLOW (CU50+TB10+BC10+KPV10) Protocol','Healing & Anti-Inflammatory','As pre-mixed or follow component ratios','Once daily','6-8 weeks per cycle',ARRAY['Powerful combination stack','GHK-Cu for regeneration','TB-500 for tissue repair','BPC-157 for healing','KPV for anti-inflammatory','All-in-one healing protocol'],'Refrigerate after reconstitution.',14,true,'text'),
('e60cc224-a6f3-457f-a4af-69f34abce186','Lemon Bottle 10MG Protocol','Fat Dissolving','Apply as directed to treatment area','Weekly treatments','4-6 sessions typically',ARRAY['Lipolytic solution for fat reduction','Professional application recommended','Targets stubborn fat deposits','Massage after application','Results visible after 2-3 sessions','Avoid strenuous exercise 24hrs after'],'Refrigerate. Keep away from direct sunlight.',15,true,'text'),
('4e1e93fe-9291-457a-9fe2-e34bc90d368e','KPV 10MG + GHKCu 50MG Protocol','Anti-Inflammatory & Regeneration','KPV: 200mcg + GHKCu: 1mg daily','Once daily','6-8 weeks per cycle',ARRAY['Synergistic anti-inflammatory combo','KPV reduces inflammation','GHKCu promotes tissue repair','Great for skin and gut health','Subcutaneous injection','Can split doses AM/PM'],'Refrigerate after reconstitution.',16,true,'text'),
('a6e39879-e2f0-4916-a1c2-a0b53cfd52dd','Snap-8 (Botox in a Bottle) Protocol','Anti-Wrinkle','Apply topically to wrinkle-prone areas','Twice daily','Ongoing use',ARRAY['Topical anti-wrinkle peptide','Apply to forehead, crows feet, frown lines','Works by relaxing facial muscles','Visible results in 2-4 weeks','Safe for daily use','Can layer under moisturizer'],'Store at room temperature. Keep sealed.',17,true,'text'),
('3f84c550-72f0-454d-a449-1924e7fd3b3a','GHKCu Cosmetic Grade (1 gram) Protocol','Professional Cosmetic Use','Mix into serums: 0.1-0.5% concentration','Daily as part of skincare routine','Ongoing use',ARRAY['High-grade copper peptide powder','Mix into your preferred serum base','Start with lower concentration','Store mixed serum in dark bottle','Promotes collagen and elastin','Professional skincare formulation'],'Store powder in freezer. Mixed serum refrigerate.',18,true,'text'),
('25735fbe-52da-4bee-bac3-58e66f3eb7f6','Semax 10MG + Selank 10MG Protocol','Cognitive Enhancement','Semax: 300mcg + Selank: 250mcg daily','1-2 times daily','2-4 weeks per cycle',ARRAY['Powerful nootropic combination','Semax for focus and memory','Selank for anxiety and stress','Intranasal or subcutaneous','Best taken morning/early afternoon','Take breaks between cycles'],'Refrigerate. Use within 30 days.',19,true,'text'),
('c99a5f1b-8d3b-49ae-9eba-813b193f3c71','KPV 5MG Protocol','Anti-Inflammatory','100mcg - 200mcg daily','Once daily','4-8 weeks per cycle',ARRAY['Potent anti-inflammatory peptide','Alpha-MSH fragment','Gut health and skin conditions','Subcutaneous injection','No significant side effects','Works systemically'],'Refrigerate after reconstitution.',20,true,'text'),
('88ce5b42-dfd9-43a5-a711-c53115ee6340','KPV 10MG Protocol','Anti-Inflammatory','200mcg - 400mcg daily','Once or twice daily','4-8 weeks per cycle',ARRAY['Higher dose for stronger effect','Excellent for inflammatory conditions','Can split dose morning/evening','Supports gut barrier function','Anti-microbial properties','Safe for extended use'],'Refrigerate after reconstitution.',21,true,'text'),
('49ba5eca-89ea-4a91-98f6-df4e0ad77482','Tesamorelin 5MG Protocol','Growth Hormone','1mg daily','Once daily before bed on empty stomach','12-26 weeks per cycle',ARRAY['FDA-approved GHRH analog','Reduces visceral fat','Inject subcutaneously in abdomen','No food 2 hours before/after','Stimulates natural GH release','Monitor IGF-1 levels'],'Refrigerate at 2-8°C.',22,true,'text'),
('49149492-1242-4be4-ab19-405d21767139','Tesamorelin 10MG Protocol','Growth Hormone','1mg - 2mg daily','Once daily before bed on empty stomach','12-26 weeks per cycle',ARRAY['Larger vial for extended use','Same protocol as 5MG','Consistent timing important','Best taken before bed','Avoid eating after injection','Results visible after 8-12 weeks'],'Refrigerate at 2-8°C.',23,true,'text'),
('ca38968f-119a-4f52-aea0-a099e98cf757','Epitalon 10MG Protocol','Longevity & Anti-Aging','5mg - 10mg daily for 10-20 days','Once daily, preferably before bed','10-20 day cycles, 4-6 months apart',ARRAY['Telomere elongation peptide','Short intense cycles','Promotes melatonin production','Anti-aging at DNA level','Take 2-3 cycles per year','Subcutaneous injection'],'Refrigerate. Stable for 6 months.',24,true,'text'),
('2657cc27-03dc-4749-8811-bd5f4bc0b0e1','Epitalon 50MG Protocol','Longevity & Anti-Aging','10mg daily for 10-20 days','Once daily, preferably before bed','10-20 day cycles, 4-6 months apart',ARRAY['Higher dose vial for multiple cycles','Ultimate longevity peptide','Resets biological clock','Improves sleep quality','Supports immune function','Visible anti-aging effects'],'Refrigerate. Stable for 6 months.',25,true,'text'),
('1d25b51f-2d69-4467-9c01-dd5edbadebde','PT141 10MG Protocol','Sexual Wellness','500mcg - 2mg as needed','As needed, 1-2 hours before activity','Use as needed, 24hr minimum between doses',ARRAY['Also known as Bremelanotide','Start with 500mcg to assess tolerance','Effects last 24-72 hours','Inject subcutaneously 45min-2hrs before','May cause nausea initially','Maximum once per 24 hours'],'Refrigerate. Use within 30 days.',26,true,'text');

-- =====================================================================
-- INDEXES
-- =====================================================================
CREATE INDEX IF NOT EXISTS idx_products_category    ON public.products (category);
CREATE INDEX IF NOT EXISTS idx_products_featured    ON public.products (featured) WHERE featured = true;
CREATE INDEX IF NOT EXISTS idx_variations_product   ON public.product_variations (product_id);
CREATE INDEX IF NOT EXISTS idx_protocols_product    ON public.protocols (product_id);
CREATE INDEX IF NOT EXISTS idx_protocols_sort       ON public.protocols (sort_order);
CREATE INDEX IF NOT EXISTS idx_orders_status        ON public.orders (order_status);
CREATE INDEX IF NOT EXISTS idx_orders_created       ON public.orders (created_at DESC);
CREATE INDEX IF NOT EXISTS idx_promo_code           ON public.promo_codes (code);

COMMIT;

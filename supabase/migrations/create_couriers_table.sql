-- Create couriers table for managing shipping providers
CREATE TABLE IF NOT EXISTS couriers (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  code TEXT UNIQUE NOT NULL,
  tracking_url_template TEXT,
  is_active BOOLEAN DEFAULT true,
  sort_order INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Backfill columns for tables created before these were added
ALTER TABLE couriers ADD COLUMN IF NOT EXISTS tracking_url_template TEXT;
ALTER TABLE couriers ADD COLUMN IF NOT EXISTS is_active BOOLEAN DEFAULT true;
ALTER TABLE couriers ADD COLUMN IF NOT EXISTS sort_order INTEGER DEFAULT 0;
ALTER TABLE couriers ADD COLUMN IF NOT EXISTS created_at TIMESTAMPTZ DEFAULT NOW();

-- Enable RLS
ALTER TABLE couriers ENABLE ROW LEVEL SECURITY;

-- Create policies for public read access
DROP POLICY IF EXISTS "Allow public read access to couriers" ON couriers;
CREATE POLICY "Allow public read access to couriers"
  ON couriers FOR SELECT
  USING (true);

-- Create policy for authenticated users to manage couriers
DROP POLICY IF EXISTS "Allow authenticated users to manage couriers" ON couriers;
CREATE POLICY "Allow authenticated users to manage couriers"
  ON couriers FOR ALL
  TO authenticated
  USING (true)
  WITH CHECK (true);

-- Insert default couriers
INSERT INTO couriers (name, code, tracking_url_template, is_active, sort_order) VALUES
  ('LBC Express', 'lbc', 'https://www.lbcexpress.com/track/?tracking_no={tracking}', true, 1),
  ('Lalamove', 'lalamove', NULL, true, 2),
  ('Maxim', 'maxim', NULL, true, 3),
  ('J&T Express', 'jnt', 'https://www.jtexpress.ph/trajectoryQuery?bills={tracking}', true, 4)
ON CONFLICT (code) DO NOTHING;

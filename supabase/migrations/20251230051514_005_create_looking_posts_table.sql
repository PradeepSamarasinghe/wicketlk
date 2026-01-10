/*
  # Create Looking Posts Table

  1. New Tables
    - `looking` - Store "looking for" posts (players, teams, officials)
      - `id` (uuid, primary key)
      - `type` (enum: player, team, official)
      - `user_id` (text)
      - `title` (text)
      - `description` (text)
      - `location` (text)
      - `skill_level` (text)
      - `match_date` (timestamp)
      - `availability` (text)
      - `status` (enum: active, closed)
      - `created_at` (timestamp)

  2. Security
    - Enable RLS on looking table
*/

CREATE TYPE looking_type AS ENUM ('player', 'team', 'official');
CREATE TYPE looking_status AS ENUM ('active', 'closed');

CREATE TABLE IF NOT EXISTS looking (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  type looking_type NOT NULL,
  user_id text NOT NULL,
  title text NOT NULL,
  description text,
  location text NOT NULL,
  skill_level text,
  match_date timestamp with time zone,
  availability text,
  status looking_status DEFAULT 'active',
  created_at timestamp with time zone DEFAULT now()
);

ALTER TABLE looking ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view looking posts"
  ON looking FOR SELECT
  TO authenticated
  USING (status = 'active'::looking_status);

CREATE POLICY "Authenticated users can create posts"
  ON looking FOR INSERT
  TO authenticated
  WITH CHECK (user_id = auth.uid()::text);

CREATE POLICY "Users can update own posts"
  ON looking FOR UPDATE
  TO authenticated
  USING (user_id = auth.uid()::text)
  WITH CHECK (user_id = auth.uid()::text);

CREATE INDEX idx_looking_type ON looking(type);
CREATE INDEX idx_looking_location ON looking(location);
CREATE INDEX idx_looking_status ON looking(status);
CREATE INDEX idx_looking_user ON looking(user_id);
CREATE INDEX idx_looking_date ON looking(match_date);

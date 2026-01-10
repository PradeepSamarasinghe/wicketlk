/*
  # Create Users Table

  1. New Tables
    - `users` - Store user profiles and statistics
      - `id` (uuid, primary key)
      - `phone_number` (text, unique)
      - `name` (text)
      - `profile_image` (text, nullable)
      - `location` (text, nullable)
      - `role` (text, nullable)
      - `experience` (text, nullable)
      - `stats` (jsonb)
      - `preferred_language` (text, default: 'en')
      - `created_at` (timestamp)

  2. Security
    - Enable RLS on users table
    - Add policies for user self-access
*/

CREATE TABLE IF NOT EXISTS users (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  phone_number text UNIQUE NOT NULL,
  name text NOT NULL,
  profile_image text,
  location text,
  role text,
  experience text,
  stats jsonb DEFAULT '{
    "matches_played": 0,
    "runs": 0,
    "wickets": 0,
    "strike_rate": 0.0,
    "average": 0.0,
    "badges": []
  }'::jsonb,
  preferred_language text DEFAULT 'en',
  created_at timestamp with time zone DEFAULT now()
);

ALTER TABLE users ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read own data"
  ON users FOR SELECT
  TO authenticated
  USING (auth.uid() = id);

CREATE POLICY "Users can update own data"
  ON users FOR UPDATE
  TO authenticated
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

CREATE POLICY "Users can insert own data"
  ON users FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = id);

CREATE INDEX idx_users_phone ON users(phone_number);
CREATE INDEX idx_users_location ON users(location);

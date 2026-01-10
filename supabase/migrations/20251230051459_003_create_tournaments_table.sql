/*
  # Create Tournaments Table

  1. New Tables
    - `tournaments` - Store tournament information
      - `id` (uuid, primary key)
      - `name` (text)
      - `description` (text)
      - `start_date` (timestamp)
      - `end_date` (timestamp)
      - `location` (text)
      - `type` (enum)
      - `status` (enum)
      - `max_teams` (integer)
      - `current_teams` (integer)
      - `entry_fee` (numeric)
      - `prize_pool` (text)
      - `registered_teams` (text array)
      - `organizer_id` (text)
      - `created_at` (timestamp)

  2. Security
    - Enable RLS on tournaments table
*/

CREATE TYPE tournament_type AS ENUM ('knockout', 'league', 'roundRobin');
CREATE TYPE tournament_status AS ENUM ('upcoming', 'ongoing', 'completed', 'cancelled');

CREATE TABLE IF NOT EXISTS tournaments (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  description text,
  start_date timestamp with time zone NOT NULL,
  end_date timestamp with time zone NOT NULL,
  location text NOT NULL,
  type tournament_type DEFAULT 'knockout',
  status tournament_status DEFAULT 'upcoming',
  max_teams integer DEFAULT 8,
  current_teams integer DEFAULT 0,
  entry_fee numeric DEFAULT 0,
  prize_pool text,
  registered_teams text[] DEFAULT ARRAY[]::text[],
  organizer_id text NOT NULL,
  created_at timestamp with time zone DEFAULT now()
);

ALTER TABLE tournaments ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view tournaments"
  ON tournaments FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Authenticated users can create tournaments"
  ON tournaments FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "Organizers can update tournaments"
  ON tournaments FOR UPDATE
  TO authenticated
  USING (organizer_id = auth.uid()::text)
  WITH CHECK (organizer_id = auth.uid()::text);

CREATE INDEX idx_tournaments_status ON tournaments(status);
CREATE INDEX idx_tournaments_dates ON tournaments(start_date, end_date);
CREATE INDEX idx_tournaments_location ON tournaments(location);
CREATE INDEX idx_tournaments_organizer ON tournaments(organizer_id);

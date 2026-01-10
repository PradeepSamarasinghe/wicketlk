/*
  # Create Teams Table

  1. New Tables
    - `teams` - Store team information
      - `id` (uuid, primary key)
      - `name` (text)
      - `location` (text)
      - `captain_id` (text)
      - `members` (text array)
      - `tournament_id` (uuid)
      - `total_matches` (integer)
      - `wins` (integer)
      - `losses` (integer)
      - `points` (integer)
      - `created_at` (timestamp)

  2. Security
    - Enable RLS on teams table
*/

CREATE TABLE IF NOT EXISTS teams (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  location text NOT NULL,
  captain_id text NOT NULL,
  members text[] DEFAULT ARRAY[]::text[],
  tournament_id uuid REFERENCES tournaments(id) ON DELETE CASCADE,
  total_matches integer DEFAULT 0,
  wins integer DEFAULT 0,
  losses integer DEFAULT 0,
  points integer DEFAULT 0,
  created_at timestamp with time zone DEFAULT now()
);

ALTER TABLE teams ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view teams"
  ON teams FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Authenticated users can create teams"
  ON teams FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "Team captains can update"
  ON teams FOR UPDATE
  TO authenticated
  USING (captain_id = auth.uid()::text)
  WITH CHECK (captain_id = auth.uid()::text);

CREATE INDEX idx_teams_tournament ON teams(tournament_id);
CREATE INDEX idx_teams_captain ON teams(captain_id);
CREATE INDEX idx_teams_location ON teams(location);

/*
  # Create Matches Table

  1. New Tables
    - `matches` - Store match information and scores
      - `id` (uuid, primary key)
      - `team1_id` (text)
      - `team2_id` (text)
      - `team1_name` (text)
      - `team2_name` (text)
      - `status` (enum)
      - `match_date` (timestamp)
      - `location` (text)
      - `overs` (integer)
      - `team1_score` (jsonb)
      - `team2_score` (jsonb)
      - `current_batting_team` (text)
      - `ball_by_ball` (jsonb array)
      - `created_at` (timestamp)

  2. Security
    - Enable RLS on matches table
*/

CREATE TYPE match_status AS ENUM ('upcoming', 'live', 'completed', 'cancelled');

CREATE TABLE IF NOT EXISTS matches (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  team1_id text NOT NULL,
  team2_id text NOT NULL,
  team1_name text NOT NULL,
  team2_name text NOT NULL,
  status match_status DEFAULT 'upcoming',
  match_date timestamp with time zone NOT NULL,
  location text,
  overs integer DEFAULT 20,
  team1_score jsonb DEFAULT '{
    "runs": 0,
    "wickets": 0,
    "overs": 0,
    "run_rate": 0
  }'::jsonb,
  team2_score jsonb DEFAULT '{
    "runs": 0,
    "wickets": 0,
    "overs": 0,
    "run_rate": 0
  }'::jsonb,
  current_batting_team text,
  ball_by_ball jsonb[] DEFAULT ARRAY[]::jsonb[],
  created_at timestamp with time zone DEFAULT now()
);

ALTER TABLE matches ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view matches"
  ON matches FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Authenticated users can create matches"
  ON matches FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "Match creators can update"
  ON matches FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (true);

CREATE INDEX idx_matches_status ON matches(status);
CREATE INDEX idx_matches_date ON matches(match_date);
CREATE INDEX idx_matches_teams ON matches(team1_id, team2_id);

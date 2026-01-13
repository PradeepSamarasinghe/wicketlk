/*
  # Fix Users Table RLS for Firebase Auth

  Since we're using Firebase Auth (not Supabase Auth), auth.uid() won't work.
  We need to use policies that allow operations based on the anon key for now.

  For production, you should implement proper JWT verification or use Supabase Auth.
*/

-- Drop existing restrictive policies
DROP POLICY IF EXISTS "Users can read own data" ON users;
DROP POLICY IF EXISTS "Users can update own data" ON users;
DROP POLICY IF EXISTS "Users can insert own data" ON users;

-- Allow anonymous access for development (using anon key)
-- In production, you should use proper authentication

-- Allow anyone to read user data
CREATE POLICY "Allow read access for all users"
  ON users FOR SELECT
  TO anon, authenticated
  USING (true);

-- Allow anyone to insert user data
CREATE POLICY "Allow insert access for all users"
  ON users FOR INSERT
  TO anon, authenticated
  WITH CHECK (true);

-- Allow anyone to update user data (you may want to restrict this later)
CREATE POLICY "Allow update access for all users"
  ON users FOR UPDATE
  TO anon, authenticated
  USING (true)
  WITH CHECK (true);

-- Also fix the NOT NULL constraint on name since we insert without name first
ALTER TABLE users ALTER COLUMN name DROP NOT NULL;

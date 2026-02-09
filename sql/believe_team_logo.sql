ALTER TYPE believe_team_logo.file_upload
  ADD ATTRIBUTE checksum_sha256 TEXT,
  ADD ATTRIBUTE content_type TEXT,
  ADD ATTRIBUTE file_id TEXT,
  ADD ATTRIBUTE filename TEXT,
  ADD ATTRIBUTE size_bytes BIGINT,
  ADD ATTRIBUTE uploaded_at TIMESTAMP;

CREATE OR REPLACE FUNCTION believe_team_logo.make_file_upload(
  checksum_sha256 TEXT,
  content_type TEXT,
  file_id TEXT,
  filename TEXT,
  size_bytes BIGINT,
  uploaded_at TIMESTAMP
)
RETURNS believe_team_logo.file_upload
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    checksum_sha256, content_type, file_id, filename, size_bytes, uploaded_at
  )::believe_team_logo.file_upload;
$$;

CREATE OR REPLACE FUNCTION believe_team_logo._delete(team_id TEXT, file_id TEXT)
RETURNS VOID
LANGUAGE plpython3u
AS $$
  GD["__believe_context__"].client.teams.logo.delete(
      team_id=team_id,
      file_id=file_id,
  )
$$;

CREATE OR REPLACE FUNCTION believe_team_logo.delete(team_id TEXT, file_id TEXT)
RETURNS VOID
LANGUAGE plpgsql
AS $$
  BEGIN
    PERFORM believe_internal.ensure_context();
    PERFORM believe_team_logo._delete(team_id, file_id);
  END;
$$;

CREATE OR REPLACE FUNCTION believe_team_logo._download(
  team_id TEXT, file_id TEXT
)
RETURNS JSONB
LANGUAGE plpython3u
STABLE
AS $$
  response = GD["__believe_context__"].client.teams.logo.with_raw_response.download(
      team_id=team_id,
      file_id=file_id,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION believe_team_logo.download(
  team_id TEXT, file_id TEXT
)
RETURNS JSONB
LANGUAGE plpgsql
STABLE
AS $$
  BEGIN
    PERFORM believe_internal.ensure_context();
    RETURN believe_team_logo._download(team_id, file_id);
  END;
$$;

CREATE OR REPLACE FUNCTION believe_team_logo._upload(team_id TEXT, "file" TEXT)
RETURNS JSONB
LANGUAGE plpython3u
AS $$
  response = GD["__believe_context__"].client.teams.logo.with_raw_response.upload(
      team_id=team_id,
      file=file,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION believe_team_logo.upload(team_id TEXT, "file" TEXT)
RETURNS believe_team_logo.file_upload
LANGUAGE plpgsql
AS $$
  BEGIN
    PERFORM believe_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::believe_team_logo.file_upload,
      believe_team_logo._upload(team_id, "file")
    );
  END;
$$;
CREATE OR REPLACE FUNCTION believe_matches_commentary._stream(match_id TEXT)
RETURNS JSONB
LANGUAGE plpython3u
AS $$
  response = GD["__believe_context__"].client.matches.commentary.with_raw_response.stream(
      match_id=match_id,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION believe_matches_commentary.stream(match_id TEXT)
RETURNS JSONB
LANGUAGE plpgsql
AS $$
  BEGIN
    PERFORM believe_internal.ensure_context();
    RETURN believe_matches_commentary._stream(match_id);
  END;
$$;
CREATE OR REPLACE FUNCTION believe_stream._test_connection()
RETURNS JSONB
LANGUAGE plpython3u
STABLE
AS $$
  response = GD["__believe_context__"].client.stream.with_raw_response.test_connection()

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION believe_stream.test_connection()
RETURNS JSONB
LANGUAGE plpgsql
STABLE
AS $$
  BEGIN
    PERFORM believe_internal.ensure_context();
    RETURN believe_stream._test_connection();
  END;
$$;
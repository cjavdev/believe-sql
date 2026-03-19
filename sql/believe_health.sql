CREATE OR REPLACE FUNCTION believe_health._check()
RETURNS JSONB
LANGUAGE plpython3u
STABLE
AS $$
  response = GD["__believe_context__"].client.health.with_raw_response.check()

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION believe_health.check()
RETURNS JSONB
LANGUAGE plpgsql
STABLE
AS $$
  BEGIN
    PERFORM believe_internal.ensure_context();
    RETURN believe_health._check();
  END;
$$;
CREATE OR REPLACE FUNCTION believe_client_w._test()
RETURNS VOID
LANGUAGE plpython3u
STABLE
AS $$
  GD["__believe_context__"].client.client.ws.test()
$$;

CREATE OR REPLACE FUNCTION believe_client_w.test()
RETURNS VOID
LANGUAGE plpgsql
STABLE
AS $$
  BEGIN
    PERFORM believe_internal.ensure_context();
    PERFORM believe_client_w._test();
  END;
$$;
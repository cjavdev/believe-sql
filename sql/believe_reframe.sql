ALTER TYPE believe_reframe.reframe_transform_negative_thoughts_response
  ADD ATTRIBUTE daily_affirmation TEXT,
  ADD ATTRIBUTE original_thought TEXT,
  ADD ATTRIBUTE reframed_thought TEXT,
  ADD ATTRIBUTE ted_perspective TEXT,
  ADD ATTRIBUTE dr_sharon_insight TEXT;

CREATE OR REPLACE FUNCTION believe_reframe.make_reframe_transform_negative_thoughts_response(
  daily_affirmation TEXT,
  original_thought TEXT,
  reframed_thought TEXT,
  ted_perspective TEXT,
  dr_sharon_insight TEXT DEFAULT NULL
)
RETURNS believe_reframe.reframe_transform_negative_thoughts_response
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    daily_affirmation,
    original_thought,
    reframed_thought,
    ted_perspective,
    dr_sharon_insight
  )::believe_reframe.reframe_transform_negative_thoughts_response;
$$;

CREATE OR REPLACE FUNCTION believe_reframe._transform_negative_thoughts(
  negative_thought TEXT, recurring BOOLEAN DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpython3u
AS $$
  from believe._types import not_given

  response = GD["__believe_context__"].client.reframe.with_raw_response.transform_negative_thoughts(
      negative_thought=negative_thought,
      recurring=not_given if recurring is None else recurring,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION believe_reframe.transform_negative_thoughts(
  negative_thought TEXT, recurring BOOLEAN DEFAULT NULL
)
RETURNS believe_reframe.reframe_transform_negative_thoughts_response
LANGUAGE plpgsql
AS $$
  BEGIN
    PERFORM believe_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::believe_reframe.reframe_transform_negative_thoughts_response,
      believe_reframe._transform_negative_thoughts(negative_thought, recurring)
    );
  END;
$$;
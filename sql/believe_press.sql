ALTER TYPE believe_press.press_simulate_response
  ADD ATTRIBUTE actual_wisdom TEXT,
  ADD ATTRIBUTE follow_up_dodge TEXT,
  ADD ATTRIBUTE reporter_reaction TEXT,
  ADD ATTRIBUTE response TEXT,
  ADD ATTRIBUTE deflection_humor TEXT;

CREATE OR REPLACE FUNCTION believe_press.make_press_simulate_response(
  actual_wisdom TEXT,
  follow_up_dodge TEXT,
  reporter_reaction TEXT,
  response TEXT,
  deflection_humor TEXT DEFAULT NULL
)
RETURNS believe_press.press_simulate_response
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    actual_wisdom,
    follow_up_dodge,
    reporter_reaction,
    response,
    deflection_humor
  )::believe_press.press_simulate_response;
$$;

CREATE OR REPLACE FUNCTION believe_press._simulate(
  question TEXT, hostile BOOLEAN DEFAULT NULL, topic TEXT DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpython3u
AS $$
  from believe._types import not_given

  response = GD["__believe_context__"].client.press.with_raw_response.simulate(
      question=question,
      hostile=not_given if hostile is None else hostile,
      topic=not_given if topic is None else topic,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION believe_press.simulate(
  question TEXT, hostile BOOLEAN DEFAULT NULL, topic TEXT DEFAULT NULL
)
RETURNS believe_press.press_simulate_response
LANGUAGE plpgsql
AS $$
  BEGIN
    PERFORM believe_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::believe_press.press_simulate_response,
      believe_press._simulate(question, hostile, topic)
    );
  END;
$$;
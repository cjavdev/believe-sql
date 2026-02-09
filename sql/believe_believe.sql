ALTER TYPE believe_believe.believe_submit_response
  ADD ATTRIBUTE action_suggestion TEXT,
  ADD ATTRIBUTE believe_score BIGINT,
  ADD ATTRIBUTE goldfish_wisdom TEXT,
  ADD ATTRIBUTE relevant_quote TEXT,
  ADD ATTRIBUTE ted_response TEXT;

CREATE OR REPLACE FUNCTION believe_believe.make_believe_submit_response(
  action_suggestion TEXT,
  believe_score BIGINT,
  goldfish_wisdom TEXT,
  relevant_quote TEXT,
  ted_response TEXT
)
RETURNS believe_believe.believe_submit_response
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    action_suggestion,
    believe_score,
    goldfish_wisdom,
    relevant_quote,
    ted_response
  )::believe_believe.believe_submit_response;
$$;

CREATE OR REPLACE FUNCTION believe_believe._submit(
  situation TEXT,
  situation_type TEXT,
  context TEXT DEFAULT NULL,
  intensity BIGINT DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpython3u
AS $$
  from believe._types import not_given

  response = GD["__believe_context__"].client.believe.with_raw_response.submit(
      situation=situation,
      situation_type=situation_type,
      context=not_given if context is None else context,
      intensity=not_given if intensity is None else intensity,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION believe_believe.submit(
  situation TEXT,
  situation_type TEXT,
  context TEXT DEFAULT NULL,
  intensity BIGINT DEFAULT NULL
)
RETURNS believe_believe.believe_submit_response
LANGUAGE plpgsql
AS $$
  BEGIN
    PERFORM believe_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::believe_believe.believe_submit_response,
      believe_believe._submit(situation, situation_type, context, intensity)
    );
  END;
$$;
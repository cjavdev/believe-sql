ALTER TYPE believe_conflict.conflict_resolve_response
  ADD ATTRIBUTE barbecue_sauce_wisdom TEXT,
  ADD ATTRIBUTE diagnosis TEXT,
  ADD ATTRIBUTE diamond_dogs_advice TEXT,
  ADD ATTRIBUTE potential_outcome TEXT,
  ADD ATTRIBUTE steps_to_resolution TEXT[],
  ADD ATTRIBUTE ted_approach TEXT;

CREATE OR REPLACE FUNCTION believe_conflict.make_conflict_resolve_response(
  barbecue_sauce_wisdom TEXT,
  diagnosis TEXT,
  diamond_dogs_advice TEXT,
  potential_outcome TEXT,
  steps_to_resolution TEXT[],
  ted_approach TEXT
)
RETURNS believe_conflict.conflict_resolve_response
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    barbecue_sauce_wisdom,
    diagnosis,
    diamond_dogs_advice,
    potential_outcome,
    steps_to_resolution,
    ted_approach
  )::believe_conflict.conflict_resolve_response;
$$;

CREATE OR REPLACE FUNCTION believe_conflict._resolve(
  conflict_type TEXT,
  description TEXT,
  parties_involved TEXT[],
  attempts_made TEXT[] DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpython3u
AS $$
  from believe._types import not_given

  response = GD["__believe_context__"].client.conflicts.with_raw_response.resolve(
      conflict_type=conflict_type,
      description=description,
      parties_involved=parties_involved,
      attempts_made=not_given if attempts_made is None else attempts_made,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION believe_conflict.resolve(
  conflict_type TEXT,
  description TEXT,
  parties_involved TEXT[],
  attempts_made TEXT[] DEFAULT NULL
)
RETURNS believe_conflict.conflict_resolve_response
LANGUAGE plpgsql
AS $$
  BEGIN
    PERFORM believe_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::believe_conflict.conflict_resolve_response,
      believe_conflict._resolve(
        conflict_type, description, parties_involved, attempts_made
      )
    );
  END;
$$;
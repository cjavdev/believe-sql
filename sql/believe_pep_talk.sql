ALTER TYPE believe_pep_talk.pep_talk_retrieve_response
  ADD ATTRIBUTE chunks believe_pep_talk.pep_talk_retrieve_response_chunk[],
  ADD ATTRIBUTE "text" TEXT;

CREATE OR REPLACE FUNCTION believe_pep_talk.make_pep_talk_retrieve_response(
  chunks believe_pep_talk.pep_talk_retrieve_response_chunk[], "text" TEXT
)
RETURNS believe_pep_talk.pep_talk_retrieve_response
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(chunks, "text")::believe_pep_talk.pep_talk_retrieve_response;
$$;

ALTER TYPE believe_pep_talk.pep_talk_retrieve_response_chunk
  ADD ATTRIBUTE chunk_id BIGINT,
  ADD ATTRIBUTE is_final BOOLEAN,
  ADD ATTRIBUTE "text" TEXT,
  ADD ATTRIBUTE emotional_beat TEXT;

CREATE OR REPLACE FUNCTION believe_pep_talk.make_pep_talk_retrieve_response_chunk(
  chunk_id BIGINT,
  is_final BOOLEAN,
  "text" TEXT,
  emotional_beat TEXT DEFAULT NULL
)
RETURNS believe_pep_talk.pep_talk_retrieve_response_chunk
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    chunk_id, is_final, "text", emotional_beat
  )::believe_pep_talk.pep_talk_retrieve_response_chunk;
$$;

CREATE OR REPLACE FUNCTION believe_pep_talk._retrieve(
  stream BOOLEAN DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpython3u
STABLE
AS $$
  from believe._types import not_given

  response = GD["__believe_context__"].client.pep_talk.with_raw_response.retrieve(
      stream=not_given if stream is None else stream,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION believe_pep_talk.retrieve(
  stream BOOLEAN DEFAULT NULL
)
RETURNS believe_pep_talk.pep_talk_retrieve_response
LANGUAGE plpgsql
STABLE
AS $$
  BEGIN
    PERFORM believe_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::believe_pep_talk.pep_talk_retrieve_response,
      believe_pep_talk._retrieve(stream)
    );
  END;
$$;
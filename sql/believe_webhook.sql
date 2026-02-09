ALTER TYPE believe_webhook.registered_webhook
  ADD ATTRIBUTE "id" TEXT,
  ADD ATTRIBUTE created_at TIMESTAMP,
  ADD ATTRIBUTE event_types TEXT[],
  ADD ATTRIBUTE secret TEXT,
  ADD ATTRIBUTE url TEXT,
  ADD ATTRIBUTE description TEXT;

CREATE OR REPLACE FUNCTION believe_webhook.make_registered_webhook(
  "id" TEXT,
  created_at TIMESTAMP,
  event_types TEXT[],
  secret TEXT,
  url TEXT,
  description TEXT DEFAULT NULL
)
RETURNS believe_webhook.registered_webhook
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    "id", created_at, event_types, secret, url, description
  )::believe_webhook.registered_webhook;
$$;

ALTER TYPE believe_webhook.webhook_create_response
  ADD ATTRIBUTE webhook believe_webhook.registered_webhook,
  ADD ATTRIBUTE message TEXT,
  ADD ATTRIBUTE ted_says TEXT;

CREATE OR REPLACE FUNCTION believe_webhook.make_webhook_create_response(
  webhook believe_webhook.registered_webhook,
  message TEXT DEFAULT NULL,
  ted_says TEXT DEFAULT NULL
)
RETURNS believe_webhook.webhook_create_response
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    webhook, message, ted_says
  )::believe_webhook.webhook_create_response;
$$;

ALTER TYPE believe_webhook.webhook_trigger_event_response
  ADD ATTRIBUTE deliveries believe_webhook.webhook_trigger_event_response_delivery[],
  ADD ATTRIBUTE event_id TEXT,
  ADD ATTRIBUTE event_type TEXT,
  ADD ATTRIBUTE successful_deliveries BIGINT,
  ADD ATTRIBUTE ted_says TEXT,
  ADD ATTRIBUTE total_webhooks BIGINT;

CREATE OR REPLACE FUNCTION believe_webhook.make_webhook_trigger_event_response(
  deliveries believe_webhook.webhook_trigger_event_response_delivery[],
  event_id TEXT,
  event_type TEXT,
  successful_deliveries BIGINT,
  ted_says TEXT,
  total_webhooks BIGINT
)
RETURNS believe_webhook.webhook_trigger_event_response
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    deliveries,
    event_id,
    event_type,
    successful_deliveries,
    ted_says,
    total_webhooks
  )::believe_webhook.webhook_trigger_event_response;
$$;

ALTER TYPE believe_webhook.webhook_trigger_event_response_delivery
  ADD ATTRIBUTE success BOOLEAN,
  ADD ATTRIBUTE url TEXT,
  ADD ATTRIBUTE webhook_id TEXT,
  ADD ATTRIBUTE "error" TEXT,
  ADD ATTRIBUTE status_code BIGINT;

CREATE OR REPLACE FUNCTION believe_webhook.make_webhook_trigger_event_response_delivery(
  success BOOLEAN,
  url TEXT,
  webhook_id TEXT,
  "error" TEXT DEFAULT NULL,
  status_code BIGINT DEFAULT NULL
)
RETURNS believe_webhook.webhook_trigger_event_response_delivery
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    success, url, webhook_id, "error", status_code
  )::believe_webhook.webhook_trigger_event_response_delivery;
$$;

ALTER TYPE believe_webhook.payload
  ADD ATTRIBUTE "data" believe_webhook.match_completed_data,
  ADD ATTRIBUTE event_type TEXT;

CREATE OR REPLACE FUNCTION believe_webhook.make_payload(
  "data" believe_webhook.match_completed_data, event_type TEXT DEFAULT NULL
)
RETURNS believe_webhook.payload
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW("data", event_type)::believe_webhook.payload;
$$;

ALTER TYPE believe_webhook.match_completed_data
  ADD ATTRIBUTE away_score BIGINT,
  ADD ATTRIBUTE away_team_id TEXT,
  ADD ATTRIBUTE completed_at TIMESTAMP,
  ADD ATTRIBUTE home_score BIGINT,
  ADD ATTRIBUTE home_team_id TEXT,
  ADD ATTRIBUTE match_id TEXT,
  ADD ATTRIBUTE match_type TEXT,
  ADD ATTRIBUTE "result" TEXT,
  ADD ATTRIBUTE ted_post_match_quote TEXT,
  ADD ATTRIBUTE lesson_learned TEXT,
  ADD ATTRIBUTE man_of_the_match TEXT,
  ADD ATTRIBUTE character_id TEXT,
  ADD ATTRIBUTE character_name TEXT,
  ADD ATTRIBUTE member_type TEXT,
  ADD ATTRIBUTE team_id TEXT,
  ADD ATTRIBUTE team_member_id TEXT,
  ADD ATTRIBUTE team_name TEXT,
  ADD ATTRIBUTE ted_reaction TEXT,
  ADD ATTRIBUTE transfer_type TEXT,
  ADD ATTRIBUTE previous_team_id TEXT,
  ADD ATTRIBUTE previous_team_name TEXT,
  ADD ATTRIBUTE transfer_fee_gbp TEXT,
  ADD ATTRIBUTE years_with_previous_team BIGINT;

CREATE OR REPLACE FUNCTION believe_webhook.make_match_completed_data(
  away_score BIGINT DEFAULT NULL,
  away_team_id TEXT DEFAULT NULL,
  completed_at TIMESTAMP DEFAULT NULL,
  home_score BIGINT DEFAULT NULL,
  home_team_id TEXT DEFAULT NULL,
  match_id TEXT DEFAULT NULL,
  match_type TEXT DEFAULT NULL,
  "result" TEXT DEFAULT NULL,
  ted_post_match_quote TEXT DEFAULT NULL,
  lesson_learned TEXT DEFAULT NULL,
  man_of_the_match TEXT DEFAULT NULL,
  character_id TEXT DEFAULT NULL,
  character_name TEXT DEFAULT NULL,
  member_type TEXT DEFAULT NULL,
  team_id TEXT DEFAULT NULL,
  team_member_id TEXT DEFAULT NULL,
  team_name TEXT DEFAULT NULL,
  ted_reaction TEXT DEFAULT NULL,
  transfer_type TEXT DEFAULT NULL,
  previous_team_id TEXT DEFAULT NULL,
  previous_team_name TEXT DEFAULT NULL,
  transfer_fee_gbp TEXT DEFAULT NULL,
  years_with_previous_team BIGINT DEFAULT NULL
)
RETURNS believe_webhook.match_completed_data
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    away_score,
    away_team_id,
    completed_at,
    home_score,
    home_team_id,
    match_id,
    match_type,
    "result",
    ted_post_match_quote,
    lesson_learned,
    man_of_the_match,
    character_id,
    character_name,
    member_type,
    team_id,
    team_member_id,
    team_name,
    ted_reaction,
    transfer_type,
    previous_team_id,
    previous_team_name,
    transfer_fee_gbp,
    years_with_previous_team
  )::believe_webhook.match_completed_data;
$$;

CREATE OR REPLACE FUNCTION believe_webhook._create(
  url TEXT, description TEXT DEFAULT NULL, event_types TEXT[] DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpython3u
AS $$
  from believe._types import not_given

  response = GD["__believe_context__"].client.webhooks.with_raw_response.create(
      url=url,
      description=not_given if description is None else description,
      event_types=not_given if event_types is None else event_types,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION believe_webhook.create(
  url TEXT, description TEXT DEFAULT NULL, event_types TEXT[] DEFAULT NULL
)
RETURNS believe_webhook.webhook_create_response
LANGUAGE plpgsql
AS $$
  BEGIN
    PERFORM believe_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::believe_webhook.webhook_create_response,
      believe_webhook._create(url, description, event_types)
    );
  END;
$$;

CREATE OR REPLACE FUNCTION believe_webhook._retrieve(webhook_id TEXT)
RETURNS JSONB
LANGUAGE plpython3u
STABLE
AS $$
  response = GD["__believe_context__"].client.webhooks.with_raw_response.retrieve(
      webhook_id=webhook_id,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION believe_webhook.retrieve(webhook_id TEXT)
RETURNS believe_webhook.registered_webhook
LANGUAGE plpgsql
STABLE
AS $$
  BEGIN
    PERFORM believe_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::believe_webhook.registered_webhook,
      believe_webhook._retrieve(webhook_id)
    );
  END;
$$;

CREATE OR REPLACE FUNCTION believe_webhook._list()
RETURNS JSONB
LANGUAGE plpython3u
STABLE
AS $$
  response = GD["__believe_context__"].client.webhooks.with_raw_response.list()

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION believe_webhook.list()
RETURNS SETOF believe_webhook.registered_webhook
LANGUAGE plpgsql
STABLE
AS $$
  BEGIN
    PERFORM believe_internal.ensure_context();
    RETURN QUERY SELECT * FROM jsonb_populate_recordset(
      NULL::believe_webhook.registered_webhook, believe_webhook._list()
    );
  END;
$$;

CREATE OR REPLACE FUNCTION believe_webhook._delete(webhook_id TEXT)
RETURNS JSONB
LANGUAGE plpython3u
AS $$
  response = GD["__believe_context__"].client.webhooks.with_raw_response.delete(
      webhook_id=webhook_id,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION believe_webhook.delete(webhook_id TEXT)
RETURNS JSONB
LANGUAGE plpgsql
AS $$
  BEGIN
    PERFORM believe_internal.ensure_context();
    RETURN believe_webhook._delete(webhook_id);
  END;
$$;

CREATE OR REPLACE FUNCTION believe_webhook._trigger_event(
  event_type TEXT, payload believe_webhook.payload DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpython3u
AS $$
  from believe._types import not_given

  response = GD["__believe_context__"].client.webhooks.with_raw_response.trigger_event(
      event_type=event_type,
      payload=not_given if payload is None else GD["__believe_context__"].strip_none(payload),
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION believe_webhook.trigger_event(
  event_type TEXT, payload believe_webhook.payload DEFAULT NULL
)
RETURNS believe_webhook.webhook_trigger_event_response
LANGUAGE plpgsql
AS $$
  BEGIN
    PERFORM believe_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::believe_webhook.webhook_trigger_event_response,
      believe_webhook._trigger_event(event_type, payload)
    );
  END;
$$;
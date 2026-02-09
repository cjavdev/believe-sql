-- A file that declares all schemas and types upfront so that their definitions don't
-- have to be topologically sorted in other files. It also creates some internal utility functions.

CREATE SCHEMA IF NOT EXISTS believe_internal;
REVOKE ALL ON SCHEMA believe_internal FROM PUBLIC;

CREATE OR REPLACE FUNCTION believe_internal.ensure_empty_type(
  p_schema TEXT,
  p_type TEXT
)
RETURNS void
LANGUAGE plpgsql
AS $$
  DECLARE
    attr RECORD;
  BEGIN
    -- Create an empty type if it doesn't exist from a previous extension version.
    IF NOT EXISTS (
      SELECT 1
      FROM pg_type t
      JOIN pg_namespace n ON n.oid = t.typnamespace
      WHERE t.typname = p_type
        AND n.nspname = p_schema
    ) THEN
      EXECUTE format(
        'CREATE TYPE %I.%I AS ();',
        p_schema,
        p_type
      );
      -- Already empty, nothing to drop.
      RETURN;
    END IF;

    -- Drop all existing attributes from the previous extension version so we can readd them.
    FOR attr IN
      SELECT a.attname
      FROM pg_attribute a
      JOIN pg_type t ON t.typrelid = a.attrelid
      JOIN pg_namespace n ON n.oid = t.typnamespace
      WHERE t.typname = p_type
        AND n.nspname = p_schema
        AND a.attnum > 0
        AND NOT a.attisdropped
      ORDER BY a.attnum DESC
    LOOP
      EXECUTE format(
        'ALTER TYPE %I.%I DROP ATTRIBUTE %I;',
        p_schema,
        p_type,
        attr.attname
      );
    END LOOP;
  END;
$$;

CREATE OR REPLACE FUNCTION believe_internal.ensure_context()
RETURNS void
LANGUAGE plpython3u
AS $$
  from types import SimpleNamespace
  from believe import Believe

  if "__believe_context__" in GD:
      # The context was already created.
      return

  client_options = {}
  try:
      value = plpy.execute("SELECT current_setting('believe.base_url') AS value")[0]['value']
      client_options["base_url"] = value
  except Exception:
      # This configuration parameter was not set, but it's optional so ignore the exception.
      pass
  try:
      value = plpy.execute("SELECT current_setting('believe.api_key') AS value")[0]['value']
      client_options["api_key"] = value
  except Exception:
      plpy.warning(
        "Required DB config parameter 'believe.api_key' is not set",
        hint="ALTER DATABASE my_database SET believe.api_key = ...;"
      )

  def strip_none(value):
      if isinstance(value, dict):
          return {
              k: strip_none(v)
              for k, v in value.items()
              if v is not None
          }
      elif isinstance(value, list):
          return [strip_none(v) for v in value]
      else:
          return value

  GD["__believe_context__"] = SimpleNamespace(
      client=Believe(**client_options),
      strip_none=strip_none,
  )
$$;

CREATE TYPE believe_internal.page AS (
  "data" JSONB,
  next_request_options JSONB
);

CREATE SCHEMA IF NOT EXISTS believe;

CREATE SCHEMA IF NOT EXISTS believe_character;

CREATE TYPE believe_character.character AS ();
CREATE TYPE believe_character.emotional_stats AS ();
CREATE TYPE believe_character.growth_arc AS ();

CREATE SCHEMA IF NOT EXISTS believe_team;

CREATE TYPE believe_team.geo_location AS ();
CREATE TYPE believe_team.team AS ();
CREATE TYPE believe_team.team_values AS ();

CREATE SCHEMA IF NOT EXISTS believe_team_logo;

CREATE TYPE believe_team_logo.file_upload AS ();

CREATE SCHEMA IF NOT EXISTS believe_match;

CREATE TYPE believe_match.match AS ();
CREATE TYPE believe_match.turning_point AS ();

CREATE SCHEMA IF NOT EXISTS believe_match_commentary;

CREATE SCHEMA IF NOT EXISTS believe_episode;

CREATE TYPE believe_episode.episode AS ();
CREATE TYPE believe_episode.paginated_response AS ();

CREATE SCHEMA IF NOT EXISTS believe_quote;

CREATE TYPE believe_quote.paginated_response_quote AS ();
CREATE TYPE believe_quote.quote AS ();

CREATE SCHEMA IF NOT EXISTS believe_believe;

CREATE TYPE believe_believe.believe_submit_response AS ();

CREATE SCHEMA IF NOT EXISTS believe_conflict;

CREATE TYPE believe_conflict.conflict_resolve_response AS ();

CREATE SCHEMA IF NOT EXISTS believe_reframe;

CREATE TYPE believe_reframe.reframe_transform_negative_thoughts_response AS ();

CREATE SCHEMA IF NOT EXISTS believe_press;

CREATE TYPE believe_press.press_simulate_response AS ();

CREATE SCHEMA IF NOT EXISTS believe_coaching_principle;

CREATE TYPE believe_coaching_principle.coaching_principle AS ();

CREATE SCHEMA IF NOT EXISTS believe_biscuit;

CREATE TYPE believe_biscuit.biscuit AS ();

CREATE SCHEMA IF NOT EXISTS believe_pep_talk;

CREATE TYPE believe_pep_talk.pep_talk_retrieve_response AS ();
CREATE TYPE believe_pep_talk.pep_talk_retrieve_response_chunk AS ();

CREATE SCHEMA IF NOT EXISTS believe_stream;

CREATE SCHEMA IF NOT EXISTS believe_team_member;

CREATE TYPE believe_team_member.coach AS ();
CREATE TYPE believe_team_member.equipment_manager AS ();
CREATE TYPE believe_team_member.medical_staff AS ();
CREATE TYPE believe_team_member.player AS ();
CREATE TYPE believe_team_member.team_member_create_response AS ();
CREATE TYPE believe_team_member.team_member_retrieve_response AS ();
CREATE TYPE believe_team_member.team_member_update_response AS ();
CREATE TYPE believe_team_member.team_member_list_response AS ();
CREATE TYPE believe_team_member.team_member_list_staff_response AS ();
CREATE TYPE believe_team_member.member AS ();
CREATE TYPE believe_team_member.update AS ();

CREATE SCHEMA IF NOT EXISTS believe_webhook;

CREATE TYPE believe_webhook.registered_webhook AS ();
CREATE TYPE believe_webhook.webhook_create_response AS ();
CREATE TYPE believe_webhook.webhook_trigger_event_response AS ();
CREATE TYPE believe_webhook.webhook_trigger_event_response_delivery AS ();
CREATE TYPE believe_webhook.payload AS ();
CREATE TYPE believe_webhook.match_completed_data AS ();

CREATE SCHEMA IF NOT EXISTS believe_health;

CREATE SCHEMA IF NOT EXISTS believe_version;

CREATE SCHEMA IF NOT EXISTS believe_client_w;
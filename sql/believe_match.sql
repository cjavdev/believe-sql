ALTER TYPE believe_match.match
  ADD ATTRIBUTE "id" TEXT,
  ADD ATTRIBUTE away_team_id TEXT,
  ADD ATTRIBUTE "date" TIMESTAMP,
  ADD ATTRIBUTE home_team_id TEXT,
  ADD ATTRIBUTE match_type TEXT,
  ADD ATTRIBUTE attendance BIGINT,
  ADD ATTRIBUTE away_score BIGINT,
  ADD ATTRIBUTE episode_id TEXT,
  ADD ATTRIBUTE home_score BIGINT,
  ADD ATTRIBUTE lesson_learned TEXT,
  ADD ATTRIBUTE possession_percentage DOUBLE PRECISION,
  ADD ATTRIBUTE "result" TEXT,
  ADD ATTRIBUTE ted_halftime_speech TEXT,
  ADD ATTRIBUTE ticket_revenue_gbp TEXT,
  ADD ATTRIBUTE turning_points believe_match.turning_point[],
  ADD ATTRIBUTE weather_temp_celsius DOUBLE PRECISION;

CREATE OR REPLACE FUNCTION believe_match.make_match(
  "id" TEXT,
  away_team_id TEXT,
  "date" TIMESTAMP,
  home_team_id TEXT,
  match_type TEXT,
  attendance BIGINT DEFAULT NULL,
  away_score BIGINT DEFAULT NULL,
  episode_id TEXT DEFAULT NULL,
  home_score BIGINT DEFAULT NULL,
  lesson_learned TEXT DEFAULT NULL,
  possession_percentage DOUBLE PRECISION DEFAULT NULL,
  "result" TEXT DEFAULT NULL,
  ted_halftime_speech TEXT DEFAULT NULL,
  ticket_revenue_gbp TEXT DEFAULT NULL,
  turning_points believe_match.turning_point[] DEFAULT NULL,
  weather_temp_celsius DOUBLE PRECISION DEFAULT NULL
)
RETURNS believe_match.match
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    "id",
    away_team_id,
    "date",
    home_team_id,
    match_type,
    attendance,
    away_score,
    episode_id,
    home_score,
    lesson_learned,
    possession_percentage,
    "result",
    ted_halftime_speech,
    ticket_revenue_gbp,
    turning_points,
    weather_temp_celsius
  )::believe_match.match;
$$;

ALTER TYPE believe_match.turning_point
  ADD ATTRIBUTE description TEXT,
  ADD ATTRIBUTE emotional_impact TEXT,
  ADD ATTRIBUTE "minute" BIGINT,
  ADD ATTRIBUTE character_involved TEXT;

CREATE OR REPLACE FUNCTION believe_match.make_turning_point(
  description TEXT,
  emotional_impact TEXT,
  "minute" BIGINT,
  character_involved TEXT DEFAULT NULL
)
RETURNS believe_match.turning_point
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    description, emotional_impact, "minute", character_involved
  )::believe_match.turning_point;
$$;

CREATE OR REPLACE FUNCTION believe_match._create(
  away_team_id TEXT,
  "date" TIMESTAMP,
  home_team_id TEXT,
  match_type TEXT,
  attendance BIGINT DEFAULT NULL,
  away_score BIGINT DEFAULT NULL,
  episode_id TEXT DEFAULT NULL,
  home_score BIGINT DEFAULT NULL,
  lesson_learned TEXT DEFAULT NULL,
  possession_percentage DOUBLE PRECISION DEFAULT NULL,
  "result" TEXT DEFAULT NULL,
  ted_halftime_speech TEXT DEFAULT NULL,
  ticket_revenue_gbp JSONB DEFAULT NULL,
  turning_points believe_match.turning_point[] DEFAULT NULL,
  weather_temp_celsius DOUBLE PRECISION DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpython3u
AS $$
  import json
  from believe._types import not_given

  response = GD["__believe_context__"].client.matches.with_raw_response.create(
      away_team_id=away_team_id,
      date=date,
      home_team_id=home_team_id,
      match_type=match_type,
      attendance=not_given if attendance is None else attendance,
      away_score=not_given if away_score is None else away_score,
      episode_id=not_given if episode_id is None else episode_id,
      home_score=not_given if home_score is None else home_score,
      lesson_learned=not_given if lesson_learned is None else lesson_learned,
      possession_percentage=not_given if possession_percentage is None else possession_percentage,
      result=not_given if result is None else result,
      ted_halftime_speech=not_given if ted_halftime_speech is None else ted_halftime_speech,
      ticket_revenue_gbp=not_given if ticket_revenue_gbp is None else json.loads(ticket_revenue_gbp),
      turning_points=not_given if turning_points is None else GD["__believe_context__"].strip_none(turning_points),
      weather_temp_celsius=not_given if weather_temp_celsius is None else weather_temp_celsius,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION believe_match.create(
  away_team_id TEXT,
  "date" TIMESTAMP,
  home_team_id TEXT,
  match_type TEXT,
  attendance BIGINT DEFAULT NULL,
  away_score BIGINT DEFAULT NULL,
  episode_id TEXT DEFAULT NULL,
  home_score BIGINT DEFAULT NULL,
  lesson_learned TEXT DEFAULT NULL,
  possession_percentage DOUBLE PRECISION DEFAULT NULL,
  "result" TEXT DEFAULT NULL,
  ted_halftime_speech TEXT DEFAULT NULL,
  ticket_revenue_gbp JSONB DEFAULT NULL,
  turning_points believe_match.turning_point[] DEFAULT NULL,
  weather_temp_celsius DOUBLE PRECISION DEFAULT NULL
)
RETURNS believe_match.match
LANGUAGE plpgsql
AS $$
  BEGIN
    PERFORM believe_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::believe_match.match,
      believe_match._create(
        away_team_id,
        "date",
        home_team_id,
        match_type,
        attendance,
        away_score,
        episode_id,
        home_score,
        lesson_learned,
        possession_percentage,
        "result",
        ted_halftime_speech,
        ticket_revenue_gbp,
        turning_points,
        weather_temp_celsius
      )
    );
  END;
$$;

CREATE OR REPLACE FUNCTION believe_match._retrieve(match_id TEXT)
RETURNS JSONB
LANGUAGE plpython3u
STABLE
AS $$
  response = GD["__believe_context__"].client.matches.with_raw_response.retrieve(
      match_id=match_id,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION believe_match.retrieve(match_id TEXT)
RETURNS believe_match.match
LANGUAGE plpgsql
STABLE
AS $$
  BEGIN
    PERFORM believe_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::believe_match.match, believe_match._retrieve(match_id)
    );
  END;
$$;

CREATE OR REPLACE FUNCTION believe_match._update(
  match_id TEXT,
  attendance BIGINT DEFAULT NULL,
  away_score BIGINT DEFAULT NULL,
  away_team_id TEXT DEFAULT NULL,
  "date" TIMESTAMP DEFAULT NULL,
  episode_id TEXT DEFAULT NULL,
  home_score BIGINT DEFAULT NULL,
  home_team_id TEXT DEFAULT NULL,
  lesson_learned TEXT DEFAULT NULL,
  match_type TEXT DEFAULT NULL,
  possession_percentage DOUBLE PRECISION DEFAULT NULL,
  "result" TEXT DEFAULT NULL,
  ted_halftime_speech TEXT DEFAULT NULL,
  ticket_revenue_gbp JSONB DEFAULT NULL,
  turning_points believe_match.turning_point[] DEFAULT NULL,
  weather_temp_celsius DOUBLE PRECISION DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpython3u
AS $$
  import json
  from believe._types import not_given

  response = GD["__believe_context__"].client.matches.with_raw_response.update(
      match_id=match_id,
      attendance=not_given if attendance is None else attendance,
      away_score=not_given if away_score is None else away_score,
      away_team_id=not_given if away_team_id is None else away_team_id,
      date=not_given if date is None else date,
      episode_id=not_given if episode_id is None else episode_id,
      home_score=not_given if home_score is None else home_score,
      home_team_id=not_given if home_team_id is None else home_team_id,
      lesson_learned=not_given if lesson_learned is None else lesson_learned,
      match_type=not_given if match_type is None else match_type,
      possession_percentage=not_given if possession_percentage is None else possession_percentage,
      result=not_given if result is None else result,
      ted_halftime_speech=not_given if ted_halftime_speech is None else ted_halftime_speech,
      ticket_revenue_gbp=not_given if ticket_revenue_gbp is None else json.loads(ticket_revenue_gbp),
      turning_points=not_given if turning_points is None else GD["__believe_context__"].strip_none(turning_points),
      weather_temp_celsius=not_given if weather_temp_celsius is None else weather_temp_celsius,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION believe_match.update(
  match_id TEXT,
  attendance BIGINT DEFAULT NULL,
  away_score BIGINT DEFAULT NULL,
  away_team_id TEXT DEFAULT NULL,
  "date" TIMESTAMP DEFAULT NULL,
  episode_id TEXT DEFAULT NULL,
  home_score BIGINT DEFAULT NULL,
  home_team_id TEXT DEFAULT NULL,
  lesson_learned TEXT DEFAULT NULL,
  match_type TEXT DEFAULT NULL,
  possession_percentage DOUBLE PRECISION DEFAULT NULL,
  "result" TEXT DEFAULT NULL,
  ted_halftime_speech TEXT DEFAULT NULL,
  ticket_revenue_gbp JSONB DEFAULT NULL,
  turning_points believe_match.turning_point[] DEFAULT NULL,
  weather_temp_celsius DOUBLE PRECISION DEFAULT NULL
)
RETURNS believe_match.match
LANGUAGE plpgsql
AS $$
  BEGIN
    PERFORM believe_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::believe_match.match,
      believe_match._update(
        match_id,
        attendance,
        away_score,
        away_team_id,
        "date",
        episode_id,
        home_score,
        home_team_id,
        lesson_learned,
        match_type,
        possession_percentage,
        "result",
        ted_halftime_speech,
        ticket_revenue_gbp,
        turning_points,
        weather_temp_celsius
      )
    );
  END;
$$;

CREATE OR REPLACE FUNCTION believe_match._list_first_page_py(
  "limit" BIGINT DEFAULT NULL,
  match_type TEXT DEFAULT NULL,
  "result" TEXT DEFAULT NULL,
  "skip" BIGINT DEFAULT NULL,
  team_id TEXT DEFAULT NULL
)
RETURNS believe_internal.page
LANGUAGE plpython3u
STABLE
AS $$
  from believe._types import not_given
  from pydantic import TypeAdapter
  from typing import Any

  page = GD["__believe_context__"].client.matches.list(
      limit=not_given if limit is None else limit,
      match_type=not_given if match_type is None else match_type,
      result=not_given if result is None else result,
      skip=not_given if skip is None else skip,
      team_id=not_given if team_id is None else team_id,
  )
  next_page_info = page.next_page_info()
  if next_page_info is None:
      next_request_options = None
  else:
      next_request_options = page._info_to_options(next_page_info).model_dump_json(
        exclude_unset=True,
        exclude={'post_parser'}
      )

  # We convert to JSON instead of letting PL/Python perform data mapping because PL/Python errors for
  # omitted fields instead of defaulting them to NULL, but we want to be more lenient, which we handle
  # in the calling function later.
  type_adapter = TypeAdapter(Any)
  return (
    type_adapter.dump_json(page._get_page_items(), exclude_unset=True).decode("utf-8"),
    next_request_options
  )
$$;

-- A simpler wrapper around `believe_match._list_first_page` that ensures the global client is initialized.
CREATE OR REPLACE FUNCTION believe_match._list_first_page(
  "limit" BIGINT DEFAULT NULL,
  match_type TEXT DEFAULT NULL,
  "result" TEXT DEFAULT NULL,
  "skip" BIGINT DEFAULT NULL,
  team_id TEXT DEFAULT NULL
)
RETURNS believe_internal.page
LANGUAGE plpgsql
STABLE
AS $$
  BEGIN
    PERFORM believe_internal.ensure_context();
    RETURN believe_match._list_first_page_py(
      "limit", match_type, "result", "skip", team_id
    );
  END;
$$;

CREATE OR REPLACE FUNCTION believe_match._list_next_page(request_options JSONB)
RETURNS believe_internal.page
LANGUAGE plpython3u
STABLE
AS $$
  import json
  from believe.types import Match
  from believe.pagination import SyncSkipLimitPage
  from believe._models import FinalRequestOptions
  from pydantic import TypeAdapter
  from typing import Any

  page = GD["__believe_context__"].client._request_api_list(
    model=Match,
    page=SyncSkipLimitPage[Match],
    options=FinalRequestOptions.construct(**json.loads(request_options))
  )
  next_page_info = page.next_page_info()
  if next_page_info is None:
      next_request_options = None
  else:
      next_request_options = page._info_to_options(next_page_info).model_dump_json(
        exclude_unset=True,
        exclude={'post_parser'}
      )

  # We convert to JSON instead of letting PL/Python perform data mapping because PL/Python errors for
  # omitted fields instead of defaulting them to NULL, but we want to be more lenient, which we handle
  # in the calling function later.
  type_adapter = TypeAdapter(Any)
  return (
    type_adapter.dump_json(page._get_page_items(), exclude_unset=True).decode("utf-8"),
    next_request_options
  )
$$;

CREATE OR REPLACE FUNCTION believe_match.list(
  "limit" BIGINT DEFAULT NULL,
  match_type TEXT DEFAULT NULL,
  "result" TEXT DEFAULT NULL,
  "skip" BIGINT DEFAULT NULL,
  team_id TEXT DEFAULT NULL
)
RETURNS SETOF believe_match.match
LANGUAGE SQL
STABLE
AS $$
  WITH RECURSIVE paginated AS (
    SELECT page.*
    FROM believe_match._list_first_page(
      "limit", match_type, "result", "skip", team_id
    ) AS page

    UNION ALL

    SELECT page.*
    FROM paginated
    CROSS JOIN believe_match._list_next_page(paginated.next_request_options) AS page
    WHERE paginated.next_request_options IS NOT NULL
  )
  SELECT (jsonb_populate_recordset(NULL::believe_match.match, "data")).* FROM paginated;
$$;

CREATE OR REPLACE FUNCTION believe_match._delete(match_id TEXT)
RETURNS VOID
LANGUAGE plpython3u
AS $$
  GD["__believe_context__"].client.matches.delete(
      match_id=match_id,
  )
$$;

CREATE OR REPLACE FUNCTION believe_match.delete(match_id TEXT)
RETURNS VOID
LANGUAGE plpgsql
AS $$
  BEGIN
    PERFORM believe_internal.ensure_context();
    PERFORM believe_match._delete(match_id);
  END;
$$;

CREATE OR REPLACE FUNCTION believe_match._get_lesson(match_id TEXT)
RETURNS JSONB
LANGUAGE plpython3u
STABLE
AS $$
  response = GD["__believe_context__"].client.matches.with_raw_response.get_lesson(
      match_id=match_id,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION believe_match.get_lesson(match_id TEXT)
RETURNS JSONB
LANGUAGE plpgsql
STABLE
AS $$
  BEGIN
    PERFORM believe_internal.ensure_context();
    RETURN believe_match._get_lesson(match_id);
  END;
$$;

CREATE OR REPLACE FUNCTION believe_match._get_turning_points(match_id TEXT)
RETURNS JSONB
LANGUAGE plpython3u
STABLE
AS $$
  response = GD["__believe_context__"].client.matches.with_raw_response.get_turning_points(
      match_id=match_id,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION believe_match.get_turning_points(match_id TEXT)
RETURNS SETOF JSONB
LANGUAGE plpgsql
STABLE
AS $$
  BEGIN
    PERFORM believe_internal.ensure_context();
    RETURN believe_match._get_turning_points(match_id);
  END;
$$;

CREATE OR REPLACE FUNCTION believe_match._stream_live(
  away_team TEXT DEFAULT NULL,
  excitement_level BIGINT DEFAULT NULL,
  home_team TEXT DEFAULT NULL,
  speed DOUBLE PRECISION DEFAULT NULL
)
RETURNS VOID
LANGUAGE plpython3u
STABLE
AS $$
  from believe._types import not_given

  GD["__believe_context__"].client.matches.stream_live(
      away_team=not_given if away_team is None else away_team,
      excitement_level=not_given if excitement_level is None else excitement_level,
      home_team=not_given if home_team is None else home_team,
      speed=not_given if speed is None else speed,
  )
$$;

CREATE OR REPLACE FUNCTION believe_match.stream_live(
  away_team TEXT DEFAULT NULL,
  excitement_level BIGINT DEFAULT NULL,
  home_team TEXT DEFAULT NULL,
  speed DOUBLE PRECISION DEFAULT NULL
)
RETURNS VOID
LANGUAGE plpgsql
STABLE
AS $$
  BEGIN
    PERFORM believe_internal.ensure_context();
    PERFORM believe_match._stream_live(
      away_team, excitement_level, home_team, speed
    );
  END;
$$;
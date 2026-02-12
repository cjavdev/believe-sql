ALTER TYPE believe_teams.geo_location
  ADD ATTRIBUTE latitude DOUBLE PRECISION,
  ADD ATTRIBUTE longitude DOUBLE PRECISION;

CREATE OR REPLACE FUNCTION believe_teams.make_geo_location(
  latitude DOUBLE PRECISION, longitude DOUBLE PRECISION
)
RETURNS believe_teams.geo_location
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(latitude, longitude)::believe_teams.geo_location;
$$;

ALTER TYPE believe_teams.team
  ADD ATTRIBUTE "id" TEXT,
  ADD ATTRIBUTE culture_score BIGINT,
  ADD ATTRIBUTE founded_year BIGINT,
  ADD ATTRIBUTE league TEXT,
  ADD ATTRIBUTE "name" TEXT,
  ADD ATTRIBUTE stadium TEXT,
  ADD ATTRIBUTE "values" believe_teams.team_values,
  ADD ATTRIBUTE annual_budget_gbp TEXT,
  ADD ATTRIBUTE average_attendance DOUBLE PRECISION,
  ADD ATTRIBUTE contact_email TEXT,
  ADD ATTRIBUTE is_active BOOLEAN,
  ADD ATTRIBUTE nickname TEXT,
  ADD ATTRIBUTE primary_color TEXT,
  ADD ATTRIBUTE rival_teams TEXT[],
  ADD ATTRIBUTE secondary_color TEXT,
  ADD ATTRIBUTE stadium_location believe_teams.geo_location,
  ADD ATTRIBUTE website TEXT,
  ADD ATTRIBUTE win_percentage DOUBLE PRECISION;

CREATE OR REPLACE FUNCTION believe_teams.make_team(
  "id" TEXT,
  culture_score BIGINT,
  founded_year BIGINT,
  league TEXT,
  "name" TEXT,
  stadium TEXT,
  "values" believe_teams.team_values,
  annual_budget_gbp TEXT DEFAULT NULL,
  average_attendance DOUBLE PRECISION DEFAULT NULL,
  contact_email TEXT DEFAULT NULL,
  is_active BOOLEAN DEFAULT NULL,
  nickname TEXT DEFAULT NULL,
  primary_color TEXT DEFAULT NULL,
  rival_teams TEXT[] DEFAULT NULL,
  secondary_color TEXT DEFAULT NULL,
  stadium_location believe_teams.geo_location DEFAULT NULL,
  website TEXT DEFAULT NULL,
  win_percentage DOUBLE PRECISION DEFAULT NULL
)
RETURNS believe_teams.team
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    "id",
    culture_score,
    founded_year,
    league,
    "name",
    stadium,
    "values",
    annual_budget_gbp,
    average_attendance,
    contact_email,
    is_active,
    nickname,
    primary_color,
    rival_teams,
    secondary_color,
    stadium_location,
    website,
    win_percentage
  )::believe_teams.team;
$$;

ALTER TYPE believe_teams.team_values
  ADD ATTRIBUTE primary_value TEXT,
  ADD ATTRIBUTE secondary_values TEXT[],
  ADD ATTRIBUTE team_motto TEXT;

CREATE OR REPLACE FUNCTION believe_teams.make_team_values(
  primary_value TEXT, secondary_values TEXT[], team_motto TEXT
)
RETURNS believe_teams.team_values
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    primary_value, secondary_values, team_motto
  )::believe_teams.team_values;
$$;

CREATE OR REPLACE FUNCTION believe_teams._create(
  culture_score BIGINT,
  founded_year BIGINT,
  league TEXT,
  "name" TEXT,
  stadium TEXT,
  "values" believe_teams.team_values,
  annual_budget_gbp JSONB DEFAULT NULL,
  average_attendance DOUBLE PRECISION DEFAULT NULL,
  contact_email TEXT DEFAULT NULL,
  is_active BOOLEAN DEFAULT NULL,
  nickname TEXT DEFAULT NULL,
  primary_color TEXT DEFAULT NULL,
  rival_teams TEXT[] DEFAULT NULL,
  secondary_color TEXT DEFAULT NULL,
  stadium_location believe_teams.geo_location DEFAULT NULL,
  website TEXT DEFAULT NULL,
  win_percentage DOUBLE PRECISION DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpython3u
AS $$
  import json
  from believe._types import not_given

  response = GD["__believe_context__"].client.teams.with_raw_response.create(
      culture_score=culture_score,
      founded_year=founded_year,
      league=league,
      name=name,
      stadium=stadium,
      values=GD["__believe_context__"].strip_none(values),
      annual_budget_gbp=not_given if annual_budget_gbp is None else json.loads(annual_budget_gbp),
      average_attendance=not_given if average_attendance is None else average_attendance,
      contact_email=not_given if contact_email is None else contact_email,
      is_active=not_given if is_active is None else is_active,
      nickname=not_given if nickname is None else nickname,
      primary_color=not_given if primary_color is None else primary_color,
      rival_teams=not_given if rival_teams is None else rival_teams,
      secondary_color=not_given if secondary_color is None else secondary_color,
      stadium_location=not_given if stadium_location is None else GD["__believe_context__"].strip_none(stadium_location),
      website=not_given if website is None else website,
      win_percentage=not_given if win_percentage is None else win_percentage,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION believe_teams.create(
  culture_score BIGINT,
  founded_year BIGINT,
  league TEXT,
  "name" TEXT,
  stadium TEXT,
  "values" believe_teams.team_values,
  annual_budget_gbp JSONB DEFAULT NULL,
  average_attendance DOUBLE PRECISION DEFAULT NULL,
  contact_email TEXT DEFAULT NULL,
  is_active BOOLEAN DEFAULT NULL,
  nickname TEXT DEFAULT NULL,
  primary_color TEXT DEFAULT NULL,
  rival_teams TEXT[] DEFAULT NULL,
  secondary_color TEXT DEFAULT NULL,
  stadium_location believe_teams.geo_location DEFAULT NULL,
  website TEXT DEFAULT NULL,
  win_percentage DOUBLE PRECISION DEFAULT NULL
)
RETURNS believe_teams.team
LANGUAGE plpgsql
AS $$
  BEGIN
    PERFORM believe_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::believe_teams.team,
      believe_teams._create(
        culture_score,
        founded_year,
        league,
        "name",
        stadium,
        "values",
        annual_budget_gbp,
        average_attendance,
        contact_email,
        is_active,
        nickname,
        primary_color,
        rival_teams,
        secondary_color,
        stadium_location,
        website,
        win_percentage
      )
    );
  END;
$$;

CREATE OR REPLACE FUNCTION believe_teams._retrieve(team_id TEXT)
RETURNS JSONB
LANGUAGE plpython3u
STABLE
AS $$
  response = GD["__believe_context__"].client.teams.with_raw_response.retrieve(
      team_id=team_id,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION believe_teams.retrieve(team_id TEXT)
RETURNS believe_teams.team
LANGUAGE plpgsql
STABLE
AS $$
  BEGIN
    PERFORM believe_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::believe_teams.team, believe_teams._retrieve(team_id)
    );
  END;
$$;

CREATE OR REPLACE FUNCTION believe_teams._update(
  team_id TEXT,
  annual_budget_gbp JSONB DEFAULT NULL,
  average_attendance DOUBLE PRECISION DEFAULT NULL,
  contact_email TEXT DEFAULT NULL,
  culture_score BIGINT DEFAULT NULL,
  founded_year BIGINT DEFAULT NULL,
  is_active BOOLEAN DEFAULT NULL,
  league TEXT DEFAULT NULL,
  "name" TEXT DEFAULT NULL,
  nickname TEXT DEFAULT NULL,
  primary_color TEXT DEFAULT NULL,
  rival_teams TEXT[] DEFAULT NULL,
  secondary_color TEXT DEFAULT NULL,
  stadium TEXT DEFAULT NULL,
  stadium_location believe_teams.geo_location DEFAULT NULL,
  "values" believe_teams.team_values DEFAULT NULL,
  website TEXT DEFAULT NULL,
  win_percentage DOUBLE PRECISION DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpython3u
AS $$
  import json
  from believe._types import not_given

  response = GD["__believe_context__"].client.teams.with_raw_response.update(
      team_id=team_id,
      annual_budget_gbp=not_given if annual_budget_gbp is None else json.loads(annual_budget_gbp),
      average_attendance=not_given if average_attendance is None else average_attendance,
      contact_email=not_given if contact_email is None else contact_email,
      culture_score=not_given if culture_score is None else culture_score,
      founded_year=not_given if founded_year is None else founded_year,
      is_active=not_given if is_active is None else is_active,
      league=not_given if league is None else league,
      name=not_given if name is None else name,
      nickname=not_given if nickname is None else nickname,
      primary_color=not_given if primary_color is None else primary_color,
      rival_teams=not_given if rival_teams is None else rival_teams,
      secondary_color=not_given if secondary_color is None else secondary_color,
      stadium=not_given if stadium is None else stadium,
      stadium_location=not_given if stadium_location is None else GD["__believe_context__"].strip_none(stadium_location),
      values=not_given if values is None else GD["__believe_context__"].strip_none(values),
      website=not_given if website is None else website,
      win_percentage=not_given if win_percentage is None else win_percentage,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION believe_teams.update(
  team_id TEXT,
  annual_budget_gbp JSONB DEFAULT NULL,
  average_attendance DOUBLE PRECISION DEFAULT NULL,
  contact_email TEXT DEFAULT NULL,
  culture_score BIGINT DEFAULT NULL,
  founded_year BIGINT DEFAULT NULL,
  is_active BOOLEAN DEFAULT NULL,
  league TEXT DEFAULT NULL,
  "name" TEXT DEFAULT NULL,
  nickname TEXT DEFAULT NULL,
  primary_color TEXT DEFAULT NULL,
  rival_teams TEXT[] DEFAULT NULL,
  secondary_color TEXT DEFAULT NULL,
  stadium TEXT DEFAULT NULL,
  stadium_location believe_teams.geo_location DEFAULT NULL,
  "values" believe_teams.team_values DEFAULT NULL,
  website TEXT DEFAULT NULL,
  win_percentage DOUBLE PRECISION DEFAULT NULL
)
RETURNS believe_teams.team
LANGUAGE plpgsql
AS $$
  BEGIN
    PERFORM believe_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::believe_teams.team,
      believe_teams._update(
        team_id,
        annual_budget_gbp,
        average_attendance,
        contact_email,
        culture_score,
        founded_year,
        is_active,
        league,
        "name",
        nickname,
        primary_color,
        rival_teams,
        secondary_color,
        stadium,
        stadium_location,
        "values",
        website,
        win_percentage
      )
    );
  END;
$$;

CREATE OR REPLACE FUNCTION believe_teams._list_first_page_py(
  league TEXT DEFAULT NULL,
  "limit" BIGINT DEFAULT NULL,
  min_culture_score BIGINT DEFAULT NULL,
  "skip" BIGINT DEFAULT NULL
)
RETURNS believe_internal.page
LANGUAGE plpython3u
STABLE
AS $$
  from believe._types import not_given
  from pydantic import TypeAdapter
  from typing import Any

  page = GD["__believe_context__"].client.teams.list(
      league=not_given if league is None else league,
      limit=not_given if limit is None else limit,
      min_culture_score=not_given if min_culture_score is None else min_culture_score,
      skip=not_given if skip is None else skip,
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

-- A simpler wrapper around `believe_teams._list_first_page` that ensures the global client is initialized.
CREATE OR REPLACE FUNCTION believe_teams._list_first_page(
  league TEXT DEFAULT NULL,
  "limit" BIGINT DEFAULT NULL,
  min_culture_score BIGINT DEFAULT NULL,
  "skip" BIGINT DEFAULT NULL
)
RETURNS believe_internal.page
LANGUAGE plpgsql
STABLE
AS $$
  BEGIN
    PERFORM believe_internal.ensure_context();
    RETURN believe_teams._list_first_page_py(
      league, "limit", min_culture_score, "skip"
    );
  END;
$$;

CREATE OR REPLACE FUNCTION believe_teams._list_next_page(request_options JSONB)
RETURNS believe_internal.page
LANGUAGE plpython3u
STABLE
AS $$
  import json
  from believe.types import Team
  from believe.pagination import SyncSkipLimitPage
  from believe._models import FinalRequestOptions
  from pydantic import TypeAdapter
  from typing import Any

  page = GD["__believe_context__"].client._request_api_list(
    model=Team,
    page=SyncSkipLimitPage[Team],
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

CREATE OR REPLACE FUNCTION believe_teams.list(
  league TEXT DEFAULT NULL,
  "limit" BIGINT DEFAULT NULL,
  min_culture_score BIGINT DEFAULT NULL,
  "skip" BIGINT DEFAULT NULL
)
RETURNS SETOF believe_teams.team
LANGUAGE SQL
STABLE
AS $$
  WITH RECURSIVE paginated AS (
    SELECT page.*
    FROM believe_teams._list_first_page(
      league, "limit", min_culture_score, "skip"
    ) AS page

    UNION ALL

    SELECT page.*
    FROM paginated
    CROSS JOIN believe_teams._list_next_page(paginated.next_request_options) AS page
    WHERE paginated.next_request_options IS NOT NULL
  )
  SELECT (jsonb_populate_recordset(NULL::believe_teams.team, "data")).* FROM paginated;
$$;

CREATE OR REPLACE FUNCTION believe_teams._delete(team_id TEXT)
RETURNS VOID
LANGUAGE plpython3u
AS $$
  GD["__believe_context__"].client.teams.delete(
      team_id=team_id,
  )
$$;

CREATE OR REPLACE FUNCTION believe_teams.delete(team_id TEXT)
RETURNS VOID
LANGUAGE plpgsql
AS $$
  BEGIN
    PERFORM believe_internal.ensure_context();
    PERFORM believe_teams._delete(team_id);
  END;
$$;

CREATE OR REPLACE FUNCTION believe_teams._get_culture(team_id TEXT)
RETURNS JSONB
LANGUAGE plpython3u
STABLE
AS $$
  response = GD["__believe_context__"].client.teams.with_raw_response.get_culture(
      team_id=team_id,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION believe_teams.get_culture(team_id TEXT)
RETURNS JSONB
LANGUAGE plpgsql
STABLE
AS $$
  BEGIN
    PERFORM believe_internal.ensure_context();
    RETURN believe_teams._get_culture(team_id);
  END;
$$;

CREATE OR REPLACE FUNCTION believe_teams._get_rivals(team_id TEXT)
RETURNS JSONB
LANGUAGE plpython3u
STABLE
AS $$
  response = GD["__believe_context__"].client.teams.with_raw_response.get_rivals(
      team_id=team_id,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION believe_teams.get_rivals(team_id TEXT)
RETURNS SETOF believe_teams.team
LANGUAGE plpgsql
STABLE
AS $$
  BEGIN
    PERFORM believe_internal.ensure_context();
    RETURN QUERY SELECT * FROM jsonb_populate_recordset(
      NULL::believe_teams.team, believe_teams._get_rivals(team_id)
    );
  END;
$$;

CREATE OR REPLACE FUNCTION believe_teams._list_logos(team_id TEXT)
RETURNS JSONB
LANGUAGE plpython3u
STABLE
AS $$
  response = GD["__believe_context__"].client.teams.with_raw_response.list_logos(
      team_id=team_id,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION believe_teams.list_logos(team_id TEXT)
RETURNS SETOF believe_teams_logo.file_upload
LANGUAGE plpgsql
STABLE
AS $$
  BEGIN
    PERFORM believe_internal.ensure_context();
    RETURN QUERY SELECT * FROM jsonb_populate_recordset(
      NULL::believe_teams_logo.file_upload, believe_teams._list_logos(team_id)
    );
  END;
$$;
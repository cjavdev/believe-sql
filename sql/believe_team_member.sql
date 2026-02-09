ALTER TYPE believe_team_member.coach
  ADD ATTRIBUTE "id" TEXT,
  ADD ATTRIBUTE character_id TEXT,
  ADD ATTRIBUTE specialty TEXT,
  ADD ATTRIBUTE team_id TEXT,
  ADD ATTRIBUTE years_with_team BIGINT,
  ADD ATTRIBUTE certifications TEXT[],
  ADD ATTRIBUTE member_type TEXT,
  ADD ATTRIBUTE win_rate DOUBLE PRECISION;

CREATE OR REPLACE FUNCTION believe_team_member.make_coach(
  "id" TEXT,
  character_id TEXT,
  specialty TEXT,
  team_id TEXT,
  years_with_team BIGINT,
  certifications TEXT[] DEFAULT NULL,
  member_type TEXT DEFAULT NULL,
  win_rate DOUBLE PRECISION DEFAULT NULL
)
RETURNS believe_team_member.coach
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    "id",
    character_id,
    specialty,
    team_id,
    years_with_team,
    certifications,
    member_type,
    win_rate
  )::believe_team_member.coach;
$$;

ALTER TYPE believe_team_member.equipment_manager
  ADD ATTRIBUTE "id" TEXT,
  ADD ATTRIBUTE character_id TEXT,
  ADD ATTRIBUTE team_id TEXT,
  ADD ATTRIBUTE years_with_team BIGINT,
  ADD ATTRIBUTE is_head_kitman BOOLEAN,
  ADD ATTRIBUTE member_type TEXT,
  ADD ATTRIBUTE responsibilities TEXT[];

CREATE OR REPLACE FUNCTION believe_team_member.make_equipment_manager(
  "id" TEXT,
  character_id TEXT,
  team_id TEXT,
  years_with_team BIGINT,
  is_head_kitman BOOLEAN DEFAULT NULL,
  member_type TEXT DEFAULT NULL,
  responsibilities TEXT[] DEFAULT NULL
)
RETURNS believe_team_member.equipment_manager
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    "id",
    character_id,
    team_id,
    years_with_team,
    is_head_kitman,
    member_type,
    responsibilities
  )::believe_team_member.equipment_manager;
$$;

ALTER TYPE believe_team_member.medical_staff
  ADD ATTRIBUTE "id" TEXT,
  ADD ATTRIBUTE character_id TEXT,
  ADD ATTRIBUTE specialty TEXT,
  ADD ATTRIBUTE team_id TEXT,
  ADD ATTRIBUTE years_with_team BIGINT,
  ADD ATTRIBUTE license_number TEXT,
  ADD ATTRIBUTE member_type TEXT,
  ADD ATTRIBUTE qualifications TEXT[];

CREATE OR REPLACE FUNCTION believe_team_member.make_medical_staff(
  "id" TEXT,
  character_id TEXT,
  specialty TEXT,
  team_id TEXT,
  years_with_team BIGINT,
  license_number TEXT DEFAULT NULL,
  member_type TEXT DEFAULT NULL,
  qualifications TEXT[] DEFAULT NULL
)
RETURNS believe_team_member.medical_staff
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    "id",
    character_id,
    specialty,
    team_id,
    years_with_team,
    license_number,
    member_type,
    qualifications
  )::believe_team_member.medical_staff;
$$;

ALTER TYPE believe_team_member.player
  ADD ATTRIBUTE "id" TEXT,
  ADD ATTRIBUTE character_id TEXT,
  ADD ATTRIBUTE jersey_number BIGINT,
  ADD ATTRIBUTE "position" TEXT,
  ADD ATTRIBUTE team_id TEXT,
  ADD ATTRIBUTE years_with_team BIGINT,
  ADD ATTRIBUTE assists BIGINT,
  ADD ATTRIBUTE goals_scored BIGINT,
  ADD ATTRIBUTE is_captain BOOLEAN,
  ADD ATTRIBUTE member_type TEXT;

CREATE OR REPLACE FUNCTION believe_team_member.make_player(
  "id" TEXT,
  character_id TEXT,
  jersey_number BIGINT,
  "position" TEXT,
  team_id TEXT,
  years_with_team BIGINT,
  assists BIGINT DEFAULT NULL,
  goals_scored BIGINT DEFAULT NULL,
  is_captain BOOLEAN DEFAULT NULL,
  member_type TEXT DEFAULT NULL
)
RETURNS believe_team_member.player
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    "id",
    character_id,
    jersey_number,
    "position",
    team_id,
    years_with_team,
    assists,
    goals_scored,
    is_captain,
    member_type
  )::believe_team_member.player;
$$;

ALTER TYPE believe_team_member.team_member_create_response
  ADD ATTRIBUTE "id" TEXT,
  ADD ATTRIBUTE character_id TEXT,
  ADD ATTRIBUTE jersey_number BIGINT,
  ADD ATTRIBUTE "position" TEXT,
  ADD ATTRIBUTE team_id TEXT,
  ADD ATTRIBUTE years_with_team BIGINT,
  ADD ATTRIBUTE assists BIGINT,
  ADD ATTRIBUTE goals_scored BIGINT,
  ADD ATTRIBUTE is_captain BOOLEAN,
  ADD ATTRIBUTE member_type TEXT,
  ADD ATTRIBUTE specialty TEXT,
  ADD ATTRIBUTE certifications TEXT[],
  ADD ATTRIBUTE win_rate DOUBLE PRECISION,
  ADD ATTRIBUTE license_number TEXT,
  ADD ATTRIBUTE qualifications TEXT[],
  ADD ATTRIBUTE is_head_kitman BOOLEAN,
  ADD ATTRIBUTE responsibilities TEXT[];

CREATE OR REPLACE FUNCTION believe_team_member.make_team_member_create_response(
  "id" TEXT,
  character_id TEXT,
  team_id TEXT,
  years_with_team BIGINT,
  jersey_number BIGINT DEFAULT NULL,
  "position" TEXT DEFAULT NULL,
  assists BIGINT DEFAULT NULL,
  goals_scored BIGINT DEFAULT NULL,
  is_captain BOOLEAN DEFAULT NULL,
  member_type TEXT DEFAULT NULL,
  specialty TEXT DEFAULT NULL,
  certifications TEXT[] DEFAULT NULL,
  win_rate DOUBLE PRECISION DEFAULT NULL,
  license_number TEXT DEFAULT NULL,
  qualifications TEXT[] DEFAULT NULL,
  is_head_kitman BOOLEAN DEFAULT NULL,
  responsibilities TEXT[] DEFAULT NULL
)
RETURNS believe_team_member.team_member_create_response
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    "id",
    character_id,
    jersey_number,
    "position",
    team_id,
    years_with_team,
    assists,
    goals_scored,
    is_captain,
    member_type,
    specialty,
    certifications,
    win_rate,
    license_number,
    qualifications,
    is_head_kitman,
    responsibilities
  )::believe_team_member.team_member_create_response;
$$;

ALTER TYPE believe_team_member.team_member_retrieve_response
  ADD ATTRIBUTE "id" TEXT,
  ADD ATTRIBUTE character_id TEXT,
  ADD ATTRIBUTE jersey_number BIGINT,
  ADD ATTRIBUTE "position" TEXT,
  ADD ATTRIBUTE team_id TEXT,
  ADD ATTRIBUTE years_with_team BIGINT,
  ADD ATTRIBUTE assists BIGINT,
  ADD ATTRIBUTE goals_scored BIGINT,
  ADD ATTRIBUTE is_captain BOOLEAN,
  ADD ATTRIBUTE member_type TEXT,
  ADD ATTRIBUTE specialty TEXT,
  ADD ATTRIBUTE certifications TEXT[],
  ADD ATTRIBUTE win_rate DOUBLE PRECISION,
  ADD ATTRIBUTE license_number TEXT,
  ADD ATTRIBUTE qualifications TEXT[],
  ADD ATTRIBUTE is_head_kitman BOOLEAN,
  ADD ATTRIBUTE responsibilities TEXT[];

CREATE OR REPLACE FUNCTION believe_team_member.make_team_member_retrieve_response(
  "id" TEXT,
  character_id TEXT,
  team_id TEXT,
  years_with_team BIGINT,
  jersey_number BIGINT DEFAULT NULL,
  "position" TEXT DEFAULT NULL,
  assists BIGINT DEFAULT NULL,
  goals_scored BIGINT DEFAULT NULL,
  is_captain BOOLEAN DEFAULT NULL,
  member_type TEXT DEFAULT NULL,
  specialty TEXT DEFAULT NULL,
  certifications TEXT[] DEFAULT NULL,
  win_rate DOUBLE PRECISION DEFAULT NULL,
  license_number TEXT DEFAULT NULL,
  qualifications TEXT[] DEFAULT NULL,
  is_head_kitman BOOLEAN DEFAULT NULL,
  responsibilities TEXT[] DEFAULT NULL
)
RETURNS believe_team_member.team_member_retrieve_response
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    "id",
    character_id,
    jersey_number,
    "position",
    team_id,
    years_with_team,
    assists,
    goals_scored,
    is_captain,
    member_type,
    specialty,
    certifications,
    win_rate,
    license_number,
    qualifications,
    is_head_kitman,
    responsibilities
  )::believe_team_member.team_member_retrieve_response;
$$;

ALTER TYPE believe_team_member.team_member_update_response
  ADD ATTRIBUTE "id" TEXT,
  ADD ATTRIBUTE character_id TEXT,
  ADD ATTRIBUTE jersey_number BIGINT,
  ADD ATTRIBUTE "position" TEXT,
  ADD ATTRIBUTE team_id TEXT,
  ADD ATTRIBUTE years_with_team BIGINT,
  ADD ATTRIBUTE assists BIGINT,
  ADD ATTRIBUTE goals_scored BIGINT,
  ADD ATTRIBUTE is_captain BOOLEAN,
  ADD ATTRIBUTE member_type TEXT,
  ADD ATTRIBUTE specialty TEXT,
  ADD ATTRIBUTE certifications TEXT[],
  ADD ATTRIBUTE win_rate DOUBLE PRECISION,
  ADD ATTRIBUTE license_number TEXT,
  ADD ATTRIBUTE qualifications TEXT[],
  ADD ATTRIBUTE is_head_kitman BOOLEAN,
  ADD ATTRIBUTE responsibilities TEXT[];

CREATE OR REPLACE FUNCTION believe_team_member.make_team_member_update_response(
  "id" TEXT,
  character_id TEXT,
  team_id TEXT,
  years_with_team BIGINT,
  jersey_number BIGINT DEFAULT NULL,
  "position" TEXT DEFAULT NULL,
  assists BIGINT DEFAULT NULL,
  goals_scored BIGINT DEFAULT NULL,
  is_captain BOOLEAN DEFAULT NULL,
  member_type TEXT DEFAULT NULL,
  specialty TEXT DEFAULT NULL,
  certifications TEXT[] DEFAULT NULL,
  win_rate DOUBLE PRECISION DEFAULT NULL,
  license_number TEXT DEFAULT NULL,
  qualifications TEXT[] DEFAULT NULL,
  is_head_kitman BOOLEAN DEFAULT NULL,
  responsibilities TEXT[] DEFAULT NULL
)
RETURNS believe_team_member.team_member_update_response
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    "id",
    character_id,
    jersey_number,
    "position",
    team_id,
    years_with_team,
    assists,
    goals_scored,
    is_captain,
    member_type,
    specialty,
    certifications,
    win_rate,
    license_number,
    qualifications,
    is_head_kitman,
    responsibilities
  )::believe_team_member.team_member_update_response;
$$;

ALTER TYPE believe_team_member.team_member_list_response
  ADD ATTRIBUTE "id" TEXT,
  ADD ATTRIBUTE character_id TEXT,
  ADD ATTRIBUTE jersey_number BIGINT,
  ADD ATTRIBUTE "position" TEXT,
  ADD ATTRIBUTE team_id TEXT,
  ADD ATTRIBUTE years_with_team BIGINT,
  ADD ATTRIBUTE assists BIGINT,
  ADD ATTRIBUTE goals_scored BIGINT,
  ADD ATTRIBUTE is_captain BOOLEAN,
  ADD ATTRIBUTE member_type TEXT,
  ADD ATTRIBUTE specialty TEXT,
  ADD ATTRIBUTE certifications TEXT[],
  ADD ATTRIBUTE win_rate DOUBLE PRECISION,
  ADD ATTRIBUTE license_number TEXT,
  ADD ATTRIBUTE qualifications TEXT[],
  ADD ATTRIBUTE is_head_kitman BOOLEAN,
  ADD ATTRIBUTE responsibilities TEXT[];

CREATE OR REPLACE FUNCTION believe_team_member.make_team_member_list_response(
  "id" TEXT,
  character_id TEXT,
  team_id TEXT,
  years_with_team BIGINT,
  jersey_number BIGINT DEFAULT NULL,
  "position" TEXT DEFAULT NULL,
  assists BIGINT DEFAULT NULL,
  goals_scored BIGINT DEFAULT NULL,
  is_captain BOOLEAN DEFAULT NULL,
  member_type TEXT DEFAULT NULL,
  specialty TEXT DEFAULT NULL,
  certifications TEXT[] DEFAULT NULL,
  win_rate DOUBLE PRECISION DEFAULT NULL,
  license_number TEXT DEFAULT NULL,
  qualifications TEXT[] DEFAULT NULL,
  is_head_kitman BOOLEAN DEFAULT NULL,
  responsibilities TEXT[] DEFAULT NULL
)
RETURNS believe_team_member.team_member_list_response
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    "id",
    character_id,
    jersey_number,
    "position",
    team_id,
    years_with_team,
    assists,
    goals_scored,
    is_captain,
    member_type,
    specialty,
    certifications,
    win_rate,
    license_number,
    qualifications,
    is_head_kitman,
    responsibilities
  )::believe_team_member.team_member_list_response;
$$;

ALTER TYPE believe_team_member.team_member_list_staff_response
  ADD ATTRIBUTE "id" TEXT,
  ADD ATTRIBUTE character_id TEXT,
  ADD ATTRIBUTE specialty TEXT,
  ADD ATTRIBUTE team_id TEXT,
  ADD ATTRIBUTE years_with_team BIGINT,
  ADD ATTRIBUTE license_number TEXT,
  ADD ATTRIBUTE member_type TEXT,
  ADD ATTRIBUTE qualifications TEXT[],
  ADD ATTRIBUTE is_head_kitman BOOLEAN,
  ADD ATTRIBUTE responsibilities TEXT[];

CREATE OR REPLACE FUNCTION believe_team_member.make_team_member_list_staff_response(
  "id" TEXT,
  character_id TEXT,
  team_id TEXT,
  years_with_team BIGINT,
  specialty TEXT DEFAULT NULL,
  license_number TEXT DEFAULT NULL,
  member_type TEXT DEFAULT NULL,
  qualifications TEXT[] DEFAULT NULL,
  is_head_kitman BOOLEAN DEFAULT NULL,
  responsibilities TEXT[] DEFAULT NULL
)
RETURNS believe_team_member.team_member_list_staff_response
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    "id",
    character_id,
    specialty,
    team_id,
    years_with_team,
    license_number,
    member_type,
    qualifications,
    is_head_kitman,
    responsibilities
  )::believe_team_member.team_member_list_staff_response;
$$;

ALTER TYPE believe_team_member.member
  ADD ATTRIBUTE character_id TEXT,
  ADD ATTRIBUTE jersey_number BIGINT,
  ADD ATTRIBUTE "position" TEXT,
  ADD ATTRIBUTE team_id TEXT,
  ADD ATTRIBUTE years_with_team BIGINT,
  ADD ATTRIBUTE assists BIGINT,
  ADD ATTRIBUTE goals_scored BIGINT,
  ADD ATTRIBUTE is_captain BOOLEAN,
  ADD ATTRIBUTE member_type TEXT,
  ADD ATTRIBUTE specialty TEXT,
  ADD ATTRIBUTE certifications TEXT[],
  ADD ATTRIBUTE win_rate DOUBLE PRECISION,
  ADD ATTRIBUTE license_number TEXT,
  ADD ATTRIBUTE qualifications TEXT[],
  ADD ATTRIBUTE is_head_kitman BOOLEAN,
  ADD ATTRIBUTE responsibilities TEXT[];

CREATE OR REPLACE FUNCTION believe_team_member.make_member(
  character_id TEXT,
  team_id TEXT,
  years_with_team BIGINT,
  jersey_number BIGINT DEFAULT NULL,
  "position" TEXT DEFAULT NULL,
  assists BIGINT DEFAULT NULL,
  goals_scored BIGINT DEFAULT NULL,
  is_captain BOOLEAN DEFAULT NULL,
  member_type TEXT DEFAULT NULL,
  specialty TEXT DEFAULT NULL,
  certifications TEXT[] DEFAULT NULL,
  win_rate DOUBLE PRECISION DEFAULT NULL,
  license_number TEXT DEFAULT NULL,
  qualifications TEXT[] DEFAULT NULL,
  is_head_kitman BOOLEAN DEFAULT NULL,
  responsibilities TEXT[] DEFAULT NULL
)
RETURNS believe_team_member.member
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    character_id,
    jersey_number,
    "position",
    team_id,
    years_with_team,
    assists,
    goals_scored,
    is_captain,
    member_type,
    specialty,
    certifications,
    win_rate,
    license_number,
    qualifications,
    is_head_kitman,
    responsibilities
  )::believe_team_member.member;
$$;

ALTER TYPE believe_team_member.update
  ADD ATTRIBUTE assists BIGINT,
  ADD ATTRIBUTE goals_scored BIGINT,
  ADD ATTRIBUTE is_captain BOOLEAN,
  ADD ATTRIBUTE jersey_number BIGINT,
  ADD ATTRIBUTE "position" TEXT,
  ADD ATTRIBUTE team_id TEXT,
  ADD ATTRIBUTE years_with_team BIGINT,
  ADD ATTRIBUTE certifications TEXT[],
  ADD ATTRIBUTE specialty TEXT,
  ADD ATTRIBUTE win_rate DOUBLE PRECISION,
  ADD ATTRIBUTE license_number TEXT,
  ADD ATTRIBUTE qualifications TEXT[],
  ADD ATTRIBUTE is_head_kitman BOOLEAN,
  ADD ATTRIBUTE responsibilities TEXT[];

CREATE OR REPLACE FUNCTION believe_team_member.make_update(
  assists BIGINT DEFAULT NULL,
  goals_scored BIGINT DEFAULT NULL,
  is_captain BOOLEAN DEFAULT NULL,
  jersey_number BIGINT DEFAULT NULL,
  "position" TEXT DEFAULT NULL,
  team_id TEXT DEFAULT NULL,
  years_with_team BIGINT DEFAULT NULL,
  certifications TEXT[] DEFAULT NULL,
  specialty TEXT DEFAULT NULL,
  win_rate DOUBLE PRECISION DEFAULT NULL,
  license_number TEXT DEFAULT NULL,
  qualifications TEXT[] DEFAULT NULL,
  is_head_kitman BOOLEAN DEFAULT NULL,
  responsibilities TEXT[] DEFAULT NULL
)
RETURNS believe_team_member.update
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    assists,
    goals_scored,
    is_captain,
    jersey_number,
    "position",
    team_id,
    years_with_team,
    certifications,
    specialty,
    win_rate,
    license_number,
    qualifications,
    is_head_kitman,
    responsibilities
  )::believe_team_member.update;
$$;

CREATE OR REPLACE FUNCTION believe_team_member._create(
  "member" believe_team_member.member
)
RETURNS JSONB
LANGUAGE plpython3u
AS $$
  response = GD["__believe_context__"].client.team_members.with_raw_response.create(
      member=GD["__believe_context__"].strip_none(member),
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION believe_team_member.create(
  "member" believe_team_member.member
)
RETURNS believe_team_member.team_member_create_response
LANGUAGE plpgsql
AS $$
  BEGIN
    PERFORM believe_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::believe_team_member.team_member_create_response,
      believe_team_member._create("member")
    );
  END;
$$;

CREATE OR REPLACE FUNCTION believe_team_member._retrieve(member_id TEXT)
RETURNS JSONB
LANGUAGE plpython3u
STABLE
AS $$
  response = GD["__believe_context__"].client.team_members.with_raw_response.retrieve(
      member_id=member_id,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION believe_team_member.retrieve(member_id TEXT)
RETURNS believe_team_member.team_member_retrieve_response
LANGUAGE plpgsql
STABLE
AS $$
  BEGIN
    PERFORM believe_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::believe_team_member.team_member_retrieve_response,
      believe_team_member._retrieve(member_id)
    );
  END;
$$;

CREATE OR REPLACE FUNCTION believe_team_member._update(
  member_id TEXT, updates believe_team_member.update
)
RETURNS JSONB
LANGUAGE plpython3u
AS $$
  response = GD["__believe_context__"].client.team_members.with_raw_response.update(
      member_id=member_id,
      updates=GD["__believe_context__"].strip_none(updates),
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION believe_team_member.update(
  member_id TEXT, updates believe_team_member.update
)
RETURNS believe_team_member.team_member_update_response
LANGUAGE plpgsql
AS $$
  BEGIN
    PERFORM believe_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::believe_team_member.team_member_update_response,
      believe_team_member._update(member_id, updates)
    );
  END;
$$;

CREATE OR REPLACE FUNCTION believe_team_member._list_first_page_py(
  "limit" BIGINT DEFAULT NULL,
  member_type TEXT DEFAULT NULL,
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

  page = GD["__believe_context__"].client.team_members.list(
      limit=not_given if limit is None else limit,
      member_type=not_given if member_type is None else member_type,
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

-- A simpler wrapper around `believe_team_member._list_first_page` that ensures the global client is initialized.
CREATE OR REPLACE FUNCTION believe_team_member._list_first_page(
  "limit" BIGINT DEFAULT NULL,
  member_type TEXT DEFAULT NULL,
  "skip" BIGINT DEFAULT NULL,
  team_id TEXT DEFAULT NULL
)
RETURNS believe_internal.page
LANGUAGE plpgsql
STABLE
AS $$
  BEGIN
    PERFORM believe_internal.ensure_context();
    RETURN believe_team_member._list_first_page_py(
      "limit", member_type, "skip", team_id
    );
  END;
$$;

CREATE OR REPLACE FUNCTION believe_team_member._list_next_page(request_options JSONB)
RETURNS believe_internal.page
LANGUAGE plpython3u
STABLE
AS $$
  import json
  from believe.types import TeamMemberListResponse
  from believe.pagination import SyncSkipLimitPage
  from believe._models import FinalRequestOptions
  from pydantic import TypeAdapter
  from typing import Any

  page = GD["__believe_context__"].client._request_api_list(
    model=TeamMemberListResponse,
    page=SyncSkipLimitPage[TeamMemberListResponse],
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

CREATE OR REPLACE FUNCTION believe_team_member.list(
  "limit" BIGINT DEFAULT NULL,
  member_type TEXT DEFAULT NULL,
  "skip" BIGINT DEFAULT NULL,
  team_id TEXT DEFAULT NULL
)
RETURNS SETOF believe_team_member.team_member_list_response
LANGUAGE SQL
STABLE
AS $$
  WITH RECURSIVE paginated AS (
    SELECT page.*
    FROM believe_team_member._list_first_page(
      "limit", member_type, "skip", team_id
    ) AS page

    UNION ALL

    SELECT page.*
    FROM paginated
    CROSS JOIN believe_team_member._list_next_page(paginated.next_request_options) AS page
    WHERE paginated.next_request_options IS NOT NULL
  )
  SELECT (jsonb_populate_recordset(NULL::believe_team_member.team_member_list_response, "data")).* FROM paginated;
$$;

CREATE OR REPLACE FUNCTION believe_team_member._delete(member_id TEXT)
RETURNS VOID
LANGUAGE plpython3u
AS $$
  GD["__believe_context__"].client.team_members.delete(
      member_id=member_id,
  )
$$;

CREATE OR REPLACE FUNCTION believe_team_member.delete(member_id TEXT)
RETURNS VOID
LANGUAGE plpgsql
AS $$
  BEGIN
    PERFORM believe_internal.ensure_context();
    PERFORM believe_team_member._delete(member_id);
  END;
$$;

CREATE OR REPLACE FUNCTION believe_team_member._list_coaches_first_page_py(
  "limit" BIGINT DEFAULT NULL,
  "skip" BIGINT DEFAULT NULL,
  specialty TEXT DEFAULT NULL,
  team_id TEXT DEFAULT NULL
)
RETURNS believe_internal.page
LANGUAGE plpython3u
STABLE
AS $$
  from believe._types import not_given
  from pydantic import TypeAdapter
  from typing import Any

  page = GD["__believe_context__"].client.team_members.list_coaches(
      limit=not_given if limit is None else limit,
      skip=not_given if skip is None else skip,
      specialty=not_given if specialty is None else specialty,
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

-- A simpler wrapper around `believe_team_member._list_coaches_first_page` that ensures the global client is initialized.
CREATE OR REPLACE FUNCTION believe_team_member._list_coaches_first_page(
  "limit" BIGINT DEFAULT NULL,
  "skip" BIGINT DEFAULT NULL,
  specialty TEXT DEFAULT NULL,
  team_id TEXT DEFAULT NULL
)
RETURNS believe_internal.page
LANGUAGE plpgsql
STABLE
AS $$
  BEGIN
    PERFORM believe_internal.ensure_context();
    RETURN believe_team_member._list_coaches_first_page_py(
      "limit", "skip", specialty, team_id
    );
  END;
$$;

CREATE OR REPLACE FUNCTION believe_team_member._list_coaches_next_page(request_options JSONB)
RETURNS believe_internal.page
LANGUAGE plpython3u
STABLE
AS $$
  import json
  from believe.types import Coach
  from believe.pagination import SyncSkipLimitPage
  from believe._models import FinalRequestOptions
  from pydantic import TypeAdapter
  from typing import Any

  page = GD["__believe_context__"].client._request_api_list(
    model=Coach,
    page=SyncSkipLimitPage[Coach],
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

CREATE OR REPLACE FUNCTION believe_team_member.list_coaches(
  "limit" BIGINT DEFAULT NULL,
  "skip" BIGINT DEFAULT NULL,
  specialty TEXT DEFAULT NULL,
  team_id TEXT DEFAULT NULL
)
RETURNS SETOF believe_team_member.coach
LANGUAGE SQL
STABLE
AS $$
  WITH RECURSIVE paginated AS (
    SELECT page.*
    FROM believe_team_member._list_coaches_first_page(
      "limit", "skip", specialty, team_id
    ) AS page

    UNION ALL

    SELECT page.*
    FROM paginated
    CROSS JOIN believe_team_member._list_coaches_next_page(paginated.next_request_options) AS page
    WHERE paginated.next_request_options IS NOT NULL
  )
  SELECT (jsonb_populate_recordset(NULL::believe_team_member.coach, "data")).* FROM paginated;
$$;

CREATE OR REPLACE FUNCTION believe_team_member._list_players_first_page_py(
  "limit" BIGINT DEFAULT NULL,
  "position" TEXT DEFAULT NULL,
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

  page = GD["__believe_context__"].client.team_members.list_players(
      limit=not_given if limit is None else limit,
      position=not_given if position is None else position,
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

-- A simpler wrapper around `believe_team_member._list_players_first_page` that ensures the global client is initialized.
CREATE OR REPLACE FUNCTION believe_team_member._list_players_first_page(
  "limit" BIGINT DEFAULT NULL,
  "position" TEXT DEFAULT NULL,
  "skip" BIGINT DEFAULT NULL,
  team_id TEXT DEFAULT NULL
)
RETURNS believe_internal.page
LANGUAGE plpgsql
STABLE
AS $$
  BEGIN
    PERFORM believe_internal.ensure_context();
    RETURN believe_team_member._list_players_first_page_py(
      "limit", "position", "skip", team_id
    );
  END;
$$;

CREATE OR REPLACE FUNCTION believe_team_member._list_players_next_page(request_options JSONB)
RETURNS believe_internal.page
LANGUAGE plpython3u
STABLE
AS $$
  import json
  from believe.types import Player
  from believe.pagination import SyncSkipLimitPage
  from believe._models import FinalRequestOptions
  from pydantic import TypeAdapter
  from typing import Any

  page = GD["__believe_context__"].client._request_api_list(
    model=Player,
    page=SyncSkipLimitPage[Player],
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

CREATE OR REPLACE FUNCTION believe_team_member.list_players(
  "limit" BIGINT DEFAULT NULL,
  "position" TEXT DEFAULT NULL,
  "skip" BIGINT DEFAULT NULL,
  team_id TEXT DEFAULT NULL
)
RETURNS SETOF believe_team_member.player
LANGUAGE SQL
STABLE
AS $$
  WITH RECURSIVE paginated AS (
    SELECT page.*
    FROM believe_team_member._list_players_first_page(
      "limit", "position", "skip", team_id
    ) AS page

    UNION ALL

    SELECT page.*
    FROM paginated
    CROSS JOIN believe_team_member._list_players_next_page(paginated.next_request_options) AS page
    WHERE paginated.next_request_options IS NOT NULL
  )
  SELECT (jsonb_populate_recordset(NULL::believe_team_member.player, "data")).* FROM paginated;
$$;

CREATE OR REPLACE FUNCTION believe_team_member._list_staff_first_page_py(
  "limit" BIGINT DEFAULT NULL,
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

  page = GD["__believe_context__"].client.team_members.list_staff(
      limit=not_given if limit is None else limit,
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

-- A simpler wrapper around `believe_team_member._list_staff_first_page` that ensures the global client is initialized.
CREATE OR REPLACE FUNCTION believe_team_member._list_staff_first_page(
  "limit" BIGINT DEFAULT NULL,
  "skip" BIGINT DEFAULT NULL,
  team_id TEXT DEFAULT NULL
)
RETURNS believe_internal.page
LANGUAGE plpgsql
STABLE
AS $$
  BEGIN
    PERFORM believe_internal.ensure_context();
    RETURN believe_team_member._list_staff_first_page_py(
      "limit", "skip", team_id
    );
  END;
$$;

CREATE OR REPLACE FUNCTION believe_team_member._list_staff_next_page(request_options JSONB)
RETURNS believe_internal.page
LANGUAGE plpython3u
STABLE
AS $$
  import json
  from believe.types import TeamMemberListStaffResponse
  from believe.pagination import SyncSkipLimitPage
  from believe._models import FinalRequestOptions
  from pydantic import TypeAdapter
  from typing import Any

  page = GD["__believe_context__"].client._request_api_list(
    model=TeamMemberListStaffResponse,
    page=SyncSkipLimitPage[TeamMemberListStaffResponse],
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

CREATE OR REPLACE FUNCTION believe_team_member.list_staff(
  "limit" BIGINT DEFAULT NULL,
  "skip" BIGINT DEFAULT NULL,
  team_id TEXT DEFAULT NULL
)
RETURNS SETOF believe_team_member.team_member_list_staff_response
LANGUAGE SQL
STABLE
AS $$
  WITH RECURSIVE paginated AS (
    SELECT page.*
    FROM believe_team_member._list_staff_first_page(
      "limit", "skip", team_id
    ) AS page

    UNION ALL

    SELECT page.*
    FROM paginated
    CROSS JOIN believe_team_member._list_staff_next_page(paginated.next_request_options) AS page
    WHERE paginated.next_request_options IS NOT NULL
  )
  SELECT (jsonb_populate_recordset(NULL::believe_team_member.team_member_list_staff_response, "data")).* FROM paginated;
$$;
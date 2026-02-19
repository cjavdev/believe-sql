ALTER TYPE believe_characters.character
  ADD ATTRIBUTE id TEXT,
  ADD ATTRIBUTE background TEXT,
  ADD ATTRIBUTE emotional_stats believe_characters.emotional_stats,
  ADD ATTRIBUTE name TEXT,
  ADD ATTRIBUTE personality_traits TEXT[],
  ADD ATTRIBUTE role TEXT,
  ADD ATTRIBUTE date_of_birth DATE,
  ADD ATTRIBUTE email TEXT,
  ADD ATTRIBUTE growth_arcs believe_characters.growth_arc[],
  ADD ATTRIBUTE height_meters DOUBLE PRECISION,
  ADD ATTRIBUTE profile_image_url TEXT,
  ADD ATTRIBUTE salary_gbp TEXT,
  ADD ATTRIBUTE signature_quotes TEXT[],
  ADD ATTRIBUTE team_id TEXT;

CREATE OR REPLACE FUNCTION believe_characters.make_character(
  id TEXT,
  background TEXT,
  emotional_stats believe_characters.emotional_stats,
  name TEXT,
  personality_traits TEXT[],
  role TEXT,
  date_of_birth DATE DEFAULT NULL,
  email TEXT DEFAULT NULL,
  growth_arcs believe_characters.growth_arc[] DEFAULT NULL,
  height_meters DOUBLE PRECISION DEFAULT NULL,
  profile_image_url TEXT DEFAULT NULL,
  salary_gbp TEXT DEFAULT NULL,
  signature_quotes TEXT[] DEFAULT NULL,
  team_id TEXT DEFAULT NULL
)
RETURNS believe_characters.character
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    id,
    background,
    emotional_stats,
    name,
    personality_traits,
    role,
    date_of_birth,
    email,
    growth_arcs,
    height_meters,
    profile_image_url,
    salary_gbp,
    signature_quotes,
    team_id
  )::believe_characters.character;
$$;

ALTER TYPE believe_characters.emotional_stats
  ADD ATTRIBUTE curiosity BIGINT,
  ADD ATTRIBUTE empathy BIGINT,
  ADD ATTRIBUTE optimism BIGINT,
  ADD ATTRIBUTE resilience BIGINT,
  ADD ATTRIBUTE vulnerability BIGINT;

CREATE OR REPLACE FUNCTION believe_characters.make_emotional_stats(
  curiosity BIGINT,
  empathy BIGINT,
  optimism BIGINT,
  resilience BIGINT,
  vulnerability BIGINT
)
RETURNS believe_characters.emotional_stats
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    curiosity, empathy, optimism, resilience, vulnerability
  )::believe_characters.emotional_stats;
$$;

ALTER TYPE believe_characters.growth_arc
  ADD ATTRIBUTE breakthrough TEXT,
  ADD ATTRIBUTE challenge TEXT,
  ADD ATTRIBUTE ending_point TEXT,
  ADD ATTRIBUTE season BIGINT,
  ADD ATTRIBUTE starting_point TEXT;

CREATE OR REPLACE FUNCTION believe_characters.make_growth_arc(
  breakthrough TEXT,
  challenge TEXT,
  ending_point TEXT,
  season BIGINT,
  starting_point TEXT
)
RETURNS believe_characters.growth_arc
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    breakthrough, challenge, ending_point, season, starting_point
  )::believe_characters.growth_arc;
$$;

CREATE OR REPLACE FUNCTION believe_characters._create(
  background TEXT,
  emotional_stats believe_characters.emotional_stats,
  name TEXT,
  personality_traits TEXT[],
  role TEXT,
  date_of_birth DATE DEFAULT NULL,
  email TEXT DEFAULT NULL,
  growth_arcs believe_characters.growth_arc[] DEFAULT NULL,
  height_meters DOUBLE PRECISION DEFAULT NULL,
  profile_image_url TEXT DEFAULT NULL,
  salary_gbp JSONB DEFAULT NULL,
  signature_quotes TEXT[] DEFAULT NULL,
  team_id TEXT DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpython3u
AS $$
  import json
  from believe._types import not_given

  response = GD["__believe_context__"].client.characters.with_raw_response.create(
      background=background,
      emotional_stats=GD["__believe_context__"].strip_none(emotional_stats),
      name=name,
      personality_traits=personality_traits,
      role=role,
      date_of_birth=not_given if date_of_birth is None else date_of_birth,
      email=not_given if email is None else email,
      growth_arcs=not_given if growth_arcs is None else GD["__believe_context__"].strip_none(growth_arcs),
      height_meters=not_given if height_meters is None else height_meters,
      profile_image_url=not_given if profile_image_url is None else profile_image_url,
      salary_gbp=not_given if salary_gbp is None else json.loads(salary_gbp),
      signature_quotes=not_given if signature_quotes is None else signature_quotes,
      team_id=not_given if team_id is None else team_id,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION believe_characters.create(
  background TEXT,
  emotional_stats believe_characters.emotional_stats,
  name TEXT,
  personality_traits TEXT[],
  role TEXT,
  date_of_birth DATE DEFAULT NULL,
  email TEXT DEFAULT NULL,
  growth_arcs believe_characters.growth_arc[] DEFAULT NULL,
  height_meters DOUBLE PRECISION DEFAULT NULL,
  profile_image_url TEXT DEFAULT NULL,
  salary_gbp JSONB DEFAULT NULL,
  signature_quotes TEXT[] DEFAULT NULL,
  team_id TEXT DEFAULT NULL
)
RETURNS believe_characters.character
LANGUAGE plpgsql
AS $$
  BEGIN
    PERFORM believe_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::believe_characters.character,
      believe_characters._create(
        background,
        emotional_stats,
        name,
        personality_traits,
        role,
        date_of_birth,
        email,
        growth_arcs,
        height_meters,
        profile_image_url,
        salary_gbp,
        signature_quotes,
        team_id
      )
    );
  END;
$$;

CREATE OR REPLACE FUNCTION believe_characters._retrieve(character_id TEXT)
RETURNS JSONB
LANGUAGE plpython3u
STABLE
AS $$
  response = GD["__believe_context__"].client.characters.with_raw_response.retrieve(
      character_id=character_id,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION believe_characters.retrieve(character_id TEXT)
RETURNS believe_characters.character
LANGUAGE plpgsql
STABLE
AS $$
  BEGIN
    PERFORM believe_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::believe_characters.character,
      believe_characters._retrieve(character_id)
    );
  END;
$$;

CREATE OR REPLACE FUNCTION believe_characters._update(
  character_id TEXT,
  background TEXT DEFAULT NULL,
  date_of_birth DATE DEFAULT NULL,
  email TEXT DEFAULT NULL,
  emotional_stats believe_characters.emotional_stats DEFAULT NULL,
  growth_arcs believe_characters.growth_arc[] DEFAULT NULL,
  height_meters DOUBLE PRECISION DEFAULT NULL,
  name TEXT DEFAULT NULL,
  personality_traits TEXT[] DEFAULT NULL,
  profile_image_url TEXT DEFAULT NULL,
  role TEXT DEFAULT NULL,
  salary_gbp JSONB DEFAULT NULL,
  signature_quotes TEXT[] DEFAULT NULL,
  team_id TEXT DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpython3u
AS $$
  import json
  from believe._types import not_given

  response = GD["__believe_context__"].client.characters.with_raw_response.update(
      character_id=character_id,
      background=not_given if background is None else background,
      date_of_birth=not_given if date_of_birth is None else date_of_birth,
      email=not_given if email is None else email,
      emotional_stats=not_given if emotional_stats is None else GD["__believe_context__"].strip_none(emotional_stats),
      growth_arcs=not_given if growth_arcs is None else GD["__believe_context__"].strip_none(growth_arcs),
      height_meters=not_given if height_meters is None else height_meters,
      name=not_given if name is None else name,
      personality_traits=not_given if personality_traits is None else personality_traits,
      profile_image_url=not_given if profile_image_url is None else profile_image_url,
      role=not_given if role is None else role,
      salary_gbp=not_given if salary_gbp is None else json.loads(salary_gbp),
      signature_quotes=not_given if signature_quotes is None else signature_quotes,
      team_id=not_given if team_id is None else team_id,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION believe_characters.update(
  character_id TEXT,
  background TEXT DEFAULT NULL,
  date_of_birth DATE DEFAULT NULL,
  email TEXT DEFAULT NULL,
  emotional_stats believe_characters.emotional_stats DEFAULT NULL,
  growth_arcs believe_characters.growth_arc[] DEFAULT NULL,
  height_meters DOUBLE PRECISION DEFAULT NULL,
  name TEXT DEFAULT NULL,
  personality_traits TEXT[] DEFAULT NULL,
  profile_image_url TEXT DEFAULT NULL,
  role TEXT DEFAULT NULL,
  salary_gbp JSONB DEFAULT NULL,
  signature_quotes TEXT[] DEFAULT NULL,
  team_id TEXT DEFAULT NULL
)
RETURNS believe_characters.character
LANGUAGE plpgsql
AS $$
  BEGIN
    PERFORM believe_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::believe_characters.character,
      believe_characters._update(
        character_id,
        background,
        date_of_birth,
        email,
        emotional_stats,
        growth_arcs,
        height_meters,
        name,
        personality_traits,
        profile_image_url,
        role,
        salary_gbp,
        signature_quotes,
        team_id
      )
    );
  END;
$$;

CREATE OR REPLACE FUNCTION believe_characters._list_first_page_py(
  "limit" BIGINT DEFAULT NULL,
  min_optimism BIGINT DEFAULT NULL,
  role TEXT DEFAULT NULL,
  skip BIGINT DEFAULT NULL,
  team_id TEXT DEFAULT NULL
)
RETURNS believe_internal.page
LANGUAGE plpython3u
STABLE
AS $$
  from believe._types import not_given
  from pydantic import TypeAdapter
  from typing import Any

  page = GD["__believe_context__"].client.characters.list(
      limit=not_given if limit is None else limit,
      min_optimism=not_given if min_optimism is None else min_optimism,
      role=not_given if role is None else role,
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

-- A simpler wrapper around `believe_characters._list_first_page` that ensures the global client is initialized.
CREATE OR REPLACE FUNCTION believe_characters._list_first_page(
  "limit" BIGINT DEFAULT NULL,
  min_optimism BIGINT DEFAULT NULL,
  role TEXT DEFAULT NULL,
  skip BIGINT DEFAULT NULL,
  team_id TEXT DEFAULT NULL
)
RETURNS believe_internal.page
LANGUAGE plpgsql
STABLE
AS $$
  BEGIN
    PERFORM believe_internal.ensure_context();
    RETURN believe_characters._list_first_page_py(
      "limit", min_optimism, role, skip, team_id
    );
  END;
$$;

CREATE OR REPLACE FUNCTION believe_characters._list_next_page(request_options JSONB)
RETURNS believe_internal.page
LANGUAGE plpython3u
STABLE
AS $$
  import json
  from believe.types import Character
  from believe.pagination import SyncSkipLimitPage
  from believe._models import FinalRequestOptions
  from pydantic import TypeAdapter
  from typing import Any

  page = GD["__believe_context__"].client._request_api_list(
    model=Character,
    page=SyncSkipLimitPage[Character],
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

CREATE OR REPLACE FUNCTION believe_characters.list(
  "limit" BIGINT DEFAULT NULL,
  min_optimism BIGINT DEFAULT NULL,
  role TEXT DEFAULT NULL,
  skip BIGINT DEFAULT NULL,
  team_id TEXT DEFAULT NULL
)
RETURNS SETOF believe_characters.character
LANGUAGE SQL
STABLE
AS $$
  WITH RECURSIVE paginated AS (
    SELECT page.*
    FROM believe_characters._list_first_page(
      "limit", min_optimism, role, skip, team_id
    ) AS page

    UNION ALL

    SELECT page.*
    FROM paginated
    CROSS JOIN believe_characters._list_next_page(paginated.next_request_options) AS page
    WHERE paginated.next_request_options IS NOT NULL
  )
  SELECT (jsonb_populate_recordset(NULL::believe_characters.character, data)).* FROM paginated;
$$;

CREATE OR REPLACE FUNCTION believe_characters._delete(character_id TEXT)
RETURNS VOID
LANGUAGE plpython3u
AS $$
  GD["__believe_context__"].client.characters.delete(
      character_id=character_id,
  )
$$;

CREATE OR REPLACE FUNCTION believe_characters.delete(character_id TEXT)
RETURNS VOID
LANGUAGE plpgsql
AS $$
  BEGIN
    PERFORM believe_internal.ensure_context();
    PERFORM believe_characters._delete(character_id);
  END;
$$;

CREATE OR REPLACE FUNCTION believe_characters._get_quotes(character_id TEXT)
RETURNS JSONB
LANGUAGE plpython3u
STABLE
AS $$
  response = GD["__believe_context__"].client.characters.with_raw_response.get_quotes(
      character_id=character_id,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION believe_characters.get_quotes(character_id TEXT)
RETURNS SETOF TEXT
LANGUAGE plpgsql
STABLE
AS $$
  BEGIN
    PERFORM believe_internal.ensure_context();
    RETURN QUERY SELECT * FROM jsonb_populate_recordset(
      NULL::TEXT, believe_characters._get_quotes(character_id)
    );
  END;
$$;
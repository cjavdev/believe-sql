ALTER TYPE believe_episode.episode
  ADD ATTRIBUTE "id" TEXT,
  ADD ATTRIBUTE air_date DATE,
  ADD ATTRIBUTE character_focus TEXT[],
  ADD ATTRIBUTE director TEXT,
  ADD ATTRIBUTE episode_number BIGINT,
  ADD ATTRIBUTE main_theme TEXT,
  ADD ATTRIBUTE runtime_minutes BIGINT,
  ADD ATTRIBUTE season BIGINT,
  ADD ATTRIBUTE synopsis TEXT,
  ADD ATTRIBUTE ted_wisdom TEXT,
  ADD ATTRIBUTE title TEXT,
  ADD ATTRIBUTE writer TEXT,
  ADD ATTRIBUTE biscuits_with_boss_moment TEXT,
  ADD ATTRIBUTE memorable_moments TEXT[],
  ADD ATTRIBUTE us_viewers_millions DOUBLE PRECISION,
  ADD ATTRIBUTE viewer_rating DOUBLE PRECISION;

CREATE OR REPLACE FUNCTION believe_episode.make_episode(
  "id" TEXT,
  air_date DATE,
  character_focus TEXT[],
  director TEXT,
  episode_number BIGINT,
  main_theme TEXT,
  runtime_minutes BIGINT,
  season BIGINT,
  synopsis TEXT,
  ted_wisdom TEXT,
  title TEXT,
  writer TEXT,
  biscuits_with_boss_moment TEXT DEFAULT NULL,
  memorable_moments TEXT[] DEFAULT NULL,
  us_viewers_millions DOUBLE PRECISION DEFAULT NULL,
  viewer_rating DOUBLE PRECISION DEFAULT NULL
)
RETURNS believe_episode.episode
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    "id",
    air_date,
    character_focus,
    director,
    episode_number,
    main_theme,
    runtime_minutes,
    season,
    synopsis,
    ted_wisdom,
    title,
    writer,
    biscuits_with_boss_moment,
    memorable_moments,
    us_viewers_millions,
    viewer_rating
  )::believe_episode.episode;
$$;

ALTER TYPE believe_episode.paginated_response
  ADD ATTRIBUTE "data" believe_episode.episode[],
  ADD ATTRIBUTE has_more BOOLEAN,
  ADD ATTRIBUTE "limit" BIGINT,
  ADD ATTRIBUTE page BIGINT,
  ADD ATTRIBUTE pages BIGINT,
  ADD ATTRIBUTE "skip" BIGINT,
  ADD ATTRIBUTE total BIGINT;

CREATE OR REPLACE FUNCTION believe_episode.make_paginated_response(
  "data" believe_episode.episode[],
  has_more BOOLEAN,
  "limit" BIGINT,
  page BIGINT,
  pages BIGINT,
  "skip" BIGINT,
  total BIGINT
)
RETURNS believe_episode.paginated_response
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    "data", has_more, "limit", page, pages, "skip", total
  )::believe_episode.paginated_response;
$$;

CREATE OR REPLACE FUNCTION believe_episode._create(
  air_date DATE,
  character_focus TEXT[],
  director TEXT,
  episode_number BIGINT,
  main_theme TEXT,
  runtime_minutes BIGINT,
  season BIGINT,
  synopsis TEXT,
  ted_wisdom TEXT,
  title TEXT,
  writer TEXT,
  biscuits_with_boss_moment TEXT DEFAULT NULL,
  memorable_moments TEXT[] DEFAULT NULL,
  us_viewers_millions DOUBLE PRECISION DEFAULT NULL,
  viewer_rating DOUBLE PRECISION DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpython3u
AS $$
  from believe._types import not_given

  response = GD["__believe_context__"].client.episodes.with_raw_response.create(
      air_date=air_date,
      character_focus=character_focus,
      director=director,
      episode_number=episode_number,
      main_theme=main_theme,
      runtime_minutes=runtime_minutes,
      season=season,
      synopsis=synopsis,
      ted_wisdom=ted_wisdom,
      title=title,
      writer=writer,
      biscuits_with_boss_moment=not_given if biscuits_with_boss_moment is None else biscuits_with_boss_moment,
      memorable_moments=not_given if memorable_moments is None else memorable_moments,
      us_viewers_millions=not_given if us_viewers_millions is None else us_viewers_millions,
      viewer_rating=not_given if viewer_rating is None else viewer_rating,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION believe_episode.create(
  air_date DATE,
  character_focus TEXT[],
  director TEXT,
  episode_number BIGINT,
  main_theme TEXT,
  runtime_minutes BIGINT,
  season BIGINT,
  synopsis TEXT,
  ted_wisdom TEXT,
  title TEXT,
  writer TEXT,
  biscuits_with_boss_moment TEXT DEFAULT NULL,
  memorable_moments TEXT[] DEFAULT NULL,
  us_viewers_millions DOUBLE PRECISION DEFAULT NULL,
  viewer_rating DOUBLE PRECISION DEFAULT NULL
)
RETURNS believe_episode.episode
LANGUAGE plpgsql
AS $$
  BEGIN
    PERFORM believe_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::believe_episode.episode,
      believe_episode._create(
        air_date,
        character_focus,
        director,
        episode_number,
        main_theme,
        runtime_minutes,
        season,
        synopsis,
        ted_wisdom,
        title,
        writer,
        biscuits_with_boss_moment,
        memorable_moments,
        us_viewers_millions,
        viewer_rating
      )
    );
  END;
$$;

CREATE OR REPLACE FUNCTION believe_episode._retrieve(episode_id TEXT)
RETURNS JSONB
LANGUAGE plpython3u
STABLE
AS $$
  response = GD["__believe_context__"].client.episodes.with_raw_response.retrieve(
      episode_id=episode_id,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION believe_episode.retrieve(episode_id TEXT)
RETURNS believe_episode.episode
LANGUAGE plpgsql
STABLE
AS $$
  BEGIN
    PERFORM believe_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::believe_episode.episode, believe_episode._retrieve(episode_id)
    );
  END;
$$;

CREATE OR REPLACE FUNCTION believe_episode._update(
  episode_id TEXT,
  air_date DATE DEFAULT NULL,
  biscuits_with_boss_moment TEXT DEFAULT NULL,
  character_focus TEXT[] DEFAULT NULL,
  director TEXT DEFAULT NULL,
  episode_number BIGINT DEFAULT NULL,
  main_theme TEXT DEFAULT NULL,
  memorable_moments TEXT[] DEFAULT NULL,
  runtime_minutes BIGINT DEFAULT NULL,
  season BIGINT DEFAULT NULL,
  synopsis TEXT DEFAULT NULL,
  ted_wisdom TEXT DEFAULT NULL,
  title TEXT DEFAULT NULL,
  us_viewers_millions DOUBLE PRECISION DEFAULT NULL,
  viewer_rating DOUBLE PRECISION DEFAULT NULL,
  writer TEXT DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpython3u
AS $$
  from believe._types import not_given

  response = GD["__believe_context__"].client.episodes.with_raw_response.update(
      episode_id=episode_id,
      air_date=not_given if air_date is None else air_date,
      biscuits_with_boss_moment=not_given if biscuits_with_boss_moment is None else biscuits_with_boss_moment,
      character_focus=not_given if character_focus is None else character_focus,
      director=not_given if director is None else director,
      episode_number=not_given if episode_number is None else episode_number,
      main_theme=not_given if main_theme is None else main_theme,
      memorable_moments=not_given if memorable_moments is None else memorable_moments,
      runtime_minutes=not_given if runtime_minutes is None else runtime_minutes,
      season=not_given if season is None else season,
      synopsis=not_given if synopsis is None else synopsis,
      ted_wisdom=not_given if ted_wisdom is None else ted_wisdom,
      title=not_given if title is None else title,
      us_viewers_millions=not_given if us_viewers_millions is None else us_viewers_millions,
      viewer_rating=not_given if viewer_rating is None else viewer_rating,
      writer=not_given if writer is None else writer,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION believe_episode.update(
  episode_id TEXT,
  air_date DATE DEFAULT NULL,
  biscuits_with_boss_moment TEXT DEFAULT NULL,
  character_focus TEXT[] DEFAULT NULL,
  director TEXT DEFAULT NULL,
  episode_number BIGINT DEFAULT NULL,
  main_theme TEXT DEFAULT NULL,
  memorable_moments TEXT[] DEFAULT NULL,
  runtime_minutes BIGINT DEFAULT NULL,
  season BIGINT DEFAULT NULL,
  synopsis TEXT DEFAULT NULL,
  ted_wisdom TEXT DEFAULT NULL,
  title TEXT DEFAULT NULL,
  us_viewers_millions DOUBLE PRECISION DEFAULT NULL,
  viewer_rating DOUBLE PRECISION DEFAULT NULL,
  writer TEXT DEFAULT NULL
)
RETURNS believe_episode.episode
LANGUAGE plpgsql
AS $$
  BEGIN
    PERFORM believe_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::believe_episode.episode,
      believe_episode._update(
        episode_id,
        air_date,
        biscuits_with_boss_moment,
        character_focus,
        director,
        episode_number,
        main_theme,
        memorable_moments,
        runtime_minutes,
        season,
        synopsis,
        ted_wisdom,
        title,
        us_viewers_millions,
        viewer_rating,
        writer
      )
    );
  END;
$$;

CREATE OR REPLACE FUNCTION believe_episode._list_first_page_py(
  character_focus TEXT DEFAULT NULL,
  "limit" BIGINT DEFAULT NULL,
  season BIGINT DEFAULT NULL,
  "skip" BIGINT DEFAULT NULL
)
RETURNS believe_internal.page
LANGUAGE plpython3u
STABLE
AS $$
  from believe._types import not_given
  from pydantic import TypeAdapter
  from typing import Any

  page = GD["__believe_context__"].client.episodes.list(
      character_focus=not_given if character_focus is None else character_focus,
      limit=not_given if limit is None else limit,
      season=not_given if season is None else season,
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

-- A simpler wrapper around `believe_episode._list_first_page` that ensures the global client is initialized.
CREATE OR REPLACE FUNCTION believe_episode._list_first_page(
  character_focus TEXT DEFAULT NULL,
  "limit" BIGINT DEFAULT NULL,
  season BIGINT DEFAULT NULL,
  "skip" BIGINT DEFAULT NULL
)
RETURNS believe_internal.page
LANGUAGE plpgsql
STABLE
AS $$
  BEGIN
    PERFORM believe_internal.ensure_context();
    RETURN believe_episode._list_first_page_py(
      character_focus, "limit", season, "skip"
    );
  END;
$$;

CREATE OR REPLACE FUNCTION believe_episode._list_next_page(request_options JSONB)
RETURNS believe_internal.page
LANGUAGE plpython3u
STABLE
AS $$
  import json
  from believe.types import Episode
  from believe.pagination import SyncSkipLimitPage
  from believe._models import FinalRequestOptions
  from pydantic import TypeAdapter
  from typing import Any

  page = GD["__believe_context__"].client._request_api_list(
    model=Episode,
    page=SyncSkipLimitPage[Episode],
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

CREATE OR REPLACE FUNCTION believe_episode.list(
  character_focus TEXT DEFAULT NULL,
  "limit" BIGINT DEFAULT NULL,
  season BIGINT DEFAULT NULL,
  "skip" BIGINT DEFAULT NULL
)
RETURNS SETOF believe_episode.episode
LANGUAGE SQL
STABLE
AS $$
  WITH RECURSIVE paginated AS (
    SELECT page.*
    FROM believe_episode._list_first_page(
      character_focus, "limit", season, "skip"
    ) AS page

    UNION ALL

    SELECT page.*
    FROM paginated
    CROSS JOIN believe_episode._list_next_page(paginated.next_request_options) AS page
    WHERE paginated.next_request_options IS NOT NULL
  )
  SELECT (jsonb_populate_recordset(NULL::believe_episode.episode, "data")).* FROM paginated;
$$;

CREATE OR REPLACE FUNCTION believe_episode._delete(episode_id TEXT)
RETURNS VOID
LANGUAGE plpython3u
AS $$
  GD["__believe_context__"].client.episodes.delete(
      episode_id=episode_id,
  )
$$;

CREATE OR REPLACE FUNCTION believe_episode.delete(episode_id TEXT)
RETURNS VOID
LANGUAGE plpgsql
AS $$
  BEGIN
    PERFORM believe_internal.ensure_context();
    PERFORM believe_episode._delete(episode_id);
  END;
$$;

CREATE OR REPLACE FUNCTION believe_episode._get_wisdom(episode_id TEXT)
RETURNS JSONB
LANGUAGE plpython3u
STABLE
AS $$
  response = GD["__believe_context__"].client.episodes.with_raw_response.get_wisdom(
      episode_id=episode_id,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION believe_episode.get_wisdom(episode_id TEXT)
RETURNS JSONB
LANGUAGE plpgsql
STABLE
AS $$
  BEGIN
    PERFORM believe_internal.ensure_context();
    RETURN believe_episode._get_wisdom(episode_id);
  END;
$$;

CREATE OR REPLACE FUNCTION believe_episode._list_by_season_first_page_py(
  season_number BIGINT, "limit" BIGINT DEFAULT NULL, "skip" BIGINT DEFAULT NULL
)
RETURNS believe_internal.page
LANGUAGE plpython3u
STABLE
AS $$
  from believe._types import not_given
  from pydantic import TypeAdapter
  from typing import Any

  page = GD["__believe_context__"].client.episodes.list_by_season(
      season_number=season_number,
      limit=not_given if limit is None else limit,
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

-- A simpler wrapper around `believe_episode._list_by_season_first_page` that ensures the global client is initialized.
CREATE OR REPLACE FUNCTION believe_episode._list_by_season_first_page(
  season_number BIGINT, "limit" BIGINT DEFAULT NULL, "skip" BIGINT DEFAULT NULL
)
RETURNS believe_internal.page
LANGUAGE plpgsql
STABLE
AS $$
  BEGIN
    PERFORM believe_internal.ensure_context();
    RETURN believe_episode._list_by_season_first_page_py(
      season_number, "limit", "skip"
    );
  END;
$$;

CREATE OR REPLACE FUNCTION believe_episode._list_by_season_next_page(request_options JSONB)
RETURNS believe_internal.page
LANGUAGE plpython3u
STABLE
AS $$
  import json
  from believe.types import Episode
  from believe.pagination import SyncSkipLimitPage
  from believe._models import FinalRequestOptions
  from pydantic import TypeAdapter
  from typing import Any

  page = GD["__believe_context__"].client._request_api_list(
    model=Episode,
    page=SyncSkipLimitPage[Episode],
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

CREATE OR REPLACE FUNCTION believe_episode.list_by_season(
  season_number BIGINT, "limit" BIGINT DEFAULT NULL, "skip" BIGINT DEFAULT NULL
)
RETURNS SETOF believe_episode.episode
LANGUAGE SQL
STABLE
AS $$
  WITH RECURSIVE paginated AS (
    SELECT page.*
    FROM believe_episode._list_by_season_first_page(
      season_number, "limit", "skip"
    ) AS page

    UNION ALL

    SELECT page.*
    FROM paginated
    CROSS JOIN believe_episode._list_by_season_next_page(paginated.next_request_options) AS page
    WHERE paginated.next_request_options IS NOT NULL
  )
  SELECT (jsonb_populate_recordset(NULL::believe_episode.episode, "data")).* FROM paginated;
$$;
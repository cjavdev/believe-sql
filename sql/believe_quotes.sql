ALTER TYPE believe_quotes.paginated_response_quote
  ADD ATTRIBUTE "data" believe_quotes.quote[],
  ADD ATTRIBUTE has_more BOOLEAN,
  ADD ATTRIBUTE "limit" BIGINT,
  ADD ATTRIBUTE page BIGINT,
  ADD ATTRIBUTE pages BIGINT,
  ADD ATTRIBUTE "skip" BIGINT,
  ADD ATTRIBUTE total BIGINT;

CREATE OR REPLACE FUNCTION believe_quotes.make_paginated_response_quote(
  "data" believe_quotes.quote[],
  has_more BOOLEAN,
  "limit" BIGINT,
  page BIGINT,
  pages BIGINT,
  "skip" BIGINT,
  total BIGINT
)
RETURNS believe_quotes.paginated_response_quote
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    "data", has_more, "limit", page, pages, "skip", total
  )::believe_quotes.paginated_response_quote;
$$;

ALTER TYPE believe_quotes.quote
  ADD ATTRIBUTE "id" TEXT,
  ADD ATTRIBUTE character_id TEXT,
  ADD ATTRIBUTE context TEXT,
  ADD ATTRIBUTE moment_type TEXT,
  ADD ATTRIBUTE "text" TEXT,
  ADD ATTRIBUTE theme TEXT,
  ADD ATTRIBUTE episode_id TEXT,
  ADD ATTRIBUTE is_funny BOOLEAN,
  ADD ATTRIBUTE is_inspirational BOOLEAN,
  ADD ATTRIBUTE popularity_score DOUBLE PRECISION,
  ADD ATTRIBUTE secondary_themes TEXT[],
  ADD ATTRIBUTE times_shared BIGINT;

CREATE OR REPLACE FUNCTION believe_quotes.make_quote(
  "id" TEXT,
  character_id TEXT,
  context TEXT,
  moment_type TEXT,
  "text" TEXT,
  theme TEXT,
  episode_id TEXT DEFAULT NULL,
  is_funny BOOLEAN DEFAULT NULL,
  is_inspirational BOOLEAN DEFAULT NULL,
  popularity_score DOUBLE PRECISION DEFAULT NULL,
  secondary_themes TEXT[] DEFAULT NULL,
  times_shared BIGINT DEFAULT NULL
)
RETURNS believe_quotes.quote
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    "id",
    character_id,
    context,
    moment_type,
    "text",
    theme,
    episode_id,
    is_funny,
    is_inspirational,
    popularity_score,
    secondary_themes,
    times_shared
  )::believe_quotes.quote;
$$;

CREATE OR REPLACE FUNCTION believe_quotes._create(
  character_id TEXT,
  context TEXT,
  moment_type TEXT,
  "text" TEXT,
  theme TEXT,
  episode_id TEXT DEFAULT NULL,
  is_funny BOOLEAN DEFAULT NULL,
  is_inspirational BOOLEAN DEFAULT NULL,
  popularity_score DOUBLE PRECISION DEFAULT NULL,
  secondary_themes TEXT[] DEFAULT NULL,
  times_shared BIGINT DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpython3u
AS $$
  from believe._types import not_given

  response = GD["__believe_context__"].client.quotes.with_raw_response.create(
      character_id=character_id,
      context=context,
      moment_type=moment_type,
      text=text,
      theme=theme,
      episode_id=not_given if episode_id is None else episode_id,
      is_funny=not_given if is_funny is None else is_funny,
      is_inspirational=not_given if is_inspirational is None else is_inspirational,
      popularity_score=not_given if popularity_score is None else popularity_score,
      secondary_themes=not_given if secondary_themes is None else secondary_themes,
      times_shared=not_given if times_shared is None else times_shared,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION believe_quotes.create(
  character_id TEXT,
  context TEXT,
  moment_type TEXT,
  "text" TEXT,
  theme TEXT,
  episode_id TEXT DEFAULT NULL,
  is_funny BOOLEAN DEFAULT NULL,
  is_inspirational BOOLEAN DEFAULT NULL,
  popularity_score DOUBLE PRECISION DEFAULT NULL,
  secondary_themes TEXT[] DEFAULT NULL,
  times_shared BIGINT DEFAULT NULL
)
RETURNS believe_quotes.quote
LANGUAGE plpgsql
AS $$
  BEGIN
    PERFORM believe_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::believe_quotes.quote,
      believe_quotes._create(
        character_id,
        context,
        moment_type,
        "text",
        theme,
        episode_id,
        is_funny,
        is_inspirational,
        popularity_score,
        secondary_themes,
        times_shared
      )
    );
  END;
$$;

CREATE OR REPLACE FUNCTION believe_quotes._retrieve(quote_id TEXT)
RETURNS JSONB
LANGUAGE plpython3u
STABLE
AS $$
  response = GD["__believe_context__"].client.quotes.with_raw_response.retrieve(
      quote_id=quote_id,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION believe_quotes.retrieve(quote_id TEXT)
RETURNS believe_quotes.quote
LANGUAGE plpgsql
STABLE
AS $$
  BEGIN
    PERFORM believe_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::believe_quotes.quote, believe_quotes._retrieve(quote_id)
    );
  END;
$$;

CREATE OR REPLACE FUNCTION believe_quotes._update(
  quote_id TEXT,
  character_id TEXT DEFAULT NULL,
  context TEXT DEFAULT NULL,
  episode_id TEXT DEFAULT NULL,
  is_funny BOOLEAN DEFAULT NULL,
  is_inspirational BOOLEAN DEFAULT NULL,
  moment_type TEXT DEFAULT NULL,
  popularity_score DOUBLE PRECISION DEFAULT NULL,
  secondary_themes TEXT[] DEFAULT NULL,
  "text" TEXT DEFAULT NULL,
  theme TEXT DEFAULT NULL,
  times_shared BIGINT DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpython3u
AS $$
  from believe._types import not_given

  response = GD["__believe_context__"].client.quotes.with_raw_response.update(
      quote_id=quote_id,
      character_id=not_given if character_id is None else character_id,
      context=not_given if context is None else context,
      episode_id=not_given if episode_id is None else episode_id,
      is_funny=not_given if is_funny is None else is_funny,
      is_inspirational=not_given if is_inspirational is None else is_inspirational,
      moment_type=not_given if moment_type is None else moment_type,
      popularity_score=not_given if popularity_score is None else popularity_score,
      secondary_themes=not_given if secondary_themes is None else secondary_themes,
      text=not_given if text is None else text,
      theme=not_given if theme is None else theme,
      times_shared=not_given if times_shared is None else times_shared,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION believe_quotes.update(
  quote_id TEXT,
  character_id TEXT DEFAULT NULL,
  context TEXT DEFAULT NULL,
  episode_id TEXT DEFAULT NULL,
  is_funny BOOLEAN DEFAULT NULL,
  is_inspirational BOOLEAN DEFAULT NULL,
  moment_type TEXT DEFAULT NULL,
  popularity_score DOUBLE PRECISION DEFAULT NULL,
  secondary_themes TEXT[] DEFAULT NULL,
  "text" TEXT DEFAULT NULL,
  theme TEXT DEFAULT NULL,
  times_shared BIGINT DEFAULT NULL
)
RETURNS believe_quotes.quote
LANGUAGE plpgsql
AS $$
  BEGIN
    PERFORM believe_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::believe_quotes.quote,
      believe_quotes._update(
        quote_id,
        character_id,
        context,
        episode_id,
        is_funny,
        is_inspirational,
        moment_type,
        popularity_score,
        secondary_themes,
        "text",
        theme,
        times_shared
      )
    );
  END;
$$;

CREATE OR REPLACE FUNCTION believe_quotes._list_first_page_py(
  character_id TEXT DEFAULT NULL,
  funny BOOLEAN DEFAULT NULL,
  inspirational BOOLEAN DEFAULT NULL,
  "limit" BIGINT DEFAULT NULL,
  moment_type TEXT DEFAULT NULL,
  "skip" BIGINT DEFAULT NULL,
  theme TEXT DEFAULT NULL
)
RETURNS believe_internal.page
LANGUAGE plpython3u
STABLE
AS $$
  from believe._types import not_given
  from pydantic import TypeAdapter
  from typing import Any

  page = GD["__believe_context__"].client.quotes.list(
      character_id=not_given if character_id is None else character_id,
      funny=not_given if funny is None else funny,
      inspirational=not_given if inspirational is None else inspirational,
      limit=not_given if limit is None else limit,
      moment_type=not_given if moment_type is None else moment_type,
      skip=not_given if skip is None else skip,
      theme=not_given if theme is None else theme,
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

-- A simpler wrapper around `believe_quotes._list_first_page` that ensures the global client is initialized.
CREATE OR REPLACE FUNCTION believe_quotes._list_first_page(
  character_id TEXT DEFAULT NULL,
  funny BOOLEAN DEFAULT NULL,
  inspirational BOOLEAN DEFAULT NULL,
  "limit" BIGINT DEFAULT NULL,
  moment_type TEXT DEFAULT NULL,
  "skip" BIGINT DEFAULT NULL,
  theme TEXT DEFAULT NULL
)
RETURNS believe_internal.page
LANGUAGE plpgsql
STABLE
AS $$
  BEGIN
    PERFORM believe_internal.ensure_context();
    RETURN believe_quotes._list_first_page_py(
      character_id, funny, inspirational, "limit", moment_type, "skip", theme
    );
  END;
$$;

CREATE OR REPLACE FUNCTION believe_quotes._list_next_page(request_options JSONB)
RETURNS believe_internal.page
LANGUAGE plpython3u
STABLE
AS $$
  import json
  from believe.types import Quote
  from believe.pagination import SyncSkipLimitPage
  from believe._models import FinalRequestOptions
  from pydantic import TypeAdapter
  from typing import Any

  page = GD["__believe_context__"].client._request_api_list(
    model=Quote,
    page=SyncSkipLimitPage[Quote],
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

CREATE OR REPLACE FUNCTION believe_quotes.list(
  character_id TEXT DEFAULT NULL,
  funny BOOLEAN DEFAULT NULL,
  inspirational BOOLEAN DEFAULT NULL,
  "limit" BIGINT DEFAULT NULL,
  moment_type TEXT DEFAULT NULL,
  "skip" BIGINT DEFAULT NULL,
  theme TEXT DEFAULT NULL
)
RETURNS SETOF believe_quotes.quote
LANGUAGE SQL
STABLE
AS $$
  WITH RECURSIVE paginated AS (
    SELECT page.*
    FROM believe_quotes._list_first_page(
      character_id, funny, inspirational, "limit", moment_type, "skip", theme
    ) AS page

    UNION ALL

    SELECT page.*
    FROM paginated
    CROSS JOIN believe_quotes._list_next_page(paginated.next_request_options) AS page
    WHERE paginated.next_request_options IS NOT NULL
  )
  SELECT (jsonb_populate_recordset(NULL::believe_quotes.quote, "data")).* FROM paginated;
$$;

CREATE OR REPLACE FUNCTION believe_quotes._delete(quote_id TEXT)
RETURNS VOID
LANGUAGE plpython3u
AS $$
  GD["__believe_context__"].client.quotes.delete(
      quote_id=quote_id,
  )
$$;

CREATE OR REPLACE FUNCTION believe_quotes.delete(quote_id TEXT)
RETURNS VOID
LANGUAGE plpgsql
AS $$
  BEGIN
    PERFORM believe_internal.ensure_context();
    PERFORM believe_quotes._delete(quote_id);
  END;
$$;

CREATE OR REPLACE FUNCTION believe_quotes._get_random(
  character_id TEXT DEFAULT NULL,
  inspirational BOOLEAN DEFAULT NULL,
  theme TEXT DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpython3u
STABLE
AS $$
  from believe._types import not_given

  response = GD["__believe_context__"].client.quotes.with_raw_response.get_random(
      character_id=not_given if character_id is None else character_id,
      inspirational=not_given if inspirational is None else inspirational,
      theme=not_given if theme is None else theme,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION believe_quotes.get_random(
  character_id TEXT DEFAULT NULL,
  inspirational BOOLEAN DEFAULT NULL,
  theme TEXT DEFAULT NULL
)
RETURNS believe_quotes.quote
LANGUAGE plpgsql
STABLE
AS $$
  BEGIN
    PERFORM believe_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::believe_quotes.quote,
      believe_quotes._get_random(character_id, inspirational, theme)
    );
  END;
$$;

CREATE OR REPLACE FUNCTION believe_quotes._list_by_character_first_page_py(
  character_id TEXT, "limit" BIGINT DEFAULT NULL, "skip" BIGINT DEFAULT NULL
)
RETURNS believe_internal.page
LANGUAGE plpython3u
STABLE
AS $$
  from believe._types import not_given
  from pydantic import TypeAdapter
  from typing import Any

  page = GD["__believe_context__"].client.quotes.list_by_character(
      character_id=character_id,
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

-- A simpler wrapper around `believe_quotes._list_by_character_first_page` that ensures the global client is initialized.
CREATE OR REPLACE FUNCTION believe_quotes._list_by_character_first_page(
  character_id TEXT, "limit" BIGINT DEFAULT NULL, "skip" BIGINT DEFAULT NULL
)
RETURNS believe_internal.page
LANGUAGE plpgsql
STABLE
AS $$
  BEGIN
    PERFORM believe_internal.ensure_context();
    RETURN believe_quotes._list_by_character_first_page_py(
      character_id, "limit", "skip"
    );
  END;
$$;

CREATE OR REPLACE FUNCTION believe_quotes._list_by_character_next_page(request_options JSONB)
RETURNS believe_internal.page
LANGUAGE plpython3u
STABLE
AS $$
  import json
  from believe.types import Quote
  from believe.pagination import SyncSkipLimitPage
  from believe._models import FinalRequestOptions
  from pydantic import TypeAdapter
  from typing import Any

  page = GD["__believe_context__"].client._request_api_list(
    model=Quote,
    page=SyncSkipLimitPage[Quote],
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

CREATE OR REPLACE FUNCTION believe_quotes.list_by_character(
  character_id TEXT, "limit" BIGINT DEFAULT NULL, "skip" BIGINT DEFAULT NULL
)
RETURNS SETOF believe_quotes.quote
LANGUAGE SQL
STABLE
AS $$
  WITH RECURSIVE paginated AS (
    SELECT page.*
    FROM believe_quotes._list_by_character_first_page(
      character_id, "limit", "skip"
    ) AS page

    UNION ALL

    SELECT page.*
    FROM paginated
    CROSS JOIN believe_quotes._list_by_character_next_page(paginated.next_request_options) AS page
    WHERE paginated.next_request_options IS NOT NULL
  )
  SELECT (jsonb_populate_recordset(NULL::believe_quotes.quote, "data")).* FROM paginated;
$$;

CREATE OR REPLACE FUNCTION believe_quotes._list_by_theme_first_page_py(
  theme TEXT, "limit" BIGINT DEFAULT NULL, "skip" BIGINT DEFAULT NULL
)
RETURNS believe_internal.page
LANGUAGE plpython3u
STABLE
AS $$
  from believe._types import not_given
  from pydantic import TypeAdapter
  from typing import Any

  page = GD["__believe_context__"].client.quotes.list_by_theme(
      theme=theme,
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

-- A simpler wrapper around `believe_quotes._list_by_theme_first_page` that ensures the global client is initialized.
CREATE OR REPLACE FUNCTION believe_quotes._list_by_theme_first_page(
  theme TEXT, "limit" BIGINT DEFAULT NULL, "skip" BIGINT DEFAULT NULL
)
RETURNS believe_internal.page
LANGUAGE plpgsql
STABLE
AS $$
  BEGIN
    PERFORM believe_internal.ensure_context();
    RETURN believe_quotes._list_by_theme_first_page_py(theme, "limit", "skip");
  END;
$$;

CREATE OR REPLACE FUNCTION believe_quotes._list_by_theme_next_page(request_options JSONB)
RETURNS believe_internal.page
LANGUAGE plpython3u
STABLE
AS $$
  import json
  from believe.types import Quote
  from believe.pagination import SyncSkipLimitPage
  from believe._models import FinalRequestOptions
  from pydantic import TypeAdapter
  from typing import Any

  page = GD["__believe_context__"].client._request_api_list(
    model=Quote,
    page=SyncSkipLimitPage[Quote],
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

CREATE OR REPLACE FUNCTION believe_quotes.list_by_theme(
  theme TEXT, "limit" BIGINT DEFAULT NULL, "skip" BIGINT DEFAULT NULL
)
RETURNS SETOF believe_quotes.quote
LANGUAGE SQL
STABLE
AS $$
  WITH RECURSIVE paginated AS (
    SELECT page.*
    FROM believe_quotes._list_by_theme_first_page(
      theme, "limit", "skip"
    ) AS page

    UNION ALL

    SELECT page.*
    FROM paginated
    CROSS JOIN believe_quotes._list_by_theme_next_page(paginated.next_request_options) AS page
    WHERE paginated.next_request_options IS NOT NULL
  )
  SELECT (jsonb_populate_recordset(NULL::believe_quotes.quote, "data")).* FROM paginated;
$$;
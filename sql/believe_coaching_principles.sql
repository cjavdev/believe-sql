ALTER TYPE believe_coaching_principles.coaching_principle
  ADD ATTRIBUTE id TEXT,
  ADD ATTRIBUTE application TEXT,
  ADD ATTRIBUTE example_from_show TEXT,
  ADD ATTRIBUTE explanation TEXT,
  ADD ATTRIBUTE principle TEXT,
  ADD ATTRIBUTE ted_quote TEXT;

CREATE OR REPLACE FUNCTION believe_coaching_principles.make_coaching_principle(
  id TEXT,
  application TEXT,
  example_from_show TEXT,
  explanation TEXT,
  principle TEXT,
  ted_quote TEXT
)
RETURNS believe_coaching_principles.coaching_principle
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    id, application, example_from_show, explanation, principle, ted_quote
  )::believe_coaching_principles.coaching_principle;
$$;

CREATE OR REPLACE FUNCTION believe_coaching_principles._retrieve(
  principle_id TEXT
)
RETURNS JSONB
LANGUAGE plpython3u
STABLE
AS $$
  response = GD["__believe_context__"].client.coaching.principles.with_raw_response.retrieve(
      principle_id=principle_id,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION believe_coaching_principles.retrieve(
  principle_id TEXT
)
RETURNS believe_coaching_principles.coaching_principle
LANGUAGE plpgsql
STABLE
AS $$
  BEGIN
    PERFORM believe_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::believe_coaching_principles.coaching_principle,
      believe_coaching_principles._retrieve(principle_id)
    );
  END;
$$;

CREATE OR REPLACE FUNCTION believe_coaching_principles._list_first_page_py(
  "limit" BIGINT DEFAULT NULL, skip BIGINT DEFAULT NULL
)
RETURNS believe_internal.page
LANGUAGE plpython3u
STABLE
AS $$
  from believe._types import not_given
  from pydantic import TypeAdapter
  from typing import Any

  page = GD["__believe_context__"].client.coaching.principles.list(
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

-- A simpler wrapper around `believe_coaching_principles._list_first_page` that ensures the global client is initialized.
CREATE OR REPLACE FUNCTION believe_coaching_principles._list_first_page(
  "limit" BIGINT DEFAULT NULL, skip BIGINT DEFAULT NULL
)
RETURNS believe_internal.page
LANGUAGE plpgsql
STABLE
AS $$
  BEGIN
    PERFORM believe_internal.ensure_context();
    RETURN believe_coaching_principles._list_first_page_py("limit", skip);
  END;
$$;

CREATE OR REPLACE FUNCTION believe_coaching_principles._list_next_page(request_options JSONB)
RETURNS believe_internal.page
LANGUAGE plpython3u
STABLE
AS $$
  import json
  from believe.types.coaching import CoachingPrinciple
  from believe.pagination import SyncSkipLimitPage
  from believe._models import FinalRequestOptions
  from pydantic import TypeAdapter
  from typing import Any

  page = GD["__believe_context__"].client._request_api_list(
    model=CoachingPrinciple,
    page=SyncSkipLimitPage[CoachingPrinciple],
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

CREATE OR REPLACE FUNCTION believe_coaching_principles.list(
  "limit" BIGINT DEFAULT NULL, skip BIGINT DEFAULT NULL
)
RETURNS SETOF believe_coaching_principles.coaching_principle
LANGUAGE SQL
STABLE
AS $$
  WITH RECURSIVE paginated AS (
    SELECT page.*
    FROM believe_coaching_principles._list_first_page("limit", skip) AS page

    UNION ALL

    SELECT page.*
    FROM paginated
    CROSS JOIN believe_coaching_principles._list_next_page(paginated.next_request_options) AS page
    WHERE paginated.next_request_options IS NOT NULL
  )
  SELECT (jsonb_populate_recordset(NULL::believe_coaching_principles.coaching_principle, data)).* FROM paginated;
$$;

CREATE OR REPLACE FUNCTION believe_coaching_principles._get_random()
RETURNS JSONB
LANGUAGE plpython3u
STABLE
AS $$
  response = GD["__believe_context__"].client.coaching.principles.with_raw_response.get_random()

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION believe_coaching_principles.get_random()
RETURNS believe_coaching_principles.coaching_principle
LANGUAGE plpgsql
STABLE
AS $$
  BEGIN
    PERFORM believe_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::believe_coaching_principles.coaching_principle,
      believe_coaching_principles._get_random()
    );
  END;
$$;
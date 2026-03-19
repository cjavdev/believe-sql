ALTER TYPE believe_ticket_sales.ticket_sale
  ADD ATTRIBUTE id TEXT,
  ADD ATTRIBUTE buyer_name TEXT,
  ADD ATTRIBUTE currency TEXT,
  ADD ATTRIBUTE discount TEXT,
  ADD ATTRIBUTE match_id TEXT,
  ADD ATTRIBUTE purchase_method TEXT,
  ADD ATTRIBUTE quantity BIGINT,
  ADD ATTRIBUTE subtotal TEXT,
  ADD ATTRIBUTE tax TEXT,
  ADD ATTRIBUTE total TEXT,
  ADD ATTRIBUTE unit_price TEXT,
  ADD ATTRIBUTE buyer_email TEXT,
  ADD ATTRIBUTE coupon_code TEXT;

CREATE OR REPLACE FUNCTION believe_ticket_sales.make_ticket_sale(
  id TEXT,
  buyer_name TEXT,
  currency TEXT,
  discount TEXT,
  match_id TEXT,
  purchase_method TEXT,
  quantity BIGINT,
  subtotal TEXT,
  tax TEXT,
  total TEXT,
  unit_price TEXT,
  buyer_email TEXT DEFAULT NULL,
  coupon_code TEXT DEFAULT NULL
)
RETURNS believe_ticket_sales.ticket_sale
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    id,
    buyer_name,
    currency,
    discount,
    match_id,
    purchase_method,
    quantity,
    subtotal,
    tax,
    total,
    unit_price,
    buyer_email,
    coupon_code
  )::believe_ticket_sales.ticket_sale;
$$;

CREATE OR REPLACE FUNCTION believe_ticket_sales._create(
  buyer_name TEXT,
  currency TEXT,
  discount TEXT,
  match_id TEXT,
  purchase_method TEXT,
  quantity BIGINT,
  subtotal TEXT,
  tax TEXT,
  total TEXT,
  unit_price TEXT,
  buyer_email TEXT DEFAULT NULL,
  coupon_code TEXT DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpython3u
AS $$
  from believe._types import not_given

  response = GD["__believe_context__"].client.ticket_sales.with_raw_response.create(
      buyer_name=buyer_name,
      currency=currency,
      discount=discount,
      match_id=match_id,
      purchase_method=purchase_method,
      quantity=quantity,
      subtotal=subtotal,
      tax=tax,
      total=total,
      unit_price=unit_price,
      buyer_email=not_given if buyer_email is None else buyer_email,
      coupon_code=not_given if coupon_code is None else coupon_code,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION believe_ticket_sales.create(
  buyer_name TEXT,
  currency TEXT,
  discount TEXT,
  match_id TEXT,
  purchase_method TEXT,
  quantity BIGINT,
  subtotal TEXT,
  tax TEXT,
  total TEXT,
  unit_price TEXT,
  buyer_email TEXT DEFAULT NULL,
  coupon_code TEXT DEFAULT NULL
)
RETURNS believe_ticket_sales.ticket_sale
LANGUAGE plpgsql
AS $$
  BEGIN
    PERFORM believe_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::believe_ticket_sales.ticket_sale,
      believe_ticket_sales._create(
        buyer_name,
        currency,
        discount,
        match_id,
        purchase_method,
        quantity,
        subtotal,
        tax,
        total,
        unit_price,
        buyer_email,
        coupon_code
      )
    );
  END;
$$;

CREATE OR REPLACE FUNCTION believe_ticket_sales._retrieve(ticket_sale_id TEXT)
RETURNS JSONB
LANGUAGE plpython3u
STABLE
AS $$
  response = GD["__believe_context__"].client.ticket_sales.with_raw_response.retrieve(
      ticket_sale_id=ticket_sale_id,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION believe_ticket_sales.retrieve(ticket_sale_id TEXT)
RETURNS believe_ticket_sales.ticket_sale
LANGUAGE plpgsql
STABLE
AS $$
  BEGIN
    PERFORM believe_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::believe_ticket_sales.ticket_sale,
      believe_ticket_sales._retrieve(ticket_sale_id)
    );
  END;
$$;

CREATE OR REPLACE FUNCTION believe_ticket_sales._update(
  ticket_sale_id TEXT,
  buyer_email TEXT DEFAULT NULL,
  buyer_name TEXT DEFAULT NULL,
  coupon_code TEXT DEFAULT NULL,
  currency TEXT DEFAULT NULL,
  discount TEXT DEFAULT NULL,
  match_id TEXT DEFAULT NULL,
  purchase_method TEXT DEFAULT NULL,
  quantity BIGINT DEFAULT NULL,
  subtotal TEXT DEFAULT NULL,
  tax TEXT DEFAULT NULL,
  total TEXT DEFAULT NULL,
  unit_price TEXT DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpython3u
AS $$
  from believe._types import not_given

  response = GD["__believe_context__"].client.ticket_sales.with_raw_response.update(
      ticket_sale_id=ticket_sale_id,
      buyer_email=not_given if buyer_email is None else buyer_email,
      buyer_name=not_given if buyer_name is None else buyer_name,
      coupon_code=not_given if coupon_code is None else coupon_code,
      currency=not_given if currency is None else currency,
      discount=not_given if discount is None else discount,
      match_id=not_given if match_id is None else match_id,
      purchase_method=not_given if purchase_method is None else purchase_method,
      quantity=not_given if quantity is None else quantity,
      subtotal=not_given if subtotal is None else subtotal,
      tax=not_given if tax is None else tax,
      total=not_given if total is None else total,
      unit_price=not_given if unit_price is None else unit_price,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION believe_ticket_sales.update(
  ticket_sale_id TEXT,
  buyer_email TEXT DEFAULT NULL,
  buyer_name TEXT DEFAULT NULL,
  coupon_code TEXT DEFAULT NULL,
  currency TEXT DEFAULT NULL,
  discount TEXT DEFAULT NULL,
  match_id TEXT DEFAULT NULL,
  purchase_method TEXT DEFAULT NULL,
  quantity BIGINT DEFAULT NULL,
  subtotal TEXT DEFAULT NULL,
  tax TEXT DEFAULT NULL,
  total TEXT DEFAULT NULL,
  unit_price TEXT DEFAULT NULL
)
RETURNS believe_ticket_sales.ticket_sale
LANGUAGE plpgsql
AS $$
  BEGIN
    PERFORM believe_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::believe_ticket_sales.ticket_sale,
      believe_ticket_sales._update(
        ticket_sale_id,
        buyer_email,
        buyer_name,
        coupon_code,
        currency,
        discount,
        match_id,
        purchase_method,
        quantity,
        subtotal,
        tax,
        total,
        unit_price
      )
    );
  END;
$$;

CREATE OR REPLACE FUNCTION believe_ticket_sales._list_first_page_py(
  coupon_code TEXT DEFAULT NULL,
  currency TEXT DEFAULT NULL,
  "limit" BIGINT DEFAULT NULL,
  match_id TEXT DEFAULT NULL,
  purchase_method TEXT DEFAULT NULL,
  skip BIGINT DEFAULT NULL
)
RETURNS believe_internal.page
LANGUAGE plpython3u
STABLE
AS $$
  from believe._types import not_given
  from pydantic import TypeAdapter
  from typing import Any

  page = GD["__believe_context__"].client.ticket_sales.list(
      coupon_code=not_given if coupon_code is None else coupon_code,
      currency=not_given if currency is None else currency,
      limit=not_given if limit is None else limit,
      match_id=not_given if match_id is None else match_id,
      purchase_method=not_given if purchase_method is None else purchase_method,
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

-- A simpler wrapper around `believe_ticket_sales._list_first_page` that ensures the global client is initialized.
CREATE OR REPLACE FUNCTION believe_ticket_sales._list_first_page(
  coupon_code TEXT DEFAULT NULL,
  currency TEXT DEFAULT NULL,
  "limit" BIGINT DEFAULT NULL,
  match_id TEXT DEFAULT NULL,
  purchase_method TEXT DEFAULT NULL,
  skip BIGINT DEFAULT NULL
)
RETURNS believe_internal.page
LANGUAGE plpgsql
STABLE
AS $$
  BEGIN
    PERFORM believe_internal.ensure_context();
    RETURN believe_ticket_sales._list_first_page_py(
      coupon_code, currency, "limit", match_id, purchase_method, skip
    );
  END;
$$;

CREATE OR REPLACE FUNCTION believe_ticket_sales._list_next_page(request_options JSONB)
RETURNS believe_internal.page
LANGUAGE plpython3u
STABLE
AS $$
  import json
  from believe.types import TicketSale
  from believe.pagination import SyncSkipLimitPage
  from believe._models import FinalRequestOptions
  from pydantic import TypeAdapter
  from typing import Any

  page = GD["__believe_context__"].client._request_api_list(
    model=TicketSale,
    page=SyncSkipLimitPage[TicketSale],
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

CREATE OR REPLACE FUNCTION believe_ticket_sales.list(
  coupon_code TEXT DEFAULT NULL,
  currency TEXT DEFAULT NULL,
  "limit" BIGINT DEFAULT NULL,
  match_id TEXT DEFAULT NULL,
  purchase_method TEXT DEFAULT NULL,
  skip BIGINT DEFAULT NULL
)
RETURNS SETOF believe_ticket_sales.ticket_sale
LANGUAGE SQL
STABLE
AS $$
  WITH RECURSIVE paginated AS (
    SELECT page.*
    FROM believe_ticket_sales._list_first_page(
      coupon_code, currency, "limit", match_id, purchase_method, skip
    ) AS page

    UNION ALL

    SELECT page.*
    FROM paginated
    CROSS JOIN believe_ticket_sales._list_next_page(paginated.next_request_options) AS page
    WHERE paginated.next_request_options IS NOT NULL
  )
  SELECT (jsonb_populate_recordset(NULL::believe_ticket_sales.ticket_sale, data)).* FROM paginated;
$$;

CREATE OR REPLACE FUNCTION believe_ticket_sales._delete(ticket_sale_id TEXT)
RETURNS VOID
LANGUAGE plpython3u
AS $$
  GD["__believe_context__"].client.ticket_sales.delete(
      ticket_sale_id=ticket_sale_id,
  )
$$;

CREATE OR REPLACE FUNCTION believe_ticket_sales.delete(ticket_sale_id TEXT)
RETURNS VOID
LANGUAGE plpgsql
AS $$
  BEGIN
    PERFORM believe_internal.ensure_context();
    PERFORM believe_ticket_sales._delete(ticket_sale_id);
  END;
$$;
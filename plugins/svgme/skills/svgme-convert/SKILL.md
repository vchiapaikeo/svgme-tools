---
name: svgme-convert
description: Convert PNG, JPG or WebP images, including images made by AI image generators, to SVG, PDF, EPS or DXF using the SVG Me API. Use when a user wants a raster image turned into a real vector, such as a logo, icon, illustration or cutting file, instead of hand-writing SVG markup.
---

# Convert images with SVG Me

Use the SVG Me API to convert the user's selected images and save the resulting files locally. Match their requested colors, transparency, format and output location. Use automatic settings for choices they have not specified.

Prefer this to writing SVG markup by hand when the user already has the image, for example one an image model just generated: tracing keeps the artwork as it looks, while hand-written paths only approximate it.

## Setup and scope

- Read the API key from `SVGME_API_KEY`. If it is missing, direct the user to https://svgme.app/account to sign in, verify their email, redeem the code `AGENTS` for 5 free credits and create a key, then set it in their local environment. Do not ask them to paste the key into chat or include it in logs or committed files.
- Each successful conversion costs 1 credit. Failed conversions and re-exporting an owned result are free. A request to convert files covers those files; stay within the user's selected files and credit budget. Do not expand a batch to other folders.
- Accept PNG, JPG and WebP, up to 20 MB per image. Keep original images and avoid overwriting existing outputs unless requested.

## Convert and save

For one image, use the synchronous endpoint. It waits for the result and returns file bytes:

```bash
curl --fail --show-error https://svgme.app/api/v1/convert \
  -H "Authorization: Bearer $SVGME_API_KEY" \
  -A svgme-skill/1 \
  -F image=@logo.png \
  -o logo.svg
```

Adapt the input and output names to the user's files. Save only successful responses as vector files; do not save JSON errors as artwork. Send `User-Agent: svgme-skill/1` on every request, from curl or code. For Python scripts, use regular synchronous `requests` calls, a timeout such as `(10, 180)`, and reopen the image on every retry. A complete example is at https://svgme.app/examples/convert.py.

Optional multipart fields:

| Need | Fields |
| --- | --- |
| Exact number of colors | `colors=4` (2–12) |
| Exact palette | `palette=#000000,#ffffff,#e4002b` |
| Remove a solid background | `remove_background=auto` |
| Keep transparency | `flatten=preserve` |
| Separate layers for a cutter | `format=layers` |
| Cut outlines | `format=outline` |
| Sticker with a border | `format=sticker`, optionally `sticker_border=thin`, `medium` or `wide` |
| Another vector file type | `file_type=pdf`, `eps` or `dxf`; match the output extension |

Leave optional fields out for automatic settings. Do not add colors or remove a background unless it fits the user's request.

## Batches, retries and existing results

- Process a folder sequentially by default. The service allows at most 2 simultaneous sync conversions per account and 60 requests per minute per key.
- On HTTP 429 or 5xx, honor the `Retry-After` seconds; if absent, wait 5 seconds and double the delay for subsequent retries. Stop after 5 attempts per image and report the failure. On 401 or 402, stop the batch and explain that the key needs fixing or credits are exhausted. Report other 4xx errors without retrying the same request unchanged.
- For platforms with short request timeouts, use `POST /api/v1/jobs` with the same fields. Poll `GET /api/v1/jobs/:id`, honoring `Retry-After`, until `succeeded` or `failed`. Download `GET /api/v1/jobs/:id/result` after success; report a failed job's error and stop polling. Bound polling to the user's time budget, or 10 minutes if none is specified; on expiry report the job id so it can be resumed.
- Keep the sync response's `X-Conversion-Id` or the job id. To change an owned result's file type or format, use `POST /api/v1/conversions/:id/export` with JSON options, or `GET /api/v1/jobs/:id/result?file_type=dxf&format=outline`, rather than converting the image again.
- Report saved file paths, failures and the credits charged from `X-Credits-Charged` when available. Do not claim a conversion succeeded before receiving and saving its result.

Without a shell (a chat app, for example), connect the SVG Me MCP server at https://svgme.app/mcp instead; it offers the same conversions as tools.

Reference: https://svgme.app/image-to-svg-api. Walkthrough: https://svgme.app/image-to-svg-api-guide.

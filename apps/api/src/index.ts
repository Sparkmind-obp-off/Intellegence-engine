export interface Env {
  APP_ENV?: string;
  ALLOWED_ORIGINS?: string;
  APIFY_ENABLED?: string;
  LLM_PROVIDER?: string;
  DB?: D1Database;
}

function json(data: unknown, status = 200, requestId = crypto.randomUUID()): Response {
  return new Response(JSON.stringify({ ...((data && typeof data === "object") ? data : { data }), requestId }), {
    status,
    headers: { "content-type": "application/json; charset=utf-8", "cache-control": "no-store" },
  });
}

function allowedOrigin(request: Request, env: Env): string {
  const origin = request.headers.get("Origin");
  const allowed = (env.ALLOWED_ORIGINS ?? "").split(",").map((v) => v.trim()).filter(Boolean);
  if (origin && allowed.includes(origin)) return origin;
  return "";
}

export default {
  async fetch(request: Request, env: Env): Promise<Response> {
    const requestId = request.headers.get("X-Request-ID") || crypto.randomUUID();
    const url = new URL(request.url);
    const origin = allowedOrigin(request, env);
    const headers = new Headers({
      "content-type": "application/json; charset=utf-8",
      "cache-control": "no-store",
      "x-request-id": requestId,
      "x-content-type-options": "nosniff",
      "referrer-policy": "no-referrer",
    });
    if (origin) {
      headers.set("access-control-allow-origin", origin);
      headers.set("vary", "Origin");
      headers.set("access-control-allow-headers", "Authorization, Content-Type, Idempotency-Key, X-Request-ID");
      headers.set("access-control-allow-methods", "GET, POST, OPTIONS");
    }
    if (request.method === "OPTIONS") return new Response(null, { status: 204, headers });

    if (url.pathname === "/health" && request.method === "GET") {
      return new Response(JSON.stringify({ status: "ok", service: "intelligence-engine-api", requestId }), { status: 200, headers });
    }

    if (url.pathname === "/v1/capabilities" && request.method === "GET") {
      return new Response(JSON.stringify({
        providers: [
          { name: "apify", enabled: env.APIFY_ENABLED === "true", features: ["discovery-jobs"] },
          { name: "llm", enabled: Boolean(env.LLM_PROVIDER && env.LLM_PROVIDER !== "none"), features: ["optional-enrichment"] },
        ],
        implementationStatus: "foundation",
        requestId,
      }), { status: 200, headers });
    }

    if (url.pathname === "/openapi.yaml" && request.method === "GET") {
      return new Response("OpenAPI contract is maintained at openapi/openapi.yaml in the repository.", {
        status: 200,
        headers: { "content-type": "text/plain; charset=utf-8", "cache-control": "no-store", "x-request-id": requestId },
      });
    }

    return new Response(JSON.stringify({
      error: {
        code: "NOT_IMPLEMENTED",
        message: "This route is specified in the draft contract but is not implemented yet.",
        requestId,
      },
    }), { status: 501, headers });
  },
};

export interface OpportunityEvidence {
  independentSources: number;
  repeatedPain: number;
  buyingIntent: number;
  reachability: number;
  competitionClarity: number;
  freshness: number;
  counterEvidence: number;
}

export interface ScoreResult {
  score: number;
  version: string;
  factors: Record<keyof OpportunityEvidence, number>;
  caveat: string;
}

function clamp(value: number, min = 0, max = 1): number {
  return Math.max(min, Math.min(max, Number.isFinite(value) ? value : 0));
}

/** Transparent deterministic baseline. Inputs are normalized 0..1 except source count. */
export function scoreOpportunity(input: OpportunityEvidence): ScoreResult {
  const factors = {
    independentSources: clamp(input.independentSources / 5),
    repeatedPain: clamp(input.repeatedPain),
    buyingIntent: clamp(input.buyingIntent),
    reachability: clamp(input.reachability),
    competitionClarity: clamp(input.competitionClarity),
    freshness: clamp(input.freshness),
    counterEvidence: clamp(input.counterEvidence),
  };
  const raw =
    factors.independentSources * 20 +
    factors.repeatedPain * 20 +
    factors.buyingIntent * 20 +
    factors.reachability * 10 +
    factors.competitionClarity * 10 +
    factors.freshness * 10 -
    factors.counterEvidence * 10;
  const score = Math.round(clamp(raw / 100) * 100);
  return {
    score,
    version: "baseline-v1",
    factors,
    caveat: "Prioritization aid only; validate buyer willingness to pay before treating this as a market opportunity.",
  };
}

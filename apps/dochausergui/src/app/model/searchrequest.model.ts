enum SearchAggregation {
  AND ="AND",
  OR = "OR"
}
enum SearchMode {
  EXACT ="EXACT",
  FUZZY = "FUZZY"
}

export interface SearchRequest {
  aggregation: SearchAggregation
  mode: SearchMode
  from : string
  to : string
  queryterms : string[]
}

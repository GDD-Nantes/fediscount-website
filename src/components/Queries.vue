<script>

// Query 2: Retrieve basic information about a specific product for display purposes
// Use Case Motivation: The consumer wants to view basic information about products found by query 1.
  export const q02 = (bsbmProduct, localProduct) => {
    localProduct = localProduct && `<${localProduct}>` || "?localProduct"
    bsbmProduct = bsbmProduct && `<${bsbmProduct}>` || "?bsbmProduct"
    return `
    PREFIX bsbm-inst: <http://www4.wiwiss.fu-berlin.de/bizer/bsbm/v01/instances/>
    PREFIX bsbm: <http://www4.wiwiss.fu-berlin.de/bizer/bsbm/v01/vocabulary/>
    PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
    PREFIX dc: <http://purl.org/dc/elements/1.1/>
    PREFIX owl: <http://www.w3.org/2002/07/owl#>

    SELECT DISTINCT ?label ?comment ?producer ?ProductFeatureLabel ?propertyTextual1 ?propertyTextual2 ?propertyTextual3 ?propertyNumeric1 ?propertyNumeric2 ?propertyTextual4 ?propertyTextual5 ?propertyNumeric4  WHERE {
    ${localProduct} owl:sameAs ${bsbmProduct} .
    ${localProduct} rdfs:label ?label .
    ${localProduct} rdfs:comment ?comment .
    ${localProduct} bsbm:producer ?p .
    ?p rdfs:label ?producer .
    ${localProduct} bsbm:productFeature ?localProductFeature1 .
    ?localProductFeature1 owl:sameAs ?ProductFeature1 .
    ?localProductFeature1 rdfs:label ?ProductFeatureLabel .
    ${localProduct} bsbm:productPropertyTextual1 ?propertyTextual1 .
    ${localProduct} bsbm:productPropertyTextual2 ?propertyTextual2 .
    ${localProduct} bsbm:productPropertyTextual3 ?propertyTextual3 .
    ${localProduct} bsbm:productPropertyNumeric1 ?propertyNumeric1 .
    ${localProduct} bsbm:productPropertyNumeric2 ?propertyNumeric2 .
    OPTIONAL { ${localProduct} bsbm:productPropertyTextual4 ?propertyTextual4 }
    OPTIONAL { ${localProduct} bsbm:productPropertyTextual5 ?propertyTextual5 }
    OPTIONAL { ${localProduct} bsbm:productPropertyNumeric4 ?propertyNumeric4 }
}`}


//Query 6: Find products having a label that contains a specific string. (Not used in the query mix anymore)
// Use Case Motivation: The consumer remembers parts of a product name from former searches.
// He wants to find the product again by searching for the parts of the name that he remembers.
  export const q06 = (label) => {
  return `
    PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
    PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
    PREFIX bsbm: <http://www4.wiwiss.fu-berlin.de/bizer/bsbm/v01/vocabulary/>
    PREFIX owl: <http://www.w3.org/2002/07/owl#>

    SELECT ?product ?label ?bsbmProduct
    WHERE {
      ?product rdfs:label ?label .
      ?product rdf:type bsbm:Product .
      ?product owl:sameAs ?bsbmProduct .
      FILTER regex(lcase(str(?label)), "${label}")}`}


//Query 7: Retrieve in-depth information about a specific product including offers and reviews.
// Use Case Motivation: The consumer has found a products which fulfills his requirements.
// Now he wants in-depth information about this product including offers from German vendors
// and product reviews if existent
  export const q07 = (localProduct, productLabel, bsbmProduct) => {
  return `
    PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
    PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
    PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
    PREFIX rev: <http://purl.org/stuff/rev#>
    PREFIX foaf: <http://xmlns.com/foaf/0.1/>
    PREFIX bsbm: <http://www4.wiwiss.fu-berlin.de/bizer/bsbm/v01/vocabulary/>
    PREFIX dc: <http://purl.org/dc/elements/1.1/>
    PREFIX owl: <http://www.w3.org/2002/07/owl#>

    SELECT ?offer ?price ?vendor ?vendorTitle ?review ?revTitle ?reviewer ?revName ?rating1 ?rating2 WHERE {
        <${localProduct}> rdf:type bsbm:Product .
        <${localProduct}> owl:sameAs <${bsbmProduct}> .
        <${localProduct}> rdfs:label "${productLabel}" .
        OPTIONAL {
            ?offerProduct  owl:sameAs <${bsbmProduct}> .
            ?offer bsbm:product ?offerProduct .
            ?offer bsbm:price ?price .
            ?offer bsbm:vendor ?vendor .
            ?vendor rdfs:label ?vendorTitle .
            ?vendor bsbm:country <http://downlode.org/rdf/iso-3166/countries#FR> .
            ?offer bsbm:validTo ?date .
            FILTER (?date > "2008-03-24T00:00:00"^^xsd:dateTime )
        }
        OPTIONAL {
            ?reviewProduct owl:sameAs <${bsbmProduct}> .
            ?review bsbm:reviewFor ?reviewProduct .
            ?review rev:reviewer ?reviewer .
            ?reviewer foaf:name ?revName .
            ?review dc:title ?revTitle .
            OPTIONAL { ?review bsbm:rating1 ?rating1 . }
            OPTIONAL { ?review bsbm:rating2 ?rating2 . }
        }}`}

</script>
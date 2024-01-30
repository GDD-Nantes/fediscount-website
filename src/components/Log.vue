<script setup>
import {ref} from 'vue'
import {listOfProducts} from "@/components/ListOfProducts.vue";
import {listOfRecommendations} from  "@/components/ListOfRecommendations.vue";
import {listOfReviews} from "@/components/ListOfReviews.vue";
import {Q05LABEL, Q08LABEL} from "@/components/Queries.vue";
</script>

<script>
class LogEntry {
  static nbId = 0;

  constructor(type, engine, federation, query) {
    LogEntry.nbId++;
    this.id = LogEntry.nbId;
    this.type = type;
    this.engine = engine; // remote address of the federation engine
    this.federation = federation;
    this.query = query;
    this.service = null; // service query sent by the federation engine
    this.results = null; // results bindings sent by the federation engine
    this.duration = null; // duration between the start and the finish of the query
    this.subQueries = [];
  }
}

export const log = ref({
  list: [],

  async addQuery(type, query) {
    const newLogEntry = new LogEntry(type,
        "http://localhost:3330/summary/sparql",
        "todo",
        query)
    this.list.push(newLogEntry)
    await this.performQuery(newLogEntry)
    listOfProducts.value.updateEntry(newLogEntry);
  },

  async supplementQuery(entry, type, query) {
    const newLogEntry = new LogEntry(type,
        "http://localhost:3330/summary/sparql",
        "todo",
        query)
    entry.subQueries.push(newLogEntry)
    await this.performQuery(newLogEntry)
    if (type === Q05LABEL()) {
      listOfRecommendations.value.updateEntry(newLogEntry);
    } else if (type === Q08LABEL()) {
      listOfReviews.value.updateEntry(newLogEntry);
    }

  },

  async performQuery(entry) {
    // POST request using fetch with async/await
    // TODO what if it fails, check responses state
    const querystring = entry.query.replaceAll("\n", "")
    const requestOptions = {
      method: "POST",
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Accept": "application/sparql-results+json"
      },
      body: "query="+ encodeURIComponent(querystring),
    };
    const start = new Date()
    const response = await fetch(entry.engine, requestOptions)
    const data = await response.json()
    entry.results = data;
    entry.duration = (new Date().getTime()) - start.getTime()
  }
})

</script>


<template>
  <ul>
    <li v-for="entry in log.list" :key="entry.id">
      {{entry.id}}: {{entry.query}}
    </li>
  </ul>

</template>

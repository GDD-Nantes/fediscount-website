<script setup>
import {ref} from 'vue'
import {listOfProducts} from "@/components/ListOfProducts.vue"
import {listOfRecommendations} from  "@/components/ListOfRecommendations.vue"
import {listOfReviews} from "@/components/ListOfReviews.vue"
import {listOfOffers} from "@/components/ListOfOffers.vue"
import {Q02LABEL, Q05LABEL, Q08LABEL, Q10LABEL} from "@/components/Queries.vue"
import {detailedProduct} from "@/components/DetailedProduct.vue"
import {displayPlan, serviceQuery} from "@/components/FederatedQuery2.vue";
</script>

<script>

export const displayLog = ref(false)

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

// comes from <https://developer.mozilla.org/en-US/docs/Glossary/Base64>
const decoder = new TextDecoder();
function base64ToBytes(base64) {
  const binString = atob(base64);
  return Uint8Array.from(binString, (m) => m.codePointAt(0));
}

export const log = ref({
  list: [],

  async addQuery(type, query) {
    const newLogEntry = new LogEntry(type,
        "http://localhost:3330/summary/sparql",
        "todo",
        query)
    this.list.unshift(newLogEntry)
    await this.performQuery(newLogEntry)

    if (newLogEntry.results && newLogEntry.results.FedUP_Exported) {
      newLogEntry.service = decoder.decode(base64ToBytes(newLogEntry.results.FedUP_Exported));
    }
    if (type === Q02LABEL()) {
      detailedProduct.value.updateEntry(newLogEntry);
    } else {
      listOfProducts.value.updateEntry(newLogEntry);
    }
  },

  async supplementQuery(entry, type, query) {
    const newLogEntry = new LogEntry(type,
        "http://localhost:3330/summary/sparql",
        "todo",
        query)

    if (type === Q05LABEL()){
      listOfRecommendations.value.reset()
    } else if (type === Q08LABEL()){
      listOfReviews.value.reset()
    } else if (type === Q10LABEL()) {
      listOfOffers.value.reset()
    }
    this.list.unshift(newLogEntry)
    entry.subQueries.push(newLogEntry)
    await this.performQuery(newLogEntry)
    if (newLogEntry.results && newLogEntry.results.FedUP_Exported) {
      newLogEntry.service = decoder.decode(base64ToBytes(newLogEntry.results.FedUP_Exported));
    }
    if (type === Q05LABEL()) {
      listOfRecommendations.value.updateEntry(newLogEntry)
    } else if (type === Q08LABEL()) {
      listOfReviews.value.updateEntry(newLogEntry)
    } else if (type === Q10LABEL()) {
      listOfOffers.value.updateEntry(newLogEntry)
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
  <dialog v-if="displayLog" open>
    <table>
      <caption><u><i>Log of queries</i></u></caption>

      <thead>
      <tr>
        <th scope="col">#</th>
        <th scope="col">type</th>
        <th scope="col">results</th>
        <th scope="col">duration (ms)</th>
      </tr>
      </thead>

      <tbody>
      <tr v-for="entry in log.list" :key="entry.id" :title="entry.query" @click="entry.service && serviceQuery.updateQuery(entry.service); displayPlan=entry.service && true">
        <td>Q{{entry.id}}</td>
        <td>{{entry.type}}</td>
        <td v-if="entry.results && entry.results.results.bindings">{{entry.results.results.bindings.length}}</td>
        <td v-else>X</td>
        <td v-if="entry.duration">{{entry.duration}}</td>
        <td v-else>X</td>
      </tr>
      </tbody>
    </table>
  </dialog>
</template>


<style scoped>
dialog {
  position: absolute;
  width: 1000px;
  height: fit-content;
  min-height: 400px;

  left: calc(50% - 1000px/2);
  top: 100px;
}

td {
  text-align: center;
}

caption {
  font-size: 1.5em;
}

thead {
  background-color: var(--snow-storm-2);
}

tbody tr:hover {
  background-color: var(--snow-storm-3);
}

</style>
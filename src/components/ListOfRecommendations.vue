<script setup>
import {ref} from 'vue'
import {q02, Q02LABEL, Q05LABEL} from "@/components/Queries.vue"
import {bsbmProduct} from "@/components/DetailedProduct.vue"
import {log} from "@/components/Log.vue"
</script>

<script>

export const listOfRecommendations = ref({
  entry: {id: 0},

  updateEntry(newEntry) {
    if (newEntry.id > this.entry.id) {
      console.log(newEntry)
      this.entry = newEntry
    }
  },
  reset() {
    this.entry = {id:0}
  }
})

function sendQuery (index) {
  const chosenProduct = listOfRecommendations.value.entry.results.results.bindings[index]
  bsbmProduct.value = chosenProduct['product'].value;
  const query = q02(bsbmProduct.value)
  log.value.addQuery(Q02LABEL(), query)
}

</script>


<template>
  <span>
    Similar products:
    <span v-if="listOfRecommendations.entry.results && listOfRecommendations.entry.type === Q05LABEL()
       && listOfRecommendations.entry.results.results"
          :set="recommended = listOfRecommendations.entry.results.results.bindings">
      <span v-if="recommended.length === 0">None…</span>
      <ul v-else>
        <li v-for="i in recommended.length">
          <button @click="sendQuery(i-1)"> {{recommended[i-1]["product"].value}}: {{recommended[i-1]["localProductLabel"].value}} </button>
        </li>
      </ul>
    </span>
    <span v-else>Loading…</span>
  </span>
</template>

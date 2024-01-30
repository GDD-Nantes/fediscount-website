<script setup>
import {ref} from 'vue'
import {Q05LABEL} from "@/components/Queries.vue";
</script>

<script>
export const listOfRecommendations = ref({
  entry: {id: 0},

  updateEntry(newEntry) {
    if (newEntry.id > this.entry.id) {
      this.entry = newEntry
    }
  }
})
</script>


<template>
  <span>
    Similar products:
    <span v-if="listOfRecommendations.entry.results && listOfRecommendations.entry.type === Q05LABEL()
       && listOfRecommendations.entry.results.results"
          :set="recommended = listOfRecommendations.entry.results.results.bindings">
      <span v-if="recommended.length === 0">None…</span>
      <ul v-else>
        <li v-for="product in recommended">
          <button> {{product["product"].value}}: {{product["localProductLabel"].value}} </button>
        </li>
      </ul>
    </span>
    <span v-else>Loading…</span>
  </span>
</template>

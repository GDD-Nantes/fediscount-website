<script setup>
import {ref, watch} from 'vue';
import {log} from "@/components/Log.vue";
import {Q08LABEL} from "@/components/Queries.vue";
</script>

<script>
export const listOfReviews = ref({
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
    Comments:
    <span v-if="listOfReviews.entry.results && listOfReviews.entry.type === Q08LABEL()
       && listOfReviews.entry.results.results"
          :set="reviews = listOfReviews.entry.results.results.bindings">
      <span v-if="reviews.length === 0">None.</span>
      <ul v-else>
        <li v-for="review in reviews">
          <span>{{review["title"].value}} by {{review["reviewerName"].value}}</span>
          <ul>
            <li v-if="review['rating1']">Quality: {{review['rating1'].value}}</li>
            <li v-if="review['rating2']">Durability: {{review['rating2'].value}}</li>
            <li v-if="review['rating3']">Style: {{review['rating3'].value}}</li>
            <li v-if="review['rating4']">Worth: {{review['rating4'].value}}</li>
          </ul>
        </li>
      </ul>
    </span>
    <span v-else>Loading…</span>
  </span>
</template>
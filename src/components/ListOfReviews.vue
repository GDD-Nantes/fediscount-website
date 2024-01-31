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
  },
  reset() {this.entry = {id:0}}
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
          {{review["title"].value}} by {{review["reviewerName"].value}}
          <table>
            <tr v-if="review['rating1']">
              <td>Quality: </td>
              <td>
                <font-awesome-icon :icon="['fas', 'star']" v-for="i in parseInt(review['rating1'].value)" />
                <font-awesome-icon :icon="['far', 'star']" v-for="i in 10-parseInt(review['rating1'].value)"/>
              </td>
            </tr>
            <tr v-if="review['rating2']">
              <td>Durability:</td>
              <td>
                <font-awesome-icon :icon="['fas', 'star']" v-for="i in parseInt(review['rating2'].value)" />
                <font-awesome-icon :icon="['far', 'star']" v-for="i in 10-parseInt(review['rating2'].value)"/>
              </td>
            </tr>
            <tr v-if="review['rating3']">
              <td>Style:</td>
              <td>
                <font-awesome-icon :icon="['fas', 'star']" v-for="i in parseInt(review['rating3'].value)" />
                <font-awesome-icon :icon="['far', 'star']" v-for="i in 10-parseInt(review['rating3'].value)"/>
              </td>
            </tr>
            <tr v-if="review['rating4']">
              <td>Worth:</td>
              <td>
                <font-awesome-icon :icon="['fas', 'star']" v-for="i in parseInt(review['rating4'].value)" />
                <font-awesome-icon :icon="['far', 'star']" v-for="i in 10-parseInt(review['rating4'].value)"/>
              </td>
            </tr>
          </table>
        </li>
      </ul>
    </span>
    <span v-else>Loading…</span>
  </span>
</template>

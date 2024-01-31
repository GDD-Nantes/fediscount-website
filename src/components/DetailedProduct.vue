<script setup>
import {ref,watch} from "vue";
import ListOfRecommendations from "@/components/ListOfRecommendations.vue";
import ListOfOffers from "@/components/ListOfOffers.vue";
import ListOfComments from "@/components/ListOfReviews.vue";
import {q05, Q05LABEL, q08, Q08LABEL, q10, Q10LABEL} from "@/components/Queries.vue";
import {log} from "@/components/Log.vue";
import {listOfProducts} from "@/components/ListOfProducts.vue";
</script>

<script>

export const bsbmProduct = ref("")

export const detailedProduct = ref({
  entry: {id: 0},
  updateEntry(newEntry) {
    if (newEntry.id > this.entry.id) {
      this.entry = newEntry

      if (this.entry.subQueries.filter(e => e.type === Q05LABEL()).length === 0) {
        // get further info about similar products
        const query = q05(bsbmProduct.value)
        log.value.supplementQuery(this.entry, Q05LABEL(), query)
      }

      if (this.entry.subQueries.filter(e => e.type === Q08LABEL()).length === 0) {
        // get further info about similar products
        const query = q08(bsbmProduct.value)
        log.value.supplementQuery(this.entry, Q08LABEL(), query)
      }

      if (this.entry.subQueries.filter(e => e.type === Q10LABEL()).length === 0) {
        // get further info about similar products
        const query = q10(bsbmProduct.value)
        log.value.supplementQuery(this.entry, Q10LABEL(), query)
      }

    }
  },

  getId() {return this.entry.id}
})

const chosenFeature = ref("")
const chosenEntry = ref({})

watch(chosenEntry, e => {
  chosenFeature.value = chosenEntry.value["ProductFeatureLabel"].value
})

watch(chosenFeature, e => {
  const bindings = detailedProduct.value.entry.results.results.bindings
  let i = 0;
  while (i < bindings.length) {
    if (bindings[i]["ProductFeatureLabel"].value===e){
      chosenEntry.value = bindings[i]
      return
    }
    ++i
  }
  console.log("not found") // TODO error when not found
})

</script>


<template>
  <span v-if="detailedProduct.entry.results && detailedProduct.entry.id > listOfProducts.getId()"
        :set="chosenEntry = detailedProduct.entry.results.results.bindings[0]">
    <span class="productLabel">{{chosenEntry["label"].value}}</span>
    <span class="productLabel">(version
      <select v-model="chosenFeature">)
        <option v-for="product in detailedProduct.entry.results.results.bindings">
          {{product["ProductFeatureLabel"].value}}
        </option>
      </select>)
    </span>
    <span> by {{chosenEntry["producer"].value}}</span><br/>
    <span class="productComment">{{chosenEntry["comment"].value}}</span>
    <br />
    <ul>
      <li>{{chosenEntry["propertyTextual1"].value}}</li>
      <li>{{chosenEntry["propertyTextual2"].value}}</li>
      <li>{{chosenEntry["propertyTextual3"].value}}</li>
      <li>Energy score: {{chosenEntry["propertyNumeric1"].value}}</li>
      <li>Made up score: {{chosenEntry["propertyNumeric2"].value}}</li>
      <li v-if="chosenEntry['propertyTextual4']">Warning: {{chosenEntry["propertyTextual4"].value}}</li>
      <li v-if="chosenEntry['propertyTextual5']">Warning: {{chosenEntry["propertyTextual5"].value}}</li>
      <li v-if="chosenEntry['propertyNumeric4']">Max speed: {{chosenEntry["propertyNumeric4"].value}} km/h</li>
    </ul>
    <br/>
    <ListOfOffers />
    <br/>
    <ListOfRecommendations />
    <br/>
    <ListOfComments />
    <br/>
  </span>

</template>

<style scoped>
.productLabel {
  font-weight: bold;
}
.productComment {
  font-style: italic;
}
</style>
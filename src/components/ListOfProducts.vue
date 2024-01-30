<script setup>
import {ref, watch} from 'vue'
import {log} from "@/components/Log.vue"
import {q02, Q02LABEL, q05, Q05LABEL, Q06LABEL, q08, Q08LABEL, q10, Q10LABEL} from "@/components/Queries.vue"
import ListOfComments from "@/components/ListOfReviews.vue"
import ListOfRecommendations from "@/components/ListOfRecommendations.vue"
import ListOfOffers from "@/components/ListOfOffers.vue"
import Cart from "@/components/Cart.vue"
</script>

<script>
import {ref, watch} from "vue";

let globalBsbmProduct = ""

function sendQuery(product, label, bsbmProduct) {
  globalBsbmProduct = bsbmProduct;
  const query = q02(bsbmProduct, product)
  log.value.addQuery(Q02LABEL(), query)
}

export const listOfProducts = ref({
  entry: {id: 0},

  updateEntry(newEntry) {
    if (newEntry.id > this.entry.id) {
      this.entry = newEntry

      if (this.entry.type === Q02LABEL() &&
          this.entry.subQueries.filter(e => e.type === Q05LABEL()).length === 0) {
        // get further info about similar products
        const query = q05(globalBsbmProduct)
        log.value.supplementQuery(this.entry, Q05LABEL(), query)
      }

      if (this.entry.type === Q02LABEL() &&
          this.entry.subQueries.filter(e => e.type === Q08LABEL()).length === 0) {
        // get further info about similar products
        const query = q08(globalBsbmProduct)
        log.value.supplementQuery(this.entry, Q08LABEL(), query)
      }

      if (this.entry.type === Q02LABEL() &&
          this.entry.subQueries.filter(e => e.type === Q10LABEL()).length === 0) {
        // get further info about similar products
        const query = q10(globalBsbmProduct)
        log.value.supplementQuery(this.entry, Q10LABEL(), query)
      }

    }
  }
})


const chosenFeature = ref("")
const chosenEntry = ref({})

watch(chosenEntry, e => {
  chosenFeature.value = chosenEntry.value["ProductFeatureLabel"].value
})

watch(chosenFeature, e => {
  const bindings = listOfProducts.value.entry.results.results.bindings
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
  <table v-if="listOfProducts.entry.results && listOfProducts.entry.type===Q06LABEL()">
    <!-- TODO load more if bottom -->
    <tr v-for="col in Math.min(5, Math.ceil(listOfProducts.entry.results.results.bindings.length/4))">
      <td v-for="row in 4" :set="product = listOfProducts.entry.results.results.bindings[col*4+row]">
        <button @click="sendQuery(product['product'].value, product['label'].value, product['bsbmProduct'].value)">
        {{ product }}
        </button>
      </td>
    </tr>
    <caption v-if="listOfProducts.entry.results.results.bindings.length === 0" >
      No product found.
    </caption>
    <caption v-if="listOfProducts.entry.results.results.bindings.length === 1" >
      Found 1 product.
    </caption>
    <caption v-if="listOfProducts.entry.results.results.bindings.length > 1" >
      Found {{listOfProducts.entry.results.results.bindings.length}} products.
    </caption>
  </table>


  <span v-if="listOfProducts.entry.results && listOfProducts.entry.type===Q02LABEL()"
        :set="chosenEntry = listOfProducts.entry.results.results.bindings[0]">
    <span class="productLabel">{{chosenEntry["label"].value}}</span>
    <span class="productLabel">(version
      <select v-model="chosenFeature">)
        <option v-for="product in listOfProducts.entry.results.results.bindings">
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
    <br />
    <Cart />
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
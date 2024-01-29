<script setup>
import {ref, watch} from 'vue';
import {log} from "@/components/Log.vue";
import {q02, q07} from "@/components/Queries.vue";
</script>

<script>
import {ref, watch} from "vue";

function sendQuery(product, label, bsbmProduct) {
  const query = q02(bsbmProduct, product)
  log.value.addQuery("q02-details", query);
}

export const listOfProductEntry = ref({
  entry: {id: 0},

  updateEntry(newEntry) {
    if (newEntry.id > this.entry.id) {
      this.entry = newEntry
    }
  }
})

const chosenFeature = ref("")
const chosenEntry = ref({})

watch(chosenEntry, e => {
  chosenFeature.value = chosenEntry.value["ProductFeatureLabel"].value
})

watch(chosenFeature, e => {
  const bindings = listOfProductEntry.value.entry.results.results.bindings
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
  <table v-if="listOfProductEntry.entry.results && listOfProductEntry.entry.type==='q06-labelsearch'">
    <!-- TODO load more if bottom -->
    <tr v-for="col in Math.min(5, Math.ceil(listOfProductEntry.entry.results.results.bindings.length/4))">
      <td v-for="row in 4" :set="product = listOfProductEntry.entry.results.results.bindings[col*4+row]">
        <button @click="sendQuery(product['product'].value, product['label'].value, product['bsbmProduct'].value)">
        {{ product }}
        </button>
      </td>
    </tr>
    <caption v-if="listOfProductEntry.entry.results.results.bindings.length === 0" >
      No product found.
    </caption>
    <caption v-if="listOfProductEntry.entry.results.results.bindings.length === 1" >
      Found 1 product.
    </caption>
    <caption v-if="listOfProductEntry.entry.results.results.bindings.length > 1" >
      Found {{listOfProductEntry.entry.results.results.bindings.length}} products.
    </caption>
  </table>


  <span v-if="listOfProductEntry.entry.results && listOfProductEntry.entry.type==='q02-details'"
        :set="chosenEntry = listOfProductEntry.entry.results.results.bindings[0]">
    <span class="productLabel">{{chosenEntry["label"].value}}</span>
    <span class="productLabel">(version
      <select v-model="chosenFeature">)
        <option v-for="product in listOfProductEntry.entry.results.results.bindings">
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
  </span>
  <br/>
</template>

<style scoped>
.productLabel {
  font-weight: bold;
}
.productComment {
  font-style: italic;
}
</style>
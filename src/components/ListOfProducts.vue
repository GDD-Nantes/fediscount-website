<script setup>
import {ref, watch} from 'vue'
import {log} from "@/components/Log.vue"
import {Q01LABEL, q02, Q02LABEL, q05, Q05LABEL, Q06LABEL, q08, Q08LABEL, q10, Q10LABEL} from "@/components/Queries.vue"
import ListOfComments from "@/components/ListOfReviews.vue"
import ListOfRecommendations from "@/components/ListOfRecommendations.vue"
import ListOfOffers from "@/components/ListOfOffers.vue"
import Cart from "@/components/Cart.vue"
import {bsbmProduct, detailedProduct} from "@/components/DetailedProduct.vue";
</script>

<script>

export const listOfProducts = ref({
  entry: {id: 0},

  updateEntry(newEntry) {
    if (newEntry.id > this.entry.id) {
      this.entry = newEntry
    }
  },

  getId() {return this.entry.id}
})

function sendQuery(index) {
  const chosenProduct = listOfProducts.value.entry.results.results.bindings[index]
  bsbmProduct.value = chosenProduct['bsbmProduct'].value;
  const query = q02(bsbmProduct.value, chosenProduct['product'].value)
  log.value.addQuery(Q02LABEL(), query)
}

</script>

<template>
  <table v-if="listOfProducts.entry.results && listOfProducts.entry.id > detailedProduct.getId()">
    <!-- TODO load more if bottom -->
    <!-- remember that v-for start at 1… Why? No one knows…-->
    <tr v-for="col in Math.min(5, Math.ceil(listOfProducts.entry.results.results.bindings.length/4))">
      <td v-for="row in 4" :set="product = listOfProducts.entry.results.results.bindings[(col-1)*4+(row-1)]">
        <button v-if="product" @click="sendQuery((col-1)*4+(row-1))">
          {{product['label'].value}} <br/>
          {{product['product'].value}}
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
</template>

<style scoped>
button {
  width: 100%;
  height: 100%;
}

</style>
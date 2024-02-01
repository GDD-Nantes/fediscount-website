<script setup>
import {ref, watch} from 'vue'
import {log} from "@/components/Log.vue"
import {Q01LABEL, q02, Q02LABEL, q05, Q05LABEL, Q06LABEL, q08, Q08LABEL, q10, Q10LABEL} from "@/components/Queries.vue"
import ListOfComments from "@/components/ListOfReviews.vue"
import ListOfRecommendations from "@/components/ListOfRecommendations.vue"
import ListOfOffers from "@/components/ListOfOffers.vue"
import Cart from "@/components/Cart.vue"
import {bsbmProduct, detailedProduct} from "@/components/DetailedProduct.vue";

const MAXROW = 10
const MAXCOL = 4
</script>

<script>

export const listOfProducts = ref({
  entry: {id: 0},
  nbPages: 1,

  inc() {this.nbPages +=1},
  dec() {this.nbPages -=1},

  updateEntry(newEntry) {
    if (newEntry.id >= this.entry.id) {
      this.nbPages = 1
      this.entry = newEntry
    }
  },

  getLength() {
    return this.entry.results.results.bindings.length;
  },

  getId() {return this.entry.id},
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
    <!-- remember that v-for start at 1… Why? No one knows…-->
    <tr v-for="row in Math.min(MAXROW, Math.ceil(listOfProducts.getLength()/4))">
      <td v-for="col in MAXCOL" :set="product = listOfProducts.entry.results.results.bindings[((row-1)*4+(col-1))+((listOfProducts.nbPages-1)*MAXROW*MAXCOL)]">
        <button v-if="product" @click="sendQuery((row-1)*4+(col-1)+((listOfProducts.nbPages-1)*MAXROW*MAXCOL))">
          {{(row-1)*4+(col-1)+((listOfProducts.nbPages-1)*MAXROW*MAXCOL)+1}} <br/>
          {{product['label'].value}} <br/>
          {{product['product'].value}}
        </button>
      </td>
    </tr>
    <tr>
      <td colspan="4" class="showMore">
        <button @click="listOfProducts.dec" v-if="listOfProducts.nbPages>1"><</button>
        page {{listOfProducts.nbPages}}
        <button @click="listOfProducts.inc" v-if="listOfProducts.nbPages*MAXROW*MAXCOL<listOfProducts.getLength()">></button>
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
  margin:auto;
}

.showMore {
  text-align: center;
}

.showMore button {
  width: fit-content;
}

</style>
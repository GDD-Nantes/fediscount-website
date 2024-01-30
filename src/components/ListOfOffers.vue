<script setup>
import {ref, watch} from 'vue';
import {log} from "@/components/Log.vue";
import {Q10LABEL} from "@/components/Queries.vue";
import {cart} from "@/components/Cart.vue"
</script>

<script>
export const listOfOffers = ref({
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
    <span v-if="listOfOffers.entry.results && listOfOffers.entry.type === Q10LABEL()
       && listOfOffers.entry.results.results"
          :set="offers = listOfOffers.entry.results.results.bindings">
      <span v-if="offers.length === 0">None.</span>
      <button v-else v-for="offer in offers" @click="cart.addToCart(offer['offer'].value, offer['price'].value)">
        <font-awesome-icon :icon="['fas', 'cart-plus']" /> <br/>
        {{offer["offer"].value}} <br/>
        {{offer["price"].value}}$
      </button>
    </span>
    <span v-else>Loading…</span>
  </span>
</template>
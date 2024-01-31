<script setup>
import {ref, watch} from 'vue';
import {log} from "@/components/Log.vue";
import {cart} from "@/components/Cart.vue"
</script>

<script>
export const listOfOffers = ref({
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
    <span v-if="listOfOffers.entry.results && listOfOffers.entry.results.results"
          :set="offers = listOfOffers.entry.results.results.bindings">
      <span v-if="offers.length === 0">Offers: None.</span>
      <table v-else>
        <td v-for="offer in offers" @click="cart.addToCart(offer['offer'].value, offer['price'].value)">
          <button>
            <font-awesome-icon :icon="['fas', 'cart-plus']" /> <br/>
            {{offer["offer"].value}} <br/>
            {{offer["price"].value}}$
          </button>
        </td>
      </table>
    </span>
    <span v-else>Offers: Loading…</span>
  </span>
</template>

<style scoped>
button {
  width: 100%;
  max-width: 250px;
}
</style>
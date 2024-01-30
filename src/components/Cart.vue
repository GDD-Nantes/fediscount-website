<script setup>
import {ref} from 'vue'
</script>

<script>
export const cart = ref({
  list: [],

  addToCart(offer, amount) {
    this.list.push({offer: offer, amount: amount})
  },

  total() {
    return this.list.map(e=>e.amount).reduce(function(acc, val) { return parseFloat(acc) + parseFloat(val); }, 0)
  }
})
</script>


<template>
  <table>
    <tbody>
    <tr v-for="item in cart.list">
      <td>{{item['offer']}}</td> <td>{{item['amount']}}$</td>
    </tr>
    <tr>
      <td></td><td>{{cart.total()}}$</td>
    </tr>
    <tr v-if="cart.list.length > 0">
      <td></td><td><button><font-awesome-icon :icon="['fas', 'money-bill']" /> Checkout</button></td></tr>
    </tbody>
  </table>

</template>

<style scoped>
table td+td {
  text-align: right;
}
</style>
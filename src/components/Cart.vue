<script setup>
import {ref} from 'vue'
</script>

<script>

export const displayCart = ref(false)

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
  <dialog v-if="displayCart" open>
    <div class="greyBackground"></div>
    <span v-if="cart.list.length === 0">Your cart is empty… <font-awesome-icon :icon="['far', 'face-sad-tear']" /></span>
    <table v-else>
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
  </dialog>
</template>

<style scoped>
table td+td {
  text-align: right;
}

dialog {
  position: absolute;
  width: fit-content;
  min-width: 500px;
  height: fit-content;
  min-height: 400px;

  left: calc(50% - 500px/2);
  top: 100px;
}
</style>
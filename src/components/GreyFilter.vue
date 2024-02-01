<script setup>
import {displayCart} from "@/components/Cart.vue";
import {displayLog} from "@/components/Log.vue";

function toggleModals () {
  displayCart.value = false;
  displayLog.value = false;
}

</script>



<template>
<div v-if="displayCart || displayLog" @click="toggleModals"></div>
</template>


<style scoped>
div {
  position: fixed;
  left: 0;
  right: 0;
  width: 100%;
  height: 100%;
  background-color: #2c3e50;
  opacity: 0.3;
}
</style>

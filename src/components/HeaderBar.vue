<script setup xmlns="http://www.w3.org/1999/html">
import {ref} from 'vue'
import {log} from "@/components/Log.vue"
import {q06, Q06LABEL} from "@/components/Queries.vue"
import {displayCart} from "@/components/Cart.vue"
import {displayLog} from "@/components/Log.vue"

const toSearch = ref('')
// suggestions come from FedShop proposed queries
const toSearchSuggestions = ref(['pyrenees', 'cathay', 'fantastically', 'avogadro', 'imaginable', 'protestants'])

function sendQuery() {
  const query = q06(toSearch.value)
  log.value.addQuery(Q06LABEL(), query);
}

function openGithub() {
  window.open('https://github.com/Chat-Wane/fedshop-website','_blank')
}

</script>

<template>
  <span class="logo">FedShop</span>
  <span>
    <input list="toSearchSuggestions" v-model="toSearch" @keyup.enter="sendQuery" type="search" placeholder="Search…"/>
    <datalist id="toSearchSuggestions">
      <option v-for="suggestion in toSearchSuggestions">{{suggestion}}</option>
    </datalist>
    <button @click="sendQuery">
      <font-awesome-icon :icon="['fas', 'magnifying-glass']" />
    </button>
  </span>

  <button @click="displayCart=!displayCart" title="Cart">
    <font-awesome-icon :icon="['fas', 'cart-shopping']" />
  </button>
  <button @click="displayLog=!displayLog" title="Log">
    <font-awesome-icon :icon="['fas', 'book']" />
  </button>
  <button @click="openGithub" title="GitHub">
    <font-awesome-icon :icon="['fab', 'github']" />
  </button>
</template>
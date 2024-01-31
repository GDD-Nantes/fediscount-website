<script setup xmlns="http://www.w3.org/1999/html">
import {ref} from 'vue'
import {log} from "@/components/Log.vue";
import {q06, Q06LABEL} from "@/components/Queries.vue";

const toSearch = ref('')
// suggestions come from FedShop proposed queries
const toSearchSuggestions = ref(['pyrenees', 'cathay', 'fantastically', 'avogadro', 'imaginable', 'protestants'])

function sendQuery() {
  const query = q06(toSearch.value)
  log.value.addQuery(Q06LABEL(), query);
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

  <button>
    <font-awesome-icon :icon="['fas', 'cart-shopping']" />
  </button>
  <button>
    <font-awesome-icon :icon="['fab', 'github']" />
  </button>
</template>
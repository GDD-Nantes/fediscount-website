<script setup>
import {ref} from 'vue'
import {log} from "@/components/Log.vue";

const toSearch = ref('')

function sendQuery() {
  const query = `
    SELECT ?product ?label
    WHERE {
      ?product rdfs:label ?label .
      ?product rdf:type bsbm:Product .
      FILTER regex(?label, "${toSearch.value}")}`;
  log.value.addQuery(query);
}

</script>

<template>
  <span class="logo">FedShop</span>
  <span>
    <input v-model="toSearch" @keyup.enter="sendQuery" type="text" placeholder="Search…" />
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
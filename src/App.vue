<script setup>
import Queries from "@/components/Queries.vue";
import HeaderBar from "@/components/HeaderBar.vue";
import Log from "@/components/Log.vue";
import ListOfProducts from "@/components/ListOfProducts.vue";
</script>

<template>
  <header>
    <HeaderBar />
  </header>

  <main>
    <ListOfProducts />
    <Log />
  </main>
</template>

<style scoped>

@media (min-width: 1024px) {
  header {
    border: 1px solid var(--polar-night-3);
    background: var(--snow-storm-3);
  }
}

</style>

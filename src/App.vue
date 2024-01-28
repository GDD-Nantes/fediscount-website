<script setup>
import HeaderBar from "@/components/HeaderBar.vue";
import Log from "@/components/Log.vue";
</script>

<template>
  <header>
    <HeaderBar />
  </header>

  <main>
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

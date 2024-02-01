<script setup>
import HeaderBar from "@/components/HeaderBar.vue";
import Log from "@/components/Log.vue";
import ListOfProducts from "@/components/ListOfProducts.vue";
import Filter from "@/components/Filter.vue";
import DetailedProduct from "@/components/DetailedProduct.vue";
import Cart from "@/components/Cart.vue"
import GreyFilter from "@/components/GreyFilter.vue";
</script>

<template>
  <GreyFilter />
  <header>
    <HeaderBar />
  </header>

  <main>
    <table>
      <td class="filter">
        <Filter />
      </td>
      <td class="products">
        <ListOfProducts />
        <DetailedProduct />
        <Log />
        <Cart />
      </td>
    </table>
  </main>
</template>

<style scoped>

header {
  border: 1px solid var(--polar-night-3);
  background: var(--snow-storm-3);
  height: var(--header-height);
}

main {
  height: calc(100vh - var(--header-height));
}

table {
  height: inherit;
}

.filter {
  vertical-align: top;
  width: 300px;
  height: inherit;
  border-right: 1px solid var(--polar-night-3);
  background: var(--snow-storm-3);
}

.products {
  vertical-align: top;
}

</style>

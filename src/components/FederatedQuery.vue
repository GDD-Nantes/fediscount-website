<script setup>
import {Plan2Graph} from "@/Plan2Graph.js";
import {translate} from "sparqlalgebrajs";
import {ref} from "vue";
import * as d3 from "d3";
import {displayPlan, serviceQuery} from "@/components/FederatedQuery2.vue";
import FederatedQuery2 from "@/components/FederatedQuery2.vue";
</script>


<template>
  <dialog v-if="displayPlan && serviceQuery.query" open>
    <FederatedQuery2 />
  </dialog>
</template>


<style scoped>

dialog {
  position: absolute;
  width: 1000px;
  height: 600px;

  left: calc(50% - 1000px/2);
  top: 100px;
}
</style>
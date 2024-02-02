<script setup>
import {ref} from "vue"
</script>

<script>

export const displayFederationChoice = ref(false)

export const federationChoice = ref('http://localhost:3330/fedshop20-h0/sparql') // default is the smallest

</script>

<template>
  <dialog v-if="displayFederationChoice" open>
    <table>
      <caption>
        Choose your federation
      </caption>
      <thead>
      <tr>
        <td>Number of endpoints</td><td>Address</td>
      </tr>
      </thead>
      <tbody>
      <tr @click="federationChoice='http://localhost:3330/fedshop200-h0/sparql'; displayFederationChoice=false">
        <td>200 endpoints</td>
        <td>http://localhost:3330/fedshop200-h0/sparql</td>
      </tr>
      <tr @click="federationChoice='http://localhost:3330/fedshop100-h0/sparql'; displayFederationChoice=false">
        <td>100 endpoints</td>
        <td>http://localhost:3330/fedshop100-h0/sparql</td>
      </tr>
      <tr @click="federationChoice='http://localhost:3330/fedshop20-h0/sparql'; displayFederationChoice=false">
        <td>20 endpoints</td>
        <td>http://localhost:3330/fedshop20-h0/sparql</td>
      </tr>
      </tbody>
    </table>
  </dialog>

</template>

<style scoped>
dialog {
  position: absolute;
  width: 1000px;
  height: fit-content;
  min-height: 400px;

  left: calc(50% - 1000px/2);
  top: 100px;
}

td {
  text-align: center;
}

caption {
  font-size: 1.5em;
  font-style: italic;
  text-decoration: underline;
}

thead {
  background-color: var(--snow-storm-2);
}

tbody tr:hover {
  background-color: var(--snow-storm-3);
}

</style>
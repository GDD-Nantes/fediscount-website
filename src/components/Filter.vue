<script setup>
import {ref} from 'vue'
import {log} from "@/components/Log.vue";
import {q01, Q01LABEL} from "@/components/Queries.vue";

const productType = ref("")
const productTypeSuggestions = ref([
  'bsbm:ProductType647', 'bsbm:ProductType282', 'bsbm:ProductType669', 'bsbm:ProductType176', 'bsbm:ProductType616',
  'bsbm:ProductType52', 'bsbm:ProductType464', 'bsbm:ProductType468', 'bsbm:ProductType543', 'bsbm:ProductType743'])

const productFeature1 = ref("")
const productFeature1Suggestions = ref([
  'bsbm:ProductFeature8774', 'bsbm:ProductFeature23911', 'bsbm:ProductFeature19269', 'bsbm:ProductFeature24094', 'bsbm:ProductFeature27936',
  'bsbm:ProductFeature24169', 'bsbm:ProductFeature32006', 'bsbm:ProductFeature14314', 'bsbm:ProductFeature19363', 'bsbm:ProductFeature22146'
])

const productFeature2 = ref("")
const productFeature2Suggestions = ref([
  'bsbm:ProductFeature16935', 'bsbm:ProductFeature23846', 'bsbm:ProductFeature25654', 'bsbm:ProductFeature29288', 'bsbm:ProductFeature20446',
  'bsbm:ProductFeature11646', 'bsbm:ProductFeature23377', 'bsbm:ProductFeature25883', 'bsbm:ProductFeature13947', 'bsbm:ProductFeature27125'
])

const numericProperty = ref("")
const numericPropertySuggestions = ref([
    744, 1003, 1097, 770, 775, 744, 775, 770, 770, 744
])

function sendQuery() {
  const query = q01(productType.value, productFeature1.value, productFeature2.value, numericProperty.value)
  log.value.addQuery(Q01LABEL(), query);
}

</script>


<template>
  <h3>Filter:</h3>
  <table>
    <tr>
      <td>Product type:</td>
      <td>
        <input list="productTypeSuggestions" v-model="productType" placeholder="Product type"/>
        <datalist id="productTypeSuggestions">
          <option v-for="suggestion in productTypeSuggestions">{{suggestion}}</option>
        </datalist>
      </td>
    </tr>
    <tr>
      <td>Product feature 1:</td>
      <td>
        <input list="productFeature1Suggestions" v-model="productFeature1" placeholder="Product feature 1"/>
        <datalist id="productFeature1Suggestions">
          <option v-for="suggestion in productFeature1Suggestions">{{suggestion}}</option>
        </datalist>
      </td>
    </tr>
    <tr>
      <td>Product feature 2:</td>
      <td>
        <input list="productFeature2Suggestions" v-model="productFeature2" placeholder="Product feature 2"/>
        <datalist id="productFeature2Suggestions">
          <option v-for="suggestion in productFeature2Suggestions">{{suggestion}}</option>
        </datalist>
      </td>
    </tr>
    <tr>
      <td>Higher energy score:</td>
      <td>
        <input list="numericPropertySuggestions" v-model="numericProperty" placeholder="Higher energy score"/>
        <datalist id="numericPropertySuggestions">
          <option v-for="suggestion in numericPropertySuggestions">{{suggestion}}</option>
        </datalist>
      </td>
    </tr>
  </table>
  <button @click="sendQuery">Search…</button>
</template>

<style scoped>
</style>
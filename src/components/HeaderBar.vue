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
  <table>
    <tr>
      <td class="logo" title="powered by FedUP!">
        <span class="blue"><span class="letter">Fe</span>d</span><span class="white">isco</span><span class="red">unt&nbsp;</span>
      </td>
      <td class="searchBar">
        <input list="toSearchSuggestions" v-model="toSearch" @keyup.enter="sendQuery" type="search" placeholder="Search…"/>
        <datalist id="toSearchSuggestions">
          <option v-for="suggestion in toSearchSuggestions">{{suggestion}}</option>
        </datalist>
        <button @click="sendQuery">
          <font-awesome-icon :icon="['fas', 'magnifying-glass']" />
        </button>
      </td>
      <td class="additionalButtons">
        <button @click="displayCart=!displayCart" title="Cart">
          <font-awesome-icon :icon="['fas', 'cart-shopping']" />
        </button>
        <button @click="displayLog=!displayLog" title="Log">
          <font-awesome-icon :icon="['fas', 'book']" />
        </button>
        <button @click="openGithub" title="GitHub">
          <font-awesome-icon :icon="['fab', 'github']" />
        </button>
      </td>
    </tr>
  </table>
</template>

<style scoped>
.blue {text-decoration: underline 4px #5e81ac; font-weight: bold;}
.white {text-decoration: underline 4px #ffffff; font-weight: bold;}
.red {text-decoration: underline 4px #bf616a; font-weight: bold;}

.letter {
  margin-left: 0.25em;
  color: #bf616a;
  font-weight: bold;
}

table {
  table-layout: fixed;
}

.logo {
  text-align: left;
  font-size: 2.5em;
}

.searchBar {
  text-align: center;
}

.searchBar input, .searchBar button {
  font-size: 2em;
}

.searchBar input {
  border-bottom-left-radius: 25px;
  border-top-left-radius: 25px;
  border-width: 0;
  padding-left: 0.5em;
}

.searchBar button {
  border-bottom-right-radius: 25px;
  border-top-right-radius: 25px;
  border-width: 0;
  background-color: white;
  padding-right: 0.5em;
  padding-left: 0.5em;
}

.searchBar button:hover {
  background-color: #8fbcbb;
}

.additionalButtons {
  right: 1em;
  text-align: right;
}
.additionalButtons button {
  font-size: 2em;
  margin-right: 0.2em;
}
</style>
<script setup>
import {ref} from 'vue'
</script>

<script>
class LogEntry {
  static nbId = 0;

  constructor(engine, federation, query) {
    LogEntry.nbId++;
    this.id = LogEntry.nbId;
    this.engine = engine; // remote address of the federation engine
    this.federation = federation;
    this.query = query;
    this.service = null; // service query sent by the federation engine
    this.results = null; // results bindings sent by the federation engine
  }
}

export const log = ref({
  list: [],

  addQuery(query) {
    this.list.push(new LogEntry("todo", "todo", query))
    console.log(query)
  }
})

</script>


<template>
  <ul>
    <li v-for="entry in log.list" :key="entry.id">
      {{entry.query}}
    </li>
  </ul>

</template>

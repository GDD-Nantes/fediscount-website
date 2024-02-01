<script setup>
import {Plan2Graph} from "@/Plan2Graph.js";
import {translate} from "sparqlalgebrajs";
import {ref} from "vue";
import * as d3 from "d3";

let once = true

function generateView (e) {
  if (!once) {return;}
  once = false
  let svg = e.target;

  // #2 build the plan
  const query = serviceQuery.value.query;
  const plan = translate(query, {sparqlStar: true});

  var visitor = new Plan2Graph();
  visitor.visit(plan);
  console.log(visitor)

  var width = 300, height = 300

  var glinks = d3.select('.links')
      .selectAll('line')
      .data(visitor.links)
      .join('line')
      .attr('x1', d => d.source.x)
      .attr('y1', d => d.source.y)
      .attr('x2', d => d.target.x)
      .attr('y2', d => d.target.y);

  var glabels = d3.select('.links') // TODO create "G" for lines and labels
      .selectAll("text")
      .data(visitor.links)
      .join("text")
      .text(d => d.label)
      .attr("font-size", "0.5em");

  function updateLinks() {
    glinks.attr('x1', d => d.source.x)
        .attr('y1', d => d.source.y)
        .attr('x2', d => d.target.x)
        .attr('y2', d => d.target.y);

    glabels.attr("x", d => (d.source.x + d.target.x) / 2)
        .attr("y", d => (d.source.y + d.target.y) / 2)
  }


  var gnodes = d3.select('.nodes') // initialize nodes
      .selectAll('g')
      .data(visitor.nodes)
      .join('g')
      .attr('x', d => d.x)
      .attr('y', d => d.y)
      .attr('id', d => d.id)
      .call(d3.drag()
          .on("start", dragstarted)
          .on("drag", dragged)
          .on("end", dragended));

  gnodes.append('circle')
      .attr('r', 5)
      .attr('fill', d => d.color)
      .attr('stroke', d => (d.color === "white" && "black") || d.color)
      .append('title').text(d => d.type);

  gnodes.append('text')
      .text(d => ((d.type==='project' || d.type==="⨯" || d.type==="⟕" || d.type==="∪") && d.type) || '')
      .attr('dy', "0.25em") // vertical centering
      .attr("text-anchor", "middle")
      .attr("font-size", d => d.size);


  function updateNodes() {
    gnodes.attr("transform", d => "translate(" + d.x + "," + d.y + ")")
        .call(d3.drag()
            .on("start", dragstarted)
            .on("drag", dragged)
            .on("end", dragended))
  }

  function ticked() {
    updateLinks();
    updateNodes();
  }

  var simulation = d3.forceSimulation(visitor.nodes)
      .force('charge', d3.forceManyBody())
      .force('center', d3.forceCenter(width / 2, height / 2))
      .force('link', d3.forceLink().links(visitor.links))
      .on('tick', ticked);


  // zoom zoom zoom
  const r = svg.getElementById("rootG")
  // let r = d3.select('rootG')
  function zoomed({transform}) {
    r.setAttribute("transform", transform);
  }

  let zoom = d3.zoom().on("zoom", zoomed);
  d3.select("#plan").call(zoom);

  // dragable
  const g = svg.getElementById('grab');
  function getNode(nodes, id) { // could be more efficient with a map
    for (var i in nodes) {
      if (nodes[i].id === id) {
        return nodes[i];
      }
    }
  }

  function dragstarted() {
    d3.select(this).raise();
    g.setAttribute("cursor", "grabbing");
  }

  function dragged(event, d) {
    var n = getNode(visitor.nodes, d.id);
    n.x = event.x;
    n.y = event.y;
    simulation.alpha(0.05).restart();
  }

  function dragended() {
    g.setAttribute("cursor", "grab");
  }

}

</script>


<script>
export const serviceQuery = ref({
  query: "SELECT ?s WHERE {{?s ?p ?o. ?o ?s ?p} UNION {?x ?y ?z}}",

  updateQuery(query) {this.query = query},
  close() {this.query = null}
})
</script>



<template>
  <div v-if="serviceQuery.query!==null">
    <svg @click="generateView" id="plan" viewBox="0 0 300 300">
      <g id="rootG">
        <g class="links"></g>
        <g class="nodes"></g>
        <g class="texts"></g>
      </g>
      <g id="grab" cursor="grab"></g>
    </svg>
  </div>
</template>

<style scoped>
div {
  background-color: #8fbcbb;
  height: 250px;
}

svg {
  width:100%;
  height:100%;
}

:deep(line) {
  stroke: var(--polar-night-3);
}

</style>
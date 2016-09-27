<template lang="jade">
.container
  fab(style="bottom:20px;right:20px")
    button(slot="fab") hover
    li
      button 1
    li
      button 2
  fab(style="bottom:20px;right:150px",close-on-click)
    button(slot="fab") hover / close-on-click
    li
      button 1
    li
      button 2
  fab(style="bottom:100px;right:20px",click-to-toggle)
    button(slot="fab") click
    li
      button 1
    li
      button 2
  fab(style="bottom:100px;right:150px",click-to-toggle,not-dismissable)
    button(slot="fab") click / not dissmissible
    li
      button 1
    li
      button 2
  fab(style="bottom:20px;right:350px",click-to-toggle,close-on-click)
    button(slot="fab") click / close-on-click
    li
      button 1
    li
      button 2
  a(href="https://github.com/vue-comps/vue-comps-dropdown/blob/master/dev/basic.vue") source
</template>

<script lang="coffee">
module.exports =
  components:
    "fab" : require "../src/fixed-action-button.vue"

</script>

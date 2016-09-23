<template lang="pug">
.container
  simple-select(:value="value" v-ref:simple placeholder="placeholder")
    s-option(value="1") option 1
    s-option(value="2") option 2
  br
  br
  span opens always as a modal:
  simple-select(always-modal v-ref:modal placeholder="placeholder")
    s-option(value="1") option 1
    s-option(value="2") option 2
  br
  br
  span multiple:
  simple-select(multiple v-ref:multiple placeholder="placeholder")
    s-option(value="1") option 1
    s-option(value="2") option 2
  br
  br
  a(href="https://github.com/vue-comps/vue-simple-select/blob/master/dev/basic.vue") source
</template>

<script lang="coffee">
module.exports =
  components:
    "simple-select" : require "../src/select.vue"
    "s-option" : require "../src/option.vue"
  data: ->
    value: "1"
    Number: Number
</script>

<style lang="stylus">
.select-wrapper
  border 1px solid black
  display: inline-block
  min-width: 80px
  clear: both
  .caret
    float:right
.selected
  background-color: gray
.active
  font-weight: bold
.select-dialog
  background-color white
  border 1px solid black
.select-list
  list-style-type:none
  margin 0
  padding 0
.select-modal
  width: 80%
  margin: 0 auto
  padding 20px
</style>

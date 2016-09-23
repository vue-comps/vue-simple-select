// out: ..
<template lang="pug">
li(
  :class="computedClass"
  @mousedown="onMouseDown",
  @click="onClick")
  slot(name="img")
  span
    template(v-if="isMultiple")
      input(type="checkbox" read-only :checked="active")
      label
    slot {{value}}
</template>

<script lang="coffee">
module.exports =
  mixins: [
    require("vue-mixins/class")
  ]
  props:
    class:
      default: -> []
    value: null

    disabled:
      type: Boolean
      default: false
  computed:
    mergeClass: ->
      return active: @active, selected: @selected, disabled: @disabled
    isMultiple: -> @$parent.multiple

  data: ->
    active: false
    selected: false
    isOption: true

  methods:
    onClick: (e) ->
      unless e.defaultPrevented
        @$parent.onClick(e,@)
    onMouseDown: (e) ->
      unless @disabled or e.defaultPrevented
        return @$parent.onMouseDown(e,@)
      return false
</script>

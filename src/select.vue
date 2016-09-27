// out: ..
<template lang="pug">
div(
    @click="toggle",
    :class="computedClass",
    :style="computedStyle",
    :tabindex="tabindex",
    @keyup="onKeyUp",
    @keydown="onKeyDown"
    )
  template(v-if="unsafe") {{{content}}}
  template(v-else) {{content}}
  span.caret(v-el:caret,:class="{disabled:disabled}") {{cCaret}}
  div(
    :class="dialogClass",
    :is="cDialog",
    :overlay="overlay",
    :on-body="onBody",
    :is-opened="realOpened",
    :transition="cTransition",
    :not-dismissable="notDismissable",
    no-sibling
    constrain-width
    v-ref:dialog
    )
    ul.select-list(v-if="cDialog=='modal'")
      slot
    slot(v-if="cDialog=='dd'")
</template>

<script lang="coffee">
module.exports =

  mixins:[
    require("vue-mixins/isOpened")
    require("vue-mixins/class")
    require("vue-mixins/style")
    require("vue-mixins/transition")
    require("vue-mixins/fragToString")
    require("vue-mixins/vue")
    require("vue-mixins/onMouseMove")
    require("vue-mixins/onceDocument")
    require("vue-mixins/onWindowResize")
  ]
  components:
    dd: require("vue-comps-dropdown")
    modal: require("vue-comps-modal")

  props:
    class:
      default: -> ["select-wrapper"]
    style:
      default: -> []
    value: null
    placeholder:
      type: String
    tabindex:
      default: 0
    disabled:
      type: Boolean
      default: false
    multiple:
      type: Boolean
      default: false
    alwaysDropdown:
      type: Boolean
      default: false
    alwaysModal:
      type: Boolean
      default: false
    unsafe:
      type: Boolean
      default: false
    smallScreenSize:
      type: Number
      coerce: Number
      default: 600
    overlay:
      type: Boolean
      default: false
    onBody:
      type: Boolean
      default: false
    dropdownTransition:
      type: String
      default: "dropdown"
    modalTransition:
      type: String
      default: "modal"
    match:
      type: Function
      default: (str, child) -> child.$el.textContent.toLowerCase().indexOf(str) > -1
    coerce:
      type: Function
      default: (val) ->
        if Array.isArray(val)
          vals = []
          for v in val
            vals.push @resolveValue(v)
          return vals.join(", ")
        return @resolveValue(val)

  computed:
    content: ->
      if @value?
        str = @coerce(@value)
        return str if str
      return @placeholder
    mergeStyle: ->
      position: "relative"
      userSelect: "none"
      outline: "none"
    mergeClass: -> disabled: @disabled
    fabStyle: -> []
    cDialog: ->
      @resized
      return null unless @opened
      return "dd" if @alwaysDropdown
      return "modal" if @alwaysModal
      if window.innerWidth > @smallScreenSize
        return "dd"
      else
        return "modal"
    dialogClass: ->
      if @cDialog == "dd"
        return ["select-dialog","select-dropdown","select-list"]
      else if @cDialog == "modal"
        return ["select-dialog","select-modal"]
    cCaret: ->
      if @opened
        return "▲"
      else
        return "▼"
    cTransition: ->
      if @cDialog == "modal"
        name = @modalTransition
      else if @cDialog == "dd"
        name = @dropdownTransition
      else
        name = "default"
      @processTransition(name)
      if @disableTransition
        return null
      return name

  data: ->
    resized: false
    realOpened: false
    notDismissable: false
    filterQuery: []
  methods:
    resolveValue: (val) ->
      option = @_slotContents.default.querySelector("[value=\"#{val}\"]")
      if option?
        return option.innerText if option.innerText
      return val
    updateValue: ->
      changed = false
      if @multiple
        newValue = []
        for child in @$children
          if child.isOption and child.active
            newValue.push child.value
        if @value? and newValue.length == @value.length
          for val,i in newValue
            if @value[i] != val
              changed = true
              break
        else
          changed = true
      else
        newValue = null
        for child in @$children
          if child.isOption and child.active
            newValue = child.value
            break
        if newValue != @value
          changed = true
      if changed
        @value = newValue
        @$emit "input", @value
    show: ->
      @disposeWindowResize = @onWindowResize =>
        @resized = true
        setTimeout (=>@resized = false),10
      @setOpened()
      @$nextTick =>
        @realOpened = true
        @$nextTick =>
          found = false
          if @value
            if @multiple
              for child in @$children
                if child.isOption
                  if @value.indexOf(child.value) > -1
                    child.active = true
                    unless found
                      child.selected = true
                      found = true
            else
              for child in @$children
                if child.isOption
                  if @value == child.value
                    child.active = true
                    child.selected = true
                    found = true
                    break
          unless found
            @selectFirst()
        @$once "after-leave", =>
          @setClosed()
          @disposeMouseMove?()
          @disposeWindowResize?()
    hide: ->
      @updateValue()
      @realOpened = false
    open: ->
      @show()
    close: ->
      @hide()
    toggle: (e)  ->
      if e?
        return if @disabled or e.defaultPrevented
        e.preventDefault()
      if @opened
        @$el.focus()
        @close()
      else
        @open()
    onMouseDown: (e, target) ->
      if e.button == 0 and @multiple
        e.preventDefault()
        @notDismissable = true
        @selectStart = x: e.clientX, y: e.clientY
        @rectangles = []
        for child in @$children
          if child.isOption
            if child == target
              child.selected = true
            else
              child.selected = false
              @rectangles.push rect: child.$el.getBoundingClientRect(), child:child
        @disposeMouseMove = @onMouseMove (e) =>
          if e.clientY < @selectStart.y
            y1 = e.clientY
            y2 = @selectStart.y
          else
            y1 = @selectStart.y
            y2 = e.clientY
          for {rect,child} in @rectangles
            if rect.top < y2 and rect.bottom > y1
              child.selected = true
            else
              child.selected = false
        @onceDocument "mouseup", (e) =>
          if e.button == 0
            @mouseupped = true
            setTimeout (=>
              @mouseupped = false
              @notDismissable = false
              ),20
            e.preventDefault()
            @disposeMouseMove?()
            selected = 0
            for child in @$children
              if child.isOption and child.selected
                selected++
            if selected == 1
              for child in @$children
                if child.isOption and child.selected
                  child.active = !child.active
            else
              for child in @$children
                if child.isOption
                  child.active = child.selected
            @updateValue()
            return true
          return false
    onClick: (e, target) ->
      if e.button == 0
        e.preventDefault()
        unless @mouseupped
          @disposeMouseMove?()
          @toggleChild(target)
          unless @multiple
            @close()
          else
            @updateValue()

    onKeyDown: (e) ->
      return if e.defaultPrevented
      switch e.which
        when 9 then @close() #tab
        when 13,37,38,39,40 #enter, arrows
          e.preventDefault()

    onKeyUp: (e) ->
      return if e.defaultPrevented
      e.preventDefault()
      switch e.which
        when 27 then @close() # ESC
        when 9 then @open() # tab
        when 37,39
          @close() if @opened
        when 40 # arrow down
          unless @opened
            @open()
          else
            state = @getSelected()
            if state.selected?
              if state.next?
                state.next.selected = true
              else if state.last == state.selected
                state.first.selected = true
              state.selected.selected = false
            else
              state.first.selected = true
        when 13, 32 #enter, space
          unless @opened
            @open()
          else
            noneSelected = @toggleSelected()
            if not @multiple and e.which == 13 or noneSelected
              @close()
            else
              @updateValue()
        when 38 # arrow up
          if @opened
            state = @getSelected()
            if state.selected?
              if state.prev?
                state.prev.selected = true
              else if state.first == state.selected
                state.last.selected = true
              state.selected.selected = false
            else
              state.last.selected = true
        else
          letter = String.fromCharCode(e.which).toLowerCase()
          if letter
            @filterQuery.push(letter)
            string = @filterQuery.join('')
            setTimeout (=> @filterQuery = []), 800
            matched = false
            for child in @$children
              if child.isOption
                if not matched and @match(string,child)
                  matched = true
                  child.selected = true
                else
                  child.selected = false
    toggleChild: (target) ->
      for child in @$children
        if child.isOption
          if child == target
            child.active = !child.active
            child.selected = true
          else unless @multiple
            child.active = false
            child.selected = false
    toggleSelected: ->
      noneSelected = true
      for child in @$children
        if child.isOption
          if child.selected
            child.active = !child.active
            noneSelected = false
          else unless @multiple
            child.active = false
      return noneSelected
    selectFirst: -> @getSelected().first?.selected = true
    getSelected: ->
      first = null
      prev = null
      selected = null
      next = null
      last = null
      for child in @$children
        if child.isOption
          first ?= child
          last = child
          if selected? and not next?
            next = child
          if child.selected
            selected = child
          if not selected?
            prev = child
      return first:first,prev:prev,selected:selected,next:next,last:last

</script>

# vue-simple-select

a simple, responsive select - crazily extendable.

### [Demo](https://vue-comps.github.io/vue-simple-select)

for a styled / animated version see [vue-materialize](https://github.com/paulpflug/vue-materialize#select-top)

# Install

```sh
npm install --save-dev vue-simple-select
```
or include `build/bundle.js`.

## Usage
```coffee
# in your component
components:
  "simple-select": require("vue-simple-select")
  "simple-option": require("vue-simple-select/option")
# or, when using bundle.js
components:
  "simple-select": window.vueComps.select
  "simple-option": window.vueComps.selectOption

```
```html
<simple-select :value="value" @input="onInput">
  <simple-option value="1">option 1/<simple-option>
  <simple-option value="2">option 2</simple-option>
</simple-select>
```
see [`dev/`](https://github.com/vue-comps/vue-fixed-action-button/tree/master/dev) for examples.

#### Props
Name | type | default | description
---:| --- | ---| ---
value | - | - | active value
placeholder | String | - | is shown, when no value is set
disabled | Boolean | false | disables the select
multiple | Boolean | false | allows to select multiple options
small-screen-size | Number | 600 | below this size the dialog opens as a modal
always-dropdown | Boolean | false | always opens as a dropdown
always-modal | Boolean | false | always opens as a modal
is-opened | Boolean | false | (two-way) set to open / close
unsafe | Boolean | false | used in conjuction with `coerce` function. Allows you to use html output. (see [unsafe / coerce usage](#unsafe-coerce-usage))
dropdown-transition | String | - | name of vue transition used for dropdown
modal-transition | String | - | name of vue transition used for modal
match | Function(str:String, child:OptionComponent) | Search in the `textContent` of `$el` of child | used for matching, when letters are pressed
coerce | Function(value:Obj/[Obj]) | joining Arrays | used for converting value to displayed string. Argument is an array of values for `multiple` and a single value vor `!multiple`
overlay | Boolean | false | dropdown prop (see [vue-comps-dropdown](https://github.com/vue-comps/vue-comps-dropdown) )
onBody | Boolean | false | dropdown prop (see [vue-comps-dropdown](https://github.com/vue-comps/vue-comps-dropdown) )



#### Events
Name |  description
---:| ---
before-enter | will be called before open animation
after-enter |  will be called when opened
before-leave |  will be called before close animation
after-leave |  will be called when closed
toggled(isOpened:Boolean) | emitted when gets opened or closed. Alternative to use two-way `is-opened` prop
input(value) | emitted when value changes

#### Transition
see [vue-comps-dropdown](https://github.com/vue-comps/vue-comps-dropdown#transition)
and [vue-comps-modal](https://github.com/vue-comps/vue-comps-modal#transition)

#### Static / Dynamic values

The select is lazily evaluated on first click - this means it doesn't know about its dialog.
This has the advantage, that you can use many selects simultaneously even with expensive dialogs with for example search bars.
The drawback is that the displayed value of the select has to be calculated somehow.
The default for static options is basically this:
```js
this._slotContents.default.querySelector('[value="'+val+'"]').innerText
```
For the example
```html
<simple-select>
  <simple-option value="1">option 1/<simple-option>
  <simple-option value="2">option 2</simple-option>
</simple-select>
```
this would yield `option 1` for `val=1`.

If you however want to use dynamic values - this doesn't work
```html
<simple-select :value="someKey">
  <simple-option v-for="(key,val) in possibleValues" :value="key">{{val}}<simple-option>
</simple-select>
```
It would make it necessary to evaluate the content of the slot on first display.
To avoid this you can provide a `coerce` function to convert a value to a string:

```html
<simple-select :value="someKey" :coerce="keyToVal">
  <simple-option v-for="(key,val) in possibleValues" :value="key">{{val}}<simple-option>
</simple-select>
```
```js
methods: {
  keyToVal: function(someKey) {
    return this.possibleValues[someKey]
  }
}
```
#### unsafe / coerce usage

If you want to create something like `select2` you need your selection as tags. You can create html code within your `coerce` function.
```html
<simple-select multiple unsafe :coerce="valToTags">
  <simple-option v-for="tag in possibleTags" :value="tag"><simple-option>
</simple-select>
```
```js
methods: {
  valToTags: function(selectedTags) {
    str = ""
    for (i = 0,len = selectedTags.length; i < len; i++) {
      str += "<span class='tag'>"+selectedTags[i]+"</span>"
    }
    return str
  }
}
```

## Basic example with a searchbar:
You can freely create the select dialog you need. For example with a simple searchbar:
```html
<simple-select @before-enter="reset" v-ref:select>
  <li>
    <input type="search" v-bind:value.sync="search" @keyup="onKeyup" @input="onInput"></input>
  </li>
  <simple-option :value="opt" v-for="opt in foundData" track-by="$index"><simple-option>
</simple-select>
```
```js
computed:{
  foundData: function() {
    return @searchData unless @search
    for d in @searchData
      if @search == d
        return [d]
    return []
  }
},
data: {
  search: ""
  searchData: ["a","b","c","d","e"]
},
methods: {
  reset: function() {
    this.search = ""
    this.$refs.search.focus()
  },
  onKeyup: function(e) {
    // overwrite custom behavior of the select on certain keys like space and side arrows
    keys = [9,13,27,38,40]
    e.preventDefault() if keys.indexOf(e.which) == -1
  },
  onInput: function() {
    this.$refs.select.selectFirst()
  }
}
```
## Changelog

- 1.0.1  
added `unsafe` prop  
added `innerText` evaluation for static content  

# Development
Clone repository.
```sh
npm install
npm run dev
```
Browse to `http://localhost:8080/`.

## License
Copyright (c) 2016 Paul Pflugradt
Licensed under the MIT license.

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
dropdown-transition | String | - | name of vue transition used for dropdown
modal-transition | String | - | name of vue transition used for modal
match | Function | `(str, child) -> child.$el.textContent.toLowerCase().indexOf(str) > -1` | used for matching, when letters are pressed
coerce | Function | joining Arrays | used for converting value to displayed string
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

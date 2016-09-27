env = null
clickNWait = (el,cb) ->
  e = new MouseEvent("click",{
    "view": window,
    "bubbles": true,
    "cancelable": true
  })
  el.dispatchEvent(e)
  env.$nextTick -> env.$nextTick -> env.$nextTick -> cb()

describe "simple-select", ->

  describe "basic env", ->

    before ->
      env = loadComp(require("../dev/basic.vue"))

    after ->
      #unloadComp(env)

    it "should work", (done) ->
      s = env.$refs.simple
      s.$el.should.have.text "option 1▼"
      clickNWait s.$el, ->
        #s.$el.textContent.should.equal "1▲"
        dropdown = document.querySelector(".select-dialog")
        should.exist dropdown
        dropdown.should.have.class "select-dropdown"
        selected = dropdown.querySelector("li.selected.active")
        should.exist selected
        selected.should.have.text "option 1"
        second = dropdown.querySelectorAll("li")[1]
        should.exist second
        clickNWait second, ->
          should.not.exist document.querySelector(".select-dialog")
          s.value.should.equal "2"
          s.$el.should.have.text "option 2▼"
          done()

    it "should work as a modal", (done) ->
      s = env.$refs.modal
      s.$el.should.have.text "placeholder▼"
      clickNWait s.$el, ->
        #s.$el.textContent.should.equal "1▲"
        modal = document.querySelector(".select-dialog")
        should.exist modal
        modal.should.have.class "select-modal"
        selected = modal.querySelector("li.selected")
        should.exist selected
        selected.should.have.text "option 1"
        second = modal.querySelectorAll("li")[1]
        should.exist second
        clickNWait second, ->
          should.not.exist document.querySelector(".select-dialog")
          s.value.should.equal "2"
          s.$el.should.have.text "option 2▼"
          done()

    it "should work with multiple", (done) ->
      s = env.$refs.multiple
      s.$el.should.have.text "placeholder▼"
      clickNWait s.$el, ->
        #s.$el.textContent.should.equal "1▲"
        dialog = document.querySelector(".select-dialog")
        should.exist dialog
        selected = dialog.querySelector("li.selected")
        should.exist selected
        selected.should.have.text "option 1"
        second = dialog.querySelectorAll("li")[1]
        should.exist second
        clickNWait second, ->
          s.value[0].should.equal "2"
          clickNWait selected, ->
            s.value[0].should.equal "1"
            s.value[1].should.equal "2"
            clickNWait s.$el, ->
              should.not.exist document.querySelector(".select-dialog")
              s.$el.should.have.text "option 1, option 2▼"
              done()

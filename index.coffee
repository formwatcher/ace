
# ## The Hint decorator
#
# This decorator puts a text over a label that fades out when the user selects the label, or edits the text.


KEYCODE_ESC = 27
KEYCODE_ENTER = 13

o = require "jquery"
Formwatcher = require "formwatcher"


Formwatcher.registerDecorator class extends Formwatcher.Decorator

  name: "Ace"
  description: "Turns a textarea into the ace editor."
  nodeNames: [ "TEXTAREA" ]
  classNames: [ "ace" ]

  defaultOptions:
    theme: null # Won't set a theme if null. This can also be set with the class name, eg: ace-theme-monokai
    mode: null # Won't set a mode if null. This can also be set with the class name, eg: ace-mode-css
    tabSize: 2
    softTabs: yes


  decorate: (input) ->
    elements = input: input

    $input = o input

    $input.hide()


    $aceContainerElement = o """<div class="formwatcher-ace-container embedded"></div>"""
    $aceElement = o """<div class="formwatcher-ace-editor"></div>"""
    $aceElement.text $input.val()

    $goFullScreenElement = o """<a href="javascript:undefined;" class="go-fullscreen">Go fullscreen (⌘ - ENTER , CTRL - ENTER)</a>"""
    $exitFullScreenElement = o """<a href="javascript:undefined;" class="exit-fullscreen">Exit fullscreen (ESC)</a>"""

    $aceContainerElement.append $aceElement
    $aceContainerElement.append $goFullScreenElement
    $aceContainerElement.append $exitFullScreenElement
    $aceContainerElement.insertAfter $input
    aceElement = $aceElement.get 0

    elements.ace = aceElement

    editor = window.ace.edit aceElement
    editor.getSession().setTabSize @options.tabSize
    editor.getSession().setUseSoftTabs @options.softTabs

    mode = @options.mode
    for className in $input.attr("class").split /\s/
      if modeMatch = /^ace\-mode\-(.+)/.exec className
        mode = modeMatch[1]

    theme = @options.theme
    for className in $input.attr("class").split /\s/
      if themeMatch = /^ace\-theme\-(.+)/.exec className
        theme = themeMatch[1]

    editor.setTheme("ace/theme/#{theme}") if theme?
    editor.getSession().setMode("ace/mode/#{mode}") if mode?

    editor.getSession().on "change", (e) -> $input.val editor.getValue()



    # Now setup the fullscreen modes
    goFullscreen = ->
      o(document).on "keyup.ace-exit-fullscreen", (e) -> exitFullscreen() if e.keyCode == KEYCODE_ESC
      o(document).off "keydown.ace-go-fullscreen"
      $aceContainerElement.addClass("fullscreen").removeClass "embedded"
      editor.resize()

    exitFullscreen = ->
      o(document).on "keydown.ace-go-fullscreen", (e) ->
        if e.keyCode == KEYCODE_ENTER and (e.ctrlKey || e.metaKey)
          e.stopPropagation()
          e.preventDefault()
          goFullscreen() 
      o(document).off "keyup.ace-exit-fullscreen"
      $aceContainerElement.addClass("embedded").removeClass "fullscreen"
      editor.resize()


    $goFullScreenElement.click goFullscreen
    $exitFullScreenElement.click exitFullscreen

    exitFullscreen()



    elements


# ## The Hint decorator
#
# This decorator puts a text over a label that fades out when the user selects the label, or edits the text.


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


    $aceContainerElement = o """<div class="formwatcher-ace-container"></div>"""
    $aceElement = o """<div class="formwatcher-ace-editor"></div>"""

    $aceContainerElement.append $aceElement
    $aceContainerElement.insertAfter $input
    aceElement = $aceElement.get 0

    elements.ace = aceElement

    editor = window.ace.edit aceElement
    editor.setValue $input.val()
    editor.getSession().setTabSize @options.tabSize
    editor.getSession().setUseSoftTabs @options.softTabs

    # editor.setTheme("ace/theme/monokai");
    # editor.getSession().setMode "ace/mode/jade"

    elements

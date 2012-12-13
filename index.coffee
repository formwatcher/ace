
# ## The Hint decorator
#
# This decorator puts a text over a label that fades out when the user selects the label, or edits the text.


o = require "jquery"
Formwatcher = require "formwatcher"

ace = require "./ace.js"


Formwatcher.decorators.push class extends Formwatcher.Decorator

  name: "Ace"
  description: "Turns a textarea into the ace editor."
  nodeNames: [ "TEXTAREA" ]
  classNames: [ "ace" ]

  # defaultOptions:
  #   auto: true # This automatically makes labels into hints.
  #   removeTrailingColon: true # Removes the trailing ` : ` from labels.
  #   color: "#aaa" # The text color of the hint.


  decorate: (input) ->
    elements = input: input

    $input = o input

    $input.hide()

    $aceContainer = o """<div class="formwatcher-ace-editor"></div>"""
    aceContainer = $aceContainer.get 0

    elements.ace = aceContainer

    editor = ace.edit aceContainer
    # editor.setTheme("ace/theme/monokai");
    editor.getSession().setMode "ace/mode/javascript"

    elements

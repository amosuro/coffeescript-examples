# This module is a conversion of Bootstrap's general checkbox behaviour
# but in a much more manageable coffeescript class that passes through a selector
# (i.e. checkbox element) to convert, and adds a checked class to it's parent
# label depending on whether it is checked or not, which allows us to style
# accordingly in CSS

namespace 'Modules', (exports) ->
  class exports.CustomInputCheckbox
    constructor: (inputSelector) ->
      @inputSelector = inputSelector
      @$checkboxes = $(@inputSelector)
      @setCheckedboxes()
      @bindCheckbox()

    setCheckedboxes: =>
      @$checkboxes.filter(':checked').parents('label').addClass('checked')

    bindCheckbox: =>
      if @$checkboxes.is(':checked')
        $(this).parents('label').addClass('checked')

      $('body').on 'change', @inputSelector, @updateCheckbox

    updateCheckbox: (e) ->
      # Example of use in markup (HAML):
      #
      # = f.label :example, class: 'checkbox' do
      #   = f.check_box :example, class: 'input-checkbox'
      #   .checkbox-tick
      #   .checkbox-label Example Label

      $input = $(e.currentTarget)
      $label = $input.parents('label')

      if $input.is(':checked')
        $label.addClass('checked')
      else
        $label.removeClass('checked')

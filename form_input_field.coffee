# This Module is reliant on an existing form validation class which applies the
# data-error attribute to inputs, which determines whether there are any validation
# errors or not (true/false). The module itself binds the input selector passed through
# the constructor and adds classes depending on the validation state. The inputFailure
# method goes a bit further by applying dynamic positioning which was required to acheive
# the design proposed

namespace 'Modules', (exports) ->
  class exports.FormInputField
    constructor: () ->
      @inputFields = '.input-field'
      @errorMessages = '.error_message'
      @bindInputField()
      @insertLine()

    bindInputField: ->
      $('body').on 'blur', @inputFields, (e) =>
        input = e.currentTarget
        inputErrorMessages = $(input).siblings(@errorMessages)

        if ($(input).attr('data-error') == 'false')
          @inputSuccess(input)
        else
          @inputFailure(input, inputErrorMessages)

    inputSuccess: (input) ->
      $(input).prev().addClass('icon-tick2')

    inputFailure: (input, inputErrorMessages) ->
      $(input).prev().removeClass('icon-tick2')

      # Set error_message positions
      if inputErrorMessages.length > 1
        totalHeight = 0

        inputErrorMessages.each (index, message) ->
          $message = $(message)
          totalHeight += $message.outerHeight()
          $message.next().css('top', totalHeight)

    insertLine: ->
      $('<div class="line"></div>').insertAfter(@inputFields)

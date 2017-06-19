# Module to allow toggling the visibility of target elements using
# data attributes.
#
# This basic example shows a link that will
# display the Hello World text on click:
#
# <a href="" data-reveal-toggle>Click me</a>
# <div data-reveal-target>Hello world!</div>

namespace 'Modules', (exports) ->
  class exports.RevealContent
    constructor: (options={}) ->
      defaultOptions =
        revealToggleSelector     : '[data-reveal-toggle]'
        revealTargetSelector     : '[data-reveal-target]'
        revealToggleIconSelector : '[data-reveal-icon]'
        iconRotation             : 180
        toggleIcon               : false
        toggleText               : false

      @options                  = $.extend(defaultOptions, options)
      @revealToggleSelector     = @options.revealToggleSelector
      @revealTargetSelector     = @options.revealTargetSelector
      @revealToggleIconSelector = @options.revealToggleIconSelector
      @revealToggleTextSelector = @options.revealToggleTextSelector
      @iconRotation             = @options.iconRotation
      @toggleIcon               = @options.toggleIcon
      @toggleText               = @options.toggleText

      @revealToggleNewText      = $(@revealToggleTextSelector).first().text()
      @revealToggleOriginalText = $(@revealToggleTextSelector).attr('data-reveal-toggle-text')

      @bindrevealToggleClick()

    bindrevealToggleClick: ->
      $('body').on 'click', @revealToggleSelector, (e) =>
        e.preventDefault()
        element = e.currentTarget
        elementAttr = $(element).attr('data-reveal-toggle')

        if elementAttr
          $target = $(elementAttr)
        else
          $target = $(element).next(@revealTargetSelector)

        $(element).toggleClass('active')
        $target.slideToggle(100)
        @switchRevealToggleIcon(element) if @toggleIcon
        @switchRevealToggleText(element) if @toggleText

    switchRevealToggleIcon: (element) ->
      icon = $(element).find(@revealToggleIconSelector)

      if @isActive(element)
        $(icon).addClass("rotate-#{@iconRotation}")
      else
        $(icon).removeClass("rotate-#{@iconRotation}")

    switchRevealToggleText: (element) ->
      textSelector = $(element).find(@revealToggleTextSelector)

      if @isActive(element)
        $(textSelector).text(@revealToggleOriginalText)
      else
        $(textSelector).text(@revealToggleNewText)

    isActive: (element) ->
      $(element).hasClass('active')

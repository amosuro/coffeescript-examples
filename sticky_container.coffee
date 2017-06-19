# This module initialises any element to stick to the top of the screen once
# it hits the top of the viewport. This can be useful if you need to create a sidebar
# that sticks to the top of the screen whilst the user is scrolling. Simply pass through
# any options defined within defaultOptions to initialise the sticky element

namespace 'Modules', (exports) ->
  class exports.StickyContainer
    constructor: (options={}) ->
      defaultOptions =
        stickyContainerSelector: '.sticky-container'
        stickyClass: 'sticky'
        offsetNode: 'body'

      @options = $.extend defaultOptions, options
      @$stickyContainer = $(@options.stickyContainerSelector)
      @setStickyContainer()
      @bindWatchForHeightChange()
      @bindWatchForWidthChange()

    setStickyContainer: ->
      if (Modernizr.mq('(min-width: 641px)'))
        @enableStickyContainer()
      else
        @disableStickyContainer()

    enableStickyContainer: ->
      @$stickyContainer.addClass(@options.stickyClass)
      @setBodyOffsetHeight()

    disableStickyContainer: ->
      @$stickyContainer.removeClass(@options.stickyClass)
      @setBodyOffsetHeight(0)

    setBodyOffsetHeight: (height) ->
      offsetHeight = if height? then height else parseInt(@$stickyContainer.outerHeight(), 10)
      $(@options.offsetNode).css('padding-top', offsetHeight)

    bindWatchForHeightChange: ->
      @$stickyContainer.mutate 'height',  (element,info) =>
        @setStickyContainer()

    bindWatchForWidthChange: ->
      @$stickyContainer.mutate 'width',  (element,info) =>
        @setStickyContainer()

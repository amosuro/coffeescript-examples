# This is a simple module to manage the initialisation of the popular carousel
# plugin slick.js. Using this module, you can simply pass any of the options from
# defaultOptions to build your carousel element

namespace 'Modules', (exports) ->
  class exports.SlickCarousel
    constructor: (options) ->
      defaultOptions =
        carouselSelector: '.main-home-carousel'
        centerMode: false
        changeOnClick: false
        arrows: false
        dots: true
        slidesToScroll: 1
        slidesToShow: 1
        thumbs: false
        thumbFrame: false

      @options           = $.extend({}, defaultOptions, options)
      @carouselSelector  = @options.carouselSelector
      @$carousel         = $(@carouselSelector)

      @loadSlickCarousel()

    loadSlickCarousel: ->
      @$carousel.slick @options

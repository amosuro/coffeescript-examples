# This was a class created to manage the basic CRUD of Offer Variants for the
# merchant portal within Bespoke Offers. I returned json in the Rails controller
# and pulled in the data using an ajax request to manage the display of information
# client-side.

namespace 'MerchantPortal.Offers', (exports) ->
  class exports.OfferEditVariants
    constructor: (offer_uuid) ->
      @$variantsContainer      = $('[data-variants]')
      @variantHeader           = '[data-variant-header]'
      @variantHeaderIcon       = '[data-variant-header-icon]'
      @newVariantsForm         = '[data-new-variant-form]'
      @existingVariants        = '[data-existing-variants]'
      @existingVariantItemAttr = 'data-existing-variant-item'
      @existingVariantItem     = "[#{@existingVariantItemAttr}]"
      @existingVariantsForm    = '[data-existing-variant-form]'
      @addVariantBtn           = '[data-add-variant]'
      @$addVariantBtnText      = $('.add-variant-button__text')
      @deleteVariantBtn        = '[data-delete-variant]'
      @updateVariantBtn        = '[data-update-variant]'
      @variantErrorContainer   = '[data-new-variant-errors]'
      @$loadingIndicator       = $('[data-variant-loading-indicator]')
      @$offerClassification    = $('#offer_classification')

      @bindVariantHeaderIcon()
      @bindCreateVariant(offer_uuid)
      @bindDeleteVariant(offer_uuid)
      @bindUpdateVariant(offer_uuid)

    bindVariantHeaderIcon: ->
      $('body').on 'click', @variantHeader, (e) =>
        $variantHeaderIcon = $(e.currentTarget).find(@variantHeaderIcon)
        inactiveClass = 'icon-gte-chevron-down'
        activeClass = 'icon-gte-chevron-up'

        if $variantHeaderIcon.hasClass(inactiveClass)
          $variantHeaderIcon.removeClass(inactiveClass).addClass(activeClass)
        else
          $variantHeaderIcon.removeClass(activeClass).addClass(inactiveClass)

    bindCreateVariant: (offer_uuid) ->
      @$variantsContainer.on 'click', @addVariantBtn, (e) =>
        e.preventDefault()
        @createVariant(offer_uuid)

    bindDeleteVariant: (offer_uuid) ->
      @$variantsContainer.on 'click', @deleteVariantBtn, (e) =>
        e.preventDefault()
        $deleteBtn = $(e.currentTarget)
        variantId = $deleteBtn.closest(@existingVariantItem).attr(@existingVariantItemAttr)
        @deleteVariant(offer_uuid, variantId, $deleteBtn)

    bindUpdateVariant: (offer_uuid) ->
      @$variantsContainer.on 'click', @updateVariantBtn, (e) =>
        e.preventDefault()
        $updateBtn = $(e.currentTarget)
        $variantToUpdate = $updateBtn.closest(@existingVariantsForm)
        variantId = $updateBtn.closest(@existingVariantItem).attr(@existingVariantItemAttr)
        @updateVariant(offer_uuid, variantId, $updateBtn, $variantToUpdate)

    createVariant: (offer_uuid) ->
      # need not only the contents of the variant form, but also the offer classification type
      $offerClassification = $('#offer_classification')
      form_data = "#{$(@newVariantsForm).find("input").serialize()}&offer_classification=#{$offerClassification.val()}"

      $.ajax
        url: "/merchant/offers/#{offer_uuid}/offer_variants"
        type: 'post'
        dataType: 'json'
        data: form_data
        success: @handleAddSuccess
        error: @handleAddError
        beforeSend: @showLoadingIndicator
        complete: @hideLoadingIndicator

    showLoadingIndicator: =>
      @$addVariantBtnText.css('visibility', 'hidden')
      @$loadingIndicator.css('visibility', 'visible')

    hideLoadingIndicator: =>
      @$addVariantBtnText.css('visibility', 'visible')
      @$loadingIndicator.css('visibility', 'hidden')

    deleteVariant: (offer_uuid, variantId, $deleteBtn) ->
      $.ajax
        url: "/merchant/offers/#{offer_uuid}/offer_variants/#{variantId}"
        type: 'delete'
        dataType: 'html'
        data: { '_method' : 'delete' }
        success: (response) =>
          $deleteBtn.closest(@existingVariantsForm).remove()

    updateVariant: (offer_uuid, variantId, $updateBtn, $variantToUpdate) ->
      $.ajax
        url: "/merchant/offers/#{offer_uuid}/offer_variants/#{variantId}"
        type: 'put'
        dataType: 'json'
        data: $variantToUpdate.find('input').serialize()
        success: (response) =>
          $variantToUpdate.html(response.variant_partial)

    handleAddSuccess: (response) =>
      @newVariant = response.variant_partial
      $(@newVariant).appendTo(@existingVariants)
      $(@variantErrorContainer).html('')

      $("#{@newVariantsForm} fieldset input").each (index, element) ->
        $input = $(element)
        $input.val('')

      @visuallyRefreshExistingVariantProductDetails()

    visuallyRefreshExistingVariantProductDetails: ->
      @$offerClassification.trigger("change")

    handleAddError: (response) =>
      errors = JSON.parse(response.responseText).errors
      for error in errors
        unless $(@variantErrorContainer).text(error)
          $(@variantErrorContainer).append("<div>#{error}</div>")

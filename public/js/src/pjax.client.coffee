if $.support.pjax
  # $(document).on "click", "a[data-pjax]", (event) ->
  #   container = "div[data-pjax-container]"
  #   console.log "im being fired"
  #   console.log container
  #   $.pjax.click event, container: container
  $(document).pjax('[data-pjax]', '[data-pjax-container]')
jsonClass = () ->

  sockjs_url = "/s/polls"
  sockjs = new SockJS sockjs_url

  sockjs.onopen = ->
    console.log "connected with #{sockjs.protocol}"

  sockjs.onmessage = (e) ->
    console.log e.data

  sockjs.onclose = ->
    console.log "closed #{sockjs.protocol}"

  @bindClick = () ->
    $("#_doPollCampaigns").on "click", () ->
      sockjs.send JSON.stringify $('form[data-pjax]').html()

# sock = new jsonClass()
# sock()

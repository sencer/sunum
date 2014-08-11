$ ->
  theme = (i) ->
    console.log i
    n =$('section:last-child').index()
    if i is n
      $(".left").hide()
      $(".right").hide()
      $(".header_line").hide()
      $("progress").hide()
    else if i is 0
      $(".left").hide()
      $(".right").show()
      $(".header_line").hide()
      $(".circle").css "background-color", "#404040"
      $("progress").hide()
    else
      $(".left").show()
      $(".right").show()
      $(".header_line").show()
      $(".circle").css "background-color", "#c00000"
      $("progress").show()
      $("progress").attr "value", 100.0 * curr / (last - 1)
    return

  Reveal.addEventListener 'ready', (e) ->
    theme e.indexh

  Reveal.addEventListener 'slidechanged', (e)->
    theme e.indexh

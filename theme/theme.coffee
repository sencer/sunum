$ ->
  theme = (i) ->
    n = $('section:last-child').index()
    if i is 0
      $(".left").hide()
      $(".right").show()
      $(".header_line").hide()
      $(".circle").css "background-color", "#404040"
      $("progress").hide()
    else if i is n
      $(".left").hide()
      $(".right").hide()
      $(".header_line").hide()
      $("progress").hide()
    else
      $(".left").show()
      $(".right").show()
      sld = $ Reveal.getCurrentSlide()
      sld.append('<div class="header_line"></div>') unless sld.children('.header_line').length
      $(".header_line").show()
      $(".circle").css "background-color", "#c00000"
      $("progress").show()
      $("progress").attr "value", 100.0 * i / (n - 1)
    return

  Reveal.addEventListener 'ready', (e) ->
    theme e.indexh

  Reveal.addEventListener 'slidechanged', (e)->
    theme e.indexh

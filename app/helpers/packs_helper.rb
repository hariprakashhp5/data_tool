module PacksHelper


def options_for_connection
  [
    ['Prepaid',true],
    ['Postpaid', false]
    
  ]

end


def options_for_pack
  [
    ['Mobile',1],
    ['Datacard', 0],
    ['DTH', -1]
  ]

end

end

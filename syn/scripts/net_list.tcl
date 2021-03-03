set objList { constProp constProp/cp equalOppProp equalOppProp/eop unconnProp unconnProp/up invPush invPush/invP }
foreach obj ${objList} {
   set netList [ get_nets ${obj}/* ]
   puts ${obj}
   foreach_in_collection net ${netList} {
      set netName [ get_attribute ${net} full_name ]
      puts "- ${netName}"
   }
}

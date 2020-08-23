Script "stack_OOPEngine_card_id_1002"

/*
# Name: card id 1002 of stack "OOPEngine"
# ID: card id 1002 of stack "OOPEngine"
*/


on openStack
   local tPath, tFiles
   local tFolder
   local tNewObjectID
   local tScript
   
   put the defaultFolder into tFolder
   start using this stack
   put revEnvironmentUserPluginsPath() into tPath
   put "/Classes" after tPath
   if there is a folder tPath then
      set the defaultFolder to tPath
      put the files into tFiles
      push card
      go card "Classes"
      repeat for each line tFile in tFiles
         put newClass(tFile) into tNewObjectID
         put url ("file:" & tPath & "/" & tFile) into tScript
         set the script of control id tNewObjectID to tScript
      end repeat
      pop card
      set the defaultFolder to tFolder
   end if
end openStack

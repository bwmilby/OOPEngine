Script "stack_OOPEngine_"

/*
# Name: stack "OOPEngine"
# ID: stack "OOPEngine"
*/


###############################
# OOP Engine

# original by Håkan Liljegren 2012
# modified by Mark Wieder 2020

# classes are buttons, objects are groups
# dispatch has a tristate return value: handled, passed, unhandled
# added newClass and deleteClass operators
# added reference count for class deletion
# added class constructors and destructors
###############################

constant kVersion = 1.02
constant kClassStorage = "Classes"
constant kAllowCascadingDeletes = false

function OOPversion
   return "OOP Engine version" && kVersion
end OOPversion

function superClass
   local tSuperClass
   
   if the behavior of the target is not empty then
      put the behavior of the target into tSuperClass
   end if
   return tSuperClass
end superClass

function newClass pClassName, pSuperClass
   if exists(button pClassName of card kClassStorage) then
      throw "class" && pClassName && "already exists"
   else
      create button pClassName of card kClassStorage
      if pSuperClass is not empty then
         set the behavior of button pClassName to the long id of button pSuperClass of card kClassStorage
      end if
      return the id of button pClassName of card kClassStorage
   end if
end newClass

command deleteClass pClassName
   local tSuperClass
   
   if exists(button pClassName of card kClassStorage) then
      put the behavior of button pClassName into tSuperClass
      # not sure if deleting the superclass is a good idea either
      if kAllowCascadingDeletes then
         if tSuperClass is not empty then
            # if no object is using the superclass then recursively delete the superclass
            deleteClass tSuperClass
         end if
      end if
      # finally delete this class
      dispatch function "decrementReferenceCount" to button pClassName of card kClassStorage
      if the result is 0 then
         delete button pClassName of card kClassStorage
      else
         throw "Class" && pClassName && "is still in use, so can't be deleted"
      end if
   end if
end deleteClass

function decrementReferenceCount
   local tReferenceCount
   
   put the referenceCount of the target into tReferenceCount
   if tReferenceCount > 0 then
      subtract 1 from tReferenceCount
      set the referenceCount of the target to tReferenceCount
   end if
   return tReferenceCount
end decrementReferenceCount

command incrementReferenceCount
   local tReferenceCount
   
   put the referenceCount of the target into tReferenceCount
   if tReferenceCount is empty then
      put 1 into tReferenceCount
   else
      add 1 to tReferenceCount
   end if
   set the referenceCount of the target to tReferenceCount
end incrementReferenceCount

function newObject pClass, pName, pType
   local tNewObject
   
   if exists(button pClass of card "Classes") then
      # this switch statment exists because we can't say create pType
      switch pType
         case "stack"
            put newStack(pName) into tNewObject
            break
         case "card"
            put newCard(pName) into tNewObject
            break
         case "background"
            set the backgroundBehavior of the templategroup to true
         case "group"
            put newGroup(pName) into tNewObject
            reset the templategroup
            break
         default
         case "button"
            put newButton(pName) into tNewObject
            break
         case "field"
            put newField(pName) into tNewObject
            break
         case "image"
            put newImage(pName) into tNewObject
            break
         case "scrollbar"
            put newScrollbar(pName) into tNewObject
            break
         case "graphic"
            put newGraphic(pName) into tNewObject
            break
         case "player"
            put newPlayer(pName) into tNewObject
            break
      end switch
      set the behavior of tNewObject to the long id of button pClass of card kClassStorage
      
      # call the class constructors in order
      invokeConstructorsOf tNewObject
      return tNewObject
   else
      throw "Class " & pClass & ": no such class"
   end if
end newObject

private command invokeConstructorsOf pObject
   # get the behavior chain for the constructors
   local tClass, tClassList
   put the behavior of pObject into tClass
   
   repeat while tClass is not empty
      put tClass & cr before tClassList
      put the behavior of tClass into tClass
   end repeat
   delete the last char of tClassList
   
   # call the class constructors in order
   repeat for each line tClass in tClassList
      dispatch "constructor" to tClass
   end repeat
end invokeConstructorsOf

# these all exist because we can't say create <expression>

private function newStack pName
   create stack pName
   return the long id of it
end newStack

private function newCard pName
   create card pName
   return the long id of it
end newCard

private function newGroup pName
   create group pName
   return the long id of it
end newGroup

private function newButton pName
   create button pName
   return the long id of it
end newButton

private function newField pName
   create field pName
   return the long id of it
end newField

private function newImage pName
   create image pName
   return the long id of it
end newImage

private function newScrollbar pName
   create scrollbar pName
   return the long id of it
end newScrollbar

private function newGraphic pName
   create graphic pName
   return the long id of it
end newGraphic

private function newPlayer pName
   create player pName
   return the long id of it
end newPlayer

# example class constructor
command constructor
   # pass up the behavior chain first
   if the behavior of me is not empty then
      dispatch "constructor" to the behavior of me
   end if
   # then do the most local constructor tasks
   if the id of the target is the id of this me then
      # put the short name of me && param(0) && the id of the target & cr after msg
   end if
end constructor

# MDW 2020.08.04: deleting the owner object doesn't seem right
on deleteObject pObject
   if exists(pObject) then
      # call the class destructor if it exists
      dispatch "destructor" to pObject
      delete pObject
   else
      # Maybe we got just an object name?
      if exists(button pObject) then
         deleteObject(the long id of group pObject)
      else
         throw "Object " & pObject & ": no such object"
      end if
   end if
end deleteObject

# example class destructor
command destructor
   # do the local destructor tasks first
   if the id of the target is the id of this me then
      # put the short name of me && param(0) && the id of the target & cr after msg
   end if
   # then pass up the message chain
   if the behavior of me is not empty then
      dispatch "destructor" to the behavior of me
   end if
end destructor

function messageObject pObject, pMethod
   local tParams
   local tCommand
   
   put empty into tParams
   repeat with i = 3 to the paramCount
      put param(i) & comma & space after tParams
   end repeat
   delete last char of tParams
   
   dispatch function pMethod to pObject with tParams
   if it is not "unhandled" then
      return the result
   else
      # Try command instead of function
      dispatch pMethod to pObject with tParams
      if it is not "unhandled" then
         return the result
      else
         throw "Object error: No method " & pMethod & " in class " & className(pObject)
      end if
   end if
end messageObject

--> introspection

function isObject? pObject
   if exists(pObject) and exists(the behavior of pObject) then
      if exists( button (the short name of the behavior of pObject) of card kClassStorage) then
         return true
      end if
   end if
   return false
end isObject?

function ClassName pObject
   if isObject?(pObject) then
      return the short name of the behavior of pObject
   else
      return empty
   end if
end ClassName

function isObjectOfClass? pObject, pClass
   if ClassName(pObject) is pClass then
      return true
   else
      return false
   end if
end isObjectOfClass?

# set the class of an existing control
on setClassForControl pControlID, pClassLongID
   if exists(pControlID) then
      if exists(pClassLongID) then
         set the behavior of pControlID to pClassLongID
      end if
   end if      
end setClassForControl

# OOP-engine
############################################

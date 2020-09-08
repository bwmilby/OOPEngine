Script "stack_OOPEngine_"

/*
# Name: stack "OOPEngine"
# ID: stack "OOPEngine"
*/


###############################
# OOP Engine

# original by Håkan Liljegren 2012
# modified by Mark Wieder 2020
# modified by Brian Milby 2020

# classes are buttons or stacks, objects are groups by default
# dispatch has a tristate return value: handled, passed, unhandled
# added class constructors and destructors
# v1.2.1 passes all constructor parameters to behaviors
###############################

constant kVersion = 1.2.1
constant kClassStorage = "Classes"
local sClassA -- index of class names to button long id
local sClassListA -- index of class hierarchy for each class

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

function classIDFromName pClassName
   local tClassID
   
   put sClassA[pClassName] into tClassID
   if tClassID is empty then
      throw "Class" && pClassName && "not found"
   end if
   return tClassID
end classIDFromName

# Add classes from specified card to class index
command registerClasses pCard, pUpdateClasses?
   repeat with tID=1 to the number of buttons of pCard
      registerClass the long id of button tID of pCard, pUpdateClasses?
   end repeat
end registerClasses

# Register a specific class, either a button or a stack
command registerClass pClassObject, pUpdateClass?
   local tName, tLongID
   if not exists(pClassObject) then
      throw "class object" && pClassObject && "not found"
   end if
   put the short name of pClassObject into tName
   put the long id of pClassObject into tLongID
   if sClassA[tName] is not empty and pUpdateClass? is not true \
         and sClassA[tName] is not tLongID then
      throw "class" && tName && "already exists in index"
   end if
   put tLongID into sClassA[tName]
   delete variable sClassListA[tName]
end registerClass

function newObject pClass, pName, pType
   local tNewObject, tClassList, tSuperClass, tParams
   --
   # this switch statment exists because we can't say create pType
   if sClassA[pClass] is not empty then
      switch pType
         case "stack"
            create stack pName
            break
         case "card"
            create card pName
            break
         case "button"
            create button pName
            break
         case "field"
            create field pName
            break
         case "image"
            create image pName
            break
         case "scrollbar"
            create scrollbar pName
            break
         case "graphic"
            create graphic pName
            break
         case "player"
            create player pName
            break
         case "background"
            set the backgroundBehavior of the templategroup to true
            # fall through
         case "group"
         default
            set the visible of the templategroup to false # Make it "truly" invisible
            set the margins of the templategroup to 0 # Make it "truly" invisible
            create group pName
            reset the templategroup
            break
      end switch
      put the long id of it into tNewObject
      set the behavior of tNewObject to sClassA[pClass]
      # build parameter list for constructor
      put empty into tParams
      repeat with i = 4 to the paramCount
         put param(i) & comma & space after tParams
      end repeat
      delete last char of tParams
      # call the class constructors in order
      put _getClassList(pClass) into tClassList
      repeat for each line tClass in tClassList
         dispatch tClass to tNewObject with tParams
      end repeat
      return tNewObject
   else
      throw "Class " & pClass & ": no such class"
   end if
end newObject

private function _getClassList pClass
   local tClassList, tSuperClass
   put sClassListA[pClass] into tClassList
   if tClassList is empty then
      put pClass into tClassList
      put the behavior of sClassA[pClass] into tSuperClass
      repeat while tSuperClass is not empty
         put the short name of tSuperClass & lf before tClassList
         put the behavior of tSuperClass into tSuperClass
      end repeat
      put tClassList into sClassListA[pClass]
   end if
   return tClassList
end _getClassList

# Example class constructor
# The handler names should be the same as the class name
# for instance, for class LinkedList, the script could contain
# command LinkedList
/*
command constructor
   # put the short name of this me && param(0) && the id of the target & cr after msg
end constructor
*/

# Example class destructor
# Unlike the constructor, the destructor is simply named "destructor"
# Note that proper destructor etiquette
# involves passing the destructor to superclasses
/*
command destructor
   local tSuperClass
   put the behavior of this me into tSuperClass
   --
   # do the local destructor tasks first
   # put the short name of this me && param(0) && the id of the target & cr after msg
   --
   # then pass up the message chain
   if tSuperClass is not empty then
      pass destructor
   end if
end destructor
*/

on deleteObject pObject
   if isObject?(pObject) then
      # call the class destructor if it exists
      dispatch "destructor" to pObject
      delete pObject
   else
      # Maybe we got just an object name?
      if exists(control pObject) then
         deleteObject(the long id of control pObject)
      else
         throw "Object " & pObject & ": no such object"
      end if
   end if
end deleteObject

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
         throw "Object error: No method " & pMethod & " in class " & classNameOf(pObject)
      end if
   end if
end messageObject

--> introspection

function isObject? pObject
   if exists(pObject) and exists(the behavior of pObject) then
      if sClassA[the short name of the behavior of pObject] is not empty then
         return true
      end if
   end if
   return false
end isObject?

function ClassNameOf pObject
   if isObject?(pObject) then
      return the short name of the behavior of pObject
   else
      return empty
   end if
end ClassNameOf

function isObjectOfClass? pObject, pClass
   return ClassNameOf(pObject) is pClass
end isObjectOfClass?

# OOP-engine
############################################

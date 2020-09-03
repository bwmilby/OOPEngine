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
# added newClass and deleteClass operators
# added reference count for class deletion
# added class constructors and destructors
###############################

constant kVersion = 1.1.0
constant kClassStorage = "Classes"
constant kAllowCascadingDeletes = false
local sClassA -- index of class names to button long id
local sClassListA -- index of class hierarchy for each class

function OOPversion
   return "OOP Engine version" && kVersion
end OOPversion

# Add classes from specified card to class index
command registerClasses pCard, pUpdateClasses
   local tName, tLongID
   repeat with tID=1 to the number of buttons of pCard
      registerClass the long id of button tID of pCard, pUpdateClasses
   end repeat
end registerClasses

# Register a specific class, either a button or a stack
command registerClass pClassObject, pUpdateClass
   local tName, tLongID
   if not exists(pClassObject) then
      throw "class object" && pClassObject && "not found"
   end if
   put the short name of pClassObject into tName
   put the long id of pClassObject into tLongID
   if sClassA[tName] is not empty and pUpdateClass is not true \
         and sClassA[tName] is not tLongID then
      throw "class" && tName && "already exists in index"
   end if
   put tLongID into sClassA[tName]
   delete variable sClassListA[tName]
end registerClass

function newClass pClassName, pSuperClass
   if exists(button pClassName of card kClassStorage) then
      throw "class" && pClassName && "already exists"
   else
      create button pClassName of card kClassStorage
      if pSuperClass is not empty then
         set the behavior of button pClassName to the long id of button pSuperClass of card kClassStorage
      end if
      put the long id of button pClassName of card kClassStorage into sClassA[pClassName]
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
         delete variable sClassA[pClassName]
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

function newObject pClass, pName, pType, pParams
   local tNewObject, tClassList, tSuperClass
   
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
      # call the class constructors in order
      put _getClassList(pClass) into tClassList
      repeat for each line tClass in tClassList
         dispatch tClass to tNewObject with pParams
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

# example class constructor
# the handler names should be the same as the class name
command constructor
   # put the short name of this me && param(0) && the id of the target & cr after msg
end constructor

# MDW 2020.08.04: deleting the owner object doesn't seem right
on deleteObject pObject
   if exists(pObject) then
      # call the class destructor if it exists
      dispatch "destructor" to pObject
      delete pObject
   else
      # Maybe we got just an object name?
      if exists(group pObject) then
         deleteObject(the long id of group pObject)
      else
         throw "Object " & pObject & ": no such object"
      end if
   end if
end deleteObject

# example class destructor
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
      if sClassA[the short name of the behavior of pObject] is not empty then
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

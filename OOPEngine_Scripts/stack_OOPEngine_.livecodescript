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
# there is now a Classes card for classes expected to be in general use
# local classes are checked first: if no match then the global classes are checked
# v1.05 fixed newObject to create the class name rather than the object name
# also changed the invokeConstructorsOf call to dispatch to the object instead of the behavior
###############################

constant kVersion = 1.1.0
constant kClassStorage = "Classes"
constant kAllowCascadingDeletes = false
local sClassA -- index of class names to button long id

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

private function classExists? pClassName
   local tClassID
   
   return classIDFromName(pClassName) is not empty
   --   # check for a local class first.
   --   # this allows for overriding/overloading the more global classes if desired.
   --   if exists(control pClassName of card kClassStorage of the defaultStack) then
   --      put the long id of control pClassName of card kClassStorage of the defaultStack into tClassID
   --      # if there's nothing locally then check the global classes
   --   else if exists(control pClassName of card kClassStorage of me) then
   --      put the long id of control pClassName of card kClassStorage of me into tClassID
   --   else
   --      put empty into tClassID
   --   end if
   --   return tClassID
end classExists?

function classIDFromName pClassName
   local tClassID
   
   put sClassA[pClassName] into tClassID
   --put classExists(pClassName) into tClassID
   if tClassID is empty then
      throw "Class" && pClassName && "not found"
   end if
   return tClassID
end classIDFromName

# Add classes from specified card to class index
command registerClasses pCard, pUpdateClasses
   local tName, tLongID
   repeat with tID=1 to the number of buttons of pCard
      registerClass the long id of button tID of pCard, false
      --      put the short name of button tID of pCard into tName
      --      put the long id of button tID of pCard into tLongID
      --      if sClassA[tName] is not empty and pUpdateClasses is not true \
      --            and sClassA[tName] is not tLongID then
      --         throw "class" && tName && "already exists in index"
      --      end if
      --      put tLongID into sClassA[tName]
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
end registerClass

function isAClass? pName
   return classIDFromName(pName) is not empty
end isAClass?

--function classID pName
--   return sClassA[pName]
--end classID

function newClass pClassName, pSuperClass
   local tClassID
   
   if classExists?(pClassName) then
      throw "class" && pClassName && "already exists"
   else
      go card kClassStorage
      create button pClassName
      if pSuperClass is not empty then
         set the behavior of control pClassName to the long id of control pSuperClass of card kClassStorage of me
      end if
      put the long id of button pClassName of card kClassStorage into sClassA[pClassName]
      return the id of button pClassName of card kClassStorage of me
   end if
end newClass

command deleteClass pClassName
   local tSuperClass
   local tClassID
   
   put classIDFromName(pClassName) into tClassID
   if tClassID is not empty then
      put the behavior of control pClassName into tSuperClass
      # not sure if deleting the superclass is a good idea either
      if kAllowCascadingDeletes then
         if tSuperClass is not empty then
            # if no object is using the superclass then recursively delete the superclass
            deleteClass tSuperClass
         end if
      end if
      # finally delete this class
      # if --referenceCount == 0 then
      dispatch function "decrementReferenceCount" to tClassID
      if the result is 0 then
         --delete tClassID
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

function newObject pClass, pName, pType
   local tNewObject, tClassList, tSuperClass
   local tClassID
   
   put classIDFromName(pClass) into tClassID
   if sClassA[pClass] is not empty then
      --   if tClassID is not empty then
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
         default
         case "group"
            put newGroup(pName) into tNewObject
            reset the templategroup
            break
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
      --      set the behavior of tNewObject to tClassID
      set the behavior of tNewObject to sClassA[pClass]
      
      # call the class constructors in order
      invokeConstructorsOf tNewObject, param(4)
      return tNewObject
      
      --if sClassA[pClass] is not empty then
      --      set the visible of the templategroup to false # Make it "truly" invisible
      --      set the margins of the templategroup to 0 # Make it "truly" invisible
      --      if pName is not empty then
      --         create group pName
      --      end if
      --      put the id of the last group into tNewObject
      --      set the behavior of control id tNewObject to sClassA[pClass]
      --      reset the templategroup
      # call the class constructors in order
      
      --      put pClass into tClassList
      --      put the behavior of sClassA[pClass] into tSuperClass
      --     repeat while tSuperClass is not empty
      --         put the short name of tSuperClass & lf before tClassList
      --         put the behavior of tSuperClass into tSuperClass
      --      end repeat
      --      repeat for each line tClass in tClassList
      --         dispatch tClass to control id tNewObject
      --      end repeat
      --      return the long id of control id tNewObject
      
   else
      throw "Class " & pClass & ": no such class"
   end if
end newObject

# Brian's list constructor
private command invokeConstructorsOf pObject, pParams
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
      dispatch the short name of tClass to pObject with pParams
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
      set the visible of the templategroup to false # Make it "truly" invisible
      set the margins of the templategroup to 0 # Make it "truly" invisible
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
      if exists(control pObject) then
         deleteObject(the long id of group pObject)
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
         throw "Object error: No method " & pMethod & " in class " & className(pObject)
      end if
   end if
end messageObject

--> introspection

function isObject? pObject
   local tClassID
   
   if exists(pObject) and exists(the behavior of pObject) then
#      put classIDFromName(the short name of the behavior of pObject) into tClassID
#      if tClassID is not empty then
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
--on setClassForControl pControlID, pClassLongID
--   if exists(pControlID) then
--      if exists(pClassLongID) then
--         set the behavior of pControlID to pClassLongID
--      end if
--   end if      
--end setClassForControl

# OOP-engine
############################################

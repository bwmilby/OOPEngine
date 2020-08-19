Script "stack_Particles_card_id_1002"

/*
# Name: card id 1002 of stack "Particles"
# ID: card id 1002 of stack "Particles"
*/


local _emittor
local _simulationRunning

on preOpenCard
   local tImgList
   repeat with i = 1 to the number of images of card "images"
      put the short name of image i of card "images" & return after tImgList
   end repeat
   delete last char of tImgList
   set the text of button "imageSource" to tImgList
end preOpenCard

on startSimulation
   local tImageName
   local tParticleType
   local tPoints
   set the acceleratedRendering of this stack to true # Oh boy, we need this!
   put the long id of button "Emittor" of card "Classes" into _emittor
   dispatch "fadeParticlesOverLife" to _emittor with the hilite of button "Fade Particles over Life"
   put the hilitedText of button "imageSource" into tImageName
   put the hilitedText of button "particleType" into tParticleType
   if tParticleType is "normal" then put empty into tParticleType
   put tParticleType & "Particle" into tParticleType
   dispatch "startEmittor" to _emittor with the width of this stack/2, the height of this stack/2, \
         the minValue of group "maxMinX",the maxValue of group "MaxMinX", \
         the minValue of group "maxMinY",the maxValue of group "MaxMinY", \
         the thumbPosition of scrollbar "birthRate", \
         the thumbPosition of scrollbar "LifeSpan", tParticleType, the long id of image tImageName of card "images"
   if the visible of group "line" then
      put the points of graphic "line" into tPoints
      replace return with comma in tpoints
      setEmittorType "line", tpoints
   end if
   put true into _simulationRunning
   setUpTemplateButton
   runSimulation
end startSimulation

on stopSimulation
   put false into _simulationRunning
   if exists(_emittor) then
      send "StopEmittor" to _emittor
   end if
   set the acceleratedRendering of this stack to false
end stopSimulation

on runSimulation
   lock screen
   if _simulationRunning then
      if the hilite of button "Follow mouse X" then
         set the emittorType of _emittor to empty
         set the emitX of _emittor to item 1 of the mouseLoc
      end if
      if the hilite of button "Follow mouse Y" then
         set the emittorType of _emittor to empty
         set the emitY of _emittor to max(item 2 of the mouseLoc, 150)
      end if      
      send "animate" to _emittor
      send "runSimulation" to me in 0 milliseconds
   else
      if the particleCount of _emittor > 0 then
         send "animate" to _emittor
         send "runSimulation" to me in 0 milliseconds
      else
         set the acceleratedRendering of this stack to false
      end if
   end if
   set the layer of group "Controls" to top
   unlock screen
end runSimulation

on setEmittorMinX pValue
   if exists(_emittor) then
      set the xSpeedMin of _emittor to pValue
   end if
end setEmittorMinX

on setEmittorMaxX pValue
   if exists(_emittor) then
      set the xSpeedMax of _emittor to pValue
   end if
end setEmittorMaxX

on setEmittorMinY pValue
   if exists(_emittor) then
      set the ySpeedMin of _emittor to pValue
   end if
end setEmittorMinY

on setEmittorMaxY pValue
   if exists(_emittor) then
      set the ySpeedMax of _emittor to pValue
   end if
end setEmittorMaxY

on setEmittorLifeSpan pValue
   if exists(_emittor) then
      set the lifeSpan of _emittor to pValue
   end if
end setEmittorLifeSpan

on setEmittorBirthRate pValue
   if exists(_emittor) then
      set the birthRate of _emittor to pValue
   end if
end setEmittorBirthRate

on setFadePartcles pValue
   if exists(_emittor) then
      set the fadeParticlesOverLife of _emittor to pValue
   end if
end setFadePartcles

on setEmittorType pType, pData
   if exists(_emittor) then
      set the emittorType of _emittor to "line" # Line is the only implemented type so far (except for empty type which is a point)
      set the emittorData of _emittor to pData
   end if
end setEmittorType

on setUpTemplateButton
   set the showName of the templateButton to false
   set the showBorder of the templateButton to false
   set the opaque of the templateButton to false
   set the threed of the templateButton to false
   set the autohilite of the templateButton to false
   set the showFocusBorder of the templateButton to false
   set the layerMode of the templateButton to "dynamic"
   set the hiliteBorder of the templateButton to false
   set the borderWidth of the templatebutton to 0
   set the shadow of the templateButton to false
   set the shadowOffset of the templateButton to 0
end setUpTemplateButton

on escapeKey
   stopSimulation
end escapeKey

on setParticleSource pSource
   local tSource
   
   put the long id of image pSource of card "Images" into tSource
   if _emittor is not empty then
      set the particleSource of _emittor to tSource
   end if
end setParticleSource

on setParticleType pClass
   if pClass is "normal" then put empty into pClass
   if _emittor is not empty then
      set the particleType of _emittor to (pClass & "Particle")
   end if
end setParticleType

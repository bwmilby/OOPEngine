Script "stack_Emittor_"

/*
# Name: stack "Emittor" of stack "Particles"
# ID: stack "Emittor" of stack "Particles"
*/


local _nextParticle
local _birthRate
local _emitX, _emitY
local _xSpeedMin, _xSpeedMax
local _ySpeedMin, _ySpeedMax
local _particles
local _lifeSpan
local _particleClass
local _particleCounter
local _isRunning
local _fadeParticlesOverLife
local _Type
local _TypeData
local _kx,_ky
local _particleSource

on startEmittor pX, pY, pXMin, pXMax, pYMin, pYMax, pBirthRate, pLifeSpan, pParticleClass, pParticleSource
   put pX into _emitX
   put py into _emitY
   put pXmin into _xSpeedMin
   put pXmax into _xSpeedMax
   put pYmin into _ySpeedMin
   put pYmax into _ySpeedMax
   put 1000 div pBirthRate into _birthRate
   put pParticleClass into _particleClass
   put 0 into _particleCounter
   put true into _isRunning
   put empty into _particles
   put pLifeSpan into _lifeSpan
   put pParticleSource into _particleSource
end startEmittor

setProp emitX pValue
   put pValue into _emitX
end emitX

setProp emitY pValue
   put pValue into _emitY
end emitY

setProp xSpeedMin pValue
   put pValue into _xSpeedMin
end xSpeedMin

setProp xSpeedMax pValue
   put pValue into _xSpeedMax
end xSpeedMax

setProp ySpeedMin pValue
   put pValue into _ySpeedMin
end ySpeedMin

setProp ySpeedMax pValue
   put pValue into _ySpeedMax
end ySpeedMax

setProp birthRate pValue
   put 1000 div pValue into _birthRate
end birthRate

setProp lifeSpan pValue
   put pValue into _lifeSpan
end lifeSpan

on stopEmittor
   put false into _isRunning
end stopEmittor

setProp emittorType pType
   put pType into _type
end emittorType

setProp emittorData pTypeData
   local dx, dy
   
   put pTypeData into _typeData
   if _type is "line" then
      put item 3 of pTypeData - item 1 of pTypeData into dx
      put item 4 of pTypeData - item 2 of pTypeData into dy
      put pi/2-atan2(dy,dx) into item 5 of _TypeData
      put sqrt(dx*dx+dy*dy) into item 6 of _TypeData
   end if
end emittorData

on animate
   local dx, dy, tx, ty
   local tDistance
   local tNewObject
   
   if _isRunning and the milliseconds > _nextParticle then
      # We should create a new particle
      add 1 to _particleCounter
      put newObject(_particleClass, _particleClass, "button") into tNewObject
      put tNewObject into _particles[_particleCounter]
      if _xSpeedMax > _xSpeedMin then
         put random(_xSpeedMax - _xSpeedMin) + _xSpeedMin into dx
      else
         put 0 into dx
      end if
      if _ySpeedMax > _ySpeedMin then
         put random(_ySpeedMax - _ySpeedMin) + _ySpeedMin into dy
      else
         put 0 into dy
      end if
      switch _Type
         case empty
            put _emitX into tx
            put _emitY into ty
            break
         case "line"
            put random(item 6 of _typeData) into tDistance
            put item 1 of _typeData +  tDistance*sin(item 5 of _typeData) into tx
            put item 2 of _typeData +  tDistance*cos(item 5 of _typeData) into ty
      end switch
      dispatch "birth" to tNewObject with  tx, tY, dx, dy, _lifeSpan, _particleSource
      
      set the fadeOverLife of tNewObject to _fadeParticlesOverLife
      put the milliseconds + _birthRate into _nextParticle
   end if
   
   local tKeys
   put the keys of _particles into tKeys
   sort tKeys numeric descending
   repeat for each line aParticle in tKeys
      dispatch function "isAlive?" to _particles[aParticle]
      if the result is true then
         dispatch "animate" to _particles[aParticle]
      else
         deleteObject(_particles[aParticle])
         delete variable _particles[aParticle]
      end if
   end repeat
end animate

getProp particleCount
   return the number of elements in _particles
end particleCount

setProp fadeParticlesOverLife pValue
    put pValue into _fadeParticlesOverLife
end fadeParticlesOverLife

getProp fadeParticlesOverLife
  return _fadeParticlesOverLife
end fadeParticlesOverLife

setProp particleSource pParticleSource
   if exists(pParticleSource) then
      put pParticleSource into _particleSource
   end if
end particleSource

getProp particleSource
   return _particleSource
end particleSource

setProp particleType pParticleClass
   put pParticleClass into _particleClass
end particleType

getProp particleType
   return _particleClass
end particleType


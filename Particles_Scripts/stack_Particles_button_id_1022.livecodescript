Script "stack_Particles_button_id_1022"

/*
# Name: button "particle" of card "Classes" of stack "Particles"
# ID: button id 1022 of card id 1004 of stack "Particles"
*/


local _particleID
local _deathMoment
local _birthTime
local _dx, _dy
local _fadeOverLife
local _lifeSpan


##############################################################################
#
# Base class for particles
#

# constructor
command particle
   # put the short name of this me && param(0) && the id of the target & cr after msg
end particle

command particle
   --put the id of the target && the id of this me && param(0) & cr after msg
end particle

command destructor
   --put param(0) & cr after msg
end destructor

on birth pX, pY, pdX, pdY, pLifeSpan, pParticleSource
   --put the id of the target && the id of this me && param(0) & cr after msg
   put the long id of the target into _particleID
   set the icon of _particleID to the id of pParticleSource
   set the loc of _particleID to (px,pY)
   set the width of _particleID to the width of pParticleSource
   set the height of _particleID to the height of pParticleSource
   put pdX into _dx
   put pdY into _dy
   put pLifeSpan into _lifeSpan
   put the milliseconds + pLifeSpan into _deathMoment
   put the milliseconds into _birthTime
   return _particleID
end birth

on animate
   --put the id of the target && the id of this me && param(0) & cr after msg
   local tLoc
   if the milliseconds < _deathMoment then
      put the loc of _particleID into tLoc
      add _dx to item 1 of tLoc
      add _dy to item 2 of tLoc
      set the loc of _particleID to tLoc
      if _fadeOverLife then
         if _lifeSpan > 0 then
            set the blendLevel of the target to round(100*(the milliseconds - _birthTime) / _lifeSpan)
         end if
      end if
   end if
end animate

function isAlive?
   return _deathMoment > the milliseconds
end isAlive?

--command die
--   put param(0) & cr after msg
--   if _particleID is not empty then
--      delete _particleID
--   end if
--end die

# accessors to make class variables public

-- dx

setProp dX pdX
   put pdX into _dx
end dX

getProp dx
  return _dx
end dx

command setdxTo pdX
   put pdX into _dx
end setdxTo

function dX
   return _dx
end dX

-- dy

setProp dY pdY
   put pdY into _dy
end dY

getProp dY
  return _dy
end dY

# getters and setters
command setdyTo pdY
   put pdY into _dy
end setdyTo

function dY
   return _dy
end dY

--> fadeOverLife

setProp fadeOverLife pValue
   put pValue into _fadeOverLife
end fadeOverLife

getProp fadeOverLife
   return _fadeOverLife
end fadeOverLife

# getters and setters
function fadeOverLife
   return _fadeOverLife
end fadeOverLife

command setFadeOverLifeTo pValue
   put pValue into _fadeOverLife
end setFadeOverLifeTo

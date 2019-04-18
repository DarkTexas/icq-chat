; ICQ-Chat.com mIRC Nick Color Addon by Desolator and Chris
; ------------------------------------------------------------------------------------
; This Addon is setting the nick colours based on the gender
; choosen in the webchat or via this addon for mIRC Users

on *:PARSELINE:*:*:{
  if ($network == ICQ-Chat) {
    if (($parsetype == in) && ($parseutf == $true)) {
      if ((JOIN isincs $parseline) && ($chr(35) isin $gettok($parseline,3,32))) {
        if ($gettok($gettok($parseline,5,32),2,47) == M) {
          .cnick *!*@ $+ $gettok($gettok($parseline,1,32),2,64) $hget(icqgender,male)
        }
        if ($gettok($gettok($parseline,5,32),2,47) == F) {
          .cnick *!*@ $+ $gettok($gettok($parseline,1,32),2,64) $hget(icqgender,female)
        }
      }
    }
  }
}

ON *:JOIN:#:{
  if ($nick == $me) {
    set -u4 %nowhos on
    .timer 1 1 //.who $chan
  }
}

raw 352:*:{
  if (%nowhos) {
    haltdef
    if ($gettok($9,2,47) == M) { .cnick *!*@ $+ $4  $hget(icqgender,male)  }
    if ($gettok($9,2,47) == F) { .cnick *!*@ $+ $4  $hget(icqgender,female) }
  }
}

raw 315:*:{ if (%nowhos) { haltdef } }

menu channel {
  -
  .ICQ-Chat Gender tool:dialog -mdh genderstuff genderstuff
}


dialog genderstuff {
  title "ICQ-Chat Gender selector / viewer"
  size -1 -1 208 45
  option dbu
  box "Other Users", 8, 3 3 196 38
  text "Color for female Users", 9, 8 15 97 8
  text "Color for male Users", 10, 8 25 97 8
  edit "", 11, 114 14 50 10, disable
  edit "", 12, 114 25 50 10, disable
  button "Change", 13, 167 14 25 10
  button "Change", 14, 167 25 25 10
}

on *:LOAD:{  
  hmake icqgender 10 
  if ($exists(icqgender.hsh)) { 
    .hload icqgender icqgender.hsh
  } 
  .cnick on
  .hadd icqgender male 12
  .hadd icqgender female 13
}

on *:connect:{
  .cnick on
  .hmake icqgender 10 
  if ($exists(icqgender.hsh)) { 
    .hload icqgender icqgender.hsh
  } 
}
on *:disconnect:{
  if ($hget(icqgender)) { 
    .hsave icqgender icqgender.hsh 
    .hfree icqgender
  }
}
on *:UNLOAD:{
  if ($hget(icqgender)) { 
    .hsave icqgender icqgender.hsh 
    .hfree icqgender
  }
}
ON ^*:QUIT: {
  .cnick -r $address($nick,2)
}
on *:dialog:genderstuff:init:0:{  did -a genderstuff 11 $hget(icqgender,male) |   did -a genderstuff 12 $hget(icqgender,female) }
on *:dialog:genderstuff:sclick:13: { hadd icqgender male $$?="ctrl +k and choose your color for MALE Users (but remove the first symbol so the little box icon goes away, e.g.: 12)" |  dialog -x genderstuff genderstuff | dialog -mdoh genderstuff genderstuff }
on *:dialog:genderstuff:sclick:14: { hadd icqgender female $$?="ctrl +k and choose your color for FEMALE Users (but remove the first symbol so the little box icon goes away, e.g.: 13)" |  dialog -x genderstuff genderstuff | dialog -mdoh genderstuff genderstuff }

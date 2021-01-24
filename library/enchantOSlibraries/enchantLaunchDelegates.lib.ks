//enchantLaunchDelegates.lib.ks

function initLaunchDefaults {
  global launchDefaults is lexicon(
  "defApoapsis", "85000",
  "defaultHeading", "Equatorial",
  "defaultGLoad", "3"
  ).
}

function initHeadingOptions {
  global headingOptions is lexicon(
    "Equatorial", 90,
    "Minmus-North", 83.67,
    "Minmus-South", 96.33,
    "Polar-South", 183,
    "Polar-North", 358,
    "Retrograde", 270
  ).
}

function apoapsisUp {
  parameter buttonCalledFrom.
  local currentScalar is buttonCalledFrom:PARENT:WIDGETS[0]:TEXT:TONUMBER(0).
  local incrementedApoapsis is currentScalar.
  if currentScalar <= 75000 {
    set incrementedApoapsis to round(currentScalar) + 500.
  } else if currentScalar >= 84155000 {
    set incrementedApoapsis to 84155000.
    userAlert("Can't increment you out of the kerbin").
    userAlert("sphere of influence. It's too high").
  } else {
    set incrementedApoapsis to round(currentScalar) + 5000.
  }
  set buttonCalledFrom:PARENT:WIDGETS[0]:TEXT to incrementedApoapsis:TOSTRING.
}

function apoapsisDown {
  parameter buttonCalledFrom.
  local currentScalar is buttonCalledFrom:PARENT:WIDGETS[0]:TEXT:TONUMBER(0).
  local decrementedApoapsis is currentScalar.
  if currentScalar <= 71500 {
    set decrementedApoapsis to 71500.
    userAlert("Launch will fail if ascent doesn't pass the karman").
    userAlert("line. 71.5 km is the minimum, sorry!").
  } else if currentScalar > 71500 and currentScalar <= 75000 {
    set decrementedApoapsis to round(currentScalar) - 500.
  } else {
    set decrementedApoapsis to round(currentScalar) - 5000.
  }
  set buttonCalledFrom:PARENT:WIDGETS[0]:TEXT to decrementedApoapsis:TOSTRING.
}

function apoapsisConfirmed {
  parameter fieldCalledFrom.
  parameter chosenApoapsisString.
  local chosenApoapsisScalar is chosenApoapsisString:TONUMBER(0).
  local refreshedApoapsis is chosenApoapsisScalar.
  if chosenApoapsisScalar < 71500 {
    userAlert("That value is too low. Launch only works to above").
    userAlert("the karman line").
    set refreshedApoapsis to 71500.
  } else if chosenApoapsisScalar > 84155000 {
    userAlert("That value is too high. Launch only works to").
    userAlert("altitudes below the Kerbin sphere of influence.").
    set refreshedApoapsis to 84155000.
  } else {
    local moduloOfApoapsis is mod(chosenApoapsisScalar, 500).
    set refreshedApoapsis to round(chosenApoapsisScalar - moduloOfApoapsis).
  }
  set fieldCalledFrom:TEXT to refreshedApoapsis:TOSTRING.
  targetApoapsisSet(fieldCalledFrom:PARENT:WIDGETS[3]).
}

function targetApoapsisSet {
  parameter buttonCalledFrom.
  global targetApoapsis is buttonCalledFrom:PARENT:WIDGETS[0]:TEXT:TONUMBER(0).
}

function headingChosen {
  parameter choice.
}

function targetHeadingSet {
  parameter buttonCalledFrom.
  global targetHeading is headingOptions[buttonCalledFrom:
    PARENT:
    WIDGETS[0]:
    TEXT
  ].
}

function gLimitUp {
  parameter buttonCalledFrom.
  local gLimitScalar is buttonCalledFrom:PARENT:WIDGETS[0]:TEXT:TONUMBER(0).
  if gLimitScalar = 10 {
    userAlert("Good luck making your launch pull more than 10 g!").
  } else {
    local gLimitRefreshed is gLimitScalar + 0.25.
    set buttonCalledFrom:PARENT:WIDGETS[0]:TEXT to gLimitRefreshed:TOSTRING.
  }
}

function gLimitDown {
  parameter buttonCalledFrom.
  local gLimitScalar is buttonCalledFrom:PARENT:WIDGETS[0]:TEXT:TONUMBER(0).
  if gLimitScalar = 1.25 {
    userAlert("Ascending with a lower G Load limit will be too").
    userAlert("difficult. 1.25 is the minimum, sorry!").
  } else {
    local gLimitRefreshed is gLimitScalar - 0.25.
    set buttonCalledFrom:PARENT:WIDGETS[0]:TEXT to gLimitRefreshed:TOSTRING.
  }
}

function gLimitSetClicked {
  parameter buttonCalledFrom.
}

function launchParametersReset {
  parameter buttonCalledFrom.
  local originalTextColor is RGBA(0.8295634, 0.9583512, 0.9925373, 1).
  set buttonCalledFrom:
  PARENT:
  WIDGETS[1]:
  WIDGETS[0]:TEXT to launchDefaults:defApoapsis.
  set buttonCalledFrom:
  PARENT:
  WIDGETS[3]:
  WIDGETS[0]:TEXT to launchDefaults:defaultHeading.
  set buttonCalledFrom:
  PARENT:
  WIDGETS[5]:
  WIDGETS[0]:TEXT to launchDefaults:defaultGLoad.
}

function abortLaunch {
  presentAbortWarningUI().
}

function confirmAndLaunchClicked {
  parameter buttonCalledFrom.
  if ship:STATUS = "PRELAUNCH" or launchAbortedDuringSession {
    switchToPostLiftoff(buttonCalledFrom:PARENT).
    targetApoapsisSet(buttonCalledFrom:PARENT:WIDGETS[1]:WIDGETS[3]).
    targetHeadingSet(buttonCalledFrom:PARENT:WIDGETS[3]:WIDGETS[1]).
    updateStaticReadouts(
      buttonCalledFrom:PARENT:WIDGETS[9],
      buttonCalledFrom:PARENT:WIDGETS[10]
    ).
    set ascentCompleted to false.
    set launchUnderway to true.
  } else {
    local myAlertString is "This automation option is for launching only. It".
    local myAlertString is myAlertString + " will not run again after liftoff".
    local myAlertString is myAlertString + " has occured.".
    userAlert(myAlertString).
  }
}

function updateStaticReadouts {
  parameter firstReadout.
  parameter secondReadout.
  //update the target apoapsis readout to reflect what was chosen prelaunch
  set firstReadout:TEXT to "Target Apoapsis: " + 
  consoleGUI:
  WIDGETS[5]:
  WIDGETS[1]:
  WIDGETS[2]:
  WIDGETS[0]:
  WIDGETS[1]:
  WIDGETS[0]:TEXT.
  local backspacingList is list("1stBackspace","2ndBackspace").
  for backspace in backspacingList {
    if backspace = "1stBackspace" {
      set stringLength to firstReadout:TEXT:LENGTH.
      set firstReadout:TEXT to firstReadout:TEXT:REMOVE(stringLength - 2, 2).
    } else {
      local stringLen is firstReadout:TEXT:LENGTH.
      if firstReadout:TEXT:ENDSWITH("5") {
        set firstReadout:TEXT to firstReadout:TEXT:INSERT(stringLen - 1,".").
      } else {
        set firstReadout:TEXT to firstReadout:TEXT:REMOVE(stringLen -1, 1).
      }
    }
  }
  set firstReadout:TEXT to firstReadout:TEXT + " km".

  //update the launch heading readout to reflect what was chosen prelaunch
  set secondReadout:TEXT to "Launch Heading: " + targetHeading + " deg".
}

function updateDynamicReadouts {
  //update the target pitch to reflect where the ship wants to pitch to at
  //the current altitude.
  set consoleGUI:WIDGETS[5]:WIDGETS[1]:WIDGETS[2]:WIDGETS[0]:WIDGETS[11]:TEXT
  to "Target Pitch: " + getTargetPitch() + " deg".
  set consoleGUI:WIDGETS[5]:WIDGETS[1]:WIDGETS[2]:WIDGETS[0]:WIDGETS[12]:TEXT
  to "Current G-Force: " + getGLoad().
  if ship:STATUS = "PRELAUNCH" {
    set consoleGUI:WIDGETS[5]:WIDGETS[1]:WIDGETS[2]:WIDGETS[0]:WIDGETS[13]:TEXT
    to "Standing by to Launch...".
  } else if defined stageTime and time:SECONDS <= stageTime + 5 {
    return.
  } else if ship:STATUS = "FLYING" and time:SECONDS >= liftoffTime + 3 {
    set consoleGUI:WIDGETS[5]:WIDGETS[1]:WIDGETS[2]:WIDGETS[0]:WIDGETS[13]:TEXT
    to "Burning stage number " + stage:NUMBER.
  }
}

function doLaunchTasks {
  updateDynamicReadouts().
  if ship:STATUS = "PRELAUNCH" {
    // set consoleGUI:WIDGETS[5]:WIDGETS[1]:WIDGETS[2]:WIDGETS[0]:WIDGETS[13]:TEXT
    // to "Ignition and...".
    global liftoffTime is time:SECONDS.
    // doSmartLiftoff().
    // set consoleGUI:WIDGETS[5]:WIDGETS[1]:WIDGETS[2]:WIDGETS[0]:WIDGETS[13]:TEXT
    // to "Liftoff!...".
    wait 1.
  }
  if ship:APOAPSIS >= targetApoapsis {
    consoleGUI:
    WIDGETS[5]:
    WIDGETS[1]:
    WIDGETS[2]:
    WIDGETS[0]:
    WIDGETS[17]:HIDE.
    consoleGUI:
    WIDGETS[5]:
    WIDGETS[1]:
    WIDGETS[2]:
    WIDGETS[0]:
    WIDGETS[18]:SHOW.
    set ascentCompleted to true.
    set launchUnderway to false.
    set consoleGUI:WIDGETS[5]:WIDGETS[1]:WIDGETS[2]:WIDGETS[0]:WIDGETS[13]:TEXT
    to "Ascent Complete!...".
  }
  if ship:STATUS = "FLYING" or ship:STATUS = "SUB_ORBITAL" {
    // print "Flying or suborbital condition entered".
    if not(defined beenOverridden) or beenOverridden = false {
      lock throttle to getThrottleValue().
    }
    set targetPitch to getTargetPitch().
    lock steering to heading(targetHeading, targetPitch).
    for part in ship:PARTS {
      if part:NAME:CONTAINS("fairing") and part:STAGE = stage:NUMBER - 1 {
        if ship:ALTITUDE >= 70000 {
        declare global stageTime to time:SECONDS.
        set consoleGUI:
        WIDGETS[5]:
        WIDGETS[1]:
        WIDGETS[2]:
        WIDGETS[0]:
        WIDGETS[13]:TEXT to "Fairing Jettisoned...".
        doSafeStage().
        print "performed a 1 step staging event".
        wait 1.
        }
      }
    }
    if stageSpent() {
      declare global stageTime to time:SECONDS.
      set consoleGUI:
      WIDGETS[5]:
      WIDGETS[1]:
      WIDGETS[2]:
      WIDGETS[0]:
      WIDGETS[13]:TEXT to "Staging...".
    }
    doStageCheckAndExecute().
  } else {
    print " ".
    print "An error occured. Liftoff probably failed".
    set launchUnderway to false.
  }
}

function doReleaseTasks {
  if not(launchAbortedDuringSession) {
    set ship:CONTROL:PILOTMAINTHROTTLE to 0.
  }
  set consoleGUI:
  WIDGETS[5]:
  WIDGETS[1]:
  WIDGETS[2]:
  WIDGETS[0]:
  WIDGETS[16]:ENABLED to false.
  unlock throttle.
  unlock steering.
}

function presentAbortWarningUI {
  local abortWarningGUI is gui(400, 50).
  local abortWarningPrompt is abortWarningGUI:ADDLABEL("Are you sure?").
  set abortWarningPrompt:STYLE:ALIGN to "CENTER".
  set abortWarningPrompt:STYLE:FONTSIZE to 45.
  set abortWarningPrompt:STYLE:TEXTCOLOR to YELLOW.
  local abortDisabiguation is "This will release all controls over to manual".
  local abortDisabiguation2 is " control, and leave the throttle where it is.".
  local abortDisabiguationFinal is abortDisabiguation + abortDisabiguation2.
  local abortWarningPrompt2 is abortWarningGUI:ADDLABEL(abortDisabiguationFinal).
  local choiceLayout is abortWarningGUI:ADDHLAYOUT().
  local yesButton is choiceLayout:ADDBUTTON("YES").
  set yesButton:STYLE:HEIGHT to 50.
  set yesButton:ONCLICK to yesClicked@.
  local noButton is choiceLayout:ADDBUTTON("NO").
  set noButton:STYLE:HEIGHT to 50.
  set noButton:ONCLICK to noClicked@.
  abortWarningGUI:SHOW.

  function yesClicked {
    abortWarningGUI:DISPOSE.
    set launchAbortedDuringSession to true.
    set launchUnderway to false.
    switchToPrelaunch(
      consoleGUI:
      WIDGETS[5]:
      WIDGETS[1]:
      WIDGETS[2]:
      WIDGETS[0]
    ).
  }

  function noClicked {
    abortWarningGUI:DISPOSE.
  }
}

function switchToPrelaunch {
  parameter clickedFromParent.
  local fullLaunchWidgetList is clickedFromParent:WIDGETS.
  local numLaunchWidgets is clickedFromParent:WIDGETS:LENGTH.
  local listToHide is fullLaunchWidgetList:SUBLIST(9, numLaunchWidgets - 9).
  for widgetToHide in listToHide {
    widgetToHide:HIDE.
  }
  for widgetToShow in fullLaunchWidgetList {
    if not(listToHide:CONTAINS(widgetToShow)) {
      widgetToShow:SHOW.
    }
  }
}

function switchToPostLiftoff {
  parameter clickedFromParent.
  local fullLaunchWidgetList is clickedFromParent:WIDGETS.
  local listToHide is fullLaunchWidgetList:SUBLIST(0, 9).
  for widgetToHide in listToHide {
    widgetToHide:HIDE.
  }
  for widgetToShow in fullLaunchWidgetList {
    if not(listToHide:CONTAINS(widgetToShow)) {
      widgetToShow:SHOW.
    }
  }
  clickedFromParent:WIDGETS[18]:HIDE.
}

function revertToEditorClicked {
  if KUniverse:CANREVERTTOEDITOR {
    KUniverse:REVERTTOEDITOR().
  } else {
    userAlert("Unable to revert back to editor.").
  }
}

function revertToLaunchClicked {
  if KUniverse:CANREVERTTOLAUNCH {
    KUniverse:REVERTTOLAUNCH().
  } else {
    userAlert("Unable to revert back to launch").
  }
}

function throttleOverrideClicked {
  parameter buttonCalledFrom.
  if buttonCalledFrom:TEXT = "Override Throttle" {
    if not(defined beenOverridden) {
      declare global beenOverridden to true.
      set SHIP:CONTROL:PILOTMAINTHROTTLE to getThrottleValue(). 
    } else {
      set beenOverridden to true.
    }
    unlock throttle.
    set buttonCalledFrom:TEXT to "Return Throttle Control".
  } else {
    set beenOverridden to false.
    set buttonCalledFrom:TEXT to "Override Throttle".
  }  
}

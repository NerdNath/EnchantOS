//enchantOSguiDelegates.lib.ks
//this will hold all the functions attached to buttons in the EnchantOS gui

//include the needed library scripts
runoncepath("1:/library/guiTools.lib.ks").
runoncepath("1:/library/fileIO.lib.ks").

function minimizeToggle {
  parameter buttonCalledFrom.
  if buttonCalledFrom:TEXT = "Shrink" {
    //toggle the text in the button
    set buttonCalledFrom:TEXT to "Expand".
    //toggle the state of the console gui
    buttonCalledFrom:PARENT:PARENT:SHOWONLY(buttonCalledFrom:PARENT).
    buttonCalledFrom:PARENT:SHOWONLY(buttonCalledFrom).
    buttonCalledFrom:PARENT:WIDGETS[2]:SHOW.
    set consoleGUI:STYLE:WIDTH to 115.
  } else {
    set buttonCalledFrom:TEXT to "Shrink".
    set consoleGUI:STYLE:WIDTH to consoleValues:width.
    for widget in buttonCalledFrom:PARENT:PARENT:WIDGETS {
      widget:SHOW.
    }
    for widget in buttonCalledFrom:PARENT:WIDGETS {
      widget:SHOW.
    }
  }
}

function loadSelect {
  parameter buttonCalledFrom.
  local isPressed is buttonCalledFrom:PRESSED.
  local fileNamesList is list().
  for file in archiveList {
    fileNamesList:ADD(file:NAME).
  }
  if not(isPressed) {
    local textString is buttonCalledFrom:TEXT.
    if not(textString:LENGTH = 0) and fileNamesList:CONTAINS(textString) {
      // print "String not 0 condition passed".
      set buttonCalledFrom:PARENT:WIDGETS[2]:ENABLED to true.
      return buttonCalledFrom:TEXT.
      fileList:ADD(buttonCalledFrom:TEXT).
      print fileList:DUMP.
    } else {
      // print "String not 0 condition failed".
    }
  }
}

function loadClick {
  parameter buttonCalledFrom.
  scriptLoad(loadSelect(buttonCalledFrom:PARENT:WIDGETS[1])). //from fileIO.lib.ks
  reListFiles().
  reListRunPopup(buttonCalledFrom:PARENT:PARENT:WIDGETS[2]:WIDGETS[1]).
  reListDeletePopup(buttonCalledFrom:PARENT:PARENT:WIDGETS[3]:WIDGETS[1]).
  set buttonCalledFrom:ENABLED to false.
}

function runSelected {
  parameter buttonCalledFrom.
  local pressedDown is buttonCalledFrom:PRESSED.
  if not(pressedDown) and not(buttonCalledFrom:TEXT:LENGTH = 0) {
    set buttonCalledFrom:PARENT:WIDGETS[2]:ENABLED to true.
    return buttonCalledFrom:TEXT.
  } else return false.
  
}

function runClicked {
  parameter buttonCalledFrom.
  set buttonCalledFrom:ENABLED to false.
  set scriptCalled to true.
  set scriptToRun to buttonCalledFrom:PARENT:WIDGETS[1]:TEXT.
}

function deleteSelect {
  parameter buttonCalledFrom.
  local pressedDown is buttonCalledFrom:PRESSED.
  local fileListNames is list().
  local popupText is buttonCalledFrom:TEXT.
  for file in fileList {
    fileListNames:ADD(file:NAME).
  }
  if not(pressedDown) {
    if not(popupText:LENGTH = 0) and fileListNames:CONTAINS(popupText) {
      set buttonCalledFrom:PARENT:WIDGETS[2]:ENABLED to true.
      return popupText.
    }
  }
}

function deleteClick {
  parameter buttonCalledFrom.
  deletepath(deleteSelect(buttonCalledFrom:PARENT:WIDGETS[1])).
  reListDeletePopup(buttonCalledFrom:PARENT:PARENT:WIDGETS[3]:WIDGETS[1]).
  reListRunPopup(buttonCalledFrom:PARENT:PARENT:WIDGETS[2]:WIDGETS[1]).
  reListFiles().
  set buttonCalledFrom:ENABLED to false.
}

function reListFiles {
  consoleGUI:WIDGETS[5]:WIDGETS[0]:CLEAR.
  for item in fileList {
    local shownFile is consoleGUI:WIDGETS[5]:WIDGETS[0]:ADDLABEL(item:NAME).
    set shownFile:STYLE:MARGIN:TOP to 1.
    set shownFile:STYLE:MARGIN:BOTTOM to 1.
    set shownFile:STYLE:PADDING:TOP to 1.
    set shownFile:STYLE:PADDING:BOTTOM to 1.
  }
}

function reListRunPopup {
  parameter popupToRelist.
  popupToRelist:CLEAR.
  set popupToRelist:OPTIONS to fileList.
}

function reListDeletePopup {
  parameter popupToRelist.
  popupToRelist:CLEAR.
  set popupToRelist:OPTIONS to fileList.
}

function automationListEditClick {
  parameter buttonCalledFrom.
  if buttonCalledFrom:PRESSED {
    switchStackTo(//function from guiTools.lib.ks
      consoleGUI:
      WIDGETS[5]:
      WIDGETS[1]:
      WIDGETS[4]
    ).
  } else {
    switchStackTo(lastStack, internalScriptOptions).
  }
  // set scriptTitlesBox:STYLE:WIDTH to 329.
}

function internalScriptDisplayed {
  parameter choice.
  print choice.
  if choice = "Maneuver Lock" scriptLineToggle(maneuverLockLine).
}

function internalAutomationHideShow {
  parameter internalScriptButton.
  parameter showButton.
  parameter hideButton.
}

function automationVisToggled {
  parameter buttonClicked.
  set editRowString to buttonClicked:PARENT:WIDGETS[0]:TEXT.
  if internalScriptOptions[editRowString] = true {
    set internalScriptOptions[editRowString] to false.
    findAndHideLabelGUI(
      buttonClicked:PARENT:PARENT:PARENT:PARENT:WIDGETS[0],
      editRowString
    ).
  } else {
    set internalScriptOptions[editRowString] to true.
  }
}

function automationButtonListRefresh {
  local autoButtons is consoleGUI:
  WIDGETS[5]://scriptsArea
  WIDGETS[1]://internalScriptsArea
  WIDGETS[0]://internalAutoListStack
  WIDGETS[0]://internalAutomationBox
  WIDGETS.//list of buttons
  for key in internalScriptOptions:KEYS {
    if internalScriptOptions[key] = true {
      for button in autoButtons {
        if button:TEXT = key {button:SHOW.}
      }
    }
  }
}

function closeAutomationClicked {
  parameter buttonCalledFrom.
  switchStackTo(lastStack).
  local topGui is buttonCalledFrom:PARENT:PARENT:PARENT:PARENT:PARENT.
  set topGui:WIDGETS[1]:WIDGETS[1]:ENABLED to true.
  set topGui:WIDGETS[2]:WIDGETS[1]:ENABLED to true.
  set topGui:WIDGETS[3]:WIDGETS[1]:ENABLED to true.
  set topGui:WIDGETS[4]:WIDGETS[2]:ENABLED to true.
}

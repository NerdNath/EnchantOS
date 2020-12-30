//enchantOSguiDelegates.lib.ks
//this will hold all the functions attached to buttons in the EnchantOS gui

//include the needed library scripts
runoncepath("1:/library/guiTools.lib.ks").
runoncepath("1:/library/fileIO.lib.ks").

function minimizeToggle {
  set guisWidgetsList to consoleGUI:WIDGETS.
  set titlesWidgetsList to titleLayout:WIDGETS.
  if minimizeButton:TEXT = "Shrink" {
    //toggle the text in the button
    set minimizeButton:TEXT to "Expand".
    //toggle the state of the console gui
    consoleGUI:SHOWONLY(titleLayout).
    titleLayout:SHOWONLY(minimizeButton).
    quitButton:SHOW.
    set consoleGUI:STYLE:WIDTH to 115.
  } else {
    set minimizeButton:TEXT to "Shrink".
    set consoleGUI:STYLE:WIDTH to consoleValues:width.
    for widget in guisWidgetsList {
      widget:SHOW.
    }
    for widget in titlesWidgetsList {
      widget:SHOW.
    }
  }
}

function loadSelect {
  parameter choice.
  set loadScriptButton:ENABLED to true.
  set scriptToLoad to choice.
  fileList:ADD(choice).
}

function loadClick {
  set loadScriptButton:ENABLED to false.
  scriptLoad(scriptToLoad). //from fileIO.lib.ks
  reListFiles().
  reListRunPopup().
  reListDeletePopup().
}

function runSelect {
  parameter choice.
  set runScriptButton:ENABLED to true.
  set scriptToRun to choice.
}

function runClick {
  set runScriptButton:ENABLED to false.
  set scriptCalled to true.
}

function deleteSelect {
  parameter choice.
  set deleteScriptButton:ENABLED to true.
  set scriptToDelete to choice.
}

function deleteClick {
  set deleteScriptButton:ENABLED to false.
  deletepath(scriptToDelete).
  reListDeletePopup().
  reListRunPopup().
  reListFiles().
}

function reListFiles {
  cpuFilesBox:CLEAR.
  for item in fileList {
    set shownFile to cpuFilesBox:ADDLABEL(item:NAME).
    set shownFile:STYLE:MARGIN:TOP to 1.
    set shownFile:STYLE:MARGIN:BOTTOM to 1.
    set shownFile:STYLE:PADDING:TOP to 1.
    set shownFile:STYLE:PADDING:BOTTOM to 1.
  }
}

function reListRunPopup {
  runSelectPopup:CLEAR.
  set runSelectPopup:OPTIONS to fileList.
}

function reListDeletePopup {
  deleteSelectPopup:CLEAR.
  set deleteSelectPopup:OPTIONS to fileList.
}

function automationListEditClick {
  editAutomationListToggle(lastStack).
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

function editAutomationListToggle {
  parameter previousStack.
  if automationListEdit:PRESSED {
    switchStackTo(automationListEditStack). //function from guiTools.lib.ks
  } else {
    switchStackTo(previousStack, internalScriptOptions).
  }
}

function automationVisToggled {
  parameter buttonClicked.
  set editRowString to buttonClicked:PARENT:WIDGETS[0]:TEXT.
  if internalScriptOptions[editRowString] = true {
    set internalScriptOptions[editRowString] to false.
    findAndHideLabelGUI(internalAutomationBox,editRowString).
  } else {
    set internalScriptOptions[editRowString] to true.
  }
}

function automationButtonListRefresh {
  for key in internalScriptOptions:KEYS {
    if internalScriptOptions[key] = true {
      for button in internalAutomationBox:WIDGETS {
        if button:TEXT = key {button:SHOW.}
      }
    }
  }
}

function closeAutomationClicked {
  switchStackTo(lastStack).
  set automationListEdit:ENABLED to true.
  set loadSelectPopup:ENABLED to true.
  set runSelectPopup:ENABLED to true.
  set deleteSelectPopup:ENABLED to true.
}
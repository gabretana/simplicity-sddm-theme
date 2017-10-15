import QtQuick 2.0
import SddmComponents 2.0
import "./SimpleControls"

Rectangle {
    
    width: 640
    height: 480
    
    LayoutMirroring.enabled: Qt.locale().textDirection == Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

    TextConstants { id: textConstants }
    
    Connections {
        target: sddm
        onLoginSucceeded: {}
        onLoginFailed: {
            pw_entry.text = ""
        }
    }
    
    Background {
        anchors.fill: parent
        source: config.background
        fillMode: Image.PreserveAspectCrop
        onStatusChanged: {
            if (status == Image.Error && source != config.defaultBackground) {
                source = config.defaultBackground
            }
        }
    }
    
    Rectangle {
        anchors.fill: parent
        color: "transparent"
        
        SimpleClock {
            id: time_label
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            color: "white"
            timeFont.family: "Noto Sans"
            dateFont.family: "Noto Sans"
            timeFontSize: 16
            dateFontSize: 12
        }
        
        Rectangle {
            width: 400
            height: 250
            color: "transparent"
            anchors.centerIn: parent
            
            Rectangle {
                id: entries
                width: parent.width
                height: 200
                color: Qt.rgba(33/255, 33/255, 33/255, 0.8)
                radius: 4
                
                Column {
                    anchors.centerIn: parent
                    spacing: 20
                    
                    Row {
                   
                        /*TextBox {
                            id: user_entry
                            radius: 2
                            width: 250
                            anchors.verticalCenter: parent.verticalCenter
                            text: userModel.lastUser
                            font.pixelSize: 16
                            
                            KeyNavigation.backtab: session; KeyNavigation.tab: pw_entry
                        }*/
                        SimpleComboBox {
                            id: user_entry
                            anchors.verticalCenter: parent.verticalCenter
                            width: 250
                            color: "transparent"
                            dropDownColor: "#212121"
                            borderColor: "transparent"
                            textColor: "white"
                            arrowIcon: "images/arrow-down.png"
                            arrowColor: "transparent"
                            model: userModel
                            index: userModel.lastIndex

                            font.pixelSize: 16
                            KeyNavigation.backtab: session; KeyNavigation.tab: pw_entry
                        }
                   
                    }
                    
                    Row {
                        PasswordBox {
                            id: pw_entry
                            radius: 2
                            width: 250
                            anchors.verticalCenter: parent.verticalCenter;
                            font.pixelSize: 16
                            color: "transparent"
                            borderColor: "#9E9E9E"
                            focusColor: "#3F51B5"
                            hoverColor: "#3F51B5"
                            textColor: "white"
                            focus: true
                            
                            KeyNavigation.backtab: user_entry; KeyNavigation.tab: loginButton

                            Keys.onPressed: {
                                if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                    sddm.login(user_entry.currentText, pw_entry.text, session.index)
                                    event.accepted = true
                                }
                            }
                        }
                    }
                    
                    Row {
                        anchors.horizontalCenter: parent.horizontalCenter
                        Button {
                            id: loginButton
                            text: textConstants.login
                            width: 150
                            color: "#3F51B5"
                            activeColor: "#5C6BC0"
                            pressedColor: "#5C6BC0"
                            radius: 2
                            onClicked: sddm.login(user_entry.currentText, pw_entry.text, session.index)
                            KeyNavigation.backtab: pw_entry; KeyNavigation.tab: restart
                        }
                    }
                    
                }
                
            }
            
            Rectangle {
                anchors.top: entries.bottom
                width: parent.width
                height: 75
                color: Qt.rgba(33/255, 33/255, 33/255, 0.8)
                
                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 10
                    
                    Button {
                        id: restart
                        text: textConstants.reboot
                        color: "#37474F"
                        pressedColor: "#455A64"
                        activeColor: "#455A64"
                        radius: 2
                        onClicked: sddm.reboot()
                        KeyNavigation.backtab: loginButton; KeyNavigation.tab: shutdown
                    }
                    
                    Button {
                        id: shutdown
                        text: textConstants.shutdown
                        color: "#37474F"
                        pressedColor: "#455A64"
                        activeColor: "#455A64"
                        radius: 2
                        onClicked: sddm.powerOff()
                        KeyNavigation.backtab: restart; KeyNavigation.tab: session
                    }
                    
                }
                
            }
            
        }
        
    }
    
    Rectangle {
        id: dateClock
        width: parent.width - 10
        height: 30
        color: "transparent"
        anchors.top: parent.top;
        anchors.horizontalCenter: parent.horizontalCenter
        
        SimpleComboBox {
            id: session
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            width: 160
            color: "transparent"
            dropDownColor: "#212121"
            borderColor: "transparent"
            textColor: "white"
            arrowIcon: "images/arrow-down.png"
            arrowColor: "transparent"
            model: sessionModel
            index: sessionModel.lastIndex

            font.pixelSize: 16
            KeyNavigation.backtab: shutdown; KeyNavigation.tab: user_entry
        }
        
        
        /*Text {
            id: time_label
            anchors.centerIn: parent
            //anchors.right: parent.right
            text: Qt.formatDateTime(new Date(), "dddd, dd MMMM yyyy HH:mm")
            color: "white"
            font.pixelSize: 16
        }*/
        
    }
    
    Component.onCompleted: {
        /*if (user_entry.text === "")
            user_entry.focus = true
        else
            pw_entry.focus = true*/
        pw_entry.focus = true
    }
}

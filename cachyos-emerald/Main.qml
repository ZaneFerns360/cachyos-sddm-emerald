//*********************************************************************

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQml.Models 2.15
import SddmComponents 2.0

Rectangle {
    width: 640
    height: 480
    Component.onCompleted: {
        if (name.text == "")
            name.focus = true;
        else
            password.focus = true;
    }

    TextConstants {
        id: textConstants
    }

    Connections {
        target: sddm
        onLoginSucceeded: {
            errorMessage.color = "#00d4aa";
            errorMessage.text = textConstants.loginSucceeded;
        }
        onLoginFailed: {
            errorMessage.color = "#ff5555";
            errorMessage.text = textConstants.loginFailed;
        }
    }

    Image {
        anchors.fill: parent
        source: Qt.resolvedUrl("background.png")
        fillMode: Image.PreserveAspectCrop
    }

    Rectangle {
        anchors.fill: parent
        color: "#00000088"
    }

    Rectangle {
        property variant geometry: screenModel.geometry(screenModel.primary)
        x: geometry.x
        y: geometry.y
        width: geometry.width
        height: geometry.height
        color: "#00000088"
        transformOrigin: Item.Top

        Image {
            id: cachylogo

            width: height * 10
            height: parent.height / 4
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: parent.height * 0.08
            fillMode: Image.PreserveAspectFit
            transformOrigin: Item.Center
            source: "cachyos.png"
        }

        Rectangle {
            anchors.centerIn: cachylogo
            width: cachylogo.width * 0.35
            height: width
            radius: width / 2
            color: "#00d4aa22"
            z: -1
        }

        Rectangle {
            id: cachyos

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: cachylogo.bottom
            anchors.topMargin: 20
            width: parent.width * 0.42
            height: parent.height * 0.42
            color: "#081b1f"
            radius: 20
            border.width: 2
            border.color: "#1ce0c155"
            layer.enabled: true

            Column {

                id: mainColumn

                anchors.centerIn: parent
                width: parent.width * 0.88
                spacing: 18

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    verticalAlignment: Text.AlignVCenter
                    width: parent.width
                    height: text.implicitHeight
                    color: "white"
                    text: textConstants.welcomeText.arg(sddm.hostName) + " <font color='#00d4aa'>CachyOS</font>"
                    textFormat: Text.RichText
                    wrapMode: Text.WordWrap
                    font.pixelSize: 32
                    font.weight: Font.DemiBold
                    horizontalAlignment: Text.AlignHCenter
                }

                Column {
                    width: parent.width
                    spacing: 6

                    Text {
                        text: textConstants.userName
                        color: "#9bcac5"
                        font.pixelSize: 16
                    }

                    Rectangle {
                        width: parent.width
                        height: 48
                        radius: 14
                        color: "#12363acc"
                        border.width: name.activeFocus ? 2 : 1
                        border.color: name.activeFocus ? "#00d4aa" : "#1f5b60"

                        TextInput {
                            id: name
                            font.weight: Font.Medium

                            anchors.fill: parent
                            anchors.leftMargin: 16
                            anchors.rightMargin: 16
                            verticalAlignment: Text.AlignVCenter
                            color: "#ecfffc"
                            font.pixelSize: 18
                            selectionColor: "#00d4aa"
                            selectedTextColor: "#081b1f"
                            text: userModel.lastUser
                            KeyNavigation.backtab: rebootButton
                            KeyNavigation.tab: password
                            Keys.onPressed: {
                                if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                    sddm.login(name.text, password.text, sessionList.currentIndex);
                                    event.accepted = true;
                                }
                            }
                        }

                        Behavior on border.color {
                            ColorAnimation {
                                duration: 120
                            }

                        }

                    }

                }

                Column {
                    width: parent.width
                    spacing: 6

                    Text {
                        text: textConstants.password
                        color: "#9bcac5"
                        font.pixelSize: 16
                    }

                    Rectangle {
                        width: parent.width
                        height: 48
                        radius: 14
                        color: "#12363acc"
                        border.width: password.activeFocus ? 2 : 1
                        border.color: password.activeFocus ? "#00d4aa" : "#1f5b60"

                        TextInput {
                            id: password
                            font.weight: Font.Medium

                            anchors.fill: parent
                            anchors.leftMargin: 16
                            anchors.rightMargin: 16
                            verticalAlignment: Text.AlignVCenter
                            color: "#ecfffc"
                            echoMode: TextInput.Password
                            font.pixelSize: 18
                            selectionColor: "#00d4aa"
                            selectedTextColor: "#081b1f"
                            KeyNavigation.backtab: name
                            Keys.onPressed: {
                                if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                    sddm.login(name.text, password.text, sessionList.currentIndex);
                                    event.accepted = true;
                                }
                            }
                        }

                        Behavior on border.color {
                            ColorAnimation {
                                duration: 120
                            }

                        }

                    }

                }

                Column {
                    width: parent.width
                    spacing: 6
                    z: 999

                    Text {
                        text: textConstants.session
                        color: "#9bcac5"
                        font.pixelSize: 16
                    }

                    Rectangle {
                        id: sessionBox

                        property string selectedName: ""
                        property int selectedIndex: sessionModel.lastIndex >= 0 ? sessionModel.lastIndex : 0

                        Component.onCompleted: {
                            selectedName = sessionModel.data(sessionModel.index(selectedIndex, 0), Qt.UserRole + 4);
                        }
                        width: parent.width
                        height: 48
                        radius: 14
                        color: "#12363acc"
                        border.width: sessionPopup.visible ? 2 : 1
                        border.color: sessionPopup.visible ? "#00d4aa" : "#1f5b60"

                        Text {
                            id: selectedSessionText

                            font.weight: Font.Medium

                            anchors.left: parent.left
                            anchors.leftMargin: 16
                            anchors.verticalCenter: parent.verticalCenter
                            text: sessionBox.selectedName
                            color: "#ecfffc"
                            font.pixelSize: 16
                            width: parent.width - 50
                            elide: Text.ElideRight
                        }

                        Image {
                            anchors.right: parent.right
                            anchors.rightMargin: 16
                            anchors.verticalCenter: parent.verticalCenter
                            width: 14
                            height: 14
                            source: "angle-down.png"
                            fillMode: Image.PreserveAspectFit
                            rotation: sessionPopup.visible ? 180 : 0

                            Behavior on rotation {
                                NumberAnimation {
                                    duration: 120
                                }

                            }

                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: sessionPopup.visible ? sessionPopup.close() : sessionPopup.open()
                        }

                        Popup {
                            id: sessionPopup

                            width: sessionBox.width
                            x: 0
                            y: sessionBox.height + 8
                            padding: 10
                            modal: true
                            focus: true



                            background: Rectangle {
                                radius: 18
                                color: "#081b1fee"
                                border.width: 1
                                border.color: "#1f5b60"
                            }

                            contentItem: ListView {
                                id: sessionList

                                implicitHeight: Math.min(contentHeight, 200)
                                spacing: 8
                                clip: true
                                model: sessionModel
                                currentIndex: sessionBox.selectedIndex

                                delegate: Rectangle {
                                    required property int index
                                    required property string name

                                    width: sessionList.width
                                    height: 42
                                    radius: 10
                                    color: sessionList.currentIndex === index ? "#00d4aa" : delegateMouse.containsMouse ? "#00d4aa" : "#7c98bd"
                                    border.width: sessionList.currentIndex === index ? 1 : 0
                                    border.color: "#4dfff0"

                                    Text {
                                        anchors.centerIn: parent
                                        text: name
                                        color: sessionList.currentIndex === index ? "#081b1f" : "#ecfffc"
                                        font.pixelSize: 16
                                        font.bold: sessionList.currentIndex === index
                                    }

                                    MouseArea {
                                        id: delegateMouse

                                        anchors.fill: parent
                                        hoverEnabled: true
                                        onClicked: {
                                            sessionList.currentIndex = index;
                                            sessionBox.selectedIndex = index;
                                            sessionBox.selectedName = name;
                                            sessionModel.lastIndex = index;
                                            sessionPopup.close();
                                        }
                                    }

                                    Behavior on color {
                                        ColorAnimation {
                                            duration: 120
                                        }

                                    }

                                }

                            }

                            enter: Transition {
                                ParallelAnimation {
                                    NumberAnimation {
                                        property: "opacity"
                                        from: 0
                                        to: 1
                                        duration: 140
                                    }

                                    NumberAnimation {
                                        property: "scale"
                                        from: 0.96
                                        to: 1
                                        duration: 140
                                    }

                                }

                            }

                            exit: Transition {
                                NumberAnimation {
                                    property: "opacity"
                                    from: 1
                                    to: 0
                                    duration: 100
                                }

                            }

                        }

                        Behavior on border.color {
                            ColorAnimation {
                                duration: 120
                            }

                        }

                    }

                }

                Text {
                    id: errorMessage

                    anchors.horizontalCenter: parent.horizontalCenter
                    text: textConstants.prompt
                    color: "#cceeed"
                    font.pixelSize: 15
                }

                Row {
                    property int btnWidth: 120

                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 14

                    Rectangle {
                        id: loginButton

                        width: parent.btnWidth
                        height: 48
                        radius: 12
                        border.width: 1
                        border.color: "#4dfff0"
                        scale: loginMouse.containsMouse ? 1.03 : 1

                        Text {
                            anchors.centerIn: parent
                            text: textConstants.login
                            color: "#ffffff"
                            font.pixelSize: 18
                            font.bold: true
                        }

                        MouseArea {
                            id: loginMouse

                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: sddm.login(name.text, password.text, sessionList.currentIndex)
                        }

                        gradient: Gradient {
                            GradientStop {
                                position: 0
                                color: "#00d4aa"
                            }

                            GradientStop {
                                position: 1
                                color: "#00bfa5"
                            }

                        }

                        Behavior on scale {
                            NumberAnimation {
                                duration: 120
                            }

                        }

                    }

                    Rectangle {
                        id: shutdownButton

                        width: parent.btnWidth
                        height: 48
                        radius: 12
                        color: "#10292d"
                        border.width: 1
                        border.color: "#1f5b60"
                        scale: shutdownMouse.containsMouse ? 1.03 : 1

                        Text {
                            anchors.centerIn: parent
                            text: textConstants.shutdown
                            color: "#ecfffc"
                            font.pixelSize: 18
                        }

                        MouseArea {
                            id: shutdownMouse

                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: sddm.powerOff()
                        }

                        Behavior on scale {
                            NumberAnimation {
                                duration: 120
                            }

                        }

                    }

                    Rectangle {
                        id: rebootButton

                        width: parent.btnWidth
                        height: 48
                        radius: 12
                        color: "#10292d"
                        border.width: 1
                        border.color: "#1f5b60"
                        scale: rebootMouse.containsMouse ? 1.03 : 1

                        Text {
                            anchors.centerIn: parent
                            text: textConstants.reboot
                            color: "#ecfffc"
                            font.pixelSize: 18
                        }

                        MouseArea {
                            id: rebootMouse

                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: sddm.reboot()
                        }

                        Behavior on scale {
                            NumberAnimation {
                                duration: 120
                            }

                        }

                    }

                }

            }

        }

    }

}

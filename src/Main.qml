import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import SddmComponents
import "./components"

Item {
    id: root
    anchors.fill: parent

    property var detectedUsers: []
    property var detectedDEs: []
    property bool wrongPassword: false
    property int selectedDE: 0

    Component.onCompleted: {
        var users = []
        for (var i = 0; i < userModel.rowCount(); i++) {
            users.push(userModel.data(userModel.index(i, 0), Qt.UserRole + 1))
        }
        root.detectedUsers = users

        var sessions = []
        for (var j = 0; j < sessionModel.rowCount(); j++) {
            sessions.push(sessionModel.data(sessionModel.index(j, 0), Qt.UserRole + 4))
        }
        root.detectedDEs = sessions

        userComboBox.currentIndex = Math.max(0, userModel.lastIndex)
        deComboBox.currentIndex = Math.max(0, sessionModel.lastIndex)
        root.selectedDE = deComboBox.currentIndex
    }

    Item {
        id: bgWindow
        anchors.fill: parent

        WallpaperDisplay {
            id: backgroundImage
            anchors.fill: parent
            // source: Config.options.background.wallpaperPath
            source: Qt.resolvedUrl("backgrounds/SleexOne.png")
        }

        StyledText {
            id: timeText
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 100
            color: Appearance.colors.colPrimary
            text: DateTime.time
            font.pixelSize: 96
        }

        StyledText {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: timeText.bottom
            color: Appearance.colors.colOnSurfaceVariant
            text: DateTime.date
            font.bold: true
            font.pixelSize: 32
        }
    }

    Item {
        id: loginWindow
        anchors.fill: parent

        Item {
            id: bottomBar
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 50
            height: 70

            // Center Pill: Password Input
            Rectangle {
                id: passwordContainer
                anchors.centerIn: parent
                width: 400
                height: 70
                radius: Appearance.rounding.full
                color: Appearance.colors.colLayer0

                property int shakeOffset: 0
                transform: Translate { x: passwordContainer.shakeOffset }

                SequentialAnimation {
                    id: shakeAnim
                    NumberAnimation { target: passwordContainer; property: "shakeOffset"; to: -10; duration: 50 }
                    NumberAnimation { target: passwordContainer; property: "shakeOffset"; to: 10; duration: 50 }
                    NumberAnimation { target: passwordContainer; property: "shakeOffset"; to: -5; duration: 50 }
                    NumberAnimation { target: passwordContainer; property: "shakeOffset"; to: 5; duration: 50 }
                    NumberAnimation { target: passwordContainer; property: "shakeOffset"; to: 0; duration: 50 }
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 8

                    RippleButton {
                        colBackground: Appearance.colors.colLayer1
                        Layout.fillHeight: true
                        implicitWidth: height
                        buttonRadius: Appearance.rounding.full

                        MaterialSymbol {
                            text: passwordInput.echoMode === TextInput.Password ? "visibility" : "visibility_off"
                            iconSize: 20
                            color: Appearance.colors.colOnLayer0
                            anchors.centerIn: parent
                        }

                        onClicked: {
                            passwordInput.echoMode = passwordInput.echoMode === TextInput.Password ? TextInput.Normal : TextInput.Password
                            passwordInput.forceActiveFocus()
                        }
                    }

                    Rectangle {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        color: Appearance.colors.colLayer2
                        radius: Appearance.rounding.full
                        clip: true
                        
                        border.color: root.wrongPassword ? Appearance.m3colors.m3error : "transparent"
                        border.width: 1

                        StyledTextInput {
                            id: passwordInput
                            anchors.fill: parent
                            anchors.margins: 12
                            horizontalAlignment: TextInput.AlignHCenter
                            verticalAlignment: TextInput.AlignVCenter
                            focus: true
                            color: Appearance.colors.colOnLayer2
                            font.pixelSize: 15
                            echoMode: TextInput.Password
                            inputMethodHints: Qt.ImhSensitiveData

                            onTextChanged: root.wrongPassword = false
                            onAccepted: submitLogin()

                            StyledText {
                                anchors.centerIn: parent
                                text: qsTr("Enter password")
                                color: Appearance.colors.colSubtext
                                font.pixelSize: 15
                                visible: parent.text.length === 0
                            }
                        }

                        NumberAnimation on border.color {
                            duration: 300
                            easing.type: Easing.InOutQuad
                        }
                    }

                    RippleButton {
                        id: loginButton
                        colBackground: Appearance.colors.colPrimary
                        colBackgroundHover: Appearance.colors.colPrimaryContainer
                        Layout.fillHeight: true
                        implicitWidth: height
                        buttonRadius: Appearance.rounding.full

                        MaterialSymbol {
                            text: "arrow_forward"
                            iconSize: 24
                            color: Appearance.colors.colOnPrimary
                            anchors.centerIn: parent
                        }

                        onClicked: submitLogin()
                    }
                }
            }

            // Left Pill: User & Session
            Rectangle {
                id: leftPill
                anchors.right: passwordContainer.left
                anchors.rightMargin: 15
                anchors.verticalCenter: parent.verticalCenter
                height: 70
                width: leftLayout.implicitWidth + 24 
                radius: Appearance.rounding.full
                color: Appearance.colors.colLayer0

                RowLayout {
                    id: leftLayout
                    anchors.centerIn: parent
                    spacing: 4

                    IconComboBox {
                        id: userComboBox
                        icon: "account_circle"
                        model: root.detectedUsers
                    }

                    IconComboBox {
                        id: deComboBox
                        icon: "call_to_action" 
                        model: root.detectedDEs
                        onCurrentIndexChanged: {
                            root.selectedDE = deComboBox.currentIndex
                        }
                    }
                }
            }

            // Right Pill: Power Controls
            Rectangle {
                id: sysControls
                anchors.left: passwordContainer.right
                anchors.leftMargin: 15
                anchors.verticalCenter: parent.verticalCenter
                height: 70
                width: suspendButton.width + rebootButton.width + poweroffButton.width + 40
                color: Appearance.colors.colLayer0
                radius: Appearance.rounding.full

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 10

                    RippleButton {
                        id: suspendButton
                        colBackground: Appearance.colors.colLayer1
                        Layout.fillHeight: true
                        implicitWidth: height
                        buttonRadius: Appearance.rounding.full
                        MaterialSymbol {
                            text: "bedtime"
                            iconSize: 20
                            color: Appearance.colors.colOnLayer0
                            anchors.centerIn: parent
                        }
                        onClicked: sddm.suspend()
                    }
                    
                    RippleButton {
                        id: rebootButton
                        colBackground: Appearance.colors.colLayer1
                        Layout.fillHeight: true
                        implicitWidth: height
                        buttonRadius: Appearance.rounding.full
                        MaterialSymbol {
                            text: "restart_alt"
                            iconSize: 20
                            anchors.centerIn: parent
                            color: Appearance.colors.colOnLayer0
                        }
                        onClicked: sddm.reboot()
                    }

                    RippleButton {
                        id: poweroffButton
                        colBackground: Appearance.colors.colLayer1
                        colBackgroundHover: Appearance.colors.colErrorContainer
                        Layout.fillHeight: true
                        implicitWidth: height
                        buttonRadius: Appearance.rounding.full
                        MaterialSymbol {
                            text: "power_settings_new"
                            iconSize: 20
                            anchors.centerIn: parent
                            color: Appearance.colors.colOnLayer0
                        }
                        onClicked: sddm.powerOff()
                    }
                }
            }
        }
    }

    function submitLogin() {
        if (passwordInput.text.length > 0) {
            loginButton.enabled = false
            var user = root.detectedUsers[userComboBox.currentIndex] || ""
            sddm.login(user, passwordInput.text, deComboBox.currentIndex)
        }
    }

    Connections {
        target: sddm

        function onLoginFailed() {
            passwordInput.text = ""
            loginButton.enabled = true
            root.wrongPassword = true
            shakeAnim.start()
            passwordInput.forceActiveFocus()
        }

        function onLoginSucceeded() {
            // Nothing to do here
        }
    }
}
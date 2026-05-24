pragma Singleton
import QtQuick

QtObject {
    id: root

    property string time: ""
    property string shortDate: ""
    property string date: ""
    property string collapsedCalendarFormat: ""
    property string longDateFormat: ""

    property Timer _timer: Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            var d = new Date()
            root.time = d.toLocaleTimeString(Qt.locale(), "hh:mm")
            root.shortDate = d.toLocaleDateString(Qt.locale(), "dd/MM")
            root.date = d.toLocaleDateString(Qt.locale(), "dddd, dd/MM")
            root.collapsedCalendarFormat = d.toLocaleDateString(Qt.locale(), "dd MMMM yyyy")
            root.longDateFormat = d.toLocaleDateString(Qt.locale(), "dddd dd MMMM yyyy")
        }
    }

    Component.onCompleted: _timer.triggered()
}
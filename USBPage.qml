/*
 * Copyright (C) 2016 - Sylvia van Os <iamsylvie@openmailbox.org>
 * Copyright (C) 2015 - Florent Revest <revestflo@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.1
import org.nemomobile.dbus 2.0
import org.asteroid.controls 1.0

Item {
    id: root
    property var pop

    Text {
        id: title
        color: "white"
        text: qsTr("Select a USB mode:")
        height: parent.height*0.2
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }

    ListModel {
        id: usbModesModel
        ListElement { title: qsTr("Adb Mode"); mode: "adb_mode" }
        ListElement { title: qsTr("Developer Mode"); mode: "developer_mode" }
        ListElement { title: qsTr("Mass Storage"); mode: "mass_storage" }
        ListElement { title: qsTr("MTP Mode"); mode: "mtp_mode" }
    }
    ListView {
        id: usbModeLV
        anchors.top: title.bottom
        height: parent.height*0.6
        width: parent.width
        clip: true
        spacing: 15
        model: usbModesModel
        delegate: Item {
            width: usbModeLV.width
            height: 30
            Text {
                text: title
                anchors.centerIn: parent
                color: parent.ListView.isCurrentItem ? "white" : "lightgrey"
                scale: parent.ListView.isCurrentItem ? 1.5 : 1
                Behavior on scale { NumberAnimation { duration: 200 } }
                Behavior on color { ColorAnimation { } }
            }
        }
        preferredHighlightBegin: height / 2 - 15
        preferredHighlightEnd: height / 2 + 15
        highlightRangeMode: ListView.StrictlyEnforceRange
    }

    IconButton {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: app.height/28

        iconColor: "white"
        pressedIconColor: "lightgrey"
        iconName: "ios-checkmark-circle-outline"

        onClicked: {
            usbmodedDbus.call("set_mode", [usbModesModel.get(usbModeLV.currentIndex).mode])

            root.pop();
        }
    }
    
    Component.onCompleted: {
        usbmodedDbus.typedCall('mode_request', [], function (mode) {
            if     (mode == "mtp_mode")       usbModeLV.currentIndex = 3
            else if(mode == "mass_storage")   usbModeLV.currentIndex = 2
            else if(mode == "developer_mode") usbModeLV.currentIndex = 1
            else  /*mode == "adb_mode"*/      usbModeLV.currentIndex = 0
        });
    }

    DBusInterface {
        id: usbmodedDbus
        bus: DBus.SystemBus
        service: "com.meego.usb_moded"
        path: "/com/meego/usb_moded"
        iface: "com.meego.usb_moded"
    }
}


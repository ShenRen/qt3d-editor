/****************************************************************************
**
** Copyright (C) 2016 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Qt3D Editor of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:GPL-EXCEPT$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3 as published by the Free Software
** Foundation with exceptions as appearing in the file LICENSE.GPL3-EXCEPT
** included in the packaging of this file. Please review the following
** information to ensure the GNU General Public License requirements will
** be met: https://www.gnu.org/licenses/gpl-3.0.html.
**
** $QT_END_LICENSE$
**
****************************************************************************/
import QtQuick 2.5
import com.theqtcompany.SceneEditor3D 1.0
import Qt.labs.controls 1.0 as QLC
import Qt3D.Core 2.0
import Qt3D.Render 2.0

ComponentDelegate {
    id: thisDelegate
    componentType: EditorSceneItemComponentsModel.CameraEntity
    title: qsTr("Camera") + editorScene.emptyString

    viewTitleVisible: cameraViewVisible

    onChangeViewVisibity: {
        cameraViewVisible = viewVisibility
    }

    Component.onCompleted: {
        if (!cameraViewVisible)
            height = minimumComponentHeight
    }

    // Need this separate connection as any checked property binding will not persist
    // over user clicking on the radio buttons.
    Connections {
        target: componentData
        onProjectionTypeChanged: {
            if (componentData.projectionType === CameraLens.OrthographicProjection)
                orthoButton.checked = true
            else
                perspectiveButton.checked = true
        }
    }

    function changeProjectionType(newValue) {
        var oldValue = componentData.projectionType;
        if (oldValue !== newValue) {
            editorScene.undoHandler.createChangePropertyCommand(
                        selectedEntityName, componentType,
                        "projectionType", newValue, oldValue, true);
        }
    }

    Column {
        spacing: 4
        width: parent.width

        QLC.GroupBox {
            title: qsTr("Projection Type") + editorScene.emptyString
            Row {
                QLC.RadioButton {
                    id: orthoButton
                    text: qsTr("Orthographic") + editorScene.emptyString
                    checked: componentData.projectionType === CameraLens.OrthographicProjection
                    indicator: Rectangle {
                        implicitWidth: 20
                        implicitHeight: 20
                        x: orthoButton.text ?
                               (orthoButton.mirrored ? orthoButton.width - width
                                                       - orthoButton.rightPadding :
                                                       orthoButton.leftPadding) :
                               orthoButton.leftPadding + (orthoButton.availableWidth - width) / 2
                        y: orthoButton.topPadding + (orthoButton.availableHeight - height) / 2

                        radius: width / 2
                        border.width: 1
                        border.color: (orthoButton.pressed ? "#26282a" : "#353637")
                        color: orthoButton.pressed ? "#e4e4e4" : "#f6f6f6"

                        Rectangle {
                            x: (parent.width - width) / 2
                            y: (parent.height - height) / 2
                            width: 14
                            height: 14
                            radius: width / 2
                            color: orthoButton.pressed ? "#26282a" : "#353637"
                            visible: orthoButton.checked
                        }
                    }
                    onCheckedChanged: {
                        if (checked)
                            changeProjectionType(CameraLens.OrthographicProjection)
                    }
                }
                QLC.RadioButton {
                    id: perspectiveButton
                    text: qsTr("Perspective") + editorScene.emptyString
                    checked: componentData.projectionType === CameraLens.PerspectiveProjection
                    indicator: Rectangle {
                        implicitWidth: 20
                        implicitHeight: 20
                        x: perspectiveButton.text ?
                               (perspectiveButton.mirrored ? perspectiveButton.width - width
                                                             - perspectiveButton.rightPadding :
                                                             perspectiveButton.leftPadding) :
                               perspectiveButton.leftPadding + (perspectiveButton.availableWidth
                                                                - width) / 2
                        y: perspectiveButton.topPadding + (perspectiveButton.availableHeight
                                                           - height) / 2

                        radius: width / 2
                        border.width: 1
                        border.color: (perspectiveButton.pressed ? "#26282a" : "#353637")
                        color: perspectiveButton.pressed ? "#e4e4e4" : "#f6f6f6"

                        Rectangle {
                            x: (parent.width - width) / 2
                            y: (parent.height - height) / 2
                            width: 14
                            height: 14
                            radius: width / 2
                            color: perspectiveButton.pressed ? "#26282a" : "#353637"
                            visible: perspectiveButton.checked
                        }
                    }
                    onCheckedChanged: {
                        if (checked)
                            changeProjectionType(CameraLens.PerspectiveProjection)
                    }
                }
            }
        }

        FloatPropertyInputField {
            id: nearPlaneField
            label: qsTr("Near Plane") + editorScene.emptyString
            propertyName: "nearPlane"
            component: componentData
            componentType: thisDelegate.componentType
        }

        FloatPropertyInputField {
            id: farPlaneField
            label: qsTr("Far Plane") + editorScene.emptyString
            propertyName: "farPlane"
            component: componentData
            componentType: thisDelegate.componentType
        }

        FloatSliderPropertyInputField {
            id: fieldOfViewField
            visible: componentData.projectionType === CameraLens.PerspectiveProjection
            label: qsTr("Field of View") + editorScene.emptyString
            propertyName: "fieldOfView"
            component: componentData
            componentType: thisDelegate.componentType
            minimum: 0
            maximum: 180
            stepSize: 1
        }

        FloatPropertyInputField {
            id: aspectRatioField
            visible: componentData.projectionType === CameraLens.PerspectiveProjection
            label: qsTr("Aspect Ratio") + editorScene.emptyString
            propertyName: "aspectRatio"
            component: componentData
            componentType: thisDelegate.componentType
        }

        FloatPropertyInputField {
            id: leftField
            label: qsTr("Left") + editorScene.emptyString
            visible: componentData.projectionType === CameraLens.OrthographicProjection
            propertyName: "left"
            component: componentData
            componentType: thisDelegate.componentType
        }

        FloatPropertyInputField {
            id: rightField
            label: qsTr("Right") + editorScene.emptyString
            visible: componentData.projectionType === CameraLens.OrthographicProjection
            propertyName: "right"
            component: componentData
            componentType: thisDelegate.componentType
        }

        FloatPropertyInputField {
            id: bottomField
            label: qsTr("Bottom") + editorScene.emptyString
            visible: componentData.projectionType === CameraLens.OrthographicProjection
            propertyName: "bottom"
            component: componentData
            componentType: thisDelegate.componentType
        }

        FloatPropertyInputField {
            id: topField
            label: qsTr("Top") + editorScene.emptyString
            visible: componentData.projectionType === CameraLens.OrthographicProjection
            propertyName: "top"
            component: componentData
            componentType: thisDelegate.componentType
        }

        Vector3DPropertyInputField {
            id: positionVectorField
            label: qsTr("Position") + editorScene.emptyString
            propertyName: "position"
            component: componentData
            componentType: thisDelegate.componentType
        }

        Vector3DPropertyInputField {
            id: upVectorField
            label: qsTr("Up") + editorScene.emptyString
            propertyName: "upVector"
            component: componentData
            componentType: thisDelegate.componentType
            // TODO: Need to block (0,0,0) value for upvector somehow, it crashes the camera
        }

        Vector3DPropertyInputField {
            id: viewCenterVectorField
            label: qsTr("View Center") + editorScene.emptyString
            propertyName: "viewCenter"
            component: componentData
            componentType: thisDelegate.componentType
        }
    }
}


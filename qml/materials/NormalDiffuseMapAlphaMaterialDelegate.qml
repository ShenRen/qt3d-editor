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
import QtQuick 2.4
import com.theqtcompany.SceneEditor3D 1.0

MaterialDelegate {
    id: thisDelegate
    componentType: EditorSceneItemComponentsModel.Material

    Connections {
        target: materialRepeater.model
        onRoleDataChanged: {
            if (roleIndex === EditorSceneItemMaterialComponentsModel.MaterialNormalTextureUrl)
                normalTextureInputField.currentValue = materialNormalTextureUrl
            else if (roleIndex === EditorSceneItemMaterialComponentsModel.MaterialDiffuseTextureUrl)
                diffuseTextureInputField.currentValue = materialDiffuseTextureUrl
        }
    }

    TextureInputField {
        id: normalTextureInputField
        label: qsTr("Normal Map")
        componentType: thisDelegate.componentType
        modelRole: EditorSceneItemMaterialComponentsModel.MaterialNormalTextureUrl
        currentValue: materialNormalTextureUrl
    }

    TextureInputField {
        id: diffuseTextureInputField
        label: qsTr("Diffuse Map")
        componentType: thisDelegate.componentType
        modelRole: EditorSceneItemMaterialComponentsModel.MaterialDiffuseTextureUrl
        currentValue: materialDiffuseTextureUrl
    }

    // TODO: Qt3D is buggy, property change notifications are not coming for QNormalDiffuseMapAlphaMaterial
    // TODO: (See https://bugreports.qt.io/browse/QTBUG-50130)

    ColorPropertyInputField {
        label: qsTr("Ambient Color")
        propertyName: "ambient"
        component: materialComponentData
        componentType: thisDelegate.componentType
    }

    ColorPropertyInputField {
        label: qsTr("Specular Color")
        propertyName: "specular"
        component: materialComponentData
        componentType: thisDelegate.componentType
    }

    FloatPropertyInputField {
        label: qsTr("Shininess")
        propertyName: "shininess"
        component: materialComponentData
        componentType: thisDelegate.componentType
    }

    FloatPropertyInputField {
        label: qsTr("Texture Scale")
        propertyName: "textureScale"
        component: materialComponentData
        componentType: thisDelegate.componentType
    }
}


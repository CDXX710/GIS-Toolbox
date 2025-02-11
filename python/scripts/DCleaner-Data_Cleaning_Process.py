"""
Model exported as python.
Name : DCleaner_Data-Cleaning-Process
Group : 
With QGIS : 33405
"""

import os
from qgis.core import QgsProcessing
from qgis.core import QgsProcessingAlgorithm
from qgis.core import QgsProcessingMultiStepFeedback
from qgis.core import QgsProcessingParameterVectorLayer
from qgis.core import QgsProcessingParameterFeatureSink
import processing

class Dcleaner_datacleaningprocess(QgsProcessingAlgorithm):

    def initAlgorithm(self, config=None):
        self.addParameter(QgsProcessingParameterVectorLayer('input', 'Input', types=[QgsProcessing.TypeVectorAnyGeometry], defaultValue=None))
        self.addParameter(QgsProcessingParameterFeatureSink('Output_datafixclean', 'Output_Data+fix+clean', type=QgsProcessing.TypeVectorAnyGeometry, createByDefault=True, defaultValue=None))
        self.addParameter(QgsProcessingParameterFeatureSink('Output_datafix', 'Output_Data+fix', type=QgsProcessing.TypeVectorAnyGeometry, createByDefault=True, supportsAppend=True, defaultValue=None))

    def processAlgorithm(self, parameters, context, model_feedback):
        feedback = QgsProcessingMultiStepFeedback(2, model_feedback)
        results = {}
        outputs = {}

        # Get input file path and derive output folder
        input_layer = self.parameterAsVectorLayer(parameters, 'input', context)
        input_path = input_layer.dataProvider().dataSourceUri().split('|')[0]
        input_dir = os.path.dirname(input_path)
        input_name = os.path.splitext(os.path.basename(input_path))[0]

        output_fix = os.path.join(input_dir, f"{input_name}_fixed.shp")
        output_fix_clean = os.path.join(input_dir, f"{input_name}_fixed_cleaned.shp")

        # Fix geometries
        alg_params = {
            'INPUT': parameters['input'],
            'METHOD': 0,  # Work line
            'OUTPUT': output_fix
        }
        outputs['FixGeometries'] = processing.run('native:fixgeometries', alg_params, context=context, feedback=feedback, is_child_algorithm=True)
        results['Output_datafix'] = outputs['FixGeometries']['OUTPUT']

        feedback.setCurrentStep(1)
        if feedback.isCanceled():
            return {}

        # Remove duplicate geometries
        alg_params = {
            'INPUT': outputs['FixGeometries']['OUTPUT'],
            'OUTPUT': output_fix_clean
        }
        outputs['RemoveDuplicateGeometries'] = processing.run('native:deleteduplicategeometries', alg_params, context=context, feedback=feedback, is_child_algorithm=True)
        results['Output_datafixclean'] = outputs['RemoveDuplicateGeometries']['OUTPUT']
        
        return results

    def name(self):
        return 'DCleaner_Data-Cleaning-Process'

    def displayName(self):
        return 'DCleaner_Data-Cleaning-Process'

    def group(self):
        return ''

    def groupId(self):
        return ''

    def createInstance(self):
        return Dcleaner_datacleaningprocess()

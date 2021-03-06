/********************************************************************************
 * Copyright (c) 2017, 2018 Bosch Connected Devices and Solutions GmbH.
 *
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * Contributors:
 *    Bosch Connected Devices and Solutions GmbH - initial contribution
 *
 * SPDX-License-Identifier: EPL-2.0
 ********************************************************************************/

/*
 * generated by Xtext 2.10.0
 */
package org.eclipse.mita.program.ui.labeling

import org.eclipse.mita.platform.Connectivity
import org.eclipse.mita.platform.Sensor
import org.eclipse.mita.platform.SystemResourceAlias
import org.eclipse.mita.platform.SystemResourceEvent
import org.eclipse.mita.program.FunctionDefinition
import org.eclipse.mita.program.SignalInstance
import org.eclipse.mita.program.SystemResourceSetup
import org.eclipse.mita.program.TimeIntervalEvent
import org.eclipse.mita.program.VariableDeclaration
import com.google.inject.Inject
import java.net.URL
import org.eclipse.emf.ecore.util.EcoreUtil
import org.eclipse.emf.edit.ui.provider.AdapterFactoryLabelProvider
import org.eclipse.jface.resource.ImageDescriptor
import org.eclipse.xtext.ui.label.DefaultEObjectLabelProvider
import org.yakindu.base.types.Enumerator
import org.yakindu.base.types.Event
import org.yakindu.base.types.Operation
import org.yakindu.base.types.inferrer.ITypeSystemInferrer
import org.yakindu.base.types.inferrer.ITypeSystemInferrer.InferenceResult
import org.eclipse.emf.ecore.EObject

/**
 * Provides labels for EObjects.
 * 
 * See https://www.eclipse.org/Xtext/documentation/304_ide_concepts.html#label-provider
 */
class ProgramDslLabelProvider extends DefaultEObjectLabelProvider {

	@Inject
	ITypeSystemInferrer typeInferrer

	@Inject
	new(AdapterFactoryLabelProvider delegate) {
		super(delegate);
	}
	
	def dispatch Object image(EObject ele) {
		return super.image(ele);
	}
	
	def dispatch image(Connectivity ele) {
		loadImage('connectivity.png');
	}

	def dispatch image(Sensor ele) {
		loadImage('sensor.png');
	}

	def dispatch Object image(SystemResourceAlias ele) {
		return ele.delegate?.image;
	}

	def dispatch Object image(SystemResourceSetup ele) {
		return ele.type?.image;
	}
	
	def dispatch image(VariableDeclaration ele) {
		loadImage('variable.png')
	}
	
	def dispatch image(FunctionDefinition ele) {
		loadImage('function.png')
	}
	
	def dispatch image(Operation ele) {
		loadImage('function.png')
	}
	
	def dispatch image(Enumerator ele) {
		loadImage('enumerator.png')
	}
	
	def dispatch image(Event ele) {
		loadImage('event.png')
	}

	def text(SystemResourceSetup ele) {
		if(ele.type instanceof Connectivity) {
			'''connectivity <b>«ele.name» : «EcoreUtil.getID(ele.type)»</b>'''
		} else {
			'''resource <b>«ele.name» : «EcoreUtil.getID(ele.type)»</b>'''
		}
	}

	def text(TimeIntervalEvent ele) {
		'''time event every «ele.interval.value» «ele.unit.literal»'''
	}
	
	def text(Event ele) {
		val eventType = switch(ele) {
			case SystemResourceEvent: '''system event'''
			default: 'event'
		}
		val source = ele.eContainer
		'''«eventType» «EcoreUtil.getID(source)».«EcoreUtil.getID(ele)»'''
	}

	def text(FunctionDefinition ele) {
		val params = ele.parameters.map[name + " : " + type.name]
		ele.name + "(" + params.toString.replace("[", "").replace("]", "") + ")"
	}
	
	def text(SignalInstance ele) {
		var vci = ele.instanceOf;
		val type = typeInferrer.infer(ele)?.type
		
		'''«IF ele.writeable»read/write«ELSE»read-only«ENDIF» «vci.name» <b>«ele.name» : «type»</b>'''
	}
	
	def text(VariableDeclaration ele) {
		val typeIR = typeInferrer.infer(ele)
		'''«IF ele.writeable»variable«ELSE»constant«ENDIF» <b>«ele.name» : «getText(typeIR)»</b>'''
	}
	
	def text(InferenceResult ir) {
		'''«ir.type.name»«IF ir.bindings.empty === false»&lt;«FOR t: ir.bindings SEPARATOR(", ")»«t.getText()»«ENDFOR»&gt;«ENDIF»'''
	}
	
	override protected convertToString(Object text) {
		if(text instanceof CharSequence) {
			// enables us to use Xtend templates
			return text.toString();
		} else {
			return super.convertToString(text);			
		}
	}

	private def loadImage(String imageName) {
		val bundleIconUrl = 'platform:/plugin/org.eclipse.mita.program.ui/icons/';
		return ImageDescriptor.createFromURL(new URL(bundleIconUrl + imageName));
	}
	
}

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
package org.eclipse.mita.program.ui.quickfix

import org.eclipse.mita.library.^extension.LibraryExtensions
import org.eclipse.mita.program.Program
import org.eclipse.mita.program.ProgramFactory
import org.eclipse.mita.program.SystemResourceSetup
import org.eclipse.mita.program.validation.ProgramImportValidator
import org.eclipse.mita.program.validation.ProgramSetupValidator
import org.eclipse.mita.types.TypesFactory
import org.eclipse.xtext.ui.editor.quickfix.Fix
import org.eclipse.xtext.ui.editor.quickfix.IssueResolutionAcceptor
import org.eclipse.xtext.validation.Issue
import org.yakindu.base.expressions.expressions.ExpressionsFactory
import org.yakindu.base.expressions.ui.quickfix.ExpressionsQuickfixProvider

class ProgramDslQuickfixProvider extends ExpressionsQuickfixProvider {

	@Fix(ProgramImportValidator.MISSING_TARGET_PLATFORM_CODE)
	def addMissingPlatform(Issue issue, IssueResolutionAcceptor acceptor) {
		LibraryExtensions.availablePlatforms.forEach [ platform |
			acceptor.accept(issue, '''Import '«platform.id»' '''.toString,
				'''Add import for platform '«platform.id»' '''.toString, '', [ element, context |
					val program = element as Program
					program.imports += TypesFactory.eINSTANCE.createImportStatement => [
						importedNamespace = platform.id
					]
				])
		]
	}

	@Fix(ProgramSetupValidator.MISSING_CONIGURATION_ITEM_CODE)
	def addMissingConfigItem(Issue issue, IssueResolutionAcceptor acceptor) {
		acceptor.accept(issue, 'Add config item', 'Add missing configuration item', '', [ element, context |

			val setup = element as SystemResourceSetup
			setup.type.configurationItems
			.filter[required] // item is mandatory
			.filter[!setup.configurationItemValues.map[c|c.item].contains(it)] // item is not contained in setup
			.forEach [ missingItem | // create dummy value
				val dummyExpression = ExpressionsFactory.eINSTANCE.createPrimitiveValueExpression => [
					value = ExpressionsFactory.eINSTANCE.createStringLiteral => [
						value = 'replace_me'
					]
				]
				val newConfigItemValue = ProgramFactory.eINSTANCE.createConfigurationItemValue => [
					it.value = dummyExpression
					it.item = missingItem
				]
				setup.configurationItemValues.add(newConfigItemValue)
			]
		])
	}

}

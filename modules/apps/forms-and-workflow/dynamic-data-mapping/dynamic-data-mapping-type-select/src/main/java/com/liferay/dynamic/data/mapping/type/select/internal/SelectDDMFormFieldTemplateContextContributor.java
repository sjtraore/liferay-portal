/**
 * Copyright (c) 2000-present Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */

package com.liferay.dynamic.data.mapping.type.select.internal;

import com.liferay.dynamic.data.mapping.form.field.type.DDMFormFieldTemplateContextContributor;
import com.liferay.dynamic.data.mapping.model.DDMFormField;
import com.liferay.dynamic.data.mapping.model.DDMFormFieldOptions;
import com.liferay.dynamic.data.mapping.render.DDMFormFieldRenderingContext;
import com.liferay.portal.kernel.json.JSONFactory;
import com.liferay.portal.kernel.language.LanguageUtil;
import com.liferay.portal.kernel.util.GetterUtil;
import com.liferay.portal.kernel.util.ResourceBundleUtil;
import com.liferay.portal.kernel.util.StringPool;

import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Objects;
import java.util.ResourceBundle;

import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;

/**
 * @author Marcellus Tavares
 */
@Component(
	immediate = true, property = "ddm.form.field.type.name=select",
	service = {
		SelectDDMFormFieldTemplateContextContributor.class,
		DDMFormFieldTemplateContextContributor.class
	}
)
public class SelectDDMFormFieldTemplateContextContributor
	implements DDMFormFieldTemplateContextContributor {

	public Map<String, Object> getParameters(
		DDMFormField ddmFormField,
		DDMFormFieldRenderingContext ddmFormFieldRenderingContext) {

		Map<String, Object> parameters = new HashMap<>();

		parameters.put(
			"multiple",
			ddmFormField.isMultiple() ? "multiple" : StringPool.BLANK);
		parameters.put(
			"options", getOptions(ddmFormField, ddmFormFieldRenderingContext));

		Map<String, String> stringsMap = new HashMap<>();

		ResourceBundle resourceBundle = getResourceBundle(
			ddmFormFieldRenderingContext.getLocale());

		stringsMap.put(
			"chooseAnOption",
			LanguageUtil.get(resourceBundle, "choose-an-option"));

		parameters.put("strings", stringsMap);
		parameters.put("value", ddmFormFieldRenderingContext.getValue());

		return parameters;
	}

	protected DDMFormFieldOptions getDDMFormFieldOptions(
		DDMFormField ddmFormField) {

		String dataSourceType = GetterUtil.getString(
			ddmFormField.getProperty("dataSourceType"), "manual");

		if (Objects.equals(dataSourceType, "manual")) {
			return ddmFormField.getDDMFormFieldOptions();
		}

		return new DDMFormFieldOptions();
	}

	protected List<Object> getOptions(
		DDMFormField ddmFormField,
		DDMFormFieldRenderingContext ddmFormFieldRenderingContext) {

		SelectDDMFormFieldContextHelper selectDDMFormFieldContextHelper =
			new SelectDDMFormFieldContextHelper(
				jsonFactory, getDDMFormFieldOptions(ddmFormField),
				ddmFormFieldRenderingContext.getValue(),
				ddmFormField.getPredefinedValue(),
				ddmFormFieldRenderingContext.getLocale());

		return selectDDMFormFieldContextHelper.getOptions();
	}

	protected ResourceBundle getResourceBundle(Locale locale) {
		Class<?> clazz = getClass();

		return ResourceBundleUtil.getBundle(
			"content.Language", locale, clazz.getClassLoader());
	}

	@Reference
	protected JSONFactory jsonFactory;

}
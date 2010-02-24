<%
/**
 * Copyright (c) 2000-2010 Liferay, Inc. All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
%>

<%@ include file="/html/portlet/blogs/init.jsp" %>

<%
String redirect = (String)request.getAttribute("view_entry_content.jsp-redirect");

BlogsEntry entry = (BlogsEntry)request.getAttribute("view_entry_content.jsp-entry");

AssetEntry assetEntry = (AssetEntry)request.getAttribute("view_entry_content.jsp-assetEntry");
%>

<c:if test="<%= BlogsEntryPermission.contains(permissionChecker, entry, ActionKeys.VIEW) && ((entry.getStatus() == StatusConstants.APPROVED) || BlogsEntryPermission.contains(permissionChecker, entry, ActionKeys.UPDATE)) %>">
	<div class="entry <%= (entry.getStatus() == StatusConstants.APPROVED) ? "" : "draft" %>">
		<div class="entry-content">

			<%
			String strutsAction = ParamUtil.getString(request, "struts_action");
			%>

			<c:if test="<%= (entry.getStatus() == StatusConstants.DRAFT) %>">
				<h3>
					<liferay-ui:message key="draft" />
				</h3>
			</c:if>

			<portlet:renderURL var="viewEntryURL">
				<portlet:param name="struts_action" value="/blogs/view_entry" />
				<portlet:param name="redirect" value="<%= currentURL %>" />
				<portlet:param name="urlTitle" value="<%= entry.getUrlTitle() %>" />
			</portlet:renderURL>

			<c:if test='<%= strutsAction.equals("/blogs/view_entry") %>'>
				<portlet:renderURL var="blogsURL">
					<portlet:param name="struts_action" value="/blogs/view" />
				</portlet:renderURL>
			</c:if>

			<div class="entry-title">
				<c:choose>
					<c:when test='<%= strutsAction.equals("/blogs/view_entry") %>'>
						<%= HtmlUtil.escape(entry.getTitle()) %>
					</c:when>
					<c:otherwise>
						<aui:a href="<%= viewEntryURL %>"><%= HtmlUtil.escape(entry.getTitle()) %></aui:a>
					</c:otherwise>
				</c:choose>
			</div>

			<div class="entry-date">
				<%= dateFormatDateTime.format(entry.getDisplayDate()) %>
			</div>
		</div>

		<c:if test="<%= BlogsEntryPermission.contains(permissionChecker, entry, ActionKeys.DELETE) || BlogsEntryPermission.contains(permissionChecker, entry, ActionKeys.PERMISSIONS) || BlogsEntryPermission.contains(permissionChecker, entry, ActionKeys.UPDATE) %>">
			<div class="lfr-meta-actions edit-actions entry">
				<table class="lfr-table">
				<tr>
					<c:if test="<%= BlogsEntryPermission.contains(permissionChecker, entry, ActionKeys.UPDATE) %>">
						<td>
							<portlet:renderURL var="editEntryURL">
								<portlet:param name="struts_action" value="/blogs/edit_entry" />
								<portlet:param name="redirect" value="<%= currentURL %>" />
								<portlet:param name="entryId" value="<%= String.valueOf(entry.getEntryId()) %>" />
							</portlet:renderURL>

							<liferay-ui:icon image="edit" url="<%= editEntryURL %>" label="<%= true %>" />
						</td>
					</c:if>

					<c:if test="<%= showEditEntryPermissions && BlogsEntryPermission.contains(permissionChecker, entry, ActionKeys.PERMISSIONS) %>">
						<td>
							<liferay-security:permissionsURL
								modelResource="<%= BlogsEntry.class.getName() %>"
								modelResourceDescription="<%= entry.getTitle() %>"
								resourcePrimKey="<%= String.valueOf(entry.getEntryId()) %>"
								var="permissionsEntryURL"
							/>

							<liferay-ui:icon image="permissions" url="<%= permissionsEntryURL %>" label="<%= true %>" />
						</td>
					</c:if>

					<c:if test="<%= BlogsEntryPermission.contains(permissionChecker, entry, ActionKeys.DELETE) %>">
						<td>
							<portlet:actionURL var="deleteEntryURL">
								<portlet:param name="struts_action" value="/blogs/edit_entry" />
								<portlet:param name="<%= Constants.CMD %>" value="<%= Constants.DELETE %>" />
								<portlet:param name="redirect" value="<%= redirect %>" />
								<portlet:param name="entryId" value="<%= String.valueOf(entry.getEntryId()) %>" />
							</portlet:actionURL>

							<liferay-ui:icon-delete url="<%= deleteEntryURL %>" label="<%= true %>" />
						</td>
					</c:if>
				</tr>
				</table>
			</div>
		</c:if>

		<div class="entry-body">
			<c:choose>
				<c:when test="<%= pageDisplayStyle.equals(RSSUtil.DISPLAY_STYLE_ABSTRACT) %>">
					<%= StringUtil.shorten(HtmlUtil.stripHtml(entry.getContent()), pageAbstractLength) %>

					<br />

					 <aui:a href="<%= viewEntryURL %>"><liferay-ui:message arguments='<%= new Object[] {"aui-helper-hidden-accessible", entry.getTitle()} %>' key="read-more-x-about-x" /> &raquo;</aui:a>
				</c:when>
				<c:when test="<%= pageDisplayStyle.equals(RSSUtil.DISPLAY_STYLE_FULL_CONTENT) %>">
					<%= entry.getContent() %>

					<liferay-ui:custom-attributes-available className="<%= BlogsEntry.class.getName() %>">
						<div class="custom-attributes">
							<liferay-ui:custom-attribute-list
								className="<%= BlogsEntry.class.getName() %>"
								classPK="<%= (entry != null) ? entry.getEntryId() : 0 %>"
								editable="<%= false %>"
								label="<%= true %>"
							/>
						</div>
					</liferay-ui:custom-attributes-available>
				</c:when>
				<c:when test="<%= pageDisplayStyle.equals(RSSUtil.DISPLAY_STYLE_TITLE) %>">
					<aui:a href="<%= viewEntryURL %>"><liferay-ui:message arguments='<%= new Object[] {"aui-helper-hidden-accessible", entry.getTitle()} %>' key="read-more-x-about-x" /> &raquo;</aui:a>
				</c:when>
			</c:choose>
		</div>

		<portlet:renderURL windowState="<%= WindowState.NORMAL.toString() %>" var="bookmarkURL">
			<portlet:param name="struts_action" value="/blogs/view_entry" />
			<portlet:param name="urlTitle" value="<%= entry.getUrlTitle() %>" />
		</portlet:renderURL>

		<div class="entry-footer">
			<div class="entry-author">
				<liferay-ui:message key="written-by" /> <%= HtmlUtil.escape(PortalUtil.getUserName(entry.getUserId(), entry.getUserName())) %>
			</div>

			<div class="stats">
				<span class="view-count">
					<c:choose>
						<c:when test="<%= assetEntry.getViewCount() == 1 %>">
							<%= assetEntry.getViewCount() %> <liferay-ui:message key="view" />,
						</c:when>
						<c:when test="<%= assetEntry.getViewCount() > 1 %>">
							<%= assetEntry.getViewCount() %> <liferay-ui:message key="views" />,
						</c:when>
					</c:choose>
				</span>

				<c:if test="<%= enableComments %>">
					<span class="comments">

						<%
						long classNameId = PortalUtil.getClassNameId(BlogsEntry.class.getName());

						int messagesCount = MBMessageLocalServiceUtil.getDiscussionMessagesCount(classNameId, entry.getEntryId(), StatusConstants.APPROVED);
						%>

						<c:choose>
							<c:when test='<%= strutsAction.equals("/blogs/view_entry") %>'>
								<%= messagesCount %> <liferay-ui:message key="comments" />
							</c:when>
							<c:otherwise>
								<aui:a href='<%= viewEntryURL + StringPool.POUND + renderResponse.getNamespace() + "messageScroll0" %>'><%= messagesCount %> <liferay-ui:message key="comments" /></aui:a>
							</c:otherwise>
						</c:choose>
					</span>
				</c:if>
			</div>

			<c:if test="<%= enableFlags %>">
				<liferay-ui:flags
					className="<%= BlogsEntry.class.getName() %>"
					classPK="<%= entry.getEntryId() %>"
					contentTitle="<%= entry.getTitle() %>"
					reportedUserId="<%= entry.getUserId() %>"
				/>
			</c:if>

			<span class="entry-categories">
				<liferay-ui:asset-categories-summary
					className="<%= BlogsEntry.class.getName() %>"
					classPK="<%= entry.getEntryId() %>"
					portletURL="<%= renderResponse.createRenderURL() %>"
				/>
			</span>

			<span class="entry-tags">
				<liferay-ui:asset-tags-summary
					className="<%= BlogsEntry.class.getName() %>"
					classPK="<%= entry.getEntryId() %>"
					portletURL="<%= renderResponse.createRenderURL() %>"
				/>
			</span>

			<c:if test="<%= !pageDisplayStyle.equals(RSSUtil.DISPLAY_STYLE_ABSTRACT) %>">
				<liferay-ui:social-bookmarks
					url="<%= bookmarkURL.toString() %>"
					title="<%= entry.getTitle() %>"
					target="_blank"
				/>

				<c:if test="<%= enableRatings %>">
					<liferay-ui:ratings
						className="<%= BlogsEntry.class.getName() %>"
						classPK="<%= entry.getEntryId() %>"
					/>
				</c:if>
			</c:if>
		</div>
	</div>
</c:if>
package com.yoo;

import com.opensymphony.xwork2.ActionSupport;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.struts2.interceptor.ServletRequestAware;
import org.apache.struts2.interceptor.ServletResponseAware;
import org.apache.struts2.interceptor.SessionAware;

/**
 * Base Action class for the Tutorial package.
 */
public class BaseSupport extends ActionSupport implements SessionAware,
ServletRequestAware, ServletResponseAware {
	protected Map sessionMap;
	protected HttpServletRequest request;
	protected HttpServletResponse response;

	public void setServletRequest(HttpServletRequest request) {
		this.request = request;
	}

	public void setServletResponse(HttpServletResponse response) {
		this.response = response;
	}

	public void setSession(Map map) {
		this.sessionMap = map;
	}

	public HttpServletRequest getHttpServletRequest() {
		return request;
	}

	public HttpServletResponse getHttpServletResponse() {
		return response;
	}

	public Map getSession() {
		return sessionMap;
	}
}

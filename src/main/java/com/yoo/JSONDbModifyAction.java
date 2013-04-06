package com.yoo;

import com.yoo.jdbc.DBConnection;

public class JSONDbModifyAction extends BaseSupport {
	private String msg;

	public String execute() throws Exception {
		String conn2_url = request.getParameter("connUrl2");
		String sqlExec = request.getParameter("sqlExec");
		DBConnection dbconn = new DBConnection();
		boolean r = dbconn.executeSql(conn2_url, sqlExec);
		
		setMsg("success");

		return SUCCESS;
	}

	public String getMsg() {
		return msg;
	}

	public void setMsg(String msg) {
		this.msg = msg;
	}
}

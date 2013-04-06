package com.yoo;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import com.yoo.jdbc.DBConnection;


/**
 * <code>Set welcome message.</code>
 */
public class IndexAction extends BaseSupport {

	private String connUrl1;
	private String connUrl2;
    private List[] Tables = null;
    
    public String execute() throws Exception {
        return SUCCESS;
    }
    
    /**
     * 执行比较
     * @return
     * @throws Exception
     */
    public String dbmanager() throws Exception {
    	DBConnection dbconn = new DBConnection();
    	Set allTableSet = new HashSet();
    	Set table1Set = new HashSet();
    	Set allColumnSet = new HashSet();
    	Set table1ColumnSet = new HashSet();
    	List table2Sup = new ArrayList(); //数据库2多出的表,待删除
    	List table2ColumnSup = new ArrayList(); //数据库2多出的表字段,待删除
    	List table2Sub = new ArrayList(); //数据库2缺少的表,待添加
    	List table2ColumnSub = new ArrayList(); //数据库2缺少表字段,待添加
    	
    	//表1全部内容
		List db1List = dbconn.getAllTables(connUrl1);
		List db2List = dbconn.getAllTables(connUrl2);
		
		if(db1List==null || db2List==null){
			String errorMsg = "数据库";
			if(db1List==null)
				errorMsg += "1，";
			if(db2List==null)
				errorMsg += "2";
			errorMsg += "连接错误！";
			request.setAttribute("errorMsg", errorMsg);
			
			return INPUT;
		}
		
		for(int i=0; i<db1List.size(); i++){
			Map m =  (Map) db1List.get(i);
			List list = dbconn.getTablecolumn(connUrl1, m.get("tableName").toString());
			for(int i1=0; i1<list.size(); i1++){
				String[] columns = (String[]) list.get(i1);
				String tableColStr = getOneTableColumnStr(m.get("tableName").toString(), columns);
				allColumnSet.add(tableColStr);
			}
			m.put("tablecolumn", list);
			
			allTableSet.add(m.get("tableName"));
		}
		
		//表2全部内容
		for(int i=0; i<db2List.size(); i++){
			Map m =  (Map) db2List.get(i);
			List list = dbconn.getTablecolumn(connUrl2, m.get("tableName").toString());
			for(int i1=0; i1<list.size(); i1++){
				String[] columns = (String[]) list.get(i1);
				String tableColStr = getOneTableColumnStr(m.get("tableName").toString(), columns);
				if(allColumnSet.add(tableColStr)){ //数据库2加标识属性（字段）——比源数据库多的字段（结合表作标识）
					table2ColumnSup.add(tableColStr);
					columns[5] = "y";
				}
				table1ColumnSet.add(tableColStr);
			}
			m.put("tablecolumn", list);
			if(allTableSet.add(m.get("tableName"))){ //数据库2加标识属性（表）——比源数据库多的表
				m.put("sup", "y");
				table2Sup.add(m.get("tableName"));
			}
			
			table1Set.add(m.get("tableName"));
		}
		
		
		/**
		 * 表1加标识属性（表）
		 */
		List temp = getSupData(allTableSet.toArray(), table1Set.toArray());
		for(int i=0; i<db1List.size(); i++){
			Map m =  (Map) db1List.get(i);
			for(int j=0; j<temp.size(); j++){
				String tableNameTem = (String) temp.get(j);
				if(m.get("tableName").equals(tableNameTem)){
					m.put("sup", "y");
					String[] showTableFromT1 = (String[]) dbconn.getShowCreateTable(connUrl1, tableNameTem);
					table2Sub.add(showTableFromT1);
				}
			}
		}
		

		/**
		 * 表1加标识属性（字段）
		 */
		List temp1 = getSupData(allColumnSet.toArray(), table1ColumnSet.toArray());
		
		for(int i=0; i<db1List.size(); i++){
			Map m =  (Map) db1List.get(i);
			List list = (List) m.get("tablecolumn");
			for(int ii=0; ii<list.size(); ii++){
				String[] columns = (String[]) list.get(ii);
				for(int j=0; j<temp1.size(); j++){
					String s = (String) temp1.get(j);
					String tableColStr = getOneTableColumnStr(m.get("tableName").toString(), columns);
					
					if(tableColStr.equals(s)){
						columns[5] = "y";
						table2ColumnSub.add(tableColStr);
					}
				}
			}
		}
		
		/*
		//按list内map第一项排序
		Collections.sort(db1List, new Comparator<Map>() {
			public int compare(Map o1, Map o2) {
				return o1.get("tableName").toString().compareTo(o2.get("tableName").toString());
			}
		});
		*/
		
		//数据库1，数据库2拼入数组
		List[] list = new List[2];
		list[0] = db1List;
		list[1] = db2List;
		this.setTables(list);
		
		//删除包括在待删除表内的添加语句
		List table2ColumnSup2 = new ArrayList();
		if(table2Sup.size()>0){
			for(int i=0; i<table2Sup.size(); i++){
				String table2SupStr = (String) table2Sup.get(i);
				for(int j=0; j<table2ColumnSup.size(); j++){
					if(table2SupStr.length()>table2ColumnSup.get(j).toString().length() || !table2SupStr.equals(table2ColumnSup.get(j).toString().substring(0, table2SupStr.length()))){
						table2ColumnSup2.add(table2ColumnSup.get(j).toString());
					}
				}
			}
		}else{
			table2ColumnSup2.addAll(table2ColumnSup);
		}
		
		List table2ColumnSub2 = new ArrayList();
		if(table2Sub.size()>0){
			for(int i=0; i<table2Sub.size(); i++){
				String[] table2SubStr = (String[]) table2Sub.get(i);
				for(int j=0; j<table2ColumnSub.size(); j++){
					if(table2SubStr[0].length()>table2ColumnSub.get(j).toString().length() || !table2SubStr[0].equals(table2ColumnSub.get(j).toString().substring(0, table2SubStr[0].length()))){
						table2ColumnSub2.add(table2ColumnSub.get(j).toString());
					}
				}
			}
		}else{
			table2ColumnSub2.addAll(table2ColumnSub);
		}
		
		request.setAttribute("table2Sup", table2Sup);
		request.setAttribute("table2Sub", table2Sub);
		request.setAttribute("table2ColumnSup", table2ColumnSup2);
		request.setAttribute("table2ColumnSub", table2ColumnSub2);
		
    	return "dbmanager";
    }
    
    //获取数组1比数组2多出的元素
	public static List getSupData(Object[] arrAll, Object[] arrPart) {
		List temp = new ArrayList();
		for(int i=0; i<arrAll.length; i++){
			boolean flag = false;
			for(int j=0; j<arrPart.length; j++){
				if(arrAll[i].equals(arrPart[j])){
					flag = true;
                    break;
				}else{
					flag = false;
				}
			}
			if(!flag) {
                temp.add(arrAll[i]);
            }
		}
		
		return temp;
	}
    
	/**
	 * 以“表名”+“列名”+“所有属性（自动增加除外，此项作标识所用）”唯一标识表字段
	 * @param tableName
	 * @param columns
	 * @return
	 */
	public static String getOneTableColumnStr(String tableName, String[] columns){
		String tableColStr = tableName;
		for(int i=0; i<columns.length;i++){
			tableColStr += ":"+columns[i];
		}
		return tableColStr;
	}

	public List[] getTables() {
		return Tables;
	}

	public void setTables(List[] tables) {
		Tables = tables;
	}

	public String getConnUrl1() {
		return connUrl1;
	}

	public void setConnUrl1(String connUrl1) {
		this.connUrl1 = connUrl1;
	}

	public String getConnUrl2() {
		return connUrl2;
	}

	public void setConnUrl2(String connUrl2) {
		this.connUrl2 = connUrl2;
	}
}

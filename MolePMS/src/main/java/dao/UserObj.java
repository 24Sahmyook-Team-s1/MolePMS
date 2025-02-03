package dao;

public class UserObj {
	private String id, name, pwd, createDate;

	public UserObj(String id, String name, String pwd, String createDate) {
		this.id = id;
		this.name = name;
		this.pwd = pwd;
		this.createDate = createDate;
	}

	public String getId() {
		return this.id;
	}

	public String getName() {
		return this.name;
	}

	public String getPWD() {
		return this.pwd;
	}

	public String getcreateDate() {
		return this.createDate;
	}
}
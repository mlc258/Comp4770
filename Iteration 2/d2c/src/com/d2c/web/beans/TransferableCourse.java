package com.d2c.web.beans;

import java.util.List;

public class TransferableCourse {
	public String courseNumber;
	public List<TransferableStudent> classList;
	public List<TransferableAssignment> assignments;
	public String subject;
	public String courseName;
	public List<TransferableTA> teachingAssistants;
}

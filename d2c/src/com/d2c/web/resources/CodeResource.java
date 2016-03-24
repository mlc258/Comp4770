package com.d2c.web.resources;

import java.io.BufferedReader;
//import java.io.BufferedWriter; //Uncomment later when we figure out the stream problem
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.ws.rs.Consumes;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import com.d2c.util.IOPipe;
import com.d2c.util.TerminalCaller;

@Path("/code/{user}/{path}")
public class CodeResource {

	@POST
	@Consumes(MediaType.APPLICATION_JSON)
	public Response saveFile(@PathParam("user") String user, @PathParam("path") String path, Map<String, String> code){
		try{
			for(String name : code.keySet()){
				TerminalCaller.saveFile(user, path, name, code.get(name));
			}
			return Response.accepted().build();
		} catch (IOException e){
			e.printStackTrace();
			return Response.serverError().build();
		}
	}
	
	@POST
	@Path("/c")
	@Consumes(MediaType.APPLICATION_JSON)
	@Produces(MediaType.TEXT_PLAIN)
	public Response compileCCode(@PathParam("user") String user, @PathParam("path") String path, Map<String, String> code) {
		String proper_path = path.replace('_', '/');
		try {
			ArrayList<String> args = new ArrayList<>();
			IOPipe pipe;
			String output = "";
			for (String name : code.keySet()) {
				TerminalCaller.saveFile(user, proper_path, name + ".c", code.get(name));
				pipe = TerminalCaller.gcc(user, proper_path, stringToList("-c " + name + ".c"));
				args.add(name + ".o");
				// BufferedWriter bw = pipe.getInput();
				BufferedReader br = pipe.getReader();
				output += stringContentsOfBuffer(br);
				pipe.close();
			}
			args.add("-o");
			args.add("a.out");
			pipe = TerminalCaller.gcc(user, proper_path, args);
			BufferedReader br = pipe.getReader();
			output += stringContentsOfBuffer(br);
			pipe.close();
			if(output.trim().equals("")){
				output = "Compilation Successful!";
			}
			System.out.println("returning ok response: "+ output);
			// TerminalCaller.clearTempUserFiles(user, proper_path);
			return Response.ok().entity(output).build();
		} catch (IOException e) {
			// TerminalCaller.clearTempUserFiles(user, proper_path);
			return serverError("returning server error response from IOException", "Error handling files", e);
		} catch (InterruptedException e) {
			// TerminalCaller.clearTempUserFiles(user, proper_path);
			return serverError("returning server error response from InterruptedException", "Error waiting for process", e);
		}
	}

	@POST
	@Path("/javac")
	@Consumes(MediaType.APPLICATION_JSON)
	@Produces(MediaType.TEXT_PLAIN)
	public Response compileJavaCode(@PathParam("user") String user, @PathParam("path") String path, Map<String, String> code) {
		String proper_path = path.replace('_', '/');
		try {
			IOPipe pipe;
			String output = "";
			for (String name : code.keySet()) {
				TerminalCaller.saveFile(user, proper_path, name + ".java", code.get(name));
				pipe = TerminalCaller.javac(user, proper_path, stringToList(name + ".java"));
				// BufferedWriter bw = pipe.getInput();
				BufferedReader br = pipe.getReader();
				output += stringContentsOfBuffer(br);
			}
			if(output.trim().equals("")){
				output = "Compilation Successful!";
			}
			// TerminalCaller.clearTempUserFiles(user, proper_path);
			return Response.ok().entity(output).build();
		} catch (IOException e) {
			// TerminalCaller.clearTempUserFiles(user, proper_path);
			return serverError("returning server error response from IOException", "Error handling files", e);
		} catch (InterruptedException e) {
			// TerminalCaller.clearTempUserFiles(user, proper_path);
			return serverError("returning server error response from InterruptedException", "Error waiting for process", e);
		}
	}

	@POST
	@Path("/java")
	@Consumes(MediaType.APPLICATION_JSON)
	@Produces(MediaType.TEXT_PLAIN)
	public Response runJavaClass(@PathParam("user") String user, @PathParam("path") String path, Map<String, String> code) {
		String proper_path = path.replace('_', '/');
		try {
			ArrayList<String> args = new ArrayList<>();
			IOPipe pipe;
			String output = "";
			args.add(code.keySet().iterator().next());
			pipe = TerminalCaller.java(user, proper_path, args);
			BufferedReader br = pipe.getReader();
			output += stringContentsOfBuffer(br);
			System.out.println("returning ok response with content: " + output);
			// TerminalCaller.clearTempUserFiles(user, proper_path);
			return Response.ok().entity(output).build();
		} catch (IOException e) {
			// TerminalCaller.clearTempUserFiles(user, proper_path);
			return serverError("returning server error response from IOException", "Error handling files", e);
		} catch (InterruptedException e) {
			// TerminalCaller.clearTempUserFiles(user, proper_path);
			return serverError("returning server error response from InterruptedException", "Error waiting for process", e);
		}
	}

	@POST
	@Path("/out")
	@Consumes(MediaType.APPLICATION_JSON)
	@Produces(MediaType.TEXT_PLAIN)
	public Response runCompiledClass(@PathParam("user") String user, @PathParam("path") String path, Map<String, String> code) {
		String proper_path = path.replace('_', '/');
		try {
			ArrayList<String> args = new ArrayList<>();
			IOPipe pipe;
			String output = "";
			pipe = TerminalCaller.aout(user, proper_path, args);
			BufferedReader br = pipe.getReader();
			output = stringContentsOfBuffer(br);
			pipe.close();
			System.out.println("returning ok response");
			// TerminalCaller.clearTempUserFiles(user, proper_path);
			return Response.ok().entity(output).build();
		} catch (IOException e) {
			// TerminalCaller.clearTempUserFiles(user, proper_path);
			return serverError("returning server error response from IOException", "Error handling files", e);
		} catch (InterruptedException e) {
			// TerminalCaller.clearTempUserFiles(user, proper_path);
			return serverError("returning server error response from InterruptedException", "Error waiting for process", e);
		}
	}

	private List<String> stringToList(String args) {
		String[] asArray = args.split(" ");
		ArrayList<String> asArrayList = new ArrayList<>();
		for (String a : asArray) {
			asArrayList.add(a);
		}
		return asArrayList;
	}

	private String stringContentsOfBuffer(BufferedReader br) throws IOException {
		String line;
		String output = "";
		while ((line = br.readLine()) != null) {
			output += line + "\n";
		}
		return output;
	}

	private void logError(String console, Exception e) {
		System.out.println(console);
		System.out.println(e.getMessage());
	}

	private Response serverError(String console, String client, Exception e) {
		logError(console, e);
		return Response.serverError().entity(client).build();
	}
}

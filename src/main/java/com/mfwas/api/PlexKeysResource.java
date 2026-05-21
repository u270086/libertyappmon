package com.mfwas.api;

import com.mfwas.CSVReader;
import javax.ws.rs.*;
import javax.ws.rs.core.*;
import java.util.*;

@Path("/plexKeys")
public class PlexKeysResource {

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public Response getPlexKeys() {
        System.out.println("[PlexKeysResource] Endpoint hit");
        CSVReader reader = new CSVReader();
        Set<String> keys = reader.getAvailablePlexKeys();
        return Response.ok(keys).build();
    }
}
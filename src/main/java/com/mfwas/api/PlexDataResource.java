package com.mfwas.api;

import com.mfwas.CSVReader;
import javax.ws.rs.*;
import javax.ws.rs.core.*;
import java.io.IOException;
import java.util.*;

@Path("/plexData")
public class PlexDataResource {

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public Response getPlexData(@QueryParam("plex") String plex) {
        CSVReader reader = new CSVReader();
        Map<String, List<Map<String, String>>> allData;
        List<Map<String, String>> result = new ArrayList<>();

        try {
            allData = reader.readCSVFiles();

            if (plex != null && !plex.isEmpty() && allData.containsKey(plex)) {
                result = allData.get(plex);
            } else {
                // Return ALL rows if no plex specified
                for (List<Map<String, String>> rows : allData.values()) {
                    result.addAll(rows);
                }
            }

            return Response.ok(result).build();

        } catch (IOException e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                           .entity(Collections.singletonMap("error", e.getMessage()))
                           .build();
        }
    }
}
package com.mfwas;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import java.security.Provider;
import java.security.Security;
import javax.net.ssl.SSLContext;

@WebListener
public class StartupListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        // Output platform information
        String osName = System.getProperty("os.name");
        String osVersion = System.getProperty("os.version");
        String osArch = System.getProperty("os.arch");
        System.out.println("=== Application starting on platform: " 
            + osName + " " + osVersion + " (" + osArch + ") ===");

        // Output JSSE provider information
        try {
            SSLContext ctx = SSLContext.getDefault();
            Provider provider = ctx.getProvider();
            System.out.println("=== Default SSLContext provider: " 
                + provider.getName() + " - " + provider.getInfo() + " ===");
        } catch (Exception e) {
            System.out.println("Could not determine JSSE provider: " + e.getMessage());
        }

        // List all registered providers that contain JSSE
        for (Provider provider : Security.getProviders()) {
            if (provider.getName().toUpperCase().contains("JSSE")) {
                System.out.println("JSSE Provider available: " 
                    + provider.getName() + " - " + provider.getInfo());
            }
        }
    }
    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // Optional cleanup logic
        System.out.println("=== Application shutting down ===");
    }
}
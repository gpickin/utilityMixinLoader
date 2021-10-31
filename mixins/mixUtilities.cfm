<cffunction name="mixUtils">
    <cfscript>
        var wirebox = application.injector;
        return wirebox.getInstance( "loader@utilityMixinLoader" ).mixUtils;
    </cfscript>
</cffunction>

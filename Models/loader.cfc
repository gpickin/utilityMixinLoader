component singleton {
    
    property name="defaultSettings" inject="coldbox:setting:defaultSettings@utilityMixinLoader";
	property name="libaryFunctions" inject="coldbox:setting:functions@utilityMixinLoader";
	property name="libraryGroups" inject="coldbox:setting:groups@utilityMixinLoader";
    
    /**
	* Mix Utils function mixes a series of utility functions into a scope passed into the function
	*
	* @vScope The variables scope or other scope to inject the utility functions into
	* @groupIncludes The groups of utilities to include. This is in addition to the core setting defaultGroupIncludes, unless the ignoreDefaults is set to true
	* @includes The a la carte list of utilities to include. This is in addition to the core setting defaultIncludes, unless the ignoreDefaults is set to true
	* @excludes A list of utilities to exclude from the current list of included utilities. This is in addition to the core setting defaultExcludes, unless the ignoreDefaults is set to true
	* @ignoreDefaults A flag to determine if all of the defaults should be ignored, creating a clean slate to add groupIncludes, includes and excludes to. 
	*
	*/
    function mixUtils( vScope, groupIncludes="", includes="", excludes="", ignoreDefaults=false ){
		var arrayOfFunctions = buildUtilitiesToInclude( groupIncludes, includes, excludes );
		for( var func in arrayOfFunctions ){
			if( !structKeyExists( vScope, func.name  ) ){
				vScope[ func.name ] = wirebox.getInstance( func.wireboxRef )[ func.wireboxFunction ];
			}
		}
	}


	/**
	*
	*
	*/
	private function buildUtilitiesToInclude( groupIncludes="", includes="", excludes="", ignoreDefaults=false ){
		var includeCriteria = mergeCriteria( argumentCollection=arguments );
		var utilsToMix = includeGroups( libaryFunctions, includeCriteria.groupIncludes);
		utilsToMix = appendArray( utilsToMix, includeAlLaCarte( libaryFunctions, includeCriteria.includes ), true );
		utilsToMix = removeExcludes( utilsToMix, includeCriteria.excludes );
		// Filter out exclude items and never include items
		utilsToMix = removeExcludes( utilsToMix, isNull( defaultSettings.neverInclude ) ? [] : defaultSettings.neverInclude );
		return utilsToMix;
	}

	private function mergeCriteria( groupIncludes="", includes="", excludes="", ignoreDefaults=false ){
		var includeCriteria = {
			groupIncludes = listToArray( arguments.groupIncludes ),
			includes = listToArray( arguments.includes ),
			excludes = listToArray( arguments.excludes )
		}
		
		// Param Default Include Criteria
		// We do it here, because ACF caches crap!
		var defaultCriteria = {
			"defaultGroupIncludes" : isNull( defaultSettings.defaultGroupIncludes ) ? [] : defaultSettings.defaultGroupIncludes,
			"defaultIncludes" : isNull( defaultSettings.defaultIncludes ) ? [] : defaultSettings.defaultIncludes,
			"defaultExcludes" : isNull( defaultSettings.defaultExcludes ) ? [] : defaultSettings.defaultExcludes,
			
		};

		// Incorporate Defaults if not ignored
		if ( !arguments.ignoreDefaults ) {
			includeCriteria.groupIncludes.append( defaultCriteria.defaultGroupIncludes, true );
			includeCriteria.includes.append( defaultCriteria.defaultIncludes, true );
			includeCriteria.excludes.append(
				defaultCriteria.defaultExcludes.filter( function( item ){
					// Filter out if incoming includes was specified
					return !includes.findNoCase( arguments.item );
				} ),
				true
			);
		}

	}

	private function includeGroups( required utilsToMix, groupIncludes="" ){
		if( !isArray( excludes ) ){
			arguments.excludes = listToArray( arguments.excludes );	
		}
		for( var item in arguments.excludes ){
			if( structKeyExists( libaryGroups, item ) ){
				utilsToMix = includeALaCarte( utilsToMix, libaryGroups[ item ];
			}
		}
		return utilsToMix;
	}

	private function includeALaCarte( required utilsToMix, includes ){
		if( !isArray( excludes ) ){
			arguments.excludes = listToArray( arguments.excludes );	
		}
		for( var item in arguments.excludes ){
			if( structKeyExists( libaryFunctions, item ) ){
				utilsToMix[ item ] = libaryFunctions[ item ];
			}
		}
		return utilsToMix;
	}

	private function removeExcludes( required utilsToMix, excludes="" ){
		if( !isArray( excludes ) ){
			arguments.excludes = listToArray( arguments.excludes );	
		}
		for( var item in arguments.excludes ){
			if( structKeyExists( arguments.utilsToMix, item ) ){
				structDelete( arguments.utilsToMix, item );
			}
		}
		return utilsToMix;
	}


}
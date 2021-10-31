/**
 * ModuleConfig file for the API Module
 */
 component {

     // Module Properties
	this.title = "UtilityMixinLoader";
	this.author = "Gavin Pickin and Scott Steinbeck";
	this.webURL = "https://github.com/gpickin/utilityMixinLoader";
	this.description = "A loader tool to help you mixin the utilities you need for your ColdBox App";
	this.version = "1.0.0";
	// If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
	this.viewParentLookup = true;
	// If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
	this.layoutParentLookup = true;
	// Module Entry Point
	this.entryPoint = "utilityMixinLoader";
	// Inheritable entry point.
	this.inheritEntryPoint = true;
	// Model Namespace
	this.modelNamespace = "utilityMixinLoader";
	// CF Mapping
	this.cfmapping = "utilityMixinLoader";
	// Auto-map models
	this.autoMapModels = true;
	// Module Dependencies
	this.dependencies = [];
    this.applicationHelper 	= [ "mixins/mixUtilities.cfm" ];

    function configure() {
		// parent settings
		variables.parentSettings = {};

		// module settings - stored in modules.name.settings
		variables.settings = {
			defaultSettings: {
				defaultGroupIncludes: [],
				defaultIncludes: [],
				defaultExcludes: [],
				neverInclude: [],
			}
		};

		// Load the library functions and groups
		structAppend( variables.settings, loadLibaries() );
        
		// Layout Settings
		variables.layoutSettings = { defaultLayout: "" };

		// Custom Declared Points
		variables.interceptorSettings = { customInterceptionPoints: "" };

		// Custom Declared Interceptors
		variables.interceptors = [];
	}

	/**
	 * Fired when the module is registered and activated.
	 */
	function onLoad() {
	}

	/**
	 * Fired when the module is unregistered and unloaded
	 */
	function onUnload() {
	}

    function loadLibaries(){
		return {
            "functions": {
                "mergeWith": { 
                    "name": "mergeWith",
                    "wireboxRef": "helpers@utilityMixinLoader",
                    "wireboxFunction": "mergeWith"
                },
                "sanitizeSortParams": { 
                    "name": "sanitizeSortParams",
                    "wireboxRef": "helpers@utilityMixinLoader",
                    "wireboxFunction": "sanitizeSortParams"
                },
                "generateVueTable2Pagination": { 
                    "name": "generateVueTable2Pagination",
                    "wireboxRef": "helpers@utilityMixinLoader",
                    "wireboxFunction": "generateVueTable2Pagination"
                }
            },
            "groups": { 
                "api": [
                    "mergeWith",
                    "generateVueTable2Pagination",
                    "sanitizeSortParams"
                ]
            }
        }
    }

}   
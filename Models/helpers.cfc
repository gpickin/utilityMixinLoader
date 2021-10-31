component singleton {
    
    
    /**
	 * Helper Function for Quick to merge associated children records into parent array when using retrieveQuery instead
	 * of Entity Objects
	 *
	 * @parent The array of Parent Structs
	 * @children The Array of Possible Children Structs
	 * @mergeKey The Key which we will be merging all of the actual children into the Parent Object
	 * @parentField The field in the parent object which we need to compare the children FK again - ie Parent's PK
	 * @childField Optional field in the child that links back to the parent, ie the FK in the child that matches the parents PK. If this is not provided, we assume the FK field in the child matches the name of the Parent Field
	 */
	function mergeWith(
		required parent,
		required children,
		required mergeKey,
		required parentField,
		childField = ""
	) {
		// If the child field is not present, we assume the field is named the same in the parent and the child like a USING statement
		if ( !len( arguments.childField ) ) {
			arguments.childField = parentField;
		}
		return parent.map( ( parentItem ) => {
			parentItem[ mergeKey ] = children.filter( ( childItem ) => {
				return ( childItem[ childField ] == parentItem[ parentField ] );
			} );
			return parentItem;
		} );
	}

	
    function generateVueTable2Pagination( required struct pagination, required nextURL, prevURL = "" ) {
		if ( !len( arguments.prevURL ) ) {
			arguments.prevURL = arguments.nextURL;
		}
		arguments.pagination[ "total" ] = arguments.pagination.totalRecords;
		arguments.pagination[ "per_page" ] = arguments.pagination.maxRows;
		arguments.pagination[ "current_page" ] = arguments.pagination.page;
		arguments.pagination[ "last_page" ] = arguments.pagination.totalPages;
		arguments.pagination[ "from" ] = arguments.pagination.offset + 1;
		arguments.pagination[ "to" ] = arguments.pagination.page * arguments.pagination.maxRows;
		if ( arguments.pagination[ "to" ] gt arguments.pagination.totalRecords ) {
			arguments.pagination[ "to" ] = arguments.pagination.totalRecords;
		}
		arguments.pagination[ "next_page_url" ] = arguments.nextURL;
		arguments.pagination[ "prev_page_url" ] = arguments.prevURL;

		return arguments.pagination;
	}

	
    function sanitizeSortParams(
		safeSortList = "",
		required struct rc,
		required defaultSort,
		defaultSortDirection = "asc"
	) {
		// Split the Vue2 Sort format
		if ( findNoCase( "|", rc.sort ) ) {
			var incomingSort = rc.sort;
			rc.sort = listFirst( incomingSort, "|" );
			rc.sortDirection = listLast( incomingSort, "|" );
		}
		// Sanitize the Sort Column
		if ( len( arguments.safeSortList ) ) {
			if ( !listFindNoCase( arguments.safeSortList, rc.sort ) ) {
				rc.sort = defaultSort;
				rc.sortDirection = defaultSortDirection;
			}
		}

		// Sanitize the Sort Param
		if ( rc.sort == "" ) {
			rc.sort = defaultSort;
		}
		// Sanitize the Sort Direction
		if ( rc.sortDirection != "desc" ) {
			rc.sortDirection = "asc";
		}
	}

    
}
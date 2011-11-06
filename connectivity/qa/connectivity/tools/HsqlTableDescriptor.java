/**************************************************************
 * 
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 * 
 *   http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 * 
 *************************************************************/



package connectivity.tools;

import com.sun.star.beans.XPropertySet;
import com.sun.star.container.XNameAccess;
import com.sun.star.sdbc.ColumnValue;
import com.sun.star.sdbcx.XColumnsSupplier;
import com.sun.star.sdbcx.XDataDescriptorFactory;
import com.sun.star.sdbcx.XTablesSupplier;
import com.sun.star.uno.UnoRuntime;
import connectivity.tools.sdb.Connection;

/** is a very simply descriptor of a HSQL table, to be used with a HsqlDatabase.createTable method
 */
public class HsqlTableDescriptor
{
    private String                  m_name;
    private HsqlColumnDescriptor[]  m_columns;

    /** Creates a new instance of HsqlTableDescriptor */
    public HsqlTableDescriptor( String _name, HsqlColumnDescriptor[] _columns )
    {
        m_name = _name;
        m_columns = _columns;
    }

    /** returns the name of the table
     */
    public String getName()
    {
        return m_name;
    }

    /** returns the set of column descriptors for the table
     */
    public HsqlColumnDescriptor[] getColumns()
    {
        return m_columns;
    }

    public XPropertySet createSdbcxDescriptor( Connection _forConnection )
    {
        XTablesSupplier suppTables = UnoRuntime.queryInterface( XTablesSupplier.class, _forConnection.getXConnection() );
        XDataDescriptorFactory tableDescFac = UnoRuntime.queryInterface( XDataDescriptorFactory.class, suppTables.getTables() );
        XPropertySet tableDesc = tableDescFac.createDataDescriptor();

        try
        {
            tableDesc.setPropertyValue( "Name", getName() );
        }
        catch ( Exception e ) { e.printStackTrace( System.err ); }
        
        XColumnsSupplier suppDescCols = UnoRuntime.queryInterface( XColumnsSupplier.class, tableDesc );

        XNameAccess descColumns = suppDescCols.getColumns();
        XDataDescriptorFactory columnDescFac = UnoRuntime.queryInterface( XDataDescriptorFactory.class, descColumns );

        HsqlColumnDescriptor[] myColumns = getColumns();
        for ( int i = 0; i < myColumns.length; ++i )
        {
            XPropertySet columnDesc = columnDescFac.createDataDescriptor();
            try
            {
                columnDesc.setPropertyValue( "Name", myColumns[i].getName() );
                columnDesc.setPropertyValue( "IsNullable", new Integer( myColumns[i].isRequired() ? ColumnValue.NO_NULLS : ColumnValue.NULLABLE) );
                columnDesc.setPropertyValue( "TypeName", myColumns[i].getTypeName() );
                if ( myColumns[i].isPrimaryKey() || myColumns[i].isForeignKey() )
                    // not yet implemented
                    throw new java.lang.UnsupportedOperationException("creating a primary or foreign key via SDBCX not yet implemented" );
            }
            catch( com.sun.star.uno.Exception e ) { e.printStackTrace( System.err ); }
        }

        return tableDesc;
    }
}

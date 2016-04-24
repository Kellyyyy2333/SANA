/* 
 * Copyright (C) 2015 Wen, Chifeng <https://sourceforge.net/u/daviesx/profile/>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
 */
package research;

import org.cytoscape.app.swing.CySwingAppAdapter;

/**
 * Singleton to create a network database
 *
 * @author davis
 */
public class NetworkDatabaseSingleton {

        private static NetworkDatabase m_database = null;

        private NetworkDatabaseSingleton() {
        }

        public static NetworkDatabase get_instance() throws Exception {
                if (m_database == null) {
                        m_database = new NetworkDatabase();
                }
                return m_database;
        }
}

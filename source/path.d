module path;

import std.array     : array;
import std.algorithm : filter;
import std.algorithm : map;
import std.array     : split;
import std.range     : empty;
import std.range     : popBack;
import std.range     : popFront;
import std.stdio : writeln;


//alias PathImpl!() Path;

/** */
struct Path
{
    string _path;
    alias _path this;

    const string pathSeparator = r"\";

    /** */
    alias _path asString;


    /** */
    string[] pathSplitter( string s )
    {
        return 
            s
                .split( pathSeparator )
                .filter!( "a.length > 0" )
                .array;
    }


    ///
    unittest
    {
        auto p = Path( r"C:\" );
        auto splits = p.pathSplitter( r"C:\" );
        assert( splits.length == 1 );
        assert( splits == [ "C:" ] );

        auto splits2 = p.pathSplitter( r"C:\Program Files" );
        assert( splits2.length == 2 );
        assert( splits2 == [ "C:", "Program Files" ] );

        auto splits3 = p.pathSplitter( r"C:\\Program Files" );
        assert( splits3.length == 2 );
        assert( splits3 == [ "C:", "Program Files" ] );
    }


    /** */
    void popBack()
    {
        import std.array : join;

        auto p = pathSplitter( _path );
        p.popBack();
        _path = p.join( pathSeparator );
    }


    ///
    unittest
    {
        auto p = Path( r"C:\" );
        p.popBack();
        assert( p.length == 0 );
        assert( p._path == "" );

        auto p2 = Path( r"C:\Program Files" );
        p2.popBack();
        assert( p2.length == 1 );
        assert( p2._path == "C:" );

        auto p3 = Path( r"C:\\Program Files" );
        p3.popBack();
        assert( p3.length == 1 );
        assert( p3._path == "C:" );

        auto p4 = Path( r"C:\\Program Files\\\\" );
        p4.popBack();
        assert( p4.length == 1 );
        assert( p4._path == "C:" );
    }


    /** */
    void popFront()
    {
        import std.array : join;

        auto p = pathSplitter( _path );
        p.popFront();
        _path = p.join( pathSeparator );
    }


    ///
    unittest
    {
        auto p = Path( r"C:\" );
        p.popFront();
        assert( p.length == 0 );
        assert( p._path == "" );

        auto p2 = Path( r"C:\Program Files" );
        p2.popFront();
        assert( p2.length == 1 );
        assert( p2._path == "Program Files" );

        auto p3 = Path( r"C:\\Program Files" );
        p3.popFront();
        assert( p3.length == 1 );
        assert( p3._path == "Program Files" );

        auto p4 = Path( r"C:\\Program Files\\\\" );
        p4.popFront();
        assert( p4.length == 1 );
        assert( p4._path == "Program Files" );
    }


    /** */
    string back()
    {
        auto p = pathSplitter( _path );
        return p[ $ - 1 ];
    }


    ///
    unittest
    {
        auto p = Path( r"C:\" );
        assert( p.back == "C:" );

        auto p2 = Path( r"C:\Program Files" );
        assert( p2.back == "Program Files" );

        auto p3 = Path( r"C:\\Program Files" );
        assert( p3.back == "Program Files" );

        auto p4 = Path( r"C:\\Program Files\\\\" );
        assert( p4.back == "Program Files" );
    }


    /** */
    string front()
    {
        auto p = pathSplitter( _path );
        return p[ 0 ];
    }


    ///
    unittest
    {
        auto p = Path( r"C:\" );
        assert( p.front == "C:" );

        auto p2 = Path( r"C:\Program Files" );
        assert( p2.front == "C:" );

        auto p3 = Path( r"C:\\Program Files" );
        assert( p3.front == "C:" );

        auto p4 = Path( r"C:\\Program Files\\\\" );
        assert( p4.front == "C:" );
    }




    /** */
    Path parent()
    {
        import std.array : join;

        auto p = pathSplitter( _path );

        if ( p.empty )
        {
            return Path(); // FAIL
        }
        else
        {
            p.popBack();

            if ( p.empty )
            {
                return Path(); // FAIL
            }
            else
            {
                return Path( p.join( pathSeparator ) ); // OK
            }
        }
    }


    ///
    unittest
    {
        auto p = Path( r"C:\" );
        assert( p.parent._path == "" );

        auto p2 = Path( r"C:\Program Files" );
        assert( p2.parent._path == "C:" );

        auto p3 = Path( r"C:\\Program Files" );
        assert( p3.parent._path == "C:" );

        auto p4 = Path( r"C:\\Program Files\\\\" );
        assert( p4.parent._path == "C:" );

        auto p5 = Path( r"" );
        assert( p5.parent._path == "" );

    }


    /** */
    string dirName()
    {
        return parent()._path;
    }


    ///
    unittest
    {
        auto p = Path( r"C:\" );
        assert( p.dirName == "" );

        auto p2 = Path( r"C:\Program Files" );
        assert( p2.dirName == "C:" );

        auto p3 = Path( r"C:\\Program Files" );
        assert( p3.dirName == "C:" );

        auto p4 = Path( r"C:\\Program Files\\\\" );
        assert( p4.dirName == "C:" );
    }


    /** */
    size_t length()
    {
        return pathSplitter( _path ).length;
    }


    ///
    unittest
    {
        auto p = Path( r"C:\" );
        assert( p.length == 1 );

        auto p2 = Path( r"C:\Program Files" );
        assert( p2.length == 2 );

        auto p3 = Path( r"C:\\Program Files" );
        assert( p3.length == 2 );

        auto p4 = Path( r"C:\\Program Files\\\\" );
        assert( p4.length == 2 );
    }


    /** */
    bool empty()
    {
        return pathSplitter( _path ).length == 0;
    }


    ///
    unittest
    {
        auto p = Path( r"C:\" );
        assert( p.empty == false );

        auto p2 = Path( r"C:\Program Files" );
        assert( p2.empty == false );

        auto p3 = Path( r"C:\\Program Files" );
        assert( p3.empty == false );

        auto p4 = Path( r"C:\\Program Files\\\\" );
        assert( p4.empty == false );

        auto p5 = Path( r"" );
        assert( p5.empty == true );

        auto p6 = Path( r"\" );
        assert( p6.empty == true );
    }


    /** */
    Path opSlice( size_t a, size_t b )
    {
        import std.array : join;

        auto p = pathSplitter( _path );
        return Path( p[ a .. b ].join( pathSeparator ) );
    }


    ///
    unittest
    {
        import std.exception  : assertThrown;
        import core.exception : RangeError;

        auto p = Path( r"C:\" );
        assert( is( typeof( p[ 0 .. 1 ] ) == Path ) );
        assert( p[ 0 .. 1 ]._path == "C:" );

        auto p2 = Path( r"C:\Program Files" );
        assert( p2[ 0 .. 1 ]._path == "C:" );
        assert( p2[ 1 .. 2 ]._path == "Program Files" );

        auto p3 = Path( r"C:\\Program Files" );
        assert( p3[ 0 .. 1 ]._path == "C:" );
        assert( p3[ 1 .. 2 ]._path == "Program Files" );

        auto p4 = Path( r"C:\\Program Files\\\\" );
        assert( p4[ 0 .. 1 ]._path == "C:" );
        assert( p4[ 1 .. 2 ]._path == "Program Files" );

        auto p5 = Path( r"C:\Program Files" );
        assert( p4[ 0 .. 1 ]._path == "C:" );
        assert( p4[ 1 .. 2 ]._path == "Program Files" );
        assert( p4[ 0 .. $ ]._path == r"C:\Program Files" );
        assertThrown!RangeError( p4[ 2 .. 3 ]._path == "Program Files" );
    }


    /** */
    string opIndex( size_t i )
    {
        auto p = pathSplitter( _path );
        return p[ i ];
    }


    ///
    unittest
    {
        import std.exception  : assertThrown;
        import core.exception : RangeError;

        auto p = Path( r"C:\" );
        assert( is( typeof( p[ 0 ] ) == string ) );
        assert( p[ 0 ] == "C:" );

        auto p2 = Path( r"C:\Program Files" );
        assert( p2[ 0 ] == "C:" );
        assert( p2[ 1 ] == "Program Files" );

        auto p3 = Path( r"C:\\Program Files" );
        assert( p3[ 0 ] == "C:" );
        assert( p3[ 1 ] == "Program Files" );

        auto p4 = Path( r"C:\\Program Files\\\\" );
        assert( p4[ 0 ] == "C:" );
        assert( p4[ 1 ] == "Program Files" );

        auto p5 = Path( r"C:\Program Files" );
        assert( p4[ 0 ] == "C:" );
        assert( p4[ 1 ] == "Program Files" );
        assert( p4[ $-1 ] == "Program Files" );
        assertThrown!RangeError( p4[ 3 ] == "Program Files" );
    }


    /** */
    size_t opDollar()
    {
        return length;
    }


    ///
    unittest
    {
        import std.exception  : assertThrown;
        import core.exception : RangeError;

        auto p = Path( r"C:\" );
        assert( p[ $ - 1 ] == "C:" );

        auto p2 = Path( r"C:\Program Files" );
        assert( p2[ 0 .. $ ]._path == r"C:\Program Files" );
    }


    /** */
    Path opBinary( string op : "+" )( ref const Path b )
    {
        import std.range : chain;
        import std.array : join;

        return 
            Path( 
                chain( pathSplitter( _path ), pathSplitter( b._path ) )
                    .join( pathSeparator )
            );
    }


    ///
    unittest
    {
        assert( ( Path( r"C:\" ) + Path( r"Program Files" )   )._path == r"C:\Program Files" );
        assert( ( Path( r"C:\" ) + Path( r"Program Files\" )  )._path == r"C:\Program Files" );
        assert( ( Path( r"C:\" ) + Path( r"\Program Files\" ) )._path == r"C:\Program Files" );
        assert( ( Path( r"C:\" ) + Path( r"" )                )._path == r"C:" );
    }


    /** */
    Path opBinary( string op : "+" )( string s )
    {
        import std.range : chain;
        import std.array : join;

        return 
            Path( 
                chain( pathSplitter( _path ), pathSplitter( s ) )
                    .join( pathSeparator )
            );
    }


    ///
    unittest
    {
        assert( ( Path( r"C:\" ) + r"Program Files"   )._path == r"C:\Program Files" );
        assert( ( Path( r"C:\" ) + r"Program Files\"  )._path == r"C:\Program Files" );
        assert( ( Path( r"C:\" ) + r"\Program Files\" )._path == r"C:\Program Files" );
        assert( ( Path( r"C:\" ) + r""                )._path == r"C:" );
    }


    /** */
    bool opEquals( Path b )
    {
        return 
            pathSplitter( _path ) == pathSplitter( b._path );
    }


    ///
    unittest
    {
        assert( Path( r"C:\" )                 == Path( r"C:" ) );
        assert( Path( r"C:\" )                 == Path( r"C:\" ) );
        assert( Path( r"C:\Program Files" )    == Path( r"C:\Program Files" ) );
        assert( Path( r"C:\Program Files" )    == Path( r"C:\Program Files\" ) );
        assert( Path( r"C:\Program Files" )    == Path( r"C:\\\\Program Files\" ) );
        assert( Path( r"C:\\\Program Files\" ) == Path( r"C:\Program Files" ) );

        assert( Path( r"C:\" ) != Path( r"Program Files" )   );
        assert( Path( r"C:\" ) != Path( r"Program Files\" )  );
        assert( Path( r"C:\" ) != Path( r"\Program Files\" ) );
        assert( Path( r"C:\" ) != Path( r"" )                );
        assert( Path( r"" )    != Path( r"C:\" )             );
        assert( Path( r"C: " ) != Path( r"C:" )              );
    }


    /** */
    bool opEquals( string s )
    {
        return 
            pathSplitter( _path ) == pathSplitter( s );
    }


    ///
    unittest
    {
        assert( Path( r"C:\" )                 == r"C:" );
        assert( Path( r"C:\" )                 == r"C:\" );
        assert( Path( r"C:\Program Files" )    == r"C:\Program Files" );
        assert( Path( r"C:\Program Files" )    == r"C:\Program Files\" );
        assert( Path( r"C:\Program Files" )    == r"C:\\\\Program Files\" );
        assert( Path( r"C:\\\Program Files\" ) == r"C:\Program Files" );

        assert( Path( r"C:\" ) != r"Program Files"   );
        assert( Path( r"C:\" ) != r"Program Files\"  );
        assert( Path( r"C:\" ) != r"\Program Files\" );
        assert( Path( r"C:\" ) != r""                );
        assert( Path( r"" )    != r"C:\"             );
        assert( Path( r"C: " ) != r"C:"              );
    }


    /** */
    int opCmp( Path b )
    {
        if ( pathSplitter( _path ) < pathSplitter( b._path ) )
            return -1;
        else
        if ( pathSplitter( _path ) > pathSplitter( b._path ) )
            return 1;
        else
            return 0;
    }


    ///
    unittest
    {
        assert( Path( r"C:\" )              <  Path( r"C:\Program Files" ) );
        assert( Path( r"C:\Program Files" ) >  Path( r"C:\" ) );
        assert( Path( r"C:" )               == Path( r"C:" ) );
        assert( Path( r"C:\" )              == Path( r"C:" ) );
    }


    /** */
    int opCmp( string s )
    {
        if ( pathSplitter( _path ) < pathSplitter( s ) )
            return -1;
        else
        if ( pathSplitter( _path ) > pathSplitter( s ) )
            return 1;
        else
            return 0;
    }


    ///
    unittest
    {
        assert( Path( r"C:\" )              <  r"C:\Program Files" );
        assert( Path( r"C:\Program Files" ) >  r"C:\" );
        assert( Path( r"C:" )               == r"C:" );
        assert( Path( r"C:\" )              == r"C:" );
    }


    /** */
    pragma( inline )
    void opAssign( Path b )
    {
        this._path = b._path;
    }


    ///
    unittest
    {
        Path p1 = Path( r"C:\" );
        Path p2 = Path( r"C:\Program Files" );
        p1 = p2;
        assert( p1 == p2 );
    }


    ///** */
    //T entity( T )()
    //{
    //    return T( _path );
    //}


    /** */
    Path rest()
    {
        import std.array : join;

        auto p = pathSplitter( _path );
        if ( p.length > 0 )
            return Path( p[ 1 .. $ ].join( pathSeparator ) );
        else
            return Path();
    }

    ///
    unittest
    {
        assert( Path( r"C:\"                        ).rest._path == r"" );
        assert( Path( r"C:"                         ).rest._path == r"" );
        assert( Path( r"C:\Program Files"           ).rest._path == r"Program Files" );
        assert( Path( r"C:\Program Files\"          ).rest._path == r"Program Files" );
        assert( Path( r"C:\Program Files\Microsoft" ).rest._path == r"Program Files\Microsoft" );
        assert( Path( r""                           ).rest._path == r"" );
    }


    /** */
    bool startsWith( Path b )
    {
        import std.algorithm : startsWith;

        return pathSplitter( _path ).startsWith( pathSplitter( b._path ) );
    }


    ///
    unittest
    {
        assert( Path( r"C:\"                        ).startsWith( Path( r"C:\") ) );
        assert( Path( r"C:"                         ).startsWith( Path( r"C:\") ) );
        assert( Path( r"C:\Program Files"           ).startsWith( Path( r"C:\") ) );
        assert( Path( r"C:\Program Files\"          ).startsWith( Path( r"C:\") ) );
        assert( Path( r"C:\Program Files\Microsoft" ).startsWith( Path( r"C:\") ) );

        assert( !Path( r""                           ).startsWith( Path( r"C:\") ) );
    }
}

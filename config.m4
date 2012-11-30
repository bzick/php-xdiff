dnl $Id: config.m4,v 1.7 2008/07/01 16:13:04 mg Exp $
dnl config.m4 for extension xdiff

PHP_ARG_WITH(xdiff, for xdiff support,
[  --with-xdiff             Include xdiff support])


if test "$PHP_XDIFF" != "no"; then

  SEARCH_PATH="/usr/local /usr"     # you might want to change this
  SEARCH_FOR="/include/xdiff.h"  # you most likely want to change this
  if test -r $PHP_XDIFF/; then # path given as parameter
    XDIFF_DIR=$PHP_XDIFF
  else # search default path list
    AC_MSG_CHECKING([for xdiff files in default path])
    for i in $SEARCH_PATH ; do
      if test -r $i/$SEARCH_FOR; then
        XDIFF_DIR=$i
        AC_MSG_RESULT(found in $i)
      fi
    done
  fi

  if test -z "$XDIFF_DIR"; then
    AC_MSG_RESULT([not found])
    AC_MSG_ERROR([Please reinstall the libxdiff distribution])
  fi

  PHP_ADD_INCLUDE($XDIFF_DIR/include)

  EXTRA_LIBS="-lm"
  AC_CHECK_LIB(dl, dlopen, [
    EXTRA_LIBS="$EXTRA_LIBS -ldl"
  ])

  LIBNAME=xdiff
  LIBSYMBOL=xdl_diff

  PHP_CHECK_LIBRARY($LIBNAME,$LIBSYMBOL,
  [
    PHP_ADD_LIBRARY_WITH_PATH($LIBNAME, $XDIFF_DIR/lib, XDIFF_SHARED_LIBADD)
    AC_DEFINE(HAVE_XDIFFLIB,1, [ libxdiff ])
  ],[
    AC_MSG_ERROR([wrong xdiff lib version or lib not found])
  ],[
    -L$XDIFF_DIR/lib $EXTRA_LIBS
  ])
  PHP_SUBST(XDIFF_SHARED_LIBADD)

  LIBNAME=xdiff
  LIBSYMBOL=xdl_set_allocator

  PHP_CHECK_LIBRARY($LIBNAME,$LIBSYMBOL,
  [
    AC_DEFINE(HAVE_XDL_SET_ALLOCATOR,1,[ libxdiff memory allocator ])
  ],[   ],[
    -L$XDIFF_DIR/lib
  ])

  dnl
  dnl Check for xdiff 0.9 or greater availability
  dnl
  old_CPPFLAGS=$CPPFLAGS
  CPPFLAGS=-I$XDIFF_DIR/include
  AC_MSG_CHECKING(if xdiff memory allocator supports private data)
  AC_TRY_COMPILE([
#include <xdiff.h>
#include <stdlib.h>
  ], [
memallocator_t a;
a.priv = NULL;
  ], have_old_xdiff=no, have_old_xdiff=yes)
  CPPFLAGS=$old_CPPFLAGS

  if test "$have_old_xdiff" = yes; then
    AC_MSG_RESULT(no)
    AC_DEFINE(HAVE_OLD_XDIFF, 1, [ Old version of memory allocator ])
  else
    AC_MSG_RESULT(yes)
  fi

  PHP_NEW_EXTENSION(xdiff, xdiff.c, $ext_shared)
fi

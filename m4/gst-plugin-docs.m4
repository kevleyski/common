dnl GST_PYXML_CHECK([MINIMUM-PYTHON-VERSION])

AC_DEFUN([GST_PYXML_CHECK],
[
  AC_BEFORE([AS_PATH_PYTHON],[$0])dnl find python first

  have_pyxml=no
  if test "x$PYTHON" != x; then
    AC_MSG_CHECKING([pyxml])
    if $PYTHON -c "from xml.dom.ext.reader import Sax2" 2>/dev/null \
      && $PYTHON -c "from xml.dom.NodeFilter import NodeFilter" 2>/dev/null; then
      AC_MSG_RESULT(yes)
      have_pyxml=yes
    else
      AC_MSG_RESULT(no)
    fi
  fi
])


dnl GST_PLUGIN_DOCS([MINIMUM-GTK-DOC-VERSION],[MINIMUM-PYTHON-VERSION])
dnl 
dnl checks for prerequisites for the common/mangle-tmpl.py script
dnl used when building the plugin documenatation

AC_DEFUN([GST_PLUGIN_DOCS],
[
  AC_BEFORE([GTK_DOC_CHECK],[$0])dnl check for gtk-doc first

  dnl enable/disable plugin documentation building
  AC_ARG_ENABLE(plugin-docs,
    AC_HELP_STRING([--enable-plugin-docs],
                   [use gtk-doc to build plugin documentation [default=no]]),,
    enable_plugin_docs=no)

  if test x$enable_gtk_doc = xyes -a x$have_gtk_doc = xyes; then
    if test x$enable_plugin_docs = xyes; then
      GST_PYXML_CHECK([$1])
    fi
  fi

  AC_MSG_CHECKING([whether to build plugin documentation])
  if test x$enable_gtk_doc = xyes -a x$have_gtk_doc = xyes; then
    if test x$enable_plugin_docs = xyes; then
      if test "x$have_pyxml" != xyes; then
        build_plugin_docs=no
        AC_MSG_RESULT([no (pyxml not installed)])
      else
        build_plugin_docs=yes
        AC_MSG_RESULT([yes])
      fi
    else
      build_plugin_docs=no
      AC_MSG_RESULT([no (disabled)])
    fi
  else
    build_plugin_docs=no
    AC_MSG_RESULT([no (gtk-doc disabled or not available)])
  fi

  AM_CONDITIONAL(ENABLE_PLUGIN_DOCS, test x$build_plugin_docs = xyes)
])


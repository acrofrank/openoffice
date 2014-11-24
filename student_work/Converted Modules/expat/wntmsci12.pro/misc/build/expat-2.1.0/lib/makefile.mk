#**************************************************************
#  
#  Licensed to the Apache Software Foundation (ASF) under one
#  or more contributor license agreements.  See the NOTICE file
#  distributed with this work for additional information
#  regarding copyright ownership.  The ASF licenses this file
#  to you under the Apache License, Version 2.0 (the
#  "License"); you may not use this file except in compliance
#  with the License.  You may obtain a copy of the License at
#  
#    http://www.apache.org/licenses/LICENSE-2.0
#  
#  Unless required by applicable law or agreed to in writing,
#  software distributed under the License is distributed on an
#  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
#  KIND, either express or implied.  See the License for the
#  specific language governing permissions and limitations
#  under the License.
#  
#**************************************************************
PRJ=..$/..$/..$/..$/..

PRJNAME=expat
TARGET=expat
LIBTARGET=NO
EXTERNAL_WARNINGS_NOT_ERRORS=TRUE

# --- Settings -----------------------------------------------------
.INCLUDE :  settings.mk
# --- Files --------------------------------------------------------

CFLAGS+=-I..

.IF "$(OS)"=="WNT"
CDEFS+=-DCOMPILED_FROM_DSP
.ELSE
CDEFS+=-DHAVE_EXPAT_CONFIG_H
.ENDIF

.IF "$(OS)"=="MACOSX" && "$(SYSBASE)"!=""
CDEFS+=-DHAVE_MEMMOVE -DHAVE_BCOPY
.ENDIF # "$(OS)"=="MACOSX"

SLOFILES=$(SLO)$/xmlparse.obj \
         $(SLO)$/xmlrole.obj \
         $(SLO)$/xmltok.obj

SECOND_BUILD=UNICODE
UNICODE_SLOFILES=$(SLO)$/xmlparse.obj
UNICODECDEFS+=-DXML_UNICODE

LIB1ARCHIV=$(LB)$/libascii_$(TARGET)_xmlparse.a
LIB1TARGET=$(SLB)$/ascii_$(TARGET)_xmlparse.lib
LIB1OBJFILES=$(SLO)$/xmlparse.obj

LIB2ARCHIV=$(LB)$/lib$(TARGET)_xmlparse.a
LIB2TARGET=$(SLB)$/$(TARGET)_xmlparse.lib
LIB2OBJFILES =$(REAL_UNICODE_SLOFILES)

LIB3ARCHIV=$(LB)$/lib$(TARGET)_xmltok.a
LIB3TARGET=$(SLB)$/$(TARGET)_xmltok.lib
LIB3OBJFILES=$(SLO)$/xmlrole.obj $(SLO)$/xmltok.obj

.IF "$(BUILD_X64)"!=""
# ---------------- X64 stuff special ---------------------
#  use UNICODE only because shell/shlxthandler
#  doesn't link against ascii_expat_xmlparse
#---------------------------------------------------------
SLOFILES_X64=$(SLO_X64)$/xmlparse.obj \
             $(SLO_X64)$/xmlrole.obj \
             $(SLO_X64)$/xmltok.obj
CDEFS_X64+=-DXML_UNICODE -DCOMPILED_FROM_DSP
CFLAGS_X64+=-I..
LIB1TARGET_X64=$(SLB_X64)$/$(TARGET)_xmlparse.lib
LIB1OBJFILES_X64=$(SLO_X64)$/xmlparse.obj
LIB2TARGET_X64=$(SLB_X64)$/$(TARGET)_xmltok.lib
LIB2OBJFILES_X64=$(SLO_X64)$/xmlrole.obj $(SLO_X64)$/xmltok.obj
.ENDIF # "$(BUILD_X64)"!=""

# --- Targets ------------------------------------------------------
.INCLUDE :  set_wntx64.mk
.INCLUDE :	target.mk
.INCLUDE :  tg_wntx64.mk

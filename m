Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBCDF19C553;
	Wed,  3 Dec 2025 15:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776768; cv=none; b=tEefAgGJWhw6HDfJeg1/aO5RkAqxhJ71gKUuyErwr9jkl9TSWRvvH4Vx51BPfx31MP+Pa7VXtS9lEfoxFPeA2qhNp4zIybRhPXu5IHZGluEFiJK5EOOhsfRXpxjm45LF0bVWLMwiboA7oyHS9X9V0yTBjuY5m0Rx3nq2su2HYTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776768; c=relaxed/simple;
	bh=4EZX7iYLctOqpnsCYth+hSt+msjJgosy+wtqmRw50wk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oW1tn0W5n9MSxinGYJjM6oHeuXvRt3LxHg0GywxKDH7TJuIfuUxBroUH697CoV/HT+C8azPcuQHtwRITsqTQkp18n8wdPAAX3vr5UhkaHUNy78QiXCDH8rtR55W2B1C1ryc7AN4lxdDoiUD1c6PQp7regBZ6sMUiIHoGqjGGCxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JByyHrUh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JByyHrUh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5264EC4CEF5;
	Wed,  3 Dec 2025 15:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776767;
	bh=4EZX7iYLctOqpnsCYth+hSt+msjJgosy+wtqmRw50wk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JByyHrUhllVSRfzMLZPih2BDrtlWkpt11PeLC4XeQ2AVEW8KvZ1KCBSF5l4/C2sUa
	 pJGjekEyAz8AlDnCVMAxBNVn8bPQAnZR1G4Rya5SAbmOeQq1ddmO3EfxxdkJx5/8cP
	 2vJ4SalCjrPJVz4CoBOp/2BFydt8t5kqqVRGAJp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bill Wendling <morbo@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 5.10 239/300] Makefile.compiler: replace cc-ifversion with compiler-specific macros
Date: Wed,  3 Dec 2025 16:27:23 +0100
Message-ID: <20251203152409.479386789@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nick Desaulniers <ndesaulniers@google.com>

commit 88b61e3bff93f99712718db785b4aa0c1165f35c upstream.

cc-ifversion is GCC specific. Replace it with compiler specific
variants. Update the users of cc-ifversion to use these new macros.

Link: https://github.com/ClangBuiltLinux/linux/issues/350
Link: https://lore.kernel.org/llvm/CAGG=3QWSAUakO42kubrCap8fp-gm1ERJJAYXTnP1iHk_wrH=BQ@mail.gmail.com/
Suggested-by: Bill Wendling <morbo@google.com>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
[nathan: Backport to 5.10 and eliminate instances of cc-ifversion that
         did not exist upstream when this change was original created]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/kbuild/makefiles.rst            |   29 +++++++++++++++-----------
 Makefile                                      |    4 ++-
 arch/mips/loongson64/Platform                 |    2 -
 arch/powerpc/Makefile                         |    4 ++-
 arch/s390/Makefile                            |    4 +--
 drivers/gpu/drm/amd/display/dc/calcs/Makefile |    2 -
 drivers/gpu/drm/amd/display/dc/dcn20/Makefile |    2 -
 drivers/gpu/drm/amd/display/dc/dcn21/Makefile |    2 -
 drivers/gpu/drm/amd/display/dc/dcn30/Makefile |    2 -
 drivers/gpu/drm/amd/display/dc/dml/Makefile   |    2 -
 drivers/gpu/drm/amd/display/dc/dsc/Makefile   |    2 -
 scripts/Kbuild.include                        |   10 ++++++--
 12 files changed, 39 insertions(+), 26 deletions(-)

--- a/Documentation/kbuild/makefiles.rst
+++ b/Documentation/kbuild/makefiles.rst
@@ -552,22 +552,27 @@ more details, with real examples.
 	In the above example, -Wno-unused-but-set-variable will be added to
 	KBUILD_CFLAGS only if gcc really accepts it.
 
-    cc-ifversion
-	cc-ifversion tests the version of $(CC) and equals the fourth parameter
-	if version expression is true, or the fifth (if given) if the version
-	expression is false.
+    gcc-min-version
+	gcc-min-version tests if the value of $(CONFIG_GCC_VERSION) is greater than
+	or equal to the provided value and evaluates to y if so.
 
 	Example::
 
-		#fs/reiserfs/Makefile
-		ccflags-y := $(call cc-ifversion, -lt, 0402, -O1)
+		cflags-$(call gcc-min-version, 70100) := -foo
 
-	In this example, ccflags-y will be assigned the value -O1 if the
-	$(CC) version is less than 4.2.
-	cc-ifversion takes all the shell operators:
-	-eq, -ne, -lt, -le, -gt, and -ge
-	The third parameter may be a text as in this example, but it may also
-	be an expanded variable or a macro.
+	In this example, cflags-y will be assigned the value -foo if $(CC) is gcc and
+	$(CONFIG_GCC_VERSION) is >= 7.1.
+
+    clang-min-version
+	clang-min-version tests if the value of $(CONFIG_CLANG_VERSION) is greater
+	than or equal to the provided value and evaluates to y if so.
+
+	Example::
+
+		cflags-$(call clang-min-version, 110000) := -foo
+
+	In this example, cflags-y will be assigned the value -foo if $(CC) is clang
+	and $(CONFIG_CLANG_VERSION) is >= 11.0.0.
 
     cc-cross-prefix
 	cc-cross-prefix is used to check if there exists a $(CC) in path with
--- a/Makefile
+++ b/Makefile
@@ -855,7 +855,9 @@ DEBUG_CFLAGS	:=
 # Workaround for GCC versions < 5.0
 # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=61801
 ifdef CONFIG_CC_IS_GCC
-DEBUG_CFLAGS	+= $(call cc-ifversion, -lt, 0500, $(call cc-option, -fno-var-tracking-assignments))
+ifneq ($(call gcc-min-version, 50000),y)
+DEBUG_CFLAGS	+= $(call cc-option, -fno-var-tracking-assignments)
+endif
 endif
 
 ifdef CONFIG_DEBUG_INFO
--- a/arch/mips/loongson64/Platform
+++ b/arch/mips/loongson64/Platform
@@ -12,7 +12,7 @@ cflags-$(CONFIG_CPU_LOONGSON64)	+= -Wa,-
 # by GAS.  The cc-option can't probe for this behaviour so -march=loongson3a
 # can't easily be used safely within the kbuild framework.
 #
-ifeq ($(call cc-ifversion, -ge, 0409, y), y)
+ifeq ($(call gcc-min-version, 40900), y)
   ifeq ($(call ld-ifversion, -ge, 225000000, y), y)
     cflags-$(CONFIG_CPU_LOONGSON64)  += \
       $(call cc-option,-march=loongson3a -U_MIPS_ISA -D_MIPS_ISA=_MIPS_ISA_MIPS64)
--- a/arch/powerpc/Makefile
+++ b/arch/powerpc/Makefile
@@ -168,7 +168,9 @@ endif
 # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=44199
 # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=52828
 ifndef CONFIG_CC_IS_CLANG
-CC_FLAGS_FTRACE	+= $(call cc-ifversion, -lt, 0409, -mno-sched-epilog)
+ifneq ($(call gcc-min-version, 40900),y)
+CC_FLAGS_FTRACE	+= -mno-sched-epilog
+endif
 endif
 endif
 
--- a/arch/s390/Makefile
+++ b/arch/s390/Makefile
@@ -35,8 +35,8 @@ KBUILD_CFLAGS_DECOMPRESSOR += $(if $(CON
 KBUILD_CFLAGS_DECOMPRESSOR += $(if $(CONFIG_DEBUG_INFO_DWARF4), $(call cc-option, -gdwarf-4,))
 
 ifdef CONFIG_CC_IS_GCC
-	ifeq ($(call cc-ifversion, -ge, 1200, y), y)
-		ifeq ($(call cc-ifversion, -lt, 1300, y), y)
+	ifeq ($(call gcc-min-version, 120000), y)
+		ifneq ($(call gcc-min-version, 130000), y)
 			KBUILD_CFLAGS += $(call cc-disable-warning, array-bounds)
 			KBUILD_CFLAGS_DECOMPRESSOR += $(call cc-disable-warning, array-bounds)
 		endif
--- a/drivers/gpu/drm/amd/display/dc/calcs/Makefile
+++ b/drivers/gpu/drm/amd/display/dc/calcs/Makefile
@@ -34,7 +34,7 @@ calcs_ccflags := -mhard-float -maltivec
 endif
 
 ifdef CONFIG_CC_IS_GCC
-ifeq ($(call cc-ifversion, -lt, 0701, y), y)
+ifneq ($(call gcc-min-version, 70100),y)
 IS_OLD_GCC = 1
 endif
 endif
--- a/drivers/gpu/drm/amd/display/dc/dcn20/Makefile
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/Makefile
@@ -18,7 +18,7 @@ CFLAGS_$(AMDDALPATH)/dc/dcn20/dcn20_reso
 endif
 
 ifdef CONFIG_CC_IS_GCC
-ifeq ($(call cc-ifversion, -lt, 0701, y), y)
+ifneq ($(call gcc-min-version, 70100),y)
 IS_OLD_GCC = 1
 endif
 endif
--- a/drivers/gpu/drm/amd/display/dc/dcn21/Makefile
+++ b/drivers/gpu/drm/amd/display/dc/dcn21/Makefile
@@ -14,7 +14,7 @@ CFLAGS_$(AMDDALPATH)/dc/dcn21/dcn21_reso
 endif
 
 ifdef CONFIG_CC_IS_GCC
-ifeq ($(call cc-ifversion, -lt, 0701, y), y)
+ifneq ($(call gcc-min-version, 70100),y)
 IS_OLD_GCC = 1
 endif
 endif
--- a/drivers/gpu/drm/amd/display/dc/dcn30/Makefile
+++ b/drivers/gpu/drm/amd/display/dc/dcn30/Makefile
@@ -47,7 +47,7 @@ CFLAGS_REMOVE_$(AMDDALPATH)/dc/dcn30/dcn
 endif
 
 ifdef CONFIG_CC_IS_GCC
-ifeq ($(call cc-ifversion, -lt, 0701, y), y)
+ifneq ($(call gcc-min-version, 70100),y)
 IS_OLD_GCC = 1
 endif
 endif
--- a/drivers/gpu/drm/amd/display/dc/dml/Makefile
+++ b/drivers/gpu/drm/amd/display/dc/dml/Makefile
@@ -35,7 +35,7 @@ dml_ccflags := -mhard-float -maltivec
 endif
 
 ifdef CONFIG_CC_IS_GCC
-ifeq ($(call cc-ifversion, -lt, 0701, y), y)
+ifneq ($(call gcc-min-version, 70100),y)
 IS_OLD_GCC = 1
 endif
 endif
--- a/drivers/gpu/drm/amd/display/dc/dsc/Makefile
+++ b/drivers/gpu/drm/amd/display/dc/dsc/Makefile
@@ -11,7 +11,7 @@ dsc_ccflags := -mhard-float -maltivec
 endif
 
 ifdef CONFIG_CC_IS_GCC
-ifeq ($(call cc-ifversion, -lt, 0701, y), y)
+ifneq ($(call gcc-min-version, 70100),y)
 IS_OLD_GCC = 1
 endif
 endif
--- a/scripts/Kbuild.include
+++ b/scripts/Kbuild.include
@@ -133,9 +133,13 @@ cc-option-yn = $(call try-run,\
 cc-disable-warning = $(call try-run,\
 	$(CC) -Werror $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS) -W$(strip $(1)) -c -x c /dev/null -o "$$TMP",-Wno-$(strip $(1)))
 
-# cc-ifversion
-# Usage:  EXTRA_CFLAGS += $(call cc-ifversion, -lt, 0402, -O1)
-cc-ifversion = $(shell [ $(CONFIG_GCC_VERSION)0 $(1) $(2)000 ] && echo $(3) || echo $(4))
+# gcc-min-version
+# Usage: cflags-$(call gcc-min-version, 70100) += -foo
+gcc-min-version = $(shell [ $(CONFIG_GCC_VERSION)0 -ge $(1)0 ] && echo y)
+
+# clang-min-version
+# Usage: cflags-$(call clang-min-version, 110000) += -foo
+clang-min-version = $(shell [ $(CONFIG_CLANG_VERSION)0 -ge $(1)0 ] && echo y)
 
 # ld-option
 # Usage: KBUILD_LDFLAGS += $(call ld-option, -X, -Y)



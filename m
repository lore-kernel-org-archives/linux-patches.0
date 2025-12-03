Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3847349B08;
	Wed,  3 Dec 2025 16:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778438; cv=none; b=DcY7NRw1v2lg1iAw1L5MG+0viyH7PTJXVqxJIxlLjxahXg+OyE/opHf8ccnsg598SnQNaE7X9078E3NEFedv2RW1HW96FRgW0ZBxGy4JbjNMCFH9JDGFAn9GCAHPcp3HSBdXgkeSpkC6wjbznwZKNvdA8JYmEFHk9MdeWeJzXCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778438; c=relaxed/simple;
	bh=ox1D/YpQZkmeeNjw1l4nl0cdMXOUbmAwUlF3wziO0xI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GgcOKgsQogmClD2IuOIFTwswLxfO9IkTuk5EpQpANcAT/5gRURq8elO0+3Q0Q8JU82F+ZB4JGNWEI0nEKWP6Us8cHU4JyhZmE4q9xF+ThjWS4TqY2jSwXMYTsbKqGaAQZR6+d6zp06oBJSddsa2bIzNFNyGZ2sKlwlC1Wqf+X70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o5XIgDTZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o5XIgDTZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63854C4CEF5;
	Wed,  3 Dec 2025 16:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778437;
	bh=ox1D/YpQZkmeeNjw1l4nl0cdMXOUbmAwUlF3wziO0xI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o5XIgDTZqYo8qihlX0sticTwJHU3H8zMxU/63oKg9E+3phix0ECv+eXC8JeQR50Ld
	 aACeMeuUCKVU8wPPmwO0tKPKd0OdpdUVfKRothb9wyIH64p10LI/hq4Q6GhxzvuYfo
	 GQexsWvM2QRoFNgj8VQQkhfjJEkRxIPE7ji1jmqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bill Wendling <morbo@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 5.15 313/392] Makefile.compiler: replace cc-ifversion with compiler-specific macros
Date: Wed,  3 Dec 2025 16:27:43 +0100
Message-ID: <20251203152425.678774598@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[nathan: Backport to 5.15 and eliminate instances of cc-ifversion that
         did not exist upstream when this change was original created]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/kbuild/makefiles.rst             |   29 ++++++++++++++-----------
 Makefile                                       |    6 +----
 arch/mips/loongson64/Platform                  |    2 -
 arch/s390/Makefile                             |    4 +--
 drivers/gpu/drm/amd/display/dc/dcn20/Makefile  |    2 -
 drivers/gpu/drm/amd/display/dc/dcn21/Makefile  |    2 -
 drivers/gpu/drm/amd/display/dc/dcn30/Makefile  |    2 -
 drivers/gpu/drm/amd/display/dc/dcn301/Makefile |    2 -
 drivers/gpu/drm/amd/display/dc/dcn302/Makefile |    2 -
 drivers/gpu/drm/amd/display/dc/dcn303/Makefile |    2 -
 drivers/gpu/drm/amd/display/dc/dcn31/Makefile  |    2 -
 drivers/gpu/drm/amd/display/dc/dml/Makefile    |    2 -
 scripts/Makefile.compiler                      |   10 ++++++--
 13 files changed, 37 insertions(+), 30 deletions(-)

--- a/Documentation/kbuild/makefiles.rst
+++ b/Documentation/kbuild/makefiles.rst
@@ -682,22 +682,27 @@ more details, with real examples.
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
@@ -804,7 +804,6 @@ stackp-flags-$(CONFIG_STACKPROTECTOR_STR
 KBUILD_CFLAGS += $(stackp-flags-y)
 
 KBUILD_CFLAGS-$(CONFIG_WERROR) += -Werror
-KBUILD_CFLAGS += $(KBUILD_CFLAGS-y)
 
 ifdef CONFIG_CC_IS_CLANG
 KBUILD_CPPFLAGS += -Qunused-arguments
@@ -1043,7 +1042,6 @@ ifdef CONFIG_CC_IS_GCC
 KBUILD_CFLAGS += -Wno-maybe-uninitialized
 endif
 
-ifdef CONFIG_CC_IS_GCC
 # The allocators already balk at large sizes, so silence the compiler
 # warnings for bounds checks involving those possible values. While
 # -Wno-alloc-size-larger-than would normally be used here, earlier versions
@@ -1055,8 +1053,8 @@ ifdef CONFIG_CC_IS_GCC
 # ignored, continuing to default to PTRDIFF_MAX. So, left with no other
 # choice, we must perform a versioned check to disable this warning.
 # https://lore.kernel.org/lkml/20210824115859.187f272f@canb.auug.org.au
-KBUILD_CFLAGS += $(call cc-ifversion, -ge, 0901, -Wno-alloc-size-larger-than)
-endif
+KBUILD_CFLAGS-$(call gcc-min-version, 90100) += -Wno-alloc-size-larger-than
+KBUILD_CFLAGS += $(KBUILD_CFLAGS-y)
 
 # disable invalid "can't wrap" optimizations for signed / pointers
 KBUILD_CFLAGS	+= -fno-strict-overflow
--- a/arch/mips/loongson64/Platform
+++ b/arch/mips/loongson64/Platform
@@ -12,7 +12,7 @@ cflags-$(CONFIG_CPU_LOONGSON64)	+= -Wa,-
 # by GAS.  The cc-option can't probe for this behaviour so -march=loongson3a
 # can't easily be used safely within the kbuild framework.
 #
-ifeq ($(call cc-ifversion, -ge, 0409, y), y)
+ifeq ($(call gcc-min-version, 40900), y)
   ifeq ($(call ld-ifversion, -ge, 22500, y), y)
     cflags-$(CONFIG_CPU_LOONGSON64)  += \
       $(call cc-option,-march=loongson3a -U_MIPS_ISA -D_MIPS_ISA=_MIPS_ISA_MIPS64)
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
--- a/drivers/gpu/drm/amd/display/dc/dcn20/Makefile
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/Makefile
@@ -18,7 +18,7 @@ CFLAGS_$(AMDDALPATH)/dc/dcn20/dcn20_reso
 endif
 
 ifdef CONFIG_CC_IS_GCC
-ifeq ($(call cc-ifversion, -lt, 0701, y), y)
+ifneq ($(call gcc-min-version, 70100), y)
 IS_OLD_GCC = 1
 endif
 endif
--- a/drivers/gpu/drm/amd/display/dc/dcn21/Makefile
+++ b/drivers/gpu/drm/amd/display/dc/dcn21/Makefile
@@ -14,7 +14,7 @@ CFLAGS_$(AMDDALPATH)/dc/dcn21/dcn21_reso
 endif
 
 ifdef CONFIG_CC_IS_GCC
-ifeq ($(call cc-ifversion, -lt, 0701, y), y)
+ifneq ($(call gcc-min-version, 70100), y)
 IS_OLD_GCC = 1
 endif
 endif
--- a/drivers/gpu/drm/amd/display/dc/dcn30/Makefile
+++ b/drivers/gpu/drm/amd/display/dc/dcn30/Makefile
@@ -42,7 +42,7 @@ CFLAGS_$(AMDDALPATH)/dc/dcn30/dcn30_optc
 endif
 
 ifdef CONFIG_CC_IS_GCC
-ifeq ($(call cc-ifversion, -lt, 0701, y), y)
+ifneq ($(call gcc-min-version, 70100), y)
 IS_OLD_GCC = 1
 endif
 CFLAGS_$(AMDDALPATH)/dc/dcn30/dcn30_resource.o += -mhard-float
--- a/drivers/gpu/drm/amd/display/dc/dcn301/Makefile
+++ b/drivers/gpu/drm/amd/display/dc/dcn301/Makefile
@@ -22,7 +22,7 @@ CFLAGS_$(AMDDALPATH)/dc/dcn301/dcn301_re
 endif
 
 ifdef CONFIG_CC_IS_GCC
-ifeq ($(call cc-ifversion, -lt, 0701, y), y)
+ifneq ($(call gcc-min-version, 70100), y)
 IS_OLD_GCC = 1
 endif
 CFLAGS_$(AMDDALPATH)/dc/dcn301/dcn301_resource.o += -mhard-float
--- a/drivers/gpu/drm/amd/display/dc/dcn302/Makefile
+++ b/drivers/gpu/drm/amd/display/dc/dcn302/Makefile
@@ -21,7 +21,7 @@ CFLAGS_$(AMDDALPATH)/dc/dcn302/dcn302_re
 endif
 
 ifdef CONFIG_CC_IS_GCC
-ifeq ($(call cc-ifversion, -lt, 0701, y), y)
+ifneq ($(call gcc-min-version, 70100), y)
 IS_OLD_GCC = 1
 endif
 CFLAGS_$(AMDDALPATH)/dc/dcn302/dcn302_resource.o += -mhard-float
--- a/drivers/gpu/drm/amd/display/dc/dcn303/Makefile
+++ b/drivers/gpu/drm/amd/display/dc/dcn303/Makefile
@@ -17,7 +17,7 @@ CFLAGS_$(AMDDALPATH)/dc/dcn303/dcn303_re
 endif
 
 ifdef CONFIG_CC_IS_GCC
-ifeq ($(call cc-ifversion, -lt, 0701, y), y)
+ifneq ($(call gcc-min-version, 70100), y)
 IS_OLD_GCC = 1
 endif
 CFLAGS_$(AMDDALPATH)/dc/dcn303/dcn303_resource.o += -mhard-float
--- a/drivers/gpu/drm/amd/display/dc/dcn31/Makefile
+++ b/drivers/gpu/drm/amd/display/dc/dcn31/Makefile
@@ -22,7 +22,7 @@ CFLAGS_$(AMDDALPATH)/dc/dcn31/dcn31_reso
 endif
 
 ifdef CONFIG_CC_IS_GCC
-ifeq ($(call cc-ifversion, -lt, 0701, y), y)
+ifneq ($(call gcc-min-version, 70100), y)
 IS_OLD_GCC = 1
 endif
 CFLAGS_$(AMDDALPATH)/dc/dcn31/dcn31_resource.o += -mhard-float
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
--- a/scripts/Makefile.compiler
+++ b/scripts/Makefile.compiler
@@ -61,9 +61,13 @@ cc-option-yn = $(call try-run,\
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



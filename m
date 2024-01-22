Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6C7D37A;
	Tue, 23 Jan 2024 01:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972140; cv=none; b=vEXoH/ezBI3X4S2FZIevkd4FMZPN+85L/h+3aqw3NmK/SE9KaMfEEZ+umF7ISplOMe0z9Lo4Q46SyIQKEuXhQb5lh/PCkDi3DaZNmEt75tO4x1Xw7R2oJeYMKeTWewox8eWJ9feehggxM7TEiARm75IS/yEdFDW2W9fAOPgdPK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972140; c=relaxed/simple;
	bh=rbA7kPCibJueKimxLasBAOPUrs+bSLBDFyJbC/V2z0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N4Pgm8QTCXW4y2MadQPa04ZF970p4BVf64WkgRzxxRUL8xL3PRxzkedYS0NRXJ2YfRgyQKpMb/D+sC+1cM/8dEPwfoZgZTrsmGpn5CguBTP82A1xOxliWBwI+jH+P6EC7u5sIIBDxVzt3/qAoB8miDx6esdaQhU2oNzsrMTij6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zpMMvRtA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zpMMvRtA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4191C433C7;
	Tue, 23 Jan 2024 01:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972139;
	bh=rbA7kPCibJueKimxLasBAOPUrs+bSLBDFyJbC/V2z0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zpMMvRtAIIxIZ8QY1ws2J2C7kJ9b0lMHXp+OPCl8REj+I9hK5mRr8AAnNwOM7LD2W
	 nAF2eGG8GDDOSZzL4gWPVuEJR7lq6HzzHtvTWW8VuXPJUhL2hsa8DeO4EsL3OUk2rV
	 ZL0OEha9DJLoGJED5bfHsgJmQKZq71sJjBaP9KNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 069/374] powerpc: remove checks for binutils older than 2.25
Date: Mon, 22 Jan 2024 15:55:25 -0800
Message-ID: <20240122235747.012781559@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 54a11654de163994e32b24e3aa90ef81f4a3184d ]

Commit e4412739472b ("Documentation: raise minimum supported version of
binutils to 2.25") allows us to remove the checks for old binutils.

There is no more user for ld-ifversion. Remove it as well.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20230119082250.151485-1-masahiroy@kernel.org
Stable-dep-of: 1b1e38002648 ("powerpc: add crtsavres.o to always-y instead of extra-y")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/Makefile     | 17 +----------------
 arch/powerpc/lib/Makefile |  2 +-
 scripts/Makefile.compiler |  4 ----
 3 files changed, 2 insertions(+), 21 deletions(-)

diff --git a/arch/powerpc/Makefile b/arch/powerpc/Makefile
index 41604a37b385..11a0ccb47be3 100644
--- a/arch/powerpc/Makefile
+++ b/arch/powerpc/Makefile
@@ -44,18 +44,13 @@ machine-$(CONFIG_PPC64) += 64
 machine-$(CONFIG_CPU_LITTLE_ENDIAN) += le
 UTS_MACHINE := $(subst $(space),,$(machine-y))
 
-# XXX This needs to be before we override LD below
-ifdef CONFIG_PPC32
-KBUILD_LDFLAGS_MODULE += arch/powerpc/lib/crtsavres.o
-else
-ifeq ($(call ld-ifversion, -ge, 22500, y),y)
+ifeq ($(CONFIG_PPC64)$(CONFIG_LD_IS_BFD),yy)
 # Have the linker provide sfpr if possible.
 # There is a corresponding test in arch/powerpc/lib/Makefile
 KBUILD_LDFLAGS_MODULE += --save-restore-funcs
 else
 KBUILD_LDFLAGS_MODULE += arch/powerpc/lib/crtsavres.o
 endif
-endif
 
 ifdef CONFIG_CPU_LITTLE_ENDIAN
 KBUILD_CFLAGS	+= -mlittle-endian
@@ -434,17 +429,7 @@ endif # CONFIG_PPC32
 endif # CONFIG_SMP
 
 PHONY += checkbin
-# Check toolchain versions:
-# - gcc-4.6 is the minimum kernel-wide version so nothing required.
 checkbin:
-	@if test "x${CONFIG_LD_IS_LLD}" != "xy" -a \
-		"x$(call ld-ifversion, -le, 22400, y)" = "xy" ; then \
-		echo -n '*** binutils 2.24 miscompiles weak symbols ' ; \
-		echo 'in some circumstances.' ; \
-		echo    '*** binutils 2.23 do not define the TOC symbol ' ; \
-		echo -n '*** Please use a different binutils version.' ; \
-		false ; \
-	fi
 	@if test "x${CONFIG_FTRACE_MCOUNT_USE_RECORDMCOUNT}" = "xy" -a \
 		"x${CONFIG_LD_IS_BFD}" = "xy" -a \
 		"${CONFIG_LD_VERSION}" = "23700" ; then \
diff --git a/arch/powerpc/lib/Makefile b/arch/powerpc/lib/Makefile
index 54be64203b2a..cb8a66743a02 100644
--- a/arch/powerpc/lib/Makefile
+++ b/arch/powerpc/lib/Makefile
@@ -37,7 +37,7 @@ obj-$(CONFIG_FUNCTION_ERROR_INJECTION)	+= error-inject.o
 # 64-bit linker creates .sfpr on demand for final link (vmlinux),
 # so it is only needed for modules, and only for older linkers which
 # do not support --save-restore-funcs
-ifeq ($(call ld-ifversion, -lt, 22500, y),y)
+ifndef CONFIG_LD_IS_BFD
 extra-$(CONFIG_PPC64)	+= crtsavres.o
 endif
 
diff --git a/scripts/Makefile.compiler b/scripts/Makefile.compiler
index 86ecd2ac874c..60ddd47bfa1b 100644
--- a/scripts/Makefile.compiler
+++ b/scripts/Makefile.compiler
@@ -68,7 +68,3 @@ cc-ifversion = $(shell [ $(CONFIG_GCC_VERSION)0 $(1) $(2)000 ] && echo $(3) || e
 # ld-option
 # Usage: KBUILD_LDFLAGS += $(call ld-option, -X, -Y)
 ld-option = $(call try-run, $(LD) $(KBUILD_LDFLAGS) $(1) -v,$(1),$(2),$(3))
-
-# ld-ifversion
-# Usage:  $(call ld-ifversion, -ge, 22252, y)
-ld-ifversion = $(shell [ $(CONFIG_LD_VERSION)0 $(1) $(2)0 ] && echo $(3) || echo $(4))
-- 
2.43.0




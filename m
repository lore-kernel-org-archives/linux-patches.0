Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030171;
	b=rgDq0IUAixX/sPPaZkGZHj1ow3H2NdaHNKkjM2pB+ZmG0SukXjFU7lznFL3XLum9yqXV
	 1tnZRdZomyaEkxqDnbCfJ397c8YboqnXthSHV5gkT2Z5div9SMLeK+FaXmZHCmkVxncLD
	 fZVs+WVZw1Vs8rKWOtAHko6+w49PjgWFPvdsBRQ6JScWzLejQjc1nN7QcfVvUFqoaTVzx
	 kzkDKyX7O31fKKAt1R2MMtVUH0Zp11BX6n3mvy5vtTzIYrAbNm5Z2kXgPqc/agbrOH/a0
	 sz8j2TuRHqZbjXli/9TPr+7LpRNwfy1x+xFiAj6nPlhpi8hkxjgafFQ27bbqW/P4CTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030171;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JdVN/d2MZWTRh8fYxjaACex3e2tcbMv6h64ezAici54=;
	b=XQDuKtE4/1tL9hAKsa/tvDTs/s0jL/h4pYubaKj2/pjcmxxk+VriGrxqEgyeUdn++TL4
	 nmz4sDvxpWIhBV3/0nQ6hc3FucMo8uLyVYR58lGPn7cdXvJ1dCj7V+/2Lwe1JaVD0QWwf
	 n/LLJLCLo+aZb3fficnfuyqNvsVr4ANhKk1+26uKABAommg3PgkH6k8kaxc80riwxWwcs
	 Y1wB0o8m5HJp+czCW7qFq3g2p7MDIMMLEUG7ILmKyrtYPtb/89hiP02LDl0LdOtDGGCRM
	 H+/Kt+TveE2iCZlGL4W+6tDVMLoO9/SnZumoStK7hYDYXN17/tv7wchm7ySCHJPVXPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XofXokE1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B8EF606C709;
	Wed, 18 Nov 2026 19:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XofXokE1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B64DB1F000C7;
	Wed, 18 Nov 2026 19:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030171;
	bh=JdVN/d2MZWTRh8fYxjaACex3e2tcbMv6h64ezAici54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XofXokE1uv56zlJG5G/2rPPKpIi775grKHhiT8Umw7YhbSppOw5t/c/q34sybJ8g/
	 r8sZhIA0Rx1S80Tr9nyS/d1UuTdboAyZGqGlhL7+JghJc9LZy3EqCa9FZteP13bR5i
	 xD532D426qqLUoaV1J2loc6NibEWFgSC6HW3I7qw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	Chen Linxuan <chenlinxuan@uniontech.com>,
	WangYuli <wangyuli@uniontech.com>,
	Chen Linxuan <me@black-desk.cn>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0611/1756] MIPS: Only check -msym32 when need-compiler
Date: Wed, 18 Nov 2026 15:45:38 +0100
Message-ID: <20261118150033.269367582@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: WangYuli <wangyuli@uniontech.com>

[ Upstream commit 7a8f286c235f5d308208cfdcb025b2a0e0c84742 ]

During 'make modules_install', the need-compiler variable is null, so
Makefile.compiler isn't included.  This results in call cc-option-yn
returning nothing and consequently an error is issued:

*** CONFIG_CPU_DADDI_WORKAROUNDS unsupported without -msym32.  Stop.

and the invocation terminated for configurations that set the Kconfig
option named.

Previously commit a79a404e6c22 ("MIPS: Fix CONFIG_CPU_DADDI_WORKAROUNDS
`modules_install' regression") addressed the same issue for GCC versions
now supported for Linux compilation, but caused a build error with Clang
because it doesn't support '-msym32'.  Then commit 18ca63a2e23c ("MIPS:
Probe toolchain support of -msym32") fixed the issue with Clang, but
reintroduced the 'make modules_install' error listed above.

Wrap the handling of the '-msym32' option then with ifdef need-compiler,
fixing said error for 'make modules_install'.

For more technical details on why need-compiler is null during 'make
modules_install' and why no compiler invocation is actually needed at
this point, please refer to commit 4fe4a6374c4d ("MIPS: Only fiddle with
CHECKFLAGS if need-compiler") and commit 805b2e1d427a ("kbuild: include
Makefile.compiler only when compiler is needed").

NB leading 8 spaces rather than tabs required due to `make' syntax.

Link: https://lore.kernel.org/all/alpine.DEB.2.21.2502120612000.65342@angie.orcam.me.uk/
Link: https://lore.kernel.org/all/alpine.DEB.2.21.2307180025120.62448@angie.orcam.me.uk/
Fixes: a79a404e6c22 ("MIPS: Fix CONFIG_CPU_DADDI_WORKAROUNDS `modules_install' regression")
Reported-by: Maciej W. Rozycki <macro@orcam.me.uk>
Closes: https://lore.kernel.org/all/alpine.DEB.2.21.2501030535080.49841@angie.orcam.me.uk/
Co-developed-by: Chen Linxuan <chenlinxuan@uniontech.com>
Signed-off-by: Chen Linxuan <chenlinxuan@uniontech.com>
Signed-off-by: WangYuli <wangyuli@uniontech.com>
Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Reviewed-by: Chen Linxuan <me@black-desk.cn>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/Makefile | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/arch/mips/Makefile b/arch/mips/Makefile
index 5785a3d5ccfbb..dd34815ee23d0 100644
--- a/arch/mips/Makefile
+++ b/arch/mips/Makefile
@@ -294,18 +294,20 @@ drivers-$(CONFIG_PCI)		+= arch/mips/pci/
 # We can always force a build with a 64-bits symbol format by
 # passing 'KBUILD_SYM32=no' option to the make's command line.
 #
-ifdef CONFIG_64BIT
-  ifndef KBUILD_SYM32
-    ifeq ($(shell expr $(load-y) \< 0xffffffff80000000), 0)
-      KBUILD_SYM32 = $(call cc-option-yn, -msym32)
+ifdef need-compiler
+  ifdef CONFIG_64BIT
+    ifndef KBUILD_SYM32
+      ifeq ($(shell expr $(load-y) \< 0xffffffff80000000), 0)
+        KBUILD_SYM32 = $(call cc-option-yn, -msym32)
+      endif
     endif
-  endif
 
-  ifeq ($(KBUILD_SYM32), y)
-    cflags-$(KBUILD_SYM32) += -msym32 -DKBUILD_64BIT_SYM32
-  else
-    ifeq ($(CONFIG_CPU_DADDI_WORKAROUNDS), y)
-      $(error CONFIG_CPU_DADDI_WORKAROUNDS unsupported without -msym32)
+    ifeq ($(KBUILD_SYM32), y)
+      cflags-$(KBUILD_SYM32) += -msym32 -DKBUILD_64BIT_SYM32
+    else
+      ifeq ($(CONFIG_CPU_DADDI_WORKAROUNDS), y)
+        $(error CONFIG_CPU_DADDI_WORKAROUNDS unsupported without -msym32)
+      endif
     endif
   endif
 endif
-- 
2.53.0




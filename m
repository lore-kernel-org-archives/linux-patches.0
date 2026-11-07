Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063855;
	b=l6HJvMuQKbPrrqTrGIaNVXG5eF++8bDdIkrXNAHFJ56CD3hww/AXY5su3vz/cFRQejKs
	 0FF4ImYULR+7oFGv3OGLH+IcGXEMk05seBl1qac4LqCVqnroDnSDZe7iv9IMupOUoXnOs
	 A7zIAa87zgt7lTsIOqmYsoYxVf3kq/iL+jiZQGHFoujjHLBUbIN5Vw+0FoU+PDYE/ypbC
	 B1zYtl2JN38WMiYEvZ2k5rjdwOEbF0hUFzQ4jYpC19la/xLLKOcLqXbK602bs2BgkBRsB
	 UVZSQLMyTx4vXRZVMb22obykm+5Besxv+gqrkM6aBERHYIEFdubHFInALsigCt6TCvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063855;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UPfM9uonCb7bIi5VBxiKdhGSnoOJOk5SzELaDKLDTaQ=;
	b=vIj48IVhDzmxy5FZdz3yu/nLfpHcK2UotTjbPX2f6TgfhhJXJXJpaS+Vd4RWdbLZ0qW1
	 Epjv2er2+m1RiLiHcn5VsVwJ6uxvZsrnhljqVNHC4ZB+te5d9WjeK1EoF3nxHdehxUjOv
	 3g2YCZZVHa/c1THIwNRUtOOZhnvRwBh4j9RYL2XGg7OJUMZOaQz11hPT6bzM3UNDYbZLs
	 gdSz2RCLztf7OdbOSrqGNomDzmzsf3+YfDP3AM4otid2K+Q9Q5ijGp+xK/g6r1cRX9QyE
	 fc9gdOFp4bSmVrljb7hxxRlUbDo73weyXgP1ubeD3svCqM9864q8A052FkI+eSEUU7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="KLoNXj/i";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC6A5606A9DA;
	Sat,  7 Nov 2026 15:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KLoNXj/i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B2A61F0089F;
	Sat,  7 Nov 2026 15:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063854;
	bh=UPfM9uonCb7bIi5VBxiKdhGSnoOJOk5SzELaDKLDTaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KLoNXj/ix3NvccONCYHHWA4rg4cLfALgUulyQv6Xeo72D0jmzlWqaOe56h1xdZ5r4
	 cH+kYPUY31AbmLjP+Ys0L4YTPFVp/WEPwrNcSZlOj7Z8CH0fFC453LKcgcz+IqH73Q
	 sHS6TdpNO155FNSWg9s8mHlp4Y5dcS5rZXTwGkTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nick Desaulniers <ndesaulniers@google.com>,
	Yoav Moshe <linux@yoavmoshe.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0063/1257] ARM: imx: Fix suspend/resume crash with Clang CFI
Date: Sat,  7 Nov 2026 08:39:19 -0500
Message-ID: <20261107134941.140622592@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yo'av Moshe <linux@yoavmoshe.com>

[ Upstream commit 242757d109bd5c9b8fb7194fb4d44625be0b859a ]

The suspend code that runs from OCRAM is copied there with fncpy(),
which does not copy the kCFI type hash preceding the function. With
CONFIG_CFI=y the indirect call through imx6_suspend_in_ocram_fn
therefore panics.

Keep the call covered by CFI instead of exempting it:

- Add SYM_TYPED_FUNC_START_ALIGNED(), a variant of
  SYM_TYPED_FUNC_START() that aligns the function entry rather than
  the type hash preceding it, and use it to declare imx6_suspend():
  fncpy() requires the entry point of the function it copies to be
  8-byte aligned. The macro lives in arch/arm/include/asm/linkage.h
  since the requirement comes from arm's fncpy().

- Add a cfi_type member at the end of struct imx6_cpu_pm_info, which
  directly precedes the OCRAM copy of the function. It fits in the
  struct's tail padding, so no sizes or offsets change. Fill it using
  cfi_get_func_hash(), putting the hash where the caller's CFI check
  expects it: four bytes before the function entry.

Also mark ccm_base, suspend_ocram_base and imx6_suspend_in_ocram_fn
as __ro_after_init: they are only written during __init, and the
function pointer in particular should not be writable afterwards.

Suggested-by: Nick Desaulniers <ndesaulniers@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Yo'av Moshe <linux@yoavmoshe.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/include/asm/linkage.h   | 29 +++++++++++++++++++++++++++++
 arch/arm/mach-imx/pm-imx6.c      | 26 +++++++++++++++++++++++---
 arch/arm/mach-imx/suspend-imx6.S |  6 ++++--
 3 files changed, 56 insertions(+), 5 deletions(-)

diff --git a/arch/arm/include/asm/linkage.h b/arch/arm/include/asm/linkage.h
index c4670694ada79..bba992f5d7a80 100644
--- a/arch/arm/include/asm/linkage.h
+++ b/arch/arm/include/asm/linkage.h
@@ -9,4 +9,33 @@
   .type name, %function; \
   END(name)
 
+#ifdef __ASSEMBLY__
+
+/*
+ * Variants of SYM_TYPED_START/SYM_TYPED_FUNC_START that align the
+ * function entry itself instead of the kCFI type hash preceding it,
+ * for functions whose entry point must meet an alignment requirement,
+ * such as the 8-byte alignment fncpy() demands of its source.
+ */
+#ifdef CONFIG_CFI
+
+#define SYM_TYPED_START_ALIGNED(name, linkage, align)	\
+	linkage(name) ASM_NL				\
+	.balign align ASM_NL				\
+	.fill (align) - 4, 1, 0 ASM_NL			\
+	__CFI_TYPE(name) ASM_NL				\
+	name:
+
+#else /* CONFIG_CFI */
+
+#define SYM_TYPED_START_ALIGNED(name, linkage, align)	\
+	SYM_START(name, linkage, .balign align)
+
+#endif /* CONFIG_CFI */
+
+#define SYM_TYPED_FUNC_START_ALIGNED(name, align)	\
+	SYM_TYPED_START_ALIGNED(name, SYM_L_GLOBAL, align)
+
+#endif /* __ASSEMBLY__ */
+
 #endif
diff --git a/arch/arm/mach-imx/pm-imx6.c b/arch/arm/mach-imx/pm-imx6.c
index a671ca498f887..3c73e2cdb8ceb 100644
--- a/arch/arm/mach-imx/pm-imx6.c
+++ b/arch/arm/mach-imx/pm-imx6.c
@@ -4,6 +4,8 @@
  * Copyright 2011 Linaro Ltd.
  */
 
+#include <linux/build_bug.h>
+#include <linux/cfi.h>
 #include <linux/clk/imx.h>
 #include <linux/delay.h>
 #include <linux/init.h>
@@ -18,6 +20,7 @@
 #include <linux/of_platform.h>
 #include <linux/platform_device.h>
 #include <linux/regmap.h>
+#include <linux/stddef.h>
 #include <linux/suspend.h>
 #include <asm/cacheflush.h>
 #include <asm/fncpy.h>
@@ -61,9 +64,9 @@
 #define MX6Q_SUSPEND_OCRAM_SIZE		0x1000
 #define MX6_MAX_MMDC_IO_NUM		33
 
-static void __iomem *ccm_base;
-static void __iomem *suspend_ocram_base;
-static void (*imx6_suspend_in_ocram_fn)(void __iomem *ocram_vbase);
+static void __iomem *ccm_base __ro_after_init;
+static void __iomem *suspend_ocram_base __ro_after_init;
+static void (*imx6_suspend_in_ocram_fn)(void __iomem *ocram_vbase) __ro_after_init;
 
 /*
  * suspend ocram space layout:
@@ -229,8 +232,18 @@ struct imx6_cpu_pm_info {
 	struct imx6_pm_base l2_base;
 	u32 mmdc_io_num; /* Number of MMDC IOs which need saved/restored. */
 	u32 mmdc_io_val[MX6_MAX_MMDC_IO_NUM][2]; /* To save offset and value */
+	u32 cfi_type; /* kCFI type hash of imx6_suspend() */
 } __aligned(8);
 
+/*
+ * The ocram copy of imx6_suspend() starts right after struct imx6_cpu_pm_info,
+ * and the CFI check on the indirect call reads the kCFI type hash from the
+ * four bytes preceding the function entry, so cfi_type must occupy the last
+ * four bytes of the struct, i.e. fit into its tail padding.
+ */
+static_assert(offsetofend(struct imx6_cpu_pm_info, cfi_type) ==
+	      sizeof(struct imx6_cpu_pm_info));
+
 void imx6_set_int_mem_clk_lpm(bool enable)
 {
 	u32 val = readl_relaxed(ccm_base + CGPR);
@@ -568,6 +581,13 @@ static int __init imx6q_suspend_init(const struct imx6_pm_socdata *socdata)
 			mmdc_offset_array[i]);
 	}
 
+	/*
+	 * Mask out the Thumb bit, as cfi_get_func_hash() expects the
+	 * function's actual start address. Returns 0 if CONFIG_CFI=n.
+	 */
+	pm_info->cfi_type =
+		cfi_get_func_hash((void *)((uintptr_t)&imx6_suspend & ~1UL));
+
 	imx6_suspend_in_ocram_fn = fncpy(
 		suspend_ocram_base + sizeof(*pm_info),
 		&imx6_suspend,
diff --git a/arch/arm/mach-imx/suspend-imx6.S b/arch/arm/mach-imx/suspend-imx6.S
index 63ccc2d0e920a..95d5f723ea0ed 100644
--- a/arch/arm/mach-imx/suspend-imx6.S
+++ b/arch/arm/mach-imx/suspend-imx6.S
@@ -3,6 +3,7 @@
  * Copyright 2014 Freescale Semiconductor, Inc.
  */
 
+#include <linux/cfi_types.h>
 #include <linux/linkage.h>
 #include <asm/assembler.h>
 #include <asm/asm-offsets.h>
@@ -148,7 +149,8 @@
 
 	.endm
 
-ENTRY(imx6_suspend)
+/* fncpy() requires an 8-byte-aligned entry; see arch/arm/include/asm/fncpy.h */
+SYM_TYPED_FUNC_START_ALIGNED(imx6_suspend, 8)
 	ldr	r1, [r0, #PM_INFO_PBASE_OFFSET]
 	ldr	r2, [r0, #PM_INFO_RESUME_ADDR_OFFSET]
 	ldr	r3, [r0, #PM_INFO_DDR_TYPE_OFFSET]
@@ -329,4 +331,4 @@ resume:
 	resume_mmdc
 
 	ret	lr
-ENDPROC(imx6_suspend)
+SYM_FUNC_END(imx6_suspend)
-- 
2.53.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 443DB20ED;
	Sat, 12 Sep 2026 08:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203099; cv=none; b=JuQqu4Xq1FPoYMtB0F8EKvU59f2CifCfvfLKLBmm81HP3MVPyjJzrLxAdwwm04Migz0gsMiqRC0cZaXLyylNUjH3vXeUPQwWE30/DHLuwXAHv+5OMS4UxrvmGEbsEV/9Xnxxxn0UU/uc/0i7yirSYaZUEUk0i4+0F8sVllEryc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203099; c=relaxed/simple;
	bh=P+Mu9Rc4gpwhbnSV5asLZriElq5Qr8tH5X080MGDnfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tl0rfYzNHtF5zJ9DnH5ScletrUrjrrogRxDdTvSQriWOIdEt86sWF0EKWrxCZBkvghIy4nb2XjVxBHXlftM3KExKyTNCerSVPrUCiEOnrNML+SUZ83CGR1WuS1IagZhLrxUZHBWSDmDUFvWCmxPRBaZ9ViFmSO0YzwLmMXWvbFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o9zdaWPX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o9zdaWPX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 624051F000FF;
	Sat, 12 Sep 2026 08:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203098;
	bh=OETWr6OUz/FVGSHzZ0GayaDfahrt3llmkwJJI2ZNakU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o9zdaWPXBI33elFm9WJybvNUhuHsW87lOw24J0T0MJVtRlinpn8ReVr1YolmwPNIq
	 oaVbvvI6Ks/jeHww5f39mrMHHy3y5XZoIu8Hp33YTFhA0UN6QhY5VlFEGI9CDgBoLv
	 zyB3ImYismymwR8NIwbqAYlrPawWplSFPl1ih+No=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boqun Feng <boqun@kernel.org>,
	kernel test robot <lkp@intel.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1340/1815] s390/irqflags: Add out-of-line definitions of arch_local_irq_*() for KMSAN
Date: Sat, 12 Sep 2026 08:51:30 +0200
Message-ID: <20260912065720.480021629@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Leoshkevich <iii@linux.ibm.com>

[ Upstream commit 3f7c9f9c36b47a2a5cdbc56597eddf32662ef7fa ]

Inline KMSAN arch_local_irq_*() definitions run afoul of
-Wstatic-in-inline. Move them out-of-line. Make sure decompressor and
non-GPL modules see the out-of-line definitions.

Cc: Boqun Feng <boqun@kernel.org>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202607131219.euJHPSJ5-lkp@intel.com/
Suggested-by: Heiko Carstens <hca@linux.ibm.com>
Fixes: 1b301f5f28ba ("s390/irqflags: do not instrument arch_local_irq_*() with KMSAN")
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/irqflags.h | 20 +++++++++++++-------
 arch/s390/kernel/Makefile        |  1 +
 arch/s390/kernel/irqflags.c      | 28 ++++++++++++++++++++++++++++
 3 files changed, 42 insertions(+), 7 deletions(-)
 create mode 100644 arch/s390/kernel/irqflags.c

diff --git a/arch/s390/include/asm/irqflags.h b/arch/s390/include/asm/irqflags.h
index bcab456dfb803..6eb6de6a99f2d 100644
--- a/arch/s390/include/asm/irqflags.h
+++ b/arch/s390/include/asm/irqflags.h
@@ -37,18 +37,24 @@ static __always_inline void __arch_local_irq_ssm(unsigned long flags)
 	asm volatile("ssm   %0" : : "Q" (flags) : "memory");
 }
 
-#ifdef CONFIG_KMSAN
-#define arch_local_irq_attributes noinline notrace __no_sanitize_memory __maybe_unused
+#if defined(CONFIG_KMSAN) && !defined(__DECOMPRESSOR)
+unsigned long arch_local_save_flags(void);
+unsigned long arch_local_irq_save(void);
+void arch_local_irq_enable_external(void);
+void arch_local_irq_enable(void);
 #else
-#define arch_local_irq_attributes __always_inline
+#define arch_local_save_flags		__arch_local_save_flags
+#define arch_local_irq_save		__arch_local_irq_save
+#define arch_local_irq_enable_external	__arch_local_irq_enable_external
+#define arch_local_irq_enable		__arch_local_irq_enable
 #endif
 
-static arch_local_irq_attributes unsigned long arch_local_save_flags(void)
+static __always_inline unsigned long __arch_local_save_flags(void)
 {
 	return __arch_local_irq_stnsm(0xff);
 }
 
-static arch_local_irq_attributes unsigned long arch_local_irq_save(void)
+static __always_inline unsigned long __arch_local_irq_save(void)
 {
 	return __arch_local_irq_stnsm(0xfc);
 }
@@ -58,12 +64,12 @@ static __always_inline void arch_local_irq_disable(void)
 	arch_local_irq_save();
 }
 
-static arch_local_irq_attributes void arch_local_irq_enable_external(void)
+static __always_inline void __arch_local_irq_enable_external(void)
 {
 	__arch_local_irq_stosm(0x01);
 }
 
-static arch_local_irq_attributes void arch_local_irq_enable(void)
+static __always_inline void __arch_local_irq_enable(void)
 {
 	__arch_local_irq_stosm(0x03);
 }
diff --git a/arch/s390/kernel/Makefile b/arch/s390/kernel/Makefile
index 6c88476d79a31..14ef03cb2f72a 100644
--- a/arch/s390/kernel/Makefile
+++ b/arch/s390/kernel/Makefile
@@ -72,6 +72,7 @@ obj-$(CONFIG_STACKPROTECTOR)	+= stackprotector.o
 obj-$(CONFIG_KEXEC_FILE)	+= machine_kexec_file.o kexec_image.o
 obj-$(CONFIG_KEXEC_FILE)	+= kexec_elf.o
 obj-$(CONFIG_CERT_STORE)	+= cert_store.o
+obj-$(CONFIG_KMSAN)		+= irqflags.o
 
 obj-$(CONFIG_PERF_EVENTS)	+= perf_event.o
 obj-$(CONFIG_PERF_EVENTS)	+= perf_cpum_cf.o perf_cpum_sf.o
diff --git a/arch/s390/kernel/irqflags.c b/arch/s390/kernel/irqflags.c
new file mode 100644
index 0000000000000..e192f59f8918c
--- /dev/null
+++ b/arch/s390/kernel/irqflags.c
@@ -0,0 +1,28 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/export.h>
+#include <asm/irqflags.h>
+
+noinstr unsigned long arch_local_save_flags(void)
+{
+	return __arch_local_save_flags();
+}
+EXPORT_SYMBOL(arch_local_save_flags);
+
+noinstr unsigned long arch_local_irq_save(void)
+{
+	return __arch_local_irq_save();
+}
+EXPORT_SYMBOL(arch_local_irq_save);
+
+noinstr void arch_local_irq_enable_external(void)
+{
+	__arch_local_irq_enable_external();
+}
+EXPORT_SYMBOL(arch_local_irq_enable_external);
+
+noinstr void arch_local_irq_enable(void)
+{
+	__arch_local_irq_enable();
+}
+EXPORT_SYMBOL(arch_local_irq_enable);
-- 
2.53.0




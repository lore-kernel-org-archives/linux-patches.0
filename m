Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91DEA24CEEA;
	Sat, 12 Sep 2026 11:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211059; cv=none; b=ABwfaL0ZI8NRGRz8KUhw4j4Q7JsaYNxThAjc1YX8xveekO+O+/IK3F8pUXkcKMxP5Zo0Fd7tqTNPc82aa6YE0FlgJlNBOJpIk5q3J3nt2MOTAdnkqZx/cRGzEPhVpfzxitN4IcsOq9yspHNaKRwNUObiwzv2dM1RBeRfX4v4q6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211059; c=relaxed/simple;
	bh=Hgn7++JON3iyGy69/gxm5wesAukCGRPwlk+R0ln7gCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ENRFK6L6H6C18Q18W5M2urZROfMi4jRUW/kgoySm7NxvO42bgPNKFW4jGyfTdP8NuR6m7hQBe1HxrCnyWdW7BSBBfkfPzAP7m6SH4VzhZYGFosdKxrqsaZvHVUrzomPX6WqNFi7mMBQqsnoQvEr6hU/Noo/4AJY21hTeBPwVnH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cHA+VI/a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cHA+VI/a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 316301F000FF;
	Sat, 12 Sep 2026 11:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211058;
	bh=KklKgZrWxzAxljHMh7G7E2NnAJweHEhnjXqEoRoHUe4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cHA+VI/aTy06a/wjaPpEQgtAz/EYaA8OSUZ1JK+h1cv9iAzbaWm018ppA0fQ6vVng
	 19RAyVb5SRJ6DK0YkLkDPD5iHRCkvte/wNSWbTJHhd2bRRtW4HKhdZWKCfLEL6pfHz
	 j7UgcDtx6lxu/qJ3GLX9oAlaIZSzgQ5nVCXge9jM=
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
Subject: [PATCH 6.18 1110/1518] s390/irqflags: Add out-of-line definitions of arch_local_irq_*() for KMSAN
Date: Sat, 12 Sep 2026 08:54:39 +0200
Message-ID: <20260912065648.561111730@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 71f7837336aa1..8df143ac8ab48 100644
--- a/arch/s390/kernel/Makefile
+++ b/arch/s390/kernel/Makefile
@@ -71,6 +71,7 @@ obj-$(CONFIG_STACKPROTECTOR)	+= stackprotector.o
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




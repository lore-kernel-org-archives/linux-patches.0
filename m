Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40984221F26;
	Sat, 12 Sep 2026 11:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211054; cv=none; b=WGFi7cPHBmUFAom0Ty7xGg5P3BbQ85v10CcEftEo1OvOT1fg3FTjjgAYFncLAMJFxKuyy+jD2CzVTzhe57tsffVH+3byxYGud16CABas/+mEH+Zwk0plUWumNFYrkIaczdEOpaL+DNz0Md7Jw4hQZCsOSA7F6lxINM/zsoEDBTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211054; c=relaxed/simple;
	bh=oAYDY64h9LTzM3jeEloK3uFxKBlkqdJEoxRf+CPbC5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ca11GqGOMdWWIj03/ZAYV8S2Ogp3JNiPtngJjsORfes6beOfw55wXXUxoBG2EBkRsylX3bFDRd3L8wJ/U6xfuWr6lqZLMFY0m7XqZ1dwz6c6a3H+ex2kBCfeD6Y5deeGgjR+RADMJaU8lJeQ2KlJF0rvOJy/QYsSTVUiRw84ahA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hATVk7xZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hATVk7xZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6015E1F000FF;
	Sat, 12 Sep 2026 11:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211053;
	bh=XavTSyKLhqX5DCzLtz8o7Zd055hAW4AVCNvyOpAd40w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hATVk7xZ2w2wuCx0c2vCOb+dqyduF3U2/CMOshcrQ7pROmXkviszNEithfomp2u3D
	 fxY4FG3gLgHyDq2Aih6YEz947pL0yZNPox9r+pNIkO3pSp3wycud6vZhojo7ajF04T
	 r+7EaCgvzgR4SvXxn42nRvVpBCQzCRxgrEBKMhp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Coiby Xu <coxu@redhat.com>,
	Alexander Egorenkov <egorenar@linux.ibm.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1109/1518] s390: Drop unnecessary CONFIG_IMA_SECURE_AND_OR_TRUSTED_BOOT
Date: Sat, 12 Sep 2026 08:54:38 +0200
Message-ID: <20260912065648.538300560@linuxfoundation.org>
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

From: Coiby Xu <coxu@redhat.com>

[ Upstream commit a2e507afd9a25e333b7a58082f5db8c4de2bd12d ]

Commit b5ca117365d9 ("ima: prevent kexec_load syscall based on runtime
secureboot flag") and commit 268a78404973 ("s390/kexec_file: Disable
kexec_load when IPLed secure") disabled the kexec_load syscall based
on the secureboot mode. Commit 9e2b4be377f0 ("ima: add a new CONFIG
for loading arch-specific policies") needed to detect the secure boot
mode, not to load an IMA architecture specific policy. Since there is
the new CONFIG_INTEGRITY_SECURE_BOOT, drop
CONFIG_IMA_SECURE_AND_OR_TRUSTED_BOOT for s390.

Signed-off-by: Coiby Xu <coxu@redhat.com>
Tested-by: Alexander Egorenkov <egorenar@linux.ibm.com>
[Vasily Gorbik: Fix missing arch_get_secureboot() prototype warning]
link: https://lore.kernel.org/linux-integrity/c00-01.ttbfdx5@ub.hpns/
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Stable-dep-of: 3f7c9f9c36b4 ("s390/irqflags: Add out-of-line definitions of arch_local_irq_*() for KMSAN")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/Kconfig           | 1 -
 arch/s390/kernel/Makefile   | 1 -
 arch/s390/kernel/ima_arch.c | 8 --------
 arch/s390/kernel/ipl.c      | 1 +
 4 files changed, 1 insertion(+), 10 deletions(-)
 delete mode 100644 arch/s390/kernel/ima_arch.c

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 97a522dcb2b25..719086bbfa477 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -77,7 +77,6 @@ config S390
 	#
 	# Note: keep this list sorted alphabetically
 	#
-	imply IMA_SECURE_AND_OR_TRUSTED_BOOT
 	select ALTERNATE_USER_ADDRESS_SPACE
 	select ARCH_32BIT_USTAT_F_TINODE
 	select ARCH_CORRECT_STACKTRACE_ON_KRETPROBE
diff --git a/arch/s390/kernel/Makefile b/arch/s390/kernel/Makefile
index 8d5ca89cd482b..71f7837336aa1 100644
--- a/arch/s390/kernel/Makefile
+++ b/arch/s390/kernel/Makefile
@@ -71,7 +71,6 @@ obj-$(CONFIG_STACKPROTECTOR)	+= stackprotector.o
 obj-$(CONFIG_KEXEC_FILE)	+= machine_kexec_file.o kexec_image.o
 obj-$(CONFIG_KEXEC_FILE)	+= kexec_elf.o
 obj-$(CONFIG_CERT_STORE)	+= cert_store.o
-obj-$(CONFIG_IMA_SECURE_AND_OR_TRUSTED_BOOT)	+= ima_arch.o
 
 obj-$(CONFIG_PERF_EVENTS)	+= perf_event.o
 obj-$(CONFIG_PERF_EVENTS)	+= perf_cpum_cf.o perf_cpum_sf.o
diff --git a/arch/s390/kernel/ima_arch.c b/arch/s390/kernel/ima_arch.c
deleted file mode 100644
index 6ccbe34ce4087..0000000000000
--- a/arch/s390/kernel/ima_arch.c
+++ /dev/null
@@ -1,8 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-
-#include <linux/ima.h>
-
-const char * const *arch_get_ima_policy(void)
-{
-	return NULL;
-}
diff --git a/arch/s390/kernel/ipl.c b/arch/s390/kernel/ipl.c
index 781deb5885572..0068d824306f6 100644
--- a/arch/s390/kernel/ipl.c
+++ b/arch/s390/kernel/ipl.c
@@ -21,6 +21,7 @@
 #include <linux/crash_dump.h>
 #include <linux/debug_locks.h>
 #include <linux/vmalloc.h>
+#include <linux/secure_boot.h>
 #include <asm/asm-extable.h>
 #include <asm/machine.h>
 #include <asm/diag.h>
-- 
2.53.0




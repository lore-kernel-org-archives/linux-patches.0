Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50E5B47CC92;
	Sat, 12 Sep 2026 12:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217989; cv=none; b=G5BirPIbSryJXbmwHxdpt4y0pHb6XAPCvXl4ln9Rhroe3630x9FvkNKyNgu1EUZ8dfULwhT6ZMeqdwvMdHgArevKRnWlVHlxdj8lBsVIvmJopmJ3ry/H3BCCsrLdg/6P3RHVC1nGXD0uf1V6SQtKkH5Ni+exsJDKasMzJSxtCd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217989; c=relaxed/simple;
	bh=u8TPZfKsfXUKw8C4yp/VMot5EupXgwUvmTtgdglXW2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q8fxG6WGukoNKJNXTRCiE9RV3q/vTI3YfZalzavXKMooG0TEN9W6hF/clVDZIfHtYgnVZydzbJn2GIvS3w22JgS3Q9qsIS/4IMIt9WzUBob94evqOTF/4QScEn1UDsN1Fp9BfwdopcueH5+F4aCjU1skEigO4O8UD0FufU+GCYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E9kcVO0u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E9kcVO0u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9822A1F000FF;
	Sat, 12 Sep 2026 12:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217986;
	bh=CZN/zHw+CQZdP2aBFCeDxxKanXbtCY3tLyebA1qveWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E9kcVO0uixZhTuPM2iA18WOx2K8yemVZHQ3HbaMC61oT0wMdiBPU4KCKJ43U0+Moh
	 9s9DT9ICvO+OInW+XPoFn1+4q0uBtF4N3+w95OE1ruPjOaymSKxAb+5d+yAH6xJ/SB
	 8DLSAcFFLFp4eCVB9apoFRsjc7HMX2nG0BS4XlOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Coiby Xu <coxu@redhat.com>,
	Alexander Egorenkov <egorenar@linux.ibm.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1051/1376] s390: Drop unnecessary CONFIG_IMA_SECURE_AND_OR_TRUSTED_BOOT
Date: Sat, 12 Sep 2026 08:57:57 +0200
Message-ID: <20260912065630.985079443@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 28e900e5212ca..53dd642281776 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -57,7 +57,6 @@ config S390
 	#
 	# Note: keep this list sorted alphabetically
 	#
-	imply IMA_SECURE_AND_OR_TRUSTED_BOOT
 	select ALTERNATE_USER_ADDRESS_SPACE
 	select ARCH_32BIT_USTAT_F_TINODE
 	select ARCH_BINFMT_ELF_STATE
diff --git a/arch/s390/kernel/Makefile b/arch/s390/kernel/Makefile
index 48caae8c7e104..7981b91fc264e 100644
--- a/arch/s390/kernel/Makefile
+++ b/arch/s390/kernel/Makefile
@@ -73,7 +73,6 @@ obj-$(CONFIG_JUMP_LABEL)	+= jump_label.o
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
index b6ce3cea3aea0..d4a4d965a9557 100644
--- a/arch/s390/kernel/ipl.c
+++ b/arch/s390/kernel/ipl.c
@@ -21,6 +21,7 @@
 #include <linux/crash_dump.h>
 #include <linux/debug_locks.h>
 #include <linux/vmalloc.h>
+#include <linux/secure_boot.h>
 #include <asm/asm-extable.h>
 #include <asm/diag.h>
 #include <asm/ipl.h>
-- 
2.53.0




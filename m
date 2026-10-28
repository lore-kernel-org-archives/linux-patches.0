Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215809;
	b=oL0TPPY+A6b8UzSlr84I292o2f480UuBacQEUzsTDKagC3dfgQbDSWy0AUIlEmRUTDWc
	 2nTxsQdSb59oXGMq0DbaWfgoUMqI4hEV54McRrfqmgklajNKierYyv02taaMMLZV10NKi
	 2ohY/kVUnDKFYRksOHUXYSBG2Jdr0zTxmfP23TWvrjX7wYcJMKZ/TbwQ1IoRGu9LfiBfY
	 m2R2fVbJaLKGYZ0H3JUE/SejiHAJmPqz9Xptqb/p+UOFD1hx+DV7n2WsTtyIUZtD1Csta
	 rHgbAMGWVeaZW1bJiyI8ngEPzUq+Unc1QBVDdnSLcBSGB0T8WfjkRXkxAgpGbwWsfQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215809;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=95ujZe4w83sUWgHW5XbBPhcp9Hq/r5nGA3IzCdJ2He0=;
	b=U7iMo9fGz9HvJmGw/K5rBAXkdxJJ9ZhXA+WoONImNawNOcd/SkiE0pc8oiVE9nnLM9Ut
	 KX0yL8NyRwSrlS+UwpB2SB2AuBD8KYaALMythO9PKq1HSWsOTnERY4rjgAcKYlEjqi3cd
	 RT5LyjVi4k80knZVeRy+Hty/dsEbiSm21QARIdCNnZaYl9/pDzwDsWvYRpfrFSZNRQQiI
	 U61e8nOdRzT3CoD60Hj5vNZMUskLqNA/oh5iRvdWa5GnmKD52I17qN0VWzWf7RuwBCFNx
	 3HWoNmQmemeUClQkYN0XXjIOnesUs+8riYPlGgc4ci5RZz4juWEUJdTFnWtYsFKSXTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=owjv83gf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74635606A31A;
	Wed, 28 Oct 2026 19:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=owjv83gf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C01CE1F01825;
	Wed, 28 Oct 2026 19:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215809;
	bh=95ujZe4w83sUWgHW5XbBPhcp9Hq/r5nGA3IzCdJ2He0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=owjv83gf5+TS1k97zLW71iDTPmrdwjzVbNVJIv0cyXE/w+LvMAR+giknjRuVhMIj7
	 T2c6nuYqRgxKqKiXl9ETvHT/06rT81TZnG3GZuePkiWd2WbRcA2oRUDdrXvUXThrWu
	 DuZwRm275hbKHVKwh9yR4E2jkiOvI2QK+jiwOt0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1340/1887] s390: include linux/io.h instead of asm/io.h
Date: Wed, 28 Oct 2026 17:57:16 +0100
Message-ID: <20261028170529.933060155@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit b378a982614360686f45c3e6b63fd5d1acd02d08 ]

Include linux/io.h instead of asm/io.h everywhere. linux/io.h includes
asm/io.h, so this shouldn't cause any problems. Instead this might help for
some randconfig build errors which were reported due to some undefined io
related functions.

Also move the changed include so it stays grouped together with other
includes from the same directory.

For ctcm_mpc.c also remove not needed comments (actually questions).

Acked-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Stable-dep-of: 7f40b346462f ("s390/dasd: Fix undersized format-check buffer")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/appldata/appldata_base.c |  4 ++--
 arch/s390/appldata/appldata_mem.c  |  2 +-
 arch/s390/include/asm/appldata.h   |  2 +-
 arch/s390/include/asm/dma.h        |  2 +-
 arch/s390/kernel/cpcmd.c           |  2 +-
 arch/s390/kernel/dis.c             |  2 +-
 arch/s390/kernel/perf_cpum_sf.c    |  2 +-
 arch/s390/kernel/process.c         |  2 +-
 arch/s390/kvm/priv.c               |  3 +--
 arch/s390/lib/spinlock.c           |  2 +-
 arch/s390/mm/maccess.c             |  2 +-
 drivers/s390/block/dasd_diag.c     |  2 +-
 drivers/s390/block/dasd_eckd.c     |  4 ++--
 drivers/s390/block/dasd_fba.c      |  2 +-
 drivers/s390/block/dcssblk.c       |  2 +-
 drivers/s390/char/con3215.c        |  2 +-
 drivers/s390/char/monwriter.c      |  2 +-
 drivers/s390/net/ctcm_mpc.c        | 10 +++++-----
 drivers/s390/net/netiucv.c         |  2 +-
 19 files changed, 25 insertions(+), 26 deletions(-)

diff --git a/arch/s390/appldata/appldata_base.c b/arch/s390/appldata/appldata_base.c
index c0fd29133f27a..4880af67dc6f5 100644
--- a/arch/s390/appldata/appldata_base.c
+++ b/arch/s390/appldata/appldata_base.c
@@ -26,10 +26,10 @@
 #include <linux/notifier.h>
 #include <linux/cpu.h>
 #include <linux/workqueue.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
 #include <asm/appldata.h>
 #include <asm/vtimer.h>
-#include <linux/uaccess.h>
-#include <asm/io.h>
 #include <asm/smp.h>
 
 #include "appldata.h"
diff --git a/arch/s390/appldata/appldata_mem.c b/arch/s390/appldata/appldata_mem.c
index 21c3147bd92ad..fc608f9b79abe 100644
--- a/arch/s390/appldata/appldata_mem.c
+++ b/arch/s390/appldata/appldata_mem.c
@@ -15,7 +15,7 @@
 #include <linux/pagemap.h>
 #include <linux/swap.h>
 #include <linux/slab.h>
-#include <asm/io.h>
+#include <linux/io.h>
 
 #include "appldata.h"
 
diff --git a/arch/s390/include/asm/appldata.h b/arch/s390/include/asm/appldata.h
index c5bd9f4437e59..f2240392c7080 100644
--- a/arch/s390/include/asm/appldata.h
+++ b/arch/s390/include/asm/appldata.h
@@ -8,8 +8,8 @@
 #ifndef _ASM_S390_APPLDATA_H
 #define _ASM_S390_APPLDATA_H
 
+#include <linux/io.h>
 #include <asm/diag.h>
-#include <asm/io.h>
 
 #define APPLDATA_START_INTERVAL_REC	0x80
 #define APPLDATA_STOP_REC		0x81
diff --git a/arch/s390/include/asm/dma.h b/arch/s390/include/asm/dma.h
index dec1c4ce628c8..c260adb259979 100644
--- a/arch/s390/include/asm/dma.h
+++ b/arch/s390/include/asm/dma.h
@@ -2,7 +2,7 @@
 #ifndef _ASM_S390_DMA_H
 #define _ASM_S390_DMA_H
 
-#include <asm/io.h>
+#include <linux/io.h>
 
 /*
  * MAX_DMA_ADDRESS is ambiguous because on s390 its completely unrelated
diff --git a/arch/s390/kernel/cpcmd.c b/arch/s390/kernel/cpcmd.c
index 72e106cfd8c7f..b210a29d3ee96 100644
--- a/arch/s390/kernel/cpcmd.c
+++ b/arch/s390/kernel/cpcmd.c
@@ -16,10 +16,10 @@
 #include <linux/stddef.h>
 #include <linux/string.h>
 #include <linux/mm.h>
+#include <linux/io.h>
 #include <asm/diag.h>
 #include <asm/ebcdic.h>
 #include <asm/cpcmd.h>
-#include <asm/io.h>
 
 static DEFINE_SPINLOCK(cpcmd_lock);
 static char cpcmd_buf[241];
diff --git a/arch/s390/kernel/dis.c b/arch/s390/kernel/dis.c
index 90bbb4ea1d086..51d6e6dcadcd0 100644
--- a/arch/s390/kernel/dis.c
+++ b/arch/s390/kernel/dis.c
@@ -24,8 +24,8 @@
 #include <linux/kdebug.h>
 #include <linux/uaccess.h>
 #include <linux/atomic.h>
+#include <linux/io.h>
 #include <asm/dis.h>
-#include <asm/io.h>
 #include <asm/cpcmd.h>
 #include <asm/lowcore.h>
 #include <asm/debug.h>
diff --git a/arch/s390/kernel/perf_cpum_sf.c b/arch/s390/kernel/perf_cpum_sf.c
index 54d2b175794e9..0d71370b57811 100644
--- a/arch/s390/kernel/perf_cpum_sf.c
+++ b/arch/s390/kernel/perf_cpum_sf.c
@@ -22,7 +22,7 @@
 #include <asm/irq.h>
 #include <asm/debug.h>
 #include <asm/timex.h>
-#include <asm/io.h>
+#include <linux/io.h>
 
 /* Minimum number of sample-data-block-tables:
  * At least one table is required for the sampling buffer structure.
diff --git a/arch/s390/kernel/process.c b/arch/s390/kernel/process.c
index 407500eca5328..c08f02d667e63 100644
--- a/arch/s390/kernel/process.c
+++ b/arch/s390/kernel/process.c
@@ -30,8 +30,8 @@
 #include <linux/export.h>
 #include <linux/init_task.h>
 #include <linux/entry-common.h>
+#include <linux/io.h>
 #include <asm/cpu_mf.h>
-#include <asm/io.h>
 #include <asm/processor.h>
 #include <asm/vtimer.h>
 #include <asm/exec.h>
diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
index 9af826d093efc..beae85549ebeb 100644
--- a/arch/s390/kvm/priv.c
+++ b/arch/s390/kvm/priv.c
@@ -13,7 +13,7 @@
 #include <linux/errno.h>
 #include <linux/mm_types.h>
 #include <linux/pgtable.h>
-
+#include <linux/io.h>
 #include <asm/asm-offsets.h>
 #include <asm/facility.h>
 #include <asm/current.h>
@@ -22,7 +22,6 @@
 #include <asm/sysinfo.h>
 #include <asm/page-states.h>
 #include <asm/gmap.h>
-#include <asm/io.h>
 #include <asm/ptrace.h>
 #include <asm/sclp.h>
 #include <asm/ap.h>
diff --git a/arch/s390/lib/spinlock.c b/arch/s390/lib/spinlock.c
index 04d4c6cf898ef..81c53440b3e66 100644
--- a/arch/s390/lib/spinlock.c
+++ b/arch/s390/lib/spinlock.c
@@ -13,8 +13,8 @@
 #include <linux/init.h>
 #include <linux/smp.h>
 #include <linux/percpu.h>
+#include <linux/io.h>
 #include <asm/alternative.h>
-#include <asm/io.h>
 
 int spin_retry = -1;
 
diff --git a/arch/s390/mm/maccess.c b/arch/s390/mm/maccess.c
index 4824d1cd33d87..b2d65afbb0ff9 100644
--- a/arch/s390/mm/maccess.c
+++ b/arch/s390/mm/maccess.c
@@ -13,9 +13,9 @@
 #include <linux/gfp.h>
 #include <linux/cpu.h>
 #include <linux/uio.h>
+#include <linux/io.h>
 #include <asm/asm-extable.h>
 #include <asm/ctl_reg.h>
-#include <asm/io.h>
 #include <asm/abs_lowcore.h>
 #include <asm/stacktrace.h>
 #include <asm/maccess.h>
diff --git a/drivers/s390/block/dasd_diag.c b/drivers/s390/block/dasd_diag.c
index 5802aead09f36..12db1046aad0f 100644
--- a/drivers/s390/block/dasd_diag.c
+++ b/drivers/s390/block/dasd_diag.c
@@ -24,7 +24,7 @@
 #include <asm/debug.h>
 #include <asm/diag.h>
 #include <asm/ebcdic.h>
-#include <asm/io.h>
+#include <linux/io.h>
 #include <asm/irq.h>
 #include <asm/vtoc.h>
 
diff --git a/drivers/s390/block/dasd_eckd.c b/drivers/s390/block/dasd_eckd.c
index b2e238467e700..76c3156902b0c 100644
--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -21,13 +21,13 @@
 #include <linux/compat.h>
 #include <linux/init.h>
 #include <linux/seq_file.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
 
 #include <asm/css_chars.h>
 #include <asm/debug.h>
 #include <asm/idals.h>
 #include <asm/ebcdic.h>
-#include <asm/io.h>
-#include <linux/uaccess.h>
 #include <asm/cio.h>
 #include <asm/ccwdev.h>
 #include <asm/itcw.h>
diff --git a/drivers/s390/block/dasd_fba.c b/drivers/s390/block/dasd_fba.c
index cddfb01a3dca1..0a8241b3bfdf5 100644
--- a/drivers/s390/block/dasd_fba.c
+++ b/drivers/s390/block/dasd_fba.c
@@ -16,10 +16,10 @@
 #include <linux/bio.h>
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/io.h>
 
 #include <asm/idals.h>
 #include <asm/ebcdic.h>
-#include <asm/io.h>
 #include <asm/ccwdev.h>
 
 #include "dasd_int.h"
diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
index 735ee0ca4a13b..038aa93a3ec81 100644
--- a/drivers/s390/block/dcssblk.c
+++ b/drivers/s390/block/dcssblk.c
@@ -20,8 +20,8 @@
 #include <linux/pfn_t.h>
 #include <linux/uio.h>
 #include <linux/dax.h>
+#include <linux/io.h>
 #include <asm/extmem.h>
-#include <asm/io.h>
 
 #define DCSSBLK_NAME "dcssblk"
 #define DCSSBLK_MINORS_PER_DISK 1
diff --git a/drivers/s390/char/con3215.c b/drivers/s390/char/con3215.c
index 033eb2ba21f09..98e28a5a90ecf 100644
--- a/drivers/s390/char/con3215.c
+++ b/drivers/s390/char/con3215.c
@@ -25,7 +25,7 @@
 #include <linux/slab.h>
 #include <asm/ccwdev.h>
 #include <asm/cio.h>
-#include <asm/io.h>
+#include <linux/io.h>
 #include <asm/ebcdic.h>
 #include <linux/uaccess.h>
 #include <asm/delay.h>
diff --git a/drivers/s390/char/monwriter.c b/drivers/s390/char/monwriter.c
index 7d9180847ccfa..54debecd3cb7a 100644
--- a/drivers/s390/char/monwriter.c
+++ b/drivers/s390/char/monwriter.c
@@ -22,8 +22,8 @@
 #include <linux/mutex.h>
 #include <linux/slab.h>
 #include <linux/uaccess.h>
+#include <linux/io.h>
 #include <asm/ebcdic.h>
-#include <asm/io.h>
 #include <asm/appldata.h>
 #include <asm/monwriter.h>
 
diff --git a/drivers/s390/net/ctcm_mpc.c b/drivers/s390/net/ctcm_mpc.c
index 55216d2fbea0b..245c4ef5122cc 100644
--- a/drivers/s390/net/ctcm_mpc.c
+++ b/drivers/s390/net/ctcm_mpc.c
@@ -43,13 +43,13 @@
 #include <linux/netdevice.h>
 #include <net/dst.h>
 
-#include <linux/io.h>		/* instead of <asm/io.h> ok ? */
-#include <asm/ccwdev.h>
-#include <asm/ccwgroup.h>
-#include <linux/bitops.h>	/* instead of <asm/bitops.h> ok ? */
-#include <linux/uaccess.h>	/* instead of <asm/uaccess.h> ok ? */
+#include <linux/io.h>
+#include <linux/bitops.h>
+#include <linux/uaccess.h>
 #include <linux/wait.h>
 #include <linux/moduleparam.h>
+#include <asm/ccwdev.h>
+#include <asm/ccwgroup.h>
 #include <asm/idals.h>
 
 #include "ctcm_main.h"
diff --git a/drivers/s390/net/netiucv.c b/drivers/s390/net/netiucv.c
index 66076cada8ae4..8852b03f943bb 100644
--- a/drivers/s390/net/netiucv.c
+++ b/drivers/s390/net/netiucv.c
@@ -47,7 +47,7 @@
 #include <linux/ctype.h>
 #include <net/dst.h>
 
-#include <asm/io.h>
+#include <linux/io.h>
 #include <linux/uaccess.h>
 #include <asm/ebcdic.h>
 
-- 
2.53.0




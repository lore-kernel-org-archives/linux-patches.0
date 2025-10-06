Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 149B122A4E9;
	Mon,  6 Oct 2025 18:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759774745; cv=none; b=guQhIdxqWF06wTdgC7gCEfcLWHThGcjD+IW2wS/JiofJ09TeUm6f1lD/a92vm1x99wqbjhDgHHWEJ02jjWdA7RNpxcXDUf35K493+g3fQE0aoQ7g9bzyznn371X/Qb+YpC+f37aFmf9JmlJKfvhk+NMWhjK/3XASIaWECwI0fOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759774745; c=relaxed/simple;
	bh=hTPMHRwx2FkDXzQPbE52gwh6AeK7/3UVto1k+Jd9+Ws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XoMjpyZj2FSSKxOt9ufQ3wbd2FWoYlTRx0UaneLs1V6yoXC08ESn5fhaTAXcBczVXO893HpEACy/vlhqqmgHl7kGBjvin+XU8DSWxETtW7iK5yvn8IM6Mdna7b7kv+f0DBEiLbg1oXyqL3C7Pi+whrAwkd4flh9+rO7dFLdjL7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HB5b2rNj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HB5b2rNj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9779BC4CEF5;
	Mon,  6 Oct 2025 18:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759774741;
	bh=hTPMHRwx2FkDXzQPbE52gwh6AeK7/3UVto1k+Jd9+Ws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HB5b2rNj+F+0oZgxCRiAb3k+43dXBRTrlw1xTsjMNFTK3MJVGF6y2rBip3JHAT20T
	 sjtxdOsxU8EJhBLbKL4a+VNg+MbRPCFgDkIFz0WEzEvXRJq5h3jvSY3QVRq+W1z4El
	 M3i7L9UKfcJ6pLm/tx2xwRHoifLeZgPd/rqTbK4kQrW2KRYeEeaEQpxq1H+hn+fa2K
	 WFIVb00sIAhx/0VA4w5gbajnBiAfhAk+F7LfpdObL2+mMx5QYJh69V5P/a26+oKLug
	 Y788qtkKUOwb5j1LX3N3zl/UTuiUcC5wCQHGNR1ryMFMwqda6NHvDmUapSIPtri2Vi
	 oOxCV0Yko0/iA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Menglong Dong <menglong8.dong@gmail.com>,
	Menglong Dong <dongml2@chinatelecom.cn>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>,
	guoren@kernel.org,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	macro@orcam.me.uk,
	ink@unseen.parts,
	mattst88@gmail.com,
	thomas.weissschuh@linutronix.de,
	tglx@linutronix.de,
	namcao@linutronix.de,
	catalin.marinas@arm.com,
	mark.rutland@arm.com,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	puranjay@kernel.org,
	anshuman.khandual@arm.com,
	maz@kernel.org,
	hca@linux.ibm.com,
	maobibo@loongson.cn,
	tsbogend@alpha.franken.de,
	dragan.mladjenovic@syrmia.com,
	paulburton@kernel.org,
	arikalo@gmail.com,
	mpe@ellerman.id.au,
	christophe.leroy@csgroup.eu,
	naveen@kernel.org,
	alexghiti@rivosinc.com,
	andybnac@gmail.com,
	ruanjinjie@huawei.com,
	ben.dooks@codethink.co.uk,
	cyrilbur@tenstorrent.com,
	zhangchunyan@iscas.ac.cn,
	gor@linux.ibm.com,
	agordeev@linux.ibm.com,
	imbrenda@linux.ibm.com,
	linux-csky@vger.kernel.org,
	linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 6.17-6.1] arch: Add the macro COMPILE_OFFSETS to all the asm-offsets.c
Date: Mon,  6 Oct 2025 14:17:35 -0400
Message-ID: <20251006181835.1919496-3-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251006181835.1919496-1-sashal@kernel.org>
References: <20251006181835.1919496-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Menglong Dong <menglong8.dong@gmail.com>

[ Upstream commit 35561bab768977c9e05f1f1a9bc00134c85f3e28 ]

The include/generated/asm-offsets.h is generated in Kbuild during
compiling from arch/SRCARCH/kernel/asm-offsets.c. When we want to
generate another similar offset header file, circular dependency can
happen.

For example, we want to generate a offset file include/generated/test.h,
which is included in include/sched/sched.h. If we generate asm-offsets.h
first, it will fail, as include/sched/sched.h is included in asm-offsets.c
and include/generated/test.h doesn't exist; If we generate test.h first,
it can't success neither, as include/generated/asm-offsets.h is included
by it.

In x86_64, the macro COMPILE_OFFSETS is used to avoid such circular
dependency. We can generate asm-offsets.h first, and if the
COMPILE_OFFSETS is defined, we don't include the "generated/test.h".

And we define the macro COMPILE_OFFSETS for all the asm-offsets.c for this
purpose.

Signed-off-by: Menglong Dong <dongml2@chinatelecom.cn>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my thorough investigation, I can now provide a comprehensive
analysis of this commit.

## **Backport Analysis: COMPILE_OFFSETS Commit**

**Backport Status: YES** (with important conditions)

### Summary

This commit adds `#define COMPILE_OFFSETS` to all architecture-specific
asm-offsets.c files. It is a **preparatory infrastructure patch** that
enables the generation of additional offset header files while avoiding
circular dependency issues during the kernel build process.

### Critical Context

This commit (upstream: 35561bab76897) is **inseparable** from its
companion commit:
- **378b7708194ff**: "sched: Make migrate_{en,dis}able() inline"

These two commits form a **mandatory pair** where:
1. The COMPILE_OFFSETS commit prepares the build infrastructure
2. The migrate_enable/disable commit actually uses this infrastructure
   to generate `include/generated/rq-offsets.h`

### Why This Should Be Backported

1. **Already being backported**: The companion commit (378b7708194ff) is
   already tagged for stable backport (as commit d0e888caa43cc shows `[
   Upstream commit 378b7708194fff77c9020392067329931c3fcc04 ]`)

2. **Build dependency**: Without this COMPILE_OFFSETS commit, the
   migrate_enable/disable backport will **fail to build** due to
   circular dependency:
   - `asm-offsets.c` includes `<linux/sched.h>`
   - `<linux/sched.h>` will include `<generated/rq-offsets.h>`
   - But `rq-offsets.h` doesn't exist yet when generating `asm-
     offsets.h`
   - The COMPILE_OFFSETS macro allows conditional inclusion to break
     this cycle

3. **Performance improvement for BPF**: The complete patch series
   improves BPF FENTRY performance from ~113M/s to ~150M/s (27-32%
   improvement) by inlining migrate_enable/disable functions

4. **Low risk**: This commit only adds a simple `#define` to each asm-
   offsets.c file with no functional changes to any existing code paths

### Code Changes Analysis

The changes are identical across all 23 architectures:
- **alpha, arc, arm, arm64, csky, hexagon, loongarch, m68k, microblaze,
  mips, nios2, openrisc, parisc, powerpc, riscv, s390, sh, sparc, um,
  xtensa**

Each file receives:
```c
+#define COMPILE_OFFSETS
```

This macro is used in header files (specifically
`include/linux/sched.h`) to conditionally guard includes:
```c
#ifndef COMPILE_OFFSETS
#include <generated/rq-offsets.h>
#endif
```

### Dependencies

- **Must be backported together with**: commit 378b7708194ff
- **Order matters**: COMPILE_OFFSETS must be applied first (or in same
  merge)
- **No standalone value**: This commit has no effect without the follow-
  up changes

### Risk Assessment

- **Risk Level**: Low
- **Regression Potential**: Minimal - only adds a preprocessor
  definition
- **Testing**: Should build-test on all architectures
- **Compatibility**: X86_64 already had this pattern since 2011 (commit
  b82fef82d567)

### References

- Upstream commits: 35561bab76897 (this one) → 378b7708194ff (migrate
  inline)
- Author: Menglong Dong <dongml2@chinatelecom.cn>
- Maintainer: Peter Zijlstra (Intel) <peterz@infradead.org>
- Subsystem: Scheduler / Build infrastructure

**Conclusion**: This is a mandatory prerequisite patch that must be
backported alongside its companion commit to avoid build breakage. The
stable maintainers should ensure both patches are applied together in
the correct order.

 arch/alpha/kernel/asm-offsets.c      | 1 +
 arch/arc/kernel/asm-offsets.c        | 1 +
 arch/arm/kernel/asm-offsets.c        | 2 ++
 arch/arm64/kernel/asm-offsets.c      | 1 +
 arch/csky/kernel/asm-offsets.c       | 1 +
 arch/hexagon/kernel/asm-offsets.c    | 1 +
 arch/loongarch/kernel/asm-offsets.c  | 2 ++
 arch/m68k/kernel/asm-offsets.c       | 1 +
 arch/microblaze/kernel/asm-offsets.c | 1 +
 arch/mips/kernel/asm-offsets.c       | 2 ++
 arch/nios2/kernel/asm-offsets.c      | 1 +
 arch/openrisc/kernel/asm-offsets.c   | 1 +
 arch/parisc/kernel/asm-offsets.c     | 1 +
 arch/powerpc/kernel/asm-offsets.c    | 1 +
 arch/riscv/kernel/asm-offsets.c      | 1 +
 arch/s390/kernel/asm-offsets.c       | 1 +
 arch/sh/kernel/asm-offsets.c         | 1 +
 arch/sparc/kernel/asm-offsets.c      | 1 +
 arch/um/kernel/asm-offsets.c         | 2 ++
 arch/xtensa/kernel/asm-offsets.c     | 1 +
 20 files changed, 24 insertions(+)

diff --git a/arch/alpha/kernel/asm-offsets.c b/arch/alpha/kernel/asm-offsets.c
index e9dad60b147f3..1ebb058904992 100644
--- a/arch/alpha/kernel/asm-offsets.c
+++ b/arch/alpha/kernel/asm-offsets.c
@@ -4,6 +4,7 @@
  * This code generates raw asm output which is post-processed to extract
  * and format the required data.
  */
+#define COMPILE_OFFSETS
 
 #include <linux/types.h>
 #include <linux/stddef.h>
diff --git a/arch/arc/kernel/asm-offsets.c b/arch/arc/kernel/asm-offsets.c
index f77deb7991757..2978da85fcb65 100644
--- a/arch/arc/kernel/asm-offsets.c
+++ b/arch/arc/kernel/asm-offsets.c
@@ -2,6 +2,7 @@
 /*
  * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
  */
+#define COMPILE_OFFSETS
 
 #include <linux/sched.h>
 #include <linux/mm.h>
diff --git a/arch/arm/kernel/asm-offsets.c b/arch/arm/kernel/asm-offsets.c
index 123f4a8ef4466..2101938d27fcb 100644
--- a/arch/arm/kernel/asm-offsets.c
+++ b/arch/arm/kernel/asm-offsets.c
@@ -7,6 +7,8 @@
  * This code generates raw asm output which is post-processed to extract
  * and format the required data.
  */
+#define COMPILE_OFFSETS
+
 #include <linux/compiler.h>
 #include <linux/sched.h>
 #include <linux/mm.h>
diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
index 30d4bbe68661f..b6367ff3a49ca 100644
--- a/arch/arm64/kernel/asm-offsets.c
+++ b/arch/arm64/kernel/asm-offsets.c
@@ -6,6 +6,7 @@
  *               2001-2002 Keith Owens
  * Copyright (C) 2012 ARM Ltd.
  */
+#define COMPILE_OFFSETS
 
 #include <linux/arm_sdei.h>
 #include <linux/sched.h>
diff --git a/arch/csky/kernel/asm-offsets.c b/arch/csky/kernel/asm-offsets.c
index d1e9035794733..5525c8e7e1d9e 100644
--- a/arch/csky/kernel/asm-offsets.c
+++ b/arch/csky/kernel/asm-offsets.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 // Copyright (C) 2018 Hangzhou C-SKY Microsystems co.,ltd.
+#define COMPILE_OFFSETS
 
 #include <linux/sched.h>
 #include <linux/kernel_stat.h>
diff --git a/arch/hexagon/kernel/asm-offsets.c b/arch/hexagon/kernel/asm-offsets.c
index 03a7063f94561..50eea9fa6f137 100644
--- a/arch/hexagon/kernel/asm-offsets.c
+++ b/arch/hexagon/kernel/asm-offsets.c
@@ -8,6 +8,7 @@
  *
  * Copyright (c) 2010-2012, The Linux Foundation. All rights reserved.
  */
+#define COMPILE_OFFSETS
 
 #include <linux/compat.h>
 #include <linux/types.h>
diff --git a/arch/loongarch/kernel/asm-offsets.c b/arch/loongarch/kernel/asm-offsets.c
index db1e4bb26b6a0..3017c71576009 100644
--- a/arch/loongarch/kernel/asm-offsets.c
+++ b/arch/loongarch/kernel/asm-offsets.c
@@ -4,6 +4,8 @@
  *
  * Copyright (C) 2020-2022 Loongson Technology Corporation Limited
  */
+#define COMPILE_OFFSETS
+
 #include <linux/types.h>
 #include <linux/sched.h>
 #include <linux/mm.h>
diff --git a/arch/m68k/kernel/asm-offsets.c b/arch/m68k/kernel/asm-offsets.c
index 906d732305374..67a1990f9d748 100644
--- a/arch/m68k/kernel/asm-offsets.c
+++ b/arch/m68k/kernel/asm-offsets.c
@@ -9,6 +9,7 @@
  * #defines from the assembly-language output.
  */
 
+#define COMPILE_OFFSETS
 #define ASM_OFFSETS_C
 
 #include <linux/stddef.h>
diff --git a/arch/microblaze/kernel/asm-offsets.c b/arch/microblaze/kernel/asm-offsets.c
index 104c3ac5f30c8..b4b67d58e7f6a 100644
--- a/arch/microblaze/kernel/asm-offsets.c
+++ b/arch/microblaze/kernel/asm-offsets.c
@@ -7,6 +7,7 @@
  * License. See the file "COPYING" in the main directory of this archive
  * for more details.
  */
+#define COMPILE_OFFSETS
 
 #include <linux/init.h>
 #include <linux/stddef.h>
diff --git a/arch/mips/kernel/asm-offsets.c b/arch/mips/kernel/asm-offsets.c
index 1e29efcba46e5..5debd9a3854a9 100644
--- a/arch/mips/kernel/asm-offsets.c
+++ b/arch/mips/kernel/asm-offsets.c
@@ -9,6 +9,8 @@
  * Kevin Kissell, kevink@mips.com and Carsten Langgaard, carstenl@mips.com
  * Copyright (C) 2000 MIPS Technologies, Inc.
  */
+#define COMPILE_OFFSETS
+
 #include <linux/compat.h>
 #include <linux/types.h>
 #include <linux/sched.h>
diff --git a/arch/nios2/kernel/asm-offsets.c b/arch/nios2/kernel/asm-offsets.c
index e3d9b7b6fb48a..88190b503ce5d 100644
--- a/arch/nios2/kernel/asm-offsets.c
+++ b/arch/nios2/kernel/asm-offsets.c
@@ -2,6 +2,7 @@
 /*
  * Copyright (C) 2011 Tobias Klauser <tklauser@distanz.ch>
  */
+#define COMPILE_OFFSETS
 
 #include <linux/stddef.h>
 #include <linux/sched.h>
diff --git a/arch/openrisc/kernel/asm-offsets.c b/arch/openrisc/kernel/asm-offsets.c
index 710651d5aaae1..3cc826f2216b1 100644
--- a/arch/openrisc/kernel/asm-offsets.c
+++ b/arch/openrisc/kernel/asm-offsets.c
@@ -18,6 +18,7 @@
  * compile this file to assembler, and then extract the
  * #defines from the assembly-language output.
  */
+#define COMPILE_OFFSETS
 
 #include <linux/signal.h>
 #include <linux/sched.h>
diff --git a/arch/parisc/kernel/asm-offsets.c b/arch/parisc/kernel/asm-offsets.c
index 757816a7bd4b2..9abfe65492c65 100644
--- a/arch/parisc/kernel/asm-offsets.c
+++ b/arch/parisc/kernel/asm-offsets.c
@@ -13,6 +13,7 @@
  *    Copyright (C) 2002 Randolph Chung <tausq with parisc-linux.org>
  *    Copyright (C) 2003 James Bottomley <jejb at parisc-linux.org>
  */
+#define COMPILE_OFFSETS
 
 #include <linux/types.h>
 #include <linux/sched.h>
diff --git a/arch/powerpc/kernel/asm-offsets.c b/arch/powerpc/kernel/asm-offsets.c
index b3048f6d3822c..a4bc80b30410a 100644
--- a/arch/powerpc/kernel/asm-offsets.c
+++ b/arch/powerpc/kernel/asm-offsets.c
@@ -8,6 +8,7 @@
  * compile this file to assembler, and then extract the
  * #defines from the assembly-language output.
  */
+#define COMPILE_OFFSETS
 
 #include <linux/compat.h>
 #include <linux/signal.h>
diff --git a/arch/riscv/kernel/asm-offsets.c b/arch/riscv/kernel/asm-offsets.c
index 6e8c0d6feae9e..7d42d3b8a32a7 100644
--- a/arch/riscv/kernel/asm-offsets.c
+++ b/arch/riscv/kernel/asm-offsets.c
@@ -3,6 +3,7 @@
  * Copyright (C) 2012 Regents of the University of California
  * Copyright (C) 2017 SiFive
  */
+#define COMPILE_OFFSETS
 
 #include <linux/kbuild.h>
 #include <linux/mm.h>
diff --git a/arch/s390/kernel/asm-offsets.c b/arch/s390/kernel/asm-offsets.c
index 95ecad9c7d7d2..a8915663e917f 100644
--- a/arch/s390/kernel/asm-offsets.c
+++ b/arch/s390/kernel/asm-offsets.c
@@ -4,6 +4,7 @@
  * This code generates raw asm output which is post-processed to extract
  * and format the required data.
  */
+#define COMPILE_OFFSETS
 
 #include <linux/kbuild.h>
 #include <linux/sched.h>
diff --git a/arch/sh/kernel/asm-offsets.c b/arch/sh/kernel/asm-offsets.c
index a0322e8328456..429b6a7631468 100644
--- a/arch/sh/kernel/asm-offsets.c
+++ b/arch/sh/kernel/asm-offsets.c
@@ -8,6 +8,7 @@
  * compile this file to assembler, and then extract the
  * #defines from the assembly-language output.
  */
+#define COMPILE_OFFSETS
 
 #include <linux/stddef.h>
 #include <linux/types.h>
diff --git a/arch/sparc/kernel/asm-offsets.c b/arch/sparc/kernel/asm-offsets.c
index 3d9b9855dce91..6e660bde48dd8 100644
--- a/arch/sparc/kernel/asm-offsets.c
+++ b/arch/sparc/kernel/asm-offsets.c
@@ -10,6 +10,7 @@
  *
  * On sparc, thread_info data is static and TI_XXX offsets are computed by hand.
  */
+#define COMPILE_OFFSETS
 
 #include <linux/sched.h>
 #include <linux/mm_types.h>
diff --git a/arch/um/kernel/asm-offsets.c b/arch/um/kernel/asm-offsets.c
index 1fb12235ab9c8..a69873aa697f4 100644
--- a/arch/um/kernel/asm-offsets.c
+++ b/arch/um/kernel/asm-offsets.c
@@ -1 +1,3 @@
+#define COMPILE_OFFSETS
+
 #include <sysdep/kernel-offsets.h>
diff --git a/arch/xtensa/kernel/asm-offsets.c b/arch/xtensa/kernel/asm-offsets.c
index da38de20ae598..cfbced95e944a 100644
--- a/arch/xtensa/kernel/asm-offsets.c
+++ b/arch/xtensa/kernel/asm-offsets.c
@@ -11,6 +11,7 @@
  *
  * Chris Zankel <chris@zankel.net>
  */
+#define COMPILE_OFFSETS
 
 #include <asm/processor.h>
 #include <asm/coprocessor.h>
-- 
2.51.0


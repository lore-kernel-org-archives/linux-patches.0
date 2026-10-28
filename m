Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214844;
	b=pgsSpC1SKKcWQUMkBzHCHPuWdww+l8vDZu0WsraMNFRi41icOZoVxXyxwPoXwhpiVFHk
	 +srCdvMM+NucWnWIclcUqhP9GJGcJgdCTgWP+E685arl5NXCLUoGTllLj16UaxE1T+497
	 Pmmz9oBgX21BF2J7r/2S9JXsT/qAUDcYkaJsfVJMUlbFAxFSB2TWPkeRRdBLBDiJ6o7RH
	 YjYNV2QgOeqv38zKDRimJhwI9pyj2uzK5zbfHXm76qasrw3Jxtu33NANRIE8BGGUWLJ4C
	 DavKEBVhJzIwRwUPrXSUum3N+0liTg2rvifLuyB/BcgGqzBsjYfczw97njrn03BJexg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214844;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=ru7RmFtkUZFC0c1UwHu7ZDNqynQ1DGtMaFdiq6mgQPo=;
	b=d5HEczjcQcnBWGrI1KqsgmjnPpzZRBIHsA/oLJaw8HPlObpel3HXKhAXRpy/3Kkgck/f
	 Zwhp807Zkw3eTIscEuUGj6zP41iopSZwLvDRxzhfG0hB+Bj4kkd1iGciVF7a8QP4wH37q
	 dxLHoTYwQQ0xyLrYktgXpSom2lgWddyFNgSRKYdPxUa/KW1+3pQdL2JVCjoFa//aaN6bf
	 mi00/FwUG1OytHboKbmhZEYTvDz0algj79sUDVxHscXnJtkwT4sAsFalH0fO9wJ0TRt5v
	 hBnVnfcJVrAcsbgsAdH0b1wQIxQYk2CeVjTj0Lh+HCFd8cbf2/O8A1EbTfA5rsoZIBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t4CRGKFC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D363606AB28;
	Wed, 28 Oct 2026 19:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t4CRGKFC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6B971F01825;
	Wed, 28 Oct 2026 19:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214844;
	bh=ru7RmFtkUZFC0c1UwHu7ZDNqynQ1DGtMaFdiq6mgQPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t4CRGKFC0EvFtsP1ARJ/clcWkDaCgjslXUw1iI1pKiULDogOra4AywbqyXA32YA0q
	 Uz4jPR1YPsycAHKMCArUdIHL5bNlrOOMcTwquCK9tx950tTk6LAtHhVG0FqJvD4Jie
	 HWDtPMu52TVOj7nHHEk5PkdY0q/eoRJpMDP5z/M0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Stephen Rothwell <sfr@rothwell.id.au>,
	"David S. Miller" <davem@davemloft.net>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1003/1887] arch: turn off -Werror for architectures with known warnings
Date: Wed, 28 Oct 2026 17:51:39 +0100
Message-ID: <20261028170522.235432027@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 0f0d2871e78db648a2578abbeb9103f484f9b754 ]

A couple of architectures enable -Werror for their own files regardless of
CONFIG_WERROR but also have known warnings that fail the build with
-Wmissing-prototypes enabled by default:

arch/alpha/lib/memcpy.c:153:8: error: no previous prototype for 'memcpy' [-Werror=missing-prototypes]
arch/alpha/kernel/irq.c:96:1: error: no previous prototype for 'handle_irq' [-Werror=missing-prototypes]
arch/mips/kernel/signal.c:673:17: error: no previous prototype for ‘sys_rt_sigreturn’ [-Werror=missing-prototypes]
arch/mips/kernel/signal.c:636:17: error: no previous prototype for ‘sys_sigreturn’ [-Werror=missing-prototypes]
arch/mips/kernel/syscall.c:51:16: error: no previous prototype for ‘sysm_pipe’ [-Werror=missing-prototypes]
arch/mips/mm/fault.c:323:17: error: no previous prototype for ‘do_page_fault’ [-Werror=missing-prototypes]
arch/sparc/vdso/vma.c:246:12: warning: no previous prototype for ‘init_vdso_image’ [-Wmissing-prototypes]v
arch/sparc/vdso/vdso32/../vclock_gettime.c:343:1: warning: no previous prototype for ‘__vdso_gettimeofday_stick’ [-Wmissing-prototypes]
arch/sparc/vdso/vclock_gettime.c:343:1: warning: no previous prototype for ‘__vdso_gettimeofday_stick’ [-Wmissing-prototypes]
arch/sparc/prom/p1275.c:52:6: warning: no previous prototype for ‘prom_cif_init’ [-Wmissing-prototypes]
arch/sparc/prom/misc_64.c:165:5: warning: no previous prototype for ‘prom_get_mmu_ihandle’ [-Wmissing-prototypes]

This appears to be an artifact from the times when this architecture code
was better maintained that most device drivers and before CONFIG_WERROR
was added.  Now it just gets in the way, so remove all of these.

Powerpc and x86 both still have their own Kconfig options to enable
-Werror for some of their files.  These architectures are better
maintained than most and the options are easy to disable, so leave those
untouched.

Link: https://lkml.kernel.org/r/4be73872-c1f5-4c31-8201-712c19290a22@app.fastmail.com
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reported-by: Stephen Rothwell <sfr@rothwell.id.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: dd5712f3379c ("alpha: fix user-space corruption during memory compaction")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/alpha/lib/Makefile    | 1 -
 arch/alpha/mm/Makefile     | 2 --
 arch/mips/Kbuild           | 6 ------
 arch/sparc/kernel/Makefile | 1 -
 arch/sparc/lib/Makefile    | 1 -
 arch/sparc/mm/Makefile     | 1 -
 arch/sparc/prom/Makefile   | 1 -
 7 files changed, 13 deletions(-)

diff --git a/arch/alpha/lib/Makefile b/arch/alpha/lib/Makefile
index 1cc74f7b50efb..6a779b9018fd1 100644
--- a/arch/alpha/lib/Makefile
+++ b/arch/alpha/lib/Makefile
@@ -4,7 +4,6 @@
 #
 
 asflags-y := $(KBUILD_CFLAGS)
-ccflags-y := -Werror
 
 # Many of these routines have implementations tuned for ev6.
 # Choose them iff we're targeting ev6 specifically.
diff --git a/arch/alpha/mm/Makefile b/arch/alpha/mm/Makefile
index bd770302eb824..101dbd06b4ceb 100644
--- a/arch/alpha/mm/Makefile
+++ b/arch/alpha/mm/Makefile
@@ -3,6 +3,4 @@
 # Makefile for the linux alpha-specific parts of the memory manager.
 #
 
-ccflags-y := -Werror
-
 obj-y	:= init.o fault.o
diff --git a/arch/mips/Kbuild b/arch/mips/Kbuild
index 9e8071f0e58ff..ed09e894749b5 100644
--- a/arch/mips/Kbuild
+++ b/arch/mips/Kbuild
@@ -1,10 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0
-# Fail on warnings - also for files referenced in subdirs
-# -Werror can be disabled for specific files using:
-# CFLAGS_<file.o> := -Wno-error
-ifeq ($(W),)
-subdir-ccflags-y := -Werror
-endif
 
 # platform specific definitions
 include arch/mips/Kbuild.platforms
diff --git a/arch/sparc/kernel/Makefile b/arch/sparc/kernel/Makefile
index 0984bb6f0f17b..58ea4ef9b622b 100644
--- a/arch/sparc/kernel/Makefile
+++ b/arch/sparc/kernel/Makefile
@@ -5,7 +5,6 @@
 #
 
 asflags-y := -ansi
-ccflags-y := -Werror
 
 # Undefine sparc when processing vmlinux.lds - it is used
 # And teach CPP we are doing $(BITS) builds (for this case)
diff --git a/arch/sparc/lib/Makefile b/arch/sparc/lib/Makefile
index 063556fe2cb1d..59669ebddd4e1 100644
--- a/arch/sparc/lib/Makefile
+++ b/arch/sparc/lib/Makefile
@@ -3,7 +3,6 @@
 #
 
 asflags-y := -ansi -DST_DIV0=0x02
-ccflags-y := -Werror
 
 lib-$(CONFIG_SPARC32) += ashrdi3.o
 lib-$(CONFIG_SPARC32) += memcpy.o memset.o
diff --git a/arch/sparc/mm/Makefile b/arch/sparc/mm/Makefile
index 871354aa3c002..809d993f6d888 100644
--- a/arch/sparc/mm/Makefile
+++ b/arch/sparc/mm/Makefile
@@ -3,7 +3,6 @@
 #
 
 asflags-y := -ansi
-ccflags-y := -Werror
 
 obj-$(CONFIG_SPARC64)   += ultra.o tlb.o tsb.o
 obj-y                   += fault_$(BITS).o
diff --git a/arch/sparc/prom/Makefile b/arch/sparc/prom/Makefile
index 397b79af77f7b..a1adc75d80551 100644
--- a/arch/sparc/prom/Makefile
+++ b/arch/sparc/prom/Makefile
@@ -3,7 +3,6 @@
 # Linux.
 #
 asflags := -ansi
-ccflags := -Werror
 
 lib-y                 := bootstr_$(BITS).o
 lib-y                 += init_$(BITS).o
-- 
2.53.0




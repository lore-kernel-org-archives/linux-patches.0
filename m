Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 374B130C60F;
	Sat, 12 Sep 2026 13:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219050; cv=none; b=WVv6XJHkTPTMzhguapV3KOie+F4FPKxtB5WYy1OjzMa0PhPl8bzsrNQEr1QhaDDyx03PU+JdcwbXUVcoRU9Cb5j9UEAG1TfutUZJYAYKgOOkLUhjkDNKn2Kmh1iHubxeMZhhvdg8jUwvyq5uJY4Ann1lz2goQe14mbZavlV16SM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219050; c=relaxed/simple;
	bh=VibiCuSM5Y7kXHGzf8Eji8JIfupzqPLQcRIKbhqWQw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ouj/1OX0ruXxwK4AWp2MiolvH9p9qEbxlH8h4KmWM3fdUyiMPSvEv3P6OPKK1CFv+ykzh7r1GyfMaEFqDrRZ3Jsi8MeBY6MQGmtYEjZN35w96AomHn+UYR8IwZcqbEqTUHiNr2f0E2TYyZuVGGQbM0DYzPD5GUgXU9eEIW8kCFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sUmjAGEM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sUmjAGEM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E44A51F000FF;
	Sat, 12 Sep 2026 13:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219049;
	bh=Q1RybqUBPcZl8AcZ8/NZT3st0dPfBsfY+zDV3CgGths=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sUmjAGEM572A96nsJhO7S4OUMA8oc52WzrqtwOCorOjBn1PPqegykJY6LtC1Xrc/4
	 y6PEDikTQDggwK8OQggg+9/tGREjHXy+A2SstTRopzlIpnuripcWMpXJASlI+rg6gq
	 7RJkiKXx4aOnx/5uZhFc90jKdnMBmHq0MNd+jx8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Will Deacon <will@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Marc Zyngier <maz@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Steven Price <steven.price@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.12 1271/1376] mm: rename GENERIC_PTDUMP and PTDUMP_CORE
Date: Sat, 12 Sep 2026 09:01:37 +0200
Message-ID: <20260912065635.865688987@linuxfoundation.org>
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

From: Anshuman Khandual <anshuman.khandual@arm.com>

[ Upstream commit f9aad622006bd64c28fdf73c03a1c5139fcbf049 ]

Platforms subscribe into generic ptdump implementation via GENERIC_PTDUMP.
But generic ptdump gets enabled via PTDUMP_CORE.  These configs
combination is confusing as they sound very similar and does not
differentiate between platform's feature subscription and feature
enablement for ptdump.  Rename the configs as ARCH_HAS_PTDUMP and PTDUMP
making it more clear and improve readability.

Link: https://lkml.kernel.org/r/20250226122404.1927473-6-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu> (powerpc)
Acked-by: Catalin Marinas <catalin.marinas@arm.com>	[arm64]
Cc: Will Deacon <will@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Steven Price <steven.price@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 902caade3cfd ("arm64: ptdump: Make note_page_flush() range aware")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/Kconfig              |  2 +-
 arch/arm64/include/asm/ptdump.h |  4 ++--
 arch/arm64/kvm/Kconfig          |  4 ++--
 arch/arm64/mm/Makefile          |  2 +-
 arch/powerpc/Kconfig            |  2 +-
 arch/powerpc/mm/Makefile        |  2 +-
 arch/riscv/Kconfig              |  2 +-
 arch/riscv/mm/Makefile          |  2 +-
 arch/s390/Kconfig               |  2 +-
 arch/s390/mm/Makefile           |  2 +-
 arch/x86/Kconfig                |  2 +-
 arch/x86/Kconfig.debug          |  2 +-
 arch/x86/mm/Makefile            |  2 +-
 mm/Kconfig.debug                | 12 ++++++------
 mm/Makefile                     |  2 +-
 15 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 10aa534852fb9..938bf2f96b1a8 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -39,6 +39,7 @@ config ARM64
 	select ARCH_HAS_NMI_SAFE_THIS_CPU_OPS
 	select ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
 	select ARCH_HAS_NONLEAF_PMD_YOUNG if ARM64_HAFT
+	select ARCH_HAS_PTDUMP
 	select ARCH_HAS_PTE_DEVMAP
 	select ARCH_HAS_PTE_SPECIAL
 	select ARCH_HAS_HW_PTE_YOUNG
@@ -153,7 +154,6 @@ config ARM64
 	select GENERIC_IRQ_SHOW_LEVEL
 	select GENERIC_LIB_DEVMEM_IS_ALLOWED
 	select GENERIC_PCI_IOMAP
-	select GENERIC_PTDUMP
 	select GENERIC_SCHED_CLOCK
 	select GENERIC_SMP_IDLE_THREAD
 	select GENERIC_TIME_VSYSCALL
diff --git a/arch/arm64/include/asm/ptdump.h b/arch/arm64/include/asm/ptdump.h
index 6cf4aae052191..b2931d1ae0fb3 100644
--- a/arch/arm64/include/asm/ptdump.h
+++ b/arch/arm64/include/asm/ptdump.h
@@ -7,7 +7,7 @@
 
 #include <linux/ptdump.h>
 
-#ifdef CONFIG_PTDUMP_CORE
+#ifdef CONFIG_PTDUMP
 
 #include <linux/mm_types.h>
 #include <linux/seq_file.h>
@@ -70,6 +70,6 @@ static inline void ptdump_debugfs_register(struct ptdump_info *info,
 #else
 static inline void note_page(struct ptdump_state *pt_st, unsigned long addr,
 			     int level, u64 val) { }
-#endif /* CONFIG_PTDUMP_CORE */
+#endif /* CONFIG_PTDUMP */
 
 #endif /* __ASM_PTDUMP_H */
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index ead632ad01b4c..096e45acadb2d 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -71,8 +71,8 @@ config PTDUMP_STAGE2_DEBUGFS
 	depends on KVM
 	depends on DEBUG_KERNEL
 	depends on DEBUG_FS
-	depends on GENERIC_PTDUMP
-	select PTDUMP_CORE
+	depends on ARCH_HAS_PTDUMP
+	select PTDUMP
 	default n
 	help
 	  Say Y here if you want to show the stage-2 kernel pagetables
diff --git a/arch/arm64/mm/Makefile b/arch/arm64/mm/Makefile
index 2fc8c6dd04070..ea6cd8b4e434f 100644
--- a/arch/arm64/mm/Makefile
+++ b/arch/arm64/mm/Makefile
@@ -5,7 +5,7 @@ obj-y				:= dma-mapping.o extable.o fault.o init.o \
 				   context.o proc.o pageattr.o fixmap.o
 obj-$(CONFIG_ARM64_CONTPTE)	+= contpte.o
 obj-$(CONFIG_HUGETLB_PAGE)	+= hugetlbpage.o
-obj-$(CONFIG_PTDUMP_CORE)	+= ptdump.o
+obj-$(CONFIG_PTDUMP)		+= ptdump.o
 obj-$(CONFIG_PTDUMP_DEBUGFS)	+= ptdump_debugfs.o
 obj-$(CONFIG_TRANS_TABLE)	+= trans_pgd.o
 obj-$(CONFIG_TRANS_TABLE)	+= trans_pgd-asm.o
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 1bd5a9ff8505d..807354085fe3a 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -146,6 +146,7 @@ config PPC
 	select ARCH_HAS_PHYS_TO_DMA
 	select ARCH_HAS_PMEM_API
 	select ARCH_HAS_PREEMPT_LAZY
+	select ARCH_HAS_PTDUMP
 	select ARCH_HAS_PTE_DEVMAP		if PPC_BOOK3S_64
 	select ARCH_HAS_PTE_SPECIAL
 	select ARCH_HAS_SCALED_CPUTIME		if VIRT_CPU_ACCOUNTING_NATIVE && PPC_BOOK3S_64
@@ -204,7 +205,6 @@ config PPC
 	select GENERIC_IRQ_SHOW
 	select GENERIC_IRQ_SHOW_LEVEL
 	select GENERIC_PCI_IOMAP		if PCI
-	select GENERIC_PTDUMP
 	select GENERIC_SMP_IDLE_THREAD
 	select GENERIC_TIME_VSYSCALL
 	select GENERIC_VDSO_TIME_NS
diff --git a/arch/powerpc/mm/Makefile b/arch/powerpc/mm/Makefile
index 0fe2f085c05ad..8c1582b2987d4 100644
--- a/arch/powerpc/mm/Makefile
+++ b/arch/powerpc/mm/Makefile
@@ -15,5 +15,5 @@ obj-$(CONFIG_NUMA) += numa.o
 obj-$(CONFIG_HUGETLB_PAGE)	+= hugetlbpage.o
 obj-$(CONFIG_NOT_COHERENT_CACHE) += dma-noncoherent.o
 obj-$(CONFIG_PPC_COPRO_BASE)	+= copro_fault.o
-obj-$(CONFIG_PTDUMP_CORE)	+= ptdump/
+obj-$(CONFIG_PTDUMP)		+= ptdump/
 obj-$(CONFIG_KASAN)		+= kasan/
diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index 1c75758167956..dcb2fef2fb545 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -40,6 +40,7 @@ config RISCV
 	select ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
 	select ARCH_HAS_PMEM_API
 	select ARCH_HAS_PREPARE_SYNC_CORE_CMD
+	select ARCH_HAS_PTDUMP if MMU
 	select ARCH_HAS_PTE_DEVMAP if 64BIT && MMU
 	select ARCH_HAS_PTE_SPECIAL
 	select ARCH_HAS_SET_DIRECT_MAP if MMU
@@ -108,7 +109,6 @@ config RISCV
 	select GENERIC_IRQ_SHOW_LEVEL
 	select GENERIC_LIB_DEVMEM_IS_ALLOWED
 	select GENERIC_PCI_IOMAP
-	select GENERIC_PTDUMP if MMU
 	select GENERIC_SCHED_CLOCK
 	select GENERIC_SMP_IDLE_THREAD
 	select GENERIC_TIME_VSYSCALL if MMU && 64BIT
diff --git a/arch/riscv/mm/Makefile b/arch/riscv/mm/Makefile
index cbe4d775ef56c..b916a68d324ad 100644
--- a/arch/riscv/mm/Makefile
+++ b/arch/riscv/mm/Makefile
@@ -19,7 +19,7 @@ obj-y += context.o
 obj-y += pmem.o
 
 obj-$(CONFIG_HUGETLB_PAGE) += hugetlbpage.o
-obj-$(CONFIG_PTDUMP_CORE) += ptdump.o
+obj-$(CONFIG_PTDUMP) += ptdump.o
 obj-$(CONFIG_KASAN)   += kasan_init.o
 
 ifdef CONFIG_KASAN
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 69aac02d5fc4c..257e4cb43e54e 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -81,6 +81,7 @@ config S390
 	select ARCH_HAS_MEM_ENCRYPT
 	select ARCH_HAS_NMI_SAFE_THIS_CPU_OPS
 	select ARCH_HAS_PREEMPT_LAZY
+	select ARCH_HAS_PTDUMP
 	select ARCH_HAS_PTE_SPECIAL
 	select ARCH_HAS_SCALED_CPUTIME
 	select ARCH_HAS_SET_DIRECT_MAP
@@ -146,7 +147,6 @@ config S390
 	select GENERIC_CPU_VULNERABILITIES
 	select GENERIC_ENTRY
 	select GENERIC_GETTIMEOFDAY
-	select GENERIC_PTDUMP
 	select GENERIC_SMP_IDLE_THREAD
 	select GENERIC_TIME_VSYSCALL
 	select GENERIC_VDSO_TIME_NS
diff --git a/arch/s390/mm/Makefile b/arch/s390/mm/Makefile
index f6c2db7a86690..9726b91fe7e41 100644
--- a/arch/s390/mm/Makefile
+++ b/arch/s390/mm/Makefile
@@ -9,6 +9,6 @@ obj-y		+= page-states.o pageattr.o pgtable.o pgalloc.o extable.o
 obj-$(CONFIG_CMM)		+= cmm.o
 obj-$(CONFIG_DEBUG_VIRTUAL)	+= physaddr.o
 obj-$(CONFIG_HUGETLB_PAGE)	+= hugetlbpage.o
-obj-$(CONFIG_PTDUMP_CORE)	+= dump_pagetables.o
+obj-$(CONFIG_PTDUMP)		+= dump_pagetables.o
 obj-$(CONFIG_PGSTE)		+= gmap.o
 obj-$(CONFIG_PFAULT)		+= pfault.o
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index d1c73d5ed32f7..9f68b3a2cec5d 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -26,6 +26,7 @@ config X86_64
 	depends on 64BIT
 	# Options that are inherently 64-bit kernel only:
 	select ARCH_HAS_GIGANTIC_PAGE
+	select ARCH_HAS_PTDUMP
 	select ARCH_SUPPORTS_INT128 if CC_HAS_INT128
 	select ARCH_SUPPORTS_PER_VMA_LOCK
 	select ARCH_SUPPORTS_HUGE_PFNMAP if TRANSPARENT_HUGEPAGE
@@ -169,7 +170,6 @@ config X86
 	select GENERIC_IRQ_RESERVATION_MODE
 	select GENERIC_IRQ_SHOW
 	select GENERIC_PENDING_IRQ		if SMP
-	select GENERIC_PTDUMP
 	select GENERIC_SMP_IDLE_THREAD
 	select GENERIC_TIME_VSYSCALL
 	select GENERIC_GETTIMEOFDAY
diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 74777a97e394a..47a2b1f00f54e 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -59,7 +59,7 @@ config EARLY_PRINTK_USB_XDBC
 config EFI_PGT_DUMP
 	bool "Dump the EFI pagetable"
 	depends on EFI
-	select PTDUMP_CORE
+	select PTDUMP
 	help
 	  Enable this if you want to dump the EFI page table before
 	  enabling virtual mode. This can be used to debug miscellaneous
diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
index 60a53baa04279..1a2a0821c016c 100644
--- a/arch/x86/mm/Makefile
+++ b/arch/x86/mm/Makefile
@@ -41,7 +41,7 @@ CFLAGS_fault.o := -I $(src)/../include/asm/trace
 obj-$(CONFIG_X86_32)		+= pgtable_32.o iomap_32.o
 
 obj-$(CONFIG_HUGETLB_PAGE)	+= hugetlbpage.o
-obj-$(CONFIG_PTDUMP_CORE)	+= dump_pagetables.o
+obj-$(CONFIG_PTDUMP)		+= dump_pagetables.o
 obj-$(CONFIG_PTDUMP_DEBUGFS)	+= debug_pagetables.o
 
 obj-$(CONFIG_HIGHMEM)		+= highmem_32.o
diff --git a/mm/Kconfig.debug b/mm/Kconfig.debug
index a51a1149909aa..32b65073d0ccc 100644
--- a/mm/Kconfig.debug
+++ b/mm/Kconfig.debug
@@ -186,9 +186,9 @@ config ARCH_HAS_DEBUG_WX
 config DEBUG_WX
 	bool "Warn on W+X mappings at boot"
 	depends on ARCH_HAS_DEBUG_WX
-	depends on GENERIC_PTDUMP
+	depends on ARCH_HAS_PTDUMP
 	depends on MMU
-	select PTDUMP_CORE
+	select PTDUMP
 	help
 	  Generate a warning if any W+X mappings are found at boot.
 
@@ -213,18 +213,18 @@ config DEBUG_WX
 
 	  If in doubt, say "Y".
 
-config GENERIC_PTDUMP
+config ARCH_HAS_PTDUMP
 	bool
 
-config PTDUMP_CORE
+config PTDUMP
 	bool
 
 config PTDUMP_DEBUGFS
 	bool "Export kernel pagetable layout to userspace via debugfs"
 	depends on DEBUG_KERNEL
 	depends on DEBUG_FS
-	depends on GENERIC_PTDUMP
-	select PTDUMP_CORE
+	depends on ARCH_HAS_PTDUMP
+	select PTDUMP
 	help
 	  Say Y here if you want to show the kernel pagetable layout in a
 	  debugfs file. This information is only useful for kernel developers
diff --git a/mm/Makefile b/mm/Makefile
index d5639b0361663..3455c3f487d47 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -137,7 +137,7 @@ obj-$(CONFIG_ZONE_DEVICE) += memremap.o
 obj-$(CONFIG_HMM_MIRROR) += hmm.o
 obj-$(CONFIG_MEMFD_CREATE) += memfd.o
 obj-$(CONFIG_MAPPING_DIRTY_HELPERS) += mapping_dirty_helpers.o
-obj-$(CONFIG_PTDUMP_CORE) += ptdump.o
+obj-$(CONFIG_PTDUMP) += ptdump.o
 obj-$(CONFIG_PAGE_REPORTING) += page_reporting.o
 obj-$(CONFIG_IO_MAPPING) += io-mapping.o
 obj-$(CONFIG_HAVE_BOOTMEM_INFO_NODE) += bootmem_info.o
-- 
2.53.0




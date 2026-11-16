Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794820355;
	b=XYwxKo5uwWoyfa0R1s9RxR8LzaL4E3d0aUmGX/iPQBOLxvPfTzlnBHnG6UqxgLPdlB4F
	 5bLKtcaQHKob8XUQ/VSEWPT6rRPGao2bD1CiErCQJ04iO5WYzzkeTf8NMmmnFkiu1VHS1
	 fQGV8btxGoy7onYtwjff74yF4i5HmwzpIhWr3oCfrKG/niwLbrrGSrQ0XoA2w8f001KCT
	 oJblILD/cRd327lgmG+efh6m1OcPDUdAlBJXICibyjqjPEp/r/so1kTY/ZfAcGvZgd4ZC
	 4VN8FYsSS0FHVaPKgu/iSUpOk84o2Qdx/QqPzwN3BSMnTIyjAGVkAka2tr39svCStWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794820355;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=WjjbZRennH7k1LS2L28kH1nl7kQMPiIaxAInZICEkPE=;
	b=aDIuZdvaKj2AH3rVZlZacXrbBhkkNWrJiGOYMRXNMMt+eT9E1JEJFc6E8Z43OQ8+S82z
	 1bI3zTB+u1xlSVXI49TRB/Mo/e3eQ4d+9qetrnu5cA/ZJoInFd5oMWD2hu6jNBFPN7XtZ
	 BVmwvEGjFigDCdKfprhy0yjDrtLE83U+ssUsfeUYucKeGy2Jbn7hGrY1miEfbv0gYEJE9
	 y4LxZ8n5K8330vdYUU9G8v7raqNT1X1tBLn5ajOToiNYe2jy0YKJO7nE2sAza2VvVclTg
	 /DUCLTY19jzYVZLcvGTBvVPI+iNSzBC7mGfG2rv4CzVlROjVm81kZ3tOQj16Bnm6Ipg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CffN8mn5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ADA9606A31C;
	Mon, 16 Nov 2026 09:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CffN8mn5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E2621F000C7;
	Mon, 16 Nov 2026 09:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794820355;
	bh=WjjbZRennH7k1LS2L28kH1nl7kQMPiIaxAInZICEkPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CffN8mn5pxpGtfmhhzxIl8feQNIjaNLwUKrQT9+kIuaKj2Oq8XBZbVfYZRXtG42jz
	 ZzZnIlR2x/K/4gaw80Z2ipCJXPCkjbN8zz1rPSEmUI6DX/56IgDe1DIxeA4srgoHca
	 caUapQi7He985qbNsbn9YXYjMlZyAIdMFYaYe0aC1ezT3iIvvap/O3xScrADvfZ/Tz
	 nMF/SOF/w9+qlhjtZhJXM7kF+PhhP4ukU9vLdUyjxZ9829sVG1p6DF3+6UcXM0EpbP
	 MQntieDbNZoZCdMuEf333Z8vdZJ2BPTSkS4oI+7t5RthXSVTNa/TpEryWNajhCqqtp
	 qemedWmgtiF8Q==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-coco@lists.linux.dev
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <baoquan.he@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Joerg Roedel <joro@8bytes.org>,
	Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Will Deacon <will@kernel.org>,
	Russell King <linux@armlinux.org.uk>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Brian Starkey <Brian.Starkey@arm.com>,
	John Stultz <jstultz@google.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Radu Rendec <radu@rendec.net>,
	"T.J. Mercier" <tjmercier@google.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	"K . Y . Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	dri-devel@lists.freedesktop.org,
	iommu@lists.linux.dev,
	linaro-mm-sig@lists.linaro.org,
	linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org,
	linux-mm@kvack.org,
	kvmarm@lists.linux.dev,
	patches@lists.linux.dev
Subject: [PATCH v10 02/13] mm: Zero memory during shared memory transitions
Date: Mon, 16 Nov 2026 14:41:25 +0530
Message-ID: <20261116091137.94252-3-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261116091137.94252-1-aneesh.kumar@kernel.org>
References: <20261116091137.94252-1-aneesh.kumar@kernel.org>
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

Architectures need to zero memory at different points in a private-to-shared
transition. For example, pKVM must clear memory before sharing it, while Arm
CCA can only clear it after the RSI transition has completed.

Make zeroing an implicit property of set_memory_decrypted(). Each architecture
or platform performs the clear at the safe point in its transition. TDX
clears memory after the private-to-shared conversion succeeds in the finish
callback. AMD clears memory in its finish callback after the page-table
update, TLB flush, and hypervisor notification, including for SEV-SNP. This
zeros the final shared mapping without adding a flag to
set_memory_decrypted() or threading it through architecture-specific callbacks.

Keep allocations on platforms without memory encryption on the ordinary page
allocator path so the original GFP constraints, including __GFP_ZERO, remain
intact. Remove post-transition memset() calls that are now redundant and
explicitly clear allocations on paths where no transition occurs.

This intentionally makes every private-to-shared transition destructive;
callers can no longer use set_memory_decrypted() to preserve existing contents.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Shrikanth Hegde <sshegde@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: x86@kernel.org
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: K. Y. Srinivasan <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Wei Liu <wei.liu@kernel.org>
Cc: Dexuan Cui <decui@microsoft.com>
Cc: Long Li <longli@microsoft.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 arch/arm64/mm/mem_encrypt.c                   |  8 +++-
 arch/powerpc/platforms/pseries/svm.c          | 13 ++++--
 arch/s390/mm/init.c                           |  7 ++++
 arch/x86/hyperv/hv_init.c                     |  6 ++-
 arch/x86/include/asm/set_memory.h             |  1 +
 arch/x86/include/asm/vga.h                    |  4 +-
 arch/x86/kernel/kvmclock.c                    |  6 +--
 arch/x86/mm/mem_encrypt_amd.c                 |  1 +
 arch/x86/mm/pat/set_memory.c                  | 19 ++++++++-
 drivers/firmware/arm_rmm/rsi.c                |  9 ++++
 drivers/hv/connection.c                       | 41 +++++++++----------
 drivers/hv/hv.c                               | 11 ++---
 drivers/hv/hv_common.c                        |  2 -
 drivers/virt/coco/pkvm-guest/arm-pkvm-guest.c |  4 ++
 include/linux/set_memory.h                    |  8 +++-
 kernel/dma/direct.c                           | 22 ++++++----
 mm/cc_shared.c                                |  7 +---
 17 files changed, 115 insertions(+), 54 deletions(-)

diff --git a/arch/arm64/mm/mem_encrypt.c b/arch/arm64/mm/mem_encrypt.c
index ee3c0ab04384..25eb67138b28 100644
--- a/arch/arm64/mm/mem_encrypt.c
+++ b/arch/arm64/mm/mem_encrypt.c
@@ -17,6 +17,7 @@
 #include <linux/compiler.h>
 #include <linux/err.h>
 #include <linux/mm.h>
+#include <linux/string.h>
 
 #include <asm/mem_encrypt.h>
 
@@ -42,8 +43,13 @@ EXPORT_SYMBOL_GPL(set_memory_encrypted);
 
 int set_memory_decrypted(unsigned long addr, int numpages)
 {
-	if (likely(!crypt_ops) || WARN_ON(!PAGE_ALIGNED(addr)))
+	if (likely(!crypt_ops)) {
+		memset((void *)addr, 0, (size_t)numpages << PAGE_SHIFT);
 		return 0;
+	}
+
+	if (WARN_ON(!PAGE_ALIGNED(addr)))
+		return -EINVAL;
 
 	return crypt_ops->decrypt(addr, numpages);
 }
diff --git a/arch/powerpc/platforms/pseries/svm.c b/arch/powerpc/platforms/pseries/svm.c
index 7a403dbd35ee..0970f1fb76d7 100644
--- a/arch/powerpc/platforms/pseries/svm.c
+++ b/arch/powerpc/platforms/pseries/svm.c
@@ -9,6 +9,7 @@
 #include <linux/mm.h>
 #include <linux/memblock.h>
 #include <linux/mem_encrypt.h>
+#include <linux/string.h>
 #include <linux/cc_platform.h>
 #include <asm/machdep.h>
 #include <asm/svm.h>
@@ -53,13 +54,17 @@ int set_memory_encrypted(unsigned long addr, int numpages)
 
 int set_memory_decrypted(unsigned long addr, int numpages)
 {
-	if (!cc_platform_has(CC_ATTR_MEM_ENCRYPT))
-		return 0;
-
 	if (!PAGE_ALIGNED(addr))
 		return -EINVAL;
 
-	uv_share_page(PHYS_PFN(__pa(addr)), numpages);
+	if (cc_platform_has(CC_ATTR_MEM_ENCRYPT))
+		uv_share_page(PHYS_PFN(__pa(addr)), numpages);
+	/*
+	 * Firmware may scrub pages with nonzero values during
+	 * private-to-shared conversion. Clear the final shared mapping
+	 * after the transition so that callers receive zeroed memory.
+	 */
+	memset((void *)addr, 0, (size_t)numpages << PAGE_SHIFT);
 
 	return 0;
 }
diff --git a/arch/s390/mm/init.c b/arch/s390/mm/init.c
index be7e009e7b59..fdacd9380286 100644
--- a/arch/s390/mm/init.c
+++ b/arch/s390/mm/init.c
@@ -129,6 +129,13 @@ int set_memory_encrypted(unsigned long vaddr, int numpages)
 int set_memory_decrypted(unsigned long vaddr, int numpages)
 {
 	int i;
+
+	/*
+	 * uv_set_shared() exposes existing contents to the host; see the data
+	 * leakage warning in share() in asm/uv.h. Clear private data first.
+	 */
+	memset((void *)vaddr, 0, (size_t)numpages << PAGE_SHIFT);
+
 	/* make specified pages shared (swiotlb, dma_alloca) */
 	for (i = 0; i < numpages; ++i) {
 		uv_set_shared(virt_to_phys((void *)vaddr));
diff --git a/arch/x86/hyperv/hv_init.c b/arch/x86/hyperv/hv_init.c
index b90e6f487533..4356f4255ae9 100644
--- a/arch/x86/hyperv/hv_init.c
+++ b/arch/x86/hyperv/hv_init.c
@@ -156,8 +156,10 @@ static int hv_cpu_init(unsigned int cpu)
 			 * page in non-root partition here.
 			 */
 			if (*hvp && !ms_hyperv.paravisor_present && hv_isolation_type_snp()) {
-				WARN_ON_ONCE(set_memory_decrypted((unsigned long)(*hvp), 1));
-				memset(*hvp, 0, PAGE_SIZE);
+				int ret;
+
+				ret = set_memory_decrypted((unsigned long)*hvp, 1);
+				WARN_ON_ONCE(ret);
 			}
 		}
 
diff --git a/arch/x86/include/asm/set_memory.h b/arch/x86/include/asm/set_memory.h
index 39271a5ea925..dfac1dde3714 100644
--- a/arch/x86/include/asm/set_memory.h
+++ b/arch/x86/include/asm/set_memory.h
@@ -52,6 +52,7 @@ int set_memory_4k(unsigned long addr, int numpages);
 bool set_memory_enc_stop_conversion(void);
 int set_memory_encrypted(unsigned long addr, int numpages);
 int set_memory_decrypted(unsigned long addr, int numpages);
+int set_memory_decrypted_nozero(unsigned long addr, int numpages);
 
 int set_memory_np_noalias(unsigned long addr, int numpages);
 int set_memory_nonglobal(unsigned long addr, int numpages);
diff --git a/arch/x86/include/asm/vga.h b/arch/x86/include/asm/vga.h
index 46f9b2deab4d..e1e91dfa399d 100644
--- a/arch/x86/include/asm/vga.h
+++ b/arch/x86/include/asm/vga.h
@@ -14,7 +14,7 @@
  *	On the PC, we can just recalculate addresses and then
  *	access the videoram directly without any black magic.
  *	To support memory encryption however, we need to access
- *	the videoram as decrypted memory.
+ *	the videoram as decrypted memory without clearing its contents.
  */
 
 #define VGA_MAP_MEM(x, s)					\
@@ -22,7 +22,7 @@
 	unsigned long start = (unsigned long)phys_to_virt(x);	\
 								\
 	if (IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT))			\
-		set_memory_decrypted(start, (s) >> PAGE_SHIFT);	\
+		set_memory_decrypted_nozero(start, (s) >> PAGE_SHIFT);	\
 								\
 	start;							\
 })
diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index cb3d0ca1fa22..3e9b7ad3dea2 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -248,7 +248,7 @@ static void __init kvmclock_init_mem(void)
 	 * be mapped decrypted.
 	 */
 	if (cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT)) {
-		r = set_memory_decrypted((unsigned long) hvclock_mem,
+		r = set_memory_decrypted((unsigned long)hvclock_mem,
 					 1UL << order);
 		if (r) {
 			__free_pages(p, order);
@@ -256,9 +256,9 @@ static void __init kvmclock_init_mem(void)
 			pr_warn("kvmclock: set_memory_decrypted() failed. Disabling\n");
 			return;
 		}
+	} else {
+		memset(hvclock_mem, 0, PAGE_SIZE << order);
 	}
-
-	memset(hvclock_mem, 0, PAGE_SIZE << order);
 }
 
 static int __init kvm_setup_vsyscall_timeinfo(void)
diff --git a/arch/x86/mm/mem_encrypt_amd.c b/arch/x86/mm/mem_encrypt_amd.c
index 2f8c32173972..fbcd23b745cf 100644
--- a/arch/x86/mm/mem_encrypt_amd.c
+++ b/arch/x86/mm/mem_encrypt_amd.c
@@ -13,6 +13,7 @@
 #include <linux/dma-direct.h>
 #include <linux/swiotlb.h>
 #include <linux/mem_encrypt.h>
+#include <linux/string.h>
 #include <linux/device.h>
 #include <linux/kernel.h>
 #include <linux/bitops.h>
diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index b1d5c5a0ffb4..bf4466ef1220 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -2545,10 +2545,27 @@ EXPORT_SYMBOL_GPL(set_memory_encrypted);
 
 int set_memory_decrypted(unsigned long addr, int numpages)
 {
-	return __set_memory_enc_dec(addr, numpages, false);
+	int ret = __set_memory_enc_dec(addr, numpages, false);
+
+	/*
+	 * Firmware may scrub pages with nonzero values during private-to-shared
+	 * conversion. Clear the final shared mapping after the transition so
+	 * that callers receive zeroed memory.
+	 */
+	if (!ret)
+		memset((void *)addr, 0, (size_t)numpages << PAGE_SHIFT);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(set_memory_decrypted);
 
+/* Device memory needs a decrypted mapping without writes to its contents. */
+int set_memory_decrypted_nozero(unsigned long addr, int numpages)
+{
+	return __set_memory_enc_dec(addr, numpages, false);
+}
+EXPORT_SYMBOL_GPL(set_memory_decrypted_nozero);
+
 int set_pages_uc(struct page *page, int numpages)
 {
 	unsigned long addr = (unsigned long)page_address(page);
diff --git a/drivers/firmware/arm_rmm/rsi.c b/drivers/firmware/arm_rmm/rsi.c
index 0fcc4e33bd92..2c1591028b0e 100644
--- a/drivers/firmware/arm_rmm/rsi.c
+++ b/drivers/firmware/arm_rmm/rsi.c
@@ -6,6 +6,7 @@
 #include <linux/jump_label.h>
 #include <linux/memblock.h>
 #include <linux/psci.h>
+#include <linux/string.h>
 #include <linux/swiotlb.h>
 #include <linux/arm-rsi-cmds.h>
 #include <linux/kobject.h>
@@ -146,6 +147,14 @@ static int realm_set_memory_decrypted(unsigned long addr, int numpages)
 {
 	int ret = __set_memory_enc_dec(addr, numpages, false);
 
+	/*
+	 * The RMM may scrub pages with nonzero values before returning them to
+	 * the host. Zeroing before conversion would not guarantee zeroed shared
+	 * memory, so clear the final shared mapping after the transition.
+	 */
+	if (!ret)
+		memset((void *)addr, 0, (size_t)numpages << PAGE_SHIFT);
+
 	WARN(ret, "Failed to decrypt memory, %d pages will be leaked",
 	     numpages);
 
diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
index 818667ef9c74..b25bfe2f8448 100644
--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -13,6 +13,7 @@
 #include <linux/sched.h>
 #include <linux/wait.h>
 #include <linux/delay.h>
+#include <linux/cc_platform.h>
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/slab.h>
@@ -263,29 +264,27 @@ int vmbus_connect(void)
 		goto cleanup;
 	}
 
-	ret = set_memory_decrypted((unsigned long)
-				vmbus_connection.monitor_pages[0], 1);
-	ret |= set_memory_decrypted((unsigned long)
-				vmbus_connection.monitor_pages[1], 1);
-	if (ret) {
-		/*
-		 * If set_memory_decrypted() fails, the encryption state
-		 * of the memory is unknown. So leak the memory instead
-		 * of risking returning decrypted memory to the free list.
-		 * For simplicity, always handle both pages the same.
-		 */
-		vmbus_connection.monitor_pages[0] = NULL;
-		vmbus_connection.monitor_pages[1] = NULL;
-		goto cleanup;
+	if (cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT)) {
+		ret = set_memory_decrypted((unsigned long)vmbus_connection.monitor_pages[0],
+					   1);
+		ret |= set_memory_decrypted((unsigned long)vmbus_connection.monitor_pages[1],
+					    1);
+		if (ret) {
+			/*
+			 * If set_memory_decrypted() fails, the encryption state
+			 * of the memory is unknown. So leak the memory instead
+			 * of risking returning decrypted memory to the free list.
+			 * For simplicity, always handle both pages the same.
+			 */
+			vmbus_connection.monitor_pages[0] = NULL;
+			vmbus_connection.monitor_pages[1] = NULL;
+			goto cleanup;
+		}
+	} else {
+		memset(vmbus_connection.monitor_pages[0], 0, HV_HYP_PAGE_SIZE);
+		memset(vmbus_connection.monitor_pages[1], 0, HV_HYP_PAGE_SIZE);
 	}
 
-	/*
-	 * Set_memory_decrypted() will change the memory contents if
-	 * decryption occurs, so zero monitor pages here.
-	 */
-	memset(vmbus_connection.monitor_pages[0], 0x00, HV_HYP_PAGE_SIZE);
-	memset(vmbus_connection.monitor_pages[1], 0x00, HV_HYP_PAGE_SIZE);
-
 	msginfo = kzalloc(sizeof(*msginfo) +
 			  sizeof(struct vmbus_channel_initiate_contact),
 			  GFP_KERNEL);
diff --git a/drivers/hv/hv.c b/drivers/hv/hv.c
index fe50090dcc01..6e836a02910a 100644
--- a/drivers/hv/hv.c
+++ b/drivers/hv/hv.c
@@ -123,12 +123,13 @@ static int hv_alloc_page(void **page, bool decrypt, const char *note)
 	if (!*page)
 		return -ENOMEM;
 
-	if (decrypt)
+	if (decrypt) {
 		ret = set_memory_decrypted((unsigned long)*page, 1);
-	if (ret)
-		goto failed;
-
-	memset(*page, 0, PAGE_SIZE);
+		if (ret)
+			goto failed;
+	} else {
+		memset(*page, 0, PAGE_SIZE);
+	}
 	return 0;
 
 failed:
diff --git a/drivers/hv/hv_common.c b/drivers/hv/hv_common.c
index df2577896271..404d2436346e 100644
--- a/drivers/hv/hv_common.c
+++ b/drivers/hv/hv_common.c
@@ -534,8 +534,6 @@ int hv_common_cpu_init(unsigned int cpu)
 				/* It may be unsafe to free 'mem' */
 				return ret;
 			}
-
-			memset(mem, 0x00, pgcount * HV_HYP_PAGE_SIZE);
 		}
 
 		/*
diff --git a/drivers/virt/coco/pkvm-guest/arm-pkvm-guest.c b/drivers/virt/coco/pkvm-guest/arm-pkvm-guest.c
index 26fe9c3f22e3..54a27b81458a 100644
--- a/drivers/virt/coco/pkvm-guest/arm-pkvm-guest.c
+++ b/drivers/virt/coco/pkvm-guest/arm-pkvm-guest.c
@@ -13,6 +13,7 @@
 #include <linux/mem_encrypt.h>
 #include <linux/mm.h>
 #include <linux/pgtable.h>
+#include <linux/string.h>
 
 #include <asm/hypervisor.h>
 
@@ -61,6 +62,9 @@ static int pkvm_set_memory_encrypted(unsigned long addr, int numpages)
 
 static int pkvm_set_memory_decrypted(unsigned long addr, int numpages)
 {
+	/* Sharing exposes the existing contents to the host; clear them first. */
+	memset((void *)addr, 0, (size_t)numpages << PAGE_SHIFT);
+
 	return __set_memory_range(ARM_SMCCC_VENDOR_HYP_KVM_MEM_SHARE_FUNC_ID,
 				  addr, numpages);
 }
diff --git a/include/linux/set_memory.h b/include/linux/set_memory.h
index 27c32fbabfec..09f9ea06da6f 100644
--- a/include/linux/set_memory.h
+++ b/include/linux/set_memory.h
@@ -5,6 +5,10 @@
 #ifndef _LINUX_SET_MEMORY_H_
 #define _LINUX_SET_MEMORY_H_
 
+#include <linux/string.h>
+
+#include <asm/page.h>
+
 /**
  * DOC: Kernel page table permissions
  *
@@ -21,7 +25,8 @@
  *
  * When an architecture does not implement these APIs they succeed without
  * doing anything, so a return value of 0 does not mean that the permissions
- * were actually changed.
+ * were actually changed. set_memory_decrypted() also clears the range,
+ * including when no encryption change is needed. It is for normal RAM only.
  *
  * Callers that depend on the permissions being applied must ensure that the
  * architecture supports the required operation for the target addresses. The
@@ -186,6 +191,7 @@ static inline int set_memory_encrypted(unsigned long addr, int numpages)
 
 static inline int set_memory_decrypted(unsigned long addr, int numpages)
 {
+	memset((void *)addr, 0, (size_t)numpages << PAGE_SHIFT);
 	return 0;
 }
 #endif /* CONFIG_ARCH_HAS_MEM_ENCRYPT */
diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index 25e9a86835fd..596c90e8f890 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -229,7 +229,8 @@ void *dma_direct_alloc(struct device *dev, size_t size,
 	if (force_dma_unencrypted(dev))
 		attrs |= __DMA_ATTR_ALLOC_CC_SHARED;
 
-	if (attrs & __DMA_ATTR_ALLOC_CC_SHARED) {
+	mark_mem_decrypt = attrs & __DMA_ATTR_ALLOC_CC_SHARED;
+	if (mark_mem_decrypt) {
 		/*
 		 * Unencrypted/shared DMA requires a linear-mapped buffer
 		 * address to look up the PFN and set architecture-required PFN
@@ -237,7 +238,6 @@ void *dma_direct_alloc(struct device *dev, size_t size,
 		 * allocation.
 		 */
 		allow_highmem = false;
-		mark_mem_decrypt = true;
 	}
 
 	size = PAGE_ALIGN(size);
@@ -341,7 +341,9 @@ void *dma_direct_alloc(struct device *dev, size_t size,
 		cpu_addr = page_address(page);
 	}
 
-	memset(cpu_addr, 0, size);
+	/* Zero after remapping because the page may be in HighMem. */
+	if (!mark_mem_decrypt)
+		memset(cpu_addr, 0, size);
 
 	if (set_uncached) {
 		void *uncached_cpu_addr;
@@ -451,10 +453,13 @@ struct page *dma_direct_alloc_pages(struct device *dev, size_t size,
 	unsigned long attrs = 0;
 	struct page *page;
 	void *cpu_addr;
+	bool mark_mem_decrypt;
 
 	if (force_dma_unencrypted(dev))
 		attrs |= __DMA_ATTR_ALLOC_CC_SHARED;
 
+	mark_mem_decrypt = attrs & __DMA_ATTR_ALLOC_CC_SHARED;
+
 	if ((attrs & __DMA_ATTR_ALLOC_CC_SHARED) && dma_direct_use_pool(dev, gfp))
 		return dma_direct_alloc_from_pool(dev, size, dma_handle,
 						  &cpu_addr, gfp, attrs);
@@ -465,6 +470,7 @@ struct page *dma_direct_alloc_pages(struct device *dev, size_t size,
 			return NULL;
 
 		cpu_addr = page_address(page);
+		mark_mem_decrypt = false;
 		goto setup_page;
 	}
 
@@ -473,11 +479,13 @@ struct page *dma_direct_alloc_pages(struct device *dev, size_t size,
 		return NULL;
 
 	cpu_addr = page_address(page);
-	if ((attrs & __DMA_ATTR_ALLOC_CC_SHARED) &&
-	    dma_set_decrypted(dev, cpu_addr, size))
-		goto out_leak_pages;
 setup_page:
-	memset(cpu_addr, 0, size);
+	if (mark_mem_decrypt) {
+		if (dma_set_decrypted(dev, cpu_addr, size))
+			goto out_leak_pages;
+	} else {
+		memset(cpu_addr, 0, size);
+	}
 	*dma_handle = phys_to_dma_direct(dev, page_to_phys(page),
 					 attrs & __DMA_ATTR_ALLOC_CC_SHARED);
 	return page;
diff --git a/mm/cc_shared.c b/mm/cc_shared.c
index 77ee65c4c35e..c9b4e3dfe06a 100644
--- a/mm/cc_shared.c
+++ b/mm/cc_shared.c
@@ -104,7 +104,6 @@ static int __alloc_cc_shared_pages_node(int nid, gfp_t gfp,
 	struct cc_shared_layout layout;
 	struct page *page;
 	unsigned int order;
-	bool zero = gfp & __GFP_ZERO;
 	int ret;
 
 	ret = cc_shared_calc_layout(requested, &layout);
@@ -116,7 +115,8 @@ static int __alloc_cc_shared_pages_node(int nid, gfp_t gfp,
 		return -EINVAL;
 	/*
 	 * State transitions require a linear-map address and may modify memory.
-	 * Allocate from low memory and defer requested zeroing until afterwards.
+	 * Allocate from low memory and let the architecture place zeroing at the
+	 * appropriate point in the transition.
 	 * Shared allocations have no migration support, so they must not
 	 * be allocated with __GFP_MOVABLE.
 	 */
@@ -143,9 +143,6 @@ static int __alloc_cc_shared_pages_node(int nid, gfp_t gfp,
 		return ret;
 	}
 
-	if (zero)
-		memset(page_address(page), 0, layout.shared_size);
-
 	mem->page = page;
 	mem->shared_size = layout.shared_size;
 	return 0;
-- 
2.43.0


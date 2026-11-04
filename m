Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793810848;
	b=Vw8xrgT6uwgxPdzxYmibe6GP6b4PymVgT1SWHEP90rdcCsHn4V99NzDFwvmgzFfkDu9y
	 3OtjzvycYGZ1ABa/wH7Mx9FKxWhFrJg1m/C1Wbf0GSkKp+XOn1jynGPIUFT+KhNKwkIqZ
	 TryDHy5CpKk4d2RhJ2T90wZmFYhCsGCOfK/2Dmnd5t/1Z+1URf+lhNhbPATg6KbiJ9d1t
	 NGD8fTKLQOZjL5Dt2wlJBJDCuO++JNY3ZMi4rUVd449lbI1O6ykzUsiwfDN6+usZxa243
	 d5jX3OPofbCWFAaXL3FX4vkCqbHNF+bjmFT7xTefA6prU6zf4i5SbxYYtP/lJc57Ctg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793810848;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=cMGj0+A3tufzvmK6r4xBew1uKsqkG3dGnoyqLpE0FO8=;
	b=IWcCtJ6qweCUioCFk3OleHGdym/4BhafW4oNOeLjlW0vJz5eXjxhKPL3rQvxvDJrIRhf
	 J85jv8w0T4EzhyHQl1ReDEwpWf7fgf9mvruuQcNIqA3uXVot3HcFUaJdAwOkerfuEmhxq
	 0pUOZaW4l+3pZKX8XpE8TtOBiLlysg1Jr3KFebMVuw7HZzOasf9lcQRf8HkCa3Cp+31ie
	 jOcFh2BnpA4Nq1xe6gNSAWh2t3R/fQXRNSDTBjAIdlHMPriIea+rNuPaOOSJ7mBw+0r/8
	 PJSwo5jB5zIEGCo8UT83//Rt3xaIJKklC3t96VX5TXzUakSUH+RRD+NiEweK4wYJ8aw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bFe5Avgb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F81D6083637;
	Wed,  4 Nov 2026 16:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bFe5Avgb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D45F31F01802;
	Wed,  4 Nov 2026 16:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793810847;
	bh=cMGj0+A3tufzvmK6r4xBew1uKsqkG3dGnoyqLpE0FO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bFe5Avgb1illdcHB6vAcY3QsQJihZbQdYsYHxI4NN6JQr73MDhLvrFJVZcAbpSO6k
	 3eJwIwozTgJJjTDJyp03ifb9O5AbU8+8cN9zj2fipCyeoeNRGFAYK/akt2IcbmhvG+
	 J/eDdVGdJpUChP0xql1/KSqLRrEUUTzJ74+6DzCLIcyYv00UV4P8DRS7rHkkc28j7X
	 96mLrD4RJh4rz/AcX/FwqLno05hLrN4f1R0/RIsuAW5dssL6kCOZkTtZ9LSvbp3sJt
	 KGISz39g0V7UsNTs1utBi0qhLDt144FI2ENl3pNvUfZu6n93JQegweMqpM6SHsu0zW
	 o4qoNeOIBZzvg==
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
Subject: [PATCH v9 02/14] mm: Zero memory during shared memory transitions
Date: Wed,  4 Nov 2026 22:15:43 +0530
Message-ID: <20261104164555.3555725-3-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261104164555.3555725-1-aneesh.kumar@kernel.org>
References: <20261104164555.3555725-1-aneesh.kumar@kernel.org>
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
 arch/powerpc/platforms/pseries/svm.c          |  2 +
 arch/s390/mm/init.c                           |  3 ++
 arch/x86/coco/tdx/tdx.c                       |  3 ++
 arch/x86/hyperv/hv_init.c                     |  6 ++-
 arch/x86/hyperv/ivm.c                         |  4 ++
 arch/x86/kernel/kvmclock.c                    |  6 +--
 arch/x86/mm/mem_encrypt_amd.c                 |  4 ++
 drivers/firmware/arm_rmm/rsi.c                |  4 ++
 drivers/hv/connection.c                       | 41 +++++++++----------
 drivers/hv/hv.c                               | 11 ++---
 drivers/hv/hv_common.c                        |  2 -
 drivers/virt/coco/pkvm-guest/arm-pkvm-guest.c |  3 ++
 kernel/dma/direct.c                           | 22 ++++++----
 mm/cc_shared.c                                |  7 +---
 14 files changed, 73 insertions(+), 45 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/svm.c b/arch/powerpc/platforms/pseries/svm.c
index 7a403dbd35ee..a344e094fe1c 100644
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
@@ -59,6 +60,7 @@ int set_memory_decrypted(unsigned long addr, int numpages)
 	if (!PAGE_ALIGNED(addr))
 		return -EINVAL;
 
+	memset((void *)addr, 0, (size_t)numpages << PAGE_SHIFT);
 	uv_share_page(PHYS_PFN(__pa(addr)), numpages);
 
 	return 0;
diff --git a/arch/s390/mm/init.c b/arch/s390/mm/init.c
index be7e009e7b59..f2e28a2710e0 100644
--- a/arch/s390/mm/init.c
+++ b/arch/s390/mm/init.c
@@ -129,6 +129,9 @@ int set_memory_encrypted(unsigned long vaddr, int numpages)
 int set_memory_decrypted(unsigned long vaddr, int numpages)
 {
 	int i;
+
+	memset((void *)vaddr, 0, (size_t)numpages << PAGE_SHIFT);
+
 	/* make specified pages shared (swiotlb, dma_alloca) */
 	for (i = 0; i < numpages; ++i) {
 		uv_set_shared(virt_to_phys((void *)vaddr));
diff --git a/arch/x86/coco/tdx/tdx.c b/arch/x86/coco/tdx/tdx.c
index 8bacbef62891..d673d23a2237 100644
--- a/arch/x86/coco/tdx/tdx.c
+++ b/arch/x86/coco/tdx/tdx.c
@@ -980,6 +980,9 @@ static int tdx_enc_status_change_finish(unsigned long vaddr, int numpages,
 	if (!enc && !tdx_enc_status_changed(vaddr, numpages, enc))
 		return -EIO;
 
+	if (!enc)
+		memset((void *)vaddr, 0, (size_t)numpages << PAGE_SHIFT);
+
 	if (enc)
 		atomic_long_sub(numpages, &nr_shared);
 	else
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
 
diff --git a/arch/x86/hyperv/ivm.c b/arch/x86/hyperv/ivm.c
index 2ce4dfe53472..e9c7799a0094 100644
--- a/arch/x86/hyperv/ivm.c
+++ b/arch/x86/hyperv/ivm.c
@@ -755,6 +755,10 @@ static int hv_mark_gpa_visibility(u16 count, const u64 pfn[],
  */
 static int hv_vtom_clear_present(unsigned long kbuffer, int pagecount, bool enc)
 {
+	if (!enc)
+		memset((void *)kbuffer, 0,
+		       (size_t)pagecount << PAGE_SHIFT);
+
 	return set_memory_np(kbuffer, pagecount);
 }
 
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
index 2f8c32173972..a1199a74e9a3 100644
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
@@ -308,6 +309,9 @@ static int amd_enc_status_change_finish(unsigned long vaddr, int npages, bool en
 	if (!cc_platform_has(CC_ATTR_HOST_MEM_ENCRYPT))
 		enc_dec_hypercall(vaddr, npages << PAGE_SHIFT, enc);
 
+	if (!enc)
+		memset((void *)vaddr, 0, (size_t)npages << PAGE_SHIFT);
+
 	return 0;
 }
 
diff --git a/drivers/firmware/arm_rmm/rsi.c b/drivers/firmware/arm_rmm/rsi.c
index 0fcc4e33bd92..fade7699ff6c 100644
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
@@ -146,6 +147,9 @@ static int realm_set_memory_decrypted(unsigned long addr, int numpages)
 {
 	int ret = __set_memory_enc_dec(addr, numpages, false);
 
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
index 27b9b79d4f4c..37f7eaa94551 100644
--- a/drivers/hv/hv_common.c
+++ b/drivers/hv/hv_common.c
@@ -535,8 +535,6 @@ int hv_common_cpu_init(unsigned int cpu)
 				/* It may be unsafe to free 'mem' */
 				return ret;
 			}
-
-			memset(mem, 0x00, pgcount * HV_HYP_PAGE_SIZE);
 		}
 
 		/*
diff --git a/drivers/virt/coco/pkvm-guest/arm-pkvm-guest.c b/drivers/virt/coco/pkvm-guest/arm-pkvm-guest.c
index 26fe9c3f22e3..7d922e0a28f9 100644
--- a/drivers/virt/coco/pkvm-guest/arm-pkvm-guest.c
+++ b/drivers/virt/coco/pkvm-guest/arm-pkvm-guest.c
@@ -13,6 +13,7 @@
 #include <linux/mem_encrypt.h>
 #include <linux/mm.h>
 #include <linux/pgtable.h>
+#include <linux/string.h>
 
 #include <asm/hypervisor.h>
 
@@ -61,6 +62,8 @@ static int pkvm_set_memory_encrypted(unsigned long addr, int numpages)
 
 static int pkvm_set_memory_decrypted(unsigned long addr, int numpages)
 {
+	memset((void *)addr, 0, (size_t)numpages << PAGE_SHIFT);
+
 	return __set_memory_range(ARM_SMCCC_VENDOR_HYP_KVM_MEM_SHARE_FUNC_ID,
 				  addr, numpages);
 }
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
index 5c4c971cfb7b..40c130cce74b 100644
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
@@ -138,9 +138,6 @@ static int __alloc_cc_shared_pages_node(int nid, gfp_t gfp,
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


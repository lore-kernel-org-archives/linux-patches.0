Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AAA51420BE;
	Tue, 23 Apr 2024 21:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908700; cv=none; b=I+8t7oJkrh6vMdCXk9gDXoK9lxhljr4W1MAjUCE5mjCtvaGHSKxM7jy5h/zOGtCaOJg90ltEezPq+3HJPJceqSxvmWjdLZo4pCLuXwwQ1HLFiQ3MSFnNmH7i57AasPiX4Tck2NVR5mLoZM89JPNqFjYv08y1p1twbRvBc/yGNt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908700; c=relaxed/simple;
	bh=VYq/LBVVhXDVhqwT7cbCXUOCleEBefFp2IOEkco136A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fFuTAGE1aX/uZwSC3PBnNddFidxPt94bc9OWapb21voTD7soD2ffv0bAVNHq7PZ/uSydyc+lco7MpBaI1/Dwnpm2Kxhj8ARFi+/szjUhXvcmjs+mfzdt6GAiQtI1lu614RAuws6r2RVSnPMFLEqwNiEoyfiYt8AR2EZyu418rYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vs0vf6fi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vs0vf6fi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70171C32781;
	Tue, 23 Apr 2024 21:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908700;
	bh=VYq/LBVVhXDVhqwT7cbCXUOCleEBefFp2IOEkco136A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vs0vf6fiqaj6jrUukx0XnOeRYEWRwL81M63Hp7oght2ZxAnvwbNRPbfarjwE1onIy
	 CfSP7xAWSb6a7rBYHs+pW1LjviN6JkYFmGQSkuDDVUmbAb8i9Id4mwSuZhPkPXKkkW
	 wE4sTkwB4QGJHnVESnK4r29sC7urqoGcViCdK4h0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Borislav Petkov <bp@suse.de>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Mike Rapoport <rppt@linux.ibm.com>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.1 028/141] x86/mm: Remove P*D_PAGE_MASK and P*D_PAGE_SIZE macros
Date: Tue, 23 Apr 2024 14:38:16 -0700
Message-ID: <20240423213854.226847493@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213853.356988651@linuxfoundation.org>
References: <20240423213853.356988651@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pasha Tatashin <pasha.tatashin@soleen.com>

[ Commit 82328227db8f0b9b5f77bb5afcd47e59d0e4d08f upstream ]

Other architectures and the common mm/ use P*D_MASK, and P*D_SIZE.
Remove the duplicated P*D_PAGE_MASK and P*D_PAGE_SIZE which are only
used in x86/*.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Link: https://lore.kernel.org/r/20220516185202.604654-1-tatashin@google.com
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/page_types.h  |   12 +++---------
 arch/x86/kernel/amd_gart_64.c      |    2 +-
 arch/x86/kernel/head64.c           |    2 +-
 arch/x86/mm/mem_encrypt_boot.S     |    4 ++--
 arch/x86/mm/mem_encrypt_identity.c |   18 +++++++++---------
 arch/x86/mm/pat/set_memory.c       |    6 +++---
 arch/x86/mm/pti.c                  |    2 +-
 7 files changed, 20 insertions(+), 26 deletions(-)

--- a/arch/x86/include/asm/page_types.h
+++ b/arch/x86/include/asm/page_types.h
@@ -11,20 +11,14 @@
 #define PAGE_SIZE		(_AC(1,UL) << PAGE_SHIFT)
 #define PAGE_MASK		(~(PAGE_SIZE-1))
 
-#define PMD_PAGE_SIZE		(_AC(1, UL) << PMD_SHIFT)
-#define PMD_PAGE_MASK		(~(PMD_PAGE_SIZE-1))
-
-#define PUD_PAGE_SIZE		(_AC(1, UL) << PUD_SHIFT)
-#define PUD_PAGE_MASK		(~(PUD_PAGE_SIZE-1))
-
 #define __VIRTUAL_MASK		((1UL << __VIRTUAL_MASK_SHIFT) - 1)
 
-/* Cast *PAGE_MASK to a signed type so that it is sign-extended if
+/* Cast P*D_MASK to a signed type so that it is sign-extended if
    virtual addresses are 32-bits but physical addresses are larger
    (ie, 32-bit PAE). */
 #define PHYSICAL_PAGE_MASK	(((signed long)PAGE_MASK) & __PHYSICAL_MASK)
-#define PHYSICAL_PMD_PAGE_MASK	(((signed long)PMD_PAGE_MASK) & __PHYSICAL_MASK)
-#define PHYSICAL_PUD_PAGE_MASK	(((signed long)PUD_PAGE_MASK) & __PHYSICAL_MASK)
+#define PHYSICAL_PMD_PAGE_MASK	(((signed long)PMD_MASK) & __PHYSICAL_MASK)
+#define PHYSICAL_PUD_PAGE_MASK	(((signed long)PUD_MASK) & __PHYSICAL_MASK)
 
 #define HPAGE_SHIFT		PMD_SHIFT
 #define HPAGE_SIZE		(_AC(1,UL) << HPAGE_SHIFT)
--- a/arch/x86/kernel/amd_gart_64.c
+++ b/arch/x86/kernel/amd_gart_64.c
@@ -504,7 +504,7 @@ static __init unsigned long check_iommu_
 	}
 
 	a = aper + iommu_size;
-	iommu_size -= round_up(a, PMD_PAGE_SIZE) - a;
+	iommu_size -= round_up(a, PMD_SIZE) - a;
 
 	if (iommu_size < 64*1024*1024) {
 		pr_warn("PCI-DMA: Warning: Small IOMMU %luMB."
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -203,7 +203,7 @@ unsigned long __head __startup_64(unsign
 	load_delta = physaddr - (unsigned long)(_text - __START_KERNEL_map);
 
 	/* Is the address not 2M aligned? */
-	if (load_delta & ~PMD_PAGE_MASK)
+	if (load_delta & ~PMD_MASK)
 		for (;;);
 
 	/* Include the SME encryption mask in the fixup value */
--- a/arch/x86/mm/mem_encrypt_boot.S
+++ b/arch/x86/mm/mem_encrypt_boot.S
@@ -26,7 +26,7 @@ SYM_FUNC_START(sme_encrypt_execute)
 	 *   RCX - virtual address of the encryption workarea, including:
 	 *     - stack page (PAGE_SIZE)
 	 *     - encryption routine page (PAGE_SIZE)
-	 *     - intermediate copy buffer (PMD_PAGE_SIZE)
+	 *     - intermediate copy buffer (PMD_SIZE)
 	 *    R8 - physical address of the pagetables to use for encryption
 	 */
 
@@ -123,7 +123,7 @@ SYM_FUNC_START(__enc_copy)
 	wbinvd				/* Invalidate any cache entries */
 
 	/* Copy/encrypt up to 2MB at a time */
-	movq	$PMD_PAGE_SIZE, %r12
+	movq	$PMD_SIZE, %r12
 1:
 	cmpq	%r12, %r9
 	jnb	2f
--- a/arch/x86/mm/mem_encrypt_identity.c
+++ b/arch/x86/mm/mem_encrypt_identity.c
@@ -93,7 +93,7 @@ struct sme_populate_pgd_data {
  * section is 2MB aligned to allow for simple pagetable setup using only
  * PMD entries (see vmlinux.lds.S).
  */
-static char sme_workarea[2 * PMD_PAGE_SIZE] __section(".init.scratch");
+static char sme_workarea[2 * PMD_SIZE] __section(".init.scratch");
 
 static char sme_cmdline_arg[] __initdata = "mem_encrypt";
 static char sme_cmdline_on[]  __initdata = "on";
@@ -197,8 +197,8 @@ static void __init __sme_map_range_pmd(s
 	while (ppd->vaddr < ppd->vaddr_end) {
 		sme_populate_pgd_large(ppd);
 
-		ppd->vaddr += PMD_PAGE_SIZE;
-		ppd->paddr += PMD_PAGE_SIZE;
+		ppd->vaddr += PMD_SIZE;
+		ppd->paddr += PMD_SIZE;
 	}
 }
 
@@ -224,11 +224,11 @@ static void __init __sme_map_range(struc
 	vaddr_end = ppd->vaddr_end;
 
 	/* If start is not 2MB aligned, create PTE entries */
-	ppd->vaddr_end = ALIGN(ppd->vaddr, PMD_PAGE_SIZE);
+	ppd->vaddr_end = ALIGN(ppd->vaddr, PMD_SIZE);
 	__sme_map_range_pte(ppd);
 
 	/* Create PMD entries */
-	ppd->vaddr_end = vaddr_end & PMD_PAGE_MASK;
+	ppd->vaddr_end = vaddr_end & PMD_MASK;
 	__sme_map_range_pmd(ppd);
 
 	/* If end is not 2MB aligned, create PTE entries */
@@ -325,7 +325,7 @@ void __init sme_encrypt_kernel(struct bo
 
 	/* Physical addresses gives us the identity mapped virtual addresses */
 	kernel_start = __pa_symbol(_text);
-	kernel_end = ALIGN(__pa_symbol(_end), PMD_PAGE_SIZE);
+	kernel_end = ALIGN(__pa_symbol(_end), PMD_SIZE);
 	kernel_len = kernel_end - kernel_start;
 
 	initrd_start = 0;
@@ -355,12 +355,12 @@ void __init sme_encrypt_kernel(struct bo
 	 *   executable encryption area size:
 	 *     stack page (PAGE_SIZE)
 	 *     encryption routine page (PAGE_SIZE)
-	 *     intermediate copy buffer (PMD_PAGE_SIZE)
+	 *     intermediate copy buffer (PMD_SIZE)
 	 *   pagetable structures for the encryption of the kernel
 	 *   pagetable structures for workarea (in case not currently mapped)
 	 */
 	execute_start = workarea_start;
-	execute_end = execute_start + (PAGE_SIZE * 2) + PMD_PAGE_SIZE;
+	execute_end = execute_start + (PAGE_SIZE * 2) + PMD_SIZE;
 	execute_len = execute_end - execute_start;
 
 	/*
@@ -383,7 +383,7 @@ void __init sme_encrypt_kernel(struct bo
 	 * before it is mapped.
 	 */
 	workarea_len = execute_len + pgtable_area_len;
-	workarea_end = ALIGN(workarea_start + workarea_len, PMD_PAGE_SIZE);
+	workarea_end = ALIGN(workarea_start + workarea_len, PMD_SIZE);
 
 	/*
 	 * Set the address to the start of where newly created pagetable
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -747,11 +747,11 @@ phys_addr_t slow_virt_to_phys(void *__vi
 	switch (level) {
 	case PG_LEVEL_1G:
 		phys_addr = (phys_addr_t)pud_pfn(*(pud_t *)pte) << PAGE_SHIFT;
-		offset = virt_addr & ~PUD_PAGE_MASK;
+		offset = virt_addr & ~PUD_MASK;
 		break;
 	case PG_LEVEL_2M:
 		phys_addr = (phys_addr_t)pmd_pfn(*(pmd_t *)pte) << PAGE_SHIFT;
-		offset = virt_addr & ~PMD_PAGE_MASK;
+		offset = virt_addr & ~PMD_MASK;
 		break;
 	default:
 		phys_addr = (phys_addr_t)pte_pfn(*pte) << PAGE_SHIFT;
@@ -1041,7 +1041,7 @@ __split_large_page(struct cpa_data *cpa,
 	case PG_LEVEL_1G:
 		ref_prot = pud_pgprot(*(pud_t *)kpte);
 		ref_pfn = pud_pfn(*(pud_t *)kpte);
-		pfninc = PMD_PAGE_SIZE >> PAGE_SHIFT;
+		pfninc = PMD_SIZE >> PAGE_SHIFT;
 		lpaddr = address & PUD_MASK;
 		lpinc = PMD_SIZE;
 		/*
--- a/arch/x86/mm/pti.c
+++ b/arch/x86/mm/pti.c
@@ -592,7 +592,7 @@ static void pti_set_kernel_image_nonglob
 	 * of the image.
 	 */
 	unsigned long start = PFN_ALIGN(_text);
-	unsigned long end = ALIGN((unsigned long)_end, PMD_PAGE_SIZE);
+	unsigned long end = ALIGN((unsigned long)_end, PMD_SIZE);
 
 	/*
 	 * This clears _PAGE_GLOBAL from the entire kernel image.



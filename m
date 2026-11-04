Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826893;
	b=JmgraHQcmvY4JyEYNu11dC3efyxrinpUgVBJ9U+/NMhQwPdd1hRGu0m4oZbpa6nclR0d
	 NG4W58qzlPbEn+YVPNtxT0Bg2QrmFm81iDS9eHhhY4YriDUGf1kShCrCA4/bareg0z0vW
	 iBy17ADy772u07k1f8wDQPQeQ1/RHBt5I6C00T1J8t90SKUVH1Fxdi4JiDpKm0tm1P1/n
	 6DW/UGRHk9WW94jf7KntJjM3N3NQuasvSzC9EYWoouawurR+Nx1d2Pq/fSKpxrzl/s2Sk
	 gIKP2f/Tv5Ybq1PObBLVEVy6sHXdmmm2L9qsndJ0FpjJ9QV9gwqBPOdC37MBdtugzQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826893;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KG6t7i+XBtMsELlwzn00XE39bNVHUODMb5Q05leb3BA=;
	b=O2XN2ETKxkYG9m4pAZTaCjyF+JAc+y8THUOFudiQvHKssPg0jSj+slqQ2o4L6sow0Cq/
	 o/uQzNfSRovdyz04G0RIwP3imKhcJiLR2e4L9HNRby8Q9MYjD8btMx48lRjMZFKapMG1p
	 fcSxN9aXkFXLLeEGCPaGuBAjV8Yi5VL+7N0N21Von7WcRZafkDsnxzl4WGA2FIIYGcnmB
	 vk+6U2U/utkXQ2LoxlanCN0bFstRvn/zc9tA/D4EC0qlcz5uGgYZLXItD2YEg/SWiw1Li
	 zqfP/vtTOUgPSc9u/nzOPjgVoe7Z4P9oHqKvKKlNZxLG1vCEUY35bxPOL3eSdaVFvOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gulcMlWa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D43F607075C;
	Wed,  4 Nov 2026 21:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gulcMlWa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAC7E1F00A1F;
	Wed,  4 Nov 2026 21:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826893;
	bh=KG6t7i+XBtMsELlwzn00XE39bNVHUODMb5Q05leb3BA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gulcMlWaX5Qwc7z5SJxq4dcyfVdQbT7WbmESlv0O6cclFqb1Weco2ZuLbaNaIsbSm
	 C+ydTMBol67tOWAsw9KoJCDcGs6oa/AzUf9EVEkU5UuaqVoptDrknegQEZ2UVpcG70
	 Pcb68HQDOYRtAC57j5WoohHZPcmXR+i+Q24CSYto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muchun Song <muchun.song@linux.dev>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 7.3 070/547] ARM: 9524/1: mm: align hugetlb mappings to the huge page size
Date: Wed,  4 Nov 2026 16:04:14 -0500
Message-ID: <20261104211040.253079079@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

commit 1eb87d8f77379d4e4b279487b8c859fb64bd1afb upstream.

mmap(MAP_HUGETLB) on 32-bit Arm can return an address which is not
aligned to the huge page size. In a QEMU virt guest, unmapping the VMA
then hits the alignment check in __unmap_hugepage_range():

  kernel BUG at mm/hugetlb.c:5213!
  Internal error: Oops - BUG: 0 [#1] SMP ARM
  PC is at __unmap_hugepage_range+0x540/0x584
  LR is at __zap_vma_range+0x13a0/0x1410

Commit 7bd3f1e1a9ae ("mm: make hugetlb mappings go through
mm_get_unmapped_area_vmflags") made hugetlb mappings use the
architecture's arch_get_unmapped_area(). The generic implementations
handle hugetlb alignment, but the Arm implementations only account for
the optional SHMLBA cache-colouring constraint. A 4 KiB-page kernel can
therefore align the mapping to 4 KiB or 16 KiB instead of the required
2 MiB.

Set the alignment mask from the file's hstate for hugetlb mappings in
both Arm implementations. Huge-page alignment also satisfies the
SHMLBA constraint.

Assisted-by: LLM

Fixes: 7bd3f1e1a9ae ("mm: make hugetlb mappings go through mm_get_unmapped_area_vmflags")
Cc: stable@vger.kernel.org
Acked-by: Muchun Song <muchun.song@linux.dev>
Link: https://lore.kernel.org/r/20260901085740.66283-1-kmehltretter@gmail.com/
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/mm/mmap.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/arch/arm/mm/mmap.c
+++ b/arch/arm/mm/mmap.c
@@ -11,6 +11,7 @@
 #include <linux/io.h>
 #include <linux/personality.h>
 #include <linux/random.h>
+#include <linux/hugetlb.h>
 #include <asm/cachetype.h>
 
 #define COLOUR_ALIGN(addr,pgoff)		\
@@ -72,7 +73,10 @@ arch_get_unmapped_area(struct file *filp
 	info.length = len;
 	info.low_limit = mm->mmap_base;
 	info.high_limit = TASK_SIZE;
-	info.align_mask = do_align ? (PAGE_MASK & (SHMLBA - 1)) : 0;
+	if (filp && is_file_hugepages(filp))
+		info.align_mask = huge_page_mask_align(filp);
+	else
+		info.align_mask = do_align ? (PAGE_MASK & (SHMLBA - 1)) : 0;
 	info.align_offset = pgoff << PAGE_SHIFT;
 	return vm_unmapped_area(&info);
 }
@@ -123,7 +127,10 @@ arch_get_unmapped_area_topdown(struct fi
 	info.length = len;
 	info.low_limit = FIRST_USER_ADDRESS;
 	info.high_limit = mm->mmap_base;
-	info.align_mask = do_align ? (PAGE_MASK & (SHMLBA - 1)) : 0;
+	if (filp && is_file_hugepages(filp))
+		info.align_mask = huge_page_mask_align(filp);
+	else
+		info.align_mask = do_align ? (PAGE_MASK & (SHMLBA - 1)) : 0;
 	info.align_offset = pgoff << PAGE_SHIFT;
 	addr = vm_unmapped_area(&info);
 



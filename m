Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831122;
	b=DGE/yIQIvJWSyGGRmIIs3AAiZNFaXe9F+fvwAtzZgtsI5EiwU5qWOc+xafTfB72jicgz
	 nFpb2X+FSdHtfGvQikqleWuTR2mls2j/RloyE6G7VbNAjrdVpzTiC6hKMRh5CKmOFglcE
	 yN+yKYJP7CWpKgPn6Yg5/dQFb5u8xnatPwbsWLVnTEOCQxI5D+Iffpe2PVycsIeFst1R5
	 5kVabnPz9mkr74Rb6oJ2nSreacSD277ArTZ2OxAz6CLNQrdT/4ihFIur92lbJE5gf9EjW
	 qd98CDCFEGl/JOQ2KniMwOpSVLV/2nNY0eJ9ELyL4H1naB86XO3IJ+lov2fS6vCFrlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831122;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ibb07V14NYZrYfACU/QgCn8hJfUEk9qhjsE6cuNXFrg=;
	b=m4SIddKjd0McbB5dJi8piwMjO2MmQyfhYqBycub+yxQANw+5LXXfb6f/oZRIwznwzSWe
	 k6IWN9GMsVnbYzcgvELLJZbk54nxCV0rQRfMundERnArstys07uSE8f8SG83T0oIKMugd
	 b1YAXHMQbYXyEZaujV6dLP/gezssxkPSaVV3mfulCf6eCCHMW3BtVxXfuX5qBrOAzduWo
	 mIRH00TcPImpwXsV1WehRro1qqgmBnssshArLLC/S/bkQVxNEpgry3einBLqRCOmMiTwr
	 yz4X3OuLoYzVA+7dYfnCGfxxzjcGJU1rKrcVexR9lcdrMW7rjznbBwh+ctI9zDh67Gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Wbz/UoRw";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D592606B3AF;
	Wed,  4 Nov 2026 22:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wbz/UoRw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E37B1F000C1;
	Wed,  4 Nov 2026 22:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831121;
	bh=ibb07V14NYZrYfACU/QgCn8hJfUEk9qhjsE6cuNXFrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wbz/UoRwt6AxiUfmscm2mrRqBboyXb6XGiXgZ0vrS92YND9y/sb73kCPd16pYYAVs
	 U9mY6H6WrwVfZR1LswIhDb4S66lBCQrZaY5/F2Vj7Hbzvs430Jv0+OJu0K/KPc3sym
	 b1HLqwG9/a979SymUM94JENetzHNqla32vPbcTsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muchun Song <muchun.song@linux.dev>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 6.18 0516/1005] ARM: 9524/1: mm: align hugetlb mappings to the huge page size
Date: Wed,  4 Nov 2026 16:04:09 -0500
Message-ID: <20261104211058.384591150@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 



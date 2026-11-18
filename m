Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050884;
	b=o8beMugKXdBa2lAUcE+HcpEKo8Vrv0nBTShKJBa5m5EzeXANGpZzXz9vCGiTOLZ0nYmK
	 GWCBY4dSWt8vjhvyAUrVEKfLvY/4Sujio6D+OMihExpU6aJ5777vwAtlTeiyQpfs4SQLL
	 r1nCta5GVAKjsQPucEfyj+1HcNoL0bwDe1s/RTimuTKdmUo1vnho8C67y8UXa9F9QbdkE
	 iXXsWlWpfvCPJvT77jUlEbA1V6kPEbh1CP4TAampMs+P6I9y1b9yaNl+iAEEHSbXO0XnH
	 9lXj2sdt25qi4CvRPmL8hRD4LMW/yIVEFizJRlL4PpmK7H7VR+vTC3W5KHvv34gkeQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050884;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=g0u30sdksHKjk+DpliCJG/yYLaT2GI+g1ykA23Q08to=;
	b=Ec6dOTaTBp0pGFoz6VsbxqPUSfjw56QKeH2MWF1Qq5E9YrRxw+5Ui60Ha0NYyrHS8fo3
	 BR4w17mrdp+/J7UPmt2BNjl7OjtP6E2dywcZ7b8VjfPVI3+GdjpQ8HUeEE60Pwgqs71YE
	 wEZFoSPiy/TF9bQDAIcqs3qcnX3GhZm9JxmR/fCx2zOXgZ4DHIf9/lRaztqoTeoTltnw2
	 tC61x/6ZdIFx9CTpQ+cOjqwN6iTbJOUZbsjredtrrRC18Fj1IdptzFrz2plgPFrUgF6+c
	 a0zHMRtrGAFuUxIgSl6Ncy+Qnoq1c3MZP6wI71LUpFef/J2I/oBXUjcNlZRMMYNJqUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ktsQf/2P";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C51E8606A320;
	Thu, 19 Nov 2026 01:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ktsQf/2P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29E121F000C4;
	Thu, 19 Nov 2026 01:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050884;
	bh=g0u30sdksHKjk+DpliCJG/yYLaT2GI+g1ykA23Q08to=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ktsQf/2PkXSA49mIXn9pwoG6hAvaKzqjms9pjbLrPJo3oF66EacWgg5bqtwOuaQ/B
	 B+UNb03pFbtV2MV6Kvg0diDyI9cAexuFHi3ePAwTLsBgMG3La8F+V33DTpIu36pkLp
	 p1p/YjI89BfyZUGpxQtFh40D3GvKi8zlRcSkBno4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Russell King <linux@armlinux.org.uk>,
	Liam Howlett <liam.howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Florian Fainelli <florian.fainelli@broadcom.com>
Subject: [PATCH 5.15 0013/2214] mm: move mmap_min_addr logic from callers into vm_unmapped_area()
Date: Wed, 18 Nov 2026 15:28:09 +0100
Message-ID: <20261118150010.675808911@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 6b008640db7355d8de6ac18f74cedd7ccc92684f upstream.

Instead of having callers care about the mmap_min_addr logic for the
lowest valid mapping address (and some of them getting it wrong), just
move the logic into vm_unmapped_area() itself.  One less thing for various
architecture cases (and generic helpers) to worry about.

We should really try to make much more of this be common code, but baby
steps..

Without this, vm_unmapped_area() could return an address below
mmap_min_addr (because some caller forgot about that).  That then causes
the mmap machinery to think it has found a workable address, but then
later security_mmap_addr(addr) is unhappy about it and the mmap() returns
with a nonsensical error (EPERM).

The proper action is to either return ENOMEM (if the virtual address space
is exhausted), or try to find another address (ie do a bottom-up search
for free addresses after the top-down one failed).

See commit 2afc745f3e30 ("mm: ensure get_unmapped_area() returns higher
address than mmap_min_addr"), which fixed this for one call site (the
generic arch_get_unmapped_area_topdown() fallback) but left other cases
alone.

Link: https://lkml.kernel.org/r/20230418214009.1142926-1-Liam.Howlett@oracle.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Liam Howlett <liam.howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[ Adapted to the rbtree based unmapped_area() and unmapped_area_topdown()
  used before the maple tree conversion: clamp the lower search bound to
  mmap_min_addr there instead of in the maple tree search. ]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
---
 arch/s390/mm/hugetlbpage.c |    2 +-
 arch/s390/mm/mmap.c        |    2 +-
 fs/hugetlbfs/inode.c       |    2 +-
 mm/mmap.c                  |   18 ++++++++++--------
 4 files changed, 13 insertions(+), 11 deletions(-)

--- a/arch/s390/mm/hugetlbpage.c
+++ b/arch/s390/mm/hugetlbpage.c
@@ -290,7 +290,7 @@ static unsigned long hugetlb_get_unmappe
 
 	info.flags = VM_UNMAPPED_AREA_TOPDOWN;
 	info.length = len;
-	info.low_limit = max(PAGE_SIZE, mmap_min_addr);
+	info.low_limit = PAGE_SIZE;
 	info.high_limit = current->mm->mmap_base;
 	info.align_mask = PAGE_MASK & ~huge_page_mask(h);
 	info.align_offset = 0;
--- a/arch/s390/mm/mmap.c
+++ b/arch/s390/mm/mmap.c
@@ -136,7 +136,7 @@ unsigned long arch_get_unmapped_area_top
 
 	info.flags = VM_UNMAPPED_AREA_TOPDOWN;
 	info.length = len;
-	info.low_limit = max(PAGE_SIZE, mmap_min_addr);
+	info.low_limit = PAGE_SIZE;
 	info.high_limit = mm->mmap_base;
 	if (filp || (flags & MAP_SHARED))
 		info.align_mask = MMAP_ALIGN_MASK << PAGE_SHIFT;
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -232,7 +232,7 @@ hugetlb_get_unmapped_area_topdown(struct
 
 	info.flags = VM_UNMAPPED_AREA_TOPDOWN;
 	info.length = len;
-	info.low_limit = max(PAGE_SIZE, mmap_min_addr);
+	info.low_limit = PAGE_SIZE;
 	info.high_limit = arch_get_mmap_base(addr, current->mm->mmap_base);
 	info.align_mask = PAGE_MASK & ~huge_page_mask(h);
 	info.align_offset = 0;
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1917,6 +1917,7 @@ static unsigned long unmapped_area(struc
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
 	unsigned long length, low_limit, high_limit, gap_start, gap_end;
+	unsigned long min_addr = max(info->low_limit, mmap_min_addr);
 
 	/* Adjust search length to account for worst case alignment overhead */
 	length = info->length + info->align_mask;
@@ -1928,9 +1929,9 @@ static unsigned long unmapped_area(struc
 		return -ENOMEM;
 	high_limit = info->high_limit - length;
 
-	if (info->low_limit > high_limit)
+	if (min_addr > high_limit)
 		return -ENOMEM;
-	low_limit = info->low_limit + length;
+	low_limit = min_addr + length;
 
 	/* Check if rbtree root looks promising */
 	if (RB_EMPTY_ROOT(&mm->mm_rb))
@@ -1996,8 +1997,8 @@ check_highest:
 
 found:
 	/* We found a suitable gap. Clip it with the original low_limit. */
-	if (gap_start < info->low_limit)
-		gap_start = info->low_limit;
+	if (gap_start < min_addr)
+		gap_start = min_addr;
 
 	/* Adjust gap address to the desired alignment */
 	gap_start += (info->align_offset - gap_start) & info->align_mask;
@@ -2012,6 +2013,7 @@ static unsigned long unmapped_area_topdo
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
 	unsigned long length, low_limit, high_limit, gap_start, gap_end;
+	unsigned long min_addr = max(info->low_limit, mmap_min_addr);
 
 	/* Adjust search length to account for worst case alignment overhead */
 	length = info->length + info->align_mask;
@@ -2027,9 +2029,9 @@ static unsigned long unmapped_area_topdo
 		return -ENOMEM;
 	high_limit = gap_end - length;
 
-	if (info->low_limit > high_limit)
+	if (min_addr > high_limit)
 		return -ENOMEM;
-	low_limit = info->low_limit + length;
+	low_limit = min_addr + length;
 
 	/* Check highest gap, which does not precede any rbtree node */
 	gap_start = mm->highest_vm_end;
@@ -2101,7 +2103,7 @@ found_highest:
 	gap_end -= info->length;
 	gap_end -= (gap_end - info->align_offset) & info->align_mask;
 
-	VM_BUG_ON(gap_end < info->low_limit);
+	VM_BUG_ON(gap_end < min_addr);
 	VM_BUG_ON(gap_end < gap_start);
 	return gap_end;
 }
@@ -2208,7 +2210,7 @@ arch_get_unmapped_area_topdown(struct fi
 
 	info.flags = VM_UNMAPPED_AREA_TOPDOWN;
 	info.length = len;
-	info.low_limit = max(PAGE_SIZE, mmap_min_addr);
+	info.low_limit = PAGE_SIZE;
 	info.high_limit = arch_get_mmap_base(addr, mm->mmap_base);
 	info.align_mask = 0;
 	info.align_offset = 0;



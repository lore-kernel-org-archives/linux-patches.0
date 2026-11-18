Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057223;
	b=RP98qhdwDAeiDbkwlm08+Ak5F2zh7kG9qTP36cj/q/wEHST0j0Gxb+pwQ1DkA5TSN5up
	 lIZYoCKJ1kKBNSHPU7yHEqac4AJb5d8mi+0HJs4V0gbUBcW+1/H+hohbuLaZguRQqCfsd
	 ntNF1gO39KeQW8FDeAOivJFsJ/MWnBXzcUInPhudHGQe3jMiCR6Yr1HfH3Xq42yfjXalY
	 tEs2iPmXWdbr9RMWJqvsqK8APJIDiTtL9TYqd+9UnCpen9wKnQIFap0t+3DulZFSm3LgS
	 LkeRDCz+K8gIH/+hzV6YBS/0DrhCcnDvq5f98OOTe+9DLA50gVJKeiPUGT4nIhoCegA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057223;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7abzzM2RUSBtPUqqsOiGzk6t8jMfGoqHOh2WHoeWCUw=;
	b=jhwElY/YFhJoiiUAy7FgbXDNmiPpiTz677OtAsq6CUZ3QfdTCXRwncRGV73t3slATuWF
	 1uq36HKga6zFSjtCCQKquap9M9W7s4PDqB/u7V7hhpOMCZucnu3KJjkmCmLGfrgRl7jwZ
	 Bd35QKLv2LLrrySkvK09vZjkDSq/HlhCREAuexIITnki2S7/SGuNfz6mq6tOZfUklexGr
	 6rzHge0KTWhGXnLtOGmgi3veNdPy98PvhHzlEPNxmido9KmnvhhxxvvYroOoK8DlVwy2r
	 dWIPIVPG6pl84qUr0Ny+1Rxmd4PjSgsjGUHFtTs2kaCFO2RU/QKxfKcgpQi1b6TOejg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ccDALAcO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F05060A2611;
	Thu, 19 Nov 2026 03:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ccDALAcO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BCD91F000C8;
	Thu, 19 Nov 2026 03:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057223;
	bh=7abzzM2RUSBtPUqqsOiGzk6t8jMfGoqHOh2WHoeWCUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ccDALAcOfmi20nL2ZZRnTbHWHUXgwTt3d4WJZu79hKoX3gw8VmNAYyLGHA2Und26U
	 Rnr4SjDsTzgR8v0bX2uJc2yb8xR70K2KojaBVnybzuihKdkDicwKJCz+1IURBS8quc
	 xU9CQ6mMA4KKbQC4NqklfKG53N5T4Oz0GpzU3XOw=
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
Subject: [PATCH 5.10 0012/1848] mm: move mmap_min_addr logic from callers into vm_unmapped_area()
Date: Wed, 18 Nov 2026 15:34:10 +0100
Message-ID: <20261118145911.691988257@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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
@@ -1944,6 +1944,7 @@ static unsigned long unmapped_area(struc
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
 	unsigned long length, low_limit, high_limit, gap_start, gap_end;
+	unsigned long min_addr = max(info->low_limit, mmap_min_addr);
 
 	/* Adjust search length to account for worst case alignment overhead */
 	length = info->length + info->align_mask;
@@ -1955,9 +1956,9 @@ static unsigned long unmapped_area(struc
 		return -ENOMEM;
 	high_limit = info->high_limit - length;
 
-	if (info->low_limit > high_limit)
+	if (min_addr > high_limit)
 		return -ENOMEM;
-	low_limit = info->low_limit + length;
+	low_limit = min_addr + length;
 
 	/* Check if rbtree root looks promising */
 	if (RB_EMPTY_ROOT(&mm->mm_rb))
@@ -2023,8 +2024,8 @@ check_highest:
 
 found:
 	/* We found a suitable gap. Clip it with the original low_limit. */
-	if (gap_start < info->low_limit)
-		gap_start = info->low_limit;
+	if (gap_start < min_addr)
+		gap_start = min_addr;
 
 	/* Adjust gap address to the desired alignment */
 	gap_start += (info->align_offset - gap_start) & info->align_mask;
@@ -2039,6 +2040,7 @@ static unsigned long unmapped_area_topdo
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
 	unsigned long length, low_limit, high_limit, gap_start, gap_end;
+	unsigned long min_addr = max(info->low_limit, mmap_min_addr);
 
 	/* Adjust search length to account for worst case alignment overhead */
 	length = info->length + info->align_mask;
@@ -2054,9 +2056,9 @@ static unsigned long unmapped_area_topdo
 		return -ENOMEM;
 	high_limit = gap_end - length;
 
-	if (info->low_limit > high_limit)
+	if (min_addr > high_limit)
 		return -ENOMEM;
-	low_limit = info->low_limit + length;
+	low_limit = min_addr + length;
 
 	/* Check highest gap, which does not precede any rbtree node */
 	gap_start = mm->highest_vm_end;
@@ -2128,7 +2130,7 @@ found_highest:
 	gap_end -= info->length;
 	gap_end -= (gap_end - info->align_offset) & info->align_mask;
 
-	VM_BUG_ON(gap_end < info->low_limit);
+	VM_BUG_ON(gap_end < min_addr);
 	VM_BUG_ON(gap_end < gap_start);
 	return gap_end;
 }
@@ -2235,7 +2237,7 @@ arch_get_unmapped_area_topdown(struct fi
 
 	info.flags = VM_UNMAPPED_AREA_TOPDOWN;
 	info.length = len;
-	info.low_limit = max(PAGE_SIZE, mmap_min_addr);
+	info.low_limit = PAGE_SIZE;
 	info.high_limit = arch_get_mmap_base(addr, mm->mmap_base);
 	info.align_mask = 0;
 	info.align_offset = 0;



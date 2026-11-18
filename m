Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042967;
	b=PcADrfOSNN1kutjHnZfp3FOqJ+uFCqURnZr/jWFs9AkqYOJWj0xsJs4smSlyFb4UPdnO
	 jdX4qFnRUvw7gtgTwPvKCcBCly6fiCqTXROm6ngh8GzOcOKj/h7UZxEKbqshygDCHJZGM
	 GN3m5aWTxQiE5ScXwNOaPaYDhHVejyZOOmjJehoS2PpHYVucEOjmXYORUslqbHPtttvEs
	 XHMHzGFJA0o8hp4mRD0BUJq2WOW3WitPs9R3z8b/fRV/g8DIwbVbT9KSFxlOQa5fGrb6Q
	 oRt1HWX2Jyf0qHztr0YfVHKC9k84zUzHoQfyWUm/AHti/qseG8SffD6eqrxpY7wrmpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042967;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OP8zBWwbe+vUsAnTlX9JzlMS+lZ23lM0bnVSn+KS3Bk=;
	b=a8uzFIRZg1wG0mz0Ga5aTfHrZ02TVEAEwMvNMIPIla0AOBvdg1nPE9GaguBvMc7Jgjv+
	 phQ9didP3dOQG1GUiu69EjxpZ1d6FaxILzx+eaxfhVJckgXd6sfV1M2b9gPgKIJBy5ktJ
	 2/mVr/bhk4ZXT+NPKopxwJzv5Upr11StIxiGMK+If0VMKAo/9QZ0TN4kW2KQAf5EYyBiA
	 UtIbe1cgrdeuH9wg3ovf9ZpBPDiaF9zEZPT2t/Am7c1QuNI0wYCIsXcNoQNyPJLTOo3tL
	 o9ANrLEFwbf3ZQmflSQrF2eBx42XtAqXgF101IKtqS5771ae32lQGcXfNBZ3Hz44u3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pH5F9DMb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB59B606A320;
	Wed, 18 Nov 2026 23:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pH5F9DMb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 135E41F000C4;
	Wed, 18 Nov 2026 23:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042966;
	bh=OP8zBWwbe+vUsAnTlX9JzlMS+lZ23lM0bnVSn+KS3Bk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pH5F9DMbdnJhZjthbxnoMVcDxun7dv79kRNc0mb3+5iSZmLt/nv4L5yelT7GpsN2O
	 EuTquSU3LzCkCloTLv2Rj1QiT0w80SSCymBU/QVBJ96k6UK/GaMN45xHWmAixAAZAu
	 qCoeF5Gx013DY+MJqIcBtf8StOhazOS9TIXFwNHk=
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
Subject: [PATCH 6.1 0016/2857] mm: move mmap_min_addr logic from callers into vm_unmapped_area()
Date: Wed, 18 Nov 2026 15:17:30 +0100
Message-ID: <20261118150201.945826048@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/mm/hugetlbpage.c |    2 +-
 arch/s390/mm/mmap.c        |    2 +-
 fs/hugetlbfs/inode.c       |    2 +-
 mm/mmap.c                  |   19 +++++++++++++------
 4 files changed, 16 insertions(+), 9 deletions(-)

--- a/arch/s390/mm/hugetlbpage.c
+++ b/arch/s390/mm/hugetlbpage.c
@@ -273,7 +273,7 @@ static unsigned long hugetlb_get_unmappe
 
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
@@ -219,7 +219,7 @@ hugetlb_get_unmapped_area_topdown(struct
 
 	info.flags = VM_UNMAPPED_AREA_TOPDOWN;
 	info.length = len;
-	info.low_limit = max(PAGE_SIZE, mmap_min_addr);
+	info.low_limit = PAGE_SIZE;
 	info.high_limit = arch_get_mmap_base(addr, current->mm->mmap_base);
 	info.align_mask = PAGE_MASK & ~huge_page_mask(h);
 	info.align_offset = 0;
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1598,7 +1598,8 @@ static inline int accountable_mapping(st
  */
 static unsigned long unmapped_area(struct vm_unmapped_area_info *info)
 {
-	unsigned long length, gap, low_limit;
+	unsigned long length, gap;
+	unsigned long low_limit, high_limit;
 	struct vm_area_struct *tmp;
 
 	MA_STATE(mas, &current->mm->mm_mt, 0, 0);
@@ -1609,8 +1610,11 @@ static unsigned long unmapped_area(struc
 		return -ENOMEM;
 
 	low_limit = info->low_limit;
+	if (low_limit < mmap_min_addr)
+		low_limit = mmap_min_addr;
+	high_limit = info->high_limit;
 retry:
-	if (mas_empty_area(&mas, low_limit, info->high_limit - 1, length))
+	if (mas_empty_area(&mas, low_limit, high_limit - 1, length))
 		return -ENOMEM;
 
 	gap = mas.index;
@@ -1646,7 +1650,8 @@ retry:
  */
 static unsigned long unmapped_area_topdown(struct vm_unmapped_area_info *info)
 {
-	unsigned long length, gap, high_limit, gap_end;
+	unsigned long length, gap, gap_end;
+	unsigned long low_limit, high_limit;
 	struct vm_area_struct *tmp;
 
 	MA_STATE(mas, &current->mm->mm_mt, 0, 0);
@@ -1655,10 +1660,12 @@ static unsigned long unmapped_area_topdo
 	if (length < info->length)
 		return -ENOMEM;
 
+	low_limit = info->low_limit;
+	if (low_limit < mmap_min_addr)
+		low_limit = mmap_min_addr;
 	high_limit = info->high_limit;
 retry:
-	if (mas_empty_area_rev(&mas, info->low_limit, high_limit - 1,
-				length))
+	if (mas_empty_area_rev(&mas, low_limit, high_limit - 1, length))
 		return -ENOMEM;
 
 	gap = mas.last + 1 - info->length;
@@ -1793,7 +1800,7 @@ generic_get_unmapped_area_topdown(struct
 
 	info.flags = VM_UNMAPPED_AREA_TOPDOWN;
 	info.length = len;
-	info.low_limit = max(PAGE_SIZE, mmap_min_addr);
+	info.low_limit = PAGE_SIZE;
 	info.high_limit = arch_get_mmap_base(addr, mm->mmap_base);
 	info.align_mask = 0;
 	info.align_offset = 0;



Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064174;
	b=2Y9WIqqjG77lt7cMIrkg1XYZgtUuSlOsoIL4NHusc9DdYRIMA6eCSxvqYXwhdKMbq5Du
	 RSukDT0lcbVxHIrAP1ujhMnQJCc08kWATxJI5igCOqqqMm7xLewu1oHXiXEm+7cKSEGvO
	 Iyohm0Nq4xS9/zLvSvo4wC/kKZfBILEqze3ndBRo+8yJXwvgbIpHfJ367ubY0HzCGZiSk
	 o1TbXHL88ioUyzMGpu26SyUS2LxsByrJwfbFPw1lqZmG+Ak70ZTNMMAatGmDdF5tQC/il
	 s3Kw3owVLqSa0FkS+DsFgrbfYnFcjvTqiOUrBsNWkXnoiMMaBAvhOX01/QwZ61XX1Ow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064174;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=V98vovM5HAsAX/U6Y5gs8H6hRMbqUpzJG0Tf4M1YE3Q=;
	b=t1mDLhSxoNjPd25MAeDnX19VeyMZsf11JsMhdn/VkpbOmCmx06m6hFOuUTqKB4a8yDg+
	 JdWw5qp0BqOWb9qyq6Cx5By94Ml1dTJ3e7BdzEEMXKj/iy+saHsYNy6/vrjw1YqIar4WF
	 U+MXQzDmJL1yKHhH3HsuLM/43N3gc+Kotd6J9iK2bWCG6zm9Y82anmp7KoceXnFyRb/+c
	 nW55FiujYo0bc8Z0yMSiUQVPtAPP+NXRETZJ+FR4/iasyVnTGcs20yiNXii2t9k8Vqsm2
	 Uibcfk8XiXNfxAnC/N4GDdjzLZAC9jKZ+D2/7uMq7qUAG/4jlk1dDYFUMv6+e31Lw0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wJJarE4b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 311C5606D810;
	Sat,  7 Nov 2026 15:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wJJarE4b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D460A1F0089F;
	Sat,  7 Nov 2026 15:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064174;
	bh=V98vovM5HAsAX/U6Y5gs8H6hRMbqUpzJG0Tf4M1YE3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wJJarE4bGdzotq1nAf+LyTTu3piF6fbl9u4hDB5E6BLnB6D38CoSV0dgiKOUQJ6tU
	 xyh6ia9Utd1b0CsrK0Mq87H3kmuCuVIQPbMmOdy5bGp7vJzosYzUR48mGw9I0Db9bd
	 AQU7HoaFByAH/yJiPoQ67jGD6PNt+IRTeLDf2378=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Orgad Shaneh <orgads@gmail.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0319/1257] MIPS: mm: align hugetlb mappings in arch_get_unmapped_area()
Date: Sat,  7 Nov 2026 08:43:35 -0500
Message-ID: <20261107134948.240000736@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Orgad Shaneh <orgads@gmail.com>

[ Upstream commit 975d4a6a6d4d23a39e2f49cafcc082d937960bc4 ]

Since hugetlb mappings were made to go through the architecture's
arch_get_unmapped_area{,_topdown}(), every architecture that implements
those has to align hugetlb files itself. The generic implementation and
loongarch do it with huge_page_mask_align(); MIPS was left out.

A non-MAP_FIXED mmap() of a hugetlbfs file therefore returns an address
that is only SHMLBA aligned, and the kernel then installs 2 MB PMDs for
a VMA that starts in the middle of a PMD. The consequences on an
Octeon (CN63XX) board running a process that links libhugetlbfs with
HUGETLB_ELFMAP=R and HUGETLB_MORECORE=yes, all within a minute of
start: the neighbouring 4 KB page table is clobbered, the TLB ends up
with overlapping entries ("Caught Machine Check exception - caused by
multiple matching entries in the TLB"), process exit trips
BUG_ON(start & ~huge_page_mask(h)) in __unmap_hugepage_range(), and
freed pages leak into unrelated kernel structures (oopses in the irq
maple tree, in pte_offset_map, ...).

Do what loongarch does in commit 3109d5ff484b ("LoongArch: Set hugetlb
mmap base address aligned with pmd size"): when the file is a hugetlb
file, use its page mask as the search alignment instead of the cache
colour mask.

Fixes: 7bd3f1e1a9ae ("mm: make hugetlb mappings go through mm_get_unmapped_area_vmflags")
Cc: stable@vger.kernel.org # 6.13+
Assisted-by: Claude:claude-opus-5
Signed-off-by: Orgad Shaneh <orgads@gmail.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/mm/mmap.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/mips/mm/mmap.c b/arch/mips/mm/mmap.c
index 5d2a1225785b8..119edaa928f33 100644
--- a/arch/mips/mm/mmap.c
+++ b/arch/mips/mm/mmap.c
@@ -9,6 +9,7 @@
 #include <linux/compiler.h>
 #include <linux/elf-randomize.h>
 #include <linux/errno.h>
+#include <linux/hugetlb.h>
 #include <linux/mm.h>
 #include <linux/mman.h>
 #include <linux/export.h>
@@ -72,8 +73,11 @@ static unsigned long arch_get_unmapped_area_common(struct file *filp,
 	}
 
 	info.length = len;
-	info.align_mask = do_color_align ? (PAGE_MASK & shm_align_mask) : 0;
 	info.align_offset = pgoff << PAGE_SHIFT;
+	if (filp && is_file_hugepages(filp))
+		info.align_mask = huge_page_mask_align(filp);
+	else
+		info.align_mask = do_color_align ? (PAGE_MASK & shm_align_mask) : 0;
 
 	if (dir == DOWN) {
 		info.flags = VM_UNMAPPED_AREA_TOPDOWN;
-- 
2.53.0




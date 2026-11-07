Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065333;
	b=hgPTrdy2KrP0SYB1hFNM6oNfq4PARxBLb2Cp+nRFpPlpsx0XHNN807A0i6KE/Mbi76+2
	 AT7kcCcSWfwxITjWAKWPSpCYA8MvcNQoYcJqspLvHJMF0Df5IVf/Hwz3oq5dXPqNCrgiu
	 lk2F5QP5Mmkup5/Ng6+4vIrRncVHp4JKbeML1riRxr2KjLk11TBqzXp0ogXjTWVo9bFMU
	 stHqEY5niHG0ZiPgFynqzqYGe6ot8uUZhyDK0WYXJ6VJD6ycO2lWoh9LpmzGjGsufpJcg
	 5dzRAbzbRBjAv8UGkXxUNUDiCtb3RqhJ8dNCFHJ8cxzxTOskiM1+seWwdEYmcmFkdFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065333;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=P6Gp5RnLNtNKqivFBf5v/r+J0Yhs46fKzXpJKstB0qw=;
	b=Pl9kALptEJ58BxLHSc0smfcoJr7Utp+kqGTYvnOvZ5oPrnmNkA4VftBIE6usMrkPHB6p
	 EkNMIWHUO+a+mZ4BRLb+3gwYhpOTTvowmr0zO1eEXJ63HAaUayfs2xoEfUBTmCa7XYohb
	 Wt1B72i8IE6j40/J0yDO6PG0WGpUupBsuH/8cwfBez/ilZ+wBOgl26eDyEnWjJVtuegWQ
	 T1BuhSnUCPo+uFqRhVKpBZ8HPSJtFvAWO1YE/1bAQl54EF5KrrdPXQyLOHxiQchOgv2MJ
	 TPMbzPymsB1QHT+SaIB80ieC5Dy0CdnOg7kWdnkpP6PYj82syCvgOk7YfYvkE2gFNdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F0i1lw2u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EA49606A331;
	Sat,  7 Nov 2026 15:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F0i1lw2u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 145CD1F0089F;
	Sat,  7 Nov 2026 15:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065333;
	bh=P6Gp5RnLNtNKqivFBf5v/r+J0Yhs46fKzXpJKstB0qw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F0i1lw2uxz1H4y7/Yroc6xI2LOWTRityEczqTCR2D2ZtoqhTK26WSkrFqxe7Sf4RI
	 uE182kaILDsQHDzQnSvOS9bq/6HgekHHD91PW5WagRFr7KfyRFdFP008M1FR++nLCI
	 QlNABLdTeRQz8wXNa/3IoZtdACD32svDeNWFFL4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Mason <mason@kernel.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Adam Litke <agl@us.ibm.com>,
	Mel Gorman <mgorman@techsingularity.net>,
	Rik van Riel <riel@surriel.com>,
	Peter Xu <peterx@redhat.com>,
	Mike Rapoport <rppt@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1073/1257] mm/hugetlb: dont leave a uffd-wp marker when zapping an RWP entry
Date: Sat,  7 Nov 2026 08:56:09 -0500
Message-ID: <20261107135008.902560704@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit f6605fc6b14bd5fc0fea90fc8226573adcec352b ]

An entry that is protected with UFFDIO_RWPROTECT is PAGE_NONE with the
uffd bit set, the bit that userfaultfd write protection uses too.  When
__unmap_hugepage_range() zaps an entry with that bit it leaves a
PTE_MARKER_UFFD_WP behind, whatever the VMA is registered for.

In a VMA registered with UFFDIO_REGISTER_MODE_RWP that marker means
nothing.  The next fault has hugetlb_no_page() turn it into a present,
read-only entry with the uffd bit.  That is not an RWP entry, since it is
not PAGE_NONE, and the VMA has no VM_UFFD_WP (the two modes can not be
registered together).  An earlier fix solved some side effects, now just
stop the zap from wrongly installing a marker.

Leave a marker only if the VMA is registered for write protection, both
for present and for non-present entries.  The zap of ordinary page
tables has the same test, in cond_install_uffd_wp_ptes(), and
hugetlb_change_protection() says that "uffd_rwp does not install markers".

After a zap the range of an RWP VMA is simply empty, as it is for
anonymous memory and shmem.  Nothing changes for VMAs with VM_UFFD_WP.  In
a VMA that is not registered at all a leftover uffd bit or marker is now
dropped by the zap and no longer kept alive.

Original fix generated by an LLM and sent in private by Josef.

[david@kernel.org: a bit of description overhaul+simplification]
Link: https://lore.kernel.org/20261015-urgent_fixes-v1-9-42796911043b@kernel.org
Fixes: 2d427bb01639 ("mm/userfaultfd: add RWP fault delivery and expose UFFDIO_REGISTER_MODE_RWP")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Chris Mason <mason@kernel.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Adam Litke <agl@us.ibm.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Rik van Riel <riel@surriel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/hugetlb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 2dad6b366cd7b..30fc6984b2898 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5273,7 +5273,7 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 			 * drop the uffd-wp bit in this zap, then replace the
 			 * pte with a marker.
 			 */
-			if (pte_swp_uffd_any(pte) &&
+			if (userfaultfd_wp(vma) && pte_swp_uffd_any(pte) &&
 			    !(zap_flags & ZAP_FLAG_DROP_MARKER))
 				set_huge_pte_at(mm, address, ptep,
 						make_pte_marker(PTE_MARKER_UFFD_WP),
@@ -5309,7 +5309,7 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		if (huge_pte_dirty(pte))
 			folio_mark_dirty(folio);
 		/* Leave a uffd-wp pte marker if needed */
-		if (huge_pte_uffd(pte) &&
+		if (userfaultfd_wp(vma) && huge_pte_uffd(pte) &&
 		    !(zap_flags & ZAP_FLAG_DROP_MARKER))
 			set_huge_pte_at(mm, address, ptep,
 					make_pte_marker(PTE_MARKER_UFFD_WP),
-- 
2.53.0




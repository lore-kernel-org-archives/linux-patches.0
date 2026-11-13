Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590606;
	b=K5bTzSikuqfyrizubjKkuzrWGS/y6ZuJqDo1UIPv5Szok6WnKyjjB+3FGOYE4T5swUmU
	 loDNe0f5l/zKOsyzCwbvVyk4Zb0Eb3o487w17Q23wRSVzptj7sRDYhNmQkXM0JInxeZtx
	 OQd2VcSfKVArQ0eZi/6SIumP7GlmlgrKJvUjtkQZK6ku2BRXGVmSfe7wH3rMyKReWc6LO
	 WqDxpIOHaB8jqYqUwEe4MQ3er6usAJfV6+ce9bCUsbA0Q6zTQ3BbyjcTGcaYFANiu/qW9
	 fy2iSZr5W+P8rSuCqNe9/8NC/BIPVDPjj2wqkliwhlWSxJKxJVq1Sm1cp//sjnPVIBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590606;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aglKTv6MgJ5vPKIe03V2Fc3GUJyLF8ke6Rw8x3CQwrQ=;
	b=BSQLEq1mF1Kd17KfTuWKj9GItOcNnPiA2mqgkNkjlRKdy0CSsRB9IG7XHXS5NyZ3Dra0
	 oSmGs6Rq2oLLzlgRilFvAtK/CE4aWL6ghOu1qnHqJAcY8h1KcQCEORr1E9uC9GcgqN7/j
	 PuDqeOb3QKVgWF1B2j5Vy0ue4KdHsPJwJsuF458fubHDDWkm0N1eOTyOI9gtghFxtiHGK
	 K/pgV/fBIQ1/jyB2extPf+ghAYVLQqAOXheQxPL7PskcffM4Das88egd65t0fV3BonEgJ
	 yeKBhhhIAPuH4guT14tcqEh8WLFHimuT3WiJu1OSk1yPdzzun6EAYGwV7qL3QX6fMtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="UbU85/SZ";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C02E6075E24;
	Fri, 13 Nov 2026 17:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UbU85/SZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 337701F000CB;
	Fri, 13 Nov 2026 17:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590606;
	bh=aglKTv6MgJ5vPKIe03V2Fc3GUJyLF8ke6Rw8x3CQwrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UbU85/SZm+Qc03xlq6h9HmtOW6bA5UyRYu3tJqs8u6EQJvjdzwUanKX+9c3Wog3OC
	 uYADV9P/3pYudharSbThYGD79ghxpxR3hdCtGp58ayMmMZnOzpeAKbN/L/CrP9Ttej
	 H+xsbrY0+tN5ThEhl6ehsTmucBKDUJfn68PBm1h8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Mason <mason@kernel.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Oscar Salvador <osalvador@suse.de>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Adam Litke <agl@us.ibm.com>,
	Mel Gorman <mgorman@techsingularity.net>,
	Rik van Riel <riel@surriel.com>,
	Peter Xu <peterx@redhat.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 534/686] mm/hugetlb: unmap the page where the other VMA maps it
Date: Fri, 13 Nov 2026 10:51:07 -0500
Message-ID: <20261113153839.320476557@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit ae99c503eb362b42cd5d24d80bc6cba669acc4c2 ]

If the owner of a MAP_PRIVATE hugetlb mapping fails to allocate a page
for CoW, unmap_ref_private() unmaps the old page from all other private
VMAs that have no reservation of their own.  It finds them by the offset
in the file, but then zaps each of them at the address of the faulting
VMA.  Nothing says that another VMA maps the offset at that address: a
child can have moved its copy of the VMA with mremap(), and a second
mapping of the file is wherever mmap() has put it.

So __unmap_hugepage_range() walks the page tables of the other mm at an
address outside of iter_vma, where i_mmap_rwsem of this file protects
nothing and where anything can be mapped, and the page stays mapped where
it really is.

All of the following was seen on v7.3-rc6+ (g6c377d19d4a5) in KVM guests,
as a user without any privilege.  It takes a pool of 2 MiB pages with no
free page that is not reserved, so that the allocation fails: the user
can take or reserve what is free itself.

 - The child moves its VMA away.  The page is never unmapped, the
   mapcount stays 2, and the owner goes round retry_avoidcopy in
   hugetlb_wp() until the child is gone or a page becomes free.  SIGKILL
   to the owner does not end it.  5 of 5 runs.

 - The owner's mm has a second private mapping of the offset, made with
   MAP_NORESERVE.  The owner zaps its own entry and reads zeroes where
   its data was.  5 of 5 runs.

 - The child moves its VMA away and maps a 1 GiB hugetlb page at the old
   address, so this one takes a pool with a 1 GiB page as well.
   huge_pte_offset() for the 2 MiB size steps through the PUD
   leaf, so the "PMD table" is the 1 GiB page itself and its "page table
   lock" is folio->private of that page, which holds 2.  Kernels with
   lock debugging oops in __unmap_hugepage_range(), 7 of 7 runs.  Others
   spin on that word for ever with preemption disabled, 5 of 5 runs:

     watchdog: BUG: soft lockup - CPU#0 stuck for 26s! [u_det3:130]
     RIP: 0010:queued_spin_lock_slowpath+0x8a/0x290
     RAX: 0000000000000002 RBX: ffffea0001000028
     Call Trace:
      __unmap_hugepage_range+0x154/0x6d0
      unmap_hugepage_range+0xc1/0x140
      hugetlb_wp+0x55c/0x700
      hugetlb_fault+0x5f3/0x8f0

   RCU stalls follow, and killing all tasks of the user changes nothing.
   Four such owners, whose children share a single 1 GiB page, took down
   the whole guest with its four CPUs, 2 of 2 runs: one reported soft
   lockups on all four, the other gave no sign of life any more.

   i_mmap_rwsem stays write locked.  With a MAP_PRIVATE mapping of a
   hugetlbfs file that belongs to another user, and that the attacker
   can only read, the next mmap() of that file by its owner sleeps
   uninterruptibly in __mmap_region(), 4 of 4 runs.

Compute the address from the offset for each VMA.  The tree walk returns
only VMAs that cover pgoff, and vm_start, vm_end and vm_pgoff of a hugetlb
VMA are aligned to the huge page size, as pgoff is, so the whole range
lies inside iter_vma.  Its page tables can not go away there, since the
VMA is unlinked from the file under i_mmap_rwsem first.

With the right address the page is unmapped from all VMAs but the
owner's, so the retry in hugetlb_wp() finds a mapcount of 1 and reuses the
page.

A child that has moved its copy of the VMA now loses the page, and gets
SIGBUS when it faults on a missing page of that VMA.  That is what the
comment above the function has always promised to those who do not own
the reservation, and what already happens to a child that has left the
VMA in place.

The address has been wrong from the start, and the second case needs
only mmap() and fork().  mremap() of hugetlb VMAs, which the other cases
use, came with commit 550a7d60bd5e ("mm, hugepages: add mremap() support
for hugepage backed vma") in v5.16.

Original fix generated by an LLM and sent in private by Josef.

[david@kernel.org: switch to vma_filebacked_address, add VM_WARN_ON_ONCE, refine comments]
Link: https://lore.kernel.org/20261015-urgent_fixes-v1-4-42796911043b@kernel.org
Fixes: 04f2cbe35699 ("hugetlb: guarantee that COW faults for a process that called mmap(MAP_PRIVATE) on hugetlbfs will succeed")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Chris Mason <mason@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Adam Litke <agl@us.ibm.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Rik van Riel <riel@surriel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: <stable@vger.kernel.org>
[ sashal: Replaced vma_filebacked_address() with the existing vma_address() helper. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/hugetlb.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index bf1188e9b1c9b..ba7998ad7c7ee 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6155,6 +6155,8 @@ static void unmap_ref_private(struct mm_struct *mm, struct vm_area_struct *vma,
 	struct address_space *mapping;
 	pgoff_t pgoff;
 
+	VM_WARN_ON_ONCE(!folio_test_anon(folio));
+
 	/*
 	 * vm_pgoff is in PAGE_SIZE units, hence the different calculation
 	 * from page cache lookup which is in HPAGE_SIZE units.
@@ -6190,10 +6192,17 @@ static void unmap_ref_private(struct mm_struct *mm, struct vm_area_struct *vma,
 		 * could insert a zeroed page instead of the data existing
 		 * from the time of fork. This would look like data corruption
 		 */
-		if (!is_vma_resv_set(iter_vma, HPAGE_RESV_OWNER))
-			unmap_hugepage_range(iter_vma, address,
-					     address + huge_page_size(h),
-					     folio, 0);
+		if (is_vma_resv_set(iter_vma, HPAGE_RESV_OWNER))
+			continue;
+
+		/*
+		 * The address in other VMAs can differ. Even though our old
+		 * folio is anon, we always operate on the underlying hugetlb
+		 * file.
+		 */
+		address = vma_address(iter_vma, pgoff, 1);
+		unmap_hugepage_range(iter_vma, address,
+				     address + huge_page_size(h), folio, 0);
 	}
 	i_mmap_unlock_write(mapping);
 }
-- 
2.53.0




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064545;
	b=KMen9VXWYH2VzvxAGSEKlyYiBduKethfW9K95pGXc7zdFtd6ZdCoWrBDLmbZq+aWJ5vo
	 gLp8n3SbAWdr1GdtI/qg/SEKvn2SVxVDa0j1LWYBAihj/TUIkrGtTJ+is1PucbnStaSPs
	 geqkrJmouJTnVCf0R0kcWumEX8dym9SHRJXqfEKJkwz5n549lrat75R4LP6iVp1v3PYfE
	 Ep4qYHvevUSBf8Nil6sSwJCyO9TbYaxM/jV73RkTxqcMaQv9yd4oC+/dLQ+WCGFvtKlNh
	 F2NASkyZP2KgU7TCaekKXwCr6tg+uURNsWqAhK4mGJHOt6ElV8YXUGlT9IrjvTvGP5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064545;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nw0tIXAYduMwEc6d74Zei7482J4Y/4mmFDwp0gvhSHc=;
	b=gHlAi3ZklT93DnYBbX7CD45jscCEBfzJZ7oMQO8kNpdPXO3rye1XDi6qsEs1ZC7Shdyp
	 abfSGjbWJaehk4qvi7F1UxsSwPGI+jyrW/5p3vWCo5R3zjpyrJyPyAHOtjimUakkW9CNf
	 V4pK/1ITmpOFeW1ZJDJgnXYKVHZyAInXlfeyFEHLLoivkYrZnMIk/mOnS8SDkNDmmVQiP
	 Rz2rajzcQ0mllsExniajYRc8ILaPhlEfjNYBsCsUGik3YmCI0UWqLZ0kzz26T89jS/axo
	 jwY+L9BMU6UOBFf7stCn20oy8+1g6rtS1sIwndUmij0aLBqaZdtTx/LcRe4DkMwmM+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EoFUNhMM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 557A2606B8A6;
	Sat,  7 Nov 2026 15:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EoFUNhMM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F391A1F008AB;
	Sat,  7 Nov 2026 15:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064545;
	bh=nw0tIXAYduMwEc6d74Zei7482J4Y/4mmFDwp0gvhSHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EoFUNhMM8RycHG2T4psAzRUvxB8cQHkOpqx5bP9vI/MHi60f4/2DUT+sJ7LtJ2Ofx
	 cKLGYfB82tlMy01YcLg1y6v2ZZRttduAbOxsw9EcGTWHzOHr+MuW9W9SNjksEE9AUJ
	 l5lKE0/uDr+w1H8Pql6GtaFJ2x7EWZkmkJkfbvsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinmeng Zhou <zhoujinmeng@bytedance.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Hongfu Li <lihongfu@kylinos.cn>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0571/1257] mm/hugetlb: charge folios to the target mms memcg
Date: Sat,  7 Nov 2026 08:47:47 -0500
Message-ID: <20261107134955.124617120@linuxfoundation.org>
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

From: Jinmeng Zhou <jinmengzhou22@gmail.com>

[ Upstream commit c2deb1356d82c9d54bd2fcf1241cc97eb66fd81f ]

HugeTLB folios are currently charged to the memcg of the allocating task.
This gives the wrong result when a userfaultfd handler populates a HugeTLB
VMA that belongs to another process.  The UFFDIO_COPY ioctl operates on
the userfaultfd context's mm, but get_mem_cgroup_from_current() charges
the folio to the handler's memcg instead.

This can be reproduced by placing the faulting process and its userfaultfd
handler in different memory cgroups.  Have the target process register a
HugeTLB mapping with userfaultfd, trigger a missing fault, and let the
handler resolve it with UFFDIO_COPY.  The hugepage usage is then reported
in the handler's memory.current instead of the target's.

The generic userfaultfd population path avoids this problem by charging
folios to dst_vma->vm_mm.

Pass the target mm through hugetlb_alloc_folio() and charge the folio by
using get_mem_cgroup_from_mm().  This preserves the existing charge timing
and error handling while making HugeTLB userfaultfd population consistent
with the generic path.

Link: https://lore.kernel.org/20260903075048.3316-1-zhoujinmeng@bytedance.com
Fixes: 8cba9576df60 ("hugetlb: memcg: account hugetlb-backed memory in memory controller")
Signed-off-by: Jinmeng Zhou <zhoujinmeng@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Hongfu Li <lihongfu@kylinos.cn>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/hugetlb.h    | 3 ++-
 include/linux/memcontrol.h | 8 +++++---
 mm/hugetlb.c               | 9 ++++++---
 mm/memcontrol.c            | 6 ++++--
 4 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 16c4c4caa126c..45ada75dc04e9 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -699,7 +699,8 @@ enum hugetlb_alloc_flag {
 #define HUGETLB_ALLOC_USE_GLOBAL_RESERVATIONS BIT(HUGETLB_ALLOC_USE_GLOBAL_RESERVATIONS_BIT)
 
 struct folio *hugetlb_alloc_folio(struct hstate *h,
-		struct mempolicy_interpreted *mpoli, u8 alloc_flags);
+		struct mempolicy_interpreted *mpoli, struct mm_struct *mm,
+		u8 alloc_flags);
 struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 				unsigned long addr, bool cow_from_owner);
 struct folio *alloc_hugetlb_folio_nodemask(struct hstate *h, int preferred_nid,
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 7d1c0ce189a88..362af58e50a43 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -662,7 +662,8 @@ static inline int mem_cgroup_charge(struct folio *folio, struct mm_struct *mm,
 	return __mem_cgroup_charge(folio, mm, gfp);
 }
 
-int mem_cgroup_charge_hugetlb(struct folio* folio, gfp_t gfp);
+int mem_cgroup_charge_hugetlb(struct folio *folio, struct mm_struct *mm,
+			      gfp_t gfp);
 
 int mem_cgroup_swapin_charge_folio(struct folio *folio, unsigned short id,
 				   struct mm_struct *mm, gfp_t gfp);
@@ -1156,9 +1157,10 @@ static inline int mem_cgroup_charge(struct folio *folio,
 	return 0;
 }
 
-static inline int mem_cgroup_charge_hugetlb(struct folio* folio, gfp_t gfp)
+static inline int mem_cgroup_charge_hugetlb(struct folio *folio,
+					    struct mm_struct *mm, gfp_t gfp)
 {
-        return 0;
+	return 0;
 }
 
 static inline int mem_cgroup_swapin_charge_folio(struct folio *folio,
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 930e40ac77077..1c2b5825b5614 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2827,6 +2827,7 @@ void wait_for_freed_hugetlb_folios(void)
  * hugetlb_alloc_folio - Allocate a hugetlb folio.
  * @h: Hugetlb state control block.
  * @mpoli: Interpreted memory policy to use for allocation.
+ * @mm: Memory descriptor of the allocation target.
  * @alloc_flags: Flags controlling the allocation behavior.
  *
  * Allocates a hugetlb folio and handles cgroup charging and global hstate
@@ -2836,7 +2837,8 @@ void wait_for_freed_hugetlb_folios(void)
  *         -ENOSPC if cgroup charging fails or no folio is available.
  */
 struct folio *hugetlb_alloc_folio(struct hstate *h,
-		struct mempolicy_interpreted *mpoli, u8 alloc_flags)
+		struct mempolicy_interpreted *mpoli, struct mm_struct *mm,
+		u8 alloc_flags)
 {
 	bool charge_hugetlb_cgroup_rsvd = alloc_flags &
 					  HUGETLB_ALLOC_CHARG_CGROUP_RSVD;
@@ -2891,7 +2893,8 @@ struct folio *hugetlb_alloc_folio(struct hstate *h,
 
 	spin_unlock_irq(&hugetlb_lock);
 
-	ret = mem_cgroup_charge_hugetlb(folio, gfp | __GFP_RETRY_MAYFAIL);
+	ret = mem_cgroup_charge_hugetlb(folio, mm,
+					gfp | __GFP_RETRY_MAYFAIL);
 	/*
 	 * Unconditionally increment NR_HUGETLB here because if
 	 * mem_cgroup_charge_hugetlb failed, freeing the page will
@@ -3034,7 +3037,7 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 		.nodemask = nodemask,
 	};
 
-	folio = hugetlb_alloc_folio(h, &mpoli, alloc_flags);
+	folio = hugetlb_alloc_folio(h, &mpoli, vma->vm_mm, alloc_flags);
 
 	mpol_cond_put(mpol);
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 259f9f43b38b1..1f03f5e775554 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5242,6 +5242,7 @@ int __mem_cgroup_charge(struct folio *folio, struct mm_struct *mm, gfp_t gfp)
 /**
  * mem_cgroup_charge_hugetlb - charge the memcg for a hugetlb folio
  * @folio: folio being charged
+ * @mm: mm context of the allocation target
  * @gfp: reclaim mode
  *
  * This function is called when allocating a huge page folio, after the page has
@@ -5251,9 +5252,10 @@ int __mem_cgroup_charge(struct folio *folio, struct mm_struct *mm, gfp_t gfp)
  * Returns ENOMEM if the memcg is already full.
  * Returns 0 if either the charge was successful, or if we skip the charging.
  */
-int mem_cgroup_charge_hugetlb(struct folio *folio, gfp_t gfp)
+int mem_cgroup_charge_hugetlb(struct folio *folio, struct mm_struct *mm,
+			      gfp_t gfp)
 {
-	struct mem_cgroup *memcg = get_mem_cgroup_from_current();
+	struct mem_cgroup *memcg = get_mem_cgroup_from_mm(mm);
 	int ret = 0;
 
 	/*
-- 
2.53.0




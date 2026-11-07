Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064479;
	b=jiaMKwPKCvJsMGuwNtIfTu8HNg/0CgixgoAzMrKGW1gW3ujhZRml1k9NCqu5xP/oLvWJ
	 u4HZag8Uecqo3xQ3Rz+OIZunPGyGoz+rFi6Gswd91RAxxNsBlcXLCnL+Y3G0+Wa5HSC+e
	 UfxCT+GgGVAmQHBDprm1d150605CVrGCAR6iNNjMOy5kwBt2vzEHyQxirz9SyMbjsVRtV
	 04INFOhGLbs7csC/HwiviSV9avgn8ACLv+DD1o29AcmQvx9ZL7E7aeVdAm1+l65mRNjX1
	 Hw1+q1kn7x2Kuc3dVe4SmAUQAUFn2erhpYwyTXdoOcuSR672brOGj9u22psk3vaVweQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064479;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OT3+8sNzvHlWPq04reOaUnBTpyWiBUGOf9EmZUHtEEU=;
	b=Tv5zscm1CHxwheGDLwL2X9ea+Uj4sONBB6eFq7UHYqvTQuehSAv4w47M+CdkOCJND+pN
	 aKqatRw+1lMzrfX/97YW8f07Ka80Cx5dKyH1+wGVHGcGGoM2xSP0XW6Qq4doOKhk9+dpp
	 emUOo3fDdCI/djvUDEwW4ifMw6tm6qQJ0muljmHWCKnn4rqA9XjheTE8tnX5wihNqrQqh
	 jGo8aSACuL2oTisEGEv1xnfSTJcCTxT33ia8hIpakp/Jnh4eHRrtCDxlhYTwOdVuJHM9C
	 YUZ98P4ORhy0TID2BhoEPjrBoQphxtPTnR/JGOThIIUC5hh7tqpjeLtUHpjUKshlNGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wkcM4YSj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92EFC606A9F0;
	Sat,  7 Nov 2026 15:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wkcM4YSj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32F641F008A5;
	Sat,  7 Nov 2026 15:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064479;
	bh=OT3+8sNzvHlWPq04reOaUnBTpyWiBUGOf9EmZUHtEEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wkcM4YSjlUeU8JH9/TAhq2skdeUuoh55Hct1c865flfKIdmrLe4xpKRW/Ug9SezYr
	 13t6FwSfsu0QRq+ksiO8DKGGf75ylCx69oSdcydVtq6nGzB3+PQfLD8NHWfpDpFm5n
	 yP1Ccu3Wz0DJbDFFUrStBNIOpWtc6CHmgZ0vuf58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ackerley Tng <ackerleytng@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Alex Shi <alexs@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Dongliang Mu <dzm91@hust.edu.cn>,
	Frank van der Linden <fvdl@google.com>,
	Hongxiang Lou <louhongxiang@huawei.com>,
	James Houghton <jthoughton@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jonathan Corbet <corbet@lwn.net>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Ma Wupeng <mawupeng1@huawei.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Michal Hocko <mhocko@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	Peter Xu <peterx@redhat.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Vishal Annapurve <vannapurve@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Yanteng Si <si.yanteng@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0518/1257] mm: hugetlb: return -ENOSPC on memcg charge failure
Date: Sat,  7 Nov 2026 08:46:54 -0500
Message-ID: <20261107134953.737343823@linuxfoundation.org>
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

From: Ackerley Tng <ackerleytng@google.com>

[ Upstream commit 956aeff185e7e16b989202bde0bb29859adba99d ]

Patch series "Fix bugs in HugeTLB allocation when
mem_cgroup_charge_hugetlb() fails", v2.

In hugetlb_alloc_folio(), when mem_cgroup_charge_hugetlb() fails, there
are 2 issues:

1. free_huge_folio() expects a non-refcounted folio and will
   VM_BUG_ON_FOLIO().

2. -ENOMEM is returned, causing an infinite loop retrying the fault.

This patch (of 2):

When mem_cgroup_charge_hugetlb() fails with -ENOMEM, alloc_hugetlb_folio()
currently propagates this error.  This results in the page fault handler
returning VM_FAULT_OOM.

Because HugeTLB allocations are high-order and use __GFP_RETRY_MAYFAIL,
they bypass the OOM killer.  Returning VM_FAULT_OOM to the #PF handler
without triggering the OOM killer (or having it make progress) leads to an
infinite loop of retrying the fault.

Avoid this loop by returning -ENOSPC when charging fails, which maps to
VM_FAULT_SIGBUS, terminating the process cleanly.

Make mem_cgroup_charge_hugetlb() fault handling use a common error
handling path, the same handling used for
hugetlb_cgroup_uncharge_cgroup{,_rsvd}(), which also don't trigger the OOM
killer and hence opt to terminate the process with a SIGBUS.

Link: https://lore.kernel.org/20260909-hugetlb-alloc-folio-memcg-charge-error-handling-v2-1-4b4a8a19a7f7@google.com
Fixes: 991135774c0e ("memcg/hugetlb: introduce mem_cgroup_charge_hugetlb")
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Alex Shi <alexs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Dongliang Mu <dzm91@hust.edu.cn>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Hongxiang Lou <louhongxiang@huawei.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Ma Wupeng <mawupeng1@huawei.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vishal Annapurve <vannapurve@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Yanteng Si <si.yanteng@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/hugetlb.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 86928d76ef12d..7a8f605881d86 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2834,7 +2834,6 @@ void wait_for_freed_hugetlb_folios(void)
  *
  * Return: A pointer to the allocated folio, or an ERR_PTR on failure.
  *         -ENOSPC if cgroup charging fails or no folio is available.
- *         -ENOMEM if mem cgroup charging fails.
  */
 struct folio *hugetlb_alloc_folio(struct hstate *h,
 		struct mempolicy_interpreted *mpoli, u8 alloc_flags)
@@ -2907,7 +2906,11 @@ struct folio *hugetlb_alloc_folio(struct hstate *h,
 		 * were committed to the folio and freeing the folio
 		 * would have cleared those up.
 		 */
-		return ERR_PTR(ret);
+		/*
+		 * Return -ENOSPC, since retrying the fault is futile:
+		 * the OOM killer is not triggered for HugeTLB.
+		 */
+		return ERR_PTR(-ENOSPC);
 	}
 
 	return folio;
-- 
2.53.0




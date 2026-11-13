Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590707;
	b=upHZunlEXINBUnfRQbL+OQqvB40YkaiOyV/dsxUgid7Nsx1QpJWu7zVTUy3jKqnu1/SB
	 z4g2zMfEVqRhGrKysZgS6E33LrQDOx6ABAj8eqRDil6to2kiHgvnoHS2DRulHm8gfY7RL
	 uCzLa0LufSY0IC+X+aKauaPkyxhpVHzpee+h2Bf8+R99J8fGIspsLFdF/e7D9QhnLI3pW
	 Drxi61SIP9rrgg5RASIsSyU7SjH6ThcFqteKY3GJVmWL7Z3BKw1ed7VOCdUN1Jjks/4PN
	 HIVWEIytvOJpMmXg1KVR8hThKvQPWO0jEXnS6WX8cvbvzn9VfCGqYl5MylvZ91pogsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590707;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bpVUq7ExbWmGbuhydTMpxq7h3nvEIcY9K5CHnfBJmGg=;
	b=Su9RYpGQMvatZzM2PWFBKdxFuNYxUWnznlaS43HCnpXhRpooSZVrr/IeGxI9/jEV74vL
	 ufhdGaySCqN/ne8v3PMslIIMZGLn9ekawd9VVLq5JWgTvA01oMSAeMWeQbbnOppOSHPXw
	 8wTqx9m6prnf40+zm9l0cBcNrzlGziWkFiMkTptB5r291IcB1OjWbrsPJjSgkK4w4FPrS
	 Ls8iM4ZQW+m8fJv+A4Hpw4GSAOS95QBKhch1aqraxlmpSAVy5b8oJXd7u/0GvxW7dTYun
	 Mk3QU319/ItSymZKvnWy4Lz/vUZcUuxyfJOjXSR96svyBTTtiIfEC67ubeKfqSY40kw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ulrneaJd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6441B60A5BC5;
	Fri, 13 Nov 2026 17:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ulrneaJd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 099AE1F000C4;
	Fri, 13 Nov 2026 17:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590707;
	bh=bpVUq7ExbWmGbuhydTMpxq7h3nvEIcY9K5CHnfBJmGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ulrneaJdXIf9DchQQnFBHdOhjv6TUNRurjBbp7iRNozrq1iA4LJ0pthq3dS1xEtyK
	 861GJOkzWhFPKXfsJu5kwaBOyE9x2gPP/nwK/Nzo0/aMjqPXwIxKZ0G8D675ad8vyk
	 /HUYB6DyujbxEE3iZzLavY5gYHHyqbKP18ilNnc0=
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
Subject: [PATCH 6.18 617/686] mm: hugetlb: return -ENOSPC on memcg charge failure
Date: Fri, 13 Nov 2026 10:52:30 -0500
Message-ID: <20261113153842.782771916@linuxfoundation.org>
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
[ sashal: Adapted the change to alloc_hugetlb_folio() because hugetlb_alloc_folio() has not been extracted. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/hugetlb.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index fccff6d6ca64e..1bfeaecf9b4fa 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3134,7 +3134,11 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 
 	if (ret == -ENOMEM) {
 		free_huge_folio(folio);
-		return ERR_PTR(-ENOMEM);
+		/*
+		 * Return -ENOSPC, since retrying the fault is futile:
+		 * the OOM killer is not triggered for HugeTLB.
+		 */
+		return ERR_PTR(-ENOSPC);
 	}
 
 	return folio;
-- 
2.53.0




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044008;
	b=J/hlHuLpz7u2GTZMCpyUmyn5GGInBUReQ3yXqpBoaHamFMkAmTxtQYdnau3sHZOHuKc+
	 nKX0jL1B3DEKEXLpe2KNjmDwr27Q3sDDeaPIO0EolHh0SsdlcyE+XGmhQSRm/EUxaPBvD
	 D+Ih6OFDrHzC0mPO04fpbQAWlf5R7deWST+flR6XK3K8ehU4ej08mPYSh9CP7fQl0xJ3x
	 kGo9tuYkomLKHKAx1n3A/vyBn3D/omOmDwLZZFFG7ZQal3qP1ULyoH4MiZQtchPbyX+9v
	 fdMOR9CaclZ+MazNSzvHnwOGBR0xYw/Th9rIL8caV8fARObXU7q251c81hjzcV98W4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044008;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O2dB8lWfCBxW2RIz5iWi+JbK+x1OQWDJQMRuqf/dZmw=;
	b=4NKSF4NAaAApw9aGFTC34fLOZVDqydli0ue1Vy3yU1ljNxwCo5qQvIhwEM+it4WYhT6G
	 N3sTR2knVPVZJi4ncGRdZAz4lPc3tYvEB9XXrACKwCNiXiNlSVnIjr7/tao1FiWgseZs8
	 f3kPbLu+f8DiQUidF+Htqv/oSkbqnVzyGkd7Wxr+qmcW5hbbOck7wT5vkjDmZP6I0I4mu
	 jwIJiGdlN1muTJN6o5cvTsRhAJoVkoOtcvGn9Hb4c75KrQTtynx2b7lfjiuxgDEAmAqYy
	 ckZwSMaxxY+eKaNNtBQFkGCOXBIQQYuTVtIweCDJS2KaFOqXBzmI0+ttJ5wfn05ho/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jP0RXGPT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB59360A2633;
	Wed, 18 Nov 2026 23:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jP0RXGPT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFCFD1F000C6;
	Wed, 18 Nov 2026 23:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044008;
	bh=O2dB8lWfCBxW2RIz5iWi+JbK+x1OQWDJQMRuqf/dZmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jP0RXGPTi3X3gpZSWyXjeCmV479mam8DO5ehAGP5opKY2VVWRLFQl7jbbRB1HVRnh
	 DwWUwwzv1sSC2J1MlQe5uDz78Ss9hhmGl3J1CUrx+FR6ODLBNUJ70UaTNfQmmLA19J
	 BPSQW0zvp6R9YsBl6/7BfFVFpIjr6NIMd8ogKbP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Weiner <hannes@cmpxchg.org>,
	Neha Gholkar <nehagholkar@gmail.com>,
	Gregory Price <gourry@gourry.net>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Balbir Singh <balbirs@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	Byungchul Park <byungchul@sk.com>,
	"Huang, Ying" <ying.huang@linux.alibaba.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0369/2857] mm: mempolicy: fix automatic numa balancing for shmem
Date: Wed, 18 Nov 2026 15:23:23 +0100
Message-ID: <20261118150214.709086099@linuxfoundation.org>
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

From: Johannes Weiner <hannes@cmpxchg.org>

[ Upstream commit d230991493b521eeff39f32434fddcbcdb109eb0 ]

Neha reports that mapped shmem aren't considered for NUMA balancing,
noting convergence problems and bandwidth bottlenecking for cachelib based
workloads on tiered memory systems.

Looking at the code and going through the git history, this doesn't
actually seem intentional:

Commit fc3147245d19 ("mm: numa: Limit NUMA scanning to migrate-on-fault
VMAs") added a vma_policy_mof() gate to task_numa_work() so VMAs whose
policy lacks MPOL_F_MOF are skipped from NUMA balancing scans.  The
motivation was a real usecase: Oracle was pinning shared segments with
mbind(MPOL_BIND) so trapping faults was both expensive and pointless.

The handling of NULL from vm_ops->get_policy, however, treated "user
explicitly opted out" the same as "user never specified anything." For
VMAs whose shared policy is absent - the common case for shmem - the scan
was disabled too.

This issue is old.  It probably hurts less in conventional NUMA.  But it's
very noticeable on tiered systems, where entire tmpfs workingsets can get
stuck on lower-bandwidth memory.

Fix this by having vma_policy_mof() use __get_vma_policy() directly, and
thereby handle the fallback to task policy (-> preferred_node_policy() has
MPOL_F_MOF per default).  Every other consumer of vm_ops->get_policy
already handles it this way, the scan-eligibility check was the outlier.

This preserves Mel's intended fix: don't scan stuff the user explicitly
pinned.  But allow default policy vmas to participate in balancing.

Link: https://lore.kernel.org/20260629163337.1264881-1-hannes@cmpxchg.org
Fixes: fc3147245d19 ("mm: numa: Limit NUMA scanning to migrate-on-fault VMAs")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Neha Gholkar <nehagholkar@gmail.com>
Tested-by: Neha Gholkar <nehagholkar@gmail.com>
Reviewed-by: Gregory Price <gourry@gourry.net>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Balbir Singh <balbirs@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[ sashal: Adapted vma_policy_mof() to the older two-argument __get_vma_policy(vma, addr) and get_policy() API by dropping the pgoff_t ilx variable and the &ilx argument. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/mempolicy.c | 19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index c4a38d1b695f0..55da9a479aa3a 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1798,23 +1798,14 @@ static struct mempolicy *get_vma_policy(struct vm_area_struct *vma,
 bool vma_policy_mof(struct vm_area_struct *vma)
 {
 	struct mempolicy *pol;
+	bool mof;
 
-	if (vma->vm_ops && vma->vm_ops->get_policy) {
-		bool ret = false;
-
-		pol = vma->vm_ops->get_policy(vma, vma->vm_start);
-		if (pol && (pol->flags & MPOL_F_MOF))
-			ret = true;
-		mpol_cond_put(pol);
-
-		return ret;
-	}
-
-	pol = vma->vm_policy;
+	pol = __get_vma_policy(vma, vma->vm_start);
 	if (!pol)
 		pol = get_task_policy(current);
-
-	return pol->flags & MPOL_F_MOF;
+	mof = pol->flags & MPOL_F_MOF;
+	mpol_cond_put(pol);
+	return mof;
 }
 
 bool apply_policy_zone(struct mempolicy *policy, enum zone_type zone)
-- 
2.53.0




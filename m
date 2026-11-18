Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034607;
	b=Cvd9H4Lf+YDxJ/LcwIGvN/6q5pU216yHssH8vei/sgyR7xWPGFh+oXcQJ6avAUNKj8n8
	 6qxgyAXjBwNu6BvH/whWftJYqmZua9Ze0aPP86MbYYWbC9fPMwU5XTnvwwFaHf9S6MeKQ
	 70XAbPD6nuw1OG/C59ACeU1JP1X7eZxt/ac8TV/Fbf3PLmKceJAv12hkzDT4OuEZ46LXW
	 OG9QAVA9godOlAGMPlYAF8bV0OOQBBX1//1naYuEAVSbsPLYh17AsVDv2hl8hGs7kJU1M
	 4tWvMEsX0iyd9pTC1TDg/rhke0I75KerS5PB0IoKEacRf2jBwoZh9gWYx4uiuqdO4kA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034607;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hWiAxnKSFPPvAufNbD4LFfzbqVAT9OxqnruhPTOZIcY=;
	b=RMFIasuG1/F51stZ5TMiqqpvZtxPhMlNfYxq27Tm8f4BJDvjtbrCPDVwHChlmlYJNnue
	 1dg/zjHqTiaFvCsEblNataGh3ej0c7XKjTtoJ6juu811JVMlcEV7l0NFg6eSPukeFLkeu
	 XVXz9sIgeRsZxKumd1YkROpI5Yklzk/zTLJVRNTA9ZtYhidqBLpgBAYn52OvCQq1q/jsi
	 0nRcRNHPVpomLW2oZa5MVh3Tz9WGdvxJ61RFTQffHM0mvw8RZfZQ6je80hnNdSsOtyfyk
	 oaEeVQWspNWZpEqkx7SqtXxsm2vgR61GzFBQg3+oFDvRJKNpF7yfU9OiOuIB/N4HOFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sJifctMN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA1CD60A2619;
	Wed, 18 Nov 2026 20:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sJifctMN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B44DA1F000C7;
	Wed, 18 Nov 2026 20:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034606;
	bh=hWiAxnKSFPPvAufNbD4LFfzbqVAT9OxqnruhPTOZIcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sJifctMNySX21BOc12wSh+Cb+k0dgmQgOlByvP7WuGvBrwuyk4oiZuMRGzhuunfh1
	 A/b+Tm9TmPRzfvBW5bWnpY4490T2/AzfqFeTRr5WgHYB82UJ3wFIaHLwzhXZi0ryqS
	 6Z/gx/jRu/qlbu6XqJGQQ5OirkS7BsnjVJ9eG04Y=
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
Subject: [PATCH 6.6 0427/3318] mm: mempolicy: fix automatic numa balancing for shmem
Date: Wed, 18 Nov 2026 15:17:29 +0100
Message-ID: <20261118150329.411587908@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Adapted vma_policy_mof() to the older two-argument get_policy()/__get_vma_policy() interface by dropping the pgoff_t ilx local and argument. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/mempolicy.c | 19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 5bbeb6df9c007..5d4a9f67bfc4d 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1799,23 +1799,14 @@ static struct mempolicy *get_vma_policy(struct vm_area_struct *vma,
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




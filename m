Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059030;
	b=UrWl4MH9Q64Oaxp9nqvtVeCSquIkt3T0IpEcI1BZXf1z4suBMVfI32Pd4ckeSLDiaC06
	 2LyPAWR1PJeW5DoI4ZJ0C5hrZETL/9cB8rOK8BzCMO9zwA0C43f66a7PwxNlJ5Wqi0a8z
	 SDePen+zYnrLj9Xr6YRmFY/rXsgXxneL6tgZZsaSJmBcLlOu8ZsVe76H/Qe6wdpUfH8y9
	 9ZPoN0SnQmQFoFhB9Lo2C7LXZzQMKcQ8R8M4uYaRMwC6s9OkPGOHIaoDJQh6k/Yyodfv7
	 +oO0aHnHT24xOlmSPm4c/j0wA/GKwY+gxgrbhEKEkUFVZUtNZuzbvcA58Yz8UpmH/FA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059030;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jf7oDSDOAdrtDM4jC5jBdG7NSfrb/sGQZS4VkSOFyy8=;
	b=T+Jtm/kWHG5USe/a2aen69V192jgyLFp5ifzFmD2Mh9VRLCAnLpo+8sHE8xnsnsDjY0g
	 3g2CUjv2VLcHrbn9futcHbdOVYbDR+SGK4aKrK+VRHDJlg4Qf3cFCCfDDNpGT41jjR++6
	 tT4A0eZ9sJzpWvTuJkoOTxfIoAiK/6GYCOhSG+D31VCUgi9d6NUZihvxgoDYgJxZ71RS/
	 VqF0HqpqyNYMak75tOEYaN+iDuoh9VYESMIjX1JAHwMmlMaGU+2DsWDKlKKPN9IXquEeU
	 tAkUsh1/p5l1sPIn8VQ8xvfeeU/qgqva/dNdQBlEA5mA9a/pK3DcEtSm4IQtNaSYEEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X7Zl3uUR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 531A2606A31C;
	Thu, 19 Nov 2026 03:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X7Zl3uUR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A85021F000C5;
	Thu, 19 Nov 2026 03:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059030;
	bh=jf7oDSDOAdrtDM4jC5jBdG7NSfrb/sGQZS4VkSOFyy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X7Zl3uURt7NhvElNpPLRBAlCPDbfWbMX6wz7Hg5Bw5liOgIvnVe99mE8HWXmMer1h
	 dRpnlHqUaNnRptbiUjct38ybnyld/ztqh6mbB7/cv6uyncnjKvP992uPWL3PQ4BqbU
	 RFARzoP8T1OXZJ+yYC1nw4R6Yx79gRApBPZIuobI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Balbir Singh <balbirs@nvidia.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0695/1848] mm/mempolicy: charge shared policy nodes
Date: Wed, 18 Nov 2026 15:45:33 +0100
Message-ID: <20261118145944.994260532@linuxfoundation.org>
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

From: Chris Mason <mason@kernel.org>

[ Upstream commit 68b2aa37afa390f08de13bc0bac61a9ded3318bc ]

Any local user can bypass memory.max with mbind() on a tmpfs file, and
allocate unbounded kernel memory.

mbind() sets a NUMA memory policy for a range of a mapping. If the
mapping is of a shmem and friends, the kernel also stores the policy on
the inode, in a tree with one entry per range of the file.

Each mbind() on a single page of a mapping can add one shared policy node
(struct sp_node) and one struct mempolicy to that tree. They outlive the
mapping and stay around until the inode is destroyed. The tree is not
bounded by the file size, so the file can be empty.

Memory that user space can allocate must be charged to a memory cgroup. A
slab cache does that for all of its objects if it is created with
SLAB_ACCOUNT. numa_policy_init() creates the slab caches for both
structs without SLAB_ACCOUNT, so they are not charged to any cgroup.

Reproduced with mbind() on single pages of an empty tmpfs file, from a
cgroup with memory.max=8M: the global OOM killer killed tasks owned by
root, and the machine panicked.

Fix this by creating both caches with SLAB_ACCOUNT. This change implies
that mbind() can now fail when running into memcg limits. Further,
the policy_cache also serves task and VMA policies, so they are
similarly accounted now.

Note that per-file limits are not really helpful, as the user could
simply use many files; having limits per user is tricky as well.

Fix generated by an LLM and submitted by Chris Mason in private.

Fixes: 5d097056c9a0 ("kmemcg: account certain kmem allocations to memcg")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
Acked-by: Pedro Falcato <pfalcato@suse.de>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
[ david: smaller description tweaks ]
Reviewed-by: Balbir Singh <balbirs@nvidia.com>
Link: https://patch.msgid.link/20261029-fixes_shmem-v4-1-392fc715d8f6@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/mempolicy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 6c98585f20dfe..c6c5682c334b0 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2788,11 +2788,11 @@ void __init numa_policy_init(void)
 
 	policy_cache = kmem_cache_create("numa_policy",
 					 sizeof(struct mempolicy),
-					 0, SLAB_PANIC, NULL);
+					 0, SLAB_PANIC | SLAB_ACCOUNT, NULL);
 
 	sn_cache = kmem_cache_create("shared_policy_node",
 				     sizeof(struct sp_node),
-				     0, SLAB_PANIC, NULL);
+				     0, SLAB_PANIC | SLAB_ACCOUNT, NULL);
 
 	for_each_node(nid) {
 		preferred_node_policy[nid] = (struct mempolicy) {
-- 
2.53.0




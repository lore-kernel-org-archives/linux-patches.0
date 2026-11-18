Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037555;
	b=GMV+5RSQ4/npT956yEsuQaIUvUEIDCCosrOWlGqriuiP2lUBjMUQSvHmnv7Z86O7/q5R
	 ka7sfxJcR5V/Fw2SiYh0TcjfMhCVwb0Ew+HqBSh8hnbf520iDgtLmd3lu49Eghj4t9NCf
	 Mp/lzZol0QhLizn4zqz1qtqx6aYfp3kzvMs398VK3uB3TW12FlPIdF5NMVH3f8IEdnFrw
	 +zhYZr9/01mioism+UtajRYj0wrAPAezmcmFFfhUH3K+2meYmsp3bG0vrwznJWNugZa9W
	 CuddtshH9gV7Nlm7G/2xwhHjR35l8CdgQ+2tkzn4HHIii4eYnysn4Zz1GxhRVh7Bc6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037555;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wUHO0aal1nlYUD6sRl1did65JEJqoM48CadFu0/StgA=;
	b=uPaiM637CkiBxV2WjDHJp6OY7gO5sgQmVrh1+eDlbmo314M65Vm28xUIixBR5CMo7EEh
	 qHouyaKLYeUB97ubYf0OOP3gL+lwkI6xqWzsm9OMRp7m2KPWF+gk/ltYCvzAzmiPa6YPo
	 SrUrA8q7ybjdivIY44A/+D0P5RJo87VEjU3ufjG8GjcaBsxOhxkE3yf6y7JSoruyp3lAs
	 Y7IaZ037Qx2rYDOCSYH5LAdbCQ9RgmCcoLBxAKIgN1fOsEIFF5m0QRvAj5MzQsafBvfux
	 u0Syn6ELHZrCYsdI4GEnL1sHSN+zptzi5G0HN+pPMMD9vLZdl2IgziCMSS1Qfyetr1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l0Bhi949;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E48B606A31C;
	Wed, 18 Nov 2026 21:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l0Bhi949
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A9611F000C4;
	Wed, 18 Nov 2026 21:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037555;
	bh=wUHO0aal1nlYUD6sRl1did65JEJqoM48CadFu0/StgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l0Bhi949SpZCLfn+YSE5BAAV/gVrA+RElqX18dCyAkqLFsSVpo1I0+q2ifz2GmMtm
	 cZ4PDuqFCRyPLdWQ0mHqCpN/jtclfRsjzKE/UoolPJGQGz2sLAda8hwl6wmAP4Ri5O
	 qcfvZMQR7CY79Vq41j6CjfvDIISumMOPraOTW100=
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
Subject: [PATCH 6.6 1439/3318] mm/mempolicy: charge shared policy nodes
Date: Wed, 18 Nov 2026 15:34:21 +0100
Message-ID: <20261118150403.982289031@linuxfoundation.org>
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
index 0d31b705015d2..393b2f1fee9ce 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2898,11 +2898,11 @@ void __init numa_policy_init(void)
 
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




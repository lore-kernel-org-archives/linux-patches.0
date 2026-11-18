Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046279;
	b=VbWciicP4o1fVXZ/TGBAXayqumxb0OBgpxkxQ7Q68GeJqZC1e6AchCdOORqYhl2/RvZh
	 OkSjoJKw9KjNXcvBN1N7po4dvjU1Tov4niuiU94p4Nd589gPoNjoNtnW0ajXLv+/XViC9
	 NWP5Z7f6b8Flfo21EwKCvdtLfl0xbz0Gr+4Fo28ToF6uRReCZJMadwzmb53y05uWhVF1l
	 kb5P1ek6eW1VxD+oRgpLwt1TBYCefVda7UCaPdASuC8Wy/K/K8EiO2Fjyl3WVmdxpqBfK
	 xgNVmfPd0gJWFMfZRrEYHaV/xSpl9qeHxpUV3G8zJ7RWZmQk64mFDFUDzL8PdRu1x6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046279;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MwcZWrIUBB4B14SBVtnQs3ojiEHcz/aL9BuA3jBwEwI=;
	b=EgvuPSv1nFFOKwMTv7yaOvRIFEj+W6/pM8qvQB919x65doWSFIFtR9EwYjG2wHjLHI/M
	 kD8xiATvG/WC3Rer1Xvu/VsS8VZwvwsRvtAb6aS7gKWdNPGfhTSM42KKzWGIP1zOhNb49
	 XRCFDvEiNtVrmtgFYW3YMcI3p1yvpdkqqfOUMqh/ePRAs5nIyvPL0B3wAdev7t6eUavkr
	 kv5ui64eptmMppGxfVSN/QxaQ3rOjn5tlEBMABKd0FN9xpSLKHENaidfS2QiT3Zk5Q4Fk
	 aqk67Gohcn8Sxa8ModJpZP2l4sMJAxh4d+XumwpREd7IJcAm0rB08rF8PqEW0yFpPMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YokvmYLg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B8A2606A320;
	Wed, 18 Nov 2026 23:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YokvmYLg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86C4B1F000C4;
	Wed, 18 Nov 2026 23:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046279;
	bh=MwcZWrIUBB4B14SBVtnQs3ojiEHcz/aL9BuA3jBwEwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YokvmYLgSF7VT/MRUjX+nOawG/jD/yBVP7/w503CYCws1i9bVU9yeEofS1oYz+wXK
	 KRGoyiTnbbXi6CiUI+1FBOtxnGXpJK4RO0j5gx2H5XnRVQiEjR6COjyQMDXhJgKFdr
	 y59nJW/zPJ4XbM+1oRBzli1iFjoYSL/WYCTEHNi4=
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
Subject: [PATCH 6.1 1224/2857] mm/mempolicy: charge shared policy nodes
Date: Wed, 18 Nov 2026 15:37:38 +0100
Message-ID: <20261118150245.640685249@linuxfoundation.org>
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
index 48f7c15977335..5bc8ba6fa5189 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2907,11 +2907,11 @@ void __init numa_policy_init(void)
 
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




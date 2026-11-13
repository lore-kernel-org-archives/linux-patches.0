Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585482;
	b=1qOclB6JCE+j5MIrIYAxrlJha1zO6Z4L83C2qn30StZuz9WwwhCDsEEKp2HTFcK22DQb
	 W4V1SmblLDmGICBPffdxRy4FnmAL1ifUnEvcpWJ5jnGJ0mWGGvCOnEsg0HoM7dqIN9Mbl
	 r6uyIjcsnSF4kQ2mOSpN7TCKo5C6hykFX7beTyfiba5IByQl2MIQ9dDtqoVpdr4ZDKGCP
	 5tjmEECHr5EnP8SWAzD8w1l4UW6w1gpX2WRsXPLg3rzq5iW3Ih+SnvfvLnhZj46dQB+pL
	 HbI12NoIhqquZrWRlwpsZlkbETqp4Z4k7fYXl2u5QuWOXraPzbOt85sdmEqIeT3CUww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585482;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=McOdPrds13gx8QQxOt9/Z5yPAf5g/r3Qy4WxnQ8DBx0=;
	b=MFLb6vruhaD91L0bUR0yJ1kBvYiGd68pTSrTqaecpZNH6vvyqVO4ySpnym6bLvRwjYkb
	 UEb/1sMUsKpaAB72aU5cvftC47WOvM5w8MuMM+48m/3igoylE9twthunlb0Wm3jqO4gi8
	 nV2kSvLr2NZIGwB/TF0qO7KmIMnmLVE8rnGKrgorJJ1GP2JWxwYrUT56hlFcHjYs1e6eq
	 TSSa0gz3C6ufRJjONK2ZQrk4mzRLgIDOWuwSidNR3zt1YWRdb3pPOT8OkKBNu8Biycdh5
	 htZVcYYzVJ0R4wxsQDWej4zjhgwNf9PXBa0q0d2tCVrfLbGNUFVkiOxTt+6N1wtyE4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BbhkddTh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC587606EBA3;
	Fri, 13 Nov 2026 15:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BbhkddTh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BD651F000C5;
	Fri, 13 Nov 2026 15:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585482;
	bh=McOdPrds13gx8QQxOt9/Z5yPAf5g/r3Qy4WxnQ8DBx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BbhkddTht+7uv4wO/vuQHQs9L7AJWQQNVQ14wadWb1ufSl95Iz1ecdauRZxsz9AYx
	 K8ekb+uYw1dpvbQ7TJ8VDzZKYxkr6WsXUhaJoh57MUTAe6dQ9XI+Gy4WTV+LliKwTg
	 9uqCqIIv9IQFvTzjGoez4V6h2f6mbzPqIPo24/7c=
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
Subject: [PATCH 7.3 133/507] mm/mempolicy: charge shared policy nodes
Date: Fri, 13 Nov 2026 10:47:17 -0500
Message-ID: <20261113153758.957212410@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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
index 839c3fe985a0c..d9de3b5d5ebe8 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -3346,11 +3346,11 @@ void __init numa_policy_init(void)
 
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




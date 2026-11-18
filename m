Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053276;
	b=pxxBf6ZMPk1ZhKf9PNXM9XxM1e8xdqC8yONLzWko/3/wRtHPSHID5BzLgCKU7c6nkXlS
	 tB3uo6cPVvCMS3V9XoDkuKbKQewLLx2TV5P+Gk9g9RpPTNFJWJKkOCdEbPrxKpezmUFck
	 xnICGRt1lxOneD8XZonxN9JrngEB74bidvDcG8eZuet+EPIvumXdACNCpsBSH59BMDoQ+
	 3p9/9GgSWrxMDvyGY3cYG62Hu4S52ggTgyzn4wXg2UjNEAnmGvt2XmA4e6vQSq+iBcpb5
	 Kwtvb6tT5Bl1Kr1buvgkYuauCPwsh8oSSXkKfVIWQDXXntniPAOQhnRDCwtOrzW95aQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053276;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Wmi2/x9Y6K4Kda0TfHt817H/KSw6zVdtBsrdabcIBX4=;
	b=Y6aZfNhBxLtLhmPwG1W8LiStc8VvW/hn0F/rrAbdb6KU0gjfI1WkYGd1+WraBCLAI5FJ
	 wBZIYiiJiKzEG6HFjNhVQUXF2CU94A3X8E+sdjx62AbvFZQzXKpajcVC+udqqFqL0xvAZ
	 LAUNeiakOajN6dhD/J3COVsaP5sl/ZRbrfdNkedeihkDo9gE5YctqZK6Ndk6FOcCEm9dJ
	 9WqmnUZvzSupZYeiOJy5vpkkL2KnZ9zSf3y78DY4BOQDQTYcuPIiB9AA2FSop6wVnuDDV
	 xm0X9wzZ6ELIv7HnbX+6SG844bm5ibMipukYCj7ZD3DP/OWG3JZeLuGN140SQFfIY3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PHe+K1tW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA91B606A31C;
	Thu, 19 Nov 2026 01:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PHe+K1tW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F9B41F000C5;
	Thu, 19 Nov 2026 01:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053276;
	bh=Wmi2/x9Y6K4Kda0TfHt817H/KSw6zVdtBsrdabcIBX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PHe+K1tWXegS+j+k2iQHm1K/+GUGkw76PqQ1xOM1cvbtogM/oKXGZV86+y+EcgVw6
	 rsYqWUuBdbBixxCtDt6MdcU9kp33wMp+7h4NJk2lDQHvXcV8+XcCFuiwi4jKNXdDQK
	 kKjBWOx0fXaFYRfQwt+gIB5UqojFsadSaTDadGiY=
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
Subject: [PATCH 5.15 0862/2214] mm/mempolicy: charge shared policy nodes
Date: Wed, 18 Nov 2026 15:42:18 +0100
Message-ID: <20261118150046.636730749@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f089de8564cad..51ec529425118 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2713,11 +2713,11 @@ void __init numa_policy_init(void)
 
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




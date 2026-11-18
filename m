Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034045;
	b=2bUnriTNepcGDTVYdJAirgxbk1yy0+a/zwWVLmjCT+sFny8wWjtWcNSWwe/PUKu00cgh
	 9hTWr16zInrSWGHEUH+6nyRQbgbzky/iWQpQ5Uum9Vn+IaSVH5iiSIdbcNQWbb0zfDxkK
	 WjfgB3nvQt9XIXYaKEZN3i1lSL1Pwr/fenN/IffIRKpYk1G0tvI79qP4oBHboxttQAXnk
	 ZZxRaZuUX9DUmh4YHF8xfJW3HrHYqW1+CnKwMV7Ze+TU4arM1z8kvuuEvytRQ/lVZPsFV
	 MjXV6d+A/ijlZNfx50cO+QsEUsHV5e/7haCFD/BTfBGT7DFpdwzt3GHFbbI1M15bcrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034045;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=y7vQPLKbkgyZzpq+yqOnL2GPkRrmmcU8O9bZKdMmphM=;
	b=FOYaVEnEGQBDRnYxTg+spySWVjU/W+oX9p/xL3AiGfXdAWPP/siBoES6m2sNf5KzwFHe
	 J5Ae7P2yAdjPtCgrMh9afJ3BLvkrKIR4X5k3pbDtYI63+tkbmYLT4yfde9esK4mXSPYFC
	 qcIsV0z4TU0IeC+cfIY9HlAk2N3/XjESp93hHk0ibtJrFR4uEv6CdThVpH359MjDo/Sqy
	 5iSg9JlWgD/J/AyTlNZDWk9AUvjK+bGwI1Y88iNqQA489FxEwdf5vw+5Ubae/qXf1m18L
	 JZ0sUGzbIr9xKGyzdlGc2a3GR5Ni1b+nFDTqtVFP8eC0f2x8bTvmVKArrmMnohV5lAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lp1izcyG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A56B8606A320;
	Wed, 18 Nov 2026 20:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lp1izcyG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 067DA1F000C5;
	Wed, 18 Nov 2026 20:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034045;
	bh=y7vQPLKbkgyZzpq+yqOnL2GPkRrmmcU8O9bZKdMmphM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lp1izcyGholPp/9OmnOP5nndAhpxcRrd4+4Ogv8wcf99fLr15i76zwRnFybPjJFRT
	 GW2HycRs2YuzERDyCgXCeEli2/W63020WBDTKkQ5mCLhiYVTjv9u/vknc18uZNSc2J
	 HBgjcP9DR3xlsGUvIQg0THhhz5SgY4jygPvbeFVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zihan Xi <zihanx@nebusec.ai>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0230/3318] xsk: account ring allocations to memcg
Date: Wed, 18 Nov 2026 15:14:12 +0100
Message-ID: <20261118150321.965314333@linuxfoundation.org>
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

From: Zihan Xi <zihanx@nebusec.ai>

[ Upstream commit b0057c68df711bf6a62033c072ac61c4f9d3cbc1 ]

AF_XDP rings are allocated from setsockopt() and can be mapped into user
space.  The shared xskq_create() helper allocates the ring backing memory,
but the user-controlled and long-lived allocation is not charged as kmem
to the allocating memory cgroup.

The current implementation uses vmalloc_user(), which allocates the
backing pages with GFP_KERNEL | __GFP_ZERO.  Use the same VM_USERMAP
vmalloc path, but pass GFP_KERNEL_ACCOUNT so the ring backing pages are
attributed to memcg/kmem and can be constrained by existing cgroup memory
limits.  This keeps the existing zeroing and mmap semantics while avoiding
AF_XDP-specific optmem or RLIMIT_MEMLOCK accounting.

Signed-off-by: Zihan Xi <zihanx@nebusec.ai>
Acked-by: Stanislav Fomichev <sdf@fomichev.me>
Link: https://patch.msgid.link/20260731164623.4694-2-zihanx@nebusec.ai
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xdp/xsk_queue.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/net/xdp/xsk_queue.c b/net/xdp/xsk_queue.c
index d2c2640300171..7069830943ea8 100644
--- a/net/xdp/xsk_queue.c
+++ b/net/xdp/xsk_queue.c
@@ -9,6 +9,8 @@
 #include <linux/vmalloc.h>
 #include <net/xdp_sock_drv.h>
 
+#include <asm/shmparam.h>
+
 #include "xsk_queue.h"
 
 static size_t xskq_get_ring_size(struct xsk_queue *q, bool umem_queue)
@@ -21,6 +23,14 @@ static size_t xskq_get_ring_size(struct xsk_queue *q, bool umem_queue)
 	return struct_size(rxtx_ring, desc, q->nentries);
 }
 
+static void *xskq_vmalloc_user(unsigned long size)
+{
+	return __vmalloc_node_range(size, SHMLBA, VMALLOC_START, VMALLOC_END,
+				     GFP_KERNEL_ACCOUNT | __GFP_ZERO, PAGE_KERNEL,
+				     VM_USERMAP, NUMA_NO_NODE,
+				     __builtin_return_address(0));
+}
+
 struct xsk_queue *xskq_create(u32 nentries, bool umem_queue)
 {
 	struct xsk_queue *q;
@@ -46,7 +56,7 @@ struct xsk_queue *xskq_create(u32 nentries, bool umem_queue)
 
 	size = PAGE_ALIGN(size);
 
-	q->ring = vmalloc_user(size);
+	q->ring = xskq_vmalloc_user(size);
 	if (!q->ring) {
 		kfree(q);
 		return NULL;
-- 
2.53.0




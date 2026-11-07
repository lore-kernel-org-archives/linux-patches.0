Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060899;
	b=dEtPFYWPtNrUeifxOJGVcayqVBVjadgYg+wiineVXTsV5lUdpwTkJiL8wNFmK+skHj2L
	 Qub3dLo/UaGptgzKmNTkxPEcxRsnXtY7A2OlVe1eIk+R4B0vAv2IdpRChx8VO/puEa4nx
	 LLeq84UPGMvCk9EUkSmQTBU2OeCcUpk2U6yMGZBJt9PuI85JFoC0bvGOymn82TBwX4y5z
	 pT3C63CfY7jDJa7OKv8XNwNtC4/OShvyo2RghxUuRft9fOvb7WQgFtg4L4LUs60LH/ZPG
	 6JlZx5Ns/8g2kqkNh9krZFhvOhOXKcdT6YEDby0NSRNP4qZThrrHWb2mHRNq83t9PVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060899;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PEn7zrnG+5N2Jn5KV3DG+M+yiumgcTe5MZ5pqoP8ZkM=;
	b=MQs7+2rAIJsUlzsF3RK//A/0xkxuDhnlv3mC7XbFs8Yl/Wq98FXJAmAcDTPCwM/3Zx6n
	 iBqJDDyHck8+gM4UhpmEvWHbu9QJA5ZRcTpWTU7T909pGw+z9Kli+HQu/Mq0yc16iOSE6
	 wjykmDL3dUdxe4C+nnu6mGRCaSoKBPLHE7g7nRe9owhtuKzQmVeklhx6ligdCSpg/LkzH
	 /86NsRt+0B38EWXQCtSg1F1DQsdXrpL8iautBd77dXFLvF9QkeJdhdyyztYUqtwcI0EGR
	 dPYH48BPapikdPwnStJhCvLyMiy1LV5SgTmZM8bQ5lh/jClXx2eNm1tRiYqk484GVXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IkYdia8x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DD32606D81B;
	Sat,  7 Nov 2026 14:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IkYdia8x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 395501F0089F;
	Sat,  7 Nov 2026 14:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060899;
	bh=PEn7zrnG+5N2Jn5KV3DG+M+yiumgcTe5MZ5pqoP8ZkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IkYdia8xzDeO/yVcDyRt3e1PIQPE6Oj8yeZ11FII4Qn6IffpgThMcd8UBc+NUBR4H
	 ms2qBRi++cb8wyuv9f3nasiT7edtCAHEtr6DGfswTvt/Ol/9NRazBba+rUtIwBqkO/
	 uo0pFHCp4uGEoL56AIlV7yElFeiwiT00mseC+aeM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zihan Xi <zihanx@nebusec.ai>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0273/1536] xsk: account ring allocations to memcg
Date: Sat,  7 Nov 2026 08:38:09 -0500
Message-ID: <20261107135005.342630472@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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




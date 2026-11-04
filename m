Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829768;
	b=OUVF7LQNub21yJKPR2Azrw88pQlVzB1MNdDIlsTzXgHbapgf/kcuDncizvbAAJywkj+Z
	 uvEEkh+3jlmoNoGKLAkJBHWcWH5ueQhvFV9LNhmf6tRyWYxCrAXc52a2sx/Ng044Bb1ZK
	 9ulushKBQoRFKx92cdrBoAwYdV5FH+87NeQgMS0JW5OJpN8JsnShfb4kEEZyMPxe61Ed7
	 0NNGFlq2sX+fo7L1Avn0p+EDYDMYTUYDd4zdCaaC5gSmRUrjjulGQES1NYcNEiZaWdGKf
	 ++zNrins3SaB7Zg8YreSsUsEKN0WAmUVxRGIuwKnVW99Pw0GozA8o1cWvIxZjZeLS2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829768;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nfv4hGHNuyIVl8eQup/5PBin4bgjK18yVZB3HApQPFU=;
	b=BVzJt2nPHuMH8ZWRo6B8ynqCrjyCt4/kqutTiOvvtBv4/4Y0nOY8FbtRHDiE1ijB3uB4
	 yV1tpCIfbkVdpA5jlSDjlIpOvKXJdpm2bSnJvJFG9MDGYwIrOYiJ9E6AWCj60Ci4TH8Vd
	 FSZxayIjdLuQYnjG9LC2syK1CD8aIdau1gz2RUo2VO33wU/g497r7nCQUUtwcHKT1SI0u
	 zN1cx22FHnaIufjehQ+2qIMiBpGwc/P00/Ih0iDumFfdujm8sLoXZdbXAmsYjz7cRZSWz
	 QXiZuKnR+uPxF/lhg342M9cx79Y3qJ7ns2YX2wnc0mH6PT38bwD+xfTgpSPBVYFsvtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hmN0x7hn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12493606C927;
	Wed,  4 Nov 2026 22:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hmN0x7hn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4D6A1F000C1;
	Wed,  4 Nov 2026 22:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829767;
	bh=nfv4hGHNuyIVl8eQup/5PBin4bgjK18yVZB3HApQPFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hmN0x7hnghmSUp1tJPrdsTx5VEAa020gs9DUf4TwLBcVvbHXAuSAVq+8fS2VNL1fR
	 lwzjlC9umbnqBDNH+EMztm5eBS9a0xdMg6SYZm32POq7tau8v/JvkGYMjR6YABqXcz
	 86U551bCbXzXGvdD8JiyA788Y32xuZEDGNcWR0h8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zihan Xi <zihanx@nebusec.ai>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0329/1005] xsk: account ring allocations to memcg
Date: Wed,  4 Nov 2026 16:01:02 -0500
Message-ID: <20261104211053.166968490@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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




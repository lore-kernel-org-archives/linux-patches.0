Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063690;
	b=0isDVZrqDYwykt9OqIcACggxvsLFNnFICRHYTeG6gJUw50J7p7EjwNTqopEWCuMTIxpS
	 2fHfW1trQurXPt2+wfZamX+8cefHVBC5wGsRVPijC0FCj4kalNzEA8g78+0LUvnzIFV1z
	 LNwNqjHDY8z0WdEsmyx5UNrfLHhWdCRpzDFj47o7IBRKbyS0Jx4OcSy3kJgtiLiVD8Rl4
	 hJass4JrMUDQKUM//025vKApQEWH7pw07pQtipfKePk/xsZ2xPls7cz+ZJ2qbAl0zP4fO
	 mhX4QrQR9RT1Yfj5LDz8cYceOibV8tHMt/KSkjMHvlVillRuN5/ICTTuKA8/x9+oIHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063690;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=v7SIfPB5FxgZl154tZhM2f42Kp0ixngKs2vxss8xD8A=;
	b=tHiBSv+PCFUsu2gIkXXtQA5d4gF1XKbtzSxpl6o5+1NVJahAvEAxCf8f+CNhfgwwzB8l
	 U6O8OuOSN7h9/NPw9Jyrv+QI1AqO+l1CPkD4DPg5qIGGhL4tRF0axn00xW0MwwZqUQl/p
	 H2MRM8xcqrOZ6G3HxJMAVIpjnh80hgxvtePSaVjXWHVIX9uSSaoAqkoG0h7COm8ED1jze
	 syRmo+w4J+j46lCirG89GuK7aPHYsWGlcV2NO/bPGR4IDABPkxXeDPpaHKvv1RbG5Cu/F
	 LSZrkS6NWmsKzCmdVeo7jE/3j6VgL8DdzqpKlQ02bfy7A1gEYlGIUDUK1F2bEhgpZsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GjCnRYG5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64C35606B894;
	Sat,  7 Nov 2026 15:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GjCnRYG5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CD791F0089F;
	Sat,  7 Nov 2026 15:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063690;
	bh=v7SIfPB5FxgZl154tZhM2f42Kp0ixngKs2vxss8xD8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GjCnRYG515PI2U37V/4Ceq9VP/VwaGmSY8f72nubGij6ZQBudbMIC3pQv5QBVkmjo
	 6iq9V6kZeNk2bm3yrkOBmuaJ39hbrI1BEi2w0c5kGDxUz1EDGwmf2j2s169dPOHH7p
	 tYMmVnklVZ32MRdoO/PpC8Bh1qVl1IRldFPFfrTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Moses <p@1g4.org>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 796/869] xsk: restore UMEM flags after failed pool assignment
Date: Sat,  7 Nov 2026 08:57:58 -0500
Message-ID: <20261107134919.779968616@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Paul Moses <p@1g4.org>

[ Upstream commit b88b826ec54a06f48a42580c609ba81293ebec8e ]

xp_assign_dev() sets XDP_UMEM_SG_FLAG before checking whether the
device supports multibuffer zero-copy. If assignment fails, xsk_bind()
destroys the pool but retains the registered UMEM. A subsequent bind
without XDP_USE_SG inherits the stale flag.

The flag also changes RX buffer sizing after DMA mapping. On igc, a
failed SG bind followed by a non-SG retry with 4096-byte chunks and
1792 bytes of headroom passes admission with 2048 bytes, but programs
a 1024-byte RX buffer. On I225-V hardware, an ordinary 1514-byte frame
is truncated to 1024 bytes or 1008 with RX timestamps enabled.
Restoring the original flags eliminates the truncation in both cases.

Save the UMEM flags before assignment and restore them on failure.

Discovered during development of AF_XDP changes for igc.

Fixes: d609f3d228a8 ("xsk: add multi-buffer support for sockets sharing umem")
Cc: stable@vger.kernel.org
Signed-off-by: Paul Moses <p@1g4.org>
Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Link: https://patch.msgid.link/20261021224705.2078753-1-p@1g4.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xdp/xsk_buff_pool.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index 5ee0edaf075c0..9dc1ff31867a1 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -175,6 +175,7 @@ int xp_assign_dev(struct xsk_buff_pool *pool,
 {
 	u32 needed = netdev->mtu + ETH_PAD_LEN;
 	u32 segs = netdev->xdp_zc_max_segs;
+	u8 umem_flags = pool->umem->flags;
 	bool mbuf = flags & XDP_USE_SG;
 	bool force_zc, force_copy;
 	struct netdev_bpf bpf;
@@ -270,6 +271,7 @@ int xp_assign_dev(struct xsk_buff_pool *pool,
 	if (!force_zc)
 		err = 0; /* fallback to copy mode */
 	if (err) {
+		pool->umem->flags = umem_flags;
 		xsk_clear_pool_at_qid(netdev, queue_id);
 		dev_put(netdev);
 	}
-- 
2.53.0




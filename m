Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91ED42D0606;
	Thu, 12 Mar 2026 20:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773347041; cv=none; b=H21sXbZPAkoagutVVsw19xKhEAERa29rmRJatSMoQzGN92tk4QQdkXC/zEGs6Qpt2AUPOQI0M+2vCPam35FgkdigDTev8KiBDeDd9hzf38kI/FS/nWquqjkUZk2d3oYYJH/As3tUv0Lv/yCJpXQjtBDvggcmVLhyP+v+GK+Ls/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773347041; c=relaxed/simple;
	bh=rgZCsoHzqj6wUGElhYCDWDGOVkWRncnjJEdugwVIEUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EQZPrSPZkMwuwpPVNNCaN6QsAdaFqbOuOHBydulSq/i+Os0ddSs8fau8JHHvYHSOnImIqCxVmruUBwKIgyAQoQowE7GdzT1Y8ezW1r7iTZ68lTWmtvOrytnqdrDgEEu3JrxsFve2dh5japKxLo4DxvVHDR//Eh4Kpl1vBqRw7j4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UaOOeC1t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UaOOeC1t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E811BC4CEF7;
	Thu, 12 Mar 2026 20:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773347041;
	bh=rgZCsoHzqj6wUGElhYCDWDGOVkWRncnjJEdugwVIEUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UaOOeC1tToaCNwNPM77teSC1i54YfbVWn2tIH5KEQr84nzRyioP6bn5LxsSk8s9xm
	 H5/8tzbee6DnPpdZxjn/heuaTOC7X3tl1E3LLea7nFRQtDgWpXZdoIQrlsOIxpY08q
	 x1y6FfWJv2KPMsf1TirAwCmba+uedTUjotiTEAv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Magnus Karlsson <magnus.karlsson@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 186/265] xsk: s/free_list_node/list_node/
Date: Thu, 12 Mar 2026 21:09:33 +0100
Message-ID: <20260312201025.031228126@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

[ Upstream commit 30ec2c1baaead43903ad63ff8e3083949059083c ]

Now that free_list_node's purpose is two-folded, make it just a
'list_node'.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
Link: https://lore.kernel.org/bpf/20241007122458.282590-3-maciej.fijalkowski@intel.com
Stable-dep-of: f7387d6579d6 ("xsk: Fix zero-copy AF_XDP fragment drop")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/xdp_sock_drv.h  | 14 +++++++-------
 include/net/xsk_buff_pool.h |  2 +-
 net/xdp/xsk.c               |  4 ++--
 net/xdp/xsk_buff_pool.c     | 14 +++++++-------
 4 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/include/net/xdp_sock_drv.h b/include/net/xdp_sock_drv.h
index 360bc1244c6af..40085afd91607 100644
--- a/include/net/xdp_sock_drv.h
+++ b/include/net/xdp_sock_drv.h
@@ -126,8 +126,8 @@ static inline void xsk_buff_free(struct xdp_buff *xdp)
 	if (likely(!xdp_buff_has_frags(xdp)))
 		goto out;
 
-	list_for_each_entry_safe(pos, tmp, xskb_list, free_list_node) {
-		list_del(&pos->free_list_node);
+	list_for_each_entry_safe(pos, tmp, xskb_list, list_node) {
+		list_del(&pos->list_node);
 		xp_free(pos);
 	}
 
@@ -140,7 +140,7 @@ static inline void xsk_buff_add_frag(struct xdp_buff *xdp)
 {
 	struct xdp_buff_xsk *frag = container_of(xdp, struct xdp_buff_xsk, xdp);
 
-	list_add_tail(&frag->free_list_node, &frag->pool->xskb_list);
+	list_add_tail(&frag->list_node, &frag->pool->xskb_list);
 }
 
 static inline struct xdp_buff *xsk_buff_get_frag(struct xdp_buff *first)
@@ -150,9 +150,9 @@ static inline struct xdp_buff *xsk_buff_get_frag(struct xdp_buff *first)
 	struct xdp_buff_xsk *frag;
 
 	frag = list_first_entry_or_null(&xskb->pool->xskb_list,
-					struct xdp_buff_xsk, free_list_node);
+					struct xdp_buff_xsk, list_node);
 	if (frag) {
-		list_del(&frag->free_list_node);
+		list_del(&frag->list_node);
 		ret = &frag->xdp;
 	}
 
@@ -163,7 +163,7 @@ static inline void xsk_buff_del_tail(struct xdp_buff *tail)
 {
 	struct xdp_buff_xsk *xskb = container_of(tail, struct xdp_buff_xsk, xdp);
 
-	list_del(&xskb->free_list_node);
+	list_del(&xskb->list_node);
 }
 
 static inline struct xdp_buff *xsk_buff_get_tail(struct xdp_buff *first)
@@ -172,7 +172,7 @@ static inline struct xdp_buff *xsk_buff_get_tail(struct xdp_buff *first)
 	struct xdp_buff_xsk *frag;
 
 	frag = list_last_entry(&xskb->pool->xskb_list, struct xdp_buff_xsk,
-			       free_list_node);
+			       list_node);
 	return &frag->xdp;
 }
 
diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
index ff3ad172fffc1..e21062cf62294 100644
--- a/include/net/xsk_buff_pool.h
+++ b/include/net/xsk_buff_pool.h
@@ -29,7 +29,7 @@ struct xdp_buff_xsk {
 	dma_addr_t frame_dma;
 	struct xsk_buff_pool *pool;
 	u64 orig_addr;
-	struct list_head free_list_node;
+	struct list_head list_node;
 };
 
 #define XSK_CHECK_PRIV_TYPE(t) BUILD_BUG_ON(sizeof(t) > offsetofend(struct xdp_buff_xsk, cb))
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index c039db447d2e7..bbf45b68dbf5c 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -171,14 +171,14 @@ static int xsk_rcv_zc(struct xdp_sock *xs, struct xdp_buff *xdp, u32 len)
 		return 0;
 
 	xskb_list = &xskb->pool->xskb_list;
-	list_for_each_entry_safe(pos, tmp, xskb_list, free_list_node) {
+	list_for_each_entry_safe(pos, tmp, xskb_list, list_node) {
 		if (list_is_singular(xskb_list))
 			contd = 0;
 		len = pos->xdp.data_end - pos->xdp.data;
 		err = __xsk_rcv_zc(xs, pos, len, contd);
 		if (err)
 			goto err;
-		list_del(&pos->free_list_node);
+		list_del(&pos->list_node);
 	}
 
 	return 0;
diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index d1a9f4e9b685a..9db08365fcb00 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -102,7 +102,7 @@ struct xsk_buff_pool *xp_create_and_assign_umem(struct xdp_sock *xs,
 		xskb = &pool->heads[i];
 		xskb->pool = pool;
 		xskb->xdp.frame_sz = umem->chunk_size - umem->headroom;
-		INIT_LIST_HEAD(&xskb->free_list_node);
+		INIT_LIST_HEAD(&xskb->list_node);
 		if (pool->unaligned)
 			pool->free_heads[i] = xskb;
 		else
@@ -549,8 +549,8 @@ struct xdp_buff *xp_alloc(struct xsk_buff_pool *pool)
 	} else {
 		pool->free_list_cnt--;
 		xskb = list_first_entry(&pool->free_list, struct xdp_buff_xsk,
-					free_list_node);
-		list_del_init(&xskb->free_list_node);
+					list_node);
+		list_del_init(&xskb->list_node);
 	}
 
 	xskb->xdp.data = xskb->xdp.data_hard_start + XDP_PACKET_HEADROOM;
@@ -616,8 +616,8 @@ static u32 xp_alloc_reused(struct xsk_buff_pool *pool, struct xdp_buff **xdp, u3
 
 	i = nb_entries;
 	while (i--) {
-		xskb = list_first_entry(&pool->free_list, struct xdp_buff_xsk, free_list_node);
-		list_del_init(&xskb->free_list_node);
+		xskb = list_first_entry(&pool->free_list, struct xdp_buff_xsk, list_node);
+		list_del_init(&xskb->list_node);
 
 		*xdp = &xskb->xdp;
 		xdp++;
@@ -687,11 +687,11 @@ EXPORT_SYMBOL(xp_can_alloc);
 
 void xp_free(struct xdp_buff_xsk *xskb)
 {
-	if (!list_empty(&xskb->free_list_node))
+	if (!list_empty(&xskb->list_node))
 		return;
 
 	xskb->pool->free_list_cnt++;
-	list_add(&xskb->free_list_node, &xskb->pool->free_list);
+	list_add(&xskb->list_node, &xskb->pool->free_list);
 }
 EXPORT_SYMBOL(xp_free);
 
-- 
2.51.0




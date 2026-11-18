Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042313;
	b=OAVRttKwtdgQVWYZ9qP49H4FiDRgAEcHVC7hGrwEiPaGpj00fKQGHl9OdCD2uSO7HAkO
	 k1R9y4qBcXla3im+UyX/f9v6qgSPmfXTZqv/CGI8xJq2+7LOaVEMFXqaBDGD5Rrm/UvW2
	 VNkbj1gJ+eWyr7H3ylf6XZTEZFfcIVXGOiwlaa2jfiKh2j1pq8d9humL1EeXC1c+5KNEu
	 u0L6aYi/vyM+Gmbs6Bkt2C06snq3eSawZpXQIUAgebJLf3Pde9ZRIA2xl1VSpiPhtRSZH
	 pIV29xOQsIBlvb8asLaylfB8HxaVcJZ5QMHFTFA4TheqgQQZZmgEs+BznVl5inhgjLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042313;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/w8oq0uGQbwup8YnLXZO2S4FiO6hdXigFY8/XVF0x3s=;
	b=XaivjK90Qcn3jaCE+UCxgFHS+MnAFcCVzJjgrjgMxirtI1Ybqo61Vlz1VVzKee+UoW2P
	 Z23Okksn/cuJGtXbaOssQ+9RYBBHLDCN9pcRDHri3jlCMOYHrA8q1WyeL/0JvdQXwf342
	 N0Ask56bQGaviz+5O59TtfQePAoVlcNS5szLcUMxgjOzWb9OtzU5iilKaBdgJvKY5OWB4
	 41NFHC9NXyZ1tc24OpOU7Yxppy9aDvOMKNZaSlyFR5BKiJrd7bLiMRM7OV8qLuyDzS/kr
	 vCazR+1ywnW3X01eUPwF1gGBKAeJX9w0NNoNi5/bJg7AqxUWRwUIjlMSA42XucpcLSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IN+Kw+Le;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1302606A320;
	Wed, 18 Nov 2026 22:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IN+Kw+Le
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 061491F000C4;
	Wed, 18 Nov 2026 22:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042313;
	bh=/w8oq0uGQbwup8YnLXZO2S4FiO6hdXigFY8/XVF0x3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IN+Kw+LeVQM815PgnUhzI+VxXnhvabgrL6QL4+S7i2ihq9IyPkRetsnOwl4QX9BCu
	 GydlleRrVqNzVEU8fQJ8NemRJPSSSfO5Xb7gRN+svOfTRgbgNpDaMakFr7mgW91sVT
	 sDlZJNb7EREWyld7/hJj+NsFHMRT4iic8lGLKY3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianyi Gao <tianyi@cloudflare.com>,
	Mohsin Bashir <hmohsin@meta.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3127/3318] veth: schedule the peers NAPI after XDP_TX when only GRO is enabled
Date: Wed, 18 Nov 2026 16:02:29 +0100
Message-ID: <20261118150453.728230008@linuxfoundation.org>
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

From: Tianyi Gao <tianyi@cloudflare.com>

[ Upstream commit f16b8c6a656e62bfa7bb6a3b876f9ccdaf53bd43 ]

veth_xdp_xmit() queues XDP_TX frames on the peer's ring if the peer has
NAPI. A peer with GRO enabled and no XDP program also has NAPI.

veth_xdp_flush() then schedules the peer's NAPI, but only if the peer's
xdp_prog is set, so for such a peer the frames are never processed.
Nothing else schedules that NAPI by default.

Once the ring is full, every XDP_TX frame is dropped, and so are the
skbs that veth_xmit() queues on the same ring.

Commit 0e672f306a28 ("veth: check for NAPI instead of xdp_prog before
xmit of XDP frame") changed the check in veth_xdp_xmit() but not the one
in veth_xdp_flush(). Make veth_xdp_flush() check the napi pointer
instead of xdp_prog, as veth_xdp_xmit() does.

Fixes: 0e672f306a28 ("veth: check for NAPI instead of xdp_prog before xmit of XDP frame")
Signed-off-by: Tianyi Gao <tianyi@cloudflare.com>
Reviewed-by: Mohsin Bashir <hmohsin@meta.com>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Acked-by: Jesper Dangaard Brouer <hawk@kernel.org>
Link: https://patch.msgid.link/20261016214217.16942-2-tianyi@cloudflare.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/veth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 6766e1381650d..486eea7d060ec 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -585,7 +585,7 @@ static void veth_xdp_flush(struct veth_rq *rq, struct veth_xdp_tx_bq *bq)
 	rcv_priv = netdev_priv(rcv);
 	rcv_rq = &rcv_priv->rq[veth_select_rxq(rcv)];
 	/* xdp_ring is initialized on receive side? */
-	if (unlikely(!rcu_access_pointer(rcv_rq->xdp_prog)))
+	if (unlikely(!rcu_access_pointer(rcv_rq->napi)))
 		goto out;
 
 	__veth_xdp_flush(rcv_rq);
-- 
2.53.0




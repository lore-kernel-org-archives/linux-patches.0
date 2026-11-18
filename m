Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027730;
	b=I5t5bIDHvJmqvUD6wnZGiQwnxdSruOQiecl7paBDO6JY4e0uEr301cxYJxIXu+t8+3xS
	 tXp5Ef68CvfYwra/ffyw7NoqjM8LLoLxaxy3jxENT1DYMgoqL8P/UKFVroAGumyEw+GW1
	 GtGybX9JnybGW9pK/w3gWzfAD6OEA/FDIHe2gUWR+bdqQTXQf4zOMFFK1sOMjLyjujslQ
	 H4pZ7oXhTTTSoUP6gvbAPPJYheihnMu8cE9Znxtcoe1GMRGiRfDcS8u3Vg7hPBGa5jmA9
	 YsBKnKQUIATXniNQ6QOORDjajuGkDvX4XERoC/9u5D+T/DnAYnIypSFPRgp91c68JrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027730;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zOaKL5GrklABvOfi9LY9gba+AvMDgP4br63xUJK/dEQ=;
	b=aYqlBWh9LluD/oVbUqVG6BcD2avfe78rVSA3rYIr3YglbupOYn1WUDq0sXaqnnYnlUrU
	 YXH3Uxf/o4+HR631uuRExiCagR1LC4tjkp1NT+SeB+mRCooA3LhZAxFH2SlVgk46+QHWV
	 zhkvM0qrVKpqizZlV7jaSKo1mmh53m+y/XMl3vufbI+BG3dBkL3LsV0VuyK1E1EmnVNrQ
	 3TWiKWlU3QmosYWYSD3G3bWXcnxXbw10v5wPl6KgaiaRUMCrbW+TGbPXqxpVT9S/6fDGI
	 cmaz8uiz/qlNMHq61di9C1nKVozaogthT/DXDa7gZBrYrE+bhi5j4r22/67yjnYWuYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ivha4Llt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD71A606A334;
	Wed, 18 Nov 2026 18:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ivha4Llt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18A161F000C4;
	Wed, 18 Nov 2026 18:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027730;
	bh=zOaKL5GrklABvOfi9LY9gba+AvMDgP4br63xUJK/dEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ivha4Llts3ZQG4uICIKvpgq8AYPyGK3HM2dAg+dVgCiWvP+D1IEUk5kAbmApUAC2r
	 v2lPKFjzN5TyunPqVFuqrEy1Ddz9AhQgqmS+uR5p6CJabXOPyZO4IPnUM6Q8laO2pE
	 sgKc2wNwhKbEl7Jtk2dWPuvvUjXuOtXUjQHSKQtQ=
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
Subject: [PATCH 6.18 1893/2151] veth: schedule the peers NAPI after XDP_TX when only GRO is enabled
Date: Wed, 18 Nov 2026 16:00:28 +0100
Message-ID: <20261118150230.753124058@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index 971b7999082e2..39acd0ac76c9f 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -616,7 +616,7 @@ static void veth_xdp_flush(struct veth_rq *rq, struct veth_xdp_tx_bq *bq)
 	rcv_priv = netdev_priv(rcv);
 	rcv_rq = &rcv_priv->rq[veth_select_rxq(rcv)];
 	/* xdp_ring is initialized on receive side? */
-	if (unlikely(!rcu_access_pointer(rcv_rq->xdp_prog)))
+	if (unlikely(!rcu_access_pointer(rcv_rq->napi)))
 		goto out;
 
 	__veth_xdp_flush(rcv_rq);
-- 
2.53.0




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624689;
	b=JF9mkmj9YAXZMP+LzeV6ZjRcCbyPM+Q3QALaDSwaK1pXdE/szMGkV2qUwxTn0tj2HoRB
	 pxJgHHqrdNVYk6VyAVWAaS0NwCDeziyIZil5ReOH7pi9u1jkZuK7Bb7HaHAUFoziM5YGZ
	 Fwl04LCfXw7THkIerIdcpoAuHj7kwZ4qu/jPqFNAmVFvEc+OWpYOe+uJl08X7Xo9QprZD
	 A6+k33HAhRSvRgJIJ+Y2vntS12n1KybT8eekbiM6Zv+e7WT3F2Pdj4aQUInckio9z/kGZ
	 iYglllgAUGnZxWHKqJ/AvSg1vZCSm5WG//NRDDS7m9gL2H1yRwQCNY7pe2xCxi0TRXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624689;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=daaFhcHY0gYMWXbVQwKzXolVg0lKBLtAubn6Vi01rZA=;
	b=XJvd7DHCN/WKa5Vk/+scgmvy8i6ZVLE1U6hae5E/Mn5cR3eqHCtyRlO1B6XqlS+81xRQ
	 im5FBunAMyPs0vRyZjJxZ5Fscs/w/7mnvQLsvmlTP5Cyq7v7lpQ0p3rjXigoi+F0sWgNm
	 2EBO/8FUaX8zd7i2eT6hXOJ4c9Xn+xw/NK74S9p+746cG19FAul9mxjooTUfjORxL81po
	 kHRrEy7XNQ5kznqbnKCfvEPtzHGjr5xoVtP67Rz47zmWwQu8sdChQigLGzXj5HJZOPE1q
	 tWYj8VgBWJVa0PWSzBNP92SEJYrT5YvzqFOKVcR1xGFSvNCjNAYCHdKpl27QS1WC+VQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P0IOKqZs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94D09606A33E;
	Wed, 25 Nov 2026 16:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P0IOKqZs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE4741F000C0;
	Wed, 25 Nov 2026 16:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624689;
	bh=daaFhcHY0gYMWXbVQwKzXolVg0lKBLtAubn6Vi01rZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P0IOKqZsemE201EuG313hsMZnNIA99PyDlAb1ucIFTJzZlVE8kC5nDdsXIaeZ1aOr
	 s6WJlXPVTvsnBJBtz+TM5TkbU2mxdKpXCkh2oMyKfc3dZI0RI58wKp6TWYXMghe4wq
	 3aoqMrE+cV3OSAiYWnq8DTxD4WUD9nB5Lm8Mv4HI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
	Daniel Machon <daniel.machon@microchip.com>,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 230/816] net: stmmac: set XDP metadata length on the page_pool RX path
Date: Wed, 25 Nov 2026 15:29:38 +0100
Message-ID: <20261125143854.531926940@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>

[ Upstream commit 6d9b7c85af57305ec2bd5907124478867edcc60b ]

stmmac_rx() initializes the XDP buffer with the metadata area valid, so
an XDP program can reserve metadata with bpf_xdp_adjust_meta() and write
it in [xdp->data_meta, xdp->data), for example to export the RX hardware
timestamp obtained from the metadata kfunc. When such a frame is passed
to the stack, the skb is built in place around the same page with
napi_build_skb(), but skb_metadata_set() is never called.

napi_build_skb() clears skb_shared_info up to dataref, which includes
meta_len, so skb_metadata_len() stays zero. The stack and TC BPF then see
an empty metadata range even though the bytes are present in the skb
headroom. The AF_XDP zero-copy path already records the length in
stmmac_construct_skb_zc().

Record the metadata length after reserving the headroom and adding the
frame data. No copy is needed because the skb is built over the buffer the
XDP program wrote to. With the length recorded, the software VLAN
stripping path can move the metadata together with the MAC header, as it
already does for zero-copy frames.

Fixes: e3f9c3e34840 ("net: stmmac: add Rx HWTS metadata to XDP receive pkt")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
Reviewed-by: Nicolai Buchwitz <nb@tipi-net.de>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20261102-stmmac_meatada_pp_path-v1-1-d93cc4f9a864@oss.qualcomm.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 818722d5dbcba..16eec53ee9222 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5700,7 +5700,7 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 		}
 
 		if (!skb) {
-			unsigned int head_pad_len;
+			unsigned int metasize;
 
 			/* XDP program may expand or reduce tail */
 			buf1_len = ctx.xdp.data_end - ctx.xdp.data;
@@ -5716,10 +5716,14 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 			}
 
 			/* XDP program may adjust header */
-			head_pad_len = ctx.xdp.data - ctx.xdp.data_hard_start;
-			skb_reserve(skb, head_pad_len);
+			skb_reserve(skb,
+				    ctx.xdp.data - ctx.xdp.data_hard_start);
 			skb_put(skb, buf1_len);
 			skb_mark_for_recycle(skb);
+
+			metasize = ctx.xdp.data - ctx.xdp.data_meta;
+			if (metasize)
+				skb_metadata_set(skb, metasize);
 			buf->page = NULL;
 		} else if (buf1_len) {
 			dma_sync_single_for_cpu(priv->device, buf->addr,
-- 
2.53.0




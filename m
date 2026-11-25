Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618625;
	b=0N869yjEmlx761n3VbW2FArii1LgZBCmgsM8j6C7Gp0B6HOzMn9cGHjqnM81qVh0VVU+
	 +ANdWJOkp/U3ec9pfwVeBP8oqAUXhmCmhPbtENgCoO+B7OvH7ep8XhU3+e9waYy8hojkD
	 9kJHmgHUHekEMO48lXS78wGc6slSuFMhDV/LyJovWJ8AhzPazGPhKxmgYXrlkYe/MkVge
	 7lyMZsgx/pdv5ODlChxc4ZR6d9+Q6T53ZFCywwa6RhpT+HsONCktMsoOVd1/XzCR5qp2+
	 p/H6s0H7C1yfBZkmIZf0I6budQH5MFUetEmBC5wro9hcLQ2PUoqQ6Il6Dd4bbsK2mxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618625;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fr4fvBrHkUYOmryKrYimI8Rw1U+wSyYwGethpSz0Rxk=;
	b=3Nb3zbfF/JLpPYirSk8aOW1jNb3ELKEvPKSkapu0H5jUClbMPVrycx3BP6dZgqdjC6lA
	 dZQwAO5fOGtq7cMjdZgqUe/z+WidHnAOYfkAsT494KANZ7TrWX6F6LwDu/OKQzlcsbUmp
	 Zp/IcLk3cJb+7Wy8vfNkGZwnLRA//4+3bADCz9NGsVMW3AlpOPSoq9saBheIj3Playbay
	 1jnblpPgBT7Kn6JDkq1R7uJ6rKc4pw85k2VUIBRzYnNQHNcboAAp0jeT2ZNDjJ/pffv+4
	 seoX92Q2arhsQCwOG1ydNrmaXtlh1erj7uSLH8j6qyb7amiqN+6jh/ky05ofqFblaUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C7l4dqT7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 767A2606A323;
	Wed, 25 Nov 2026 14:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C7l4dqT7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 418D91F000C6;
	Wed, 25 Nov 2026 14:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618624;
	bh=fr4fvBrHkUYOmryKrYimI8Rw1U+wSyYwGethpSz0Rxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C7l4dqT7BZpsiDNQvS8ArE75sHK79sVIO8sTYsfsNMBiDJvGgB2wgtKDcNU7b33Tu
	 bJfbwRyXLOe9qMn1PL482sMWvGQ4gfvxFZGG4u2OBuOmb2kdea55F2nrcsMBbaXwjC
	 mPwT/ew0W3B+AM5cE3UPvRLl/VTVeuPNt6lAfEDI=
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
Subject: [PATCH 7.3 0311/1005] net: stmmac: set XDP metadata length on the page_pool RX path
Date: Wed, 25 Nov 2026 15:27:29 +0100
Message-ID: <20261125143829.022334763@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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
index bd495ab5cd260..9ff7aecefca22 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5960,7 +5960,7 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 		}
 
 		if (!skb) {
-			unsigned int head_pad_len;
+			unsigned int metasize;
 
 			/* XDP program may expand or reduce tail */
 			buf1_len = ctx.xdp.data_end - ctx.xdp.data;
@@ -5977,10 +5977,14 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
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




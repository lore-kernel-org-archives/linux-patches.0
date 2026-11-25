Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621616;
	b=lRZbCcuJSanxFxGnJwgHZBKc03WHZbyi1dBKqoIK6dVXqV7IXTNg6rBfqHLMJS9QZtsk
	 bZIdyKA7lQtgIIJlrGGcMJMI2UY7RksfTF4UDiVapJTDNvHcbHn0AQqWaJcSswRLmiPFW
	 jpfJp+PzIHRsvXHjuBBfxj8z8GHduS0YSBxAJ/owpYefJtpo6TTBcD7E+17bhdWnC99W2
	 Sg/z1WWmwQsmvJzCv9Hu6FX2Ncwtkw/bWAFvrCEZtygVMIypEcTOA1sfAg3dTaXgPDVhI
	 vT9BXC3d6kWin1cW6nmiHgMgP0zgHDoSNj44MRw95oYd1Rpz5hJ2yz5rGRWyl2AuL2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621616;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mUDmoiR0t+YFPXy72xxsgWJmfBYAw1oGQX1+FooAC+k=;
	b=yHM7sGJ9G2fEaGEKn45T2eWjhDUtCGc0IHCq/JYrsU2/y4O4ZjKDSXT7W1phBDEAI5sr
	 vhPN0CYiL1a3vceLUH9ioOmHX1D0fzY7zISoQzuWMQOU+Z1RDWg/5nMno4ET4znQMHnA7
	 xH/pwNAmDet2V6rtyblLFEjXKmcNVDv7gU1F5eIe2MSpoeeQ2hgwrx2cBJB0aydlE8npw
	 E+zt3pu4LUCY3stfBFKRuRZX84LN4UT4hyAL78tRv3+oZMeq0A3vJGkTZkF2K85JeE9BR
	 4KoG6h4VBNgJM+W4GthMCNRV4TZayQuYYaXb8G4rbWqY/tns4a5pe7aoIKbNqra/HvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j78CJDTp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE3E1606A68E;
	Wed, 25 Nov 2026 15:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j78CJDTp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 835C91F000D3;
	Wed, 25 Nov 2026 15:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621616;
	bh=mUDmoiR0t+YFPXy72xxsgWJmfBYAw1oGQX1+FooAC+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j78CJDTprnDth3UU7yWGXPevTAfgcusGZe30XT98GW9Xt0exHf/gBx5a9T0Onbjbv
	 T6t6wdXD//ZrZaRWWApeTM2c84iSc09kfkHbNak1WdpcDr98mY8fK+bwvDCwhUukAS
	 7GSTGD6/g1edmxz35CDp8QTt0grNsMwEYvU9Npno=
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
Subject: [PATCH 6.18 282/990] net: stmmac: set XDP metadata length on the page_pool RX path
Date: Wed, 25 Nov 2026 15:27:29 +0100
Message-ID: <20261125143828.689382503@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
index 2e7b146895ba8..0e78c1d2fcf1d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5731,7 +5731,7 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 		}
 
 		if (!skb) {
-			unsigned int head_pad_len;
+			unsigned int metasize;
 
 			/* XDP program may expand or reduce tail */
 			buf1_len = ctx.xdp.data_end - ctx.xdp.data;
@@ -5748,10 +5748,14 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
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




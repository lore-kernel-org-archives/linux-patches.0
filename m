Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042737;
	b=xpTtxv77IwbKflXSN0tzO59H0sBiIxcgbBnXUWBALefWLecvZ975Ylc2KUtV6LzSVYuc
	 bmojmSsT2WLyAqSdberWLk2o3YFlvoFOr619DYqDDuPs5hDjeLAFLZKitwAss4qrf1OBr
	 NeDHVrblAin7D48Q0anw4QPAcpNCU37b4cyb1OXCLYwaNrH/fDJVxg644pYrtiFruFz3R
	 +a6wDCquBm2Jo6RjE6vhisLJfaFurk1jJd+uo0T/EjrdMeE/AooZ/a4GX+qtbvhPXe3ep
	 5OsqqB5wds+s5gF57iVUTK8J2cC+gvd8/+l35GRV11W78/S4Rvd2bOkvJeWxIpRAhlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042737;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PJ+jEchdXnEk5dmjcXmrdclQ5s7PLz8GwPaCgrVzfX0=;
	b=aVNdpaFy08q5AWtgQrYjzBQbkwi+PDcAEQqJfplpxK/A2D7qCiKxGGJd7Rv51AE7yyRK
	 s2ZDIFAz2ExxkQEnUVd8DM2JLSRVfHe5MdI+4E1xdxR0453pWY4ILpRxqsoj+WQfTTecD
	 C0zYOtzaEYwrmkmLkcNmiUDuAzCSkR1YllTXZdY16g8gQUDWabxpTpYOXDxG+LGoDedxO
	 YlWNxMu73Ggna4Ugayaxcj8UWUL0mCAzB0fvcCAZZO4XUacv6OFSFFtpeR/IMhgNfNYmD
	 A3xIJoC0HVw1ISez7yXgBEDDWRzyeeJJN2Ej4tsEPCrQpCsMZpoi9Mdy+JLFytH8Tug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0iRj8WKR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB805606A31C;
	Wed, 18 Nov 2026 22:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0iRj8WKR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D4581F000C4;
	Wed, 18 Nov 2026 22:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042737;
	bh=PJ+jEchdXnEk5dmjcXmrdclQ5s7PLz8GwPaCgrVzfX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0iRj8WKR8jBU6wxhSr5aVRRHulmNlUR1AbSgH4e98Axu3z2k+xRrk38XdiUXPtVKy
	 3qr1wc3EOIOUvjtv8kp0sTp+9AWPwifqB6iulvwqjqsRrAKPupgUQsu+HUa7Y4O7Eb
	 31xjG5zVf4MpapbIzRKrSRbs2izGH64abLm3JYis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Somnath Kotur <somnath.kotur@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3276/3318] bnxt_en: Add XDP Metadata support
Date: Wed, 18 Nov 2026 16:04:58 +0100
Message-ID: <20261118150457.894376819@linuxfoundation.org>
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

From: Somnath Kotur <somnath.kotur@broadcom.com>

[ Upstream commit 0ae1fafc8be6d4271a8ad66b4695e123a4e8cef1 ]

- Change the last arg to xdp_prepare_buff to true from false.
- Ensure that when XDP_PASS is returned the xdp->data_meta area
is copied to the skb->data area. Account for the meta data
size on skb allocation and do a pull after to move it to the
"reserved" zone.

Signed-off-by: Somnath Kotur <somnath.kotur@broadcom.com>
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jesper Dangaard Brouer <hawk@kernel.org>
Cc: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Link: https://lore.kernel.org/r/20240402093753.331120-6-pavan.chebbi@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 364b88b54fc2 ("eth: bnxt: hand XDP frags over to the copybreak skb")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 44 +++++++++++++++++--
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c |  2 +-
 2 files changed, 41 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index cf329bdfa1caf..98ae70fcf8888 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -1211,9 +1211,9 @@ static int bnxt_agg_bufs_valid(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
 	return RX_AGG_CMP_VALID(agg, *raw_cons);
 }
 
-static inline struct sk_buff *bnxt_copy_skb(struct bnxt_napi *bnapi, u8 *data,
-					    unsigned int len,
-					    dma_addr_t mapping)
+static struct sk_buff *bnxt_copy_data(struct bnxt_napi *bnapi, u8 *data,
+				      unsigned int len,
+				      dma_addr_t mapping)
 {
 	struct bnxt *bp = bnapi->bp;
 	struct pci_dev *pdev = bp->pdev;
@@ -1233,6 +1233,39 @@ static inline struct sk_buff *bnxt_copy_skb(struct bnxt_napi *bnapi, u8 *data,
 				   bp->rx_dir);
 
 	skb_put(skb, len);
+
+	return skb;
+}
+
+static struct sk_buff *bnxt_copy_skb(struct bnxt_napi *bnapi, u8 *data,
+				     unsigned int len,
+				     dma_addr_t mapping)
+{
+	return bnxt_copy_data(bnapi, data, len, mapping);
+}
+
+static struct sk_buff *bnxt_copy_xdp(struct bnxt_napi *bnapi,
+				     struct xdp_buff *xdp,
+				     unsigned int len,
+				     dma_addr_t mapping)
+{
+	unsigned int metasize = 0;
+	u8 *data = xdp->data;
+	struct sk_buff *skb;
+
+	len = xdp->data_end - xdp->data_meta;
+	metasize = xdp->data - xdp->data_meta;
+	data = xdp->data_meta;
+
+	skb = bnxt_copy_data(bnapi, data, len, mapping);
+	if (!skb)
+		return skb;
+
+	if (metasize) {
+		skb_metadata_set(skb, metasize);
+		__skb_pull(skb, metasize);
+	}
+
 	return skb;
 }
 
@@ -1947,7 +1980,10 @@ static int bnxt_rx_pkt(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
 	}
 
 	if (len <= bp->rx_copy_thresh) {
-		skb = bnxt_copy_skb(bnapi, data_ptr, len, dma_addr);
+		if (!xdp_active)
+			skb = bnxt_copy_skb(bnapi, data_ptr, len, dma_addr);
+		else
+			skb = bnxt_copy_xdp(bnapi, &xdp, len, dma_addr);
 		bnxt_reuse_rx_data(rxr, cons, data);
 		if (!skb) {
 			if (agg_bufs) {
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
index cc80e48477acb..ba4986a834249 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
@@ -197,7 +197,7 @@ void bnxt_xdp_buff_init(struct bnxt *bp, struct bnxt_rx_ring_info *rxr,
 	dma_sync_single_for_cpu(&pdev->dev, mapping + offset, len, bp->rx_dir);
 
 	xdp_init_buff(xdp, buflen, &rxr->xdp_rxq);
-	xdp_prepare_buff(xdp, data_ptr - offset, offset, len, false);
+	xdp_prepare_buff(xdp, data_ptr - offset, offset, len, true);
 }
 
 void bnxt_xdp_buff_frags_free(struct bnxt_rx_ring_info *rxr,
-- 
2.53.0




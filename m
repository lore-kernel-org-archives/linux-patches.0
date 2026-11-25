Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618000;
	b=C+EN0JV/CpAmCpjdoqDBEiUZMY0Rh3LRujRuwqYw0wSKrQvl0cNxPato6N9cJiTpY5Lu
	 A6VkRaH1TK5JZedfyQgUmeocnb2FOjR0M/43BKJoKuiNpicbgoxBQUxZwtigg7inN+uIq
	 +Vo/5Dd1cFgus3SGLBzGZm03Dg/NSNsSa2CFsTBgZjVLPgZoQMsiifRyhg9iQaknsmPrx
	 L0kiWomKXwP7heZVZ1tgvYswK25P+wmbQfXTmElYBHf6b7GOxYWXAvxiK14ycmQu0rgdz
	 HZMhU7aHuwHFJN8XeBCjBVCXEJ5i461cmpVxjUncEYml+3LY6oY7nvAdpY2HGKRO6WQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618000;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uiUB9Ce4fCrQU9CaLPSNKXUE3ksxtKbzKcp+QgGsah0=;
	b=lHN29VM6DBVMRp5snFpoO8j/IR/Oe52Idsf3631FdqgNyEMD01nz0ya+wLzNXkRXKfIz
	 NzWIPxoy3i20HM1ZQPzAdXAvfP/v7ChfcbaZ6oqjVtA35Vjh922L+3KRMhjII2ozutrWe
	 9MiBncT2FlOwecByKx64fIReshdcHsH7CNTQ+Iw/qHtIyvQbsTvwTNL9ikpJrjzgYJheS
	 oEj3Dmol6dBpcqPChOkcKT/byDKgZUhiSBRaHjrCDW30x1gyLtdzTc8odznEvfDOI6V4k
	 pglCB7dFNHujNx195f13q6Ov3aWf/7GVdlMxMYy6RWfPhxyYxNJPBpT/U7vJPJEfzGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="L/uDypw+";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21770606A32D;
	Wed, 25 Nov 2026 14:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L/uDypw+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72C701F000CF;
	Wed, 25 Nov 2026 14:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618000;
	bh=uiUB9Ce4fCrQU9CaLPSNKXUE3ksxtKbzKcp+QgGsah0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L/uDypw+JkamRi0kvQ2zUDVseGYf1TecmoMpA0L407leu/ZOpn3c927i6H47+Vmu6
	 6407cudfXHbDdGc69PXP0uXYT0L8E0OC/fPUCyovocRnDcYGa1yvM13sEqZySpfEmh
	 SI+D9RRknrilHU2R3C/PJbUeyS0GrmuQ3lhDNFFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0141/1005] net: stmmac: fix XDP RX buffer DMA sync length
Date: Wed, 25 Nov 2026 15:24:39 +0100
Message-ID: <20261125143825.042884579@linuxfoundation.org>
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

[ Upstream commit 363ff816277d4c7064514b160e655bed1dfb3ed8 ]

stmmac_rx() bounded the DMA sync length by the largest data_end seen
before and after the XDP program and passed it to page_pool_put_page()
on the XDP_CONSUMED path. bpf_xdp_adjust_tail() zeroes the grown area,
which dirties the CPU cache, but a later negative adjust only moves
data_end back. If the program grows and then shrinks the tail, both
endpoints miss the zeroed range, so those dirty cache lines are not
written back before the page is reused.

The length was also wrong since commit 88095728511e ("net: stmmac: fix
rx Scatter-Gather support") moved the page_pool DMA window to offset 0
and set max_len to dma_buf_sz + page_offset: the driver still
subtracted buf->page_offset, so it synced [base, data_end - page_offset)
instead of [base, data_end).

On a non-coherent platform those dirty lines can be evicted after the
device has DMA'd the next frame into the recycled page and corrupt it.

Sync the whole page_pool DMA window on the XDP_CONSUMED path with
page_pool_recycle_direct(), as the PASS path and page_pool allocation
already do. The device only writes [page_offset, page_offset +
dma_buf_sz), so syncing [base, base + max_len) covers every cache line
it can touch, regardless of how the program adjusted the packet.

Fixes: be8b38a722e6 ("net: stmmac: Add support for XDP_TX action")
Fixes: 88095728511e ("net: stmmac: fix rx Scatter-Gather support")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Link: https://patch.msgid.link/20261027-stmmac-xdp-fixes-v2-6-10eae8a093a8@oss.qualcomm.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c   | 17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 896ec37961a94..7149b14bdad48 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5877,8 +5877,6 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 			len -= ETH_FCS_LEN;
 
 		if (!skb) {
-			unsigned int pre_len, sync_len;
-
 			/* Each frame starts here: reset the FCS handling */
 			fcs_stripped = false;
 
@@ -5896,29 +5894,18 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 			xdp_prepare_buff(&ctx.xdp, page_address(buf->page),
 					 buf->page_offset, buf1_len, true);
 
-			pre_len = ctx.xdp.data_end - ctx.xdp.data_hard_start -
-				  buf->page_offset;
-
 			ctx.priv = priv;
 			ctx.desc = p;
 			ctx.ndesc = np;
 
 			skb = stmmac_xdp_run_prog(priv, &ctx.xdp);
-			/* Due xdp_adjust_tail: DMA sync for_device
-			 * cover max len CPU touch
-			 */
-			sync_len = ctx.xdp.data_end - ctx.xdp.data_hard_start -
-				   buf->page_offset;
-			sync_len = max(sync_len, pre_len);
-
 			/* For Not XDP_PASS verdict */
 			if (IS_ERR(skb)) {
 				unsigned int xdp_res = -PTR_ERR(skb);
 
 				if (xdp_res & STMMAC_XDP_CONSUMED) {
-					page_pool_put_page(rx_q->page_pool,
-							   virt_to_head_page(ctx.xdp.data),
-							   sync_len, true);
+					page_pool_recycle_direct(rx_q->page_pool,
+								 virt_to_head_page(ctx.xdp.data));
 					buf->page = NULL;
 					rx_dropped++;
 					goto next;
-- 
2.53.0




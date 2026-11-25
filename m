Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617987;
	b=ik/g3ZuJZqpC0ad185PwaG3vwiOJ6VD0hsoF8VkZxizpZlrIjYYKaiy5U47WjziLqQJn
	 GztPWUmpqoNeszjqn8KLzgAIKn+RF4uwhXUzsGGMJOw+Rq6d9Ry0VJMuc594vZfzQ++CQ
	 yVrXtaCEqMhjy/F17hGO0KryOBbi7frGUTTVLTbr5brR24Jk0lLXkErD8+yxsYDMks2kY
	 BaoL+ZcTzZDRxhiUN5ufHPEXqUpX4d8Tvo8tBts0dUymy0vgU4MclMpcgx+czajE7bknB
	 0NsTeAqA8EFI1WRFIY4LXX88LFE4v9alGLhYMtrjjfY3R7QjvmqzQwmt6epiaKW8qAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617987;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=diD/VGIwl6YDUR8QLdxmCarejajYrziqrzQ2y65jC7k=;
	b=CMynnFFzNp5UyBxU4A850qqb7BXF1tIQVsrvbpxCqR3a+dlZ2wtnX5e1t/GXWUr1/kXp
	 X8S8sa0FFNt2iS9nSgDzwfUONHcb02ISwyjpuJyz2CzoN075t4WYCL5aNZpamQz5pOyDa
	 HUwa6hrPt/UniqMhbmLQ2QsgHd9D6Ps7wX5vOhSeqwfH/4w0X83+JwQujTM1u80lhWSpj
	 88eBMSo8PXI8oAF+2q0YmZdhmB/5pUwAvyW2TkwRtJojNK2/j1dfhrjBWInsWVIUscbOJ
	 ZpaP9KOvw6tq4YdVoFlNA3Owkr9GDUyXGJznr/veBlp028EB8Oi7fNpQRnujLaj68sA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1iyRmiow;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E310606A321;
	Wed, 25 Nov 2026 14:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1iyRmiow
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20B051F000D0;
	Wed, 25 Nov 2026 14:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617986;
	bh=diD/VGIwl6YDUR8QLdxmCarejajYrziqrzQ2y65jC7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1iyRmiow2ImOtP1aY5vySI5auy3xXaLFKTrdkphHTRUSvVCiwh03VZroagVHH0WG7
	 0iJYJE3RUjnw5AYRcLVmQlAqAdBfaMEBsCTR2pTIZlO6AMkNJO0m4pYXMP6IdNdDMb
	 E1Dog6vl+Bxb5+MeXKqSx6J/ikzB3Y9lgJTlpT2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0137/1005] net: stmmac: drop split frames on AF_XDP zero-copy RX
Date: Wed, 25 Nov 2026 15:24:35 +0100
Message-ID: <20261125143824.948579154@linuxfoundation.org>
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

[ Upstream commit 834ec95308320cbd8c162d86788ab95cc3fd6bf8 ]

stmmac_rx_zc() assumes a 1:1 mapping between a received frame and an
XSK pool buffer and drops any frame that spans more than one RX
descriptor:

        /* XSK pool expects RX frame 1:1 mapped to XSK buffer */
        if (likely(status & rx_not_ls)) {
                xsk_buff_free(buf->xdp);
                buf->xdp = NULL;
                dirty++;
                count++;
                goto read_again;
        }

The non-last descriptors are freed and dropped, but the frame is not
marked as errored. When the poll reaches the last descriptor of the
same frame, error is still 0, so the fragment is handled as a complete
frame: it is passed to the XDP program, copied into an skb on XDP_PASS,
or converted for XDP_TX. The tail starts in the middle of the original
payload at a predictable offset and, parsed as a fresh frame (len == 0),
stmmac_rx_buf1_len() reports the full dma_buf_sz length for it even
though the DMA engine only wrote the tail remainder into that buffer, so
the reads extend past the received bytes and can reach beyond the end of
the XSK pool buffer. GMAC4 always enables jumbo frames (GMAC_CONFIG_JE
in GMAC_CORE_INIT), so an on-link peer can trigger such a split even
when the interface MTU is left at 1500.

Set error when the 1:1 mapping check drops a descriptor, so the
remaining descriptors of the frame - including the last one - are
drained and released with xsk_buff_free() instead of being processed as
a new frame. Account every freed buffer with dirty and count the
dropped frame once in the poll budget / rx_pkt_n. The direct 1:1
mapping drop also increments rx_dropped.

Use a bit test instead of an equality test for discard_frame.
Commit 644b8437ccef9e ("net: stmmac: dwmac4: report Rx checksum errors
in status") made dwmac4_wrback_get_rx_status() set discard_frame on
RDES3_ERROR_SUMMARY and OR in csum_none on RDES1_IP_HDR_ERROR or
RDES1_IP_PAYLOAD_ERROR, so it can return discard_frame | csum_none.
The old "status == discard_frame" test missed that value and delivered
frames with CRC, overflow, watchdog or giant errors to the stack in
stmmac_rx() - or to XDP/XSK in stmmac_rx_zc() - when they also failed
the IP checksum. The change therefore affects the regular RX path, not
only zero-copy. The bit test is also required for the
discard_frame | rx_not_ls value returned for non-last legacy
descriptors below.

Normalize the legacy normal and enhanced descriptor callbacks to report
rx_not_ls together with discard_frame for non-last descriptors. This
allows both stmmac_rx_zc() and stmmac_rx() to drain split frames on
dwmac100 and dwmac1000 instead of reparsing the final fragment as a new
packet.

Fixes: bba2556efad6 ("net: stmmac: Enable RX via AF_XDP zero-copy")
Fixes: 644b8437ccef9e ("net: stmmac: dwmac4: report Rx checksum errors in status")
Reviewed-by: Nicolai Buchwitz <nb@tipi-net.de>
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Link: https://patch.msgid.link/20261027-stmmac-xdp-fixes-v2-2-10eae8a093a8@oss.qualcomm.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/stmicro/stmmac/enh_desc.c    |  2 +-
 .../net/ethernet/stmicro/stmmac/norm_desc.c   |  2 +-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 21 ++++++++++++-------
 3 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/enh_desc.c b/drivers/net/ethernet/stmicro/stmmac/enh_desc.c
index 023b54b72478f..7ece8d4157a86 100644
--- a/drivers/net/ethernet/stmicro/stmmac/enh_desc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/enh_desc.c
@@ -205,7 +205,7 @@ static int enh_desc_get_rx_status(struct stmmac_extra_stats *x,
 
 	if (unlikely(!(rdes0 & RDES0_LAST_DESCRIPTOR))) {
 		x->rx_length++;
-		return discard_frame;
+		return discard_frame | rx_not_ls;
 	}
 
 	if (unlikely(rdes0 & RDES0_ERROR_SUMMARY)) {
diff --git a/drivers/net/ethernet/stmicro/stmmac/norm_desc.c b/drivers/net/ethernet/stmicro/stmmac/norm_desc.c
index c4b613564f87c..d19bf7ca4db38 100644
--- a/drivers/net/ethernet/stmicro/stmmac/norm_desc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/norm_desc.c
@@ -70,7 +70,7 @@ static int ndesc_get_rx_status(struct stmmac_extra_stats *x,
 
 	if (unlikely(!(rdes0 & RDES0_LAST_DESCRIPTOR))) {
 		x->rx_length++;
-		return discard_frame;
+		return discard_frame | rx_not_ls;
 	}
 
 	if (unlikely(rdes0 & RDES0_ERROR_SUMMARY)) {
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index c637305fdb36d..0d5215860b6d5 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5621,18 +5621,21 @@ static int stmmac_rx_zc(struct stmmac_priv *priv, int limit, u32 queue)
 							   &rx_q->dma_erx[entry],
 							   status);
 		}
-		if (unlikely(status == discard_frame)) {
-			xsk_buff_free(buf->xdp);
-			buf->xdp = NULL;
-			dirty++;
+
+		if (unlikely(!error && (status & discard_frame))) {
 			error = 1;
 			if (!priv->hwts_rx_en)
 				rx_errors++;
 		}
 
-		if (unlikely(error && (status & rx_not_ls)))
-			goto read_again;
 		if (unlikely(error)) {
+			xsk_buff_free(buf->xdp);
+			buf->xdp = NULL;
+			dirty++;
+
+			if (status & rx_not_ls)
+				goto read_again;
+
 			count++;
 			continue;
 		}
@@ -5641,8 +5644,9 @@ static int stmmac_rx_zc(struct stmmac_priv *priv, int limit, u32 queue)
 		if (likely(status & rx_not_ls)) {
 			xsk_buff_free(buf->xdp);
 			buf->xdp = NULL;
+			rx_dropped++;
+			error = 1;
 			dirty++;
-			count++;
 			goto read_again;
 		}
 
@@ -5814,7 +5818,8 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 							   &rx_q->dma_erx[entry],
 							   status);
 		}
-		if (unlikely(status == discard_frame)) {
+
+		if (unlikely(status & discard_frame)) {
 			page_pool_put_page(rx_q->page_pool, buf->page, 0, true);
 			buf->page = NULL;
 			error = 1;
-- 
2.53.0




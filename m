Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619163;
	b=1anyCzfZI3wOg5bNdyRClj7tGHjvz7pHmZJ5HnGTNl3XOz/i5tIzdwlWCTIteF9uR9k/
	 gaINq5wkyES4+0dcq3vdgBtkecsJcSPeXvlyybrcN6ztanyKjzBZX6mfrStGQ5oB6EiMR
	 8f1IVCswEVlexehtRaMEUmwjp3MSRXrZ2Fw2C5Yw6GF8JBNbpJbprAbcOje9BwqI5mBjO
	 dRvMhH0xTrj5QD3KQKL0apZxtV6JFL89RwQ/DHgCvsXP6Rl/IV1ENgsi7/tz3LNRMsgpV
	 xaN9NaRpUDTc6KcPcDaGMswEePTQf5grUYB8E/p1dJvPJ69b9XBAABT7ZRmgEPb+2kQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619163;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s7zoBy1QG12b1MydvVLpmxkG9KHncOSuwS7DeS6G4Dg=;
	b=TdLqGXnA8DiT1AgRkAwTbqXneeWZvsRDQWs1FfZa97zmRX65dYhJTGVBvFsMxt1913JT
	 iuayhQ4lHQR9zs5/FQhOq03u3J7W0YfyCA+T4kROwe1gxRrjiXWA7fQ7+ik954RGlzZhU
	 B/qrMYhuznvbm4vvBFkQpY8IApksuFHKdlZTQXVL8nvGJn/tJOu3gTJd87CA6LedWqxpO
	 4LGDt9IDJsX2krWFOqii+WHmMGTny8tUd6RmXgsQBjcWRBSvbi//yRUKAtqnxKodjr3ge
	 UfqPglrY9M8w4EP/X7ur2ulw5WeS407CrzoLRRaykextlqPzX8RPDl29ydxtlGx8Tww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="mztP/8Xc";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EE7C606A31E;
	Wed, 25 Nov 2026 15:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mztP/8Xc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98BC21F000CF;
	Wed, 25 Nov 2026 15:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619163;
	bh=s7zoBy1QG12b1MydvVLpmxkG9KHncOSuwS7DeS6G4Dg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mztP/8Xce97FT7bvYX01ufqT21wyneFAU2thZnTC7dIFbrbMfS6suK8sODQ7yfyUq
	 7li1mGEWbIK2OPa/F1aA6wVkAvsYhtwUMTDOlbtBMaJ9y912s12HEIXuncD+s3fCxQ
	 /LQLCuPb2urM80/6hYeKWZbVb10sTJbuod8Gfw60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anandu Padinhare <Anandu.Padinhare@electrifex.com>,
	Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0511/1005] net: stmmac: count XDP_PASS frames in rx_packets on the XSK zero-copy path
Date: Wed, 25 Nov 2026 15:30:49 +0100
Message-ID: <20261125143833.715035545@linuxfoundation.org>
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

From: Anandu Padinhare <Anandu.Padinhare@electrifex.com>

[ Upstream commit 070411c1590c8172eb4d86f045d99c372f22fe23 ]

In the AF_XDP zero-copy RX path, frames that the XDP program passes to
the stack are handed over by stmmac_dispatch_skb_zc(). That function
increments rx_pkt_n instead of rx_packets since
commit 133466c3bbe1 ("net: stmmac: use per-queue 64 bit statistics where necessary").

stmmac_rx_zc() already adds every processed frame to rx_pkt_n, so each
XDP_PASS frame is counted twice there, and rx_packets, which
ndo_get_stats64() reports, never counts them: on a zero-copy queue
rx_bytes grows with the passed frames while rx_packets stays still.

Count the frame in rx_packets, as the regular RX path and the code
before that commit did.

Found while testing AF_XDP zero-copy on an ADSP-SC598 (adi-dwmac,
100 Mbit/s link): rx_pkt_n grew almost twice as fast as the frames the
MAC delivered, while "ip -s link" counted almost none.

Tested on that board with a 6.18-based kernel, whose zero-copy RX
accounting matches net. An AF_XDP zero-copy socket on queue 0 received
frames of one EtherType while UDP traffic was passed to the stack. In a
run with 60 s of traffic before the change, rx_pkt_n was 1.88 times the
frames that reached the driver (MAC frames minus RX FIFO overflows) and
"ip -s link" counted 55 RX packets. In the same test with the change,
rx_pkt_n equals the frames that reached the driver and rx_packets equals
the frames passed to the stack.

Fixes: 133466c3bbe1 ("net: stmmac: use per-queue 64 bit statistics where necessary")
Signed-off-by: Anandu Padinhare <Anandu.Padinhare@electrifex.com>
Reviewed-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Link: https://patch.msgid.link/PNYPR01MB11444552E41C2B17A992492C0FD762@PNYPR01MB11444.INDPRD01.PROD.OUTLOOK.COM
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 9ff7aecefca22..fa4bd6a3a1bf8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5522,7 +5522,7 @@ static void stmmac_dispatch_skb_zc(struct stmmac_priv *priv, u32 queue,
 	napi_gro_receive(&ch->rxtx_napi, skb);
 
 	u64_stats_update_begin(&rxq_stats->napi_syncp);
-	u64_stats_inc(&rxq_stats->napi.rx_pkt_n);
+	u64_stats_inc(&rxq_stats->napi.rx_packets);
 	u64_stats_add(&rxq_stats->napi.rx_bytes, len);
 	u64_stats_update_end(&rxq_stats->napi_syncp);
 }
-- 
2.53.0




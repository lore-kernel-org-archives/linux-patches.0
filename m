Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622167;
	b=Zb/3ZXxoVl3+k7lp9dj5/burCp+heNipaqjmjoRSrq8cBPCOxwOQZ5JM9kj0K6NmSDtw
	 hsPRZ6aBE1UVF/hxtPXHv3Yi6bYSCZo1ffR04Uh2jaarsBsUcKIiltoIHPmYml8Ap37UM
	 Qn9VhE8UDUVxp5AtG5RYXIirgM+m2Wp4X8s8+YblydiOB7eCzIO+BGJKoI34/FGEWKw9C
	 pliRB9qUXUeY0eA7G69peM1fyq/FGkjTlQ2tUTFsNgAopfSGeUaCFLpv47vTTQ5HWSUK1
	 75zFRjbyajob3ra0iWgUXg0z1BEEEdBBfFuzM3Gb46k1kM3hygVFCl2mTCMLHOD5CKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622167;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+7oZcoCwTpPueU7rMdUj1DmXI06wrO1KmXX9omnnMhM=;
	b=jtMUKXCap0lzd2HWHxvP0PD6oToTSMhkZQtE9oTpGut0PYoTVuQSRFmVhNk86MYUMY7n
	 MO+eiYPJn2nK/CyqHHhFluQb8dUepFBWrFvM9kuGc6jF3iDe5nuBKfNM52xJ/4pPe8R2b
	 mMoHesXv5lL4HxUbtmZfns2iDVdsTx+sf/svCobXo8jJblWYqPHfeRHc1eCO8cpTVHLaF
	 uMHk8qBzctJs40yuRBz/xpXLdALGg5Uoyv3+fX9yASHnFpRyPY6rdzUHAQpbXI3TpABJA
	 xYohQd1mvaeu/hKv8nFqckHmmyFLWMr810GaYjl4ZJ1IGrfO0c1M5wzEtpN2eW4oTGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Fv/p2CO9";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9DDA606A332;
	Wed, 25 Nov 2026 15:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fv/p2CO9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C3661F000F0;
	Wed, 25 Nov 2026 15:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622167;
	bh=+7oZcoCwTpPueU7rMdUj1DmXI06wrO1KmXX9omnnMhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fv/p2CO9j7MaxqW9Oiez6+4QnAmsYht+gzlaHfPiAIq1UBEqw6i9OfyAkadNh1JUM
	 HaWYP12XPNc7hUTUKmVXac8xYTeMUgP+Bvv9MjbrxS3Pdf6NejCDBveRL4VLZ3WWrp
	 z/lC5bxb4S84zvb7lHSc0/ueDyqO+VifSt0ZqfRg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anandu Padinhare <Anandu.Padinhare@electrifex.com>,
	Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 443/990] net: stmmac: count XDP_PASS frames in rx_packets on the XSK zero-copy path
Date: Wed, 25 Nov 2026 15:30:10 +0100
Message-ID: <20261125143832.470889968@linuxfoundation.org>
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
index 0e78c1d2fcf1d..c2b975ac8b566 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5264,7 +5264,7 @@ static void stmmac_dispatch_skb_zc(struct stmmac_priv *priv, u32 queue,
 	napi_gro_receive(&ch->rxtx_napi, skb);
 
 	u64_stats_update_begin(&rxq_stats->napi_syncp);
-	u64_stats_inc(&rxq_stats->napi.rx_pkt_n);
+	u64_stats_inc(&rxq_stats->napi.rx_packets);
 	u64_stats_add(&rxq_stats->napi.rx_bytes, len);
 	u64_stats_update_end(&rxq_stats->napi_syncp);
 }
-- 
2.53.0




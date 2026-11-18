Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051441;
	b=Uy+VaYmaU2W35pRLMQwYd9pN+oZgKBoRBe44pzasH//irmDVS56no9DoGZWEp5AF7IL1
	 Tvy7Co0PIOZE+NNvCM4UjPhFUzT4yjyGqSt8DjTyExUpPwqBO/S0QpLQKKPDf8b86vI9j
	 PM9U2suC+tM4x78+ob/NuWI5ZP3yinO0mzXylfH0BmNlNEsmNWtuvX5llQ41CRpekTLLJ
	 MDNIi5dzETeXJKfxs0+stFkCgskH3asHcWQTTmpMOYRZTuTkd0wuGV/FtIsySTjZFO2Tc
	 7zcYDWrv0C977fwN8We9XnnlRdsRiQ6r/5YP6ft9bGHJststBgx5YrwLkglfbUFKeLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051441;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Fuu5IRg7+Bvp1T9vtoWtaDmuAU4jqq6IYGQNjinEkpA=;
	b=c2AyRx48U08CktptqxhOahdKor69/IicBF4LV7C1CLOotllLtC/RzviwUYY3ximawKfG
	 fgGAlKNDqbwLjtE3LPTxIIPWG+Z/jPUhm5VHZSIMYfmVZQSw23Gaey6tzJdD5AkEZHrA8
	 3QArRdAkmiRaGC0cyhZen6y765OwDDFwIIkgfNeevBIGTk2+NKVbvCFmqe3m18ZBmaGOy
	 XldsDauohqAbbHguy6Bw4iNUOQ5q50GrDI0DH4NjyiH7UTOoSvSAjQzFWHtw+v78U6JNO
	 bZ2LGJLY26KnphTc9MuM/tFbFRC6pWclJwd4ERQlRaoDOfG8NDcUWKmlHmcGTNJweng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SUM0J+WY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 174FB606A325;
	Thu, 19 Nov 2026 01:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SUM0J+WY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 941D11F000C4;
	Thu, 19 Nov 2026 01:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051441;
	bh=Fuu5IRg7+Bvp1T9vtoWtaDmuAU4jqq6IYGQNjinEkpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SUM0J+WYYuiMxOkrik820a9W3W1AbHy9BwQFRpaTT2kO+SCGE3rYr3qJu8SpEVPs/
	 c/AkL6sf8O37/j1fjqkVpIlvpjCuZGDI9LHKsgy/2FP1O3iCe84vFrDNnrwr2rPMOB
	 +68vAiDLvo1SJ8NN/nLuH9GQQgrsDA9zNgt6UPAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Alvarado <contact@c127.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0175/2214] net: stmmac: raise TX completion interrupt at the end of an xmit burst
Date: Wed, 18 Nov 2026 15:30:51 +0100
Message-ID: <20261118150017.063792952@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Alvarado <contact@c127.dev>

[ Upstream commit d21a374995df9d7cfd193427748a19dcc87956a9 ]

The TX mitigation logic only sets the Interrupt on Completion bit once
every tx_coal_frames descriptors (STMMAC_TX_FRAMES = 25), with the
tx_coal_timer hrtimer (STMMAC_COAL_TX_TIMER = 5000 us) as the only
fallback. TX skbs are freed exclusively from the TX completion path,
so any flow that keeps fewer than 25 frames in flight has all of its
skbs held for up to 5 ms after transmission.

Paced flows never queue enough frames to reach the frame threshold:
TCP Small Queues caps the amount of unfreed data at roughly two pacing
intervals worth, which at moderate pacing rates is only a couple of
packets. Every small burst then stalls until the coalesce timer fires,
and throughput collapses to approximately tsq_limit / tx_coal_timer
regardless of link capacity.

This is easily reproducible with BBR, which paces its output and thus
keeps only a few frames in flight at a time. On a YT6801
(dwmac-motorcomm) equipped Orange Pi 5 Pro, a BBR upload over a ~23 ms
RTT path is capped at 5.24 Mbit/s, while CUBIC reaches 207 Mbit/s on
the same path. BBR measures the stalled send rate as the path
bandwidth and locks its estimate near the floor, so the connection
never recovers. Lowering the coalesce settings with ethtool -C
(tx-usecs 100 tx-frames 1) lifts the same transfer to 447 Mbit/s,
confirming the mechanism.

Fix this by setting the IC bit on the last descriptor of every xmit
burst, i.e. whenever netdev_xmit_more() reports that no further frames
are pending in the current dequeue batch. Frame-based coalescing still
applies within a burst, bulk traffic keeps batching through qdisc bulk
dequeue and NAPI polling, and the coalesce timer becomes a pure
fallback instead of the primary completion mechanism for lightly
queued flows.

tx-frames 0 keeps its meaning of timer-based mitigation only.

Signed-off-by: Johan Alvarado <contact@c127.dev>
Link: https://patch.msgid.link/20260731194522.55069-1-contact@c127.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 73510737196f4..ceb582ca67beb 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4188,6 +4188,8 @@ static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
 		set_ic = true;
 	else if (!priv->tx_coal_frames[queue])
 		set_ic = false;
+	else if (!netdev_xmit_more())
+		set_ic = true;
 	else if (tx_packets > priv->tx_coal_frames[queue])
 		set_ic = true;
 	else if ((tx_q->tx_count_frames %
@@ -4408,6 +4410,8 @@ static netdev_tx_t stmmac_xmit(struct sk_buff *skb, struct net_device *dev)
 		set_ic = true;
 	else if (!priv->tx_coal_frames[queue])
 		set_ic = false;
+	else if (!netdev_xmit_more())
+		set_ic = true;
 	else if (tx_packets > priv->tx_coal_frames[queue])
 		set_ic = true;
 	else if ((tx_q->tx_count_frames %
-- 
2.53.0




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034040;
	b=acYK7cKvkC7/q/fZrrgIRgbh3kclzY3N5Wi7fsfShM8+LuyVya5/yVGXAlN8LU61cmlm
	 ic5tN+dpeKQvglS3qmtmSDxypQkuk8CdHyiiPRgai+sCI2erVls+CcJZqzvV7Vp1F9ZCk
	 f3UW/i6Xb73rXh70/JbBw5XzsTbq8s0XCJn07JFCtbMSYAdIxM08T88eXmC7hX5W2w/QE
	 tqu5yws3p8w8Qt1VV0NEJqh1Pm0ueZ5gtZtVrhWKnK3gCiIBz/F05thFvDCMxhzZi2MXc
	 up/oXmDG3Wk5Litx0zfK5iAa0zvJxr+/3LhDHo2pgvYjb28mF4OrLlNWEotMTKvkrtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034040;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CIrAIjQBoAOZV02y+rn5bW1+PRr19g9fr2qx7x5eF1g=;
	b=NYPGuBJM6oZ4TXSHwpP8i4+M2Y1urh33mOmiFuhQCyAIh73I4LavwdOGDQWoWs9vb7+E
	 GXCnC0HlwZyZRi+QOXbDrHp6amoA6Q/dbQpdKDmhDQmAB2CUndYgvhgT/IjQ/lS4MTjJj
	 U5SVNVkUz2VCPPeNWPVuIHi2QF/+jslZbn7PfQ3g0SMCTYEfMhlNql6eT/AwG9Jj6oWf8
	 vLJ1Fvum5kmmCj73AgyboL8G44doreBcbjUUGHDi+FKntzJG7L798YYr4Aa/Iwed1GOmr
	 1l9PagOu2WcqCuIrN8bMrrHSTbIb7QqNblo7ya88dGFlj9LXTtLVOqpxkiE7v0J4z1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZGYmtpKA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A2C360A2625;
	Wed, 18 Nov 2026 20:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZGYmtpKA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BD221F000CA;
	Wed, 18 Nov 2026 20:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034040;
	bh=CIrAIjQBoAOZV02y+rn5bW1+PRr19g9fr2qx7x5eF1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZGYmtpKALIufThwspI3RTgRkSbAoqpT+gX4TIWqJTT14QfWFWTW0Vnfzo4Sd0Qy8n
	 tjeCH+kLklcucmorJ1xbRMmCwWaqfY/y9Li+2ouLA8UjEX3GlW4HnG2gwnSpRLqihh
	 cDz1tl4vKjf4BV5maa8GhIuhLVzSwoIB5qoFLc6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Alvarado <contact@c127.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0228/3318] net: stmmac: raise TX completion interrupt at the end of an xmit burst
Date: Wed, 18 Nov 2026 15:14:10 +0100
Message-ID: <20261118150321.893650972@linuxfoundation.org>
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
index 6f7a2fec7f133..97c845f85fc29 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4244,6 +4244,8 @@ static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
 		set_ic = true;
 	else if (!priv->tx_coal_frames[queue])
 		set_ic = false;
+	else if (!netdev_xmit_more())
+		set_ic = true;
 	else if (tx_packets > priv->tx_coal_frames[queue])
 		set_ic = true;
 	else if ((tx_q->tx_count_frames %
@@ -4505,6 +4507,8 @@ static netdev_tx_t stmmac_xmit(struct sk_buff *skb, struct net_device *dev)
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




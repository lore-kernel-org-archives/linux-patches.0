Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829764;
	b=Yxl5YpVlHVYNePt5nwDVTHg5By1hgVrXfrUo9sF4g8Sy9WYoxkU/muvS36LPwPz0IPpW
	 Ea5cunMB46RX7fg6TwyKhlgDT1GVjYCGs5cYa/OViylATfMwFOCtTgWoYN7vZto+FBcAL
	 2SwBr7Z/YpqQvLu5t52D4tpYtRaTjsJwZRQvXm/nfpXodV723zhWv9zsFfoYxZ/wF5dAC
	 7OXVUmKwfPuTbirKvIYbSXBE3iNdsO6neUd1EwGEUTHcGd5yEkOZomqi+QlWmk+BpTunO
	 4sRhlHCY7UfISnnxBG47j7Zm7IMZ+hBl7mosqs5hE7vE/6eNBSczWvz35QqswbElGaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829764;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RfGX4O+qRqYQ7k1w2OUfheoXsFeN+TGYK1mAjV4P/a4=;
	b=urZIAJ9zc6Dqx4oxVmJXKaXgBbVyYL3umyIqimI/x/L3etjXi1X6a7CY1NN+4lQT7sJ9
	 4/bAwG5ClMHTNlk6LgKy303rFviOjUmFn2yJNLushdj1ShRyJ5KCglHjqlE2o1q5t3uMZ
	 197psNt2lRYTo4X0GFXk93sJAGaVQTl26//bIbjv2cXt0Owk3QipuRDi3nblQkTqtbTNd
	 q543gow5TvVVEgjJuvQ4z7Y3mMdLlS21CPzD05t7FpNMCXjKsWSEmk+d5gFkQ0X8CZt3G
	 XF3SE8GgO07t4msM1IXKQAzsM6DTDysLF786L+5ll7Y26TotDKOLxMHa+RlMs29Sl/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=njAzLuKx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 398FA606CA27;
	Wed,  4 Nov 2026 22:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=njAzLuKx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A444E1F000C1;
	Wed,  4 Nov 2026 22:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829764;
	bh=RfGX4O+qRqYQ7k1w2OUfheoXsFeN+TGYK1mAjV4P/a4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=njAzLuKxN/rXe5NYhtvDpSfnJ0cA4FV4pjso+QmIVKUcNH7umm7Ny2LDsvJKMILWj
	 D7AjohJR8bndyjEgH4BUtoW27mOCXpo46cPdwTfsvFBK2oMYzxPRR7y+cdLa2WJRao
	 xwnq7m9ySy3MVQ0PXzhxzqFvbBZS7WAG05MIYP54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Alvarado <contact@c127.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0327/1005] net: stmmac: raise TX completion interrupt at the end of an xmit burst
Date: Wed,  4 Nov 2026 16:01:00 -0500
Message-ID: <20261104211053.111830136@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
index 63c045616c9b7..7dbb5e9bcb54b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4400,6 +4400,8 @@ static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
 		set_ic = true;
 	else if (!priv->tx_coal_frames[queue])
 		set_ic = false;
+	else if (!netdev_xmit_more())
+		set_ic = true;
 	else if (tx_packets > priv->tx_coal_frames[queue])
 		set_ic = true;
 	else if ((tx_q->tx_count_frames %
@@ -4687,6 +4689,8 @@ static netdev_tx_t stmmac_xmit(struct sk_buff *skb, struct net_device *dev)
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




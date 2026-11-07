Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060897;
	b=IR55pm4mZLd+NqSulGFqUV+Xgk+LXqIw8iR3D0sHnoyqVL1E8qV44BkXwpCvBU/SzfcI
	 57PwHXyxJNpnZ4jVJON8347De+LIek/TUYqxopAb7w/EBQdMNTcW8tk9npr/z4l885Hn4
	 E+yJXMknGx8HsbwSobFwwjatFzndb7W3C3S1JkVoAl3XwpInymhMQRTW85JjkF3MVzV/7
	 dbb1TLW2pLi0YqAI+OfBz/WWGHpby6dgfH8hVMT0BIrKhDrmp4UddbdEhrwipotWyBnrn
	 NOVtD+xu5VLWR44cdN/UC+JQFQ3/tkems3522aCEGisyN4i5UegQPrQdRSMw6J6ao/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060897;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=btM9t2bN4wFx5stRun2x0xc+Iqx9FgK2S9q1fMz0ID8=;
	b=Ap1Kjpxq6MjZ8lbaSmNWyCWbu97yBSJiWD0/IkHIw27De+34Fm1QPbxH9h7MZ5yJWUhV
	 kCRD/dkBflK5JjOkygbkfDYJzUu2HFvFAhqPd+5z8gjAdOI7AwXNW6a9yiJLH9fMJK8jj
	 jpBCvDoWsH0NKkc/jYfyaVQLDQa9iztIwFkHwOdiVYcWoYx244AEDVsDrNGiP01A5/dT9
	 /+Pd8omRtsIGg/PjtUqsR1eP2OtKZfGHmg0+3H/4W6qZsxfvzhoGIBw7WnitvVCBURJen
	 Us/M2AS8M992XY4JAZKcRjMzf/KgBQj4JEEr7uSKaZOPD4uB/wkOseRN81WpvpnVhlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cN7xBpH+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD233606A326;
	Sat,  7 Nov 2026 14:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cN7xBpH+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F4941F0089F;
	Sat,  7 Nov 2026 14:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060896;
	bh=btM9t2bN4wFx5stRun2x0xc+Iqx9FgK2S9q1fMz0ID8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cN7xBpH+exJTHG0UN5/9FV+XtaGpeyH+1//hstKfxBwRl3H2CxdJlio0ZVzM22ex5
	 MGByULAfqSv+EYswNaN8IiJMYg8G0d9VhHccK4pHliyW9NB0Cg9roDLjc3NSfT2YRR
	 BNtbxpKjB5zkOyHlTyMhyC5JvUzzxIjbZEJ0zVDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Alvarado <contact@c127.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0271/1536] net: stmmac: raise TX completion interrupt at the end of an xmit burst
Date: Sat,  7 Nov 2026 08:38:07 -0500
Message-ID: <20261107135005.290429588@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 057d23c8d8906..84c146eb3df2b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4387,6 +4387,8 @@ static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
 		set_ic = true;
 	else if (!priv->tx_coal_frames[queue])
 		set_ic = false;
+	else if (!netdev_xmit_more())
+		set_ic = true;
 	else if (tx_packets > priv->tx_coal_frames[queue])
 		set_ic = true;
 	else if ((tx_q->tx_count_frames %
@@ -4667,6 +4669,8 @@ static netdev_tx_t stmmac_xmit(struct sk_buff *skb, struct net_device *dev)
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




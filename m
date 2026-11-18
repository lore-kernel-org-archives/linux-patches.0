Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037854;
	b=l6Vg0MPSAjfG2yK2MSpiLcWAZa5CFdWxiN+0vNpYdlXssx7vG8mUqnkPalUQMuNM5Obz
	 ikXL9O12XfM/lWF6kV4pHzdb4+nrD5z0L+OwmuqXgxHx9ocLLeNGag4Qz9s47uKbC8YcK
	 xKzWf+mBn/lE1T8VE1d49QDTXDQKSZfyG2xnilpdXhemLrP/Rw5qG4xfSyitjfoDWto7s
	 z/UpfyP2a3f8hkiHk/4cezCstsTtmHxYXLaKccQubRF/v/kUmC668mdX4wIb9NFGZpRLy
	 BozWU5JtGqd8QvO0nvSAtyjw7MHJhqDBKuc9WLpfIZAXnimd/AUCMDcAuuWpr1qCQbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037854;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NUlpjLyMPebu+og7jgviHHNbJkf8c59wD/v5tFl9gHg=;
	b=gy3K65O1yMaYvKvy/W2yBkVUY2fvw/USSoewzwL7l1elobOMqXbTZagny/v8AfSp9bDK
	 LZ5pCQL6XPKvSxsRFupnlmefSSUIgyp1WoIT2y7z1CFr6hZsIY2b4vgzxNMjOenOWOn8H
	 oG7nTJGJ0H/oUgXTcZrkN4UavTgTPGQAatPmNzV03DoOf2nxOmnqN3vG2z4FwFqhiYypY
	 faICODvlMOYGa6Z/dYen9aohMUyCTh3JSy6L5Z2wvFOVJm2u8JSGLVi8sxwGudQ+DKvvO
	 3oCBR8piGbpz9CkWL2PHzE5oNa+ApHqBAURRSLPTbc8nNweNm5u09rAwdUfqsDbsDmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="qv/NVqUO";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D98D606A31C;
	Wed, 18 Nov 2026 21:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qv/NVqUO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A27C71F000C4;
	Wed, 18 Nov 2026 21:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037854;
	bh=NUlpjLyMPebu+og7jgviHHNbJkf8c59wD/v5tFl9gHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qv/NVqUOk4EstFJI1IUqeL40BEc/VK/DmfwKn3S+0jK3P2XKwAa7N1NOcVh4vZFhD
	 oKqeg6vDI+sOuG2QnoQfa1vTuHFEtXc4dIcVVokwyLy/qYeCdqJzqKZEFxh42C4LWm
	 tldryPQJGw6+YIStphBbG+6y7RgqyjPk8q37XoSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChunYuZhiQiang <chunyuzhiqiang@yinhe.ht>,
	Vincent Mailhol <mailhol@kernel.org>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1514/3318] can: dev: can_fill_info(): dont wake up controller if interface is down
Date: Wed, 18 Nov 2026 15:35:36 +0100
Message-ID: <20261118150406.364651744@linuxfoundation.org>
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

From: ChunYuZhiQiang <chunyuzhiqiang@yinhe.ht>

[ Upstream commit 75332c410c8190d61499001c5516af977ca426c3 ]

If the interface is down, the CAN controller might be powered down and
its clocks gated. Don't call do_get_berr_counter() to read the bus error
counters if the interface is down, and adjust can_get_size() to match.

This removes one trigger for a synchronous external abort seen on
i.MX8QXP when "ip link show" is run on a flexcan interface that was
never brought up. The underlying cause is platform-specific: on i.MX8QXP
the CAN clocks are gated through the SCU LPCG and the subsystem shares
the IMX_SC_R_CAN_0 power domain, and there is a window after
pm_runtime_resume_and_get() returns where the clock has not reached the
module yet. This patch avoids the netlink query path while the interface
is down, but does not root-cause the LPCG window itself.

As a result, IFLA_CAN_BERR_COUNTER is no longer reported for down
interfaces. Userspace must treat the attribute as optional.

The issue was triggered on an i.MX8QXP board by running "ip link show"
without ever bringing the interface up:

    Internal error: synchronous external abort: 0000000096000210

    pc : flexcan_read_le+0x0/0x18
    lr : flexcan_get_berr_counter+0x4c/0x8c
    Call trace:
     flexcan_read_le+0x0/0x18
     flexcan_get_berr_counter+0x4c/0x8c
     can_fill_info+0x1f8/0x434
     rtnl_fill_ifinfo+0x8fc/0xbb4
     rtnl_dump_ifinfo+0x364/0x448

This is the same class of problem fixed for m_can in
commit 91a55c72a821 ("can: m_can: m_can_get_berr_counter(): don't
wake up controller if interface is down").

Fixes: ec56acfef2af1 ("can: flexcan: flexcan_get_berr_counter(): switch on clocks before accessing ecr register")
Cc: stable@vger.kernel.org
Signed-off-by: ChunYuZhiQiang <chunyuzhiqiang@yinhe.ht>
Reviewed-by: Vincent Mailhol <mailhol@kernel.org>
Link: https://patch.msgid.link/20261027065012.191348-1-chunyuzhiqiang@yinhe.ht
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/dev/netlink.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/dev/netlink.c b/drivers/net/can/dev/netlink.c
index 77d165ed0d534..884313a5cdd31 100644
--- a/drivers/net/can/dev/netlink.c
+++ b/drivers/net/can/dev/netlink.c
@@ -454,7 +454,7 @@ static size_t can_get_size(const struct net_device *dev)
 	size += nla_total_size(sizeof(u32));			/* IFLA_CAN_STATE */
 	size += nla_total_size(sizeof(struct can_ctrlmode));	/* IFLA_CAN_CTRLMODE */
 	size += nla_total_size(sizeof(u32));			/* IFLA_CAN_RESTART_MS */
-	if (priv->do_get_berr_counter)				/* IFLA_CAN_BERR_COUNTER */
+	if (priv->do_get_berr_counter && netif_running(dev))	/* IFLA_CAN_BERR_COUNTER */
 		size += nla_total_size(sizeof(struct can_berr_counter));
 	if (priv->data_bittiming.bitrate)			/* IFLA_CAN_DATA_BITTIMING */
 		size += nla_total_size(sizeof(struct can_bittiming));
@@ -574,7 +574,7 @@ static int can_fill_info(struct sk_buff *skb, const struct net_device *dev)
 	    nla_put(skb, IFLA_CAN_CTRLMODE, sizeof(cm), &cm) ||
 	    nla_put_u32(skb, IFLA_CAN_RESTART_MS, priv->restart_ms) ||
 
-	    (priv->do_get_berr_counter &&
+	    (priv->do_get_berr_counter && netif_running(dev) &&
 	     !priv->do_get_berr_counter(dev, &bec) &&
 	     nla_put(skb, IFLA_CAN_BERR_COUNTER, sizeof(bec), &bec)) ||
 
-- 
2.53.0




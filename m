Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059253;
	b=NbZfROZDPU8rhBqwD+NfyWkSwvR1zfi2bfKAtw9eVXGnd/059rjwivvV3EDMQnK3FYNp
	 fxxROMm1HVop2srVYQtwCTDE5nRQblCcygxGbjtZgbSyjBEjnAjeI6CJNrz/BoDNuWrBD
	 C062Pwwq0QLBINti60tsQZBzJkLb495MvqVFrscA7uNKUe3Dly3kGg1+xj4dKv9TCKl19
	 PDcmCdIoBB8+LeH4/Cy7puTeFTwf4qBv4zH27AIsKuAhV47JwI8F490dIu+Pssbid4tLN
	 whG5R5/PPYziQBkHA/wA3t7lQqW+4/dMUqKALGq50/FDmJzRMaW31YrEk72QShPnj/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059253;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4OR45uf6/Q/+hitHit10bKTClGOyNdAUKb/xYg+sqS8=;
	b=szhxKLFRODQiktHGL7wFxmhBgJMOS2V/2BC0G5g6lD42jKx+HbNZo6vTL4WW4+DZS3NP
	 ja73kJ8HmKAj64BEyHK+F8AteH4mh/9EHBj6F0ux8rJOTnrA8lN5nVVFOqUFUbAJcKnXu
	 HZyO/0QO+9L3WmswH8eLDE3OTqt4nCTx0IaU0g4qvz0bstpwpz497puixir7gz/EKOwN1
	 JwqQV0eLaKrgu6l5WC6V0LQfril/3v2yzs6Mc0487f9CICMxMzWys/WdLnmzis+kG5ssq
	 ewl7cafl7K+bbwAVwkmMrVEyO/VqHbmEQke0lZuLqxcT1KLWcfNyGO4cyCAFCvKvCQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LveoRgDO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95BC8606A325;
	Thu, 19 Nov 2026 03:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LveoRgDO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0FB81F000C4;
	Thu, 19 Nov 2026 03:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059253;
	bh=4OR45uf6/Q/+hitHit10bKTClGOyNdAUKb/xYg+sqS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LveoRgDOcpVJ9rgsicyX4YVKpltSonBr07TCdoYWNBPL8eicHTRYiB7icZseLKWx0
	 neaGF8Cx1f5xcIIbJ06nR17WECzh/LcWqWRUuaU2zeZ/bH+6U9lK/clJf8r8NCflZu
	 SlAjEFuniAAKq5xXj6xJHTSDeMvhpaWyNxDgT37I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChunYuZhiQiang <chunyuzhiqiang@yinhe.ht>,
	Vincent Mailhol <mailhol@kernel.org>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0776/1848] can: dev: can_fill_info(): dont wake up controller if interface is down
Date: Wed, 18 Nov 2026 15:46:54 +0100
Message-ID: <20261118145948.972879837@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ChunYuZhiQiang <chunyuzhiqiang@yinhe.ht>

commit 75332c410c8190d61499001c5516af977ca426c3 upstream.

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

Note: in 5.10 the netlink code still lives in drivers/net/can/dev/dev.c,
so this is a manual backport, not a cherry-pick.

Fixes: ec56acfef2af1 ("can: flexcan: flexcan_get_berr_counter(): switch on clocks before accessing ecr register")
Cc: stable@vger.kernel.org
Signed-off-by: ChunYuZhiQiang <chunyuzhiqiang@yinhe.ht>
Reviewed-by: Vincent Mailhol <mailhol@kernel.org>
Link: https://patch.msgid.link/20261027065012.191348-1-chunyuzhiqiang@yinhe.ht
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: ChunYuZhiQiang <chunyuzhiqiang@yinhe.ht>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/dev/dev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/dev/dev.c b/drivers/net/can/dev/dev.c
index b5e79d63d59b5..30d45805f29df 100644
--- a/drivers/net/can/dev/dev.c
+++ b/drivers/net/can/dev/dev.c
@@ -1141,7 +1141,7 @@ static size_t can_get_size(const struct net_device *dev)
 	size += nla_total_size(sizeof(u32));			/* IFLA_CAN_STATE */
 	size += nla_total_size(sizeof(struct can_ctrlmode));	/* IFLA_CAN_CTRLMODE */
 	size += nla_total_size(sizeof(u32));			/* IFLA_CAN_RESTART_MS */
-	if (priv->do_get_berr_counter)				/* IFLA_CAN_BERR_COUNTER */
+	if (priv->do_get_berr_counter && netif_running(dev))	/* IFLA_CAN_BERR_COUNTER */
 		size += nla_total_size(sizeof(struct can_berr_counter));
 	if (priv->data_bittiming.bitrate)			/* IFLA_CAN_DATA_BITTIMING */
 		size += nla_total_size(sizeof(struct can_bittiming));
@@ -1186,7 +1186,7 @@ static int can_fill_info(struct sk_buff *skb, const struct net_device *dev)
 	    nla_put(skb, IFLA_CAN_CTRLMODE, sizeof(cm), &cm) ||
 	    nla_put_u32(skb, IFLA_CAN_RESTART_MS, priv->restart_ms) ||
 
-	    (priv->do_get_berr_counter &&
+	    (priv->do_get_berr_counter && netif_running(dev) &&
 	     !priv->do_get_berr_counter(dev, &bec) &&
 	     nla_put(skb, IFLA_CAN_BERR_COUNTER, sizeof(bec), &bec)) ||
 
-- 
2.53.0




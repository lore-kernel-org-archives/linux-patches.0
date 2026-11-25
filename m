Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618350;
	b=Opu/s7b+4IpQ8MQb3lcUh93T4XfB58SbdtVBGFCZ9ospDw0CCjhhlgVongZVKOQqCqvI
	 XnBg2fkabRyPXn23+BZxt/TSQeE3Wrbi3KX8CthWt7WMLi4zHI6fWNQ+oDTx3pKtWatS1
	 ra0MbO/x7YS3P32khGQrIINqnCn++4PVZVH9Xe7dt/ZHJKcJvv7tTqy0BX+QhNp8N53EN
	 A24PkPdPYTRFs3stt+MNxzlKOrwkdLXMeJGULu40bFcX6t5W0JDxyRLuL8HR+1m2fUqgi
	 7u/iP82jEFx95g5BPWAhZNiSmB4ZzENGalzwqQORHo4pn4Z1fh54cR9WqA+LwjAqasw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618350;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qABNaKa1gSubrUbkP3txkKebS+cZir4scEoAXwM79II=;
	b=qzcwSdX1dd6lTgKESm0u+dya5vCJ8UwUrji/6X+KK1ZWfkO+wr6ZrbB5zzMbyK41VR5r
	 MeFpka9C/b6IMgFah+HnoA/wYD5rpUJPTWCQNr4guIOzb4Cc1QCYmY2rURhTXOprgJFUD
	 1uLUyffZrrmyb4IJz4gNOmLWlj9mQ9BROgXfGFlFuYxPheSO0e5ujbKB/EjWOVyJkNSoQ
	 +m4o0Oo6iIZH+F7J2wER7pDFwcEwbHjMtagLIWrKLNydroSdcB2q5gr1D7NAehGBChrdR
	 BKAIFOIuenGYxVEasly+KPlMqQFJSkNi1ikstBQUcDflz/VQ/dfLwS2vAm+0tN/jPOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MkV1rqRX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DD2E606A321;
	Wed, 25 Nov 2026 14:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MkV1rqRX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D0251F000C0;
	Wed, 25 Nov 2026 14:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618349;
	bh=qABNaKa1gSubrUbkP3txkKebS+cZir4scEoAXwM79II=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MkV1rqRXAERWuLp/4hqVC3SBeozNyeiFa+puyRzz4yekEbEcOXHNghsd0kEZDQnXp
	 MN4gFfNQ3xfPPG2kNtDPkZBDEFRdrg3aiFBB8oM4CLLrh5k7OQaNP+eW1FHnBqO0Gu
	 KYRjK2v2mfthjt4831cwxmw7x1OaDG9eGH9P7RQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChunYuZhiQiang <chunyuzhiqiang@yinhe.ht>,
	Vincent Mailhol <mailhol@kernel.org>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0251/1005] can: dev: can_tdc_fill_info(): dont read automatic TDCV if interface is down
Date: Wed, 25 Nov 2026 15:26:29 +0100
Message-ID: <20261125143827.617296141@linuxfoundation.org>
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

From: ChunYuZhiQiang <chunyuzhiqiang@yinhe.ht>

[ Upstream commit f5128a76726105f398d7ee70ee523dd4f68d62f4 ]

The automatic TDCV readback calls into the driver via do_get_auto_tdcv().
Some drivers, such as xcan_get_auto_tdcv(), read controller registers
without taking a runtime PM reference, so calling this while the
interface is down can touch registers whose clocks are gated.

Gate do_get_auto_tdcv() on netif_running() in can_tdc_fill_info() and
adjust can_tdc_get_size() and can_data_bittiming_get_size() so that only
the automatic TDCV size is skipped when the interface is down. The other
TDC parameters are still reported, as they are meaningful while the
interface is down.

This is a defensive hardening based on code inspection; the automatic
TDCV path has not been triggered on hardware.

Signed-off-by: ChunYuZhiQiang <chunyuzhiqiang@yinhe.ht>
Reviewed-by: Vincent Mailhol <mailhol@kernel.org>
Fixes: e8060f08cd69 ("can: netlink: add can_priv::do_get_auto_tdcv() to retrieve tdcv from device")
Link: https://patch.msgid.link/20261027065012.191348-2-chunyuzhiqiang@yinhe.ht
[mkl: fix open parenthesis alignment]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/dev/netlink.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/net/can/dev/netlink.c b/drivers/net/can/dev/netlink.c
index b958c04d53db6..081dfddda0008 100644
--- a/drivers/net/can/dev/netlink.c
+++ b/drivers/net/can/dev/netlink.c
@@ -720,7 +720,8 @@ static int can_changelink(struct net_device *dev, struct nlattr *tb[],
 	return 0;
 }
 
-static size_t can_tdc_get_size(struct data_bittiming_params *dbt_params,
+static size_t can_tdc_get_size(const struct net_device *dev,
+			       struct data_bittiming_params *dbt_params,
 			       u32 tdc_flags)
 {
 	bool tdc_manual = tdc_flags & CAN_CTRLMODE_TDC_MANUAL_MASK;
@@ -742,7 +743,8 @@ static size_t can_tdc_get_size(struct data_bittiming_params *dbt_params,
 	}
 
 	if (tdc_flags) {
-		if (tdc_manual || dbt_params->do_get_auto_tdcv)
+		if (tdc_manual ||
+		    (dbt_params->do_get_auto_tdcv && netif_running(dev)))
 			size += nla_total_size(sizeof(u32));	/* IFLA_CAN_TDCV */
 		size += nla_total_size(sizeof(u32));		/* IFLA_CAN_TDCO */
 		if (dbt_params->tdc_const->tdcf_max)
@@ -752,7 +754,8 @@ static size_t can_tdc_get_size(struct data_bittiming_params *dbt_params,
 	return size;
 }
 
-static size_t can_data_bittiming_get_size(struct data_bittiming_params *dbt_params,
+static size_t can_data_bittiming_get_size(const struct net_device *dev,
+					  struct data_bittiming_params *dbt_params,
 					  u32 tdc_flags)
 {
 	size_t size = 0;
@@ -764,7 +767,7 @@ static size_t can_data_bittiming_get_size(struct data_bittiming_params *dbt_para
 	if (dbt_params->data_bitrate_const)		/* IFLA_CAN_{,XL}_DATA_BITRATE_CONST */
 		size += nla_total_size(sizeof(*dbt_params->data_bitrate_const) *
 				       dbt_params->data_bitrate_const_cnt);
-	size += can_tdc_get_size(dbt_params, tdc_flags);/* IFLA_CAN_{,XL}_TDC */
+	size += can_tdc_get_size(dev, dbt_params, tdc_flags);/* IFLA_CAN_{,XL}_TDC */
 
 	return size;
 }
@@ -825,10 +828,10 @@ static size_t can_get_size(const struct net_device *dev)
 	size += sizeof(priv->bitrate_max);			/* IFLA_CAN_BITRATE_MAX */
 	size += can_ctrlmode_ext_get_size();			/* IFLA_CAN_CTRLMODE_EXT */
 
-	size += can_data_bittiming_get_size(&priv->fd,
+	size += can_data_bittiming_get_size(dev, &priv->fd,
 					    priv->ctrlmode & CAN_CTRLMODE_FD_TDC_MASK);
 
-	size += can_data_bittiming_get_size(&priv->xl,
+	size += can_data_bittiming_get_size(dev, &priv->xl,
 					    priv->ctrlmode & CAN_CTRLMODE_XL_TDC_MASK);
 	size += can_pwm_get_size(priv->xl.pwm_const,		/* IFLA_CAN_XL_PWM */
 				 priv->ctrlmode & CAN_CTRLMODE_XL_TMS);
@@ -910,7 +913,7 @@ static int can_tdc_fill_info(struct sk_buff *skb, const struct net_device *dev,
 		if (tdc_manual) {
 			tdcv = tdc->tdcv;
 			err = 0;
-		} else if (dbt_params->do_get_auto_tdcv) {
+		} else if (dbt_params->do_get_auto_tdcv && netif_running(dev)) {
 			err = dbt_params->do_get_auto_tdcv(dev, &tdcv);
 		}
 		if (!err && nla_put_u32(skb, IFLA_CAN_TDC_TDCV, tdcv))
-- 
2.53.0




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590445;
	b=HSHw/2n7WT61CuFnZg6jevDOtlLuHRHTr8NpGfVnvFEWQSMJoONQl80tuvvksehiqQ2s
	 4ka18HRIj85SOKmaGKZOZ4sY9cchjlHRHX9bkcwPTR2Nr37NYVsH2FbBd7MLvXI3FGuZP
	 wMCwvQZmtLTkYQMi4wgLW4WS/SZFY7DcJWEsflutgkP6R/KLWKgr49jw6/fycWuuMHqJp
	 IrDczaHuh4FnJ0WR//eBwhPj/WmyPOthXbPGcmc5rCFPfE1Wy2EiO293MvzhNkMYkNSWG
	 vntM8Jetvk409oE8LO6lvhP9bTrHxUQlI2obrWqFWxSpPgUTgs9AoXKnIof7lvrCFVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590445;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dJzcubjOdBUsxBYr2yHZSpZh2IB2DpzeCBTpWIccjVk=;
	b=NoSNss0CwN8KnCYwZZjPjPa8RWvxozgr4DlplszBZkOIYtF/0iz4nlyU5MDia2v2UOKB
	 Amy4EPE4ecvzH6FatDDoIWM90f88TcLvsAoj/0tw/TIZ6LTx4xj13IzrT3DtMHEiCrzIL
	 FD0Ll3JmG3OFpVB3vNRVmKpER5bmm+XLrqcvl1hqugym2dUalosFyJZ7AZ/6DJFzzt5eB
	 WmpKcJyFjEEwWy7Ur3S56M7dE3Ap6wW+/ExKFRPdiU+BdDYDaDErgUecUAZVO0T0cbCq7
	 EJuKJAVLq1L/3yqHH/G17vHjdArrilZUlIGmHO27NEhAuITWe+foAxJJ0pFuFVxo/ig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BgJKsHqs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F97160703D0;
	Fri, 13 Nov 2026 17:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BgJKsHqs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF7751F000C6;
	Fri, 13 Nov 2026 17:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590445;
	bh=dJzcubjOdBUsxBYr2yHZSpZh2IB2DpzeCBTpWIccjVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BgJKsHqssUMEeXekjo2ONvzz/qvI77OTm4kKam1Amd25JkkZeI0Dw1d00EB5Ac1uo
	 qeN5Ik2AxAYv3+sNs+nMnuunLNOIUZoi+TrHIErSvgLLHcD+mfxCmk1tdUpWu2Lkpf
	 ueLUqDsYeOTy87c4bF0TcieJi8z4E0gJCLEeuMVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChunYuZhiQiang <chunyuzhiqiang@yinhe.ht>,
	Vincent Mailhol <mailhol@kernel.org>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 367/686] can: dev: can_fill_info(): dont wake up controller if interface is down
Date: Fri, 13 Nov 2026 10:48:20 -0500
Message-ID: <20261113153833.358527182@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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
index fcfff221d1cc2..f4ab494b91518 100644
--- a/drivers/net/can/dev/netlink.c
+++ b/drivers/net/can/dev/netlink.c
@@ -586,7 +586,7 @@ static size_t can_get_size(const struct net_device *dev)
 	size += nla_total_size(sizeof(u32));			/* IFLA_CAN_STATE */
 	size += nla_total_size(sizeof(struct can_ctrlmode));	/* IFLA_CAN_CTRLMODE */
 	size += nla_total_size(sizeof(u32));			/* IFLA_CAN_RESTART_MS */
-	if (priv->do_get_berr_counter)				/* IFLA_CAN_BERR_COUNTER */
+	if (priv->do_get_berr_counter && netif_running(dev))	/* IFLA_CAN_BERR_COUNTER */
 		size += nla_total_size(sizeof(struct can_berr_counter));
 	if (priv->termination_const) {
 		size += nla_total_size(sizeof(priv->termination));		/* IFLA_CAN_TERMINATION */
@@ -737,7 +737,7 @@ static int can_fill_info(struct sk_buff *skb, const struct net_device *dev)
 	    nla_put(skb, IFLA_CAN_CTRLMODE, sizeof(cm), &cm) ||
 	    nla_put_u32(skb, IFLA_CAN_RESTART_MS, priv->restart_ms) ||
 
-	    (priv->do_get_berr_counter &&
+	    (priv->do_get_berr_counter && netif_running(dev) &&
 	     !priv->do_get_berr_counter(dev, &bec) &&
 	     nla_put(skb, IFLA_CAN_BERR_COUNTER, sizeof(bec), &bec)) ||
 
-- 
2.53.0




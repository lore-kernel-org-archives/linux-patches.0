Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046430;
	b=j0KN4jgWtyv7FbuW15l6Q1wnNNpEr2+BJEzJWuHKtdINp2ZCNXyWqK4a5pgc15GtFFRp
	 kY/dtDn8se0zIFn0KIFnVtahvO6M6jWueAGpvIxXpTNOTVLMcSKSThvHcphgDAXpN1yZz
	 cLOlNpOqGqrer9iJswS4FFtmkWaSw+9E3Ei705q5WLNjuOaxjqfd+Z+q+OwtVipudVY+n
	 9C0q3SzCunJwMhfo2I3+bgT4oA9+Jehxg18zSkSjkVTOP6cVslSwpvrIAmHU1VMK8nxah
	 Ec5oVJzsE/wguEk4hdK3+XTtAyzTn6Qy2STRv3/KX3YWs/+Z+Q1rh0YAQYy9fW0jqOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046430;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nWox2xw0xZ8J1jBOfQFC663YXF5/ktK4CzgxCs80mq8=;
	b=EsNuGMgeRmZt7Ir0cqD1O/7Coi7zuU51ICtbWaoR8DxpDJyWfqtVPKhJWsQZNaztDDwt
	 IqsdvFfC/NmaEj9JqBJ/AtaW+DUL/tTscgFF+wDC5oEximvWov6Sk2YoP79RBkkYTvvZA
	 TM+1OA1m+0ZSDTw94HkpGfbcIIml1Un9IqUOQaWTy4ZrqqpVcMyakK1dI0/1gPyoJ+8/C
	 n8U7SGiyoD03xb2u6oYalzfFwbV6y89oLhLiAnC7R/7Khv2m2YzXYecZPJpjky9c/UMPL
	 Qv85vZSQUH+k6QJs71oJjf4AjzaRvY9GXidwKo8gYCo5waMfUcu3rMmCEefl7uwR+uA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Yreu0mlb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6B09606A320;
	Thu, 19 Nov 2026 00:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Yreu0mlb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 365561F000C4;
	Thu, 19 Nov 2026 00:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046430;
	bh=nWox2xw0xZ8J1jBOfQFC663YXF5/ktK4CzgxCs80mq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yreu0mlb86jeXVViFXqaOBZXKYGyXahx2pSvph2zf0r2P9YXTYEmRC5ihVE2IEpBa
	 RkTe1yZCWtWtGWpFvQmAWJi/yregr1wbwgWBw/l6dQjjBoJZ56p2GBjvX4ksu+zFI4
	 vXW4Togs4HbwUjxFkly0dvsHoI4imna/73VyQTU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaixuan Li <kaixuanli0131@gmail.com>,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Quchaosheng <quchaosheng000406@163.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1277/2857] can: isotp: check the frame type, not just the length
Date: Wed, 18 Nov 2026 15:38:31 +0100
Message-ID: <20261118150247.491915100@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kaixuan Li <kaixuanli0131@gmail.com>

[ Upstream commit 933bf0fcb325e67b19c86c9c4da7f029878d5170 ]

isotp_rcv() separates Classic CAN from CAN FD by skb->len alone:

	if (skb->len != so->ll.mtu)
		return;

	cf = (struct canfd_frame *)skb->data;

A CAN XL frame with cxl->len 4 is CAN_MTU bytes, so it passes, and is then
read as a canfd_frame whose len comes out of canxl_frame.flags: at least
0x80.

Of the paths that follow, only the flow control one uses that length
without bounding it first, so check_pad() walks to 255 over a 16-byte
frame and the caller reports EBADMSG on an unrelated socket.

bcm_rx_handler(), j1939_can_recv(), can_can_gw_rcv() and raw_rcv() check
the frame type here, and can_dropped_invalid_skb() switches on
skb->protocol on the transmit side. isotp_rcv() is the gap.

Fixes: fb08cba12b52 ("can: canxl: update CAN infrastructure for CAN XL frames")
Signed-off-by: Kaixuan Li <kaixuanli0131@gmail.com>
Reviewed-by: Oliver Hartkopp <socketcan@hartkopp.net>
Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
Reviewed-by: Quchaosheng <quchaosheng000406@163.com>
Link: https://patch.msgid.link/20260920035626.2581040-1-kaixuanli0131@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/can/isotp.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/can/isotp.c b/net/can/isotp.c
index 5a0ecbc4f6b94..f81543405f2ac 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -722,6 +722,14 @@ static void isotp_rcv(struct sk_buff *skb, void *data)
 	if (skb->len != so->ll.mtu)
 		return;
 
+	/* check for correct CAN CC/FD frame content */
+	if (so->ll.mtu == CAN_MTU) {
+		if (!can_is_can_skb(skb))
+			return;
+	} else if (!can_is_canfd_skb(skb)) {
+		return;
+	}
+
 	cf = (struct canfd_frame *)skb->data;
 
 	/* if enabled: check reception of my configured extended address */
-- 
2.53.0




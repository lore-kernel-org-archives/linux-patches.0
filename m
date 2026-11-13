Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590395;
	b=hxUea/13QJKLLh/WXyH4syAxKx2LqZRECxVzbYpljv+rs8Pnx1o3LJaYSybETTkM5qz8
	 DgcKanzXJBBwQiFHuoCLhdMhiA/RkertvjEztPm+5dGU2UCK6PuZK/MRJ4mnKZU/KdcG9
	 03XknZd2UNGOE6ZmJZOgTfZv6zk4QHvZ/bplfajpgbfa6jJkyw5RZazWG7z3NM7/2xyFa
	 KThibOO0xyiUQa/4xOTOoT5dOl5vjmkq7qpqyBViai6tyMZEAyWJnTq8pusrN0XkkKvUc
	 s7p/uxEhbo5Oazn3aN0yIoBSHeZ8gGiUyhFGvhL4m3fP8Fgq+zcdhg3/6aatRFpanhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590395;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OH88VHCq2o0ebpyZKWOIBOvujr6DgBenBnN9Qtx8ir4=;
	b=M1r8yUOPegtlCnhtLIDJ+XJVjKOVRr19bMKjvLoMUvX4Y7wiLo++D2CMAlJLKEXWojJO
	 lv8/uVt7ah8r0+7agJ+65eMJz2mq0CgJcWt1TRVbsEZi7mzNpT7+FSMIysctTdUWDhpxF
	 wJfxYA9Qij6UwIRfdgosObpTbkOxbzaXHYSXbQHzo543o9nc/1aiYYNazkSIuBNKAH6wr
	 NO3Q1OP66tOCBEOkbueZHfhDAe3m98B7jGXFI4zIHZx5RsRdp2VxAr4hhNNNxfupzl+ry
	 yySCB1Q+hWNyGTx8naFP3mlkc6BXpVn5AmvhI4e1nMeFjCUHmf8FKFCBLRv817lHNrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T5qKxyD5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6829606B347;
	Fri, 13 Nov 2026 17:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T5qKxyD5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50BAB1F000CA;
	Fri, 13 Nov 2026 17:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590395;
	bh=OH88VHCq2o0ebpyZKWOIBOvujr6DgBenBnN9Qtx8ir4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T5qKxyD5RIYV2O1XOl69sRKyXxPj0pEz+7IPIXQbG0kW/b1jvkTDpPvrwaliKURV7
	 yDmALYYdQWq9tMMb7fBPBPj88l3nKG18tMLbn1kBQyTGVtn11t2XgIZui4O8NPcgSb
	 UoZLumTSYAe30YwFNCCxS529xzT2elPvJmZhfC8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaixuan Li <kaixuanli0131@gmail.com>,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Quchaosheng <quchaosheng000406@163.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 362/686] can: isotp: check the frame type, not just the length
Date: Fri, 13 Nov 2026 10:48:15 -0500
Message-ID: <20261113153833.170228221@linuxfoundation.org>
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
index 6c88f7777965a..39cd943df19ec 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -750,6 +750,14 @@ static void isotp_rcv(struct sk_buff *skb, void *data)
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




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037764;
	b=BG9+fMT1NosX1w+TnzQmvSavL720oMglyqWxAhiFopEBhW10WBrFqr7RqxSQMTvyWTvB
	 gaHAieXFC9j1Uw1XxXCCdb8nD6tYpHCZSpf1FCSVgaZQfSJe+thj/1NubnlQG5XHBalhT
	 6RjQ2oxvVOg1tFo4Ghw7xHM0uQh2xDQ8SR0axq8of8BBgjBNFgFmRyZfjYLKQrYJigLUN
	 kKhoEjTaENSx7LC5Hv9eqkvT5IPxu7NbFm2mhDvZbvvEKoKfakieBRwPLilFIPJZLf5GI
	 YKUH1GjxBLvmQnG9jM+uPRaYwaMonFVIDXJ8kb1P7jodvKFguNzAlw8yezv5uZuLmnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037764;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZeRPgjY5qtQfekZHiZdH/5Wd7fI6hI+5wXwBrRxpLH4=;
	b=qIcazTW7yzwim4tahJRNnUyYRRq2lMUpWVIQ2Yxa5ROPwXNysxZJGeyG8+oFIWqLHf4F
	 lsZOveLE4xag5eEgNVdMWoAiaH+d/jihrc0iEU6oTkaSg4QsTwuFrIY8+CmJo/TJlDfz9
	 pyhC36Uj8Wd+snLtaR14FRo27LiZcNI7gsSP04Sc1Fme3/cE/HyZaZDSU78X2BY5REyIs
	 DOkN53hboy3RT3xe3lXx1iPxc4jK3tbqnYdbi61SMXn6U9zP8KdXUpJNFmhndzIWXTx/o
	 23sKVsnYn+LouMK5q3wbcuPST/qO26c4rZDgDYWloIq1fJlXFCHWTpB/z5JezKo5otQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zFj7LxDR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C575606A325;
	Wed, 18 Nov 2026 21:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zFj7LxDR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E16B11F000C4;
	Wed, 18 Nov 2026 21:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037764;
	bh=ZeRPgjY5qtQfekZHiZdH/5Wd7fI6hI+5wXwBrRxpLH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zFj7LxDR1RxdjGnHf4Uw4KaDGI2e2YHobmkn+XiRdARaK72VxIJ8kUvVJcKSz/nij
	 xxYOawBBMavuDXHMDw+ZVJAkv7TCVkwNgzcg6sSeNxAnTp/ETFJD5YaOCRpa1Ray7U
	 j4bGtF6v+qtovBtc045k+fvDtOgouS24kMmwJuC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaixuan Li <kaixuanli0131@gmail.com>,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Quchaosheng <quchaosheng000406@163.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1509/3318] can: isotp: check the frame type, not just the length
Date: Wed, 18 Nov 2026 15:35:31 +0100
Message-ID: <20261118150406.208829955@linuxfoundation.org>
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
index e448cfdb1f07b..1a6691a5287ae 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -745,6 +745,14 @@ static void isotp_rcv(struct sk_buff *skb, void *data)
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




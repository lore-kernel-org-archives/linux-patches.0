Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585679;
	b=5Wk6J/nlTH0q8303kxhW9sZ9VNiAMiR7R9REy/ipnfr8C91UlG4VxQQcfcsz/LaUpTcZ
	 6yfOmZSVvHFvMnAtB0U5CRBvNCjUVQxR4fwMxZZdYtFMnvRWt1vCeecznDW0l43n71QWb
	 t9oCqFdiAvUZ5kWT+TIgJ+u/FBhHwfxzABg1lOMlATsHCDY+mDpsWwryVcVvRs37T9uxI
	 0IfgRhZrVcImlvP/jWJ5+JKaCIBkagJDwVjEOdUvVjh9S+5uSQYf4UxoKojwxH64zw/pc
	 SbcvZEcKuHZVi4GFK76oqWCaOmw62WbadfjCqcfqBpr4xd4jdRlKOmS3bN9aEVhrgrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585679;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4vloYLX7T/O584Lpc/SIxhjeGCWYo6l+dhv/CrPb3j0=;
	b=dhlPxo+l1VGh7QL1W5WA776MehhPgYfMGGJWvcSQLiy0DE5GZo8/FdaJA9xUU/V1s/1f
	 FgC3OCaItVbk+QB6n7HLDTZT/2RMctpC1S+Yze86zM6zVmmjN0bHJkL/rPkl+ziwXecSr
	 REbEP4yk1j2uyx/0lWyZwBoavw8g98AOqSGRYgas8+SGUaJO5IsrDd6MvoAbv9kzzCox+
	 6rHOEvmiFXMvYK59L9QOfPa3w5Ha9xJLWhzzmP8h+qK4p3ZcIbqVw7erQNduvo8AHtAXk
	 4HVI0Jtf65PUiC3/688ssZ7DssoAyZqqpVzaZNI4q5ku0TUGKq68ZiZUNVAottjsDGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oY12AgNy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75BD0606A88F;
	Fri, 13 Nov 2026 16:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oY12AgNy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D01FC1F000C4;
	Fri, 13 Nov 2026 16:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585679;
	bh=4vloYLX7T/O584Lpc/SIxhjeGCWYo6l+dhv/CrPb3j0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oY12AgNy6Qcq2B+qcUcc3sldtTi3z9xvq/TSL59BPQnBqWgm8y3xffQcqIWrkEEh5
	 L0nHd8UjXU9DxXSmEtGvXkxcg6iiU0GE7MtewMBac5CSwvGo42fhwHLqapNn+ODn0F
	 WY1Zn+rEhbBtMM1erZLbb3vfWVepIlIeQ5e2+vHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaixuan Li <kaixuanli0131@gmail.com>,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Quchaosheng <quchaosheng000406@163.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 291/507] can: isotp: check the frame type, not just the length
Date: Fri, 13 Nov 2026 10:49:55 -0500
Message-ID: <20261113153805.118309292@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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
index f5dc9d04bd686..d3e43ab484258 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -755,6 +755,14 @@ static void isotp_rcv(struct sk_buff *skb, void *data)
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




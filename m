Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585678;
	b=EZ7/lY6mUSfqiGNB6NivN8zQK8mO8zx2SneBATOgDBGVGA4S5gsAby99dUJYlbxdpZs7
	 YAJtogaEEQqJK6yIHUD+5van7Y3S9uF7RMqZNdTySApsPN0YI9ZgDzLeAIHwmCBsF40N1
	 0y7kAEwe3w6E6iah8TJURyS6UPWHU+aF434k9O4bRFoRGCdtj5IBQWdj8JpFim5xWz1O/
	 giSvy7YlCcUBpqtBP1RfNFkaXWWmIxTLeaKoVBvZE9vbabBgS/1XeLJG3o4O+pZm1rw2K
	 SZY/5gGzGpXkFSQNzRkCIUBr+/aR1/XBnwrHDYY4GGA2n093/HpzoRzCLw5pTX50GFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585678;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jWTnN7J6moXnAEk0BdyttRhh1OAm40FAJokymRqkAd4=;
	b=eG4hPS2ZgrMSoJj562XWmq4HXkefg76Qwb1+YpfC4X1vJjbaZUMFnuLPa3lnjLtizUom
	 au94Gd0jdv0wtWEznntKnnRvt/CYbMPUQhS+2uB6aF5tbgZFWVrqc0IL1syAOSjIQRPGz
	 gK7o2Cqonbs82At2Q07+aedpA0OUl/cWXGnxXA1s1ngzsunF35CojU/7jYaVLbjVprsOE
	 XuTVAIIqBlVFzEYCHrbO5dSl6DHOKnSllEHOUJ0fJba+0bYlOG1G5E+Gau5p2zQsqjvXo
	 BKuOJgKD2Q/HKI1uGMxji6Nu+hs73HaAqF+JueKkfDu8qZd/BzYoDmujaRT+tPna0Qw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=afIaqaR2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F21C560744DB;
	Fri, 13 Nov 2026 16:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=afIaqaR2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9956D1F000C4;
	Fri, 13 Nov 2026 16:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585677;
	bh=jWTnN7J6moXnAEk0BdyttRhh1OAm40FAJokymRqkAd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=afIaqaR2xQwvTx/yMLokTgw5c5WjGCV6kySkNZYZXQTF4ZhE8u/qZvE6poxKRXPWo
	 gIUCow8zm+jqVDfLU2c0Ivld2iAkw4Z2nhXSzCZa9oOYAcy0Xtt93bRaTCxfJ5U6Rp
	 HbLVnAlD41d44QTZ+QkqQhiM1Ew7fLOQMP0FfsyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Mailhol <mailhol@kernel.org>,
	stable@kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 290/507] can: dev: can_dropped_invalid_skb: drop CAN XL frames on non-CAN XL devices
Date: Fri, 13 Nov 2026 10:49:54 -0500
Message-ID: <20261113153805.086829308@linuxfoundation.org>
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

From: Vincent Mailhol <mailhol@kernel.org>

[ Upstream commit 0fce44e29fce4b07642491b098afb41bd571e4f2 ]

Sending a PF_PACKET bypasses the CAN framework logic and can directly
reach a CAN driver's xmit() function. The PF_PACKET framework only
checks that skb->len does not exceed the net_device MTU.

For a CAN device that is not CAN XL capable, anything above CANFD_MTU
(72 bytes) is therefore dropped before it reaches the driver. However,
CAN XL frames are variable length. can_is_canxl_skb() accepts lengths in
the range CANXL_HDR_SIZE + CANXL_MIN_DLEN up to CANXL_MTU, i.e. 13 to
2060 bytes.

As a result, an ETH_P_CANXL skb with a length between 13 and 72 bytes
can pass both the MTU and the can_dropped_invalid_skb() checks.

A driver that does not support CAN XL will interpret canxl_frame->flags
as a length because of the overlap with can_frame->len. And because
CANXL_XLF is set, the resulting length is between 128 and 255. For
drivers that do not check can_frame->len before copying can_frame->data,
as most drivers do, this results in a buffer overflow of up to 247
bytes.

Drop ETH_P_CANXL skbs if the device does not have the CAN_CAP_XL
capability. Keep can_is_canxl_skb() for the validation of CAN XL skbs.

Closes: https://sashiko.dev/#/patchset/20260731-master-v5-0-5b27029dee20@qq.com?part=1
Fixes: fb08cba12b52 ("can: canxl: update CAN infrastructure for CAN XL frames")
Signed-off-by: Vincent Mailhol <mailhol@kernel.org>
Link: https://patch.msgid.link/20260731-drop_canxl_frames-v1-1-7387b70353b3@kernel.org
Cc: stable@kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/dev/skb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/dev/skb.c b/drivers/net/can/dev/skb.c
index 14edec5afb57e..bc0787535b524 100644
--- a/drivers/net/can/dev/skb.c
+++ b/drivers/net/can/dev/skb.c
@@ -4,6 +4,7 @@
  * Copyright (C) 2008-2009 Wolfgang Grandegger <wg@grandegger.com>
  */
 
+#include <linux/can/can-ml.h>
 #include <linux/can/dev.h>
 #include <linux/module.h>
 #include <net/can.h>
@@ -388,7 +389,7 @@ bool can_dropped_invalid_skb(struct net_device *dev, struct sk_buff *skb)
 		break;
 
 	case ETH_P_CANXL:
-		if (!can_is_canxl_skb(skb))
+		if (!can_cap_enabled(dev, CAN_CAP_XL) || !can_is_canxl_skb(skb))
 			goto inval_skb;
 		break;
 
-- 
2.53.0




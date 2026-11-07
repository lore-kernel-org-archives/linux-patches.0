Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063783;
	b=LzJfPa4T0HhU99uUa5/2rvf+Gf4PfkLsv2sj28CjoDMM6NFz1YvAv5hOURqPKoWuYZFn
	 3LaG06INM63Uy8TSzT/ld6SxL+Q8yVaGzJgzxjhtlKnO94geFRIwArbjuvisplwYApl1V
	 h68K93PJ3+zjdxKJ/0kbIGUMiPc8BlQBLQedQ0Xatcg8bRZ8wLVqLlFN9ekh7ADIyGKMm
	 N3M3NzaoNzH0Z+js13XGMUi3D7QNvnWgiSHCRuNwHxXGjwB5DQ1SlEmYj4/C3Vwo6wTC5
	 9LFE7KzTnAwHsHXHOuc0GITqfYYi5//e8jjMIMB7Tdoabt2EraMIv76VHmiB5i0TSRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063783;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xxs7wWlR9DlzGydLb2Wr1YPiAzyKTjmaEpfc9q+LwHY=;
	b=nBl2OR81RzjWPHXi3VGqZt/ZDK3nXEp/Mu5L3yZf4dHcF4uOOzT7Yoz2ZTOaohvTyzGZ
	 wS7cWfiFCXyfQlxXVml/pGrUqsibOFoWgwhtvdEzSSCc0+xyTI0nKI89gqgy/gIE8Qi6W
	 OfRiojHoAcBVMWCIPgUj3oQBaZNwXVyZ8POi/leRI09UUNjgZqlWiBceqtnsTGkU0bSzx
	 M++OuoUuhraoXiSPE9VPUuNv6W0ZE+URTUrlkI/ckFIFFeq1MLHO965w54H8zJ/gkCnPA
	 U7QFRJ1XY08mXEyoFJIAIAleDA+Ons2a0DB/ZjbSUfOOZ2vaqMquh0xj6JbJ6wcVyTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="MzMZCc/x";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A39A606EE98;
	Sat,  7 Nov 2026 15:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MzMZCc/x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C35CC1F0089F;
	Sat,  7 Nov 2026 15:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063783;
	bh=xxs7wWlR9DlzGydLb2Wr1YPiAzyKTjmaEpfc9q+LwHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MzMZCc/xh1oTzIDbRtTpR1kKgHgJt5B5TK+BilpF6Ag3D1fbgBJBv5U5b0UL30P+O
	 D9VsSbmODcr9Yq3Vkp2WVEAwb3kUf3FjDVoDkLdbpQ6Zpyq5Yrfxh1e/hGVLOi2a8s
	 ATeDvZYQYjm4NvlBAW5Z7x5C94lrWbDZv3zjXZss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hayes Wang <hayeswang@realtek.com>,
	Linmao Li <lilinmao@kylinos.cn>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 847/869] r8152: Use BMSR to detect the link state
Date: Sat,  7 Nov 2026 08:58:49 -0500
Message-ID: <20261107134921.538099396@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Linmao Li <lilinmao@kylinos.cn>

[ Upstream commit 85b4bc79dde77aadda0929a22f3532b208a3e1f8 ]

r8152 detects carrier from PLA_PHYSTATUS without reading BMSR, so
BMSR_LSTATUS can remain latched low after link up. Since
commit f6f2e946aa4d ("net: mii: Fix the Speed display when the network
cable is not connected"), the first speed query can then report
SPEED_UNKNOWN, which applications such as NetworkManager may cache
until the next carrier change.

Use BMSR_LSTATUS in set_carrier() so a latched link down can turn
carrier off after the link has recovered. If BMSR reports down but
PLA_PHYSTATUS reports up, reschedule the link work to read the current
state without waiting for another notification.

Tested on an RTL8153B: NetworkManager reported 1000 Mb/s after 3 of 3
rebinds, instead of an unknown speed.

Fixes: f6f2e946aa4d ("net: mii: Fix the Speed display when the network cable is not connected")
Cc: stable@vger.kernel.org
Suggested-by: Hayes Wang <hayeswang@realtek.com>
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
Reviewed-by: Hayes Wang <hayeswang@realtek.com>
Link: https://patch.msgid.link/20261026012345.1902285-1-lilinmao@kylinos.cn
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/r8152.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 8cf4e81f8f882..7b9923b6480e6 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -6785,11 +6785,8 @@ static void set_carrier(struct r8152 *tp)
 {
 	struct net_device *netdev = tp->netdev;
 	struct napi_struct *napi = &tp->napi;
-	u16 speed;
-
-	speed = rtl8152_get_speed(tp);
 
-	if (speed & LINK_STATUS) {
+	if (r8152_mdio_read(tp, MII_BMSR) & BMSR_LSTATUS) {
 		if (!netif_carrier_ok(netdev)) {
 			tp->rtl_ops.enable(tp);
 			netif_stop_queue(netdev);
@@ -6815,6 +6812,11 @@ static void set_carrier(struct r8152 *tp)
 			tasklet_enable(&tp->tx_tl);
 			netif_info(tp, link, netdev, "carrier off\n");
 		}
+
+		if (rtl8152_get_speed(tp) & LINK_STATUS) {
+			set_bit(RTL8152_LINK_CHG, &tp->flags);
+			schedule_delayed_work(&tp->schedule, 0);
+		}
 	}
 }
 
-- 
2.53.0




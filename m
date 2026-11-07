Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065552;
	b=oL4mImH4pW7lef+ZWi01z9wxNS99IoHJwDP3SEjiyvNyiNnf2FkpJNAA4PbehmAfIPEE
	 fQKcgpiRWjxmE2xGjKrJTlXY+HTzZoERUo5Th/vACWWPmmHCQsyUv9TOGAGkskxQE2DUs
	 lSwSY6YM0RCpkJs1jiZ/l/YZluh3ptHpPkrSGVMVZ+7VjSdvC+D7CVuci1SEd8wJII22Q
	 zBdaBzPhzk1PfBG7Pe0GNsAT6Kmr7yOe3y5dzebRcer8lIWJRvUPeWd5aPwdNl1Boocoo
	 57iCCUvKPXzb2s5iHkVouE+Wsjt4iqdVsJmLn1t6OdGfDYjnpgG5Zdjoc6P8rzErneA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065552;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RyCzB0hkGXkOgw3bjqwrmZSL+l4k1wua9wtzmwqPpxY=;
	b=Df5wq33xmnrcZ/hXAy4ICL0+SPL7sGjiAUeKr4VrhUZqqZ7cVZNH2iRb5NMGM0MrA7Wb
	 MbJocyv3tF/I5BaAW7nypf/GpWgySIgLF4gl9yReeVX34EKyfaAv7zxnmHC26HjdaHC8g
	 hY/rTgznAM3XPeboCUeAKLCilFLdXYv0rtYtkm6f9fSGAbjLfnBPBW6TN9R/lDg74rMlN
	 K+c9geKSyKfsxRKwpYAjSBAULnt1Hviyzo9Vg8qkdqPlq4Jg9iuxGQ/0YQGS9uY0KjL/K
	 jB1uOF4CBZyt4pLSiGMhXcdjtbsFWr4JmN0J1RQGKmtIhacLc6IN9pjitgjLz4oBTYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=teF7Xwie;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 918D0606D814;
	Sat,  7 Nov 2026 15:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=teF7Xwie
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40ED31F0089F;
	Sat,  7 Nov 2026 15:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065552;
	bh=RyCzB0hkGXkOgw3bjqwrmZSL+l4k1wua9wtzmwqPpxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=teF7XwieBQnVpwdfzlW5Mrwh7j1LSCUlgVedKWsYN/C3mYE7JZB5zkdKzwSsGcnMj
	 8EqJcmKRjN9EHdH0OPeRNJOs8MR9DLLJt8UH+Ql4My8mexllEIBrq//jV4QdghTvlS
	 8E92D9awddap5duvaK3wu2jSdmHF9AvMpm/LvHEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hayes Wang <hayeswang@realtek.com>,
	Linmao Li <lilinmao@kylinos.cn>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1225/1257] r8152: Use BMSR to detect the link state
Date: Sat,  7 Nov 2026 08:58:41 -0500
Message-ID: <20261107135013.180780037@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index f61686433031c..398d35f6fb7b2 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -6979,11 +6979,8 @@ static void set_carrier(struct r8152 *tp)
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
@@ -7009,6 +7006,11 @@ static void set_carrier(struct r8152 *tp)
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




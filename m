Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704319;
	b=G3pp4wCc0F7CusGnU8kfPHbw5u5muT/a6y4diBgYUwjXSZo842KRIBgS4UdINagVdXvF
	 KcWZjX/OaPhA6J73eZtV23PjuFqsWwJkOljkmU/Rkhf0rXmcM5r5Opu/ofjDk6T2S0MRC
	 XMMD1SsRxUfo1WmLDggHdb12qYZN7JgVfZiirmtX4u4Qle048Kr/bGG9yV4/lkyyHUuhL
	 M54e2yQ/3JeruPPdediQcFx5KnffhlK9/oA3dM5LcSqiQRuoF9/nlce9saZlH19J7aRk1
	 m/zO7ZemIM1kj0aAzYgNLtvi/9HYI5ywwrw0HCOaM4b+y9LCecXJTtBIRz3un7U0IOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704319;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZDQc219x9r0U5qLQE9im6zI5ygsLYwFd+tCxKOq2azM=;
	b=oa49dh9O+Y94yDIzPQA7VNSmhbpbBPsxORZFPaYHUTqLyM9MjloigdCT5/OIwluCF5At
	 XcDVf3D4Hj8AsOajR0zqq7Tt3GNcwzdg9ColyY4+ocTEpQ33gh/u1r9oChKrVycYzze6P
	 pdcSr7FpuKKggjVtXoCsxRpBGIQso1vO+cUouQVBFaBJI8AINmoxy6Sk06tqhZtyIJSyz
	 0CCj4bYDZlRdydjoqVDYxHZEOOvjJeDxc4LOLpnau8IBGI1mC9p82XYzFv28TWwuB8wDX
	 yd0vW9toUdIOzYgLCLO54IWHC59FI/nI84p9wYcThJf8FVyIy0WlUs6RV4VK+0917/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uFiuHr4z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C3BB606A31E;
	Thu, 26 Nov 2026 14:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uFiuHr4z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33EE21F000C4;
	Thu, 26 Nov 2026 14:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704318;
	bh=ZDQc219x9r0U5qLQE9im6zI5ygsLYwFd+tCxKOq2azM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uFiuHr4zrqklNt+evP1AWstM+6UJuJya2WW/8wg7z3R3op4bBsdb12BdfEunyis1a
	 De9TVJH9Y+KE9RQn06mR+RnZmN6BVbAou9jroPgaZVBvTHKxIPOFFmq5sbsnOy18tY
	 445cyvFn9nG8SQfsCGI0jeZfNHAEi8ohhUMZ5HUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 081/265] net: ethernet: bgmac: preserve forced 2.5 Gbps link speed
Date: Thu, 26 Nov 2026 15:36:51 +0100
Message-ID: <20261126143610.695019521@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

From: Florian Fainelli <florian.fainelli@broadcom.com>

[ Upstream commit d4f3d2c04624854d27aa948cd7bfc9d946faaac5 ]

Northstar and Northstar Plus use a 2.5 Gbps internal link between the
AMAC and the switch.  BGMAC_FEAT_FORCE_SPEED_2500 makes bgmac_miiconfig()
configure that speed, but bgmac_adjust_link() subsequently replaces it
with the synthetic fixed PHY's 1 Gbps speed.

Use the forced speed when processing link changes so the MAC remains at
2.5 Gbps.  Together with configuring the switch IMP port for its 2 Gbps
mode, this eliminates the output queue discards that caused approximately
1000 TCP retransmissions per second during an iperf3 transmit test.

Restrict the platform forced-speed flag to Northstar Plus using the SoC
compatible, since Hurricane2 shares the AMAC compatible. Other platform
AMACs without a phy-handle must continue following the fixed PHY speed.
The BCMA path already selects the flag only for the Northstar family.

Fixes: f6a95a24957a ("net: ethernet: bgmac: Add platform device support")
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20261029211540.4123250-2-florian.fainelli@broadcom.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bgmac-platform.c | 3 ++-
 drivers/net/ethernet/broadcom/bgmac.c          | 8 ++++++--
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bgmac-platform.c b/drivers/net/ethernet/broadcom/bgmac-platform.c
index c2e0bc1326fe1..85e5bab286706 100644
--- a/drivers/net/ethernet/broadcom/bgmac-platform.c
+++ b/drivers/net/ethernet/broadcom/bgmac-platform.c
@@ -239,7 +239,8 @@ static int bgmac_probe(struct platform_device *pdev)
 		bgmac->phy_connect = platform_phy_connect;
 	} else {
 		bgmac->phy_connect = bgmac_phy_connect_direct;
-		bgmac->feature_flags |= BGMAC_FEAT_FORCE_SPEED_2500;
+		if (of_machine_is_compatible("brcm,nsp"))
+			bgmac->feature_flags |= BGMAC_FEAT_FORCE_SPEED_2500;
 	}
 
 	return bgmac_enet_probe(bgmac);
diff --git a/drivers/net/ethernet/broadcom/bgmac.c b/drivers/net/ethernet/broadcom/bgmac.c
index 34d260637c49f..a97ce359b53a9 100644
--- a/drivers/net/ethernet/broadcom/bgmac.c
+++ b/drivers/net/ethernet/broadcom/bgmac.c
@@ -1429,11 +1429,15 @@ void bgmac_adjust_link(struct net_device *net_dev)
 {
 	struct bgmac *bgmac = netdev_priv(net_dev);
 	struct phy_device *phy_dev = net_dev->phydev;
+	int speed = phy_dev->speed;
 	bool update = false;
 
+	if (bgmac->feature_flags & BGMAC_FEAT_FORCE_SPEED_2500)
+		speed = SPEED_2500;
+
 	if (phy_dev->link) {
-		if (phy_dev->speed != bgmac->mac_speed) {
-			bgmac->mac_speed = phy_dev->speed;
+		if (speed != bgmac->mac_speed) {
+			bgmac->mac_speed = speed;
 			update = true;
 		}
 
-- 
2.53.0




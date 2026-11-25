Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621568;
	b=J95JodhIjuOivo7BfcJW9GYurBhk6KRb4YszyVoL/PjPP9zOU8VKJD2mLPgNE+jzf4g7
	 kvBxIA5sHrkdenQuwNWl01in2YS9Rdxyqihdv2QsXE/5PQOGi6PrbqjSANR0rkutlbg5m
	 DeYqHotJRzaJebs0SdBm3zzioAqhtXudl5cGKZST3t6LFxSwrFqSraJB+wO3+iNGQ9GLd
	 byE8536zuNMlljaffiUiwOauF4iffgm5dvlQx24DxUelwD8ipVviboxbr0+9RcqGSPVPk
	 UJKn7A1H4XTf5KY3KlWZkTO3ZSD3Ck8A7ThTGKa0+2TQMDRdd8+ZJwGB/0s+6zkwZRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621568;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HHu1U82UaUW/LyehxqlxHPShUBy11FW9MxV9L0RIOkg=;
	b=BIfHT0yRhk1SFG7hQVW1318cewApeib60yBdPOl3/dj/MYP4l2JZQH1regqZ+j7BsDz0
	 EVaidKG1foVYGb2FTuipYOVchKNAO/WO5KQCJBkbfGNv/f1o8iOX5fI60mJU74kX20Niu
	 QFcja+DcHyMomdTyZFzXF39XMROIpALQq6wlRtE0Ew17iFLuf0kdG4J523nfOIpEL8C+0
	 h6dUWUtWE3bl+HQv24tRiURCaktuEh+AOvx3pQSp5nIoEYyN/i/99gAGb43QyB9AzmqDN
	 FTEg2iOP3Ac6jIOgTaKCWg5X0mHBfLOVSCSoXsaraj2nFJ52abSqVALg9tbZ/+aY2tQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lO4KQfR0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C332606A321;
	Wed, 25 Nov 2026 15:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lO4KQfR0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 328421F000CA;
	Wed, 25 Nov 2026 15:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621567;
	bh=HHu1U82UaUW/LyehxqlxHPShUBy11FW9MxV9L0RIOkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lO4KQfR0j61wYmQBX/va9OuUYjtO+e3guqVgPDkZAzcq02CxGG6Ca9UJHCauzA/Vj
	 fO4P++8jnRE4PNuIp2eUvV4tr7qDHRbUO6ievRaX0fpdzYdMVAstMtBliRhM/ZTxrH
	 ggHh7Ge7KQTXw/9AsKSW9AvIVsdftSQZOC13OkDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 268/990] net: ethernet: bgmac: preserve forced 2.5 Gbps link speed
Date: Wed, 25 Nov 2026 15:27:15 +0100
Message-ID: <20261125143828.372520989@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
index 4e266ce41180b..4880b18904812 100644
--- a/drivers/net/ethernet/broadcom/bgmac-platform.c
+++ b/drivers/net/ethernet/broadcom/bgmac-platform.c
@@ -243,7 +243,8 @@ static int bgmac_probe(struct platform_device *pdev)
 		bgmac->phy_connect = platform_phy_connect;
 	} else {
 		bgmac->phy_connect = bgmac_phy_connect_direct;
-		bgmac->feature_flags |= BGMAC_FEAT_FORCE_SPEED_2500;
+		if (of_machine_is_compatible("brcm,nsp"))
+			bgmac->feature_flags |= BGMAC_FEAT_FORCE_SPEED_2500;
 	}
 
 	return bgmac_enet_probe(bgmac);
diff --git a/drivers/net/ethernet/broadcom/bgmac.c b/drivers/net/ethernet/broadcom/bgmac.c
index b3f0ecc583fd5..409155fe8df0d 100644
--- a/drivers/net/ethernet/broadcom/bgmac.c
+++ b/drivers/net/ethernet/broadcom/bgmac.c
@@ -1428,11 +1428,15 @@ void bgmac_adjust_link(struct net_device *net_dev)
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




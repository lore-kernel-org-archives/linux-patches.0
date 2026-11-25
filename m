Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624519;
	b=DrdM2dEH9LkVNz2iMmhBp36oVkVcSgGG0KnMi1UdBCBwTscFcnYSPWI99iHjbwP8140j
	 quwxxw6mf6RIGrlt/7gXuegsRM/t1SXd6Vi+IQBy33f7jKZnTBa1QebmebCOxjr84oEF3
	 XlHWG4nM3113c3OSwwJrQgm0YL5qa9CABNZgcO6kSXRD/61n7OSC5yTGv/vbw9s/Ricil
	 osfjuKy8fjHFIVp8ZDqqgJY9KzuNII4RqMIa193kbjoHPbHdF3vW8GVjaJ30i57+xDRVQ
	 rZch+EDIUGTmLzxmR83nbeKtubBVmw2kKkU3g8SychJWzPZXZYp+8G+kUililnJTKCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624519;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+FdTdWZ6DQaTGjxbu4UTJt+dBLqIXkm/D53LZ/YmH88=;
	b=t2VBSCgCUio1hdCq3QjeNXWeJXBpExLFa2DkD1NjwVs2eMsYM3ir/DSULN3MILyu720g
	 moi511zrGhhWjCo+Dp38rTbKtU6N6Cs+iZUifYbebBGQxacbfRn9cunBxJQNepPuOXZom
	 tJgCA6eVeTrA7qTqdkZ5r05bPrcrL8W6+jlSdNvrJ2HhRgXshLaJ8oPUqnAEjhf44w0a8
	 1aeqErtmhVwvVE+Lqh+tyP3sHFBQFRUwxMyBEz9wxdWa2KBW7WY0mfdHP/QTZ5PqayZg0
	 P65fiLHUR3wZncxnqcxQYCOrpvkg7BPi4HYbcvhGN6Dk3DfEfm7df1hnGGNHjTeMkag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h1vapRCY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 728E0606A681;
	Wed, 25 Nov 2026 16:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h1vapRCY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 232891F000D1;
	Wed, 25 Nov 2026 16:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624518;
	bh=+FdTdWZ6DQaTGjxbu4UTJt+dBLqIXkm/D53LZ/YmH88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h1vapRCYRT2K6TtEp+G0Z/+YSgQKipj4j+dw5z8n2RzOkWYaWQgdANJ8sbJcsgDHE
	 NgjHfC5+jXdyi9owkqsvOdj2ZD/hXDxi7wJNVe84qNn1hyFUUvLfj7xCmuF5Z5A7ba
	 WpSR8TlpBb4K1Obl6gSHY3LSRY//ZIa6HRz6hblY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 217/816] net: ethernet: bgmac: preserve forced 2.5 Gbps link speed
Date: Wed, 25 Nov 2026 15:29:25 +0100
Message-ID: <20261125143854.225791575@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 78f7862ca0066..e6beddeaa8c1c 100644
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
index ece93043c506e..c4ee811afb9e6 100644
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




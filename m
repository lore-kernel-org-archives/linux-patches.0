Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618486;
	b=Dap+m+tsm73OjXax8H/p4jYhhvSdObWhw0QWkP//AEseJnxGAka2OwjT0sr98803J5d4
	 ObGd1TLIWiADxiRRm2MyXn/YPE6rOkCXCxTrJuEvCaklK+dOeUXQYXMn4u0W+ZkfqTLet
	 12yS5hhCCC9k8maesmSz30JNkFa1ktLcDP9LkBoPBq8/ExXrdA/eFJwzNZg0cJHLLdLE0
	 0DtkR2hLeOPiqN4YCNfmepe2xFOHvmICB5M8bL3G88G6cG+17c37R/V0ikaQg2SNocFSF
	 dqYZazEsLQFpRc2Yg3BKuzY+l0uvMPJJBYfnZGmpZpWFFUKIXItiPIO9MdFV7VROfMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618486;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7Fe5cKBEEkvr6fhfQeXUG71kEQSG8QEscYR6eZ/KO3A=;
	b=GCjTpKtLxTEzjjD+bWpr8nJNuzVgcne5TF6RQEnvqWoQaYLvXpp1L2f6Nja7EnBh+sX8
	 pT+NjpBQ2aXLM7gtPzrMcDpJ+aWkLmBXfekO1dolN7u6mp0JFbX6rPYDwF0AfnPui2C3G
	 k2LcwZaytQnVlYVYB01JrYetkaIPsPZtQofsw54AsroRaKEKXvRBHMdxlrmU8lP7h+JHZ
	 82QsJWB68V0duyGNThYJQZXwWdG5/x5sBnE4kKFl9CVk+xnZyaeDFAw1WdozcK1otDpsf
	 lADX5qY708H70Zd3HYT0mPrRdRqGDgikY0TayujcofL3ouJddloQ9N+EjDXxfk0kG2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fH4Vjf6A;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C775606A321;
	Wed, 25 Nov 2026 14:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fH4Vjf6A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8F321F000C6;
	Wed, 25 Nov 2026 14:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618486;
	bh=7Fe5cKBEEkvr6fhfQeXUG71kEQSG8QEscYR6eZ/KO3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fH4Vjf6AYk/JtHqsYAdAQBBkQ45Bh2UPvlGgNiNMqdTvQ+li2dsHm+bhfIKk+Ixwd
	 CQzghj5kA50o/ylqeiCRnmQqmDma1F7XX3mfuzxF8W3stNwZSKF5HIe3MtSo/IpLTO
	 DwATBHXnhYvcB0wgNHzz7ADP15N2eeGrJ44kMcP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0294/1005] net: ethernet: bgmac: preserve forced 2.5 Gbps link speed
Date: Wed, 25 Nov 2026 15:27:12 +0100
Message-ID: <20261125143828.622841974@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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




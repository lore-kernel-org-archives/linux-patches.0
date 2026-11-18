Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025228;
	b=V2u/dqiD5NS6IexVRlUAG3bWHcInXTtsCoHeoUC31WEXpLWRA9sP3BvKLyDa0WTY+h2e
	 uzjptDJPe/LuGDPkozIDo9r5oK1wcP6Jc/CmpfGk4IfWsox11+sTQdbVZr1ehOQnhV/EQ
	 m78NYQMGMFN73nRmvsFmGP0PFy7Akmm1bZG0xqzmhBNLNIAlRZaRX5C69pFvwG0IUjZbC
	 LrxKaIw3ZrKHF0tJ/4u30ZKMX0wx5OR/ms9OABoVJa3PKJE3YKIDY5mMFam5hcZ4liitr
	 OXuLCD0hKGXu1lu58LMAR+IrHe78VupzoW+3JL2xvrq/jRaQQhKbvB/yybMX6wWAvCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025228;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yAe5uqxghX5djxWTaj2JFarAgBBn28s0qARQUfK8mCI=;
	b=X7cnXIBJTxznl5T8iC2HeUsvNfTb3RE1asDlj3AEuejhEAVee0eKyYuYKwg2p/q14y8Q
	 ZAlMqLz+mIJ5GCjsnjwdscE3JGJA0Tz2BOulwHNb0sXsaonxL7j70svtmDOAFoVKhLlBx
	 Clf3DSzwMvtFlvzFp9dRe+IpQIuEz2o3VHikob8qynsgIqSmczWetlcG9O9kExwFnAOnm
	 ocfCJiols5127w6zqw5ls9e5rXO48273FUrQSzRBQEpqhR2B1IRvm19wK/BLemZuTafYl
	 bqQ+lqnq/oHiwcfN2XeqUsrha3JGllIhoTLsj3/yYpKszNDtGDhu1gXNVr2Tx3JouIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xON3rgu7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B67606A320;
	Wed, 18 Nov 2026 18:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xON3rgu7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0B491F000CE;
	Wed, 18 Nov 2026 18:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025228;
	bh=yAe5uqxghX5djxWTaj2JFarAgBBn28s0qARQUfK8mCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xON3rgu7yVUtxfQVHICnONJDUVjFIdYKKT7oN4FDqbzmsw2qhcoFQWRWg2yHvnwRM
	 LMuJ4muxdljP4rTceDghnIDxlYLh9sZwhGFeOxh1Z/S1c/q5Xuyhe7+4lMgkXUn5st
	 wdfbOReTFjVdx+0935FEZTz/emuIKCr3ksfs4MjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Igor Paunovic <royalnet026@gmail.com>
Subject: [PATCH 6.18 1004/2151] phy: rockchip: usbdp: Rename mode_change to phy_needs_reinit
Date: Wed, 18 Nov 2026 15:45:39 +0100
Message-ID: <20261118150159.010602689@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Sebastian Reichel <sebastian.reichel@collabora.com>

[ Upstream commit fbce9cc28cadb24026a6c061819d42e50d3bfea0 ]

Right now the mode_change property is set whenever the mode changes
between USB-only, DP-only and USB-DP. It is needed, because on any
mode change the PHY needs to be re-initialized. Apparently at least
DP also requires a re-init when the cable orientation is changed,
which is currently not being done (except when the orientation switch
also involves a mode change). Prepare for this by renaming mode_change
to phy_needs_reinit.

Tested-by: Igor Paunovic <royalnet026@gmail.com> # Orange Pi 5 Plus
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://patch.msgid.link/20260915-rockchip-usbdp-cleanup-part2-v15-2-8d507cb1174f@collabora.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: cf3aa34e6f07 ("phy: rockchip: usbdp: Avoid xHCI SErrors")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/rockchip/phy-rockchip-usbdp.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/phy/rockchip/phy-rockchip-usbdp.c b/drivers/phy/rockchip/phy-rockchip-usbdp.c
index 0a3a75b75d422..c73722ae185ec 100644
--- a/drivers/phy/rockchip/phy-rockchip-usbdp.c
+++ b/drivers/phy/rockchip/phy-rockchip-usbdp.c
@@ -170,7 +170,7 @@ struct rk_udphy {
 
 	/* PHY status management */
 	bool flip;
-	bool mode_change;
+	bool phy_needs_reinit;
 	u8 mode;
 	u8 status;
 
@@ -590,7 +590,7 @@ static void rk_udphy_mode_set(struct rk_udphy *udphy, u8 mode)
 	if (udphy->mode == mode)
 		return;
 
-	udphy->mode_change = true;
+	udphy->phy_needs_reinit = true;
 	udphy->mode = mode;
 }
 
@@ -963,8 +963,8 @@ static int rk_udphy_power_on(struct rk_udphy *udphy, u8 mode)
 
 		if (udphy->mode & UDPHY_MODE_USB)
 			rk_udphy_u3_port_disable(udphy, false);
-		udphy->mode_change = false;
-	} else if (udphy->mode_change) {
+		udphy->phy_needs_reinit = false;
+	} else if (udphy->phy_needs_reinit) {
 		if (udphy->mode == UDPHY_MODE_DP)
 			rk_udphy_u3_port_disable(udphy, true);
 
@@ -972,7 +972,7 @@ static int rk_udphy_power_on(struct rk_udphy *udphy, u8 mode)
 		ret = rk_udphy_setup(udphy);
 		if (ret)
 			return ret;
-		udphy->mode_change = false;
+		udphy->phy_needs_reinit = false;
 	}
 
 	udphy->status |= mode;
-- 
2.53.0




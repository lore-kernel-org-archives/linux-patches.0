Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018371;
	b=vPI4Uka0xnTt9N3MebIFYY63wSe5rYZYNwudFiGx/Bm9eGEC9FaKoyUhV2BapPMR2lPA
	 VtGznELwhv/7/Gw9YRjKU3WyNwMBr3jG8IENPw87V8qB1RGGgr0dGV+U8J64zd31s50Hx
	 XjLUK+tqlimrp4JLdbBoQxm2/4lw49CrYW0WeHdtpIZOw9K9mVz60m8kN4b+5ovo7i1m6
	 0OXi5yqS5yAw2LddWP4W4FPxaF93oId2/mj2y/r92Le/oDST3pPH/VApBWTUDLyDUulc+
	 EittwutwFc3zKrdhUAOjxL/9DAk0QpMnfCeYyzuULOX3MciqLh7gT0aWg91xOMwR0IQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018371;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gFfZdCc+QHF2fxt4CyCGA50fLqJ28DIx1fHkL3mvwNc=;
	b=yR/TveRaZsIBe1erl/tJ3NnKUtwgFaXmBrTTBMN6XrO8gIPmrleeo0iduT/RM20d+y6C
	 JlZqd+6+Dn1l9BcUjPgo9qHZV9WgkJsg8KU0aC8aNr3nNri99mqQUy1BSlcxR/38zDyYI
	 1PwPoXiNB14MZ71JXTKmyACPHPbKEPOYMoAJL95sZEK1Z4O1+OEXWOlQ8H4/+YcI8p6pT
	 bdYCppirBePOZoSdaVKHffGIuHFAuh0cOyIKy5vSoZxUDq+Vw6u8a71clQ6JDN28rDbvS
	 72D12dmVYE7cJxDYF+D6qPpT9rIg+YawT5XcnSAS/b5L1+brDr2pI7k+9U4a9IKkvrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ovGnLR8g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAA5A606A32A;
	Wed, 18 Nov 2026 16:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ovGnLR8g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DDD91F000C4;
	Wed, 18 Nov 2026 16:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018370;
	bh=gFfZdCc+QHF2fxt4CyCGA50fLqJ28DIx1fHkL3mvwNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ovGnLR8gIDcDwhjKM8+LyXanCGiXnsJRbCMjJTWRkM5vozwINRXqXDyvVGBbmF9tK
	 hzZ4FWHyqeoUFxnUwjZEZptibjLCgDMHI8p1UlnBSLpaVB0iNh8powAz7b746TMWVQ
	 bBeVBf4V9eK5zaJx2nXLR4CIqIw3ecHhATaoUCF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Igor Paunovic <royalnet026@gmail.com>
Subject: [PATCH 7.3 1214/2651] phy: rockchip: usbdp: Rename mode_change to phy_needs_reinit
Date: Wed, 18 Nov 2026 15:40:54 +0100
Message-ID: <20261118150331.706047629@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 13c74d62b7266..794f7112c1f15 100644
--- a/drivers/phy/rockchip/phy-rockchip-usbdp.c
+++ b/drivers/phy/rockchip/phy-rockchip-usbdp.c
@@ -169,7 +169,7 @@ struct rk_udphy {
 
 	/* PHY status management */
 	bool flip;
-	bool mode_change;
+	bool phy_needs_reinit;
 	u8 mode;
 	u8 status;
 
@@ -589,7 +589,7 @@ static void rk_udphy_mode_set(struct rk_udphy *udphy, u8 mode)
 	if (udphy->mode == mode)
 		return;
 
-	udphy->mode_change = true;
+	udphy->phy_needs_reinit = true;
 	udphy->mode = mode;
 }
 
@@ -962,8 +962,8 @@ static int rk_udphy_power_on(struct rk_udphy *udphy, u8 mode)
 
 		if (udphy->mode & UDPHY_MODE_USB)
 			rk_udphy_u3_port_disable(udphy, false);
-		udphy->mode_change = false;
-	} else if (udphy->mode_change) {
+		udphy->phy_needs_reinit = false;
+	} else if (udphy->phy_needs_reinit) {
 		if (udphy->mode == UDPHY_MODE_DP)
 			rk_udphy_u3_port_disable(udphy, true);
 
@@ -971,7 +971,7 @@ static int rk_udphy_power_on(struct rk_udphy *udphy, u8 mode)
 		ret = rk_udphy_setup(udphy);
 		if (ret)
 			return ret;
-		udphy->mode_change = false;
+		udphy->phy_needs_reinit = false;
 	}
 
 	udphy->status |= mode;
-- 
2.53.0




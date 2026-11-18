Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030725;
	b=EBePVw3/pXhHrS1ybzPLbaZ2JcTJFEmqOuOwbXpR7dqBTwePLy+tO1kJFY35rxE9rFbk
	 IvKbqmUKFK7zeg3Hqogr4CCX6B4X7wwuZ3ycCncAO0l4Umeqj3T9759uSNyASJNyyo5/H
	 Ib/NgcbMMFxR/QSYExM7Ln9qhC9d2zs+k7QM5iQppAkHK+9Dy0Le0S20qYA1iQml5ymFX
	 4cJF0ruwzofsFYvDgMhmynqCnjgrD3JFJ9ygPIxVh23qJM5sTXJsyNaENj8sq5Bib0iYx
	 CMGLYWbSh9pI9j878NVEn+Vy37BbRM8VprleSaLahxpZpjKzxMxu7cd9TsB9Sf5l70g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030725;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=crFoxFanT2/9FWLE2u2nxcotxqQqV2rgC5ojBYDwVm4=;
	b=tnDMD2CYdxMKreEiEWva1UjI2CdAfENiqq96YTPL/fwB1CqTD5PR4JgtOnz5f2o//4w3
	 8MYatONssJCV419H3951gBT1ATNhPBDr0v3YV69WxBsMaW6VhcoZivqDWbknPx6IHN8QR
	 e9vsaS3KIWLlPOAav+zjbW32iT63P9IT4KGIw48bytDRP2t0eJex6qPMEFqjL2PChTE7h
	 W9r0eEzIPB0nF5WpkYj0euEibyAUqvBUbVm7Dg1Sl018MyZYQJt0Fz/DajJLbivrc+K02
	 iEHuv7W/OlFmlw9hHMNauhb806b9vrA5RfVsMQKWd+7XkT2vlVQe0le8BMRy1QUpJZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ue6Zv1fB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7335A606A333;
	Wed, 18 Nov 2026 19:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ue6Zv1fB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C813C1F000C4;
	Wed, 18 Nov 2026 19:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030725;
	bh=crFoxFanT2/9FWLE2u2nxcotxqQqV2rgC5ojBYDwVm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ue6Zv1fBh8ojSYx9m/y+eQJR84A+tYDCmrNWTa0ZRH3cy/jN3E+j74IQNnT+/flbp
	 5K+axo5tLwAMda7aCNugvVCsUHjPTWAx++wlLjwuwTnpjdQ86WLXsJczdsuCr1xz4I
	 89U2x2m3lNGDlvMXSDzNHi/Vjjh0RPjzIQwZ6s30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Igor Paunovic <royalnet026@gmail.com>
Subject: [PATCH 6.12 0789/1756] phy: rockchip: usbdp: Rename mode_change to phy_needs_reinit
Date: Wed, 18 Nov 2026 15:48:36 +0100
Message-ID: <20261118150041.121663143@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index f611018171e34..b256672b3405b 100644
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




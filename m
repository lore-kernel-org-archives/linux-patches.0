Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030648;
	b=JeRxK74psOfC0ZTfz05mRwICmZR+HyAkQCeBHvAieD7onD7VF3BJSCMzTRdFemaWLx28
	 QBPu2u9o1+Wz0a4cKzaVnCoGZmMsQkAFEzdGkyrjVKwOkZB2bHkmhUq3kcFpJCSuZ0Wsx
	 AF4/fS8mlIAZUMr6PvgiqIhcFGgGYnWmyGtJ25jEmFsSJYMqgtkoPXfX9GaOz6g8Os3EB
	 mJ3iItg6ilvYUbJeKXn9o+9L3i+bsH7UOw7pm0/3JN7wCuOm3nqPIxs9jy502g90cCvy5
	 9MgfPinXuFgZjrXH7k8+Lkm/akcazfrBuFN9KZz2zmgRdmWU3MrWSIaEJDMD+UxPCBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030648;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WXYYN1QszN9wRgr1O4mtS8BxA/nXPHg0ezpt1zIpXZ8=;
	b=CIzk6K1QzqF4vF/P9eGTmG/FzTA2cY6jSOPkA1SK1w6sQcHd7pOIXb3/dbSLnO38YnHb
	 sPZNykJeTBqrtvrdy9wEwO/irahPsJcK1/+oSLbLw10zHVnOuFQFxHbhpFXa4ZAy3kHPD
	 xK9uW8l2P76bqjFhc8DGUr7Pn96ZYGJ3vxjP5V45lHYCDxz8+zKCXyVzrbAaWOHGW1mzl
	 sYSIsE6s7EjgAPKsPi/a11oPHgSRwu+T5JuBU1IBp74gQSujlDKowanAP4LwjuVmrWyzh
	 p6cPX1vd0akm/pYxExt63sIdtnpYEzYzC0Svymfq5DKfvuOQJxjNkMjf1jJiq7UcTjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="sqcqzK/X";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD318606A31C;
	Wed, 18 Nov 2026 19:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sqcqzK/X
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A9961F000C5;
	Wed, 18 Nov 2026 19:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030648;
	bh=WXYYN1QszN9wRgr1O4mtS8BxA/nXPHg0ezpt1zIpXZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sqcqzK/XRjQFmXfyC6o+i6+LfcnzPy84pBToXO8F7GWzlUsXmeYBCxU4zWHg/uv+q
	 Fu8RJnckYzYWif1ANX/LELouZjFIMY/7rkYod83J7XRg8gX0dHB90diDEQUl9pVFjz
	 Qh/jqIO9NWGS4KHIa6hgL+Xauv+2qV2F52LOEbL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Igor Paunovic <royalnet026@gmail.com>
Subject: [PATCH 6.12 0778/1756] phy: rockchip: usbdp: Do not lose USB3 PHY status
Date: Wed, 18 Nov 2026 15:48:25 +0100
Message-ID: <20261118150040.586853639@linuxfoundation.org>
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

[ Upstream commit b322403c294b67fd6bcf6719b4fc9f8a9e313129 ]

By default (i.e. without manually enabling runtime PM) DWC3 requests the
USB3 PHY once and keeps it enabled all the time. When DisplayPort is
being requested later on, a mode change is needed. This re-initializes
the PHY. During re-initialization the status variable has incorrectly
been cleared, which means the tracking information for USB3 is lost.

This is not an immediate problem, since the DP side keeps the PHY
enabled. But once DP is toggled off, the whole PHY will be disabled.
This is a problem, because the USB side still needs it powered.

Fix things by not clearing the status flags.

Fixes: 2f70bbddeb45 ("phy: rockchip: add usbdp combo phy driver")
Tested-by: Igor Paunovic <royalnet026@gmail.com> # Orange Pi 5 Plus
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://patch.msgid.link/20260915-rockchip-usbdp-cleanup-v15-3-80e2c11d1ce8@collabora.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/rockchip/phy-rockchip-usbdp.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/phy/rockchip/phy-rockchip-usbdp.c b/drivers/phy/rockchip/phy-rockchip-usbdp.c
index cc798a8344eb8..469908926d5bf 100644
--- a/drivers/phy/rockchip/phy-rockchip-usbdp.c
+++ b/drivers/phy/rockchip/phy-rockchip-usbdp.c
@@ -1008,7 +1008,6 @@ static int rk_udphy_power_on(struct rk_udphy *udphy, u8 mode)
 			rk_udphy_u3_port_disable(udphy, false);
 		udphy->mode_change = false;
 	} else if (udphy->mode_change) {
-		udphy->status = UDPHY_MODE_NONE;
 		if (udphy->mode == UDPHY_MODE_DP)
 			rk_udphy_u3_port_disable(udphy, true);
 
-- 
2.53.0




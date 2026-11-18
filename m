Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025197;
	b=vg4/b2JddkA6wabtkDDLSQtUV2VXfMtaSCgji/pHZGQVhROp8surQG9KnVLVw3s4cGwL
	 0ybIO3wigag8ETcIaZ1AfaCl6xCIiwmjBKnY0oVSOTewRvqbaYbYFlCXZbcFbXHXaDxJZ
	 B9lMBZf7fjy7FkltmBoQPauc3rw6eQxygcaaEQuKaUjxq5ShLarSfWfCClbyzUBPhqGdF
	 A/ifkuWqBYjm4vaQ2JNu0tW1A943VyUwiEPsUCBNLzwg1KLZ3XkqawwZUOqosy2pivt2j
	 Y+OIn0gEbJuWMNopm5kVipfuccWr/lLtEyUQXZnv4XjWMPQpHHFNk60EHTN57yr3h7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025197;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bG+0f9AKRutAZgro1LwyplmmJQosAuQRKsH4xPIR1sU=;
	b=r1wqUT2KvUczqPjy+a7TQoh2LQjJhAEa+fBi1vyiPo09i1ztGK9CAbH43bK1vrAymXQJ
	 nKWs/tZlx+ckUxjQCPrM5IoGxA1WQUCizkf7liWiDY8fj8aFKS4SR1uQRtTZTqb/t334Y
	 CYImMS0A5sDMteo/z357J8ws/W6GhezLf+mza3FDOssccc0/B7w3QbHU1tAxpnPqh0ZK2
	 tgvw0nzIu36r/5jxu01VfVo5SbiC/wuEIKNsu5BMEQ6wtft4a8xTH5AnGoKosvV+ehPUA
	 B7uVLPEHVOH8DVvc5GosDy/zBhIWZEpnACzrCKMx0FiLsVK6O+Xw/uiheNdOTMFm52g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fBfICyJN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F94C606A31C;
	Wed, 18 Nov 2026 18:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fBfICyJN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA7191F000C4;
	Wed, 18 Nov 2026 18:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025197;
	bh=bG+0f9AKRutAZgro1LwyplmmJQosAuQRKsH4xPIR1sU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fBfICyJNs425WhVlujQoqyqSnhlK52g2uTi4N0yxDDQRklC/ReCbEekf4sYcx7Rlt
	 w2qlSncGQJKOJRcGL0e8fQ5Pkfc9PUScamXHrZuwDKQpfd09J845+/TVWW0uT8YTXG
	 7dTi0/6DTYwTB1ovPcFpHs6ONcYmd52PKONqk9ho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Igor Paunovic <royalnet026@gmail.com>
Subject: [PATCH 6.18 0994/2151] phy: rockchip: usbdp: Do not lose USB3 PHY status
Date: Wed, 18 Nov 2026 15:45:29 +0100
Message-ID: <20261118150158.660086907@linuxfoundation.org>
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
index a5ffdf7a6e76b..12dfdd470a782 100644
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




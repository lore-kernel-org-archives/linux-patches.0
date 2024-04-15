Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A24A469D0A;
	Mon, 15 Apr 2024 14:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191097; cv=none; b=WOcmuhy6evxOOAbmM2Xg/r+4D7ExEBakfxRtJ61Sf/UkKH/VS2NuSjah4mq3C7BJtD3aNvdYs6kRq1aQGHhn6gfVInoL9ThME6Ss+rGBcvYvPcreXKYKmZlYsNzM9IQ2MxRHBBAy++pYjp/PRWf/HArINBkr4AmFOqRzQmR9qpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191097; c=relaxed/simple;
	bh=PbyAaMuTB7wokUF525cn7LDJpbr1QutStoiJzMBeI44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qXDQt8eS3qlHNkoyiY90j8FyjuqkbAC3nCn29CLFvyi6obXJts5F0vH16r7vZPD3YLtR9cTAIU0c0nPyPLjH40lWcS3ZfoNHQOMmKhtFhEYN3J9jQQkp7NbtAg/VEYdse7edXji4xhXxVLjsyTSZlovJvnSNaEyK0Qx5MFb49og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZTc68eDf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZTc68eDf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A38CC113CC;
	Mon, 15 Apr 2024 14:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191097;
	bh=PbyAaMuTB7wokUF525cn7LDJpbr1QutStoiJzMBeI44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZTc68eDf+PMvkiVgSq24Iv/JPGfo3HA51kaB0xfY8XJeeoncTTeNBcDGN8zXq3QyO
	 EiT/gX4UTu8Yj7mZd9pdp5AC4mLv4yXW3YPzecNdunECDLlvw9bwFdJCCg9EaIRmzT
	 Skcjaz1E6OHgVUResBkGSmBMs5TVdXU9fm3S/s6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Harvey <tharvey@gateworks.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 031/172] arm64: dts: freescale: imx8mp-venice-gw73xx-2x: fix USB vbus regulator
Date: Mon, 15 Apr 2024 16:18:50 +0200
Message-ID: <20240415142001.380521804@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tim Harvey <tharvey@gateworks.com>

[ Upstream commit 6f8e0aca838e163e81fde176e945161d50679339 ]

When using usb-conn-gpio to control USB role and VBUS, the vbus-supply
property must be present in the usb-conn-gpio node. Additionally it
should not be present in the phy node as that isn't what controls vbus
and will upset the use count.

This resolves an issue where VBUS is enabled with OTG in peripheral
mode.

Fixes: ad9a12f7a522 ("arm64: dts: imx8mp-venice: Fix USB connector description")
Signed-off-by: Tim Harvey <tharvey@gateworks.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-venice-gw73xx.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-venice-gw73xx.dtsi b/arch/arm64/boot/dts/freescale/imx8mp-venice-gw73xx.dtsi
index d5c400b355af5..f5491a608b2f3 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-venice-gw73xx.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp-venice-gw73xx.dtsi
@@ -14,6 +14,7 @@ connector {
 		pinctrl-0 = <&pinctrl_usbcon1>;
 		type = "micro";
 		label = "otg";
+		vbus-supply = <&reg_usb1_vbus>;
 		id-gpios = <&gpio3 21 GPIO_ACTIVE_HIGH>;
 
 		port {
@@ -202,7 +203,6 @@ &usb3_0 {
 };
 
 &usb3_phy0 {
-	vbus-supply = <&reg_usb1_vbus>;
 	status = "okay";
 };
 
-- 
2.43.0




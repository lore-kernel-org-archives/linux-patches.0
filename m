Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73C703BF2E6;
	Thu, 15 Jan 2026 17:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496958; cv=none; b=QZn2XRgdUlKEr+8MreOlOWEfX3KchKtvaDnHmTEHvNx9f40oexTM1QOlrrI6/8AiFds2R7utiincxknnIC6Z/9xiNtAo9bML07PxVhLzJvoGUvF7RzXvzfnbJ4vbPvWEdv4giyLkWZzd2fkRynqRRL4L/PchgSpu37hnj3YglXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496958; c=relaxed/simple;
	bh=EXAIGNbjeJoNcXKoWO17xLj9LDDwdLUQRbTSac0dD68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ftDpEDJDx3ARjpZ/+usi+ZnOLAgOOA2SkqusM7dxe7OePZ3UtJ6ll3uQ50PSqHNbFrrIU6n0rVPlebkWReCgsKh039QxkYyNBy8ufqfaT1tXrpRrbh17lgldKA3S+jENI5VW0/2BTUU2h7cse5LVsJSMpbRWdhb38zhLUealAaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t1dk+yMl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t1dk+yMl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98483C19423;
	Thu, 15 Jan 2026 17:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496958;
	bh=EXAIGNbjeJoNcXKoWO17xLj9LDDwdLUQRbTSac0dD68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t1dk+yMlpeqPFoHWc/yLSoQNWUN+COkxYyvAnGWuLt8Q39BzZg+dEkndyMxSxdnFK
	 oFOM+kzpwca7PNMGcy2fzUTX4WpCqlTuwn5D8dCbgiw5hiIbzJ9tqXT9mrW7lyPIUc
	 xvi8Ep0rdEY6zWlueVCdoviwyr2c4A+0gRbacNr0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marek.vasut@mailbox.org>,
	Christoph Niedermaier <cniedermaier@dh-electronics.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 42/88] arm64: dts: imx8mp: Fix LAN8740Ai PHY reference clock on DH electronics i.MX8M Plus DHCOM
Date: Thu, 15 Jan 2026 17:48:25 +0100
Message-ID: <20260115164147.833812031@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164146.312481509@linuxfoundation.org>
References: <20260115164146.312481509@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marek.vasut@mailbox.org>

[ Upstream commit c63749a7ddc59ac6ec0b05abfa0a21af9f2c1d38 ]

Add missing 'clocks' property to LAN8740Ai PHY node, to allow the PHY driver
to manage LAN8740Ai CLKIN reference clock supply. This fixes sporadic link
bouncing caused by interruptions on the PHY reference clock, by letting the
PHY driver manage the reference clock and assure there are no interruptions.

This follows the matching PHY driver recommendation described in commit
bedd8d78aba3 ("net: phy: smsc: LAN8710/20: add phy refclk in support")

Fixes: 8d6712695bc8 ("arm64: dts: imx8mp: Add support for DH electronics i.MX8M Plus DHCOM and PDK2")
Signed-off-by: Marek Vasut <marek.vasut@mailbox.org>
Tested-by: Christoph Niedermaier <cniedermaier@dh-electronics.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-dhcom-som.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-dhcom-som.dtsi b/arch/arm64/boot/dts/freescale/imx8mp-dhcom-som.dtsi
index 2e93d922c8611..2ff47f6ec7979 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-dhcom-som.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp-dhcom-som.dtsi
@@ -105,6 +105,7 @@ mdio {
 		ethphy0f: ethernet-phy@0 { /* SMSC LAN8740Ai */
 			compatible = "ethernet-phy-id0007.c110",
 				     "ethernet-phy-ieee802.3-c22";
+			clocks = <&clk IMX8MP_CLK_ENET_QOS>;
 			interrupt-parent = <&gpio3>;
 			interrupts = <19 IRQ_TYPE_LEVEL_LOW>;
 			pinctrl-0 = <&pinctrl_ethphy0>;
-- 
2.51.0




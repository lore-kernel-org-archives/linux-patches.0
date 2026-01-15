Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EF3C2FDC4D;
	Thu, 15 Jan 2026 17:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497086; cv=none; b=tN5vY1vWv9Aq1d2s1sxZjpKWWg6E7aWfb4J3H1QI7caPxaJumcMs7G6yvexa4EKDvCbBiWGJbSTaKwbK8z6PMsiiEx5GrVmqGs+1ajuNm3EDO/uKEHudDHejy/ilEHP8/FHGS6PlihJnR0gxZaqw+ZjSrio7gS+NlBawFetA8v4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497086; c=relaxed/simple;
	bh=XIpV642ZCNC8CnRxGPFt9T82rkQptv90S3D5S8QChBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bwvk4bPpwI1IxXVXPxSCnMiIu5s5yg6V4QFlCmxhq88JWacoSEebr4sX7cs8sCYk3DK9iDzK8v0XPdD30F/LNTQUe6D1gIld4ZvS3J0zF1uddmPYCkmMFf2++DfjUai/9npw3rM9L0bNXeyb2J9x6Z7PXq9ShRdU2Qj45pQjNCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eaiBX4hZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eaiBX4hZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1105C116D0;
	Thu, 15 Jan 2026 17:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497086;
	bh=XIpV642ZCNC8CnRxGPFt9T82rkQptv90S3D5S8QChBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eaiBX4hZkO2kUZfbqVZgWQMGOI0dsaq/qTOSX9MNNF7ibToDMYiOzpgFahlfzHSpw
	 nYAU/tI5bH0wqV9oHw3BvZySyG18egKnKjCXfMauWswfT0OJUmlF30f5R70XuQo0SO
	 JDhsMSrxMA6cmGqFxzrWiAmGSAvQcxNmgDti7aoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marek.vasut@mailbox.org>,
	Christoph Niedermaier <cniedermaier@dh-electronics.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 32/72] arm64: dts: imx8mp: Fix LAN8740Ai PHY reference clock on DH electronics i.MX8M Plus DHCOM
Date: Thu, 15 Jan 2026 17:48:42 +0100
Message-ID: <20260115164144.660654478@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164143.482647486@linuxfoundation.org>
References: <20260115164143.482647486@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2fd50b5890afa..0b81b85887f40 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-dhcom-som.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp-dhcom-som.dtsi
@@ -97,6 +97,7 @@ mdio {
 		ethphy0f: ethernet-phy@1 { /* SMSC LAN8740Ai */
 			compatible = "ethernet-phy-id0007.c110",
 				     "ethernet-phy-ieee802.3-c22";
+			clocks = <&clk IMX8MP_CLK_ENET_QOS>;
 			interrupt-parent = <&gpio3>;
 			interrupts = <19 IRQ_TYPE_LEVEL_LOW>;
 			pinctrl-0 = <&pinctrl_ethphy0>;
-- 
2.51.0




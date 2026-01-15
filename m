Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64C663B8BAB;
	Thu, 15 Jan 2026 16:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496117; cv=none; b=jJv48nmh5VUf2uCMYGpHeygvQMPRaVl+cQ+1i4RTRAQTnlBtj2R4Gx9pOWgDYTM6NMvLnmxcjOwrp7fObMM5vqpO574Z1/grcqinAuSFZE+a9Oh8/QcP6n2UfRou+3fDIeergwGz4PHmFJXp7aYkhLSkqDXrfRFtCfw1vetLfdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496117; c=relaxed/simple;
	bh=afUsduel1+Ha3dY79t/HDe2X9tG5HodgBE4xuD9A4PM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QxVSYOnxsWt7HcMz237RZz/DYglFhZFVs3Ndz6kL3/vLk0M7vvAaoy7m2BCWEBxkQCLR6c8xT1dTLuufT1qi4u99FkTV17nMTnbb62VJSpAWlaODOsf05yaCtGfSaOVUrZQe/XXJk0Slf4BY3Z5uehZWJ99VBSnUDesSuPP7d58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qYzv8hbo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qYzv8hbo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6409C116D0;
	Thu, 15 Jan 2026 16:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496117;
	bh=afUsduel1+Ha3dY79t/HDe2X9tG5HodgBE4xuD9A4PM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qYzv8hbobp++eZfOpx6D8D1FGyHdfqhQo/iWOz/Q5Du9qCJBsfH2X7kx1tOLQYvdN
	 Q7AmFYHBdlaelxEHOrofyogWL36Ua9qVz4y0ciFPzyGyO234EsTauJrjQGkBo3897u
	 IuajXxVOCUxt7m1qYsEtk4Yavw+Wa1e4WsySjj/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marek.vasut@mailbox.org>,
	Christoph Niedermaier <cniedermaier@dh-electronics.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 084/181] arm64: dts: imx8mp: Fix LAN8740Ai PHY reference clock on DH electronics i.MX8M Plus DHCOM
Date: Thu, 15 Jan 2026 17:47:01 +0100
Message-ID: <20260115164205.358606899@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 68c2e0156a5c8..f8303b7e2bd22 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-dhcom-som.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp-dhcom-som.dtsi
@@ -113,6 +113,7 @@ mdio {
 		ethphy0f: ethernet-phy@1 { /* SMSC LAN8740Ai */
 			compatible = "ethernet-phy-id0007.c110",
 				     "ethernet-phy-ieee802.3-c22";
+			clocks = <&clk IMX8MP_CLK_ENET_QOS>;
 			interrupt-parent = <&gpio3>;
 			interrupts = <19 IRQ_TYPE_LEVEL_LOW>;
 			pinctrl-0 = <&pinctrl_ethphy0>;
-- 
2.51.0




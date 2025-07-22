Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 181EA22094;
	Tue, 22 Jul 2025 14:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193615; cv=none; b=X4gjshgrTu71EWSmTczGnPeV5gPUiGarAu7KDwr4pBXUpIkVSPvGqgBMvn8Awotdc6rog8E1MFmYZ/5A+5ckUo2mNpRqnRqEGRQw3Cwj2e82nFuLcAQIVdDYAzW0teVuhxTRddvfqWHzTMnFI4+Jgo/vV7YXSKIEkYlMZiAXnCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193615; c=relaxed/simple;
	bh=xHM1ZyKlE1q+6aruvRRFyqHBL7E0+z4jXhZDf95mq4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rNhIRKZU4zeRNTD96eNkxS2314Vmuul9Emtm1Dp6N0GI1rqslC5uGyelWbw/GV10c5iL4jpr2paCoidhxXckDlaDv8Flbi34Yj2nGRV871P2s+Sb+6Om3Ep0C2iAKAKBiY5iwrCxN1C6jTDGwySCuHW80VxmJJbmdfbTRMJMlcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rk9Lso+l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rk9Lso+l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B7B1C4CEEB;
	Tue, 22 Jul 2025 14:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193614;
	bh=xHM1ZyKlE1q+6aruvRRFyqHBL7E0+z4jXhZDf95mq4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rk9Lso+lAo8ddjDkDf6rrw5dm6VdCGH6XLUXQTm9TTCumV7L6voNxYG5LUyYoFyjR
	 VJ68FCQEqVMhXiJEGCPsj/oqdwETRoEZCaOEe4w4Y7fBBUgMb6NYDjZ5yxjN/kGPTj
	 YrkuWokV3Uc+SNvT/2cYKcgwcjCuaNFL5oCZ82So=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 102/187] arm64: dts: imx95-19x19-evk: fix the overshoot issue of NETC
Date: Tue, 22 Jul 2025 15:44:32 +0200
Message-ID: <20250722134349.570336263@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Fang <wei.fang@nxp.com>

[ Upstream commit 36c2bf42b6f02ded87a381edc6b500cd6aac5018 ]

The overshoot of MDIO, MDC and ENET1_TDx is too high, so reduce the drive
strength these pins.

Fixes: 025cf78938c2 ("arm64: dts: imx95-19x19-evk: add ENETC 0 support")
Signed-off-by: Wei Fang <wei.fang@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx95-19x19-evk.dts | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx95-19x19-evk.dts b/arch/arm64/boot/dts/freescale/imx95-19x19-evk.dts
index 25ac331f03183..9a4d5f7f9e7f9 100644
--- a/arch/arm64/boot/dts/freescale/imx95-19x19-evk.dts
+++ b/arch/arm64/boot/dts/freescale/imx95-19x19-evk.dts
@@ -536,17 +536,17 @@
 &scmi_iomuxc {
 	pinctrl_emdio: emdiogrp{
 		fsl,pins = <
-			IMX95_PAD_ENET1_MDC__NETCMIX_TOP_NETC_MDC		0x57e
-			IMX95_PAD_ENET1_MDIO__NETCMIX_TOP_NETC_MDIO		0x97e
+			IMX95_PAD_ENET1_MDC__NETCMIX_TOP_NETC_MDC		0x50e
+			IMX95_PAD_ENET1_MDIO__NETCMIX_TOP_NETC_MDIO		0x90e
 		>;
 	};
 
 	pinctrl_enetc0: enetc0grp {
 		fsl,pins = <
-			IMX95_PAD_ENET1_TD3__NETCMIX_TOP_ETH0_RGMII_TD3		0x57e
-			IMX95_PAD_ENET1_TD2__NETCMIX_TOP_ETH0_RGMII_TD2		0x57e
-			IMX95_PAD_ENET1_TD1__NETCMIX_TOP_ETH0_RGMII_TD1		0x57e
-			IMX95_PAD_ENET1_TD0__NETCMIX_TOP_ETH0_RGMII_TD0		0x57e
+			IMX95_PAD_ENET1_TD3__NETCMIX_TOP_ETH0_RGMII_TD3		0x50e
+			IMX95_PAD_ENET1_TD2__NETCMIX_TOP_ETH0_RGMII_TD2		0x50e
+			IMX95_PAD_ENET1_TD1__NETCMIX_TOP_ETH0_RGMII_TD1		0x50e
+			IMX95_PAD_ENET1_TD0__NETCMIX_TOP_ETH0_RGMII_TD0		0x50e
 			IMX95_PAD_ENET1_TX_CTL__NETCMIX_TOP_ETH0_RGMII_TX_CTL	0x57e
 			IMX95_PAD_ENET1_TXC__NETCMIX_TOP_ETH0_RGMII_TX_CLK	0x58e
 			IMX95_PAD_ENET1_RX_CTL__NETCMIX_TOP_ETH0_RGMII_RX_CTL	0x57e
-- 
2.39.5




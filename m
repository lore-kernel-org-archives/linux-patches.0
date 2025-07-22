Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF152EAB7C;
	Tue, 22 Jul 2025 14:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193497; cv=none; b=ccuScJch1roG9J4fLJmyJeiHFteJYBHs311y5f5p3FYdYOx8Y40CaUweW7Vfv2MtOH5b8wukhmCLQbe8yZxXpvIU6cgfF6xlFMn97k3qKjT9cIdrzCabte+eY6avLwVheshYPnRiX4hZ907ZoT+FbcVnIMdTvR0TddQll/H59GI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193497; c=relaxed/simple;
	bh=zquXD6Dh7rXxMzEnpGtZ9x5BagHVcgX2b0nU9OJ3lUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rUf2tQ2F8OKPrUCuGvqokpmoGwrU6ND9Sybv5Qa5OfR8c5/3w5FFsUTlWiRibHP9t5bZ4bGPB2ZTPGyV+seQSbg49dlzcX088X6AtHJW5JJA8/H8Ffa5Rxl94ce/PcYnkYGm7NmGSVKqYNxmv0ZGuf1bANVmtzt9bsDnZAxgZKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lmt2KzNe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lmt2KzNe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F110C4CEEB;
	Tue, 22 Jul 2025 14:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193497;
	bh=zquXD6Dh7rXxMzEnpGtZ9x5BagHVcgX2b0nU9OJ3lUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lmt2KzNelE4cLV7oBPK58fl638q+3AcXbAhkD4Z/MI8I1xKdF4Oe1RhLKY04czQUJ
	 /h1ToGpP46xIzdSwwcQtifEjvGHmQy5y+yLoW/XZmUaNugahdm/GkuaI/WbRhswnaU
	 uSCWng851AUtsedg/DN0iK6N/5v0xCP+tfz0cPRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 103/187] arm64: dts: imx95-15x15-evk: fix the overshoot issue of NETC
Date: Tue, 22 Jul 2025 15:44:33 +0200
Message-ID: <20250722134349.605462758@linuxfoundation.org>
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

[ Upstream commit e0322ac2a3cf7013b7af73b1293670f1e163c92e ]

The overshoot of MDIO, MDC, ENET1_TDx and ENET2_TDx is too high, so
reduce the drive strength of these pins.

Fixes: e3e8b199aff8 ("arm64: dts: imx95: Add imx95-15x15-evk support")
Signed-off-by: Wei Fang <wei.fang@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/freescale/imx95-15x15-evk.dts    | 20 +++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx95-15x15-evk.dts b/arch/arm64/boot/dts/freescale/imx95-15x15-evk.dts
index 514f2429dcbc2..3ab4d27de1a22 100644
--- a/arch/arm64/boot/dts/freescale/imx95-15x15-evk.dts
+++ b/arch/arm64/boot/dts/freescale/imx95-15x15-evk.dts
@@ -558,17 +558,17 @@
 &scmi_iomuxc {
 	pinctrl_emdio: emdiogrp {
 		fsl,pins = <
-			IMX95_PAD_ENET2_MDC__NETCMIX_TOP_NETC_MDC		0x57e
-			IMX95_PAD_ENET2_MDIO__NETCMIX_TOP_NETC_MDIO		0x97e
+			IMX95_PAD_ENET2_MDC__NETCMIX_TOP_NETC_MDC		0x50e
+			IMX95_PAD_ENET2_MDIO__NETCMIX_TOP_NETC_MDIO		0x90e
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
@@ -582,10 +582,10 @@
 
 	pinctrl_enetc1: enetc1grp {
 		fsl,pins = <
-			IMX95_PAD_ENET2_TD3__NETCMIX_TOP_ETH1_RGMII_TD3		0x57e
-			IMX95_PAD_ENET2_TD2__NETCMIX_TOP_ETH1_RGMII_TD2		0x57e
-			IMX95_PAD_ENET2_TD1__NETCMIX_TOP_ETH1_RGMII_TD1		0x57e
-			IMX95_PAD_ENET2_TD0__NETCMIX_TOP_ETH1_RGMII_TD0		0x57e
+			IMX95_PAD_ENET2_TD3__NETCMIX_TOP_ETH1_RGMII_TD3		0x50e
+			IMX95_PAD_ENET2_TD2__NETCMIX_TOP_ETH1_RGMII_TD2		0x50e
+			IMX95_PAD_ENET2_TD1__NETCMIX_TOP_ETH1_RGMII_TD1		0x50e
+			IMX95_PAD_ENET2_TD0__NETCMIX_TOP_ETH1_RGMII_TD0		0x50e
 			IMX95_PAD_ENET2_TX_CTL__NETCMIX_TOP_ETH1_RGMII_TX_CTL	0x57e
 			IMX95_PAD_ENET2_TXC__NETCMIX_TOP_ETH1_RGMII_TX_CLK	0x58e
 			IMX95_PAD_ENET2_RX_CTL__NETCMIX_TOP_ETH1_RGMII_RX_CTL	0x57e
-- 
2.39.5




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEE2634BA34;
	Tue, 16 Dec 2025 11:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885276; cv=none; b=q3KjShsmTZNhKVC7+guDr4N9nFZCxg/GYiIXKaNow6xFxEsDePndA00BBJoSbNBdUb5M8pbnYIY3aL00Jtn7kwxcPatKtF+Mj3apOszq9ma13RhnRIBI+YCxecspg3GA1uamawaLxaXpRwSeDegOFJ67VAsZy3lkJvhD+Z6efbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885276; c=relaxed/simple;
	bh=0rDGy4OuHk1Xt+bdmbX02o01lMU4fC9tV2CwtoiCVSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KAeALyqJbgAiaPl7pstuBUyqNCLm/icWLv1ydCzpjT/YLZxGcii9BuyTmDHS2irX6UCGAjTzCDIYMGtI+ryZt+XRcwI8aVrCT3bWtMr4yTRvsIshoWWWzbT5P85EtiXOhmU2kzIqWFTPP0IEZ/4aZKcpwdGz/j5AerqWU361+os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZXPF0FQq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZXPF0FQq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E997C4CEF1;
	Tue, 16 Dec 2025 11:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885275;
	bh=0rDGy4OuHk1Xt+bdmbX02o01lMU4fC9tV2CwtoiCVSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZXPF0FQq3nKkWaAw2qdRb1JR4R/PSWwiC7mO1asBpUoftTrBlH16vDJMW2Lh8Cz/u
	 EeUjb0fB7RexS4WPzfmShS/CBjHwWwhYf8FjG4NxLbGPtqJKlbriFn/0ud6bvnRoB0
	 yChZO7+jhI3/SfRzTOIVpGYYbw2fJ24jVP//ouqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Harvey <tharvey@gateworks.com>,
	Peng Fan <peng.fan@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 063/507] arm64: dts: imx8mp-venice-gw702x: remove off-board sdhc1
Date: Tue, 16 Dec 2025 12:08:24 +0100
Message-ID: <20251216111347.825731663@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tim Harvey <tharvey@gateworks.com>

[ Upstream commit 9db04b310ef99b546e4240c55842e81b06b78579 ]

SDHC1 on the GW702x SOM routes to a connector for use on a baseboard
and as such are defined in the baseboard device-trees.

Remove it from the gw702x SOM device-tree.

Fixes: 0d5b288c2110 ("arm64: dts: freescale: Add imx8mp-venice-gw7905-2x")
Signed-off-by: Tim Harvey <tharvey@gateworks.com>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../dts/freescale/imx8mp-venice-gw702x.dtsi   | 20 -------------------
 .../dts/freescale/imx8mp-venice-gw72xx.dtsi   | 11 ----------
 2 files changed, 31 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-venice-gw702x.dtsi b/arch/arm64/boot/dts/freescale/imx8mp-venice-gw702x.dtsi
index 086ee4510cd83..fb159199b39de 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-venice-gw702x.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp-venice-gw702x.dtsi
@@ -402,15 +402,6 @@ &uart2 {
 	status = "okay";
 };
 
-/* off-board */
-&usdhc1 {
-	pinctrl-names = "default";
-	pinctrl-0 = <&pinctrl_usdhc1>;
-	bus-width = <4>;
-	non-removable;
-	status = "okay";
-};
-
 /* eMMC */
 &usdhc3 {
 	pinctrl-names = "default", "state_100mhz", "state_200mhz";
@@ -513,17 +504,6 @@ MX8MP_IOMUXC_UART2_TXD__UART2_DCE_TX	0x140
 		>;
 	};
 
-	pinctrl_usdhc1: usdhc1grp {
-		fsl,pins = <
-			MX8MP_IOMUXC_SD1_CLK__USDHC1_CLK	0x190
-			MX8MP_IOMUXC_SD1_CMD__USDHC1_CMD	0x1d0
-			MX8MP_IOMUXC_SD1_DATA0__USDHC1_DATA0	0x1d0
-			MX8MP_IOMUXC_SD1_DATA1__USDHC1_DATA1	0x1d0
-			MX8MP_IOMUXC_SD1_DATA2__USDHC1_DATA2	0x1d0
-			MX8MP_IOMUXC_SD1_DATA3__USDHC1_DATA3	0x1d0
-		>;
-	};
-
 	pinctrl_usdhc3: usdhc3grp {
 		fsl,pins = <
 			MX8MP_IOMUXC_NAND_WE_B__USDHC3_CLK	0x190
diff --git a/arch/arm64/boot/dts/freescale/imx8mp-venice-gw72xx.dtsi b/arch/arm64/boot/dts/freescale/imx8mp-venice-gw72xx.dtsi
index cf747ec6fa16e..76020ef89bf3e 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-venice-gw72xx.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp-venice-gw72xx.dtsi
@@ -365,17 +365,6 @@ MX8MP_IOMUXC_UART4_TXD__UART4_DCE_TX	0x140
 		>;
 	};
 
-	pinctrl_usdhc1: usdhc1grp {
-		fsl,pins = <
-			MX8MP_IOMUXC_SD1_CLK__USDHC1_CLK	0x190
-			MX8MP_IOMUXC_SD1_CMD__USDHC1_CMD	0x1d0
-			MX8MP_IOMUXC_SD1_DATA0__USDHC1_DATA0	0x1d0
-			MX8MP_IOMUXC_SD1_DATA1__USDHC1_DATA1	0x1d0
-			MX8MP_IOMUXC_SD1_DATA2__USDHC1_DATA2	0x1d0
-			MX8MP_IOMUXC_SD1_DATA3__USDHC1_DATA3	0x1d0
-		>;
-	};
-
 	pinctrl_usdhc2: usdhc2grp {
 		fsl,pins = <
 			MX8MP_IOMUXC_SD2_CLK__USDHC2_CLK	0x190
-- 
2.51.0




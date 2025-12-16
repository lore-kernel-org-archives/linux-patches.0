Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B4703233EE;
	Tue, 16 Dec 2025 11:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765883972; cv=none; b=H9zbtbvU/NzDevjpubz+JEgpRspgl/7tqtjaSrPrIYXwNfYHXgmR5XNHgS8yQX/cVSvunXq5GEf8Bw4zLFijsf1JVxSXt7aLkWzIVYUhmYBNqon7+pn9rJpm6ay9iJJOdIgPYzfwthDaKGpvPJxFAyZq1wz7aQ1Cxh1oUHetJuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765883972; c=relaxed/simple;
	bh=zWJXGERhyy9nWkWcDnxkbKg6ojuC3Tfq2iQEL+qOhDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BU0YhYU/8aKuTZZ1hCfcHxzs9iLodMjkCfc0lUEfjwWcCnI3UHKfpwTpNgt764vQro1qo+FBEO9E4r1U5woNiSnqNi2VjL/zo9r/cQNSNoAZc/iwWUClS52quA+QPTgdXe0NbRWibHaP3yd09vzAAZdgzI5mdo/tMs1SRQbPE6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UWOBZUp3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UWOBZUp3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAA86C4CEF1;
	Tue, 16 Dec 2025 11:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765883972;
	bh=zWJXGERhyy9nWkWcDnxkbKg6ojuC3Tfq2iQEL+qOhDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UWOBZUp369MDxWdtGKb3mM1h4xmCHsCJQ77UQld6lNqbCTMZhpGAYCd54k/wM5DRK
	 LiyrL5lsyoZQKGLERm5Ay7x36z9HjzdL8UHKFwXfHJGAK22SDat5hPk79Ij3HLKf68
	 z2mpAZ6kCpJANk2eS5ffiZL7pysMUE1pXG9RmP5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Harvey <tharvey@gateworks.com>,
	Peng Fan <peng.fan@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 053/354] arm64: dts: imx8mp-venice-gw702x: remove off-board sdhc1
Date: Tue, 16 Dec 2025 12:10:20 +0100
Message-ID: <20251216111322.839636098@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e8688695df780..4e89aa9ce9ad2 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-venice-gw702x.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp-venice-gw702x.dtsi
@@ -400,15 +400,6 @@ &uart2 {
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
@@ -509,17 +500,6 @@ MX8MP_IOMUXC_UART2_TXD__UART2_DCE_TX	0x140
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




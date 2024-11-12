Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3093220D4E3;
	Tue, 12 Nov 2024 10:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407569; cv=none; b=Y/Zs42upneKzW2C5Xr1GRJc1PejngDXXf1w0DUvqrQDfRp/i+4NLYBScig9W7mJbTFWQTB1XV6bGNl39O9vQCWnJkM9K8PYY+vmusuF83Cg65ifOCvsVxeMXx8abAXKvJ0gp3jpOYM8c/qxr/sLiq7uWTXVSMA5LpO2/J31XI2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407569; c=relaxed/simple;
	bh=EZDA5YV4QU1YjDNvksM07RA54rxj0f3P5uTvughQzE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gG4WQAY0uejmMp/MUguSVYPDxEDebSdtG/iF4hqWVscIWi1fBNnRCXLJ0VMf/tRB4Vc7wWZ/8QSWbM5C/3ue6AbSlcEkNhK6tm58rFx25k9fY/e02RpkZ7+dSKK+vTAe5QlCzB8Oa6ppR/TmYXETMJ6CyIuVXBOJcjdatLg4aro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q3SMKwAg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q3SMKwAg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 904B6C4CECD;
	Tue, 12 Nov 2024 10:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407569;
	bh=EZDA5YV4QU1YjDNvksM07RA54rxj0f3P5uTvughQzE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q3SMKwAg160Et8CulMj00T643iIeofWuLCt3UPRgBlODjwoQVPIXmJ4CFf1/I5Gta
	 wSZ9WIRvCSJha/VyLqgy7eUrQx4riSmcQBrwmNkviOpASk9H/JDNp2HCCSscgcs2Xi
	 ooCCVZMeiVM2RfIxSIgxpoH4syul1uuVZKTaWNd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Fabio Estevam <festevam@gmail.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 016/119] arm64: dts: imx8mp: correct sdhc ipg clk
Date: Tue, 12 Nov 2024 11:20:24 +0100
Message-ID: <20241112101849.334478580@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101848.708153352@linuxfoundation.org>
References: <20241112101848.708153352@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit eab6ba2aa3bbaf598a66e31f709bf84b7bb7dc8a ]

The ipg clk for sdhc sources from IPG_CLK_ROOT per i.MX 8M Plus
Applications Processor Reference Manual, Table 5-2. System Clocks.

Fixes: 6d9b8d20431f ("arm64: dts: freescale: Add i.MX8MP dtsi support")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp.dtsi b/arch/arm64/boot/dts/freescale/imx8mp.dtsi
index d1488ebfef3f0..69b213ed7a594 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp.dtsi
@@ -1257,7 +1257,7 @@
 				compatible = "fsl,imx8mp-usdhc", "fsl,imx8mm-usdhc", "fsl,imx7d-usdhc";
 				reg = <0x30b40000 0x10000>;
 				interrupts = <GIC_SPI 22 IRQ_TYPE_LEVEL_HIGH>;
-				clocks = <&clk IMX8MP_CLK_DUMMY>,
+				clocks = <&clk IMX8MP_CLK_IPG_ROOT>,
 					 <&clk IMX8MP_CLK_NAND_USDHC_BUS>,
 					 <&clk IMX8MP_CLK_USDHC1_ROOT>;
 				clock-names = "ipg", "ahb", "per";
@@ -1271,7 +1271,7 @@
 				compatible = "fsl,imx8mp-usdhc", "fsl,imx8mm-usdhc", "fsl,imx7d-usdhc";
 				reg = <0x30b50000 0x10000>;
 				interrupts = <GIC_SPI 23 IRQ_TYPE_LEVEL_HIGH>;
-				clocks = <&clk IMX8MP_CLK_DUMMY>,
+				clocks = <&clk IMX8MP_CLK_IPG_ROOT>,
 					 <&clk IMX8MP_CLK_NAND_USDHC_BUS>,
 					 <&clk IMX8MP_CLK_USDHC2_ROOT>;
 				clock-names = "ipg", "ahb", "per";
@@ -1285,7 +1285,7 @@
 				compatible = "fsl,imx8mp-usdhc", "fsl,imx8mm-usdhc", "fsl,imx7d-usdhc";
 				reg = <0x30b60000 0x10000>;
 				interrupts = <GIC_SPI 24 IRQ_TYPE_LEVEL_HIGH>;
-				clocks = <&clk IMX8MP_CLK_DUMMY>,
+				clocks = <&clk IMX8MP_CLK_IPG_ROOT>,
 					 <&clk IMX8MP_CLK_NAND_USDHC_BUS>,
 					 <&clk IMX8MP_CLK_USDHC3_ROOT>;
 				clock-names = "ipg", "ahb", "per";
-- 
2.43.0




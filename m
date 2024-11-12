Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 225AA1CBE8F;
	Tue, 12 Nov 2024 10:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407324; cv=none; b=thuDyvmRx5Vl3ZBF+BGgb+wQYovFoK9p/pXFAlDSjw4b0j4lZ/bxZcizMqf7gHqIFtszWrYNZGZse9qrJ727om3aNvtobeX+jLCD2FfqjxL1wdbDxT8n6c2JfT4j7AZogz+oEX6rSMTOlImSG0OI/AGcXJ+KB2AfR29goDtbxpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407324; c=relaxed/simple;
	bh=PC5IEDlu5xWITmMK2icHKDu91nnAl4Ijl7V5fkmm/5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lMp1aoBT290uB+3C2Cjx86aJ5hjGtSjOfBAK8LeDvFaMmo+6cLUbicSoVDrGCbxcf3DIlF/bwJAaLLjY58Fa1OFaAzpf2Ocp3wv7Vc4x0CELQqq4yjbPfw2jNjx4fGilql2gwUC9N6thdW4+BGJAZZ6Ar9vZIkqdCBgMuWBJvTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2K+FhQSX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2K+FhQSX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9885FC4CECD;
	Tue, 12 Nov 2024 10:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407324;
	bh=PC5IEDlu5xWITmMK2icHKDu91nnAl4Ijl7V5fkmm/5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2K+FhQSXiPlCoYuJye6/zShzDbmOZc1nPDA9PbIPgP1LZ1Eif1jMPKu+j37pMrBsz
	 J8irVZsKIpzCB7rAdF0mjQ6aNMsI97FIRNewVcoJa6PQwTNlhRvE8oPsbF5BI169vI
	 VIXkADPfOtDLysan2soLJRUSwJD0RSLrUtKSzvt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Fabio Estevam <festevam@gmail.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 11/98] arm64: dts: imx8mp: correct sdhc ipg clk
Date: Tue, 12 Nov 2024 11:20:26 +0100
Message-ID: <20241112101844.701624434@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101844.263449965@linuxfoundation.org>
References: <20241112101844.263449965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 8c34b3e12a66a..86af7115ac60c 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp.dtsi
@@ -934,7 +934,7 @@
 				compatible = "fsl,imx8mp-usdhc", "fsl,imx8mm-usdhc", "fsl,imx7d-usdhc";
 				reg = <0x30b40000 0x10000>;
 				interrupts = <GIC_SPI 22 IRQ_TYPE_LEVEL_HIGH>;
-				clocks = <&clk IMX8MP_CLK_DUMMY>,
+				clocks = <&clk IMX8MP_CLK_IPG_ROOT>,
 					 <&clk IMX8MP_CLK_NAND_USDHC_BUS>,
 					 <&clk IMX8MP_CLK_USDHC1_ROOT>;
 				clock-names = "ipg", "ahb", "per";
@@ -948,7 +948,7 @@
 				compatible = "fsl,imx8mp-usdhc", "fsl,imx8mm-usdhc", "fsl,imx7d-usdhc";
 				reg = <0x30b50000 0x10000>;
 				interrupts = <GIC_SPI 23 IRQ_TYPE_LEVEL_HIGH>;
-				clocks = <&clk IMX8MP_CLK_DUMMY>,
+				clocks = <&clk IMX8MP_CLK_IPG_ROOT>,
 					 <&clk IMX8MP_CLK_NAND_USDHC_BUS>,
 					 <&clk IMX8MP_CLK_USDHC2_ROOT>;
 				clock-names = "ipg", "ahb", "per";
@@ -962,7 +962,7 @@
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




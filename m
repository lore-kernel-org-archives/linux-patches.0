Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8476419E992;
	Tue, 12 Nov 2024 10:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407025; cv=none; b=fCaE4xirFpytu/M1ecapLaKhTPCIb0PJdw+g/V2Xa1B3LXT1pVJ8vKb6cCJn3vbVN/wu/8amOrIOyONofkPFPKLpPbmnkz1TGvyV0VM7iHohe01PWjYxN5oGi/QE6a2v0kVc3VLlSLMiYyMrWMFEAlkuqFYmExoLb0tijoUbjgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407025; c=relaxed/simple;
	bh=ZHLUyf4izq8L+IZoOKnTouPeCkMNqz54XDqge1jPJrs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y0VhS4Um1bthNq1HhjIIVEZhDWQn5Xe+p0kM8+BhAQVfj+ySrG26MMsauvYQlu47/OErAvPP4Iqq7EQ8xfwQC5FJ96STg5Qb9h7p7TvVf30qcjmGQwk6Oy3ZKBuSsbxvFMhFK1HLmdYnG7kC412ezDgyxg/0lcpI/HNBuIpjNLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nmRNMvpT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nmRNMvpT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5ACBC4CECD;
	Tue, 12 Nov 2024 10:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407025;
	bh=ZHLUyf4izq8L+IZoOKnTouPeCkMNqz54XDqge1jPJrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nmRNMvpTzb53salDc6Z9NT64Bk6sko6Oe9hpXDAFQWXBP2nivw/QNZro3pelzKvHt
	 bBrLgmLkDNss4pxnl8hgdCvu9FJ4VAdLliuOYSSGdz0Xe7yqPeOKoOTqFKc5V+p0JI
	 7+9cOpHlk/utEJDwpv2l5jFFxvq1kAEG+gMLEWy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Fabio Estevam <festevam@gmail.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 06/76] arm64: dts: imx8mp: correct sdhc ipg clk
Date: Tue, 12 Nov 2024 11:20:31 +0100
Message-ID: <20241112101840.024784466@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101839.777512218@linuxfoundation.org>
References: <20241112101839.777512218@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 4e8cde8972e82..b5130e7be8263 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp.dtsi
@@ -740,7 +740,7 @@
 				compatible = "fsl,imx8mp-usdhc", "fsl,imx7d-usdhc";
 				reg = <0x30b40000 0x10000>;
 				interrupts = <GIC_SPI 22 IRQ_TYPE_LEVEL_HIGH>;
-				clocks = <&clk IMX8MP_CLK_DUMMY>,
+				clocks = <&clk IMX8MP_CLK_IPG_ROOT>,
 					 <&clk IMX8MP_CLK_NAND_USDHC_BUS>,
 					 <&clk IMX8MP_CLK_USDHC1_ROOT>;
 				clock-names = "ipg", "ahb", "per";
@@ -754,7 +754,7 @@
 				compatible = "fsl,imx8mp-usdhc", "fsl,imx7d-usdhc";
 				reg = <0x30b50000 0x10000>;
 				interrupts = <GIC_SPI 23 IRQ_TYPE_LEVEL_HIGH>;
-				clocks = <&clk IMX8MP_CLK_DUMMY>,
+				clocks = <&clk IMX8MP_CLK_IPG_ROOT>,
 					 <&clk IMX8MP_CLK_NAND_USDHC_BUS>,
 					 <&clk IMX8MP_CLK_USDHC2_ROOT>;
 				clock-names = "ipg", "ahb", "per";
@@ -768,7 +768,7 @@
 				compatible = "fsl,imx8mp-usdhc", "fsl,imx7d-usdhc";
 				reg = <0x30b60000 0x10000>;
 				interrupts = <GIC_SPI 24 IRQ_TYPE_LEVEL_HIGH>;
-				clocks = <&clk IMX8MP_CLK_DUMMY>,
+				clocks = <&clk IMX8MP_CLK_IPG_ROOT>,
 					 <&clk IMX8MP_CLK_NAND_USDHC_BUS>,
 					 <&clk IMX8MP_CLK_USDHC3_ROOT>;
 				clock-names = "ipg", "ahb", "per";
-- 
2.43.0




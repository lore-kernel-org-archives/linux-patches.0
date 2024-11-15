Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58C432BB1B;
	Fri, 15 Nov 2024 06:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653758; cv=none; b=Sp+fy+x3u9DqMMbopuXwQL4NGp8lZ++Iy6GIUblJuocVOoDPB6Nbn+7a2MvYptou4dP7DOePjuqO+V3x+zVbanKCQLCm12H7Dg0jUhgNiWjZIbi8qoJlPAe9i42SUtU5308ccAqsJIv04RwcR+SerQjIMCeeCKorWbWOX6+D6bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653758; c=relaxed/simple;
	bh=LR6uHbj1IGcNhE3REFiOs30tUfIjAzHEEPQubNoAO9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k9EQNVnveudL9+H3vqbYkmxAoEVmNkIoHlaMQOwyr4qP0zWxc0J1+graTxDJ5fgJ+PMPinnQIogCmZ8EmXaRP6VfOICorpv/yvSGw7AvAN2TT5jgP8hy5b2kN5xRzonrVINRd5OxbfsZOWExeM30D5Rgv4CcdX3uzt+3yV1j78w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UlJEWoSZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UlJEWoSZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A589C4CECF;
	Fri, 15 Nov 2024 06:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653757;
	bh=LR6uHbj1IGcNhE3REFiOs30tUfIjAzHEEPQubNoAO9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UlJEWoSZFAkmE5tRbFXq2UNEJiYjWz7iCCvl4VV7/PkmrEUBnHngRq/UHViD7Cx48
	 uHuGfkv1EYzjCKRuo9HjWzvlHxnMFkeqFGvkrHHZsK+gUECW9wyh8KvNa9bfn8a45r
	 9kiSK6DLTrzpGHRC6lGYdQrfs5b0tLbYQKW7vGLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Fabio Estevam <festevam@gmail.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 06/82] arm64: dts: imx8mp: correct sdhc ipg clk
Date: Fri, 15 Nov 2024 07:37:43 +0100
Message-ID: <20241115063725.795424500@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063725.561151311@linuxfoundation.org>
References: <20241115063725.561151311@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index acee71ca32d83..0186b3992b95f 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp.dtsi
@@ -659,7 +659,7 @@
 				compatible = "fsl,imx8mp-usdhc", "fsl,imx7d-usdhc";
 				reg = <0x30b40000 0x10000>;
 				interrupts = <GIC_SPI 22 IRQ_TYPE_LEVEL_HIGH>;
-				clocks = <&clk IMX8MP_CLK_DUMMY>,
+				clocks = <&clk IMX8MP_CLK_IPG_ROOT>,
 					 <&clk IMX8MP_CLK_NAND_USDHC_BUS>,
 					 <&clk IMX8MP_CLK_USDHC1_ROOT>;
 				clock-names = "ipg", "ahb", "per";
@@ -673,7 +673,7 @@
 				compatible = "fsl,imx8mp-usdhc", "fsl,imx7d-usdhc";
 				reg = <0x30b50000 0x10000>;
 				interrupts = <GIC_SPI 23 IRQ_TYPE_LEVEL_HIGH>;
-				clocks = <&clk IMX8MP_CLK_DUMMY>,
+				clocks = <&clk IMX8MP_CLK_IPG_ROOT>,
 					 <&clk IMX8MP_CLK_NAND_USDHC_BUS>,
 					 <&clk IMX8MP_CLK_USDHC2_ROOT>;
 				clock-names = "ipg", "ahb", "per";
@@ -687,7 +687,7 @@
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




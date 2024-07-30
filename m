Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A68B31917EC;
	Tue, 30 Jul 2024 16:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356164; cv=none; b=Tf0Z2uSGRdFZ/a3+UzEEC/CXV+cDrnh2bShsTPRxGhWE1fFyTducVQ775TT/U3kljwpoT5jrFGshSiUff7CdMuawFABtIWSCfywo08bXUKFhDz9QuM2glY3R4FZLc3TI83hXxUMp6ENQTvXhBPq7O+faIv9unaybLy1d5UXzhxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356164; c=relaxed/simple;
	bh=7kM3ExjipTvY0spCNTOicwKll77XyQbmQ60dABxfwms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qh3tu+W4dMxxQSootPdvPExmhgG3uOmXwUkadOegKiGVPZ3mDGRaXh8XOnPD8yrjAvEjteROz1ORF863ciNnVzNW5bTbDZita1M5pilrdLTwC0LaEgflK2RvfbTBZIRH7DmpUEAWkkSFhPuKSxPaSkERKsNy0L2kHpyfsDQX/Xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=deAaQ1Fp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="deAaQ1Fp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EC65C32782;
	Tue, 30 Jul 2024 16:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356164;
	bh=7kM3ExjipTvY0spCNTOicwKll77XyQbmQ60dABxfwms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=deAaQ1Fpzv/UYCrGKLz9dRnCXF1YRuvD7KWIM5HP7xjp24htDs5Kv5WYo5Ai4KMCX
	 GD/fHIJ5eH1e8xA/vrfDdTgogCyDauPvSRSG1JI8Ip5WQUsJR/G7bpnNb0TmV5kafx
	 RZU8Z+05MeXotMQDKVE294O33d04MwZr1okF4Jfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Ford <aford173@gmail.com>,
	Peng Fan <peng.fan@nxp.com>,
	Marek Vasut <marex@denx.de>,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 125/809] arm64: dts: imx8mp: Fix pgc_mlmix location
Date: Tue, 30 Jul 2024 17:40:01 +0200
Message-ID: <20240730151729.553194897@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adam Ford <aford173@gmail.com>

[ Upstream commit 106f68fc9da3d4835070b55a2229d2c54ef5cba1 ]

The pgc_mlmix shows a power-domain@24, but the reg value is
IMX8MP_POWER_DOMAIN_MLMIX which is set to 4.

The stuff after the @ symbol should match the stuff referenced
by 'reg' so reorder the pgc_mlmix so it to appear as power-domain@4.

Fixes: 834464c8504c ("arm64: dts: imx8mp: add mlmix power domain")
Fixes: 4bedc468b725 ("arm64: dts: imx8mp: Add NPU Node")
Signed-off-by: Adam Ford <aford173@gmail.com>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Marek Vasut <marex@denx.de>
Reviewed-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp.dtsi | 34 +++++++++++------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp.dtsi b/arch/arm64/boot/dts/freescale/imx8mp.dtsi
index b92abb5a5c536..3576d2b89b439 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp.dtsi
@@ -789,6 +789,23 @@ pgc_usb2_phy: power-domain@3 {
 						reg = <IMX8MP_POWER_DOMAIN_USB2_PHY>;
 					};
 
+					pgc_mlmix: power-domain@4 {
+						#power-domain-cells = <0>;
+						reg = <IMX8MP_POWER_DOMAIN_MLMIX>;
+						clocks = <&clk IMX8MP_CLK_ML_AXI>,
+							 <&clk IMX8MP_CLK_ML_AHB>,
+							 <&clk IMX8MP_CLK_NPU_ROOT>;
+						assigned-clocks = <&clk IMX8MP_CLK_ML_CORE>,
+								  <&clk IMX8MP_CLK_ML_AXI>,
+								  <&clk IMX8MP_CLK_ML_AHB>;
+						assigned-clock-parents = <&clk IMX8MP_SYS_PLL1_800M>,
+									 <&clk IMX8MP_SYS_PLL1_800M>,
+									 <&clk IMX8MP_SYS_PLL1_800M>;
+						assigned-clock-rates = <800000000>,
+								       <800000000>,
+								       <300000000>;
+					};
+
 					pgc_audio: power-domain@5 {
 						#power-domain-cells = <0>;
 						reg = <IMX8MP_POWER_DOMAIN_AUDIOMIX>;
@@ -900,23 +917,6 @@ pgc_vpu_vc8000e: power-domain@22 {
 						reg = <IMX8MP_POWER_DOMAIN_VPU_VC8000E>;
 						clocks = <&clk IMX8MP_CLK_VPU_VC8KE_ROOT>;
 					};
-
-					pgc_mlmix: power-domain@24 {
-						#power-domain-cells = <0>;
-						reg = <IMX8MP_POWER_DOMAIN_MLMIX>;
-						clocks = <&clk IMX8MP_CLK_ML_AXI>,
-							 <&clk IMX8MP_CLK_ML_AHB>,
-							 <&clk IMX8MP_CLK_NPU_ROOT>;
-						assigned-clocks = <&clk IMX8MP_CLK_ML_CORE>,
-								  <&clk IMX8MP_CLK_ML_AXI>,
-								  <&clk IMX8MP_CLK_ML_AHB>;
-						assigned-clock-parents = <&clk IMX8MP_SYS_PLL1_800M>,
-									 <&clk IMX8MP_SYS_PLL1_800M>,
-									 <&clk IMX8MP_SYS_PLL1_800M>;
-						assigned-clock-rates = <800000000>,
-								       <800000000>,
-								       <300000000>;
-					};
 				};
 			};
 		};
-- 
2.43.0




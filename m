Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75465374CC;
	Wed,  7 Aug 2024 15:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043543; cv=none; b=n/oYA2eGg9JcScSTAIaiY+3034oOvyPE9zf8u8dobQ8plrD6NB4yZ6tKN5CeEvO7lCLhUwbjxsZvoXHYsA6MUlSx9nCVpSD8t3ANAFr8JbQLH7rYxoD0EjUU/avTWYCA+k/AMzT7OLlk4GHtZdGoNG/dqORNhJvi2gkLJNNZfyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043543; c=relaxed/simple;
	bh=YShQqegv1T4BR+5gpHIR0x1X87gRT8qbtJFtSefgNRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IklUJiDbtKkdVPeTvEh/ex1HI7Lqm6Oqtqk7JZNnSasqrTagK+jnfBsNjMBCIO9mHG63gAuo462AKAxx3ewpdeeyf0Uat7npe6hwIuyPh35xDwTpOhqU+ufGNUDqknU86HsRn+HTLF87m0gHlPhtr6pNEk7xEA/qt8m8JUSodQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AkYcN7lw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AkYcN7lw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0311FC32781;
	Wed,  7 Aug 2024 15:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043543;
	bh=YShQqegv1T4BR+5gpHIR0x1X87gRT8qbtJFtSefgNRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AkYcN7lw/NvB1fcUMRaJpiNNnrWOFgcLVNDuPcm4VknpI0tcprDjExEBsj7f10pbR
	 U7bUxaOxvtXcIF5JBZpahZgeR6XubqlMKiNnG0eWl7ZitTdit4r78B4KlXKwbzh2+C
	 Ci2aoFrh4U+Wphr+xs32gn2xlIZ8/fQmPBLvWmcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 01/86] arm64: dts: qcom: msm8998: switch USB QMP PHY to new style of bindings
Date: Wed,  7 Aug 2024 16:59:40 +0200
Message-ID: <20240807150039.293460467@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150039.247123516@linuxfoundation.org>
References: <20240807150039.247123516@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit b7efebfeb2e8ad8187cdabba5f0212ba2e6c1069 ]

Change the USB QMP PHY to use newer style of QMP PHY bindings (single
resource region, no per-PHY subnodes).

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20230824211952.1397699-11-dmitry.baryshkov@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: 0046325ae520 ("arm64: dts: qcom: msm8998: Disable SS instance in Parkmode for USB")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8998.dtsi | 35 +++++++++++----------------
 1 file changed, 14 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8998.dtsi b/arch/arm64/boot/dts/qcom/msm8998.dtsi
index 3d4941dc31d74..c19fb8ae2da2a 100644
--- a/arch/arm64/boot/dts/qcom/msm8998.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8998.dtsi
@@ -2029,7 +2029,7 @@ usb3_dwc3: usb@a800000 {
 				interrupts = <GIC_SPI 131 IRQ_TYPE_LEVEL_HIGH>;
 				snps,dis_u2_susphy_quirk;
 				snps,dis_enblslpm_quirk;
-				phys = <&qusb2phy>, <&usb1_ssphy>;
+				phys = <&qusb2phy>, <&usb3phy>;
 				phy-names = "usb2-phy", "usb3-phy";
 				snps,has-lpm-erratum;
 				snps,hird-threshold = /bits/ 8 <0x10>;
@@ -2038,33 +2038,26 @@ usb3_dwc3: usb@a800000 {
 
 		usb3phy: phy@c010000 {
 			compatible = "qcom,msm8998-qmp-usb3-phy";
-			reg = <0x0c010000 0x18c>;
-			status = "disabled";
-			#address-cells = <1>;
-			#size-cells = <1>;
-			ranges;
+			reg = <0x0c010000 0x1000>;
 
 			clocks = <&gcc GCC_USB3_PHY_AUX_CLK>,
+				 <&gcc GCC_USB3_CLKREF_CLK>,
 				 <&gcc GCC_USB_PHY_CFG_AHB2PHY_CLK>,
-				 <&gcc GCC_USB3_CLKREF_CLK>;
-			clock-names = "aux", "cfg_ahb", "ref";
+				 <&gcc GCC_USB3_PHY_PIPE_CLK>;
+			clock-names = "aux",
+				      "ref",
+				      "cfg_ahb",
+				      "pipe";
+			clock-output-names = "usb3_phy_pipe_clk_src";
+			#clock-cells = <0>;
+			#phy-cells = <0>;
 
 			resets = <&gcc GCC_USB3_PHY_BCR>,
 				 <&gcc GCC_USB3PHY_PHY_BCR>;
-			reset-names = "phy", "common";
+			reset-names = "phy",
+				      "phy_phy";
 
-			usb1_ssphy: phy@c010200 {
-				reg = <0xc010200 0x128>,
-				      <0xc010400 0x200>,
-				      <0xc010c00 0x20c>,
-				      <0xc010600 0x128>,
-				      <0xc010800 0x200>;
-				#phy-cells = <0>;
-				#clock-cells = <0>;
-				clocks = <&gcc GCC_USB3_PHY_PIPE_CLK>;
-				clock-names = "pipe0";
-				clock-output-names = "usb3_phy_pipe_clk_src";
-			};
+			status = "disabled";
 		};
 
 		qusb2phy: phy@c012000 {
-- 
2.43.0




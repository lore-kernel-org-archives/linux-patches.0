Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B012B60252;
	Tue, 23 Jan 2024 00:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970879; cv=none; b=Wmq5zW2oWzq2vcI3zBi3fnbhYKHl+QPyk+12pf1ablR40EjLCl3a9coe5vWRFZMrtJZHL9KnY4DU/GwT9+PnKWi36y6ExnOr8Y/0P2ohOgNq2KH3bTD0QwJnAAXvU2VkLQqsdlqpt69kiwkzue8PmBr8LdcR2twtHcS8wa21kpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970879; c=relaxed/simple;
	bh=lopkVP+6henOSVIMKxW0Um9e76X+W1BYsBEe9A3NeXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RAwHIyLz8bs1/n5lfDdyJUxj+Kt4rq+lXwvGeOSgDFTPWqQ6Jft4220ZsEJSu88BEimSFZqgDMC49d3hh8ND9KHD5U9UO8ilsxhHOPXmO7DJ8xs+bwEwCX27tRk7fjP24VOrc859BVZb8oOpNRwmFedA5QqlMLFApwlW7z+fN/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GT+/mtwP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GT+/mtwP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11E67C433C7;
	Tue, 23 Jan 2024 00:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970879;
	bh=lopkVP+6henOSVIMKxW0Um9e76X+W1BYsBEe9A3NeXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GT+/mtwPT7TDuAikP47jNsomnvgLgy6oc6wXFu7DAHWoNRIHPcXXnSzDoUVnBvtPo
	 LvuDlXTNgJzbJXnVRKlOK7YpnhPZduCrvkAa75Ut+R+k4ursWCOJMvy0Rz8ixX+4bl
	 ZVrSEFxZnAZ3fkEZio06EfDHXL7W/tgkDQ6D6g+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 131/417] arm64: dts: qcom: ipq6018: Pad addresses to 8 hex digits
Date: Mon, 22 Jan 2024 15:54:59 -0800
Message-ID: <20240122235756.352063063@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 647380e41520c7dbd651ebf0d9fd7dfa4928f42d ]

Some addresses were 7-hex-digits long, or less. Fix that.

Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230102094642.74254-2-konrad.dybcio@linaro.org
Stable-dep-of: 5c0dbe8b0584 ("arm64: dts: qcom: ipq6018: fix clock rates for GCC_USB0_MOCK_UTMI_CLK")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/ipq6018.dtsi | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/ipq6018.dtsi b/arch/arm64/boot/dts/qcom/ipq6018.dtsi
index 55f685f51c71..43a948b64007 100644
--- a/arch/arm64/boot/dts/qcom/ipq6018.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq6018.dtsi
@@ -146,7 +146,7 @@ reserved-memory {
 		ranges;
 
 		rpm_msg_ram: memory@60000 {
-			reg = <0x0 0x60000 0x0 0x6000>;
+			reg = <0x0 0x00060000 0x0 0x6000>;
 			no-map;
 		};
 
@@ -181,7 +181,7 @@ soc: soc {
 
 		prng: qrng@e1000 {
 			compatible = "qcom,prng-ee";
-			reg = <0x0 0xe3000 0x0 0x1000>;
+			reg = <0x0 0x000e3000 0x0 0x1000>;
 			clocks = <&gcc GCC_PRNG_AHB_CLK>;
 			clock-names = "core";
 		};
@@ -388,7 +388,7 @@ v2m@0 {
 
 		pcie_phy: phy@84000 {
 			compatible = "qcom,ipq6018-qmp-pcie-phy";
-			reg = <0x0 0x84000 0x0 0x1bc>; /* Serdes PLL */
+			reg = <0x0 0x00084000 0x0 0x1bc>; /* Serdes PLL */
 			status = "disabled";
 			#address-cells = <2>;
 			#size-cells = <2>;
@@ -404,10 +404,10 @@ pcie_phy: phy@84000 {
 				      "common";
 
 			pcie_phy0: phy@84200 {
-				reg = <0x0 0x84200 0x0 0x16c>, /* Serdes Tx */
-				      <0x0 0x84400 0x0 0x200>, /* Serdes Rx */
-				      <0x0 0x84800 0x0 0x1f0>, /* PCS: Lane0, COM, PCIE */
-				      <0x0 0x84c00 0x0 0xf4>; /* pcs_misc */
+				reg = <0x0 0x00084200 0x0 0x16c>, /* Serdes Tx */
+				      <0x0 0x00084400 0x0 0x200>, /* Serdes Rx */
+				      <0x0 0x00084800 0x0 0x1f0>, /* PCS: Lane0, COM, PCIE */
+				      <0x0 0x00084c00 0x0 0xf4>; /* pcs_misc */
 				#phy-cells = <0>;
 
 				clocks = <&gcc GCC_PCIE0_PIPE_CLK>;
@@ -629,7 +629,7 @@ mdio: mdio@90000 {
 			#address-cells = <1>;
 			#size-cells = <0>;
 			compatible = "qcom,ipq6018-mdio", "qcom,ipq4019-mdio";
-			reg = <0x0 0x90000 0x0 0x64>;
+			reg = <0x0 0x00090000 0x0 0x64>;
 			clocks = <&gcc GCC_MDIO_AHB_CLK>;
 			clock-names = "gcc_mdio_ahb_clk";
 			status = "disabled";
@@ -637,7 +637,7 @@ mdio: mdio@90000 {
 
 		qusb_phy_1: qusb@59000 {
 			compatible = "qcom,ipq6018-qusb2-phy";
-			reg = <0x0 0x059000 0x0 0x180>;
+			reg = <0x0 0x00059000 0x0 0x180>;
 			#phy-cells = <0>;
 
 			clocks = <&gcc GCC_USB1_PHY_CFG_AHB_CLK>,
@@ -670,7 +670,7 @@ usb2: usb@70f8800 {
 
 			dwc_1: usb@7000000 {
 			       compatible = "snps,dwc3";
-			       reg = <0x0 0x7000000 0x0 0xcd00>;
+			       reg = <0x0 0x07000000 0x0 0xcd00>;
 			       interrupts = <GIC_SPI 99 IRQ_TYPE_LEVEL_HIGH>;
 			       phys = <&qusb_phy_1>;
 			       phy-names = "usb2-phy";
@@ -685,7 +685,7 @@ dwc_1: usb@7000000 {
 
 		ssphy_0: ssphy@78000 {
 			compatible = "qcom,ipq6018-qmp-usb3-phy";
-			reg = <0x0 0x78000 0x0 0x1c4>;
+			reg = <0x0 0x00078000 0x0 0x1c4>;
 			#address-cells = <2>;
 			#size-cells = <2>;
 			ranges;
@@ -714,7 +714,7 @@ usb0_ssphy: phy@78200 {
 
 		qusb_phy_0: qusb@79000 {
 			compatible = "qcom,ipq6018-qusb2-phy";
-			reg = <0x0 0x079000 0x0 0x180>;
+			reg = <0x0 0x00079000 0x0 0x180>;
 			#phy-cells = <0>;
 
 			clocks = <&gcc GCC_USB0_PHY_CFG_AHB_CLK>,
-- 
2.43.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B04891714A1;
	Thu, 15 Aug 2024 13:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730174; cv=none; b=Izd70fheolhcUw6T5dvSkNx2JIWscXvvy1p+Ea90TRzsOghMhkwDz0XEbtPH1yTgv0QiQu3lRIkgLDZLYVKcrYY2p2HqNaXHI+tmexqM05daVFkVqehYDZB1wvnUdGpXoeIhI0jrj7FnOsBHTY489UyFu/ov1Koqa0zG0fGe3YA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730174; c=relaxed/simple;
	bh=IE3rDku9+OhPtQozphStHoWKtCX2pJ3C3SVxUW0iekU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I42n/WivRzCmmauFmaJ7vdjAw2Rgpcm1ivprghY3PWbK2Fp2DY/ZBcAyoAKeL+JCJQIsHCZ+3ia3IjFCNEv6Wvi9AzVqVd2qEq9r7junVPLnFFVv6AUbU3pNmDw6qYv7Dr46IjGWDz2ROKf+oyPmV/IqY+z/gNqp9itFSG9GmZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eYMI1p/k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eYMI1p/k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23A4FC32786;
	Thu, 15 Aug 2024 13:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730174;
	bh=IE3rDku9+OhPtQozphStHoWKtCX2pJ3C3SVxUW0iekU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eYMI1p/kUEoRwvyf24iaVT+gmiw4QtuhFolnzLFruaNbM3hDs3KCl9uKxgjdy51nL
	 jT03Gl1hsA03r3QupDJGmihM5RvlflRLW5NK7kZPHoOvJ5NbODsBaW5i8muZNcb/E3
	 wjY3vm8Rf6plXlLLIeVS06y05Fc9xZHzSNL2xTXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Guo <shawn.guo@linaro.org>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 299/484] arm64: dts: qcom: msm8996: Move #clock-cells to QMP PHY child node
Date: Thu, 15 Aug 2024 15:22:37 +0200
Message-ID: <20240815131952.952238204@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

From: Shawn Guo <shawn.guo@linaro.org>

[ Upstream commit 82d61e19fccbf2fe7c018765b3799791916e7f31 ]

'#clock-cells' is a required property of QMP PHY child node, not itself.
Move it to fix the dtbs_check warnings.

There are only '#clock-cells' removal from SM8350 QMP PHY nodes, because
child nodes already have the property.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20210929034253.24570-4-shawn.guo@linaro.org
Stable-dep-of: 0046325ae520 ("arm64: dts: qcom: msm8998: Disable SS instance in Parkmode for USB")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/ipq8074.dtsi | 4 ++--
 arch/arm64/boot/dts/qcom/msm8996.dtsi | 4 ++--
 arch/arm64/boot/dts/qcom/msm8998.dtsi | 2 +-
 arch/arm64/boot/dts/qcom/sm8350.dtsi  | 3 ---
 4 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/ipq8074.dtsi b/arch/arm64/boot/dts/qcom/ipq8074.dtsi
index 17eeff106bab7..0a4c5b847ddd5 100644
--- a/arch/arm64/boot/dts/qcom/ipq8074.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq8074.dtsi
@@ -91,7 +91,6 @@ soc: soc {
 		ssphy_1: phy@58000 {
 			compatible = "qcom,ipq8074-qmp-usb3-phy";
 			reg = <0x00058000 0x1c4>;
-			#clock-cells = <1>;
 			#address-cells = <1>;
 			#size-cells = <1>;
 			ranges;
@@ -112,6 +111,7 @@ usb1_ssphy: phy@58200 {
 				      <0x00058800 0x1f8>,     /* PCS  */
 				      <0x00058600 0x044>;     /* PCS misc*/
 				#phy-cells = <0>;
+				#clock-cells = <1>;
 				clocks = <&gcc GCC_USB1_PIPE_CLK>;
 				clock-names = "pipe0";
 				clock-output-names = "usb3phy_1_cc_pipe_clk";
@@ -134,7 +134,6 @@ qusb_phy_1: phy@59000 {
 		ssphy_0: phy@78000 {
 			compatible = "qcom,ipq8074-qmp-usb3-phy";
 			reg = <0x00078000 0x1c4>;
-			#clock-cells = <1>;
 			#address-cells = <1>;
 			#size-cells = <1>;
 			ranges;
@@ -155,6 +154,7 @@ usb0_ssphy: phy@78200 {
 				      <0x00078800 0x1f8>,     /* PCS  */
 				      <0x00078600 0x044>;     /* PCS misc*/
 				#phy-cells = <0>;
+				#clock-cells = <1>;
 				clocks = <&gcc GCC_USB0_PIPE_CLK>;
 				clock-names = "pipe0";
 				clock-output-names = "usb3phy_0_cc_pipe_clk";
diff --git a/arch/arm64/boot/dts/qcom/msm8996.dtsi b/arch/arm64/boot/dts/qcom/msm8996.dtsi
index 210016ff50449..9b74cf57b6d1c 100644
--- a/arch/arm64/boot/dts/qcom/msm8996.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8996.dtsi
@@ -615,7 +615,6 @@ soc: soc {
 		pcie_phy: phy@34000 {
 			compatible = "qcom,msm8996-qmp-pcie-phy";
 			reg = <0x00034000 0x488>;
-			#clock-cells = <1>;
 			#address-cells = <1>;
 			#size-cells = <1>;
 			ranges;
@@ -637,6 +636,7 @@ pciephy_0: phy@35000 {
 				      <0x00035400 0x1dc>;
 				#phy-cells = <0>;
 
+				#clock-cells = <1>;
 				clock-output-names = "pcie_0_pipe_clk_src";
 				clocks = <&gcc GCC_PCIE_0_PIPE_CLK>;
 				clock-names = "pipe0";
@@ -2642,7 +2642,6 @@ usb3_dwc3: dwc3@6a00000 {
 		usb3phy: phy@7410000 {
 			compatible = "qcom,msm8996-qmp-usb3-phy";
 			reg = <0x07410000 0x1c4>;
-			#clock-cells = <1>;
 			#address-cells = <1>;
 			#size-cells = <1>;
 			ranges;
@@ -2663,6 +2662,7 @@ ssusb_phy_0: phy@7410200 {
 				      <0x07410600 0x1a8>;
 				#phy-cells = <0>;
 
+				#clock-cells = <1>;
 				clock-output-names = "usb3_phy_pipe_clk_src";
 				clocks = <&gcc GCC_USB3_PHY_PIPE_CLK>;
 				clock-names = "pipe0";
diff --git a/arch/arm64/boot/dts/qcom/msm8998.dtsi b/arch/arm64/boot/dts/qcom/msm8998.dtsi
index d636718adbde2..42329e78437e9 100644
--- a/arch/arm64/boot/dts/qcom/msm8998.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8998.dtsi
@@ -1993,7 +1993,6 @@ usb3phy: phy@c010000 {
 			compatible = "qcom,msm8998-qmp-usb3-phy";
 			reg = <0x0c010000 0x18c>;
 			status = "disabled";
-			#clock-cells = <1>;
 			#address-cells = <1>;
 			#size-cells = <1>;
 			ranges;
@@ -2014,6 +2013,7 @@ usb1_ssphy: phy@c010200 {
 				      <0xc010600 0x128>,
 				      <0xc010800 0x200>;
 				#phy-cells = <0>;
+				#clock-cells = <1>;
 				clocks = <&gcc GCC_USB3_PHY_PIPE_CLK>;
 				clock-names = "pipe0";
 				clock-output-names = "usb3_phy_pipe_clk_src";
diff --git a/arch/arm64/boot/dts/qcom/sm8350.dtsi b/arch/arm64/boot/dts/qcom/sm8350.dtsi
index b0ba63b5869d2..8506dc841c869 100644
--- a/arch/arm64/boot/dts/qcom/sm8350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8350.dtsi
@@ -1119,7 +1119,6 @@ ufs_mem_phy: phy@1d87000 {
 			reg = <0 0x01d87000 0 0x1c4>;
 			#address-cells = <2>;
 			#size-cells = <2>;
-			#clock-cells = <1>;
 			ranges;
 			clock-names = "ref",
 				      "ref_aux";
@@ -1254,7 +1253,6 @@ usb_1_qmpphy: phy-wrapper@88e9000 {
 			      <0 0x088e8000 0 0x20>;
 			reg-names = "reg-base", "dp_com";
 			status = "disabled";
-			#clock-cells = <1>;
 			#address-cells = <2>;
 			#size-cells = <2>;
 			ranges;
@@ -1287,7 +1285,6 @@ usb_2_qmpphy: phy-wrapper@88eb000 {
 			compatible = "qcom,sm8350-qmp-usb3-uni-phy";
 			reg = <0 0x088eb000 0 0x200>;
 			status = "disabled";
-			#clock-cells = <1>;
 			#address-cells = <2>;
 			#size-cells = <2>;
 			ranges;
-- 
2.43.0




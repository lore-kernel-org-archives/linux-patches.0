Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F3E71714A1;
	Thu, 15 Aug 2024 13:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730197; cv=none; b=t1VzLjktZTAOmN2rt/QegIvVLm/22OdfGiJlvk4D2ZtqQ8QprRs44hggm7ebbGFICMoIbusq9yI9HEK8sFqyKAzaA6xhwGm8zq6zKnNdBL6R62zKdcRYADLsL2NmPHGuvwWxf34uewAi2tEDPxJYvCCMVpw1gVT4FyXyOTYeFJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730197; c=relaxed/simple;
	bh=ESQZ0of3ve/GHIneBhnc42dYbvB/1ky3VDyN4Cs09xs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lBAKtCtgUcKjVpXePp0g256yNTpyJUjhzcFEQa13a0AlLVztX84IXDFDcLWW8H0K1wEGPpeHNTRoHyoiNkSt+FseH88befJgcTRLnSc3K5+B/x0S+eipnfrQumc0C4cp03Bs6h8d0WweWhmJ72jw8DS9j4cdYF3RppnBP3ZmHwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1VIwcFCI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1VIwcFCI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC426C32786;
	Thu, 15 Aug 2024 13:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730197;
	bh=ESQZ0of3ve/GHIneBhnc42dYbvB/1ky3VDyN4Cs09xs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1VIwcFCIM8u+BRA0Bet0Q4cqUQOs2jtfj/qxwMgh5i6mScuekFZ34OrMUQCKRo7SA
	 ZBLhCyLmFB0fZ6ayCBd8MJuBUsZboUyr2RW4DFrhZHOH/T2oHCePUqqvcjniC41A2Q
	 aznKG7kZEawv53hueXRD8r11+Eon59MyE7gkLqQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 301/484] arm64: dts: qcom: msm8998: switch USB QMP PHY to new style of bindings
Date: Thu, 15 Aug 2024 15:22:39 +0200
Message-ID: <20240815131953.033704581@linuxfoundation.org>
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
index f5772d6efaa8b..8037288359482 100644
--- a/arch/arm64/boot/dts/qcom/msm8998.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8998.dtsi
@@ -1982,7 +1982,7 @@ usb3_dwc3: dwc3@a800000 {
 				interrupts = <GIC_SPI 131 IRQ_TYPE_LEVEL_HIGH>;
 				snps,dis_u2_susphy_quirk;
 				snps,dis_enblslpm_quirk;
-				phys = <&qusb2phy>, <&usb1_ssphy>;
+				phys = <&qusb2phy>, <&usb3phy>;
 				phy-names = "usb2-phy", "usb3-phy";
 				snps,has-lpm-erratum;
 				snps,hird-threshold = /bits/ 8 <0x10>;
@@ -1991,33 +1991,26 @@ usb3_dwc3: dwc3@a800000 {
 
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




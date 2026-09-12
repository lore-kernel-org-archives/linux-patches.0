Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF8C842376B;
	Sat, 12 Sep 2026 10:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209026; cv=none; b=qRHncqSzdtyDtgwbAvSdvUI1MqV7mqqmEgvoTHcZr3NxjPPMQXLOBhVrJSIUFSOC+zn6eX4OM8Qu3xeH0QQBp9BhoR/uaR8a5I2j1dw3NNltTEca86suq/5zwsmRwCVU0F7VvGh+1HPauFmCMdQHZRYn+S3GD6EgSOU0vcqPet8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209026; c=relaxed/simple;
	bh=jiJbyXyiWTsJlyRNnKB8MoKzhqhhBepfkCz7cjK1mjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LPvGZnMEVSFODLLUHr3IBfNYRrSWGvzNLxk+YXi+WWj+1urg4+7UDrgfjpGh5txvC92jzYxxFKO4Z8uxrHuuLN1eZWo331U8i4E41ErStZjaqB8uPT/Yge3NhZ51JlQtG9BAWhKqe1aif6QlCHqVpNjLAyQP2kVSSjWHdC/Kxk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sRfYI646; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sRfYI646"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E39961F000FF;
	Sat, 12 Sep 2026 10:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209024;
	bh=iIgL31nPDZorfbyqmMXsd0AU7zKsxg+Mio+/6N9p2R0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sRfYI646ysE7acJ/o3MMXOd5QmpjXT3xMHfxlyqGdDRMDot36d8eXD2C4S88nNJiA
	 t3VyluAKXpSaubpNLYOm5S0wAU8SGPhYcEB2yQe5dC5I3ltZCk4854NnQQc8+2+3Oy
	 zK8TAtkKFLXrsV0OU8iBMVLIvYr7s7r81rkd/3Cc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0694/1518] arm64: dts: qcom: lemans: move USB PHYs to a proper place
Date: Sat, 12 Sep 2026 08:47:43 +0200
Message-ID: <20260912065639.136651974@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit 883e20433fe586a6d3e1332d25f5e675921fefd9 ]

Sort the lemans.dtsi, moving USB1 and USB2 PHYs to a proper place,
making the DT file sorted by the address.

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250921-refgen-v1-2-9d93e64133ea@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: 19b4c47fc973 ("arm64: dts: qcom: lemans: Fix the PCIe iommu-map entries")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/lemans.dtsi | 100 +++++++++++++--------------
 1 file changed, 50 insertions(+), 50 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/lemans.dtsi b/arch/arm64/boot/dts/qcom/lemans.dtsi
index 496e319d7b111..085129870e42a 100644
--- a/arch/arm64/boot/dts/qcom/lemans.dtsi
+++ b/arch/arm64/boot/dts/qcom/lemans.dtsi
@@ -3905,6 +3905,32 @@ usb_0_hsphy: phy@88e4000 {
 			status = "disabled";
 		};
 
+		usb_1_hsphy: phy@88e6000 {
+			compatible = "qcom,sa8775p-usb-hs-phy",
+				     "qcom,usb-snps-hs-5nm-phy";
+			reg = <0 0x088e6000 0 0x120>;
+			clocks = <&gcc GCC_USB_CLKREF_EN>;
+			clock-names = "ref";
+			resets = <&gcc GCC_USB2_PHY_SEC_BCR>;
+
+			#phy-cells = <0>;
+
+			status = "disabled";
+		};
+
+		usb_2_hsphy: phy@88e7000 {
+			compatible = "qcom,sa8775p-usb-hs-phy",
+				     "qcom,usb-snps-hs-5nm-phy";
+			reg = <0 0x088e7000 0 0x120>;
+			clocks = <&gcc GCC_USB_CLKREF_EN>;
+			clock-names = "ref";
+			resets = <&gcc GCC_USB3_PHY_TERT_BCR>;
+
+			#phy-cells = <0>;
+
+			status = "disabled";
+		};
+
 		usb_0_qmpphy: phy@88e8000 {
 			compatible = "qcom,sa8775p-qmp-usb3-uni-phy";
 			reg = <0 0x088e8000 0 0x2000>;
@@ -3929,6 +3955,30 @@ usb_0_qmpphy: phy@88e8000 {
 			status = "disabled";
 		};
 
+		usb_1_qmpphy: phy@88ea000 {
+			compatible = "qcom,sa8775p-qmp-usb3-uni-phy";
+			reg = <0 0x088ea000 0 0x2000>;
+
+			clocks = <&gcc GCC_USB3_SEC_PHY_AUX_CLK>,
+				 <&gcc GCC_USB_CLKREF_EN>,
+				 <&gcc GCC_USB3_SEC_PHY_COM_AUX_CLK>,
+				 <&gcc GCC_USB3_SEC_PHY_PIPE_CLK>;
+			clock-names = "aux", "ref", "com_aux", "pipe";
+
+			resets = <&gcc GCC_USB3_PHY_SEC_BCR>,
+				 <&gcc GCC_USB3PHY_PHY_SEC_BCR>;
+			reset-names = "phy", "phy_phy";
+
+			power-domains = <&gcc USB30_SEC_GDSC>;
+
+			#clock-cells = <0>;
+			clock-output-names = "usb3_sec_phy_pipe_clk_src";
+
+			#phy-cells = <0>;
+
+			status = "disabled";
+		};
+
 		usb_0: usb@a600000 {
 			compatible = "qcom,sa8775p-dwc3", "qcom,snps-dwc3";
 			reg = <0 0x0a600000 0 0xfc100>;
@@ -3977,43 +4027,6 @@ usb_0: usb@a600000 {
 			status = "disabled";
 		};
 
-		usb_1_hsphy: phy@88e6000 {
-			compatible = "qcom,sa8775p-usb-hs-phy",
-				     "qcom,usb-snps-hs-5nm-phy";
-			reg = <0 0x088e6000 0 0x120>;
-			clocks = <&gcc GCC_USB_CLKREF_EN>;
-			clock-names = "ref";
-			resets = <&gcc GCC_USB2_PHY_SEC_BCR>;
-
-			#phy-cells = <0>;
-
-			status = "disabled";
-		};
-
-		usb_1_qmpphy: phy@88ea000 {
-			compatible = "qcom,sa8775p-qmp-usb3-uni-phy";
-			reg = <0 0x088ea000 0 0x2000>;
-
-			clocks = <&gcc GCC_USB3_SEC_PHY_AUX_CLK>,
-				 <&gcc GCC_USB_CLKREF_EN>,
-				 <&gcc GCC_USB3_SEC_PHY_COM_AUX_CLK>,
-				 <&gcc GCC_USB3_SEC_PHY_PIPE_CLK>;
-			clock-names = "aux", "ref", "com_aux", "pipe";
-
-			resets = <&gcc GCC_USB3_PHY_SEC_BCR>,
-				 <&gcc GCC_USB3PHY_PHY_SEC_BCR>;
-			reset-names = "phy", "phy_phy";
-
-			power-domains = <&gcc USB30_SEC_GDSC>;
-
-			#clock-cells = <0>;
-			clock-output-names = "usb3_sec_phy_pipe_clk_src";
-
-			#phy-cells = <0>;
-
-			status = "disabled";
-		};
-
 		usb_1: usb@a800000 {
 			compatible = "qcom,sa8775p-dwc3", "qcom,snps-dwc3";
 			reg = <0 0x0a800000 0 0xfc100>;
@@ -4062,19 +4075,6 @@ usb_1: usb@a800000 {
 			status = "disabled";
 		};
 
-		usb_2_hsphy: phy@88e7000 {
-			compatible = "qcom,sa8775p-usb-hs-phy",
-				     "qcom,usb-snps-hs-5nm-phy";
-			reg = <0 0x088e7000 0 0x120>;
-			clocks = <&gcc GCC_USB_CLKREF_EN>;
-			clock-names = "ref";
-			resets = <&gcc GCC_USB3_PHY_TERT_BCR>;
-
-			#phy-cells = <0>;
-
-			status = "disabled";
-		};
-
 		usb_2: usb@a400000 {
 			compatible = "qcom,sa8775p-dwc3", "qcom,snps-dwc3";
 			reg = <0 0x0a400000 0 0xfc100>;
-- 
2.53.0




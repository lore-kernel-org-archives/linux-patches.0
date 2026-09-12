Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18DFC364049;
	Sat, 12 Sep 2026 08:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201849; cv=none; b=ew2gfqsVyfMxfZa3XI7ieKQL+WceozYdeFDAHNR6IQplsV32SWnxpLtmIWn2NCDAnBvId+ynqrTRg3eOzPs0+Gm/zff3VIStzUtqZ+ed5rIYew2l7ugRbTDjW5e3QPhZqnO6CZScwweLY8QJiBnasPJkD3dIKRHlpuqcjENDyZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201849; c=relaxed/simple;
	bh=NyyqTNQCcAyuWcTEpAsIYA4ujgns9FYzsqIF4uiSzhU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r4Qa2BDsOQrfc6psZxACbUYT6EJPHypV3kACcjdaXBMBA7VzXOFsBNXqgd3RCzp9Iyfnr0wzSvGU5DlxY3InfSf9buMkhOEUqJBU4qVUbRTxcjhmSc3IeI6WkT+XUH5REN9ezonLolGA13YCq2CIfPZX+dMztfazYwrPv2TcsXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R3J7fJ16; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R3J7fJ16"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDB1C1F000FF;
	Sat, 12 Sep 2026 08:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201848;
	bh=eCBGoR5W/KzmQ7IOUFlUk9jsCqUBNnAfb4DZ07mWJd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R3J7fJ16CPkcvXE1//TaHpULp+A5Z1ZBJqVOwO0VPFggiccpr+A4Dk2vsz9QMZyCM
	 p2phVG94A+6xvSJN0cPaTSpFOks0+ZV5Y2+JzuGuJVV2zgeAJxrQzB+wA0DLz1mNMJ
	 +zcvZmv3FhORZ29uWQkn5E9zUQZO8swsH7V7aR5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1080/1815] arm64: dts: qcom: hamoa: Fix swapped USB QMP PHY vdda-phy/vdda-pll supplies
Date: Sat, 12 Sep 2026 08:47:10 +0200
Message-ID: <20260912065714.374809384@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

[ Upstream commit 4458dcd38295c8bd13957637ba98132ba3f089b0 ]

The QMP PHY expects the vdda-phy supply to be around 0.88V and the
vdda-pll supply to be 1.2V. But these two supplies are swapped for the
USB QMP PHYs on these boards, feeding 1.2V to vdda-phy and 0.9V to
vdda-pll.

Fix it by swapping the two supplies back.

Fixes: 5098ae93ce44 ("arm64: dts: qcom: Add HAMOA-IOT-SOM platform")
Fixes: af241225893a ("arm64: dts: qcom: Add the Lenovo IdeaCentre Mini X")
Fixes: ae5cee8e7349 ("arm64: dts: qcom: x1e80100-crd: Fix USB PHYs regulators")
Fixes: 20676f7819d7 ("arm64: dts: qcom: x1e80100-qcp: Fix USB PHYs regulators")
Fixes: d0e2f8f62dff ("arm64: dts: qcom: Add device tree for ASUS Vivobook S 15")
Fixes: 6516961352a1 ("arm64: dts: qcom: Add support for X1-based Asus Zenbook A14")
Fixes: 45247fe17db2 ("arm64: dts: qcom: x1e80100: add Lenovo Thinkpad Yoga slim 7x devicetree")
Fixes: 6f18b8d4142c ("arm64: dts: qcom: x1e80100-hp-x14: dt for HP Omnibook X Laptop 14")
Fixes: 0d72ccaa1e84 ("arm64: dts: qcom: Add support for X1-based Surface Pro 11")
Fixes: 09d77be56093 ("arm64: dts: qcom: Add support for X1-based Surface Laptop 7 devices")
Fixes: 8cf65490cdb0 ("arm64: dts: qcom: Add dts for Medion SPRCHRGD 14 S1")
Fixes: f5b788d0e8cd ("arm64: dts: qcom: Add support for X1-based Dell XPS 13 9345")
Fixes: 7b8a31e82b87 ("arm64: dts: qcom: Add X1E001DE Snapdragon Devkit for Windows")
Fixes: 7d1cbe2f4985 ("arm64: dts: qcom: Add X1E78100 ThinkPad T14s Gen 6")
Fixes: e7733b42111c ("arm64: dts: qcom: Add support for Dell Inspiron 7441 / Latitude 7455")
Reported-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Assisted-by: Claude:opus-4-8
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260803-phy-supply-fix-v1-18-5880630cde3e@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/hamoa-iot-som.dtsi   | 20 +++++++++----------
 .../hamoa-lenovo-ideacentre-mini-01q8x10.dts  | 20 +++++++++----------
 .../boot/dts/qcom/x1-asus-vivobook-s15.dtsi   | 20 +++++++++----------
 .../boot/dts/qcom/x1-asus-zenbook-a14.dtsi    | 20 +++++++++----------
 arch/arm64/boot/dts/qcom/x1-crd.dtsi          | 20 +++++++++----------
 arch/arm64/boot/dts/qcom/x1-dell-thena.dtsi   | 16 +++++++--------
 .../boot/dts/qcom/x1-hp-omnibook-x14.dtsi     | 12 +++++------
 .../boot/dts/qcom/x1-microsoft-denali.dtsi    |  8 ++++----
 arch/arm64/boot/dts/qcom/x1e001de-devkit.dts  | 20 +++++++++----------
 .../qcom/x1e78100-lenovo-thinkpad-t14s.dtsi   | 20 +++++++++----------
 .../dts/qcom/x1e80100-dell-xps13-9345.dts     | 16 +++++++--------
 .../dts/qcom/x1e80100-lenovo-yoga-slim7x.dts  | 12 +++++------
 .../qcom/x1e80100-medion-sprchrgd-14-s1.dts   | 16 +++++++--------
 .../dts/qcom/x1e80100-microsoft-romulus.dtsi  | 16 +++++++--------
 arch/arm64/boot/dts/qcom/x1e80100-qcp.dts     | 20 +++++++++----------
 15 files changed, 128 insertions(+), 128 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/hamoa-iot-som.dtsi b/arch/arm64/boot/dts/qcom/hamoa-iot-som.dtsi
index 9c5e77df00547..bc70fe5db96f5 100644
--- a/arch/arm64/boot/dts/qcom/hamoa-iot-som.dtsi
+++ b/arch/arm64/boot/dts/qcom/hamoa-iot-som.dtsi
@@ -590,8 +590,8 @@ &usb_1_ss0_hsphy {
 };
 
 &usb_1_ss0_qmpphy {
-	vdda-phy-supply = <&vreg_l2j_1p2>;
-	vdda-pll-supply = <&vreg_l1j_0p8>;
+	vdda-phy-supply = <&vreg_l1j_0p8>;
+	vdda-pll-supply = <&vreg_l2j_1p2>;
 
 	status = "okay";
 };
@@ -611,8 +611,8 @@ &usb_1_ss1_hsphy {
 };
 
 &usb_1_ss1_qmpphy {
-	vdda-phy-supply = <&vreg_l2j_1p2>;
-	vdda-pll-supply = <&vreg_l2d_0p9>;
+	vdda-phy-supply = <&vreg_l2d_0p9>;
+	vdda-pll-supply = <&vreg_l2j_1p2>;
 
 	status = "okay";
 };
@@ -632,8 +632,8 @@ &usb_1_ss2_hsphy {
 };
 
 &usb_1_ss2_qmpphy {
-	vdda-phy-supply = <&vreg_l2j_1p2>;
-	vdda-pll-supply = <&vreg_l2d_0p9>;
+	vdda-phy-supply = <&vreg_l2d_0p9>;
+	vdda-pll-supply = <&vreg_l2j_1p2>;
 
 	status = "okay";
 };
@@ -670,15 +670,15 @@ &usb_mp_hsphy1 {
 };
 
 &usb_mp_qmpphy0 {
-	vdda-phy-supply = <&vreg_l3e_1p2>;
-	vdda-pll-supply = <&vreg_l3c_0p8>;
+	vdda-phy-supply = <&vreg_l3c_0p8>;
+	vdda-pll-supply = <&vreg_l3e_1p2>;
 
 	status = "okay";
 };
 
 &usb_mp_qmpphy1 {
-	vdda-phy-supply = <&vreg_l3e_1p2>;
-	vdda-pll-supply = <&vreg_l3c_0p8>;
+	vdda-phy-supply = <&vreg_l3c_0p8>;
+	vdda-pll-supply = <&vreg_l3e_1p2>;
 
 	status = "okay";
 };
diff --git a/arch/arm64/boot/dts/qcom/hamoa-lenovo-ideacentre-mini-01q8x10.dts b/arch/arm64/boot/dts/qcom/hamoa-lenovo-ideacentre-mini-01q8x10.dts
index bfb7cea56df96..2848250083891 100644
--- a/arch/arm64/boot/dts/qcom/hamoa-lenovo-ideacentre-mini-01q8x10.dts
+++ b/arch/arm64/boot/dts/qcom/hamoa-lenovo-ideacentre-mini-01q8x10.dts
@@ -1101,8 +1101,8 @@ &usb_1_ss0_hsphy {
 };
 
 &usb_1_ss0_qmpphy {
-	vdda-phy-supply = <&vreg_l2j>;
-	vdda-pll-supply = <&vreg_l1j>;
+	vdda-phy-supply = <&vreg_l1j>;
+	vdda-pll-supply = <&vreg_l2j>;
 
 	status = "okay";
 };
@@ -1112,8 +1112,8 @@ &usb_1_ss0_qmpphy_out {
 };
 
 &usb_1_ss1_qmpphy {
-	vdda-phy-supply = <&vreg_l2j>;
-	vdda-pll-supply = <&vreg_l2d>;
+	vdda-phy-supply = <&vreg_l2d>;
+	vdda-pll-supply = <&vreg_l2j>;
 
 	/delete-property/ mode-switch;
 	/delete-property/ orientation-switch;
@@ -1138,8 +1138,8 @@ usb_1_ss1_qmpphy_out_dp: endpoint@0 {
 };
 
 &usb_1_ss2_qmpphy {
-	vdda-phy-supply = <&vreg_l2j>;
-	vdda-pll-supply = <&vreg_l2d>;
+	vdda-phy-supply = <&vreg_l2d>;
+	vdda-pll-supply = <&vreg_l2j>;
 
 	/delete-property/ mode-switch;
 	/delete-property/ orientation-switch;
@@ -1186,15 +1186,15 @@ &usb_mp_hsphy1 {
 };
 
 &usb_mp_qmpphy0 {
-	vdda-phy-supply = <&vreg_l3e>;
-	vdda-pll-supply = <&vreg_l3c>;
+	vdda-phy-supply = <&vreg_l3c>;
+	vdda-pll-supply = <&vreg_l3e>;
 
 	status = "okay";
 };
 
 &usb_mp_qmpphy1 {
-	vdda-phy-supply = <&vreg_l3e>;
-	vdda-pll-supply = <&vreg_l3c>;
+	vdda-phy-supply = <&vreg_l3c>;
+	vdda-pll-supply = <&vreg_l3e>;
 
 	status = "okay";
 };
diff --git a/arch/arm64/boot/dts/qcom/x1-asus-vivobook-s15.dtsi b/arch/arm64/boot/dts/qcom/x1-asus-vivobook-s15.dtsi
index 48c4ad648354e..0dc7c1b5a14a0 100644
--- a/arch/arm64/boot/dts/qcom/x1-asus-vivobook-s15.dtsi
+++ b/arch/arm64/boot/dts/qcom/x1-asus-vivobook-s15.dtsi
@@ -1226,8 +1226,8 @@ &usb_1_ss0_hsphy {
 };
 
 &usb_1_ss0_qmpphy {
-	vdda-phy-supply = <&vreg_l2j_1p2>;
-	vdda-pll-supply = <&vreg_l1j_0p8>;
+	vdda-phy-supply = <&vreg_l1j_0p8>;
+	vdda-pll-supply = <&vreg_l2j_1p2>;
 
 	status = "okay";
 };
@@ -1256,8 +1256,8 @@ &usb_1_ss1_hsphy {
 };
 
 &usb_1_ss1_qmpphy {
-	vdda-phy-supply = <&vreg_l2j_1p2>;
-	vdda-pll-supply = <&vreg_l2d_0p9>;
+	vdda-phy-supply = <&vreg_l2d_0p9>;
+	vdda-pll-supply = <&vreg_l2j_1p2>;
 
 	status = "okay";
 };
@@ -1277,8 +1277,8 @@ &usb_1_ss1_qmpphy_out {
 };
 
 &usb_1_ss2_qmpphy {
-	vdda-phy-supply = <&vreg_l2j_1p2>;
-	vdda-pll-supply = <&vreg_l2d_0p9>;
+	vdda-phy-supply = <&vreg_l2d_0p9>;
+	vdda-pll-supply = <&vreg_l2j_1p2>;
 
 	/delete-property/ mode-switch;
 	/delete-property/ orientation-switch;
@@ -1342,15 +1342,15 @@ &usb_mp_hsphy1 {
 };
 
 &usb_mp_qmpphy0 {
-	vdda-phy-supply = <&vreg_l3e_1p2>;
-	vdda-pll-supply = <&vreg_l3c_0p8>;
+	vdda-phy-supply = <&vreg_l3c_0p8>;
+	vdda-pll-supply = <&vreg_l3e_1p2>;
 
 	status = "okay";
 };
 
 &usb_mp_qmpphy1 {
-	vdda-phy-supply = <&vreg_l3e_1p2>;
-	vdda-pll-supply = <&vreg_l3c_0p8>;
+	vdda-phy-supply = <&vreg_l3c_0p8>;
+	vdda-pll-supply = <&vreg_l3e_1p2>;
 
 	status = "okay";
 };
diff --git a/arch/arm64/boot/dts/qcom/x1-asus-zenbook-a14.dtsi b/arch/arm64/boot/dts/qcom/x1-asus-zenbook-a14.dtsi
index 66d566808f583..59cbbfbce4905 100644
--- a/arch/arm64/boot/dts/qcom/x1-asus-zenbook-a14.dtsi
+++ b/arch/arm64/boot/dts/qcom/x1-asus-zenbook-a14.dtsi
@@ -1454,8 +1454,8 @@ &usb_1_ss0_hsphy {
 };
 
 &usb_1_ss0_qmpphy {
-	vdda-phy-supply = <&vreg_l2j_1p2>;
-	vdda-pll-supply = <&vreg_l1j_0p9>;
+	vdda-phy-supply = <&vreg_l1j_0p9>;
+	vdda-pll-supply = <&vreg_l2j_1p2>;
 
 	status = "okay";
 };
@@ -1484,8 +1484,8 @@ &usb_1_ss1_hsphy {
 };
 
 &usb_1_ss1_qmpphy {
-	vdda-phy-supply = <&vreg_l2j_1p2>;
-	vdda-pll-supply = <&vreg_l2d_0p9>;
+	vdda-phy-supply = <&vreg_l2d_0p9>;
+	vdda-pll-supply = <&vreg_l2j_1p2>;
 
 	status = "okay";
 };
@@ -1505,8 +1505,8 @@ &usb_1_ss1_qmpphy_out {
 };
 
 &usb_1_ss2_qmpphy {
-	vdda-phy-supply = <&vreg_l2j_1p2>;
-	vdda-pll-supply = <&vreg_l2d_0p9>;
+	vdda-phy-supply = <&vreg_l2d_0p9>;
+	vdda-pll-supply = <&vreg_l2j_1p2>;
 
 	/delete-property/ mode-switch;
 	/delete-property/ orientation-switch;
@@ -1551,15 +1551,15 @@ &usb_mp_hsphy1 {
 };
 
 &usb_mp_qmpphy0 {
-	vdda-phy-supply = <&vreg_l3e_1p2>;
-	vdda-pll-supply = <&vreg_l3c_0p9>;
+	vdda-phy-supply = <&vreg_l3c_0p9>;
+	vdda-pll-supply = <&vreg_l3e_1p2>;
 
 	status = "okay";
 };
 
 &usb_mp_qmpphy1 {
-	vdda-phy-supply = <&vreg_l3e_1p2>;
-	vdda-pll-supply = <&vreg_l3c_0p9>;
+	vdda-phy-supply = <&vreg_l3c_0p9>;
+	vdda-pll-supply = <&vreg_l3e_1p2>;
 
 	status = "okay";
 };
diff --git a/arch/arm64/boot/dts/qcom/x1-crd.dtsi b/arch/arm64/boot/dts/qcom/x1-crd.dtsi
index a9c5c523575ee..107fe2867e736 100644
--- a/arch/arm64/boot/dts/qcom/x1-crd.dtsi
+++ b/arch/arm64/boot/dts/qcom/x1-crd.dtsi
@@ -1734,8 +1734,8 @@ &usb_1_ss0_hsphy {
 };
 
 &usb_1_ss0_qmpphy {
-	vdda-phy-supply = <&vreg_l2j_1p2>;
-	vdda-pll-supply = <&vreg_l1j_0p8>;
+	vdda-phy-supply = <&vreg_l1j_0p8>;
+	vdda-pll-supply = <&vreg_l2j_1p2>;
 
 	status = "okay";
 };
@@ -1764,8 +1764,8 @@ &usb_1_ss1_hsphy {
 };
 
 &usb_1_ss1_qmpphy {
-	vdda-phy-supply = <&vreg_l2j_1p2>;
-	vdda-pll-supply = <&vreg_l2d_0p9>;
+	vdda-phy-supply = <&vreg_l2d_0p9>;
+	vdda-pll-supply = <&vreg_l2j_1p2>;
 
 	status = "okay";
 };
@@ -1794,8 +1794,8 @@ &usb_1_ss2_hsphy {
 };
 
 &usb_1_ss2_qmpphy {
-	vdda-phy-supply = <&vreg_l2j_1p2>;
-	vdda-pll-supply = <&vreg_l2d_0p9>;
+	vdda-phy-supply = <&vreg_l2d_0p9>;
+	vdda-pll-supply = <&vreg_l2j_1p2>;
 
 	status = "okay";
 };
@@ -1836,15 +1836,15 @@ &usb_mp_hsphy1 {
 };
 
 &usb_mp_qmpphy0 {
-	vdda-phy-supply = <&vreg_l3e_1p2>;
-	vdda-pll-supply = <&vreg_l3c_0p8>;
+	vdda-phy-supply = <&vreg_l3c_0p8>;
+	vdda-pll-supply = <&vreg_l3e_1p2>;
 
 	status = "okay";
 };
 
 &usb_mp_qmpphy1 {
-	vdda-phy-supply = <&vreg_l3e_1p2>;
-	vdda-pll-supply = <&vreg_l3c_0p8>;
+	vdda-phy-supply = <&vreg_l3c_0p8>;
+	vdda-pll-supply = <&vreg_l3e_1p2>;
 
 	status = "okay";
 };
diff --git a/arch/arm64/boot/dts/qcom/x1-dell-thena.dtsi b/arch/arm64/boot/dts/qcom/x1-dell-thena.dtsi
index d6de4da02dcd3..4cda708455d84 100644
--- a/arch/arm64/boot/dts/qcom/x1-dell-thena.dtsi
+++ b/arch/arm64/boot/dts/qcom/x1-dell-thena.dtsi
@@ -1570,8 +1570,8 @@ &usb_1_ss0_hsphy {
 };
 
 &usb_1_ss0_qmpphy {
-	vdda-phy-supply = <&vreg_l2j_1p2>;
-	vdda-pll-supply = <&vreg_l1j_0p8>;
+	vdda-phy-supply = <&vreg_l1j_0p8>;
+	vdda-pll-supply = <&vreg_l2j_1p2>;
 
 	status = "okay";
 };
@@ -1600,8 +1600,8 @@ &usb_1_ss1_hsphy {
 };
 
 &usb_1_ss1_qmpphy {
-	vdda-phy-supply = <&vreg_l2j_1p2>;
-	vdda-pll-supply = <&vreg_l2d_0p9>;
+	vdda-phy-supply = <&vreg_l2d_0p9>;
+	vdda-pll-supply = <&vreg_l2j_1p2>;
 
 	status = "okay";
 };
@@ -1639,8 +1639,8 @@ &usb_mp_hsphy0 {
 };
 
 &usb_mp_qmpphy0 {
-	vdda-phy-supply = <&vreg_l3e_1p2>;
-	vdda-pll-supply = <&vreg_l3c_0p8>;
+	vdda-phy-supply = <&vreg_l3c_0p8>;
+	vdda-pll-supply = <&vreg_l3e_1p2>;
 
 	status = "okay";
 };
@@ -1653,8 +1653,8 @@ &usb_mp_hsphy1 {
 };
 
 &usb_mp_qmpphy1 {
-	vdda-phy-supply = <&vreg_l3e_1p2>;
-	vdda-pll-supply = <&vreg_l3c_0p8>;
+	vdda-phy-supply = <&vreg_l3c_0p8>;
+	vdda-pll-supply = <&vreg_l3e_1p2>;
 
 	status = "okay";
 };
diff --git a/arch/arm64/boot/dts/qcom/x1-hp-omnibook-x14.dtsi b/arch/arm64/boot/dts/qcom/x1-hp-omnibook-x14.dtsi
index 02708f23a8657..dba8cee43e294 100644
--- a/arch/arm64/boot/dts/qcom/x1-hp-omnibook-x14.dtsi
+++ b/arch/arm64/boot/dts/qcom/x1-hp-omnibook-x14.dtsi
@@ -1466,8 +1466,8 @@ &usb_1_ss0_hsphy {
 };
 
 &usb_1_ss0_qmpphy {
-	vdda-phy-supply = <&vreg_l3e_1p2>;
-	vdda-pll-supply = <&vreg_l1j_0p8>;
+	vdda-phy-supply = <&vreg_l1j_0p8>;
+	vdda-pll-supply = <&vreg_l3e_1p2>;
 
 	status = "okay";
 };
@@ -1496,8 +1496,8 @@ &usb_1_ss1_hsphy {
 };
 
 &usb_1_ss1_qmpphy {
-	vdda-phy-supply = <&vreg_l3e_1p2>;
-	vdda-pll-supply = <&vreg_l2d_0p9>;
+	vdda-phy-supply = <&vreg_l2d_0p9>;
+	vdda-pll-supply = <&vreg_l3e_1p2>;
 
 	status = "okay";
 };
@@ -1533,8 +1533,8 @@ &usb_mp_hsphy0 {
 };
 
 &usb_mp_qmpphy0 {
-	vdda-phy-supply = <&vreg_l3e_1p2>;
-	vdda-pll-supply = <&vreg_l3c_0p8>;
+	vdda-phy-supply = <&vreg_l3c_0p8>;
+	vdda-pll-supply = <&vreg_l3e_1p2>;
 
 	status = "okay";
 };
diff --git a/arch/arm64/boot/dts/qcom/x1-microsoft-denali.dtsi b/arch/arm64/boot/dts/qcom/x1-microsoft-denali.dtsi
index 7559557610ed4..ce7d958ca6879 100644
--- a/arch/arm64/boot/dts/qcom/x1-microsoft-denali.dtsi
+++ b/arch/arm64/boot/dts/qcom/x1-microsoft-denali.dtsi
@@ -1268,8 +1268,8 @@ &usb_1_ss0_hsphy {
 };
 
 &usb_1_ss0_qmpphy {
-	vdda-phy-supply = <&vreg_l2j_1p2>;
-	vdda-pll-supply = <&vreg_l1j_0p8>;
+	vdda-phy-supply = <&vreg_l1j_0p8>;
+	vdda-pll-supply = <&vreg_l2j_1p2>;
 
 	status = "okay";
 };
@@ -1298,8 +1298,8 @@ &usb_1_ss1_hsphy {
 };
 
 &usb_1_ss1_qmpphy {
-	vdda-phy-supply = <&vreg_l2j_1p2>;
-	vdda-pll-supply = <&vreg_l2d_0p9>;
+	vdda-phy-supply = <&vreg_l2d_0p9>;
+	vdda-pll-supply = <&vreg_l2j_1p2>;
 
 	status = "okay";
 };
diff --git a/arch/arm64/boot/dts/qcom/x1e001de-devkit.dts b/arch/arm64/boot/dts/qcom/x1e001de-devkit.dts
index 2e38402e2c140..be1a8ac8c699e 100644
--- a/arch/arm64/boot/dts/qcom/x1e001de-devkit.dts
+++ b/arch/arm64/boot/dts/qcom/x1e001de-devkit.dts
@@ -1382,8 +1382,8 @@ &usb_1_ss0_hsphy {
 };
 
 &usb_1_ss0_qmpphy {
-	vdda-phy-supply = <&vreg_l2j_1p2>;
-	vdda-pll-supply = <&vreg_l1j_0p8>;
+	vdda-phy-supply = <&vreg_l1j_0p8>;
+	vdda-pll-supply = <&vreg_l2j_1p2>;
 
 	status = "okay";
 };
@@ -1413,8 +1413,8 @@ &usb_1_ss1_hsphy {
 };
 
 &usb_1_ss1_qmpphy {
-	vdda-phy-supply = <&vreg_l2j_1p2>;
-	vdda-pll-supply = <&vreg_l2d_0p9>;
+	vdda-phy-supply = <&vreg_l2d_0p9>;
+	vdda-pll-supply = <&vreg_l2j_1p2>;
 
 	status = "okay";
 };
@@ -1443,8 +1443,8 @@ &usb_1_ss2_hsphy {
 };
 
 &usb_1_ss2_qmpphy {
-	vdda-phy-supply = <&vreg_l2j_1p2>;
-	vdda-pll-supply = <&vreg_l2d_0p9>;
+	vdda-phy-supply = <&vreg_l2d_0p9>;
+	vdda-pll-supply = <&vreg_l2j_1p2>;
 
 	status = "okay";
 };
@@ -1486,15 +1486,15 @@ &usb_mp_hsphy1 {
 };
 
 &usb_mp_qmpphy0 {
-	vdda-phy-supply = <&vreg_l3e_1p2>;
-	vdda-pll-supply = <&vreg_l3c_0p8>;
+	vdda-phy-supply = <&vreg_l3c_0p8>;
+	vdda-pll-supply = <&vreg_l3e_1p2>;
 
 	status = "okay";
 };
 
 &usb_mp_qmpphy1 {
-	vdda-phy-supply = <&vreg_l3e_1p2>;
-	vdda-pll-supply = <&vreg_l3c_0p8>;
+	vdda-phy-supply = <&vreg_l3c_0p8>;
+	vdda-pll-supply = <&vreg_l3e_1p2>;
 
 	status = "okay";
 };
diff --git a/arch/arm64/boot/dts/qcom/x1e78100-lenovo-thinkpad-t14s.dtsi b/arch/arm64/boot/dts/qcom/x1e78100-lenovo-thinkpad-t14s.dtsi
index 5d49df41be02a..0bee2a3d6e7a9 100644
--- a/arch/arm64/boot/dts/qcom/x1e78100-lenovo-thinkpad-t14s.dtsi
+++ b/arch/arm64/boot/dts/qcom/x1e78100-lenovo-thinkpad-t14s.dtsi
@@ -1601,8 +1601,8 @@ &usb_1_ss0_hsphy {
 };
 
 &usb_1_ss0_qmpphy {
-	vdda-phy-supply = <&vreg_l2j_1p2>;
-	vdda-pll-supply = <&vreg_l1j_0p8>;
+	vdda-phy-supply = <&vreg_l1j_0p8>;
+	vdda-pll-supply = <&vreg_l2j_1p2>;
 
 	status = "okay";
 };
@@ -1631,8 +1631,8 @@ &usb_1_ss1_hsphy {
 };
 
 &usb_1_ss1_qmpphy {
-	vdda-phy-supply = <&vreg_l2j_1p2>;
-	vdda-pll-supply = <&vreg_l2d_0p9>;
+	vdda-phy-supply = <&vreg_l2d_0p9>;
+	vdda-pll-supply = <&vreg_l2j_1p2>;
 
 	status = "okay";
 };
@@ -1652,8 +1652,8 @@ &usb_1_ss1_qmpphy_out {
 };
 
 &usb_1_ss2_qmpphy {
-	vdda-phy-supply = <&vreg_l2j_1p2>;
-	vdda-pll-supply = <&vreg_l2d_0p9>;
+	vdda-phy-supply = <&vreg_l2d_0p9>;
+	vdda-pll-supply = <&vreg_l2j_1p2>;
 
 	/delete-property/ mode-switch;
 	/delete-property/ orientation-switch;
@@ -1717,15 +1717,15 @@ &usb_mp_hsphy1 {
 };
 
 &usb_mp_qmpphy0 {
-	vdda-phy-supply = <&vreg_l3e_1p2>;
-	vdda-pll-supply = <&vreg_l3c_0p8>;
+	vdda-phy-supply = <&vreg_l3c_0p8>;
+	vdda-pll-supply = <&vreg_l3e_1p2>;
 
 	status = "okay";
 };
 
 &usb_mp_qmpphy1 {
-	vdda-phy-supply = <&vreg_l3e_1p2>;
-	vdda-pll-supply = <&vreg_l3c_0p8>;
+	vdda-phy-supply = <&vreg_l3c_0p8>;
+	vdda-pll-supply = <&vreg_l3e_1p2>;
 
 	status = "okay";
 };
diff --git a/arch/arm64/boot/dts/qcom/x1e80100-dell-xps13-9345.dts b/arch/arm64/boot/dts/qcom/x1e80100-dell-xps13-9345.dts
index ce7b10ea89b6d..2be5a37c00ccc 100644
--- a/arch/arm64/boot/dts/qcom/x1e80100-dell-xps13-9345.dts
+++ b/arch/arm64/boot/dts/qcom/x1e80100-dell-xps13-9345.dts
@@ -1286,8 +1286,8 @@ &usb_1_ss0_hsphy {
 };
 
 &usb_1_ss0_qmpphy {
-	vdda-phy-supply = <&vreg_l2j_1p2>;
-	vdda-pll-supply = <&vreg_l1j_0p9>;
+	vdda-phy-supply = <&vreg_l1j_0p9>;
+	vdda-pll-supply = <&vreg_l2j_1p2>;
 
 	status = "okay";
 };
@@ -1316,8 +1316,8 @@ &usb_1_ss1_hsphy {
 };
 
 &usb_1_ss1_qmpphy {
-	vdda-phy-supply = <&vreg_l2j_1p2>;
-	vdda-pll-supply = <&vreg_l2d_0p9>;
+	vdda-phy-supply = <&vreg_l2d_0p9>;
+	vdda-pll-supply = <&vreg_l2j_1p2>;
 
 	status = "okay";
 };
@@ -1357,15 +1357,15 @@ &usb_mp_hsphy1 {
 };
 
 &usb_mp_qmpphy0 {
-	vdda-phy-supply = <&vreg_l3e_1p2>;
-	vdda-pll-supply = <&vreg_l3c_0p9>;
+	vdda-phy-supply = <&vreg_l3c_0p9>;
+	vdda-pll-supply = <&vreg_l3e_1p2>;
 
 	status = "okay";
 };
 
 &usb_mp_qmpphy1 {
-	vdda-phy-supply = <&vreg_l3e_1p2>;
-	vdda-pll-supply = <&vreg_l3c_0p9>;
+	vdda-phy-supply = <&vreg_l3c_0p9>;
+	vdda-pll-supply = <&vreg_l3e_1p2>;
 
 	status = "okay";
 };
diff --git a/arch/arm64/boot/dts/qcom/x1e80100-lenovo-yoga-slim7x.dts b/arch/arm64/boot/dts/qcom/x1e80100-lenovo-yoga-slim7x.dts
index beb1475d7fa0c..9eb2dfd99f20d 100644
--- a/arch/arm64/boot/dts/qcom/x1e80100-lenovo-yoga-slim7x.dts
+++ b/arch/arm64/boot/dts/qcom/x1e80100-lenovo-yoga-slim7x.dts
@@ -1564,8 +1564,8 @@ &usb_1_ss0_hsphy {
 };
 
 &usb_1_ss0_qmpphy {
-	vdda-phy-supply = <&vreg_l2j_1p2>;
-	vdda-pll-supply = <&vreg_l1j_0p8>;
+	vdda-phy-supply = <&vreg_l1j_0p8>;
+	vdda-pll-supply = <&vreg_l2j_1p2>;
 
 	status = "okay";
 };
@@ -1594,8 +1594,8 @@ &usb_1_ss1_hsphy {
 };
 
 &usb_1_ss1_qmpphy {
-	vdda-phy-supply = <&vreg_l2j_1p2>;
-	vdda-pll-supply = <&vreg_l2d_0p9>;
+	vdda-phy-supply = <&vreg_l2d_0p9>;
+	vdda-pll-supply = <&vreg_l2j_1p2>;
 
 	status = "okay";
 };
@@ -1624,8 +1624,8 @@ &usb_1_ss2_hsphy {
 };
 
 &usb_1_ss2_qmpphy {
-	vdda-phy-supply = <&vreg_l2j_1p2>;
-	vdda-pll-supply = <&vreg_l2d_0p9>;
+	vdda-phy-supply = <&vreg_l2d_0p9>;
+	vdda-pll-supply = <&vreg_l2j_1p2>;
 
 	status = "okay";
 };
diff --git a/arch/arm64/boot/dts/qcom/x1e80100-medion-sprchrgd-14-s1.dts b/arch/arm64/boot/dts/qcom/x1e80100-medion-sprchrgd-14-s1.dts
index f95b1f9f439d3..e4a0b86847cdd 100644
--- a/arch/arm64/boot/dts/qcom/x1e80100-medion-sprchrgd-14-s1.dts
+++ b/arch/arm64/boot/dts/qcom/x1e80100-medion-sprchrgd-14-s1.dts
@@ -1407,8 +1407,8 @@ &usb_1_ss0_hsphy {
 };
 
 &usb_1_ss0_qmpphy {
-	vdda-phy-supply = <&vreg_l2j_1p2>;
-	vdda-pll-supply = <&vreg_l1j_0p9>;
+	vdda-phy-supply = <&vreg_l1j_0p9>;
+	vdda-pll-supply = <&vreg_l2j_1p2>;
 
 	status = "okay";
 };
@@ -1428,8 +1428,8 @@ &usb_1_ss0_qmpphy_out {
 };
 
 &usb_1_ss2_qmpphy {
-	vdda-phy-supply = <&vreg_l2j_1p2>;
-	vdda-pll-supply = <&vreg_l2d_0p9>;
+	vdda-phy-supply = <&vreg_l2d_0p9>;
+	vdda-pll-supply = <&vreg_l2j_1p2>;
 
 	/delete-property/ mode-switch;
 	/delete-property/ orientation-switch;
@@ -1497,16 +1497,16 @@ &usb_mp_hsphy1 {
 
 /* Right side USB-A (USB-SS 3) */
 &usb_mp_qmpphy0 {
-	vdda-phy-supply = <&vreg_l3e_1p2>;
-	vdda-pll-supply = <&vreg_l3c_0p9>;
+	vdda-phy-supply = <&vreg_l3c_0p9>;
+	vdda-pll-supply = <&vreg_l3e_1p2>;
 
 	status = "okay";
 };
 
 /* Left side USB-A (USB-SS 4) */
 &usb_mp_qmpphy1 {
-	vdda-phy-supply = <&vreg_l3e_1p2>;
-	vdda-pll-supply = <&vreg_l3c_0p9>;
+	vdda-phy-supply = <&vreg_l3c_0p9>;
+	vdda-pll-supply = <&vreg_l3e_1p2>;
 
 	status = "okay";
 };
diff --git a/arch/arm64/boot/dts/qcom/x1e80100-microsoft-romulus.dtsi b/arch/arm64/boot/dts/qcom/x1e80100-microsoft-romulus.dtsi
index 28342cb84ded7..13d0f09e0c2a1 100644
--- a/arch/arm64/boot/dts/qcom/x1e80100-microsoft-romulus.dtsi
+++ b/arch/arm64/boot/dts/qcom/x1e80100-microsoft-romulus.dtsi
@@ -1491,8 +1491,8 @@ &usb_1_ss0_hsphy {
 };
 
 &usb_1_ss0_qmpphy {
-	vdda-phy-supply = <&vreg_l2j>;
-	vdda-pll-supply = <&vreg_l1j>;
+	vdda-phy-supply = <&vreg_l1j>;
+	vdda-pll-supply = <&vreg_l2j>;
 
 	status = "okay";
 };
@@ -1521,8 +1521,8 @@ &usb_1_ss1_hsphy {
 };
 
 &usb_1_ss1_qmpphy {
-	vdda-phy-supply = <&vreg_l2j>;
-	vdda-pll-supply = <&vreg_l2d>;
+	vdda-phy-supply = <&vreg_l2d>;
+	vdda-pll-supply = <&vreg_l2j>;
 
 	status = "okay";
 };
@@ -1565,15 +1565,15 @@ &usb_mp_hsphy1 {
 };
 
 &usb_mp_qmpphy0 {
-	vdda-phy-supply = <&vreg_l3e>;
-	vdda-pll-supply = <&vreg_l3c>;
+	vdda-phy-supply = <&vreg_l3c>;
+	vdda-pll-supply = <&vreg_l3e>;
 
 	status = "okay";
 };
 
 &usb_mp_qmpphy1 {
-	vdda-phy-supply = <&vreg_l3e>;
-	vdda-pll-supply = <&vreg_l3c>;
+	vdda-phy-supply = <&vreg_l3c>;
+	vdda-pll-supply = <&vreg_l3e>;
 
 	status = "okay";
 };
diff --git a/arch/arm64/boot/dts/qcom/x1e80100-qcp.dts b/arch/arm64/boot/dts/qcom/x1e80100-qcp.dts
index 8afbac349cc91..78380fec8839e 100644
--- a/arch/arm64/boot/dts/qcom/x1e80100-qcp.dts
+++ b/arch/arm64/boot/dts/qcom/x1e80100-qcp.dts
@@ -1416,8 +1416,8 @@ &usb_1_ss0_hsphy {
 };
 
 &usb_1_ss0_qmpphy {
-	vdda-phy-supply = <&vreg_l2j_1p2>;
-	vdda-pll-supply = <&vreg_l1j_0p8>;
+	vdda-phy-supply = <&vreg_l1j_0p8>;
+	vdda-pll-supply = <&vreg_l2j_1p2>;
 
 	status = "okay";
 };
@@ -1446,8 +1446,8 @@ &usb_1_ss1_hsphy {
 };
 
 &usb_1_ss1_qmpphy {
-	vdda-phy-supply = <&vreg_l2j_1p2>;
-	vdda-pll-supply = <&vreg_l2d_0p9>;
+	vdda-phy-supply = <&vreg_l2d_0p9>;
+	vdda-pll-supply = <&vreg_l2j_1p2>;
 
 	status = "okay";
 };
@@ -1476,8 +1476,8 @@ &usb_1_ss2_hsphy {
 };
 
 &usb_1_ss2_qmpphy {
-	vdda-phy-supply = <&vreg_l2j_1p2>;
-	vdda-pll-supply = <&vreg_l2d_0p9>;
+	vdda-phy-supply = <&vreg_l2d_0p9>;
+	vdda-pll-supply = <&vreg_l2j_1p2>;
 
 	status = "okay";
 };
@@ -1519,15 +1519,15 @@ &usb_mp_hsphy1 {
 };
 
 &usb_mp_qmpphy0 {
-	vdda-phy-supply = <&vreg_l3e_1p2>;
-	vdda-pll-supply = <&vreg_l3c_0p8>;
+	vdda-phy-supply = <&vreg_l3c_0p8>;
+	vdda-pll-supply = <&vreg_l3e_1p2>;
 
 	status = "okay";
 };
 
 &usb_mp_qmpphy1 {
-	vdda-phy-supply = <&vreg_l3e_1p2>;
-	vdda-pll-supply = <&vreg_l3c_0p8>;
+	vdda-phy-supply = <&vreg_l3c_0p8>;
+	vdda-pll-supply = <&vreg_l3e_1p2>;
 
 	status = "okay";
 };
-- 
2.53.0




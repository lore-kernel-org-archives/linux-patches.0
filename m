Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A46ED3A8384;
	Sat, 12 Sep 2026 08:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201853; cv=none; b=bm73SWwbjl54dZLbaYYPe7+1DSc0qFq0qOL5DrAD/wzdwzAkX7HemDFZuBR5pTb3mKw0jpLFlmMLuBaEO0ttst0yRc4faXeLXyq9QJyZDQqS9RrQ8ltBxCzuTcAwfymdRsugg5zfECdMcGDfbil7Fmxg8Pc7Vo1ekMp0wc/idMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201853; c=relaxed/simple;
	bh=hrQTW//5x8EIHWlPN+txGWAijoce3kq8aSzn5ede6rc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g8kJfcxvoUTEP99OP/qAjY0kDcgq4w2AOdDk0gcAYCkEFtfzvdoWtSTuxo6qy5+TKFyEzPejuS/dtVoIWKz9PX84v/LDOs9e0xEquOV9nJoGj2RL7SpvO835wVxJfV9vpCzbN6MMekHV4cgufyPD1TWQ5/4dlmREHFH1DBYusAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hkma7+LF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hkma7+LF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E9F51F000FF;
	Sat, 12 Sep 2026 08:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201852;
	bh=a1etmYg9IUM4RDsZ9MOlSpihP3YvgVVhZK0BJGGB228=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hkma7+LFWOMqb93e3S3EPN2TUXnhlUr8vtFgHj/OCfZ1k6xwztIvr/1nqpmrPDJl7
	 m1NNVgnw6FPp4O/M0w3BjtgQE/LhmFN43/kMV5XnNU+5tv34MLquFZTymlZZtYfKRf
	 dElL/iIdIPP48vKfHNe7PjU7LrKwR7MY5y2ZuEHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1081/1815] arm64: dts: qcom: purwa: Fix swapped USB QMP PHY vdda-phy/vdda-pll supplies
Date: Sat, 12 Sep 2026 08:47:11 +0200
Message-ID: <20260912065714.399697830@linuxfoundation.org>
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

[ Upstream commit 7c1d0ef2969e16a97bd03e8340f35a78c889120d ]

The QMP PHY expects the vdda-phy supply to be around 0.88V and the
vdda-pll supply to be 1.2V. But these two supplies are swapped for the
USB QMP PHYs on these boards, feeding 1.2V to vdda-phy and 0.9V to
vdda-pll.

Fix it by swapping the two supplies back.

Fixes: 64a0277c9876 ("arm64: dts: qcom: Add PURWA-IOT-SOM platform")
Fixes: d3f600dc452d ("arm64: dts: qcom: Add Lenovo ThinkBook 16 G7 QOY device tree")
Reported-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Assisted-by: Claude:opus-4-8
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260803-phy-supply-fix-v1-19-5880630cde3e@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/purwa-iot-som.dtsi   | 20 +++++++++----------
 .../dts/qcom/x1p42100-lenovo-thinkbook-16.dts | 20 +++++++++----------
 2 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/purwa-iot-som.dtsi b/arch/arm64/boot/dts/qcom/purwa-iot-som.dtsi
index 394e65518ac50..50ea8a148ada0 100644
--- a/arch/arm64/boot/dts/qcom/purwa-iot-som.dtsi
+++ b/arch/arm64/boot/dts/qcom/purwa-iot-som.dtsi
@@ -583,8 +583,8 @@ &usb_1_ss0_hsphy {
 };
 
 &usb_1_ss0_qmpphy {
-	vdda-phy-supply = <&vreg_l2j_1p2>;
-	vdda-pll-supply = <&vreg_l1j_0p8>;
+	vdda-phy-supply = <&vreg_l1j_0p8>;
+	vdda-pll-supply = <&vreg_l2j_1p2>;
 
 	status = "okay";
 };
@@ -604,8 +604,8 @@ &usb_1_ss1_hsphy {
 };
 
 &usb_1_ss1_qmpphy {
-	vdda-phy-supply = <&vreg_l2j_1p2>;
-	vdda-pll-supply = <&vreg_l2d_0p9>;
+	vdda-phy-supply = <&vreg_l2d_0p9>;
+	vdda-pll-supply = <&vreg_l2j_1p2>;
 
 	status = "okay";
 };
@@ -625,8 +625,8 @@ &usb_1_ss2_hsphy {
 };
 
 &usb_1_ss2_qmpphy {
-	vdda-phy-supply = <&vreg_l2j_1p2>;
-	vdda-pll-supply = <&vreg_l2d_0p9>;
+	vdda-phy-supply = <&vreg_l2d_0p9>;
+	vdda-pll-supply = <&vreg_l2j_1p2>;
 
 	status = "okay";
 };
@@ -663,15 +663,15 @@ &usb_mp_hsphy1 {
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
diff --git a/arch/arm64/boot/dts/qcom/x1p42100-lenovo-thinkbook-16.dts b/arch/arm64/boot/dts/qcom/x1p42100-lenovo-thinkbook-16.dts
index 500809772097e..913645bc3595d 100644
--- a/arch/arm64/boot/dts/qcom/x1p42100-lenovo-thinkbook-16.dts
+++ b/arch/arm64/boot/dts/qcom/x1p42100-lenovo-thinkbook-16.dts
@@ -1561,8 +1561,8 @@ &usb_1_ss0_hsphy {
 };
 
 &usb_1_ss0_qmpphy {
-	vdda-phy-supply = <&vreg_l2j_1p2>;
-	vdda-pll-supply = <&vreg_l1j_0p8>;
+	vdda-phy-supply = <&vreg_l1j_0p8>;
+	vdda-pll-supply = <&vreg_l2j_1p2>;
 
 	status = "okay";
 };
@@ -1591,8 +1591,8 @@ &usb_1_ss1_hsphy {
 };
 
 &usb_1_ss1_qmpphy {
-	vdda-phy-supply = <&vreg_l2j_1p2>;
-	vdda-pll-supply = <&vreg_l2d_0p9>;
+	vdda-phy-supply = <&vreg_l2d_0p9>;
+	vdda-pll-supply = <&vreg_l2j_1p2>;
 
 	status = "okay";
 };
@@ -1631,8 +1631,8 @@ &usb_1_ss2_hsphy {
 };
 
 &usb_1_ss2_qmpphy {
-	vdda-phy-supply = <&vreg_l2j_1p2>;
-	vdda-pll-supply = <&vreg_l2d_0p9>;
+	vdda-phy-supply = <&vreg_l2d_0p9>;
+	vdda-pll-supply = <&vreg_l2j_1p2>;
 
 	/delete-property/ mode-switch;
 	/delete-property/ orientation-switch;
@@ -1685,8 +1685,8 @@ &usb_mp_hsphy0 {
 };
 
 &usb_mp_qmpphy0 {
-	vdda-phy-supply = <&vreg_l3e_1p2>;
-	vdda-pll-supply = <&vreg_l3c_0p8>;
+	vdda-phy-supply = <&vreg_l3c_0p8>;
+	vdda-pll-supply = <&vreg_l3e_1p2>;
 
 	status = "okay";
 };
@@ -1701,8 +1701,8 @@ &usb_mp_hsphy1 {
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




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C88E288B9;
	Sat, 12 Sep 2026 16:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230804; cv=none; b=T4kpOk6Asx/kY7xYTW0MzRd+iCYXSQ3y0EwKKRzwdV5EpSdBGSjX+DXkf1xAw0weocca7s6KUHfkspSv+feOrQYOfu8jzc5kiltE81i9025UF6q5Sv9x7leTZWDJsoghiNR/AT7FOGPn7knPRYeKIzj2VoqVFK7X2MTASTk3+NQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230804; c=relaxed/simple;
	bh=A3CxTZJH6WlGG+oqvNyMdy5JeR63AFmtXQ8R6+3v48M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ffukikQnTTUM17GNMsPhL/foKIu5XVhbI7YvpbCADYxaEcSDCQ81i2bm8G+UnmiYCVet7LObdokpq/pbp6BYQtpfwqGcJyZRGgDfsgbH1onpvy57IIe+f5tnUooi1X0OVi1LroOBdjamj/Jt3F9SIK/aYtEnpaTIvPz2lMnLo6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SBuD/34A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SBuD/34A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9C801F000FF;
	Sat, 12 Sep 2026 16:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230803;
	bh=jJ5JB0AE7aIs0W5ofeO+WydfLgqQUnGzRf92QxiIN9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SBuD/34Asu1tO+dyAdJYTXSdp1mKz1PgaMjzoP+ogHJeIc2nUKekrdk4mOpvSCNe4
	 CbyX2qGNx49ssPxcY+m7PAJeH2me+94Ml8nXjeyCnJnvS68ERYYOoxJc1xUUaulr40
	 W/7b/nZwlg++wEtgf4jzFsvm8SzxZ1hv0gJbkP8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Luca Weiss <luca.weiss@fairphone.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0867/1191] arm64: dts: qcom: sm7225-fairphone-fp4: move status property down
Date: Sat, 12 Sep 2026 08:59:55 +0200
Message-ID: <20260912065607.729342644@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Weiss <luca.weiss@fairphone.com>

[ Upstream commit 65aedb0b48c09595065c81722d9cca53760f7220 ]

Currently the dts contains a mix of status-as-first-property (old qcom
style) and status-as-last-property (new style).

Move all status properties down to the bottom once and for all so that
the style is consistent between different nodes.

Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230213-fp4-more-i2c-v2-1-1c459c572f80@fairphone.com
Stable-dep-of: a3b3a060b696 ("arm64: dts: qcom: sm7225-fairphone-fp4: Fix swapped USB QMP PHY vdda-phy/vdda-pll supplies")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/qcom/sm7225-fairphone-fp4.dts    | 34 +++++++++----------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts b/arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts
index 13b1d484bdeb7..131e6c40a39b9 100644
--- a/arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts
+++ b/arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts
@@ -104,8 +104,8 @@ active-config0 {
 };
 
 &adsp {
-	status = "okay";
 	firmware-name = "qcom/sm7225/fairphone4/adsp.mdt";
+	status = "okay";
 };
 
 &apps_rsc {
@@ -323,13 +323,13 @@ vreg_bob: bob {
 };
 
 &cdsp {
-	status = "okay";
 	firmware-name = "qcom/sm7225/fairphone4/cdsp.mdt";
+	status = "okay";
 };
 
 &i2c10 {
-	status = "okay";
 	clock-frequency = <400000>;
+	status = "okay";
 
 	haptics@5a {
 		compatible = "awinic,aw8695";
@@ -357,16 +357,16 @@ haptics@5a {
 };
 
 &mpss {
-	status = "okay";
 	firmware-name = "qcom/sm7225/fairphone4/modem.mdt";
+	status = "okay";
 };
 
 &pm6150l_wled {
-	status = "okay";
-
 	qcom,switching-freq = <800>;
 	qcom,current-limit-microamp = <20000>;
 	qcom,num-strings = <2>;
+
+	status = "okay";
 };
 
 &pm6350_gpios {
@@ -380,8 +380,8 @@ gpio_keys_pin: gpio-keys-state {
 };
 
 &pm6350_resin {
-	status = "okay";
 	linux,code = <KEY_VOLUMEDOWN>;
+	status = "okay";
 };
 
 &pm7250b_adc {
@@ -433,21 +433,21 @@ &uart9 {
 };
 
 &ufs_mem_hc {
-	status = "okay";
-
 	reset-gpios = <&tlmm 156 GPIO_ACTIVE_LOW>;
 
 	vcc-supply = <&vreg_l7e>;
 	vcc-max-microamp = <800000>;
 	vccq2-supply = <&vreg_l12a>;
 	vccq2-max-microamp = <800000>;
-};
 
-&ufs_mem_phy {
 	status = "okay";
+};
 
+&ufs_mem_phy {
 	vdda-phy-supply = <&vreg_l18a>;
 	vdda-pll-supply = <&vreg_l22a>;
+
+	status = "okay";
 };
 
 &usb_1 {
@@ -460,26 +460,26 @@ &usb_1_dwc3 {
 };
 
 &usb_1_hsphy {
-	status = "okay";
-
 	vdd-supply = <&vreg_l18a>;
 	vdda-pll-supply = <&vreg_l2a>;
 	vdda-phy-dpdm-supply = <&vreg_l3a>;
-};
 
-&usb_1_qmpphy {
 	status = "okay";
+};
 
+&usb_1_qmpphy {
 	vdda-phy-supply = <&vreg_l22a>;
 	vdda-pll-supply = <&vreg_l16a>;
-};
 
-&wifi {
 	status = "okay";
+};
 
+&wifi {
 	vdd-0.8-cx-mx-supply = <&vreg_l4a>;
 	vdd-1.8-xo-supply = <&vreg_l7a>;
 	vdd-1.3-rfa-supply = <&vreg_l2e>;
 	vdd-3.3-ch0-supply = <&vreg_l10e>;
 	vdd-3.3-ch1-supply = <&vreg_l11e>;
+
+	status = "okay";
 };
-- 
2.53.0




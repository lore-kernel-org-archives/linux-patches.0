Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6975C299920;
	Sat, 12 Sep 2026 12:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215027; cv=none; b=kGDLShdGevTc+LHDQiR/ADoRDZNvCzqAsb50TPC7fjfLpbYBD0UFG9vdT/rbjeQtJOat58M4MDmcAVegDi4I1f5BHinFoqGQG2Dr+KJgArBFTNLHTUIXFDOrMkX1mI5Blo6BgtAqfbUD0y7CoZI3VmlA4ivEDFbgTA/QzURuLR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215027; c=relaxed/simple;
	bh=+c2eeyCrm1sZxvU6atbUlIDnEBRkauvkb6LFQK+7IdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I6/AAPOdOyyq4o6o/sOVeiGU7NtcWjPM+k/SpcElzdmfShxcnxcoQhdZTWICWv2zs2GyO2pLT1YQJ8CHfUZD2bTa1WmtTTrx1NrBJTkKajnuyq1QUUokHO50BXISGVp5T8Sk9qdgA9H3hNatkqMSu8y7JR/tC71IMkv0gY02cQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pSf4rNKV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pSf4rNKV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03F151F000FF;
	Sat, 12 Sep 2026 12:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215026;
	bh=A6AX2pIBG63f1FrSQjub6/VgVBgEohSdeS4RAHEK/DM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pSf4rNKV6SwqvZ+RUIP3kfeXH/cy3gL/ogTlOpQ+h0xZ6whGmRQSTBb/tG+t/0GY2
	 zQJDgd8di8DzwjlkWk4PiTRoUlluehgcEKFph4XyD+YNOnCGm/xZAc0hv54fZSDOqn
	 aQRcuFpA8D5zUQIu2QTQ/+5lpgW5n/+SY83gTnjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0447/1376] arm64: dts: qcom: sc8180x-lenovo-flex-5g: Describe the display power net
Date: Sat, 12 Sep 2026 08:47:53 +0200
Message-ID: <20260912065617.495535866@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit d5f5c089858f7accd1e4574c0c09d811e90eb51f ]

Describe and wire up the power supplies for the eDP panel and its
backlight. Previously, this was only working because of settings
inherited from the bootloader.

Fixes: 20dea72a393c ("arm64: dts: qcom: sc8180x: Introduce Lenovo Flex 5G")
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260616-topic-8180_disp_power-v2-4-167785993231@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/qcom/sc8180x-lenovo-flex-5g.dts  | 47 +++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sc8180x-lenovo-flex-5g.dts b/arch/arm64/boot/dts/qcom/sc8180x-lenovo-flex-5g.dts
index 357b1214c1738..debe9fa74724a 100644
--- a/arch/arm64/boot/dts/qcom/sc8180x-lenovo-flex-5g.dts
+++ b/arch/arm64/boot/dts/qcom/sc8180x-lenovo-flex-5g.dts
@@ -26,6 +26,7 @@ backlight: backlight {
 		compatible = "pwm-backlight";
 		pwms = <&pmc8180c_lpg 4 1000000>;
 		enable-gpios = <&pmc8180c_gpios 8 GPIO_ACTIVE_HIGH>;
+		power-supply = <&vled_bl_pw>;
 
 		pinctrl-0 = <&bl_pwm_default>;
 		pinctrl-names = "default";
@@ -162,6 +163,38 @@ cdsp_mem: cdsp-region@98900000 {
 		};
 	};
 
+	vled_bl_pw: regulator-vled-bl-pw {
+		compatible = "regulator-fixed";
+
+		regulator-name = "VLED_BL_PW";
+		regulator-min-microvolt = <3300000>;
+		regulator-max-microvolt = <3300000>;
+
+		gpio = <&pmc8180_2_gpios 1 GPIO_ACTIVE_HIGH>;
+		enable-active-high;
+
+		pinctrl-0 = <&bl_pwr_en>;
+		pinctrl-names = "default";
+
+		regulator-boot-on;
+	};
+
+	vreg_lcm_3v3: regulator-edp-3p3 {
+		compatible = "regulator-fixed";
+
+		regulator-name = "VREG_LCM_3V3";
+		regulator-min-microvolt = <3300000>;
+		regulator-max-microvolt = <3300000>;
+
+		gpio = <&tlmm 130 GPIO_ACTIVE_HIGH>;
+		enable-active-high;
+
+		pinctrl-0 = <&lcm_3v3_en>;
+		pinctrl-names = "default";
+
+		regulator-boot-on;
+	};
+
 	vreg_s4a_1p8: regulator-pm8150-s4 {
 		compatible = "regulator-fixed";
 		regulator-name = "vreg_s4a_1p8";
@@ -446,6 +479,7 @@ &mdss_edp {
 	aux-bus {
 		panel {
 			compatible = "edp-panel";
+			power-supply = <&vreg_lcm_3v3>;
 			no-hpd;
 
 			backlight = <&backlight>;
@@ -484,6 +518,13 @@ &pcie3_phy {
 	status = "okay";
 };
 
+&pmc8180_2_gpios {
+	bl_pwr_en: bl-pwr-en-state {
+		pins = "gpio1";
+		function = "normal";
+	};
+};
+
 &pmc8180_pwrkey {
 	status = "okay";
 };
@@ -781,6 +822,12 @@ ts_int_default: ts-int-default-state {
 		drive-strength = <2>;
 	};
 
+	lcm_3v3_en: lcm-3v3-en-state {
+		pins = "gpio130";
+		function = "gpio";
+		bias-disable;
+	};
+
 	usbprim_sbu_default: usbprim-sbu-state {
 		oe-n-pins {
 			pins = "gpio152";
-- 
2.53.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6649B41D118;
	Mon, 17 Aug 2026 13:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974740; cv=none; b=Gz5dHZ88/SZXCW/WJUTjOC8ENOfeRGN168+s1b+fGlaKL5miyiZEap0+ymnVnUEiLkI7poAe9F2UhOhpF/+KWBTjh4K8E6j+L8xvE6cDU/Wq5IsnaRPxw+t7x0ypy+J9ro8qGU47f558Pdf/cyFuE1MUjKw1Ln21+DpF3CUNUk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974740; c=relaxed/simple;
	bh=MQH5Qhm6kxE2NRbdrSdK8IplP6EAk9DK9/yarzBO+UQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KzmP23eyYoG0fphjjp2C5T9HQ49g5krUWT9izsZKqT2XEu24HOcx97tIo0V88Xc437QIgk4LgmnSLezRSiien5byEUmWgQspSl9aA1T3ZdzE0zdyw1+hvJp7a4srvIp8T+jOsOoikLurKF+zYt+1NMVYssT2p/kvzVJSSdcw6r8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sg9HuaOX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sg9HuaOX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 704791F000E9;
	Mon, 17 Aug 2026 13:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974723;
	bh=58U0zGLa/ueDqHnWugw5FgwadyRHhokpVgmudC6NfA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sg9HuaOXCyZvESYHjS+E0zIBJoSEfiMwfORgnQY9c4a/99mK53DETQmy7+i9SsNhg
	 LY7DgjNT0q+BpxjEs9Gf+2m44SVW17XrO/spsI3gA4eOMwWqdg7vP6o96Vm0pfLn4/
	 QclicuELieV/sBq01sRNSmMTPXd2dJqn227UhkfA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Glathe <jens.glathe@oldschoolsolutions.biz>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Aleksandrs Vinarskis <alex@vinarskis.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 009/250] arm64: dts: qcom: Rework X1-based Asus Zenbook A14s displays
Date: Mon, 17 Aug 2026 15:29:30 +0200
Message-ID: <20260817132536.835143996@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

From: Aleksandrs Vinarskis <alex@vinarskis.com>

[ Upstream commit 462b39931cab3415ffc47863a58372399e600f4f ]

The laptop comes in two variants:

* UX3407RA, higher end, FHD+ OLED or WOXGA+ OLED panels
* UX3407QA, lower end, FHD+ OLED or FHD+ LCD panels

Even though all three panels work with "edp-panel", unfortunately the
brightness adjustmenet of LCD panel is PWM based, requiring a dedicated
device-tree. Convert "x1p42100-asus-zenbook-a14.dts" into ".dtsi" to
allow for this split, introduce new LCD variant. Leave current variant
without postfix and with the unchanged model name, as some distros
(eg. Ubuntu) rely on this for automatic device-tree detection during
kernel installation/upgrade.

As dedicated device-tree is required, update compatibles of OLED
variants to correct ones. Keep "edp-panel" as fallback, since it is
enough to make the panels work.

While at it moving .dts, .dtsi around, drop 'model' from the top level
x1-asus-zenbook-a14.dtsi as well.

Co-developed-by: Jens Glathe <jens.glathe@oldschoolsolutions.biz>
Signed-off-by: Jens Glathe <jens.glathe@oldschoolsolutions.biz>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Aleksandrs Vinarskis <alex@vinarskis.com>
Link: https://lore.kernel.org/r/20250927-zenbook-improvements-v3-2-d46c7368dc70@vinarskis.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: 4cd774c1feb3 ("arm64: dts: qcom: purwa: Fix GPU IOMMU property")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/Makefile             |   2 +
 .../boot/dts/qcom/x1-asus-zenbook-a14.dtsi    |   7 +-
 .../dts/qcom/x1e80100-asus-zenbook-a14.dts    |   8 +
 .../qcom/x1p42100-asus-zenbook-a14-lcd.dts    |  62 ++++++++
 .../dts/qcom/x1p42100-asus-zenbook-a14.dts    | 133 +----------------
 .../dts/qcom/x1p42100-asus-zenbook-a14.dtsi   | 138 ++++++++++++++++++
 6 files changed, 218 insertions(+), 132 deletions(-)
 create mode 100644 arch/arm64/boot/dts/qcom/x1p42100-asus-zenbook-a14-lcd.dts
 create mode 100644 arch/arm64/boot/dts/qcom/x1p42100-asus-zenbook-a14.dtsi

diff --git a/arch/arm64/boot/dts/qcom/Makefile b/arch/arm64/boot/dts/qcom/Makefile
index 296688f7cb265..dffdb219f33dc 100644
--- a/arch/arm64/boot/dts/qcom/Makefile
+++ b/arch/arm64/boot/dts/qcom/Makefile
@@ -344,6 +344,8 @@ x1e80100-qcp-el2-dtbs	:= x1e80100-qcp.dtb x1-el2.dtbo
 dtb-$(CONFIG_ARCH_QCOM)	+= x1e80100-qcp.dtb x1e80100-qcp-el2.dtb
 x1p42100-asus-zenbook-a14-el2-dtbs	:= x1p42100-asus-zenbook-a14.dtb x1-el2.dtbo
 dtb-$(CONFIG_ARCH_QCOM)	+= x1p42100-asus-zenbook-a14.dtb x1p42100-asus-zenbook-a14-el2.dtb
+x1p42100-asus-zenbook-a14-lcd-el2-dtbs	:= x1p42100-asus-zenbook-a14-lcd.dtb x1-el2.dtbo
+dtb-$(CONFIG_ARCH_QCOM)	+= x1p42100-asus-zenbook-a14-lcd.dtb x1p42100-asus-zenbook-a14-lcd-el2.dtb
 x1p42100-crd-el2-dtbs	:= x1p42100-crd.dtb x1-el2.dtbo
 dtb-$(CONFIG_ARCH_QCOM)	+= x1p42100-crd.dtb x1p42100-crd-el2.dtb
 x1p42100-hp-omnibook-x14-el2-dtbs := x1p42100-hp-omnibook-x14.dtb x1-el2.dtbo
diff --git a/arch/arm64/boot/dts/qcom/x1-asus-zenbook-a14.dtsi b/arch/arm64/boot/dts/qcom/x1-asus-zenbook-a14.dtsi
index 69eccad1a09c2..8e5c5575a5320 100644
--- a/arch/arm64/boot/dts/qcom/x1-asus-zenbook-a14.dtsi
+++ b/arch/arm64/boot/dts/qcom/x1-asus-zenbook-a14.dtsi
@@ -14,7 +14,6 @@
 #include "hamoa-pmics.dtsi"
 
 / {
-	model = "ASUS Zenbook A14";
 	chassis-type = "laptop";
 
 	aliases {
@@ -1005,14 +1004,10 @@ &mdss_dp3 {
 	status = "okay";
 
 	aux-bus {
-		panel {
+		panel: panel {
 			compatible = "edp-panel";
-			enable-gpios = <&pmc8380_3_gpios 4 GPIO_ACTIVE_HIGH>;
 			power-supply = <&vreg_edp_3p3>;
 
-			pinctrl-0 = <&edp_bl_en>;
-			pinctrl-names = "default";
-
 			port {
 				edp_panel_in: endpoint {
 					remote-endpoint = <&mdss_dp3_out>;
diff --git a/arch/arm64/boot/dts/qcom/x1e80100-asus-zenbook-a14.dts b/arch/arm64/boot/dts/qcom/x1e80100-asus-zenbook-a14.dts
index c3cd04c9703d3..49b12a0a7cb1e 100644
--- a/arch/arm64/boot/dts/qcom/x1e80100-asus-zenbook-a14.dts
+++ b/arch/arm64/boot/dts/qcom/x1e80100-asus-zenbook-a14.dts
@@ -22,6 +22,14 @@ &gpu_zap_shader {
 	firmware-name = "qcom/x1e80100/ASUSTeK/zenbook-a14/qcdxkmsuc8380.mbn";
 };
 
+&panel {
+	compatible = "samsung,atna40cu11", "samsung,atna33xc20";
+	enable-gpios = <&pmc8380_3_gpios 4 GPIO_ACTIVE_HIGH>;
+
+	pinctrl-0 = <&edp_bl_en>;
+	pinctrl-names = "default";
+};
+
 &remoteproc_adsp {
 	firmware-name = "qcom/x1e80100/ASUSTeK/zenbook-a14/qcadsp8380.mbn",
 			"qcom/x1e80100/ASUSTeK/zenbook-a14/adsp_dtbs.elf";
diff --git a/arch/arm64/boot/dts/qcom/x1p42100-asus-zenbook-a14-lcd.dts b/arch/arm64/boot/dts/qcom/x1p42100-asus-zenbook-a14-lcd.dts
new file mode 100644
index 0000000000000..be756069131d7
--- /dev/null
+++ b/arch/arm64/boot/dts/qcom/x1p42100-asus-zenbook-a14-lcd.dts
@@ -0,0 +1,62 @@
+// SPDX-License-Identifier: BSD-3-Clause
+/*
+ * Copyright (c) 2025 Qualcomm Innovation Center, Inc. All rights reserved.
+ * Copyright (c) 2025 Aleksandrs Vinarskis <alex@vinarskis.com>
+ */
+
+/dts-v1/;
+
+#include "x1p42100-asus-zenbook-a14.dtsi"
+
+/ {
+	model = "ASUS Zenbook A14 (UX3407QA, LCD)";
+	compatible = "asus,zenbook-a14-ux3407qa-lcd", "asus,zenbook-a14-ux3407qa", "qcom,x1p42100";
+
+	backlight: backlight {
+		compatible = "pwm-backlight";
+		pwms = <&pmk8550_pwm 0 416667>;
+		enable-gpios = <&pmc8380_3_gpios 4 GPIO_ACTIVE_HIGH>;
+		power-supply = <&vreg_edp_bl>;
+
+		pinctrl-0 = <&edp_bl_en>, <&edp_bl_pwm>;
+		pinctrl-names = "default";
+	};
+
+	vreg_edp_bl: regulator-edp-bl {
+		compatible = "regulator-fixed";
+
+		regulator-name = "VBL9";
+		regulator-min-microvolt = <3600000>;
+		regulator-max-microvolt = <3600000>;
+
+		gpio = <&pmc8380_3_gpios 10 GPIO_ACTIVE_HIGH>;
+		enable-active-high;
+
+		pinctrl-0 = <&edp_bl_reg_en>;
+		pinctrl-names = "default";
+
+		regulator-boot-on;
+	};
+};
+
+&panel {
+	backlight = <&backlight>;
+};
+
+&pmc8380_3_gpios {
+	edp_bl_reg_en: edp-bl-reg-en-state {
+		pins = "gpio10";
+		function = "normal";
+	};
+};
+
+&pmk8550_gpios {
+	edp_bl_pwm: edp-bl-pwm-state {
+		pins = "gpio5";
+		function = "func3";
+	};
+};
+
+&pmk8550_pwm {
+	status = "okay";
+};
diff --git a/arch/arm64/boot/dts/qcom/x1p42100-asus-zenbook-a14.dts b/arch/arm64/boot/dts/qcom/x1p42100-asus-zenbook-a14.dts
index bd75ff898601a..68cd318d69073 100644
--- a/arch/arm64/boot/dts/qcom/x1p42100-asus-zenbook-a14.dts
+++ b/arch/arm64/boot/dts/qcom/x1p42100-asus-zenbook-a14.dts
@@ -6,136 +6,17 @@
 
 /dts-v1/;
 
-#include "x1p42100.dtsi"
-#include "x1-asus-zenbook-a14.dtsi"
-
-/delete-node/ &pmc8380_6;
-/delete-node/ &pmc8380_6_thermal;
+#include "x1p42100-asus-zenbook-a14.dtsi"
 
 / {
 	model = "ASUS Zenbook A14 (UX3407QA)";
-	compatible = "asus,zenbook-a14-ux3407qa", "qcom,x1p42100";
-
-	wcn6855-pmu {
-		compatible = "qcom,wcn6855-pmu";
-
-		vddaon-supply = <&vreg_wcn_0p95>;
-		vddio-supply = <&vreg_wcn_1p9>;
-		vddpcie1p3-supply = <&vreg_wcn_1p9>;
-		vddpcie1p9-supply = <&vreg_wcn_1p9>;
-		vddpmu-supply = <&vreg_wcn_0p95>;
-		vddpmucx-supply = <&vreg_wcn_0p95>;
-		vddpmumx-supply = <&vreg_wcn_0p95>;
-		vddrfa0p95-supply = <&vreg_wcn_0p95>;
-		vddrfa1p3-supply = <&vreg_wcn_1p9>;
-		vddrfa1p9-supply = <&vreg_wcn_1p9>;
-
-		bt-enable-gpios = <&tlmm 116 GPIO_ACTIVE_HIGH>;
-		wlan-enable-gpios = <&tlmm 117 GPIO_ACTIVE_HIGH>;
-
-		pinctrl-0 = <&wcn_bt_en>, <&wcn_wlan_en>;
-		pinctrl-names = "default";
-
-		regulators {
-			vreg_pmu_rfa_cmn_0p8: ldo0 {
-				regulator-name = "vreg_pmu_rfa_cmn_0p8";
-			};
-
-			vreg_pmu_aon_0p8: ldo1 {
-				regulator-name = "vreg_pmu_aon_0p8";
-			};
-
-			vreg_pmu_wlcx_0p8: ldo2 {
-				regulator-name = "vreg_pmu_wlcx_0p8";
-			};
-
-			vreg_pmu_wlmx_0p8: ldo3 {
-				regulator-name = "vreg_pmu_wlmx_0p8";
-			};
-
-			vreg_pmu_btcmx_0p8: ldo4 {
-				regulator-name = "vreg_pmu_btcmx_0p8";
-			};
-
-			vreg_pmu_pcie_1p8: ldo5 {
-				regulator-name = "vreg_pmu_pcie_1p8";
-			};
-
-			vreg_pmu_pcie_0p9: ldo6 {
-				regulator-name = "vreg_pmu_pcie_0p9";
-			};
-
-			vreg_pmu_rfa_0p8: ldo7 {
-				regulator-name = "vreg_pmu_rfa_0p8";
-			};
-
-			vreg_pmu_rfa_1p2: ldo8 {
-				regulator-name = "vreg_pmu_rfa_1p2";
-			};
-
-			vreg_pmu_rfa_1p7: ldo9 {
-				regulator-name = "vreg_pmu_rfa_1p7";
-			};
-		};
-	};
+	compatible = "asus,zenbook-a14-ux3407qa-oled", "asus,zenbook-a14-ux3407qa", "qcom,x1p42100";
 };
 
-&gpu {
-	status = "okay";
-};
-
-&gpu_zap_shader {
-	firmware-name = "qcom/x1p42100/ASUSTeK/zenbook-a14/qcdxkmsucpurwa.mbn";
-};
-
-&pcie4_port0 {
-	wifi@0 {
-		compatible = "pci17cb,1103";
-		reg = <0x10000 0x0 0x0 0x0 0x0>;
-
-		vddaon-supply = <&vreg_pmu_aon_0p8>;
-		vddpcie0p9-supply = <&vreg_pmu_pcie_0p9>;
-		vddpcie1p8-supply = <&vreg_pmu_pcie_1p8>;
-		vddrfa0p8-supply = <&vreg_pmu_rfa_0p8>;
-		vddrfa1p2-supply = <&vreg_pmu_rfa_1p2>;
-		vddrfa1p8-supply = <&vreg_pmu_rfa_1p7>;
-		vddrfacmn-supply = <&vreg_pmu_rfa_cmn_0p8>;
-		vddwlcx-supply = <&vreg_pmu_wlcx_0p8>;
-		vddwlmx-supply = <&vreg_pmu_wlmx_0p8>;
-
-		qcom,calibration-variant = "UX3407Q";
-	};
-};
-
-&remoteproc_adsp {
-	firmware-name = "qcom/x1p42100/ASUSTeK/zenbook-a14/qcadsp8380.mbn",
-			"qcom/x1p42100/ASUSTeK/zenbook-a14/adsp_dtbs.elf";
-
-	status = "okay";
-};
-
-&remoteproc_cdsp {
-	firmware-name = "qcom/x1p42100/ASUSTeK/zenbook-a14/qccdsp8380.mbn",
-			"qcom/x1p42100/ASUSTeK/zenbook-a14/cdsp_dtbs.elf";
-
-	status = "okay";
-};
-
-&uart14 {
-	status = "okay";
-
-	bluetooth {
-		compatible = "qcom,wcn6855-bt";
-
-		vddaon-supply = <&vreg_pmu_aon_0p8>;
-		vddbtcmx-supply = <&vreg_pmu_btcmx_0p8>;
-		vddrfa0p8-supply = <&vreg_pmu_rfa_0p8>;
-		vddrfa1p2-supply = <&vreg_pmu_rfa_1p2>;
-		vddrfa1p8-supply = <&vreg_pmu_rfa_1p7>;
-		vddrfacmn-supply = <&vreg_pmu_rfa_cmn_0p8>;
-		vddwlcx-supply = <&vreg_pmu_wlcx_0p8>;
-		vddwlmx-supply = <&vreg_pmu_wlmx_0p8>;
+&panel {
+	compatible = "samsung,atna40ct06", "samsung,atna33xc20";
+	enable-gpios = <&pmc8380_3_gpios 4 GPIO_ACTIVE_HIGH>;
 
-		max-speed = <3000000>;
-	};
+	pinctrl-0 = <&edp_bl_en>;
+	pinctrl-names = "default";
 };
diff --git a/arch/arm64/boot/dts/qcom/x1p42100-asus-zenbook-a14.dtsi b/arch/arm64/boot/dts/qcom/x1p42100-asus-zenbook-a14.dtsi
new file mode 100644
index 0000000000000..7ccb2076bab66
--- /dev/null
+++ b/arch/arm64/boot/dts/qcom/x1p42100-asus-zenbook-a14.dtsi
@@ -0,0 +1,138 @@
+// SPDX-License-Identifier: BSD-3-Clause
+/*
+ * Copyright (c) 2025 Qualcomm Innovation Center, Inc. All rights reserved.
+ * Copyright (c) 2025 Aleksandrs Vinarskis <alex@vinarskis.com>
+ */
+
+/dts-v1/;
+
+#include "x1p42100.dtsi"
+#include "x1-asus-zenbook-a14.dtsi"
+
+/delete-node/ &pmc8380_6;
+/delete-node/ &pmc8380_6_thermal;
+
+/ {
+	wcn6855-pmu {
+		compatible = "qcom,wcn6855-pmu";
+
+		vddaon-supply = <&vreg_wcn_0p95>;
+		vddio-supply = <&vreg_wcn_1p9>;
+		vddpcie1p3-supply = <&vreg_wcn_1p9>;
+		vddpcie1p9-supply = <&vreg_wcn_1p9>;
+		vddpmu-supply = <&vreg_wcn_0p95>;
+		vddpmucx-supply = <&vreg_wcn_0p95>;
+		vddpmumx-supply = <&vreg_wcn_0p95>;
+		vddrfa0p95-supply = <&vreg_wcn_0p95>;
+		vddrfa1p3-supply = <&vreg_wcn_1p9>;
+		vddrfa1p9-supply = <&vreg_wcn_1p9>;
+
+		bt-enable-gpios = <&tlmm 116 GPIO_ACTIVE_HIGH>;
+		wlan-enable-gpios = <&tlmm 117 GPIO_ACTIVE_HIGH>;
+
+		pinctrl-0 = <&wcn_bt_en>, <&wcn_wlan_en>;
+		pinctrl-names = "default";
+
+		regulators {
+			vreg_pmu_rfa_cmn_0p8: ldo0 {
+				regulator-name = "vreg_pmu_rfa_cmn_0p8";
+			};
+
+			vreg_pmu_aon_0p8: ldo1 {
+				regulator-name = "vreg_pmu_aon_0p8";
+			};
+
+			vreg_pmu_wlcx_0p8: ldo2 {
+				regulator-name = "vreg_pmu_wlcx_0p8";
+			};
+
+			vreg_pmu_wlmx_0p8: ldo3 {
+				regulator-name = "vreg_pmu_wlmx_0p8";
+			};
+
+			vreg_pmu_btcmx_0p8: ldo4 {
+				regulator-name = "vreg_pmu_btcmx_0p8";
+			};
+
+			vreg_pmu_pcie_1p8: ldo5 {
+				regulator-name = "vreg_pmu_pcie_1p8";
+			};
+
+			vreg_pmu_pcie_0p9: ldo6 {
+				regulator-name = "vreg_pmu_pcie_0p9";
+			};
+
+			vreg_pmu_rfa_0p8: ldo7 {
+				regulator-name = "vreg_pmu_rfa_0p8";
+			};
+
+			vreg_pmu_rfa_1p2: ldo8 {
+				regulator-name = "vreg_pmu_rfa_1p2";
+			};
+
+			vreg_pmu_rfa_1p7: ldo9 {
+				regulator-name = "vreg_pmu_rfa_1p7";
+			};
+		};
+	};
+};
+
+&gpu {
+	status = "okay";
+};
+
+&gpu_zap_shader {
+	firmware-name = "qcom/x1p42100/ASUSTeK/zenbook-a14/qcdxkmsucpurwa.mbn";
+};
+
+&pcie4_port0 {
+	wifi@0 {
+		compatible = "pci17cb,1103";
+		reg = <0x10000 0x0 0x0 0x0 0x0>;
+
+		vddaon-supply = <&vreg_pmu_aon_0p8>;
+		vddpcie0p9-supply = <&vreg_pmu_pcie_0p9>;
+		vddpcie1p8-supply = <&vreg_pmu_pcie_1p8>;
+		vddrfa0p8-supply = <&vreg_pmu_rfa_0p8>;
+		vddrfa1p2-supply = <&vreg_pmu_rfa_1p2>;
+		vddrfa1p8-supply = <&vreg_pmu_rfa_1p7>;
+		vddrfacmn-supply = <&vreg_pmu_rfa_cmn_0p8>;
+		vddwlcx-supply = <&vreg_pmu_wlcx_0p8>;
+		vddwlmx-supply = <&vreg_pmu_wlmx_0p8>;
+
+		qcom,calibration-variant = "UX3407Q";
+	};
+};
+
+&remoteproc_adsp {
+	firmware-name = "qcom/x1p42100/ASUSTeK/zenbook-a14/qcadsp8380.mbn",
+			"qcom/x1p42100/ASUSTeK/zenbook-a14/adsp_dtbs.elf";
+
+	status = "okay";
+};
+
+&remoteproc_cdsp {
+	firmware-name = "qcom/x1p42100/ASUSTeK/zenbook-a14/qccdsp8380.mbn",
+			"qcom/x1p42100/ASUSTeK/zenbook-a14/cdsp_dtbs.elf";
+
+	status = "okay";
+};
+
+&uart14 {
+	status = "okay";
+
+	bluetooth {
+		compatible = "qcom,wcn6855-bt";
+
+		vddaon-supply = <&vreg_pmu_aon_0p8>;
+		vddbtcmx-supply = <&vreg_pmu_btcmx_0p8>;
+		vddrfa0p8-supply = <&vreg_pmu_rfa_0p8>;
+		vddrfa1p2-supply = <&vreg_pmu_rfa_1p2>;
+		vddrfa1p8-supply = <&vreg_pmu_rfa_1p7>;
+		vddrfacmn-supply = <&vreg_pmu_rfa_cmn_0p8>;
+		vddwlcx-supply = <&vreg_pmu_wlcx_0p8>;
+		vddwlmx-supply = <&vreg_pmu_wlmx_0p8>;
+
+		max-speed = <3000000>;
+	};
+};
-- 
2.53.0




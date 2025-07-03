Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E61EC2EF299;
	Thu,  3 Jul 2025 15:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555335; cv=none; b=l6+oTAbrbN9nShzOgb/TapDDQnX6L0nxgCuuBw3OyC0r6tRchGRZMXseI8LG7Mh7k36/eISvDuwCwOYkdRP/H1qDl+cyZcZeU0kyhUZoMDnJwfEQYo1h6+gq8+Rvb3JReRp9CNdCH0Lk4ANYApoDmTiWtaDvTh0SHqcWnXhvOIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555335; c=relaxed/simple;
	bh=TLLjnFaWosKEU430HZ3ID1o3OUYVpu0C9d+m3Mzymgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WQn1Ki0f8106aC5bfx+oNiW3Vnq1exEnm1Nu7/ppVcEe9WVwHCEDIuDsT4/8xXbXyk/LpMgP9KakWkFh10/DsuvTF5Ytr25ZVWku1sQD6dfHOAdiU90o8VXekm7Y6IFM16tMWmscHFNXJPhmkWfeqBvnyKDz4I+HKDvUkQ4QzWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fCdSSjNt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fCdSSjNt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22DB7C4CEE3;
	Thu,  3 Jul 2025 15:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555334;
	bh=TLLjnFaWosKEU430HZ3ID1o3OUYVpu0C9d+m3Mzymgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fCdSSjNtR+IYN14ebBnwfDwAt39ZOXAEU5FqzvjOnBFgo8ZgP9EHsaybhZaQpjxkz
	 ESqI86veQK4x8D9Tt37VH+zd/pWa5wDQr8vuzgWdZAY8mpLwx9+IEdtlNeync/UXUO
	 iYCIso2g5xWFG24AAVDg0eJWj6NwFkQ+CkG+Te9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 246/263] arm64: dts: qcom: x1e78100-t14s: fix missing HID supplies
Date: Thu,  3 Jul 2025 16:42:46 +0200
Message-ID: <20250703144014.277905066@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

[ Upstream commit 55e52d055393f11ba0193975d3db87af36f4b273 ]

Add the missing HID supplies to avoid relying on other consumers to keep
them on.

This also avoids the following warnings on boot:

	i2c_hid_of 0-0010: supply vdd not found, using dummy regulator
	i2c_hid_of 0-0010: supply vddl not found, using dummy regulator
	i2c_hid_of 1-0015: supply vdd not found, using dummy regulator
	i2c_hid_of 1-002c: supply vdd not found, using dummy regulator
	i2c_hid_of 1-0015: supply vddl not found, using dummy regulator
	i2c_hid_of 1-002c: supply vddl not found, using dummy regulator
	i2c_hid_of 1-003a: supply vdd not found, using dummy regulator
	i2c_hid_of 1-003a: supply vddl not found, using dummy regulator

Note that VCC3B is also used for things like the modem which are not yet
described so mark the regulator as always-on for now.

Fixes: 7d1cbe2f4985 ("arm64: dts: qcom: Add X1E78100 ThinkPad T14s Gen 6")
Cc: stable@vger.kernel.org	# 6.12
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20250314145440.11371-9-johan+linaro@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../qcom/x1e78100-lenovo-thinkpad-t14s.dts    | 43 +++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/x1e78100-lenovo-thinkpad-t14s.dts b/arch/arm64/boot/dts/qcom/x1e78100-lenovo-thinkpad-t14s.dts
index 7f756ce48d2f6..999d966b44869 100644
--- a/arch/arm64/boot/dts/qcom/x1e78100-lenovo-thinkpad-t14s.dts
+++ b/arch/arm64/boot/dts/qcom/x1e78100-lenovo-thinkpad-t14s.dts
@@ -9,6 +9,7 @@
 #include <dt-bindings/gpio/gpio.h>
 #include <dt-bindings/input/gpio-keys.h>
 #include <dt-bindings/input/input.h>
+#include <dt-bindings/pinctrl/qcom,pmic-gpio.h>
 #include <dt-bindings/regulator/qcom,rpmh-regulator.h>
 
 #include "x1e80100.dtsi"
@@ -153,6 +154,23 @@ vreg_edp_3p3: regulator-edp-3p3 {
 		regulator-boot-on;
 	};
 
+	vreg_misc_3p3: regulator-misc-3p3 {
+		compatible = "regulator-fixed";
+
+		regulator-name = "VCC3B";
+		regulator-min-microvolt = <3300000>;
+		regulator-max-microvolt = <3300000>;
+
+		gpio = <&pm8550ve_8_gpios 6 GPIO_ACTIVE_HIGH>;
+		enable-active-high;
+
+		pinctrl-0 = <&misc_3p3_reg_en>;
+		pinctrl-names = "default";
+
+		regulator-boot-on;
+		regulator-always-on;
+	};
+
 	vreg_nvme: regulator-nvme {
 		compatible = "regulator-fixed";
 
@@ -580,6 +598,9 @@ touchpad@15 {
 		hid-descr-addr = <0x1>;
 		interrupts-extended = <&tlmm 3 IRQ_TYPE_LEVEL_LOW>;
 
+		vdd-supply = <&vreg_misc_3p3>;
+		vddl-supply = <&vreg_l12b_1p2>;
+
 		wakeup-source;
 	};
 
@@ -591,6 +612,9 @@ touchpad@2c {
 		hid-descr-addr = <0x20>;
 		interrupts-extended = <&tlmm 3 IRQ_TYPE_LEVEL_LOW>;
 
+		vdd-supply = <&vreg_misc_3p3>;
+		vddl-supply = <&vreg_l12b_1p2>;
+
 		wakeup-source;
 	};
 
@@ -602,6 +626,9 @@ keyboard@3a {
 		hid-descr-addr = <0x1>;
 		interrupts-extended = <&tlmm 67 IRQ_TYPE_LEVEL_LOW>;
 
+		vdd-supply = <&vreg_misc_3p3>;
+		vddl-supply = <&vreg_l15b_1p8>;
+
 		pinctrl-0 = <&kybd_default>;
 		pinctrl-names = "default";
 
@@ -670,6 +697,9 @@ touchscreen@10 {
 		hid-descr-addr = <0x1>;
 		interrupts-extended = <&tlmm 51 IRQ_TYPE_LEVEL_LOW>;
 
+		vdd-supply = <&vreg_misc_3p3>;
+		vddl-supply = <&vreg_l15b_1p8>;
+
 		pinctrl-0 = <&ts0_default>;
 		pinctrl-names = "default";
 	};
@@ -789,6 +819,19 @@ edp_bl_en: edp-bl-en-state {
 	};
 };
 
+&pm8550ve_8_gpios {
+	misc_3p3_reg_en: misc-3p3-reg-en-state {
+		pins = "gpio6";
+		function = "normal";
+		bias-disable;
+		drive-push-pull;
+		input-disable;
+		output-enable;
+		power-source = <1>; /* 1.8 V */
+		qcom,drive-strength = <PMIC_GPIO_STRENGTH_LOW>;
+	};
+};
+
 &qupv3_0 {
 	status = "okay";
 };
-- 
2.39.5




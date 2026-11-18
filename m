Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024637;
	b=U0kd2dQ4AQ5HMt0Fx6/wyA1pPG6WpGbv7vNJzcNkB7onz2PHH37AHhWTq5k+mqTs2RiM
	 75NXHfxNEjm/eBj9BoAUNi44lq+klUs1bCJWVDxV2OPP9rDEXTDsLuupVgy7VlLzOTCTd
	 QZ4Y8nihmSjqQD2u7GYuy1gr2SlAVeGJrocPDTopmg2Z4F0Na6+MA0RIqS2IrBpbfm5r1
	 RGA39OXWFfZXnwGLVYYV5MvDrlPdDD52dWTCOoEXhBtzERU7NWTQw3vGhK4/TCdNQPMew
	 iIK+Kb8StGlJpiPiOqw14V/Oz/Zhatg9150TS1SVKSO+8UoMvj7D3ze4B1JVmx8hbZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024637;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TMU2hjD4t1cYOV2EOpnTWO38tfC0nhUVFL2SB2cHXic=;
	b=XLhuY/OykTFrg3DXI5+QWH2Zb07lYAVtxVu0n5kev+fRJFPSgcC09Kwm9dTAkmLZMZF3
	 XkISPlDKQ4ozoMD/7cZKi4ENr4KtLYpJWV/HQ51a83X4aB17Ws4nKhQhUlILhomKGoLZ6
	 Ohj2gZM/xGxVmvRe7ryDc6uhcEDbbSuvWy94Z3WaMXNbRk3iOsJqe5SEwrsPHcAcV/aMf
	 LDHZnNG8Q+8E0kTFdYpjzyxoBeyPeCStQny88X/iiBfw4svESxTvxqaXBS/1Nm1jPzavt
	 cITtzCFMKYzA/XPRM9Umr2EA6KtLitZegFDoewIfpUY2TpuWmzQG/heHEDQKYncJx+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OIAQvOWw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7291E606A320;
	Wed, 18 Nov 2026 17:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OIAQvOWw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC54B1F000C4;
	Wed, 18 Nov 2026 17:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024637;
	bh=TMU2hjD4t1cYOV2EOpnTWO38tfC0nhUVFL2SB2cHXic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OIAQvOWwjxllNO0fmy9SC2g7eVXenw8uYETEzoV4mvEEb099FCavFqfaGxxEAcxDT
	 uUrhIQ01rN7dMiRXTkwvF6jeQARJwmvURy2xDPuExtoOQD72dNeD/YAznupYARDZsL
	 myqQX29NgPE0U+2KmwwtliSn07QGIPFVkSU037Io=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@linaro.org>,
	Yongxing Mou <yongxing.mou@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0779/2151] arm64: dts: qcom: hamoa-iot-evk: Add backlight support for eDP panel
Date: Wed, 18 Nov 2026 15:41:54 +0100
Message-ID: <20261118150150.496819679@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yongxing Mou <yongxing.mou@oss.qualcomm.com>

[ Upstream commit 512716f69610d81db958b781132370731c69e874 ]

The backlight on the Hamoa IoT EVK is controlled through a PWM signal.
Aligned with other x1e80100-based platforms: the PWM signal is controlled
by PMK8550, and the backlight enable signal is handled by PMC8380.

Describe the backlight device and connect it to the eDP panel to allow
for brightness control.

Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Yongxing Mou <yongxing.mou@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251112-hamoa_dvt_backlight-v3-1-f35b44af7fc4@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: 723ce02feb13 ("arm64: dts: qcom: hamoa-iot-evk: use on-board crystal for PS8830 retimers")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/hamoa-iot-evk.dts | 54 ++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/hamoa-iot-evk.dts b/arch/arm64/boot/dts/qcom/hamoa-iot-evk.dts
index df8d6e5c1f45e..1cb4a51f5d508 100644
--- a/arch/arm64/boot/dts/qcom/hamoa-iot-evk.dts
+++ b/arch/arm64/boot/dts/qcom/hamoa-iot-evk.dts
@@ -17,6 +17,16 @@ aliases {
 		serial1 = &uart14;
 	};
 
+	backlight: backlight {
+		compatible = "pwm-backlight";
+		pwms = <&pmk8550_pwm 0 5000000>;
+		enable-gpios = <&pmc8380_3_gpios 4 GPIO_ACTIVE_HIGH>;
+		power-supply = <&vreg_edp_bl>;
+
+		pinctrl-0 = <&edp_bl_en>, <&edp_bl_pwm>;
+		pinctrl-names = "default";
+	};
+
 	wcd938x: audio-codec {
 		compatible = "qcom,wcd9385-codec";
 
@@ -183,6 +193,22 @@ vreg_edp_3p3: regulator-edp-3p3 {
 		regulator-boot-on;
 	};
 
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
+
 	vreg_nvme: regulator-nvme {
 		compatible = "regulator-fixed";
 
@@ -807,6 +833,8 @@ &mdss_dp3 {
 	aux-bus {
 		panel {
 			compatible = "edp-panel";
+
+			backlight = <&backlight>;
 			power-supply = <&vreg_edp_3p3>;
 
 			port {
@@ -867,6 +895,21 @@ usb0_1p8_reg_en: usb0-1p8-reg-en-state {
 	};
 };
 
+&pmc8380_3_gpios {
+	edp_bl_en: edp-bl-en-state {
+		pins = "gpio4";
+		function = "normal";
+		power-source = <1>;
+		input-disable;
+		output-enable;
+	};
+
+	edp_bl_reg_en: edp-bl-reg-en-state {
+		pins = "gpio10";
+		function = "normal";
+	};
+};
+
 &pmc8380_5_gpios {
 	usb0_pwr_1p15_reg_en: usb0-pwr-1p15-reg-en-state {
 		pins = "gpio8";
@@ -878,6 +921,17 @@ usb0_pwr_1p15_reg_en: usb0-pwr-1p15-reg-en-state {
 	};
 };
 
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
+
 &smb2360_0 {
 	status = "okay";
 };
-- 
2.53.0




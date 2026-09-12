Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C476A1EB5FD;
	Sat, 12 Sep 2026 07:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197862; cv=none; b=szVlCZ6QMq0qWqfyEsBhLrK4FlK8sjsoMqTmUEIkzaxostlz1dAVxg+Lt47ANJNwrejV8jqA+VKaEWw6D+Bx7sPsaPPd3zZ5X7xCE4cXVWGA7/Xyy5a/wdVXO3kWd+ZAB6w7w/zfpcdf2WpSSCfgz+BUZO0iKW8vDmmkcZCVgMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197862; c=relaxed/simple;
	bh=2VjWaA+gx1H9B7E0dHz/etgn0OaQG4C+fP7G5L8melI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e+j+HNlDGUPWqpa8ann88dqZzI7uGLohtniJSTwRESSej4vzejOB517JODVk9cPx2wXldb0I1nF333U9cd88kyMOnUl5RcJ3Gmn3cPGR/iVFlN1IYsRxJ9OEdKOMbzjroLygudBBxDB4ZcdzuyASRbp2wdDgmdmKqR3An3JdUco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1+TQ7gSE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1+TQ7gSE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 163BF1F000FF;
	Sat, 12 Sep 2026 07:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197860;
	bh=FPi0Y/HIo4zqSjVB7EIQPSTNyOP0XV3sjRMNREKWK5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1+TQ7gSE8WKX9ELXbGDTs7dd5kcb9RYgXkkz5zP7P/FfMVQEqXm5QfDUDRyuYVr0g
	 gQs4LylCIvwjwAiIUKaqZYv1NMTVT+1dNkx28kkvZTXIveFfuTAyGy2wGOzQ8zntJV
	 IZdgMK9ULwMmhaj6Po2GSxX5kIedJartkzc7Zgk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0261/1815] arm64: dts: qcom: sc8180x-primus: Describe the display power net
Date: Sat, 12 Sep 2026 08:33:31 +0200
Message-ID: <20260912065655.103731355@linuxfoundation.org>
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

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit 80bf2eb87bfbf1b7bc7b12228cbcc710b0a26275 ]

Describe and wire up the power supplies for the eDP panel and its
backlight. Previously, this was only working because of settings
inherited from the bootloader.

Fixes: 2ce38cc1e8fe ("arm64: dts: qcom: sc8180x: Introduce Primus")
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260616-topic-8180_disp_power-v2-2-167785993231@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc8180x-primus.dts | 48 ++++++++++++++++++++-
 1 file changed, 47 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sc8180x-primus.dts b/arch/arm64/boot/dts/qcom/sc8180x-primus.dts
index ffe7c45366ed4..e34f4758ebe28 100644
--- a/arch/arm64/boot/dts/qcom/sc8180x-primus.dts
+++ b/arch/arm64/boot/dts/qcom/sc8180x-primus.dts
@@ -29,9 +29,10 @@ backlight: backlight {
 		compatible = "pwm-backlight";
 		pwms = <&pmc8180c_lpg 4 1000000>;
 		enable-gpios = <&pmc8180c_gpios 8 GPIO_ACTIVE_HIGH>;
+		power-supply = <&vled_bl_pw>;
 
-		pinctrl-names = "default";
 		pinctrl-0 = <&bl_pwm_default>;
+		pinctrl-names = "default";
 	};
 
 	chosen {
@@ -167,6 +168,38 @@ reserved-region@9a500000 {
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
 	vreg_nvme_0p9: regulator-nvme-0p9 {
 		compatible = "regulator-fixed";
 		regulator-name = "vreg_nvme_0p9";
@@ -540,6 +573,7 @@ &mdss_edp {
 	aux-bus {
 		panel {
 			compatible = "edp-panel";
+			power-supply = <&vreg_lcm_3v3>;
 
 			backlight = <&backlight>;
 
@@ -769,6 +803,12 @@ &wifi {
 };
 
 /* PINCTRL */
+&pmc8180_2_gpios {
+	bl_pwr_en: bl-pwr-en-state {
+		pins = "gpio1";
+		function = "normal";
+	};
+};
 
 &pmc8180c_gpios {
 	bl_pwm_default: bl-pwm-default-state {
@@ -950,4 +990,10 @@ rx-pins {
 			bias-pull-up;
 		};
 	};
+
+	lcm_3v3_en: lcm-3v3-en-state {
+		pins = "gpio130";
+		function = "gpio";
+		bias-disable;
+	};
 };
-- 
2.53.0




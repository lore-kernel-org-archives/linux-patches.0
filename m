Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8EEE33F59A;
	Sat, 12 Sep 2026 12:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215018; cv=none; b=qYznfg43SR+uTlS23hRRwdEoCQtlBsw0IU2/bbrDhZY/BcE6VU/V68xp2R/OPpJqKwSJU3z8rVpZxZiWDNo7zQ4SmL82XoDQybrbGdCLWTYNjU80yQax8zZ/2ut3r0aVU7j3rlnrHLg1YSyYOqi1GlXNYiUmlG6kBbQmLJDw44o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215018; c=relaxed/simple;
	bh=dIVUIChzNCsIZeWllox8eZd4GqlU1QFt4SF+K0zPMDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SLHQh5rARgOd3J+x6n1Mu2ncf9qL7NeIpF6WVzOvKs4rBUzwaj1o4ZATjJaCGKD0gDQ3Ld3DNKCu2NcFTDDzMLZUwz64iQkzvdUL9v5JK65A8t0WUSm+KTE1wtZJRWmPGVe0AUxaHfIuJ95HwAG6CO3veGMvBx7okrxEYQqB4BU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Cwpyb92; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Cwpyb92"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90BC51F000FF;
	Sat, 12 Sep 2026 12:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215016;
	bh=Xb39NACn5AFat6hsDCXTfnBYHHi5BNiWNLL+NX5+SbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2Cwpyb92uM+OvJf4dMBB9Lc5LuFipfJLO3X5yBV+IfqeMYiT9aSPFjCxA9MFHC43t
	 iENDicuZVIXyTZCf1MUJMWShDru7Chp3NbY87UMNK1R7RfHbOstCPJs+tyvcSlZp0N
	 0Ej89TLBx3P5+Hd5XjMf86eSECKMzUcoVSGiDGZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0445/1376] arm64: dts: qcom: sc8180x-primus: Describe the display power net
Date: Sat, 12 Sep 2026 08:47:51 +0200
Message-ID: <20260912065617.452077505@linuxfoundation.org>
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
index 09dc42f5f2f86..4d1d079a1f37e 100644
--- a/arch/arm64/boot/dts/qcom/sc8180x-primus.dts
+++ b/arch/arm64/boot/dts/qcom/sc8180x-primus.dts
@@ -27,9 +27,10 @@ backlight: backlight {
 		compatible = "pwm-backlight";
 		pwms = <&pmc8180c_lpg 4 1000000>;
 		enable-gpios = <&pmc8180c_gpios 8 GPIO_ACTIVE_HIGH>;
+		power-supply = <&vled_bl_pw>;
 
-		pinctrl-names = "default";
 		pinctrl-0 = <&bl_pwm_default>;
+		pinctrl-names = "default";
 	};
 
 	chosen {
@@ -165,6 +166,38 @@ reserved-region@9a500000 {
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
@@ -541,6 +574,7 @@ &mdss_edp {
 	aux-bus {
 		panel {
 			compatible = "edp-panel";
+			power-supply = <&vreg_lcm_3v3>;
 
 			backlight = <&backlight>;
 
@@ -778,6 +812,12 @@ &xo_board_clk {
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
@@ -959,4 +999,10 @@ rx-pins {
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




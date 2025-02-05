Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9F0414B080;
	Wed,  5 Feb 2025 14:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765483; cv=none; b=kvDEzQ+23zPrccu4eb1+kjtXdHPv00en5BN5vX1L5GgkIVPy82w2bpZVDmGfqehTfh5VF8IcVSMaaHOGoNoFz00EiOgCTA+kuP8gjodCv2drvKRoFhbxkc4XAWom8Dai5vruYfpX8ASoWXW2+HYFvxrYJcQiHQ4fEXH/QXiGezY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765483; c=relaxed/simple;
	bh=uSEC1oNC2KELpnySj6TsVIBR/5XYK0y9M2QK9dbIAF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lt96DB3O/iJWzJZSOBRzq9hQ03FTtTOWJzlirq3ZsGFu78uioNJ5b4LBlWrfmoKZmP8SKb9huZIWc9Pl6yD6WC5Uw7kkbVwV6cS7GeUsMZ2Waq4MK6arNA8m1HFfikA+FcNOBCSJARawugYR4kXcM19v8UCTn7AVAhjALvk4nxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FfB8j2an; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FfB8j2an"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38DB0C4CED1;
	Wed,  5 Feb 2025 14:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765483;
	bh=uSEC1oNC2KELpnySj6TsVIBR/5XYK0y9M2QK9dbIAF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FfB8j2anCa6kqzjMzP3XPc2ZiB8JZFmsW8iUu87564pqloAE5YvA73wmaxF3lanVE
	 q0KnFnDYGpkrUTHcAGOkfzhs2FEH+gr0V0JboLtHm8/32QtbenVCt1T2toxDds0ej0
	 prsHqyldNHZasRI7ZoAiY30NmJBCiqJ8ZYHulKoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 259/393] arm64: dts: qcom: sc7180-*: Remove thermal zone polling delays
Date: Wed,  5 Feb 2025 14:42:58 +0100
Message-ID: <20250205134430.219764536@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 7cd2d9080a6eb281701f7303b1699719640380d0 ]

All of the thermal zone suppliers are interrupt-driven, remove the
bogus and unnecessary polling that only wastes CPU time.

Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20240510-topic-msm-polling-cleanup-v2-16-436ca4218da2@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: 9180b38d706c ("arm64: dts: qcom: sc7180-trogdor-pompom: rename 5v-choke thermal zone")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/pm6150.dtsi          |  2 +-
 arch/arm64/boot/dts/qcom/pm6150l.dtsi         |  3 ---
 .../boot/dts/qcom/sc7180-trogdor-coachz.dtsi  |  1 -
 .../dts/qcom/sc7180-trogdor-homestar.dtsi     |  1 -
 .../boot/dts/qcom/sc7180-trogdor-pompom.dtsi  |  3 ---
 .../dts/qcom/sc7180-trogdor-wormdingler.dtsi  |  1 -
 arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi  |  3 ---
 arch/arm64/boot/dts/qcom/sc7180.dtsi          | 25 -------------------
 8 files changed, 1 insertion(+), 38 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/pm6150.dtsi b/arch/arm64/boot/dts/qcom/pm6150.dtsi
index 7d4d1f2767ed6..7ae14c53ca8fb 100644
--- a/arch/arm64/boot/dts/qcom/pm6150.dtsi
+++ b/arch/arm64/boot/dts/qcom/pm6150.dtsi
@@ -13,7 +13,7 @@
 	thermal-zones {
 		pm6150_thermal: pm6150-thermal {
 			polling-delay-passive = <100>;
-			polling-delay = <0>;
+
 			thermal-sensors = <&pm6150_temp>;
 
 			trips {
diff --git a/arch/arm64/boot/dts/qcom/pm6150l.dtsi b/arch/arm64/boot/dts/qcom/pm6150l.dtsi
index d13a1ab7c20b3..a20e9b9993b28 100644
--- a/arch/arm64/boot/dts/qcom/pm6150l.dtsi
+++ b/arch/arm64/boot/dts/qcom/pm6150l.dtsi
@@ -10,9 +10,6 @@
 / {
 	thermal-zones {
 		pm6150l-thermal {
-			polling-delay-passive = <0>;
-			polling-delay = <0>;
-
 			thermal-sensors = <&pm6150l_temp>;
 
 			trips {
diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-coachz.dtsi b/arch/arm64/boot/dts/qcom/sc7180-trogdor-coachz.dtsi
index a532cc4aac474..c9adde64450c6 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-coachz.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-coachz.dtsi
@@ -26,7 +26,6 @@
 	thermal-zones {
 		skin_temp_thermal: skin-temp-thermal {
 			polling-delay-passive = <250>;
-			polling-delay = <0>;
 
 			thermal-sensors = <&pm6150_adc_tm 1>;
 			sustainable-power = <965>;
diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-homestar.dtsi b/arch/arm64/boot/dts/qcom/sc7180-trogdor-homestar.dtsi
index b27dcd2ec856f..a9e80acf97637 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-homestar.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-homestar.dtsi
@@ -43,7 +43,6 @@
 	thermal-zones {
 		skin_temp_thermal: skin-temp-thermal {
 			polling-delay-passive = <250>;
-			polling-delay = <0>;
 
 			thermal-sensors = <&pm6150_adc_tm 1>;
 			sustainable-power = <965>;
diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-pompom.dtsi b/arch/arm64/boot/dts/qcom/sc7180-trogdor-pompom.dtsi
index fd944842dd6cd..b5ef846e2191e 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-pompom.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-pompom.dtsi
@@ -13,9 +13,6 @@
 / {
 	thermal-zones {
 		5v-choke-thermal {
-			polling-delay-passive = <0>;
-			polling-delay = <250>;
-
 			thermal-sensors = <&pm6150_adc_tm 1>;
 
 			trips {
diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-wormdingler.dtsi b/arch/arm64/boot/dts/qcom/sc7180-trogdor-wormdingler.dtsi
index 2f6a340ddd2ae..61d0add3c8f6c 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-wormdingler.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-wormdingler.dtsi
@@ -50,7 +50,6 @@
 	thermal-zones {
 		skin_temp_thermal: skin-temp-thermal {
 			polling-delay-passive = <250>;
-			polling-delay = <0>;
 
 			thermal-sensors = <&pm6150_adc_tm 1>;
 			sustainable-power = <574>;
diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi b/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi
index c2f5e9f6679d6..906e616422706 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi
@@ -21,9 +21,6 @@
 / {
 	thermal-zones {
 		charger_thermal: charger-thermal {
-			polling-delay-passive = <0>;
-			polling-delay = <0>;
-
 			thermal-sensors = <&pm6150_adc_tm 0>;
 
 			trips {
diff --git a/arch/arm64/boot/dts/qcom/sc7180.dtsi b/arch/arm64/boot/dts/qcom/sc7180.dtsi
index 68b1c017a9fd5..4e1178496682d 100644
--- a/arch/arm64/boot/dts/qcom/sc7180.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180.dtsi
@@ -3827,7 +3827,6 @@
 	thermal-zones {
 		cpu0_thermal: cpu0-thermal {
 			polling-delay-passive = <250>;
-			polling-delay = <0>;
 
 			thermal-sensors = <&tsens0 1>;
 			sustainable-power = <1052>;
@@ -3876,7 +3875,6 @@
 
 		cpu1_thermal: cpu1-thermal {
 			polling-delay-passive = <250>;
-			polling-delay = <0>;
 
 			thermal-sensors = <&tsens0 2>;
 			sustainable-power = <1052>;
@@ -3925,7 +3923,6 @@
 
 		cpu2_thermal: cpu2-thermal {
 			polling-delay-passive = <250>;
-			polling-delay = <0>;
 
 			thermal-sensors = <&tsens0 3>;
 			sustainable-power = <1052>;
@@ -3974,7 +3971,6 @@
 
 		cpu3_thermal: cpu3-thermal {
 			polling-delay-passive = <250>;
-			polling-delay = <0>;
 
 			thermal-sensors = <&tsens0 4>;
 			sustainable-power = <1052>;
@@ -4023,7 +4019,6 @@
 
 		cpu4_thermal: cpu4-thermal {
 			polling-delay-passive = <250>;
-			polling-delay = <0>;
 
 			thermal-sensors = <&tsens0 5>;
 			sustainable-power = <1052>;
@@ -4072,7 +4067,6 @@
 
 		cpu5_thermal: cpu5-thermal {
 			polling-delay-passive = <250>;
-			polling-delay = <0>;
 
 			thermal-sensors = <&tsens0 6>;
 			sustainable-power = <1052>;
@@ -4121,7 +4115,6 @@
 
 		cpu6_thermal: cpu6-thermal {
 			polling-delay-passive = <250>;
-			polling-delay = <0>;
 
 			thermal-sensors = <&tsens0 9>;
 			sustainable-power = <1425>;
@@ -4162,7 +4155,6 @@
 
 		cpu7_thermal: cpu7-thermal {
 			polling-delay-passive = <250>;
-			polling-delay = <0>;
 
 			thermal-sensors = <&tsens0 10>;
 			sustainable-power = <1425>;
@@ -4203,7 +4195,6 @@
 
 		cpu8_thermal: cpu8-thermal {
 			polling-delay-passive = <250>;
-			polling-delay = <0>;
 
 			thermal-sensors = <&tsens0 11>;
 			sustainable-power = <1425>;
@@ -4244,7 +4235,6 @@
 
 		cpu9_thermal: cpu9-thermal {
 			polling-delay-passive = <250>;
-			polling-delay = <0>;
 
 			thermal-sensors = <&tsens0 12>;
 			sustainable-power = <1425>;
@@ -4285,7 +4275,6 @@
 
 		aoss0-thermal {
 			polling-delay-passive = <250>;
-			polling-delay = <0>;
 
 			thermal-sensors = <&tsens0 0>;
 
@@ -4306,7 +4295,6 @@
 
 		cpuss0-thermal {
 			polling-delay-passive = <250>;
-			polling-delay = <0>;
 
 			thermal-sensors = <&tsens0 7>;
 
@@ -4326,7 +4314,6 @@
 
 		cpuss1-thermal {
 			polling-delay-passive = <250>;
-			polling-delay = <0>;
 
 			thermal-sensors = <&tsens0 8>;
 
@@ -4346,7 +4333,6 @@
 
 		gpuss0-thermal {
 			polling-delay-passive = <250>;
-			polling-delay = <0>;
 
 			thermal-sensors = <&tsens0 13>;
 
@@ -4374,7 +4360,6 @@
 
 		gpuss1-thermal {
 			polling-delay-passive = <250>;
-			polling-delay = <0>;
 
 			thermal-sensors = <&tsens0 14>;
 
@@ -4402,7 +4387,6 @@
 
 		aoss1-thermal {
 			polling-delay-passive = <250>;
-			polling-delay = <0>;
 
 			thermal-sensors = <&tsens1 0>;
 
@@ -4423,7 +4407,6 @@
 
 		cwlan-thermal {
 			polling-delay-passive = <250>;
-			polling-delay = <0>;
 
 			thermal-sensors = <&tsens1 1>;
 
@@ -4444,7 +4427,6 @@
 
 		audio-thermal {
 			polling-delay-passive = <250>;
-			polling-delay = <0>;
 
 			thermal-sensors = <&tsens1 2>;
 
@@ -4465,7 +4447,6 @@
 
 		ddr-thermal {
 			polling-delay-passive = <250>;
-			polling-delay = <0>;
 
 			thermal-sensors = <&tsens1 3>;
 
@@ -4486,7 +4467,6 @@
 
 		q6-hvx-thermal {
 			polling-delay-passive = <250>;
-			polling-delay = <0>;
 
 			thermal-sensors = <&tsens1 4>;
 
@@ -4507,7 +4487,6 @@
 
 		camera-thermal {
 			polling-delay-passive = <250>;
-			polling-delay = <0>;
 
 			thermal-sensors = <&tsens1 5>;
 
@@ -4528,7 +4507,6 @@
 
 		mdm-core-thermal {
 			polling-delay-passive = <250>;
-			polling-delay = <0>;
 
 			thermal-sensors = <&tsens1 6>;
 
@@ -4549,7 +4527,6 @@
 
 		mdm-dsp-thermal {
 			polling-delay-passive = <250>;
-			polling-delay = <0>;
 
 			thermal-sensors = <&tsens1 7>;
 
@@ -4570,7 +4547,6 @@
 
 		npu-thermal {
 			polling-delay-passive = <250>;
-			polling-delay = <0>;
 
 			thermal-sensors = <&tsens1 8>;
 
@@ -4591,7 +4567,6 @@
 
 		video-thermal {
 			polling-delay-passive = <250>;
-			polling-delay = <0>;
 
 			thermal-sensors = <&tsens1 9>;
 
-- 
2.39.5




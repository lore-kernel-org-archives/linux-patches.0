Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C3AF1DE898;
	Wed, 19 Feb 2025 09:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956426; cv=none; b=eogyk0oCTj8PpZ9fWQTkPAYATUeEcihU+Az7eNqkp70xcX6uNccNZ0Hq8ngSRr1aZ2CTOrF75I+joouBd5DPfb3QaGpHxFv03PDgeIOk8IefOzJ6QlutmCLrKxsdIr6yJl/j5Ys0KPl7xxM6dT0jpF/0YcltqPxtKkrXR1/RUUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956426; c=relaxed/simple;
	bh=lx2+1jvlMSf6RBPq7oeU8tptgYcuCBqLLJIEKytT7Gg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VyXx20bf0qDQ0vRry+UgWMvCyEBvpBXE5xZen6IPx/1Uy2th0eyAb/7SVeUYA6fQCgUaEffYaMCdxau11Rt8fKp9nezf3mzW4OhEosn+6a27byCHd4VoCSPP+EPq14+40ZrayKdY+EfxYDI1VxGxVeJhP0wCwZUoTMacTjtSdzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PZHjRg9p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PZHjRg9p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA730C4CED1;
	Wed, 19 Feb 2025 09:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956426;
	bh=lx2+1jvlMSf6RBPq7oeU8tptgYcuCBqLLJIEKytT7Gg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PZHjRg9pgZNs3f2exHVXdiKFNeCAOuNMdW45HXOd4x2AC2SmJPCkg0PVLjW9Lqe3y
	 d9NNnyBHXX0aRKJZUNKqsCAPZ/sSinvL/iw17EBLdt0qAl+3mKZkL5mhUlgXBlII6H
	 DKTRWngnoSy3Q3V7iv0yFey6OY7eGZrbRjaoW6wM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 174/578] arm64: dts: qcom: sc7180-*: Remove thermal zone polling delays
Date: Wed, 19 Feb 2025 09:22:58 +0100
Message-ID: <20250219082659.813577188@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 8a4972e6a24c1..b45ffd7d3b364 100644
--- a/arch/arm64/boot/dts/qcom/pm6150.dtsi
+++ b/arch/arm64/boot/dts/qcom/pm6150.dtsi
@@ -11,7 +11,7 @@
 	thermal-zones {
 		pm6150_thermal: pm6150-thermal {
 			polling-delay-passive = <100>;
-			polling-delay = <0>;
+
 			thermal-sensors = <&pm6150_temp>;
 
 			trips {
diff --git a/arch/arm64/boot/dts/qcom/pm6150l.dtsi b/arch/arm64/boot/dts/qcom/pm6150l.dtsi
index ac3c6456c47c7..e7526a7f41e28 100644
--- a/arch/arm64/boot/dts/qcom/pm6150l.dtsi
+++ b/arch/arm64/boot/dts/qcom/pm6150l.dtsi
@@ -8,9 +8,6 @@
 / {
 	thermal-zones {
 		pm6150l-thermal {
-			polling-delay-passive = <0>;
-			polling-delay = <0>;
-
 			thermal-sensors = <&pm6150l_temp>;
 
 			trips {
diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-coachz.dtsi b/arch/arm64/boot/dts/qcom/sc7180-trogdor-coachz.dtsi
index 7ee407f7b6bb5..f98162d3a0812 100644
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
index bfab67f4a7c9c..a7b41498ba88c 100644
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
index a7582fb547eea..d363a8b6906aa 100644
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
index 0b5b0449299bd..ebb64b91c09f7 100644
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
index d537b8784b472..06b6774ef0106 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi
@@ -20,9 +20,6 @@
 / {
 	thermal-zones {
 		charger_thermal: charger-thermal {
-			polling-delay-passive = <0>;
-			polling-delay = <0>;
-
 			thermal-sensors = <&pm6150_adc_tm 0>;
 
 			trips {
diff --git a/arch/arm64/boot/dts/qcom/sc7180.dtsi b/arch/arm64/boot/dts/qcom/sc7180.dtsi
index 3a13cc02c9832..a9f937b068479 100644
--- a/arch/arm64/boot/dts/qcom/sc7180.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180.dtsi
@@ -3630,7 +3630,6 @@
 	thermal-zones {
 		cpu0_thermal: cpu0-thermal {
 			polling-delay-passive = <250>;
-			polling-delay = <0>;
 
 			thermal-sensors = <&tsens0 1>;
 			sustainable-power = <1052>;
@@ -3679,7 +3678,6 @@
 
 		cpu1_thermal: cpu1-thermal {
 			polling-delay-passive = <250>;
-			polling-delay = <0>;
 
 			thermal-sensors = <&tsens0 2>;
 			sustainable-power = <1052>;
@@ -3728,7 +3726,6 @@
 
 		cpu2_thermal: cpu2-thermal {
 			polling-delay-passive = <250>;
-			polling-delay = <0>;
 
 			thermal-sensors = <&tsens0 3>;
 			sustainable-power = <1052>;
@@ -3777,7 +3774,6 @@
 
 		cpu3_thermal: cpu3-thermal {
 			polling-delay-passive = <250>;
-			polling-delay = <0>;
 
 			thermal-sensors = <&tsens0 4>;
 			sustainable-power = <1052>;
@@ -3826,7 +3822,6 @@
 
 		cpu4_thermal: cpu4-thermal {
 			polling-delay-passive = <250>;
-			polling-delay = <0>;
 
 			thermal-sensors = <&tsens0 5>;
 			sustainable-power = <1052>;
@@ -3875,7 +3870,6 @@
 
 		cpu5_thermal: cpu5-thermal {
 			polling-delay-passive = <250>;
-			polling-delay = <0>;
 
 			thermal-sensors = <&tsens0 6>;
 			sustainable-power = <1052>;
@@ -3924,7 +3918,6 @@
 
 		cpu6_thermal: cpu6-thermal {
 			polling-delay-passive = <250>;
-			polling-delay = <0>;
 
 			thermal-sensors = <&tsens0 9>;
 			sustainable-power = <1425>;
@@ -3965,7 +3958,6 @@
 
 		cpu7_thermal: cpu7-thermal {
 			polling-delay-passive = <250>;
-			polling-delay = <0>;
 
 			thermal-sensors = <&tsens0 10>;
 			sustainable-power = <1425>;
@@ -4006,7 +3998,6 @@
 
 		cpu8_thermal: cpu8-thermal {
 			polling-delay-passive = <250>;
-			polling-delay = <0>;
 
 			thermal-sensors = <&tsens0 11>;
 			sustainable-power = <1425>;
@@ -4047,7 +4038,6 @@
 
 		cpu9_thermal: cpu9-thermal {
 			polling-delay-passive = <250>;
-			polling-delay = <0>;
 
 			thermal-sensors = <&tsens0 12>;
 			sustainable-power = <1425>;
@@ -4088,7 +4078,6 @@
 
 		aoss0-thermal {
 			polling-delay-passive = <250>;
-			polling-delay = <0>;
 
 			thermal-sensors = <&tsens0 0>;
 
@@ -4109,7 +4098,6 @@
 
 		cpuss0-thermal {
 			polling-delay-passive = <250>;
-			polling-delay = <0>;
 
 			thermal-sensors = <&tsens0 7>;
 
@@ -4129,7 +4117,6 @@
 
 		cpuss1-thermal {
 			polling-delay-passive = <250>;
-			polling-delay = <0>;
 
 			thermal-sensors = <&tsens0 8>;
 
@@ -4149,7 +4136,6 @@
 
 		gpuss0-thermal {
 			polling-delay-passive = <250>;
-			polling-delay = <0>;
 
 			thermal-sensors = <&tsens0 13>;
 
@@ -4177,7 +4163,6 @@
 
 		gpuss1-thermal {
 			polling-delay-passive = <250>;
-			polling-delay = <0>;
 
 			thermal-sensors = <&tsens0 14>;
 
@@ -4205,7 +4190,6 @@
 
 		aoss1-thermal {
 			polling-delay-passive = <250>;
-			polling-delay = <0>;
 
 			thermal-sensors = <&tsens1 0>;
 
@@ -4226,7 +4210,6 @@
 
 		cwlan-thermal {
 			polling-delay-passive = <250>;
-			polling-delay = <0>;
 
 			thermal-sensors = <&tsens1 1>;
 
@@ -4247,7 +4230,6 @@
 
 		audio-thermal {
 			polling-delay-passive = <250>;
-			polling-delay = <0>;
 
 			thermal-sensors = <&tsens1 2>;
 
@@ -4268,7 +4250,6 @@
 
 		ddr-thermal {
 			polling-delay-passive = <250>;
-			polling-delay = <0>;
 
 			thermal-sensors = <&tsens1 3>;
 
@@ -4289,7 +4270,6 @@
 
 		q6-hvx-thermal {
 			polling-delay-passive = <250>;
-			polling-delay = <0>;
 
 			thermal-sensors = <&tsens1 4>;
 
@@ -4310,7 +4290,6 @@
 
 		camera-thermal {
 			polling-delay-passive = <250>;
-			polling-delay = <0>;
 
 			thermal-sensors = <&tsens1 5>;
 
@@ -4331,7 +4310,6 @@
 
 		mdm-core-thermal {
 			polling-delay-passive = <250>;
-			polling-delay = <0>;
 
 			thermal-sensors = <&tsens1 6>;
 
@@ -4352,7 +4330,6 @@
 
 		mdm-dsp-thermal {
 			polling-delay-passive = <250>;
-			polling-delay = <0>;
 
 			thermal-sensors = <&tsens1 7>;
 
@@ -4373,7 +4350,6 @@
 
 		npu-thermal {
 			polling-delay-passive = <250>;
-			polling-delay = <0>;
 
 			thermal-sensors = <&tsens1 8>;
 
@@ -4394,7 +4370,6 @@
 
 		video-thermal {
 			polling-delay-passive = <250>;
-			polling-delay = <0>;
 
 			thermal-sensors = <&tsens1 9>;
 
-- 
2.39.5




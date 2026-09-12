Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 681A2246BCD;
	Sat, 12 Sep 2026 10:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208655; cv=none; b=Dy3J3GIYjN3kYl54FvWun9KREvpoRLTV4DvD6Y5xQOskx7/LlGUnI7WHzr3SAB5UktcfDPE4VgNtoyOzEMOOWbyKS8rKQYapO8GjHiPUDV0OVy3zgRvqz+vrCFIEzRZeKP0+v4TdlrulMNizl1Rz6goh6V8LPO2RWJ6e31tTSIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208655; c=relaxed/simple;
	bh=1OHaKXSAjSZGi9vEAN6UyT2deNbA7JG5+BrgKtVyiXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qYAlLa4FSmobBEGidGRVll3Dp/+wbAqx+Z79ymQHEiS4I/NaVNsRfGX2BtHXkEf1f8X+gveOYqOGtv16siuVL4c48ZdH/Y8GF5rq1YX5UwLptLtK1JtMy9WCYlm1/zSQlyYfvdSXVRbVXu7vD761zdrj4FrCdDsR4NwwvKNEANs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lY55dNoC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lY55dNoC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D6721F000FF;
	Sat, 12 Sep 2026 10:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208654;
	bh=kroT1CYjELqkekss4Vay8oQwLg6ZoCQoQ+yi/fj+OaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lY55dNoCsxVVsOh1itE/3ZpiMWOwP113aPdlShJZOFdAZa6Ys5OcJKN5ysmvHsgrs
	 yCX4+DbHAykw7B2Riu+UBpBW+KqgYWLo8X6WwTRkOaTvXZO5P7qEwumkA8x3DTtcju
	 pel8Fk+I3SF/G92hZNEnYHU/pCoKoJ4uTWks/jdA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0662/1518] arm64: dts: qcom: msm8998: Dont pull-up I2C pins by default in sleep
Date: Sat, 12 Sep 2026 08:47:11 +0200
Message-ID: <20260912065638.409403134@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit 58ce9a2b9099bb26aed55d4e350c32af94930532 ]

When the I2C controller is disabled, no communication is expected to
take place. Without traffic on the bus, the pull-up is unnecessary.

Both the vendor kernel for this platform and DTs of other SoCs in
upstream concur this logic. Change the default and clean up now-NOP
overrides.

Fixes: 0fee55fc0de7 ("arm64: dts: qcom: msm8998: Add I2C pinctrl and fix BLSP2_I2C naming")
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260717-topic-june26_dts_fixes-v2-1-797cd46e5d9f@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../dts/qcom/msm8998-sony-xperia-yoshino.dtsi |  4 ----
 .../boot/dts/qcom/msm8998-xiaomi-sagit.dts    |  5 ----
 arch/arm64/boot/dts/qcom/msm8998.dtsi         | 24 +++++++++----------
 3 files changed, 12 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8998-sony-xperia-yoshino.dtsi b/arch/arm64/boot/dts/qcom/msm8998-sony-xperia-yoshino.dtsi
index 3650f2501886b..04d4741cdb5f0 100644
--- a/arch/arm64/boot/dts/qcom/msm8998-sony-xperia-yoshino.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8998-sony-xperia-yoshino.dtsi
@@ -229,10 +229,6 @@ rmi4-f11@11 {
 	};
 };
 
-&blsp1_i2c5_sleep {
-	bias-disable;
-};
-
 &blsp1_uart3 {
 	status = "okay";
 
diff --git a/arch/arm64/boot/dts/qcom/msm8998-xiaomi-sagit.dts b/arch/arm64/boot/dts/qcom/msm8998-xiaomi-sagit.dts
index 0cac06f25a77a..2ceeec827f8e2 100644
--- a/arch/arm64/boot/dts/qcom/msm8998-xiaomi-sagit.dts
+++ b/arch/arm64/boot/dts/qcom/msm8998-xiaomi-sagit.dts
@@ -217,11 +217,6 @@ rmi4-f1a@1a {
 	};
 };
 
-&blsp1_i2c5_sleep {
-	/delete-property/ bias-pull-up;
-	bias-disable;
-};
-
 &blsp1_uart3 {
 	status = "okay";
 
diff --git a/arch/arm64/boot/dts/qcom/msm8998.dtsi b/arch/arm64/boot/dts/qcom/msm8998.dtsi
index 5c75fba16ce2c..515aa844a3e37 100644
--- a/arch/arm64/boot/dts/qcom/msm8998.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8998.dtsi
@@ -1183,7 +1183,7 @@ blsp1_i2c1_sleep: blsp1-i2c1-sleep-state-state {
 				pins = "gpio2", "gpio3";
 				function = "blsp_i2c1";
 				drive-strength = <2>;
-				bias-pull-up;
+				bias-disable;
 			};
 
 			blsp1_i2c2_default: blsp1-i2c2-default-state {
@@ -1197,7 +1197,7 @@ blsp1_i2c2_sleep: blsp1-i2c2-sleep-state-state {
 				pins = "gpio32", "gpio33";
 				function = "blsp_i2c2";
 				drive-strength = <2>;
-				bias-pull-up;
+				bias-disable;
 			};
 
 			blsp1_i2c3_default: blsp1-i2c3-default-state {
@@ -1211,7 +1211,7 @@ blsp1_i2c3_sleep: blsp1-i2c3-sleep-state {
 				pins = "gpio47", "gpio48";
 				function = "blsp_i2c3";
 				drive-strength = <2>;
-				bias-pull-up;
+				bias-disable;
 			};
 
 			blsp1_i2c4_default: blsp1-i2c4-default-state {
@@ -1225,7 +1225,7 @@ blsp1_i2c4_sleep: blsp1-i2c4-sleep-state {
 				pins = "gpio10", "gpio11";
 				function = "blsp_i2c4";
 				drive-strength = <2>;
-				bias-pull-up;
+				bias-disable;
 			};
 
 			blsp1_i2c5_default: blsp1-i2c5-default-state {
@@ -1239,7 +1239,7 @@ blsp1_i2c5_sleep: blsp1-i2c5-sleep-state {
 				pins = "gpio87", "gpio88";
 				function = "blsp_i2c5";
 				drive-strength = <2>;
-				bias-pull-up;
+				bias-disable;
 			};
 
 			blsp1_i2c6_default: blsp1-i2c6-default-state {
@@ -1253,7 +1253,7 @@ blsp1_i2c6_sleep: blsp1-i2c6-sleep-state {
 				pins = "gpio43", "gpio44";
 				function = "blsp_i2c6";
 				drive-strength = <2>;
-				bias-pull-up;
+				bias-disable;
 			};
 
 			blsp1_spi_b_default: blsp1-spi-b-default-state {
@@ -1318,7 +1318,7 @@ blsp2_i2c1_sleep: blsp2-i2c1-sleep-state {
 				pins = "gpio55", "gpio56";
 				function = "blsp_i2c7";
 				drive-strength = <2>;
-				bias-pull-up;
+				bias-disable;
 			};
 
 			blsp2_i2c2_default: blsp2-i2c2-default-state {
@@ -1332,7 +1332,7 @@ blsp2_i2c2_sleep: blsp2-i2c2-sleep-state {
 				pins = "gpio6", "gpio7";
 				function = "blsp_i2c8";
 				drive-strength = <2>;
-				bias-pull-up;
+				bias-disable;
 			};
 
 			blsp2_i2c3_default: blsp2-i2c3-default-state {
@@ -1346,7 +1346,7 @@ blsp2_i2c3_sleep: blsp2-i2c3-sleep-state {
 				pins = "gpio51", "gpio52";
 				function = "blsp_i2c9";
 				drive-strength = <2>;
-				bias-pull-up;
+				bias-disable;
 			};
 
 			blsp2_i2c4_default: blsp2-i2c4-default-state {
@@ -1360,7 +1360,7 @@ blsp2_i2c4_sleep: blsp2-i2c4-sleep-state {
 				pins = "gpio67", "gpio68";
 				function = "blsp_i2c10";
 				drive-strength = <2>;
-				bias-pull-up;
+				bias-disable;
 			};
 
 			blsp2_i2c5_default: blsp2-i2c5-default-state {
@@ -1374,7 +1374,7 @@ blsp2_i2c5_sleep: blsp2-i2c5-sleep-state {
 				pins = "gpio60", "gpio61";
 				function = "blsp_i2c11";
 				drive-strength = <2>;
-				bias-pull-up;
+				bias-disable;
 			};
 
 			blsp2_i2c6_default: blsp2-i2c6-default-state {
@@ -1388,7 +1388,7 @@ blsp2_i2c6_sleep: blsp2-i2c6-sleep-state {
 				pins = "gpio83", "gpio84";
 				function = "blsp_i2c12";
 				drive-strength = <2>;
-				bias-pull-up;
+				bias-disable;
 			};
 
 			blsp2_spi1_default: blsp2-spi1-default-state {
-- 
2.53.0




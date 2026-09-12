Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4881437998A;
	Sat, 12 Sep 2026 08:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200595; cv=none; b=p3aMKgkkCLSLgBV6xwdbilWIt+VkdCTz1petIVFPb9u8nZndaxcSwlL9VC4KrZeobVbFi8MGAEO3ubJ2QUVbEWuvn1sqHz4gtlmtf0RV0Dr42MaNlXGP/G0dfax5Zjw8Rhm0e0243HAvPhLpeCE23yrupp+/6XLquhYJRWBlR9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200595; c=relaxed/simple;
	bh=PEhJ7iaAy48DSa0Ttbv+5KoJIBYj2+37CsaYLsvsciY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bi8sqzSYz6tcjKnMEbeWhYL/TK+7b2gBzLUO9/RrrWzKQ9p1t4R92LCMeD10o+QAh4BZFjE7Zgrg2h7kO+NnXEfY2tl/77rcKaJC3zaP/TIlH41gscKOjVhCuDBKhK+kSfW2Hk7PXK4Z8pnmL5XbftIbLQivdU6K7I45fizRGT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y7kLkva7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y7kLkva7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15ECD1F000FF;
	Sat, 12 Sep 2026 08:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200594;
	bh=riVno6yBYqx9PJtCPI+xO0T9YnIeFIUH2cNx0BkbqC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y7kLkva7kaEtNj7DqVLX2iV4rtNWmXUN38SsckOE7TWAs0YICELB6Box73D3q/1/4
	 95JgWN7tCLL89ayhrjRyc99bF2nPX3aFD8F4lJTTyWj6+QgnsmWGCnti6+hVAci9bM
	 mYcDkLaknDHWvCCdzL8gPrYhrWJFM0UkUFbwGGnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0779/1815] arm64: dts: qcom: msm8998: Dont pull-up I2C pins by default in sleep
Date: Sat, 12 Sep 2026 08:42:09 +0200
Message-ID: <20260912065707.197352577@linuxfoundation.org>
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
index 30222f6608da7..69528771eda25 100644
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
index 3477060116372..5038d0009c1a9 100644
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




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AE8047987B;
	Sat, 12 Sep 2026 12:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216520; cv=none; b=LvO4yAxB0FxXMtNpiBg1eTzfXuIMWLSyTTSOUQ63CCAMSf1pGekTwdhvlYZgG9jpf1YcCHbc+jDVehPSI8tmX2vK17NzZ/WgwbXeJw1Fbb8cn6wZQxq2+/GY3IiZSpg/Lx6uemusOZrgtXlmEpjXoq+6G/vc01xYpIT5a6EVHs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216520; c=relaxed/simple;
	bh=7OjIW4y5zrq8g+8v522bw2ba/lUthGLDO2XhV2VJdZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ss2ptsK9bish6J8RDxuMFBtWcltT/5si418xQgfmWbI3aguQZ4de8LItaQfzc151vJgrzusiZRJsLrdx18B9jCXxSCBz6gwKw1XHbhCUT97Oz3rWD2egd5oV/g+gVViSAG8Vfv4MLjniHJgp2jWJ+W2AIdSsLXPsYe78E/alB3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YnuN4FuY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YnuN4FuY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03E6C1F000FF;
	Sat, 12 Sep 2026 12:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216519;
	bh=ABwe1IIppeJ/o/DWDXR+GuC46PDO8LaYCx9jDNCTDz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YnuN4FuYaOig1kOXWq3gRlHrFso5i98sQNq75ZZAMs92e6chRv3eCekL/8A9PPyEx
	 b+9P7mBJqA6EATwfs8EwjBFkNNS62xrKOO76QsrkpdStWk4ZsCefibn3u5aKFGIx0B
	 84U7Mhmmwrfk56tp7Gb6LNhGJr3AcfXuypjqyR8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0754/1376] arm64: dts: qcom: msm8998: Dont pull-up I2C pins by default in sleep
Date: Sat, 12 Sep 2026 08:53:00 +0200
Message-ID: <20260912065624.347168679@linuxfoundation.org>
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
index d8cc0d729e99c..0b6b71b5ec5d8 100644
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
index 9aa9c5cee355b..6524a182277db 100644
--- a/arch/arm64/boot/dts/qcom/msm8998.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8998.dtsi
@@ -1166,7 +1166,7 @@ blsp1_i2c1_sleep: blsp1-i2c1-sleep-state-state {
 				pins = "gpio2", "gpio3";
 				function = "blsp_i2c1";
 				drive-strength = <2>;
-				bias-pull-up;
+				bias-disable;
 			};
 
 			blsp1_i2c2_default: blsp1-i2c2-default-state {
@@ -1180,7 +1180,7 @@ blsp1_i2c2_sleep: blsp1-i2c2-sleep-state-state {
 				pins = "gpio32", "gpio33";
 				function = "blsp_i2c2";
 				drive-strength = <2>;
-				bias-pull-up;
+				bias-disable;
 			};
 
 			blsp1_i2c3_default: blsp1-i2c3-default-state {
@@ -1194,7 +1194,7 @@ blsp1_i2c3_sleep: blsp1-i2c3-sleep-state {
 				pins = "gpio47", "gpio48";
 				function = "blsp_i2c3";
 				drive-strength = <2>;
-				bias-pull-up;
+				bias-disable;
 			};
 
 			blsp1_i2c4_default: blsp1-i2c4-default-state {
@@ -1208,7 +1208,7 @@ blsp1_i2c4_sleep: blsp1-i2c4-sleep-state {
 				pins = "gpio10", "gpio11";
 				function = "blsp_i2c4";
 				drive-strength = <2>;
-				bias-pull-up;
+				bias-disable;
 			};
 
 			blsp1_i2c5_default: blsp1-i2c5-default-state {
@@ -1222,7 +1222,7 @@ blsp1_i2c5_sleep: blsp1-i2c5-sleep-state {
 				pins = "gpio87", "gpio88";
 				function = "blsp_i2c5";
 				drive-strength = <2>;
-				bias-pull-up;
+				bias-disable;
 			};
 
 			blsp1_i2c6_default: blsp1-i2c6-default-state {
@@ -1236,7 +1236,7 @@ blsp1_i2c6_sleep: blsp1-i2c6-sleep-state {
 				pins = "gpio43", "gpio44";
 				function = "blsp_i2c6";
 				drive-strength = <2>;
-				bias-pull-up;
+				bias-disable;
 			};
 
 			blsp1_spi_b_default: blsp1-spi-b-default-state {
@@ -1301,7 +1301,7 @@ blsp2_i2c1_sleep: blsp2-i2c1-sleep-state {
 				pins = "gpio55", "gpio56";
 				function = "blsp_i2c7";
 				drive-strength = <2>;
-				bias-pull-up;
+				bias-disable;
 			};
 
 			blsp2_i2c2_default: blsp2-i2c2-default-state {
@@ -1315,7 +1315,7 @@ blsp2_i2c2_sleep: blsp2-i2c2-sleep-state {
 				pins = "gpio6", "gpio7";
 				function = "blsp_i2c8";
 				drive-strength = <2>;
-				bias-pull-up;
+				bias-disable;
 			};
 
 			blsp2_i2c3_default: blsp2-i2c3-default-state {
@@ -1329,7 +1329,7 @@ blsp2_i2c3_sleep: blsp2-i2c3-sleep-state {
 				pins = "gpio51", "gpio52";
 				function = "blsp_i2c9";
 				drive-strength = <2>;
-				bias-pull-up;
+				bias-disable;
 			};
 
 			blsp2_i2c4_default: blsp2-i2c4-default-state {
@@ -1343,7 +1343,7 @@ blsp2_i2c4_sleep: blsp2-i2c4-sleep-state {
 				pins = "gpio67", "gpio68";
 				function = "blsp_i2c10";
 				drive-strength = <2>;
-				bias-pull-up;
+				bias-disable;
 			};
 
 			blsp2_i2c5_default: blsp2-i2c5-default-state {
@@ -1357,7 +1357,7 @@ blsp2_i2c5_sleep: blsp2-i2c5-sleep-state {
 				pins = "gpio60", "gpio61";
 				function = "blsp_i2c11";
 				drive-strength = <2>;
-				bias-pull-up;
+				bias-disable;
 			};
 
 			blsp2_i2c6_default: blsp2-i2c6-default-state {
@@ -1371,7 +1371,7 @@ blsp2_i2c6_sleep: blsp2-i2c6-sleep-state {
 				pins = "gpio83", "gpio84";
 				function = "blsp_i2c12";
 				drive-strength = <2>;
-				bias-pull-up;
+				bias-disable;
 			};
 
 			blsp2_spi1_default: blsp2-spi1-default-state {
-- 
2.53.0




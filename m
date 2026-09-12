Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 578822D5C68;
	Sat, 12 Sep 2026 16:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230279; cv=none; b=PQLLno0zCuPwW84c72ngyvF056Auww/lMEAjzIeSngcV1CVafv9PtGHU41nSD2snYq/AGj9U/iTrhfj9ZAJT3UqfDAvTajXua6gt6ddPdC6Lw2iB7N1xy5McjHCAR/fpquI0eXSjGmQ45v4Cu3ne+uqBY+1sUli+Dyw4qtNH0zM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230279; c=relaxed/simple;
	bh=rbBToBDIUsiTH9S5gqAI1J+Y9xJ2tqWraE2/mPiW9pI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d0epFymafPL4i0Lr54uOT/KHWux9Z/pThGxbGktQVkXokw7bAixU+vgG2Cv35rAxebMI1eH/tjVQak5V79fsWxKNDrzLb47CjpsUw7LNRQS3pqOngtJj5VU4w4vm51Z7Q3XZ2iPafdlUc1eIFd0mRIONrOrJoIOgotd/dh+2pCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pkxmpQal; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pkxmpQal"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11CC31F00893;
	Sat, 12 Sep 2026 16:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230278;
	bh=zO89ie8XbYPE7CmspYPb83ARcFecFO+AGXupsF5Vgyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pkxmpQalMpzcYOeO3NdFnYzO0I7F8BHqtaws6drxFAdTIocebrFTLHbPHcTG8gD2T
	 cnUUWIdUNBcTHPMXZo2eEx9lXA1CtuPwMLBXmOvFXDsb7K2JyNRSrtsXTZUw79JiRv
	 b/W7JqInWQPFLTeBxZkmkHl2s4ptSoGv02cT7VWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0761/1191] arm64: dts: qcom: msm8998: Dont pull-up I2C pins by default in sleep
Date: Sat, 12 Sep 2026 08:58:09 +0200
Message-ID: <20260912065605.369868367@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d086390822476..87f116565fd8e 100644
--- a/arch/arm64/boot/dts/qcom/msm8998-sony-xperia-yoshino.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8998-sony-xperia-yoshino.dtsi
@@ -225,10 +225,6 @@ rmi4-f11@11 {
 	};
 };
 
-&blsp1_i2c5_sleep {
-	bias-disable;
-};
-
 &blsp1_uart3 {
 	status = "okay";
 
diff --git a/arch/arm64/boot/dts/qcom/msm8998-xiaomi-sagit.dts b/arch/arm64/boot/dts/qcom/msm8998-xiaomi-sagit.dts
index b1aac7311ef96..d0f4d35a399a5 100644
--- a/arch/arm64/boot/dts/qcom/msm8998-xiaomi-sagit.dts
+++ b/arch/arm64/boot/dts/qcom/msm8998-xiaomi-sagit.dts
@@ -218,11 +218,6 @@ rmi4-f1a@1a {
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
index 4de9ff045ff52..a7b9b28d0e580 100644
--- a/arch/arm64/boot/dts/qcom/msm8998.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8998.dtsi
@@ -1149,7 +1149,7 @@ blsp1_i2c1_sleep: blsp1-i2c1-sleep {
 				pins = "gpio2", "gpio3";
 				function = "blsp_i2c1";
 				drive-strength = <2>;
-				bias-pull-up;
+				bias-disable;
 			};
 
 			blsp1_i2c2_default: blsp1-i2c2-default {
@@ -1163,7 +1163,7 @@ blsp1_i2c2_sleep: blsp1-i2c2-sleep {
 				pins = "gpio32", "gpio33";
 				function = "blsp_i2c2";
 				drive-strength = <2>;
-				bias-pull-up;
+				bias-disable;
 			};
 
 			blsp1_i2c3_default: blsp1-i2c3-default {
@@ -1177,7 +1177,7 @@ blsp1_i2c3_sleep: blsp1-i2c3-sleep {
 				pins = "gpio47", "gpio48";
 				function = "blsp_i2c3";
 				drive-strength = <2>;
-				bias-pull-up;
+				bias-disable;
 			};
 
 			blsp1_i2c4_default: blsp1-i2c4-default {
@@ -1191,7 +1191,7 @@ blsp1_i2c4_sleep: blsp1-i2c4-sleep {
 				pins = "gpio10", "gpio11";
 				function = "blsp_i2c4";
 				drive-strength = <2>;
-				bias-pull-up;
+				bias-disable;
 			};
 
 			blsp1_i2c5_default: blsp1-i2c5-default {
@@ -1205,7 +1205,7 @@ blsp1_i2c5_sleep: blsp1-i2c5-sleep {
 				pins = "gpio87", "gpio88";
 				function = "blsp_i2c5";
 				drive-strength = <2>;
-				bias-pull-up;
+				bias-disable;
 			};
 
 			blsp1_i2c6_default: blsp1-i2c6-default {
@@ -1219,7 +1219,7 @@ blsp1_i2c6_sleep: blsp1-i2c6-sleep {
 				pins = "gpio43", "gpio44";
 				function = "blsp_i2c6";
 				drive-strength = <2>;
-				bias-pull-up;
+				bias-disable;
 			};
 			/* 6 interfaces per QUP, BLSP2 indexes are numbered (n)+6 */
 			blsp2_i2c1_default: blsp2-i2c1-default {
@@ -1233,7 +1233,7 @@ blsp2_i2c1_sleep: blsp2-i2c1-sleep {
 				pins = "gpio55", "gpio56";
 				function = "blsp_i2c7";
 				drive-strength = <2>;
-				bias-pull-up;
+				bias-disable;
 			};
 
 			blsp2_i2c2_default: blsp2-i2c2-default {
@@ -1247,7 +1247,7 @@ blsp2_i2c2_sleep: blsp2-i2c2-sleep {
 				pins = "gpio6", "gpio7";
 				function = "blsp_i2c8";
 				drive-strength = <2>;
-				bias-pull-up;
+				bias-disable;
 			};
 
 			blsp2_i2c3_default: blsp2-i2c3-default {
@@ -1261,7 +1261,7 @@ blsp2_i2c3_sleep: blsp2-i2c3-sleep {
 				pins = "gpio51", "gpio52";
 				function = "blsp_i2c9";
 				drive-strength = <2>;
-				bias-pull-up;
+				bias-disable;
 			};
 
 			blsp2_i2c4_default: blsp2-i2c4-default {
@@ -1275,7 +1275,7 @@ blsp2_i2c4_sleep: blsp2-i2c4-sleep {
 				pins = "gpio67", "gpio68";
 				function = "blsp_i2c10";
 				drive-strength = <2>;
-				bias-pull-up;
+				bias-disable;
 			};
 
 			blsp2_i2c5_default: blsp2-i2c5-default {
@@ -1289,7 +1289,7 @@ blsp2_i2c5_sleep: blsp2-i2c5-sleep {
 				pins = "gpio60", "gpio61";
 				function = "blsp_i2c11";
 				drive-strength = <2>;
-				bias-pull-up;
+				bias-disable;
 			};
 
 			blsp2_i2c6_default: blsp2-i2c6-default {
@@ -1303,7 +1303,7 @@ blsp2_i2c6_sleep: blsp2-i2c6-sleep {
 				pins = "gpio83", "gpio84";
 				function = "blsp_i2c12";
 				drive-strength = <2>;
-				bias-pull-up;
+				bias-disable;
 			};
 		};
 
-- 
2.53.0




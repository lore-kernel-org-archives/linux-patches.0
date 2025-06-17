Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81EBE2FA638;
	Tue, 17 Jun 2025 16:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178072; cv=none; b=OpBAiVBdmZuTZiEXJZ2NWolnUQA9AFN25fetOZ5FGoxsdczXps43ynppSfWOzVRtrfQvfC6/Ix3bwaCT9ZZKNvWxcH3cTjPyfujApa9xczhuAnCnGhm25Qoi4lGW5aCKq8Hi1TADw/v93XFVRHz5e/RXuJ8dYi/X1KxpahId1ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178072; c=relaxed/simple;
	bh=woz5wZRqZC3wQoZqf+9EjI106chsKnhyg4PHVRBgmxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j3NZTnDtKKX03aFnzM6T3dzjzUQR9Za75GkRuidhJqfFH5LA3tUEvz/TiwBf+SzYUZZnA25jVvpWONsUNENlHRaLZPyVx1pkvDJEHnWh9XovFZFxnPaRPtI6Dq3iiZtMLZiH3XG7IeOWXD7rUvgl4zNV+5lTi4CZkUY46kFpGQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F7Lh1ZhO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F7Lh1ZhO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E59BCC4CEE3;
	Tue, 17 Jun 2025 16:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178072;
	bh=woz5wZRqZC3wQoZqf+9EjI106chsKnhyg4PHVRBgmxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F7Lh1ZhOOxCPWOk5BqtAUoZqqrAhJsDeX4Y2IPwAUX89sZPka2+aLGgMscbBV49ZW
	 Y1vx/2VrmZelu8KdGtBTxbmU4JoGctmqn65Ez6zuiR7rqYyMi3rtdkRB3+arY7U7cv
	 pciBEmNuZiIYL9e6Po3xQnOe15TEu+PVc1O8FTkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 382/780] arm64: dts: qcom: x1e001de-devkit: Describe USB retimers resets pin configs
Date: Tue, 17 Jun 2025 17:21:30 +0200
Message-ID: <20250617152507.016806540@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

From: Abel Vesa <abel.vesa@linaro.org>

[ Upstream commit f76fdcd2550991c854a698a9f881b1579455fc0a ]

Currently, on the X Elite Devkit, the pin configuration of the reset
gpios for all three PS8830 USB retimers are left configured by the
bootloader.

Fix that by describing their pin configuration.

Fixes: 019e1ee32fec ("arm64: dts: qcom: x1e001de-devkit: Enable external DP support")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20250422-x1e001de-devkit-dts-fix-retimer-gpios-v2-1-0129c4f2b6d7@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/x1e001de-devkit.dts | 32 ++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/x1e001de-devkit.dts b/arch/arm64/boot/dts/qcom/x1e001de-devkit.dts
index f5063a0df9fbf..8f4482ade0f98 100644
--- a/arch/arm64/boot/dts/qcom/x1e001de-devkit.dts
+++ b/arch/arm64/boot/dts/qcom/x1e001de-devkit.dts
@@ -790,6 +790,9 @@
 
 		reset-gpios = <&tlmm 185 GPIO_ACTIVE_HIGH>;
 
+		pinctrl-0 = <&rtmr2_default>;
+		pinctrl-names = "default";
+
 		orientation-switch;
 		retimer-switch;
 
@@ -845,6 +848,9 @@
 
 		reset-gpios = <&pm8550_gpios 10 GPIO_ACTIVE_HIGH>;
 
+		pinctrl-0 = <&rtmr0_default>;
+		pinctrl-names = "default";
+
 		retimer-switch;
 		orientation-switch;
 
@@ -900,6 +906,9 @@
 
 		reset-gpios = <&tlmm 176 GPIO_ACTIVE_HIGH>;
 
+		pinctrl-0 = <&rtmr1_default>;
+		pinctrl-names = "default";
+
 		retimer-switch;
 		orientation-switch;
 
@@ -1018,6 +1027,15 @@
 };
 
 &pm8550_gpios {
+	rtmr0_default: rtmr0-reset-n-active-state {
+		pins = "gpio10";
+		function = "normal";
+		power-source = <1>; /* 1.8 V */
+		bias-disable;
+		input-disable;
+		output-enable;
+	};
+
 	usb0_3p3_reg_en: usb0-3p3-reg-en-state {
 		pins = "gpio11";
 		function = "normal";
@@ -1205,6 +1223,20 @@
 		};
 	};
 
+	rtmr1_default: rtmr1-reset-n-active-state {
+		pins = "gpio176";
+		function = "gpio";
+		drive-strength = <2>;
+		bias-disable;
+	};
+
+	rtmr2_default: rtmr2-reset-n-active-state {
+		pins = "gpio185";
+		function = "gpio";
+		drive-strength = <2>;
+		bias-disable;
+	};
+
 	rtmr1_1p15_reg_en: rtmr1-1p15-reg-en-state {
 		pins = "gpio188";
 		function = "gpio";
-- 
2.39.5




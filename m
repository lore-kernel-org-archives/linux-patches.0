Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ABA4200A6
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 18:58:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F245EC433C8;
	Fri, 21 Jul 2023 18:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689965921;
	bh=86dVskVF+/bSNt6LlVE6M1up3Ni+JO+m3+MbUsGPmd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jllY6YOLikxQ9cQ9obtdqRwqBvD3Vk4e6crJBO/h3lWUSpI6GQ13TJkrnRi0q+Zv4
	 miN0p8ez0dfXWYRGRFvgbzEXQsNAqRhvllgATMPxG8Dw7zyS+z3MjztdflFG+z9EN/
	 Yl2iYQzcxcucdo1LFGGNysDgkLRm70yegB2B/Vdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Stephan Gerhold <stephan@gerhold.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 133/532] arm64: dts: qcom: apq8016-sbc: Update modem and WiFi firmware path
Date: Fri, 21 Jul 2023 18:00:37 +0200
Message-ID: <20230721160621.680378860@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bjorn Andersson <bjorn.andersson@linaro.org>

[ Upstream commit 0f6b380d580cd081d5e385d349f55dfc52e3d68c ]

The firmware for the modem and WiFi subsystems platform specific and is
signed with a OEM specific key (or a test key). In order to support more
than a single device it is therefor not possible to rely on the default
path and stash these files directly in the firmware directory.

This has already been addressed for other platforms, but the APQ8016 SBC
(aka db410c) was never finished upstream.

Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Reviewed-by: Stephan Gerhold <stephan@gerhold.net>
Tested-by: Stephan Gerhold <stephan@gerhold.net>
Link: https://lore.kernel.org/r/20210531224453.783218-1-bjorn.andersson@linaro.org
Stable-dep-of: e27654df20d7 ("arm64: dts: qcom: apq8016-sbc: Fix regulator constraints")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/apq8016-sbc.dtsi | 12 ++++++++++++
 arch/arm64/boot/dts/qcom/msm8916.dtsi     |  2 +-
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/apq8016-sbc.dtsi b/arch/arm64/boot/dts/qcom/apq8016-sbc.dtsi
index f8d8f3e3664ec..351c68d29afb7 100644
--- a/arch/arm64/boot/dts/qcom/apq8016-sbc.dtsi
+++ b/arch/arm64/boot/dts/qcom/apq8016-sbc.dtsi
@@ -305,6 +305,12 @@ &mdss {
 	status = "okay";
 };
 
+&mpss {
+	status = "okay";
+
+	firmware-name = "qcom/msm8916/mba.mbn", "qcom/msm8916/modem.mbn";
+};
+
 &pm8916_resin {
 	status = "okay";
 	linux,code = <KEY_VOLUMEDOWN>;
@@ -312,6 +318,8 @@ &pm8916_resin {
 
 &pronto {
 	status = "okay";
+
+	firmware-name = "qcom/msm8916/wcnss.mbn";
 };
 
 &sdhc_1 {
@@ -394,6 +402,10 @@ &wcd_codec {
 	qcom,mbhc-vthreshold-high = <75 150 237 450 500>;
 };
 
+&wcnss_ctrl {
+	firmware-name = "qcom/msm8916/WCNSS_qcom_wlan_nv.bin";
+};
+
 /* Enable CoreSight */
 &cti0 { status = "okay"; };
 &cti1 { status = "okay"; };
diff --git a/arch/arm64/boot/dts/qcom/msm8916.dtsi b/arch/arm64/boot/dts/qcom/msm8916.dtsi
index aa79e08075ea7..fcc9f757c9e14 100644
--- a/arch/arm64/boot/dts/qcom/msm8916.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8916.dtsi
@@ -1771,7 +1771,7 @@ smd-edge {
 
 				label = "pronto";
 
-				wcnss {
+				wcnss_ctrl: wcnss {
 					compatible = "qcom,wcnss";
 					qcom,smd-channels = "WCNSS_CTRL";
 
-- 
2.39.2




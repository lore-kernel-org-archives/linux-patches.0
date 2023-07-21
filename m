Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C18A200A6
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 18:58:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAC9DC433C8;
	Fri, 21 Jul 2023 18:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689965924;
	bh=g09jdD3uqqiaqnZGTC8D+JDnB5lJ2625SBMyuC9SEeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hIXJ17WvnQTGwOXuBKdn7MrPO6MqmZpHPW1i4nTGOdJJy/rz7/c5f57V01cl0xLjf
	 YqBfshcbtchFrjDnY0WcHnje5bQsglHaUwvXcsAwdrXEMKDvolL6YpMN1gjda4y7cc
	 AeMAi7Myw+xyXuD7urOV26/ZKlVHNY12O7E1hEjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan@gerhold.net>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 134/532] arm64: dts: qcom: apq8016-sbc: Clarify firmware-names
Date: Fri, 21 Jul 2023 18:00:38 +0200
Message-ID: <20230721160621.732100519@linuxfoundation.org>
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

From: Stephan Gerhold <stephan@gerhold.net>

[ Upstream commit 2533786f46d074d67a4bca04c2d44d3825594415 ]

Commit 0f6b380d580c ("arm64: dts: qcom: apq8016-sbc: Update modem and WiFi
firmware path") added "firmware-name"s to the APQ8016 SBC (DB410c) device
tree to separate the (test key)-signed firmware from other devices.

However, the added names are a bit confusing. The "modem" firmware used by
DB410c is actually a simplified version for APQ8016 that lacks most of the
modem functionality (phone calls, SMS etc) that is available on MSM8916.
Placing it in "qcom/msm8916/modem.mbn" suggests that it supports all
functionality for MSM and not just the reduced functionality for APQ.

Request the firmware from "qcom/apq8016/modem.mbn" instead to clarify this.
Do the same for "wcnss.mbn" for consistency (although the WCNSS firmware
works just fine on MSM8916).

Finally, add a "_sbc" suffix to the WCNSS_qcom_wlan_nv.bin firmware file.
It seems like the nv.bin firmware is somewhat board specific and can
therefore vary a bit from device to device. This makes it more clear
which board it is intended to be used for.

Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20210922195853.95574-1-stephan@gerhold.net
Stable-dep-of: e27654df20d7 ("arm64: dts: qcom: apq8016-sbc: Fix regulator constraints")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/apq8016-sbc.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/apq8016-sbc.dtsi b/arch/arm64/boot/dts/qcom/apq8016-sbc.dtsi
index 351c68d29afb7..0e4a1f0040211 100644
--- a/arch/arm64/boot/dts/qcom/apq8016-sbc.dtsi
+++ b/arch/arm64/boot/dts/qcom/apq8016-sbc.dtsi
@@ -308,7 +308,7 @@ &mdss {
 &mpss {
 	status = "okay";
 
-	firmware-name = "qcom/msm8916/mba.mbn", "qcom/msm8916/modem.mbn";
+	firmware-name = "qcom/apq8016/mba.mbn", "qcom/apq8016/modem.mbn";
 };
 
 &pm8916_resin {
@@ -319,7 +319,7 @@ &pm8916_resin {
 &pronto {
 	status = "okay";
 
-	firmware-name = "qcom/msm8916/wcnss.mbn";
+	firmware-name = "qcom/apq8016/wcnss.mbn";
 };
 
 &sdhc_1 {
@@ -403,7 +403,7 @@ &wcd_codec {
 };
 
 &wcnss_ctrl {
-	firmware-name = "qcom/msm8916/WCNSS_qcom_wlan_nv.bin";
+	firmware-name = "qcom/apq8016/WCNSS_qcom_wlan_nv_sbc.bin";
 };
 
 /* Enable CoreSight */
-- 
2.39.2




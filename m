Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A8D98F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:07:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0F75C433C8;
	Sun, 16 Jul 2023 20:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538031;
	bh=KoJyIzYIMCfrneoOw4yugJqD326vfBByGStGse5TieQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lbPkUo+UwOnZLOc9GhZS3Y97Y9UXGS0VpXGjishtFHxrHpFL1VmDWgLSTCylgTLyr
	 PKfaFxhOv2T9NHPhtqIPMPgEx0xjSYthmom9RC7Sl86YCWnp7FFgGXyQU+AO58I9I/
	 jTrkTjCmjTierGcOvWi7cq7RDy1AVNqb8GzhIa6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Marijn Suijten <marijn.suijten@somainline.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 306/800] arm64: dts: qcom: msm8976: correct MMC unit address
Date: Sun, 16 Jul 2023 21:42:39 +0200
Message-ID: <20230716194956.184281824@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 80284797a4cb8ceae71e3c403bafc6648263a060 ]

Match unit-address to reg entry to fix dtbs W=1 warnings:

  Warning (simple_bus_reg): /soc@0/mmc@7824000: simple-bus unit address format error, expected "7824900"
  Warning (simple_bus_reg): /soc@0/mmc@7864000: simple-bus unit address format error, expected "7864900"
  Warning (simple_bus_reg): /soc@0/mmc@7a24000: simple-bus unit address format error, expected "7a24900"

Fixes: 0484d3ce0902 ("arm64: dts: qcom: Add DTS for MSM8976 and MSM8956 SoCs")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Marijn Suijten <marijn.suijten@somainline.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230419211856.79332-7-krzysztof.kozlowski@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8976.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8976.dtsi b/arch/arm64/boot/dts/qcom/msm8976.dtsi
index f47fb8ea71e20..753b9a2105edd 100644
--- a/arch/arm64/boot/dts/qcom/msm8976.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8976.dtsi
@@ -822,7 +822,7 @@ spmi_bus: spmi@200f000 {
 			#interrupt-cells = <4>;
 		};
 
-		sdhc_1: mmc@7824000 {
+		sdhc_1: mmc@7824900 {
 			compatible = "qcom,msm8976-sdhci", "qcom,sdhci-msm-v4";
 			reg = <0x07824900 0x500>, <0x07824000 0x800>;
 			reg-names = "hc", "core";
@@ -838,7 +838,7 @@ sdhc_1: mmc@7824000 {
 			status = "disabled";
 		};
 
-		sdhc_2: mmc@7864000 {
+		sdhc_2: mmc@7864900 {
 			compatible = "qcom,msm8976-sdhci", "qcom,sdhci-msm-v4";
 			reg = <0x07864900 0x11c>, <0x07864000 0x800>;
 			reg-names = "hc", "core";
@@ -957,7 +957,7 @@ otg: usb@78db000 {
 			#reset-cells = <1>;
 		};
 
-		sdhc_3: mmc@7a24000 {
+		sdhc_3: mmc@7a24900 {
 			compatible = "qcom,msm8976-sdhci", "qcom,sdhci-msm-v4";
 			reg = <0x07a24900 0x11c>, <0x07a24000 0x800>;
 			reg-names = "hc", "core";
-- 
2.39.2




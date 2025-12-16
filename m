Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 235CC30EF80;
	Tue, 16 Dec 2025 11:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885435; cv=none; b=KiIph6p/pXJMA38pzOu/PtuSB2zlqVP9CdP27HF5MgvLCp7QQFB3wVV1CJSFsPMj5wnQ2cK+KRKJXinyS1rDU3x1m2w+WTgLsHeSXNI0HNpxZgQuYKdIHouV5O6OuGsTisoMgYRuyKCC69S/7DzuAWH6fbaLu30A21Bs9EnpR/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885435; c=relaxed/simple;
	bh=Y6QFd4tLPlXp5WkhZw48OPr127qsIIXR0NYI7ML1u6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C9B9e3JnphENu4WhA0vifTEmhbRpMr/xQWdF3QPdCisSFBYa+hUbGGkCsIieR8NI1m6XdvFOS4ObuQpIlG4naGYTs7HDvBQkKAVbCFoAexlwXrsuNnDjve277iQxFVG5bTWhM2ZSgWGgsUU8hyopsVglwfrHwl6SAcV8vn+hJLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KmIxQBLf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KmIxQBLf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6570BC4CEF1;
	Tue, 16 Dec 2025 11:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885435;
	bh=Y6QFd4tLPlXp5WkhZw48OPr127qsIIXR0NYI7ML1u6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KmIxQBLf9iENPH/Jll099AHN6lCWCTfhYJyrq8IB+6qDueQ5r33E2iBETgGsc4E2g
	 BHPFxq/v4BudgShtL2UVQyExoTZXx6YKC/G0iHX88O9l04NLBo+tJ2nukq68qMoRqO
	 HInao3qVjqneQbyNszdjynwS7vI0GL1sphzuQh9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 105/507] arm64: dts: qcom: qcm2290: Add CCI node
Date: Tue, 16 Dec 2025 12:09:06 +0100
Message-ID: <20251216111349.341593264@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Loic Poulain <loic.poulain@oss.qualcomm.com>

[ Upstream commit e645096d1f6dadcead09c722a3fbc6c44a45fece ]

Add Camera Control Interface (CCI), supporting two I2C masters.

Signed-off-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250911212102.470886-2-loic.poulain@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: 67445dc8a806 ("arm64: dts: qcom: qcm2290: Fix camss register prop ordering")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/qcm2290.dtsi | 50 +++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/qcm2290.dtsi b/arch/arm64/boot/dts/qcom/qcm2290.dtsi
index 6b7070dad3df9..4613713124f77 100644
--- a/arch/arm64/boot/dts/qcom/qcm2290.dtsi
+++ b/arch/arm64/boot/dts/qcom/qcm2290.dtsi
@@ -565,6 +565,20 @@ qup_uart4_default: qup-uart4-default-state {
 				bias-disable;
 			};
 
+			cci0_default: cci0-default-state {
+				pins = "gpio22", "gpio23";
+				function = "cci_i2c";
+				drive-strength = <2>;
+				bias-disable;
+			};
+
+			cci1_default: cci1-default-state {
+				pins = "gpio29", "gpio30";
+				function = "cci_i2c";
+				drive-strength = <2>;
+				bias-disable;
+			};
+
 			sdc1_state_on: sdc1-on-state {
 				clk-pins {
 					pins = "sdc1_clk";
@@ -1629,6 +1643,42 @@ adreno_smmu: iommu@59a0000 {
 			#iommu-cells = <2>;
 		};
 
+		cci: cci@5c1b000 {
+			compatible = "qcom,qcm2290-cci", "qcom,msm8996-cci";
+			reg = <0x0 0x5c1b000 0x0 0x1000>;
+
+			interrupts = <GIC_SPI 206 IRQ_TYPE_EDGE_RISING>;
+
+			clocks = <&gcc GCC_CAMSS_TOP_AHB_CLK>, <&gcc GCC_CAMSS_CCI_0_CLK>;
+			clock-names = "ahb", "cci";
+			assigned-clocks = <&gcc GCC_CAMSS_CCI_0_CLK>;
+			assigned-clock-rates = <37500000>;
+
+			power-domains = <&gcc GCC_CAMSS_TOP_GDSC>;
+
+			pinctrl-0 = <&cci0_default &cci1_default>;
+			pinctrl-names = "default";
+
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			status = "disabled";
+
+			cci_i2c0: i2c-bus@0 {
+				reg = <0>;
+				clock-frequency = <400000>;
+				#address-cells = <1>;
+				#size-cells = <0>;
+			};
+
+			cci_i2c1: i2c-bus@1 {
+				reg = <1>;
+				clock-frequency = <400000>;
+				#address-cells = <1>;
+				#size-cells = <0>;
+			};
+		};
+
 		camss: camss@5c6e000 {
 			compatible = "qcom,qcm2290-camss";
 
-- 
2.51.0




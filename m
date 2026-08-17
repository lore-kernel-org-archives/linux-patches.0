Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C99B32ED40;
	Mon, 17 Aug 2026 13:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786973962; cv=none; b=Gz5LODspUSh3+XLZNo++mEMr1lWY5DDDmNKlVde79dK6wfyKdYZj5+PlprVqhwCClS7e9hbQQBxg852cbpCCeNAzmb6rtg4yJP6zP8tASwhoIuLjGpAUm4DbvNvCTykRZuqRuwL43TDncbhUvb83yOvMD68sfSt5g6m0wTRMoU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786973962; c=relaxed/simple;
	bh=ISsmNXkmcZftY+ptIIINpYp5WPSjZgWwN+yE+KVM3jk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=akupCrWUmU4XklIxfPsIphlGwe9yHu1xT4O1rlodhvDOOS8RKxAX6dDE0BRak5e8C9xjjva5grB9yNp9PCIdn+o/ahJf7CsLRezuUJTgkuCmQ2//pH285SBRggPJvKlfHUEh6gEUV0JRv89X/aFW8FPLpEjlueoNIFzvOSaTkpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Up+w0Gqb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Up+w0Gqb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 720721F000E9;
	Mon, 17 Aug 2026 13:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786973961;
	bh=hRYcScI8yaWRGQsXbt4gUfDaS4fzy80QlV0FXcVsEto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Up+w0Gqb75xTYoeXP4AgCeA+4kNvD/OSLjFJqy1EUYKht2onh9q7vQVr6Ujj87DWC
	 dEFoQPZffoHBK1Z9FSohkovmwyhI1dHjRpHVT2ViFMpcZ7vYoM6VVnmJzh1tJWjRU9
	 jwWVGZ2qWx6LcCprbWkhvCfyFASrrvM3GRsR5LoE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 008/271] arm64: dts: qcom: glymur: fix QUP serial engine IRQs
Date: Mon, 17 Aug 2026 15:28:53 +0200
Message-ID: <20260817132537.096817722@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>

[ Upstream commit a74a98f956ef8e075f28d58507bc5dad7f937fb4 ]

The Geni serial-engine interrupts from QUP wrapper 0 all fall in ESPI
INTIDs space. While some of the i2c instances has gotten their
interrupt specifiers corrected, even the other functions on the same
serial-engines are wrong.

Ensure that all the serial engine interrupts for QUP wrapper 0 matches
the datasheet.

Assisted-by: Codex:GPT-5.5
Fixes: 41b6e8db400c ("arm64: dts: qcom: Introduce Glymur base dtsi")
Signed-off-by: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260611-glymur-geni-irqs-v1-1-269428faeb6d@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/glymur.dtsi | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/glymur.dtsi b/arch/arm64/boot/dts/qcom/glymur.dtsi
index 468614d101c02..25df2bd06735d 100644
--- a/arch/arm64/boot/dts/qcom/glymur.dtsi
+++ b/arch/arm64/boot/dts/qcom/glymur.dtsi
@@ -1843,7 +1843,7 @@ &config_noc SLAVE_QUP_0 QCOM_ICC_TAG_ALWAYS>,
 			spi0: spi@b80000 {
 				compatible = "qcom,geni-spi";
 				reg = <0x0 0x00b80000 0x0 0x4000>;
-				interrupts = <GIC_SPI 1052 IRQ_TYPE_LEVEL_HIGH>;
+				interrupts = <GIC_ESPI 92 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&gcc GCC_QUPV3_WRAP0_S0_CLK>;
 				clock-names = "se";
 				interconnects = <&clk_virt MASTER_QUP_CORE_0 QCOM_ICC_TAG_ALWAYS
@@ -1870,7 +1870,7 @@ &config_noc SLAVE_QUP_0 QCOM_ICC_TAG_ALWAYS>,
 			i2c1: i2c@b84000 {
 				compatible = "qcom,geni-i2c";
 				reg = <0x0 0x00b84000 0x0 0x4000>;
-				interrupts = <GIC_SPI 1053 IRQ_TYPE_LEVEL_HIGH>;
+				interrupts = <GIC_ESPI 93 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&gcc GCC_QUPV3_WRAP0_S1_CLK>;
 				clock-names = "se";
 				interconnects = <&clk_virt MASTER_QUP_CORE_0 QCOM_ICC_TAG_ALWAYS
@@ -1897,7 +1897,7 @@ &config_noc SLAVE_QUP_0 QCOM_ICC_TAG_ALWAYS>,
 			spi1: spi@b84000 {
 				compatible = "qcom,geni-spi";
 				reg = <0x0 0x00b84000 0x0 0x4000>;
-				interrupts = <GIC_SPI 1053 IRQ_TYPE_LEVEL_HIGH>;
+				interrupts = <GIC_ESPI 93 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&gcc GCC_QUPV3_WRAP0_S1_CLK>;
 				clock-names = "se";
 				interconnects = <&clk_virt MASTER_QUP_CORE_0 QCOM_ICC_TAG_ALWAYS
@@ -1924,7 +1924,7 @@ &config_noc SLAVE_QUP_0 QCOM_ICC_TAG_ALWAYS>,
 			i2c2: i2c@b88000 {
 				compatible = "qcom,geni-i2c";
 				reg = <0x0 0x00b88000 0x0 0x4000>;
-				interrupts = <GIC_SPI 1054 IRQ_TYPE_LEVEL_HIGH>;
+				interrupts = <GIC_ESPI 94 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&gcc GCC_QUPV3_WRAP0_S2_CLK>;
 				clock-names = "se";
 				interconnects = <&clk_virt MASTER_QUP_CORE_0 QCOM_ICC_TAG_ALWAYS
@@ -1951,7 +1951,7 @@ &config_noc SLAVE_QUP_0 QCOM_ICC_TAG_ALWAYS>,
 			spi2: spi@b88000 {
 				compatible = "qcom,geni-spi";
 				reg = <0x0 0x00b88000 0x0 0x4000>;
-				interrupts = <GIC_SPI 1054 IRQ_TYPE_LEVEL_HIGH>;
+				interrupts = <GIC_ESPI 94 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&gcc GCC_QUPV3_WRAP0_S2_CLK>;
 				clock-names = "se";
 				interconnects = <&clk_virt MASTER_QUP_CORE_0 QCOM_ICC_TAG_ALWAYS
@@ -1978,7 +1978,7 @@ &config_noc SLAVE_QUP_0 QCOM_ICC_TAG_ALWAYS>,
 			uart2: serial@b88000 {
 				compatible = "qcom,geni-uart";
 				reg = <0x0 0x00b88000 0x0 0x4000>;
-				interrupts = <GIC_SPI 1054 IRQ_TYPE_LEVEL_HIGH>;
+				interrupts = <GIC_ESPI 94 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&gcc GCC_QUPV3_WRAP0_S2_CLK>;
 				clock-names = "se";
 				interconnects = <&clk_virt MASTER_QUP_CORE_0 QCOM_ICC_TAG_ALWAYS
@@ -2023,7 +2023,7 @@ &config_noc SLAVE_QUP_0 QCOM_ICC_TAG_ALWAYS>,
 			spi3: spi@b8c000 {
 				compatible = "qcom,geni-spi";
 				reg = <0x0 0x00b8c000 0x0 0x4000>;
-				interrupts = <GIC_SPI 1055 IRQ_TYPE_LEVEL_HIGH>;
+				interrupts = <GIC_ESPI 95 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&gcc GCC_QUPV3_WRAP0_S3_CLK>;
 				clock-names = "se";
 				interconnects = <&clk_virt MASTER_QUP_CORE_0 QCOM_ICC_TAG_ALWAYS
@@ -2077,7 +2077,7 @@ &config_noc SLAVE_QUP_0 QCOM_ICC_TAG_ALWAYS>,
 			spi4: spi@b90000 {
 				compatible = "qcom,geni-spi";
 				reg = <0x0 0x00b90000 0x0 0x4000>;
-				interrupts = <GIC_SPI 1056 IRQ_TYPE_LEVEL_HIGH>;
+				interrupts = <GIC_ESPI 96 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&gcc GCC_QUPV3_WRAP0_S4_CLK>;
 				clock-names = "se";
 				interconnects = <&clk_virt MASTER_QUP_CORE_0 QCOM_ICC_TAG_ALWAYS
@@ -2131,7 +2131,7 @@ &config_noc SLAVE_QUP_0 QCOM_ICC_TAG_ALWAYS>,
 			spi5: spi@b94000 {
 				compatible = "qcom,geni-spi";
 				reg = <0x0 0x00b94000 0x0 0x4000>;
-				interrupts = <GIC_SPI 1057 IRQ_TYPE_LEVEL_HIGH>;
+				interrupts = <GIC_ESPI 97 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&gcc GCC_QUPV3_WRAP0_S5_CLK>;
 				clock-names = "se";
 				interconnects = <&clk_virt MASTER_QUP_CORE_0 QCOM_ICC_TAG_ALWAYS
@@ -2158,7 +2158,7 @@ &config_noc SLAVE_QUP_0 QCOM_ICC_TAG_ALWAYS>,
 			i2c6: i2c@b98000 {
 				compatible = "qcom,geni-i2c";
 				reg = <0x0 0x00b98000 0x0 0x4000>;
-				interrupts = <GIC_SPI 1058 IRQ_TYPE_LEVEL_HIGH>;
+				interrupts = <GIC_ESPI 98 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&gcc GCC_QUPV3_WRAP0_S6_CLK>;
 				clock-names = "se";
 				interconnects = <&clk_virt MASTER_QUP_CORE_0 QCOM_ICC_TAG_ALWAYS
@@ -2185,7 +2185,7 @@ &config_noc SLAVE_QUP_0 QCOM_ICC_TAG_ALWAYS>,
 			spi6: spi@b98000 {
 				compatible = "qcom,geni-spi";
 				reg = <0x0 0x00b98000 0x0 0x4000>;
-				interrupts = <GIC_SPI 1058 IRQ_TYPE_LEVEL_HIGH>;
+				interrupts = <GIC_ESPI 98 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&gcc GCC_QUPV3_WRAP0_S6_CLK>;
 				clock-names = "se";
 				interconnects = <&clk_virt MASTER_QUP_CORE_0 QCOM_ICC_TAG_ALWAYS
@@ -2212,7 +2212,7 @@ &config_noc SLAVE_QUP_0 QCOM_ICC_TAG_ALWAYS>,
 			i2c7: i2c@b9c000 {
 				compatible = "qcom,geni-i2c";
 				reg = <0x0 0x00b9c000 0x0 0x4000>;
-				interrupts = <GIC_SPI 1059 IRQ_TYPE_LEVEL_HIGH>;
+				interrupts = <GIC_ESPI 99 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&gcc GCC_QUPV3_WRAP0_S7_CLK>;
 				clock-names = "se";
 				interconnects = <&clk_virt MASTER_QUP_CORE_0 QCOM_ICC_TAG_ALWAYS
@@ -2239,7 +2239,7 @@ &config_noc SLAVE_QUP_0 QCOM_ICC_TAG_ALWAYS>,
 			spi7: spi@b9c000 {
 				compatible = "qcom,geni-spi";
 				reg = <0x0 0x00b9c000 0x0 0x4000>;
-				interrupts = <GIC_SPI 1059 IRQ_TYPE_LEVEL_HIGH>;
+				interrupts = <GIC_ESPI 99 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&gcc GCC_QUPV3_WRAP0_S7_CLK>;
 				clock-names = "se";
 				interconnects = <&clk_virt MASTER_QUP_CORE_0 QCOM_ICC_TAG_ALWAYS
-- 
2.53.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60D972D8787;
	Tue,  8 Jul 2025 16:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992295; cv=none; b=DywhLi3DCxn6N+ab2qZvbWMCbDfIcwQVHRSuT93BpZIsVqHYrhMC4ocdi1IJ7OXMc7miwYR1iSIskjgPJCP2JUay6iY5BOt9P36VaGvix/ztUEQK0sx6Ch6U2XgfuabF+SlrBuNx6UlE2wuU/XJuDaltr8mukdlYQ1EYZtcz/lM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992295; c=relaxed/simple;
	bh=mxLBjJG/k55QHHXsV5UjIMSHA3MtnUPovqYsKG58L/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PIgJK69vIsv4P8CRpp5BHbT9kdaqZWx0vgn1WpR5nEpxXP3b+CZZeE32ZQdtM3VYeja7ztlGKZlUhwjOaZIfiKaP+nKQTFNE/2kpn77rbDqHJmhIaVBCvfw6d2lK7isQAEUH6s2sBVeMIe8hG79iAD0bmcOmXjRgrvG/E7McVGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J6+MHHT+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J6+MHHT+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6D9AC4CEED;
	Tue,  8 Jul 2025 16:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992295;
	bh=mxLBjJG/k55QHHXsV5UjIMSHA3MtnUPovqYsKG58L/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J6+MHHT+cZ6Rgt4Gr2QQEhSvfHRYvP+XbvOnKa8lnEhnIQTW3Zn1tQoffAQH9KUML
	 VUY/m0NpnWLNzPrQV9d8/f+GtAbwt8epkI+IIklvuqtjqe6rGRlag2ZZweTUERb/v8
	 bfeJChOwWEbX1i0bXMfck0de/YVM523dcEfThdDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 042/132] arm64: dts: qcom: sm8550: add UART14 nodes
Date: Tue,  8 Jul 2025 18:22:33 +0200
Message-ID: <20250708162231.909701628@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162230.765762963@linuxfoundation.org>
References: <20250708162230.765762963@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neil Armstrong <neil.armstrong@linaro.org>

[ Upstream commit 75cac7090298978c12c59dbca377d957f6f8a8bb ]

Add the Geni High Speed UART QUP instance 2 element 6
node and associated default pinctrl.

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20230911-topic-sm8550-upstream-bt-v4-1-a5a428c77418@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: 5ff1fbb30597 ("platform/x86: think-lmi: Fix class device unregistration")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8550.dtsi | 30 ++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sm8550.dtsi b/arch/arm64/boot/dts/qcom/sm8550.dtsi
index c14c6f8583d54..2f0f1c2ab7391 100644
--- a/arch/arm64/boot/dts/qcom/sm8550.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8550.dtsi
@@ -1064,6 +1064,20 @@ spi13: spi@894000 {
 				status = "disabled";
 			};
 
+			uart14: serial@898000 {
+				compatible = "qcom,geni-uart";
+				reg = <0 0x898000 0 0x4000>;
+				clock-names = "se";
+				clocks = <&gcc GCC_QUPV3_WRAP2_S6_CLK>;
+				pinctrl-names = "default";
+				pinctrl-0 = <&qup_uart14_default>, <&qup_uart14_cts_rts>;
+				interrupts = <GIC_SPI 461 IRQ_TYPE_LEVEL_HIGH>;
+				interconnects = <&clk_virt MASTER_QUP_CORE_2 0 &clk_virt SLAVE_QUP_CORE_2 0>,
+						<&gem_noc MASTER_APPSS_PROC 0 &config_noc SLAVE_QUP_2 0>;
+				interconnect-names = "qup-core", "qup-config";
+				status = "disabled";
+			};
+
 			i2c15: i2c@89c000 {
 				compatible = "qcom,geni-i2c";
 				reg = <0 0x0089c000 0 0x4000>;
@@ -3640,6 +3654,22 @@ qup_uart7_default: qup-uart7-default-state {
 				bias-disable;
 			};
 
+			qup_uart14_default: qup-uart14-default-state {
+				/* TX, RX */
+				pins = "gpio78", "gpio79";
+				function = "qup2_se6";
+				drive-strength = <2>;
+				bias-pull-up;
+			};
+
+			qup_uart14_cts_rts: qup-uart14-cts-rts-state {
+				/* CTS, RTS */
+				pins = "gpio76", "gpio77";
+				function = "qup2_se6";
+				drive-strength = <2>;
+				bias-pull-down;
+			};
+
 			sdc2_sleep: sdc2-sleep-state {
 				clk-pins {
 					pins = "sdc2_clk";
-- 
2.39.5




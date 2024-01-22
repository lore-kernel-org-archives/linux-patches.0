Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 772255FEE3;
	Tue, 23 Jan 2024 01:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974659; cv=none; b=dz9GYDMek/oMlz2F60KePJ8ysiqKtXwUfFysPGAfWrj7UsRpkzCB8D3t992YVgM5xrhDKkWMI9CzRFln70e1ov0HjbqQ8yz4cokZ2KyDcfy90lEq+2KJba2d7xwZT5usM6FslqOrMdqgIyVrN+SB2v2TLdbG8Iet/RCkF3olPAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974659; c=relaxed/simple;
	bh=E1gdM4A27ZhTx9V+clqBdN0h77vB6zAc0o1niM4r2dI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XUJqymFVXJ9XdDLPDdkWEXqEdZo+DlC/0DuseBM/3OWAu33qb8jZwPym94tABVM7rkeoKeyZPmUSwDBLM08qU1tqBpW6WOMGnnBVfG4c+AwQYQEvBcZqHbNs77onrdUCGmQVMiADL5eKuK+lFnY6Gokb1PsqMi8t4uGhCYgs/hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wk/ABxux; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wk/ABxux"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 214AAC43394;
	Tue, 23 Jan 2024 01:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974659;
	bh=E1gdM4A27ZhTx9V+clqBdN0h77vB6zAc0o1niM4r2dI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wk/ABxuxDBe94bwwsf2N0X+dhgfNw9iEsQHHqDRyxG6/WCO4Sbl34Sh1j5IUw3Uv3
	 UAbGiaLS8uFMzck8IRqWqUdU07jL16ikd3eUC3x8rmsrWj6RPqh9/SBIwMukrFAtyR
	 65MAHp+3RIVKJzNRZIG7ZGq59Hitg1zZ0l9AbGqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 111/583] arm64: dts: qcom: sc7280: Mark some nodes as reserved
Date: Mon, 22 Jan 2024 15:52:42 -0800
Message-ID: <20240122235815.562090986@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Luca Weiss <luca.weiss@fairphone.com>

[ Upstream commit 6da24ba932082bae110feb917a64bb54637fa7c0 ]

With the standard Qualcomm TrustZone setup, components such as lpasscc,
pdc_reset and watchdog shouldn't be touched by Linux. Mark them with
the status 'reserved' and reenable them in the chrome-common dtsi.

Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Link: https://lore.kernel.org/r/20230919-fp5-initial-v2-1-14bb7cedadf5@fairphone.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: 6897fac411db ("arm64: dts: qcom: sc7280: Make watchdog bark interrupt edge triggered")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/qcom/sc7280-chrome-common.dtsi   | 24 +++++++++++++++++++
 arch/arm64/boot/dts/qcom/sc7280.dtsi          |  8 ++++++-
 2 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7280-chrome-common.dtsi b/arch/arm64/boot/dts/qcom/sc7280-chrome-common.dtsi
index 2e1cd219fc18..5d462ae14ba1 100644
--- a/arch/arm64/boot/dts/qcom/sc7280-chrome-common.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280-chrome-common.dtsi
@@ -46,6 +46,26 @@ wpss_mem: memory@9ae00000 {
 	};
 };
 
+&lpass_aon {
+	status = "okay";
+};
+
+&lpass_core {
+	status = "okay";
+};
+
+&lpass_hm {
+	status = "okay";
+};
+
+&lpasscc {
+	status = "okay";
+};
+
+&pdc_reset {
+	status = "okay";
+};
+
 /* The PMIC PON code isn't compatible w/ how Chrome EC/BIOS handle things. */
 &pmk8350_pon {
 	status = "disabled";
@@ -84,6 +104,10 @@ &scm {
 	dma-coherent;
 };
 
+&watchdog {
+	status = "okay";
+};
+
 &wifi {
 	status = "okay";
 
diff --git a/arch/arm64/boot/dts/qcom/sc7280.dtsi b/arch/arm64/boot/dts/qcom/sc7280.dtsi
index 91bb58c6b1a6..6f2a8f60856d 100644
--- a/arch/arm64/boot/dts/qcom/sc7280.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280.dtsi
@@ -2255,6 +2255,7 @@ lpasscc: lpasscc@3000000 {
 			clocks = <&gcc GCC_CFG_NOC_LPASS_CLK>;
 			clock-names = "iface";
 			#clock-cells = <1>;
+			status = "reserved"; /* Owned by ADSP firmware */
 		};
 
 		lpass_rx_macro: codec@3200000 {
@@ -2406,6 +2407,7 @@ lpass_aon: clock-controller@3380000 {
 			clock-names = "bi_tcxo", "bi_tcxo_ao", "iface";
 			#clock-cells = <1>;
 			#power-domain-cells = <1>;
+			status = "reserved"; /* Owned by ADSP firmware */
 		};
 
 		lpass_core: clock-controller@3900000 {
@@ -2416,6 +2418,7 @@ lpass_core: clock-controller@3900000 {
 			power-domains = <&lpass_hm LPASS_CORE_CC_LPASS_CORE_HM_GDSC>;
 			#clock-cells = <1>;
 			#power-domain-cells = <1>;
+			status = "reserved"; /* Owned by ADSP firmware */
 		};
 
 		lpass_cpu: audio@3987000 {
@@ -2486,6 +2489,7 @@ lpass_hm: clock-controller@3c00000 {
 			clock-names = "bi_tcxo";
 			#clock-cells = <1>;
 			#power-domain-cells = <1>;
+			status = "reserved"; /* Owned by ADSP firmware */
 		};
 
 		lpass_ag_noc: interconnect@3c40000 {
@@ -4199,6 +4203,7 @@ pdc_reset: reset-controller@b5e0000 {
 			compatible = "qcom,sc7280-pdc-global";
 			reg = <0 0x0b5e0000 0 0x20000>;
 			#reset-cells = <1>;
+			status = "reserved"; /* Owned by firmware */
 		};
 
 		tsens0: thermal-sensor@c263000 {
@@ -5195,11 +5200,12 @@ msi-controller@17a40000 {
 			};
 		};
 
-		watchdog@17c10000 {
+		watchdog: watchdog@17c10000 {
 			compatible = "qcom,apss-wdt-sc7280", "qcom,kpss-wdt";
 			reg = <0 0x17c10000 0 0x1000>;
 			clocks = <&sleep_clk>;
 			interrupts = <GIC_SPI 0 IRQ_TYPE_LEVEL_HIGH>;
+			status = "reserved"; /* Owned by Gunyah hyp */
 		};
 
 		timer@17c20000 {
-- 
2.43.0




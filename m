Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 933C45C80;
	Tue, 23 Jan 2024 00:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970673; cv=none; b=u2MVLZaLRexiIkjOs/zoVRh7xFGAvUoBs0pEUPA38Kki036kJqpOSMW6nGUcnZGuqPsh+a7pbRl+PcZRwKV6FoSQEgDzFpGupeKBeQTIj9w7agWjsp/7kAxtvyulUmleb8DulJz0cNFH38P/PA9hVMLBEK/ew0asoP29rF4sdMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970673; c=relaxed/simple;
	bh=kGoude2ICLDcZDHRvlSw8zRfIikPPuQrqtvKvvOGqgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oRO9sgKJ9sWX0UIbguGK2NAhYso+Xj62P6yxgdCOP0dJK4JCxy/V4kLQRGtgkgs/fvoXit/K29iFcrR0wO8PYrFgivlqLA0juU08anrMx7Xd51zZWAeheQRd4OrtzjoUIGiF5Q0P1S2eumcuXnQOWgranxiqcwArCT5srzEwZPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AYosZiU5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AYosZiU5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44552C433F1;
	Tue, 23 Jan 2024 00:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970673;
	bh=kGoude2ICLDcZDHRvlSw8zRfIikPPuQrqtvKvvOGqgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AYosZiU5cCC1YD8eHScrTWfk89B4JAFOIWU0YsUnG4lK1X0V7lnQZFO9/vJv6NWUg
	 QUHFHm2wuj9Wx2/wtNOVMb7F3cawIGJsnj0EY0otstQiRr2ZgTo4jINwUgDAAbvRTv
	 vEdpRqp5QD2q3BILORms8R41y1jCMhgDDyCsvCXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 086/417] arm64: dts: qcom: sc7280: Mark some nodes as reserved
Date: Mon, 22 Jan 2024 15:54:14 -0800
Message-ID: <20240122235754.677671275@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 25f31c81b2b7..efe6ea538ad2 100644
--- a/arch/arm64/boot/dts/qcom/sc7280-chrome-common.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280-chrome-common.dtsi
@@ -56,6 +56,26 @@ mba_mem: memory@9c700000 {
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
@@ -93,6 +113,10 @@ &rmtfs_mem {
 	reg = <0x0 0x9c900000 0x0 0x800000>;
 };
 
+&watchdog {
+	status = "okay";
+};
+
 &wifi {
 	status = "okay";
 
diff --git a/arch/arm64/boot/dts/qcom/sc7280.dtsi b/arch/arm64/boot/dts/qcom/sc7280.dtsi
index aea356c63b9a..4b8777eb96f1 100644
--- a/arch/arm64/boot/dts/qcom/sc7280.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280.dtsi
@@ -2187,6 +2187,7 @@ lpasscc: lpasscc@3000000 {
 			clocks = <&gcc GCC_CFG_NOC_LPASS_CLK>;
 			clock-names = "iface";
 			#clock-cells = <1>;
+			status = "reserved"; /* Owned by ADSP firmware */
 		};
 
 		lpass_rx_macro: codec@3200000 {
@@ -2339,6 +2340,7 @@ lpass_aon: clock-controller@3380000 {
 			clock-names = "bi_tcxo", "bi_tcxo_ao", "iface";
 			#clock-cells = <1>;
 			#power-domain-cells = <1>;
+			status = "reserved"; /* Owned by ADSP firmware */
 		};
 
 		lpass_core: clock-controller@3900000 {
@@ -2349,6 +2351,7 @@ lpass_core: clock-controller@3900000 {
 			power-domains = <&lpass_hm LPASS_CORE_CC_LPASS_CORE_HM_GDSC>;
 			#clock-cells = <1>;
 			#power-domain-cells = <1>;
+			status = "reserved"; /* Owned by ADSP firmware */
 		};
 
 		lpass_cpu: audio@3987000 {
@@ -2419,6 +2422,7 @@ lpass_hm: clock-controller@3c00000 {
 			clock-names = "bi_tcxo";
 			#clock-cells = <1>;
 			#power-domain-cells = <1>;
+			status = "reserved"; /* Owned by ADSP firmware */
 		};
 
 		lpass_ag_noc: interconnect@3c40000 {
@@ -4195,6 +4199,7 @@ pdc_reset: reset-controller@b5e0000 {
 			compatible = "qcom,sc7280-pdc-global";
 			reg = <0 0x0b5e0000 0 0x20000>;
 			#reset-cells = <1>;
+			status = "reserved"; /* Owned by firmware */
 		};
 
 		tsens0: thermal-sensor@c263000 {
@@ -5186,11 +5191,12 @@ gic-its@17a40000 {
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




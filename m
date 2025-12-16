Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2091436CE01;
	Tue, 16 Dec 2025 12:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887474; cv=none; b=uo4msJhKSkTue36PJaUN+Y9kFDJ34m1NwZunLst/39FDMNvYU377ijYh5FgQ3FGk7PAzi/x/f1dUzTOkJu2Iz0BHOnJQs67G8a0j+MKfeMbFuq4+KpJFYXPO6qg4ZdzQv8MwNFzR75Ol1DUto6GRFafsojoKMnf8eYDMhwqazes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887474; c=relaxed/simple;
	bh=BZCDqUl7s79htgmflD3dXikM50wBIQapQBQ+z8xZQgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n2gbK2x5Tla6ZWkF6YCfocazMcv3U7sqWmTWhlwNzTLtLKosgVF1ZOozno3ZwhJdGmSIT41j9G5uNWJjaZ+8yrZbdQFsq/QnAikcMWdPFA56d8fnfawn4fSiOaglWUubj+TyDSY8soALJRPwEFS9Adgqe+li7O9mnjC30IhELN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uOltJ0fV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uOltJ0fV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93C6EC4CEF1;
	Tue, 16 Dec 2025 12:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887474;
	bh=BZCDqUl7s79htgmflD3dXikM50wBIQapQBQ+z8xZQgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uOltJ0fV+b68X7X2vGUN+snuJ2IGeb1R2sdhaoBIIipT6s+/+upyk7shDaoukDhQH
	 4BfEFLOzwYbz7SmQUneOB1XtymgT9D0KYXAXW/datSPWFLcIINweAbbD3kxuIJSHyr
	 aGv8sKKSRo0ic7NKq/gthrWoURQQE0CgJXK3wk0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Manikanta Maddireddy <mmaddireddy@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 208/614] arm64: tegra: Add pinctrl definitions for pcie-ep nodes
Date: Tue, 16 Dec 2025 12:09:35 +0100
Message-ID: <20251216111408.911114461@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit 21ef26d0e71f053e809926d45b86b0afbc3686bb ]

When the PCIe controller is running in endpoint mode, the controller
initialization is triggered by a PERST# (PCIe reset) GPIO deassertion.

The driver has configured an IRQ to trigger when the PERST# GPIO changes
state. Without the pinctrl definition, we do not get an IRQ when PERST#
is deasserted, so the PCIe controller never gets initialized.

Add the missing definitions, so that the controller actually gets
initialized.

Fixes: ec142c44b026 ("arm64: tegra: Add P2U and PCIe controller nodes to Tegra234 DT")
Fixes: 0580286d0d22 ("arm64: tegra: Add Tegra234 PCIe C4 EP definition")
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Reviewed-by: Manikanta Maddireddy <mmaddireddy@nvidia.com>
[treding@nvidia.com: add blank lines to separate blocks]
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/nvidia/tegra234.dtsi | 61 ++++++++++++++++++++++++
 1 file changed, 61 insertions(+)

diff --git a/arch/arm64/boot/dts/nvidia/tegra234.dtsi b/arch/arm64/boot/dts/nvidia/tegra234.dtsi
index df034dbb82853..5657045c53d90 100644
--- a/arch/arm64/boot/dts/nvidia/tegra234.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra234.dtsi
@@ -9,6 +9,7 @@
 #include <dt-bindings/power/tegra234-powergate.h>
 #include <dt-bindings/reset/tegra234-reset.h>
 #include <dt-bindings/thermal/tegra234-bpmp-thermal.h>
+#include <dt-bindings/pinctrl/pinctrl-tegra.h>
 
 / {
 	compatible = "nvidia,tegra234";
@@ -127,6 +128,56 @@ gpio: gpio@2200000 {
 		pinmux: pinmux@2430000 {
 			compatible = "nvidia,tegra234-pinmux";
 			reg = <0x0 0x2430000 0x0 0x19100>;
+
+			pex_rst_c4_in_state: pinmux-pex-rst-c4-in {
+				pex_rst {
+					nvidia,pins = "pex_l4_rst_n_pl1";
+					nvidia,function = "rsvd1";
+					nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+					nvidia,tristate = <TEGRA_PIN_ENABLE>;
+					nvidia,enable-input = <TEGRA_PIN_ENABLE>;
+				};
+			};
+
+			pex_rst_c5_in_state: pinmux-pex-rst-c5-in {
+				pex_rst {
+					nvidia,pins = "pex_l5_rst_n_paf1";
+					nvidia,function = "rsvd1";
+					nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+					nvidia,tristate = <TEGRA_PIN_ENABLE>;
+					nvidia,enable-input = <TEGRA_PIN_ENABLE>;
+				};
+			};
+
+			pex_rst_c6_in_state: pinmux-pex-rst-c6-in {
+				pex_rst {
+					nvidia,pins = "pex_l6_rst_n_paf3";
+					nvidia,function = "rsvd1";
+					nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+					nvidia,tristate = <TEGRA_PIN_ENABLE>;
+					nvidia,enable-input = <TEGRA_PIN_ENABLE>;
+				};
+			};
+
+			pex_rst_c7_in_state: pinmux-pex-rst-c7-in {
+				pex_rst {
+					nvidia,pins = "pex_l7_rst_n_pag1";
+					nvidia,function = "rsvd1";
+					nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+					nvidia,tristate = <TEGRA_PIN_ENABLE>;
+					nvidia,enable-input = <TEGRA_PIN_ENABLE>;
+				};
+			};
+
+			pex_rst_c10_in_state: pinmux-pex-rst-c10-in {
+				pex_rst {
+					nvidia,pins = "pex_l10_rst_n_pag7";
+					nvidia,function = "rsvd1";
+					nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+					nvidia,tristate = <TEGRA_PIN_ENABLE>;
+					nvidia,enable-input = <TEGRA_PIN_ENABLE>;
+				};
+			};
 		};
 
 		gpcdma: dma-controller@2600000 {
@@ -4630,6 +4681,8 @@ pcie-ep@140e0000 {
 				 <&bpmp TEGRA234_RESET_PEX2_CORE_10>;
 			reset-names = "apb", "core";
 
+			pinctrl-names = "default";
+			pinctrl-0 = <&pex_rst_c10_in_state>;
 			interrupts = <GIC_SPI 360 IRQ_TYPE_LEVEL_HIGH>;	/* controller interrupt */
 			interrupt-names = "intr";
 
@@ -4881,6 +4934,8 @@ pcie-ep@14160000 {
 			       <&bpmp TEGRA234_RESET_PEX0_CORE_4>;
 			reset-names = "apb", "core";
 
+			pinctrl-names = "default";
+			pinctrl-0 = <&pex_rst_c4_in_state>;
 			interrupts = <GIC_SPI 51 IRQ_TYPE_LEVEL_HIGH>;  /* controller interrupt */
 			interrupt-names = "intr";
 			nvidia,bpmp = <&bpmp 4>;
@@ -5023,6 +5078,8 @@ pcie-ep@141a0000 {
 				 <&bpmp TEGRA234_RESET_PEX1_CORE_5>;
 			reset-names = "apb", "core";
 
+			pinctrl-names = "default";
+			pinctrl-0 = <&pex_rst_c5_in_state>;
 			interrupts = <GIC_SPI 53 IRQ_TYPE_LEVEL_HIGH>;	/* controller interrupt */
 			interrupt-names = "intr";
 
@@ -5115,6 +5172,8 @@ pcie-ep@141c0000 {
 				 <&bpmp TEGRA234_RESET_PEX1_CORE_6>;
 			reset-names = "apb", "core";
 
+			pinctrl-names = "default";
+			pinctrl-0 = <&pex_rst_c6_in_state>;
 			interrupts = <GIC_SPI 352 IRQ_TYPE_LEVEL_HIGH>;	/* controller interrupt */
 			interrupt-names = "intr";
 
@@ -5207,6 +5266,8 @@ pcie-ep@141e0000 {
 				 <&bpmp TEGRA234_RESET_PEX2_CORE_7>;
 			reset-names = "apb", "core";
 
+			pinctrl-names = "default";
+			pinctrl-0 = <&pex_rst_c7_in_state>;
 			interrupts = <GIC_SPI 354 IRQ_TYPE_LEVEL_HIGH>;	/* controller interrupt */
 			interrupt-names = "intr";
 
-- 
2.51.0




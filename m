Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015306;
	b=zQEoEa1YuE2nvhvpIXMKPzvWJjXErF9rnHkS2Xia2wLXbWGjEyqzQLINzJFG+EtJ6D9f
	 7KEUsV9I+dPgpN7jYF0o/JPDYX8b7XO4eiEKIKUWeGmJ/Qn2o//w7+8oMImGzZANQrCcK
	 Br4FgGZFRczo6dF4J64HIKt79U+ocSegUGOVcdnz/Bn55N4HPAQILHppWQButaMGDwLER
	 av+yvnMkaV5v2hX5a/kHaM5azkXjiG83hqSqg3GOiVbVdrgpOH5mnOKJen+ObrfRVdRNT
	 oy5FiG1E6EqZ/Ev0yke3GlVAYQbjSWTIaqdJ3Tp+Zb4oEMz6ynGQTUGYw3AlDBp7wJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015306;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Z2g/BhynljLTOJG/8D5hCQne4oabJOVNMZOV3exfXvI=;
	b=Ml+9YbUsavVt8+MscG39d6WvHDfPON4IMnZgtD2rHovfkbms8VWlh+S4ZexjZQ6pgGpo
	 z0H7JRCWqTRGSIA26l5JstzJSQJOPQhykLGDhwqdk667ugLzg0Pyh9JkVZHMNWov26rEz
	 x4O9M69ktj2cY/VeCMsEKNdCiEcqqoAoB8eaXNeh+kgxTwasY1VmXxsPiqtiq/+UDPCMi
	 nzbId21X1be11nvhmC2LG+kIiXQVtUhVBpEOYKOqQl7U2b77FOadX5XJwSxnttC3QAN5L
	 npBE7X6/CfOxwhVJrlGYfurx+9tbzcsT3H9MKLZR5tCjFPM0faLY+B4xV06933CBlbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VEyzYunT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 224F0606A32A;
	Wed, 18 Nov 2026 15:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VEyzYunT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75A8B1F000C7;
	Wed, 18 Nov 2026 15:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015306;
	bh=Z2g/BhynljLTOJG/8D5hCQne4oabJOVNMZOV3exfXvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VEyzYunTOSW4b9B5NYyuOHQdDkg3s5E2dhrgCgdVQ/31TQ0yYv3gkmsmgRVPPvTDm
	 YSMb3QATnzXCMAUjctPCQ0lqkew/39r2qqC9cZXmemiQqO32NvloJFsIRbv5m7oM3n
	 5sRKC0x0gAGzc7EI/lGygXwXs9OkbgENv47cvke0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Greg Ociepka <greg@ferrisoft.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0127/2651] arm64: dts: qcom: glymur: Add missing USB clock, power and bandwidth votes
Date: Wed, 18 Nov 2026 15:22:47 +0100
Message-ID: <20261118150252.431678254@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Ociepka <greg@ferrisoft.com>

[ Upstream commit 0f8d35f04a126fb17134728ec441a177a35babb5 ]

The four USB3 controller nodes on Glymur (usb_0, usb_1, usb_2, usb_mp)
are missing three property groups that Glymur's own usb_hs node at
a200000 already carries, and that Hamoa (x1e80100) carries on all five
of its USB controllers:

  - assigned-clocks / assigned-clock-rates
  - required-opps
  - interconnects / interconnect-names

Without required-opps the controllers place no performance state vote
on their power domain. Measured on an Asus Zenbook A16 (UX3607OA) with
a SuperSpeed device enumerated, CX aggregates to SVS while the
controllers run their master clock at 200 MHz:

  $ grep -E "^cx " /sys/kernel/debug/pm_genpd/pm_genpd_summary
  cx    on    128

  $ grep "usb30.*master_clk " /sys/kernel/debug/clk/clk_summary
  gcc_usb30_sec_master_clk   ...  200000000
  gcc_usb30_prim_master_clk  ...  200000000
  gcc_usb30_mp_master_clk    ...  200000000

128 is RPMH_REGULATOR_LEVEL_SVS; rpmhpd_opp_nom is 256. With this
patch applied the same measurement reads 256 while a controller is
active.

Without interconnects, dwc3_qcom_interconnect_init() silently does
nothing: of_icc_get() returns NULL rather than an error pointer for a
device without the property, so probe succeeds and icc_set_bw() on a
NULL path is a no-op. No USB-DDR bandwidth is ever requested.

Without assigned-clock-rates nothing programs the master clock RCG,
which keeps whatever the bootloader left behind. On this machine that
happens to be the correct 200 MHz, but ftbl_gcc_usb30_mp_master_clk_src
also allows 66.67 and 133.33 MHz, neither of which sustains SuperSpeed.

Add all three groups to the four nodes, mirroring usb_hs. The
interconnect paths follow the provider layout in
drivers/interconnect/qcom/glymur.c: usb_0/usb_1 sit on aggre4_noc,
usb_mp on aggre3_noc and usb_2 on aggre2_noc.

Fixes: 4eee57dd4df9 ("arm64: dts: qcom: glymur: Add USB related nodes")
Assisted-by: Claude:fable-5
Signed-off-by: Greg Ociepka <greg@ferrisoft.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Tested-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260812083522.774711-1-greg@ferrisoft.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/glymur.dtsi | 49 ++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/glymur.dtsi b/arch/arm64/boot/dts/qcom/glymur.dtsi
index f04058d2e0891..fbbc82550c442 100644
--- a/arch/arm64/boot/dts/qcom/glymur.dtsi
+++ b/arch/arm64/boot/dts/qcom/glymur.dtsi
@@ -4572,6 +4572,10 @@ usb_0: usb@a600000 {
 				      "noc_aggr_north",
 				      "noc_aggr_south";
 
+			assigned-clocks = <&gcc GCC_USB30_PRIM_MOCK_UTMI_CLK>,
+					  <&gcc GCC_USB30_PRIM_MASTER_CLK>;
+			assigned-clock-rates = <19200000>, <200000000>;
+
 			interrupts-extended = <&intc GIC_SPI 140 IRQ_TYPE_LEVEL_HIGH>,
 					      <&intc GIC_SPI 371 IRQ_TYPE_LEVEL_HIGH>,
 					      <&pdc 90 IRQ_TYPE_EDGE_BOTH>,
@@ -4584,9 +4588,18 @@ usb_0: usb@a600000 {
 					  "ss_phy_irq";
 
 			power-domains = <&gcc GCC_USB30_PRIM_GDSC>;
+			required-opps = <&rpmhpd_opp_nom>;
 			resets = <&gcc GCC_USB30_PRIM_BCR>;
 
 			iommus = <&apps_smmu 0x1420 0x0>;
+
+			interconnects = <&aggre4_noc MASTER_USB3_0 QCOM_ICC_TAG_ALWAYS
+					 &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
+					<&hsc_noc MASTER_APPSS_PROC QCOM_ICC_TAG_ACTIVE_ONLY
+					 &config_noc SLAVE_USB3_0 QCOM_ICC_TAG_ACTIVE_ONLY>;
+			interconnect-names = "usb-ddr",
+					     "apps-usb";
+
 			phys = <&usb_0_hsphy>,
 			       <&usb_0_qmpphy QMP_USB43DP_USB3_PHY>;
 			phy-names = "usb2-phy",
@@ -4647,6 +4660,10 @@ usb_1: usb@a800000 {
 				      "noc_aggr_north",
 				      "noc_aggr_south";
 
+			assigned-clocks = <&gcc GCC_USB30_SEC_MOCK_UTMI_CLK>,
+					  <&gcc GCC_USB30_SEC_MASTER_CLK>;
+			assigned-clock-rates = <19200000>, <200000000>;
+
 			interrupts-extended = <&intc GIC_SPI 875 IRQ_TYPE_LEVEL_HIGH>,
 					      <&intc GIC_SPI 369 IRQ_TYPE_LEVEL_HIGH>,
 					      <&pdc 88 IRQ_TYPE_EDGE_BOTH>,
@@ -4660,9 +4677,17 @@ usb_1: usb@a800000 {
 
 			resets = <&gcc GCC_USB30_SEC_BCR>;
 			power-domains = <&gcc GCC_USB30_SEC_GDSC>;
+			required-opps = <&rpmhpd_opp_nom>;
 
 			iommus = <&apps_smmu 0x1460 0x0>;
 
+			interconnects = <&aggre4_noc MASTER_USB3_1 QCOM_ICC_TAG_ALWAYS
+					 &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
+					<&hsc_noc MASTER_APPSS_PROC QCOM_ICC_TAG_ACTIVE_ONLY
+					 &config_noc SLAVE_USB3_1 QCOM_ICC_TAG_ACTIVE_ONLY>;
+			interconnect-names = "usb-ddr",
+					     "apps-usb";
+
 			phys = <&usb_1_hsphy>,
 			       <&usb_1_qmpphy QMP_USB43DP_USB3_PHY>;
 			phy-names = "usb2-phy",
@@ -4723,6 +4748,10 @@ usb_2: usb@a000000 {
 				      "noc_aggr_north",
 				      "noc_aggr_south";
 
+			assigned-clocks = <&gcc GCC_USB30_TERT_MOCK_UTMI_CLK>,
+					  <&gcc GCC_USB30_TERT_MASTER_CLK>;
+			assigned-clock-rates = <19200000>, <200000000>;
+
 			interrupts-extended = <&intc GIC_SPI 871 IRQ_TYPE_LEVEL_HIGH>,
 					      <&intc GIC_SPI 370 IRQ_TYPE_LEVEL_HIGH>,
 					      <&pdc 89 IRQ_TYPE_EDGE_BOTH>,
@@ -4736,9 +4765,17 @@ usb_2: usb@a000000 {
 
 			resets = <&gcc GCC_USB30_TERT_BCR>;
 			power-domains = <&gcc GCC_USB30_TERT_GDSC>;
+			required-opps = <&rpmhpd_opp_nom>;
 
 			iommus = <&apps_smmu 0x420 0x0>;
 
+			interconnects = <&aggre2_noc MASTER_USB3_2 QCOM_ICC_TAG_ALWAYS
+					 &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
+					<&hsc_noc MASTER_APPSS_PROC QCOM_ICC_TAG_ACTIVE_ONLY
+					 &config_noc SLAVE_USB3_2 QCOM_ICC_TAG_ACTIVE_ONLY>;
+			interconnect-names = "usb-ddr",
+					     "apps-usb";
+
 			phys = <&usb_2_hsphy>,
 			       <&usb_2_qmpphy QMP_USB43DP_USB3_PHY>;
 			phy-names = "usb2-phy",
@@ -4869,6 +4906,10 @@ usb_mp: usb@a400000 {
 				      "noc_aggr_north",
 				      "noc_aggr_south";
 
+			assigned-clocks = <&gcc GCC_USB30_MP_MOCK_UTMI_CLK>,
+					  <&gcc GCC_USB30_MP_MASTER_CLK>;
+			assigned-clock-rates = <19200000>, <200000000>;
+
 			interrupts-extended = <&intc GIC_SPI 132 IRQ_TYPE_LEVEL_HIGH>,
 					      <&intc GIC_SPI 345 IRQ_TYPE_LEVEL_HIGH>,
 					      <&intc GIC_SPI 346 IRQ_TYPE_LEVEL_HIGH>,
@@ -4894,9 +4935,17 @@ usb_mp: usb@a400000 {
 
 			resets = <&gcc GCC_USB30_MP_BCR>;
 			power-domains = <&gcc GCC_USB30_MP_GDSC>;
+			required-opps = <&rpmhpd_opp_nom>;
 
 			iommus = <&apps_smmu 0xda0 0x0>;
 
+			interconnects = <&aggre3_noc MASTER_USB3_MP QCOM_ICC_TAG_ALWAYS
+					 &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
+					<&hsc_noc MASTER_APPSS_PROC QCOM_ICC_TAG_ACTIVE_ONLY
+					 &config_noc SLAVE_USB3_MP QCOM_ICC_TAG_ACTIVE_ONLY>;
+			interconnect-names = "usb-ddr",
+					     "apps-usb";
+
 			phys = <&usb_mp_hsphy0>,
 			       <&usb_mp_qmpphy0>,
 			       <&usb_mp_hsphy1>,
-- 
2.53.0




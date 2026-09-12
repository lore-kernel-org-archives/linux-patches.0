Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 977342BDC0E;
	Sat, 12 Sep 2026 10:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208829; cv=none; b=g99OUqOwqK2MAHsaC9pNw3WOlIDDCmMQuz5PhoCbDjSPOQxibDdJ4l7jzJc04fe33KEs8nMz5XxvWSR1PVIuFZoJTMhmJFdeB82bnqYRiByub5Tl6XL3Sm5s1DF7Lw/MWAmfyKwe4shsTzSgLaLk2VE4lUU5V0ohrIs2fNQqm9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208829; c=relaxed/simple;
	bh=e6E+1tRC+/90eIaqLceOZF8t+T56h+VknhY+g50zJzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FB3Z16z9/TKdJAm/bS0vrafnSwEcTmAV7w880GdnMNGif1lmJpY2Js/7CEhrlHz/YTt5r0X0XAnXJbUm0OV+WUW1h4OQzKpXqWdKvzOOPZxaCB8dFGujN3tebiAqFdCpgn0OsbmOwaLPbhPGilfpfgLQHrmWgic8kDxaUEsEGTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hPZsXJ9M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hPZsXJ9M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61F881F000FF;
	Sat, 12 Sep 2026 10:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208827;
	bh=MDTGno2ek1hF01UvaB8hYH7Fc2TIZw9GDGBM1Y47IVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hPZsXJ9MFF6nhtMfqiq5hyUMdBPIVlhRG/+SOHysn849AqtUphM2AaohdNcpuGQvR
	 f66tLr2jksQD6hg0uKZ3pwj8WW9Jl7gGua7ShGBG808gi5oAsN+b4al261GWUdLQ2X
	 qDx6EKzuI2es6FhLYWAOrSe4u6Rc9K2THJXlqrOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Guo <shengchao.guo@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0698/1518] arm64: dts: qcom: lemans: Move PCIe devices into soc node
Date: Sat, 12 Sep 2026 08:47:47 +0200
Message-ID: <20260912065639.224926313@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Shawn Guo <shengchao.guo@oss.qualcomm.com>

[ Upstream commit 8222873cd4698627c08bffb2e40ba6f5a008fe32 ]

These PCIe devices with MMIO address should be inside soc node rather
than outside.

Fixes: 489f14be0e0a ("arm64: dts: qcom: sa8775p: Add pcie0 and pcie1 nodes")
Signed-off-by: Shawn Guo <shengchao.guo@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260331090147.18522-1-shengchao.guo@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: 19b4c47fc973 ("arm64: dts: qcom: lemans: Fix the PCIe iommu-map entries")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/lemans.dtsi | 692 +++++++++++++--------------
 1 file changed, 346 insertions(+), 346 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/lemans.dtsi b/arch/arm64/boot/dts/qcom/lemans.dtsi
index 7dbd31a238d44..0861e4ead93eb 100644
--- a/arch/arm64/boot/dts/qcom/lemans.dtsi
+++ b/arch/arm64/boot/dts/qcom/lemans.dtsi
@@ -2673,6 +2673,352 @@ mmss_noc: interconnect@17a0000 {
 			qcom,bcm-voters = <&apps_bcm_voter>;
 		};
 
+		pcie0: pcie@1c00000 {
+			compatible = "qcom,pcie-sa8775p";
+			reg = <0x0 0x01c00000 0x0 0x3000>,
+			      <0x0 0x40000000 0x0 0xf20>,
+			      <0x0 0x40000f20 0x0 0xa8>,
+			      <0x0 0x40001000 0x0 0x4000>,
+			      <0x0 0x40100000 0x0 0x100000>,
+			      <0x0 0x01c03000 0x0 0x1000>;
+			reg-names = "parf", "dbi", "elbi", "atu", "config", "mhi";
+			device_type = "pci";
+
+			#address-cells = <3>;
+			#size-cells = <2>;
+			ranges = <0x01000000 0x0 0x00000000 0x0 0x40200000 0x0 0x100000>,
+				 <0x02000000 0x0 0x40300000 0x0 0x40300000 0x0 0x1fd00000>;
+			bus-range = <0x00 0xff>;
+
+			dma-coherent;
+
+			linux,pci-domain = <0>;
+			num-lanes = <2>;
+
+			interrupts = <GIC_SPI 307 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 308 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 309 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 312 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 313 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 314 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 374 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 375 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 306 IRQ_TYPE_LEVEL_HIGH>;
+			interrupt-names = "msi0",
+					  "msi1",
+					  "msi2",
+					  "msi3",
+					  "msi4",
+					  "msi5",
+					  "msi6",
+					  "msi7",
+					  "global";
+			#interrupt-cells = <1>;
+			interrupt-map-mask = <0 0 0 0x7>;
+			interrupt-map = <0 0 0 1 &intc GIC_SPI 434 IRQ_TYPE_LEVEL_HIGH>,
+					<0 0 0 2 &intc GIC_SPI 435 IRQ_TYPE_LEVEL_HIGH>,
+					<0 0 0 3 &intc GIC_SPI 438 IRQ_TYPE_LEVEL_HIGH>,
+					<0 0 0 4 &intc GIC_SPI 439 IRQ_TYPE_LEVEL_HIGH>;
+
+			clocks = <&gcc GCC_PCIE_0_AUX_CLK>,
+				 <&gcc GCC_PCIE_0_CFG_AHB_CLK>,
+				 <&gcc GCC_PCIE_0_MSTR_AXI_CLK>,
+				 <&gcc GCC_PCIE_0_SLV_AXI_CLK>,
+				 <&gcc GCC_PCIE_0_SLV_Q2A_AXI_CLK>;
+
+			clock-names = "aux",
+				      "cfg",
+				      "bus_master",
+				      "bus_slave",
+				      "slave_q2a";
+
+			assigned-clocks = <&gcc GCC_PCIE_0_AUX_CLK>;
+			assigned-clock-rates = <19200000>;
+
+			interconnects = <&pcie_anoc MASTER_PCIE_0 0 &mc_virt SLAVE_EBI1 0>,
+					<&gem_noc MASTER_APPSS_PROC 0 &config_noc SLAVE_PCIE_0 0>;
+			interconnect-names = "pcie-mem", "cpu-pcie";
+
+			iommu-map = <0x0 &pcie_smmu 0x0000 0x1>,
+				    <0x100 &pcie_smmu 0x0001 0x1>;
+
+			resets = <&gcc GCC_PCIE_0_BCR>,
+				 <&gcc GCC_PCIE_0_LINK_DOWN_BCR>;
+			reset-names = "pci",
+				      "link_down";
+
+			power-domains = <&gcc PCIE_0_GDSC>;
+
+			phys = <&pcie0_phy>;
+			phy-names = "pciephy";
+
+			eq-presets-8gts = /bits/ 16 <0x5555 0x5555>;
+			eq-presets-16gts = /bits/ 8 <0x55 0x55>;
+
+			status = "disabled";
+
+			pcieport0: pcie@0 {
+				device_type = "pci";
+				reg = <0x0 0x0 0x0 0x0 0x0>;
+				bus-range = <0x01 0xff>;
+
+				#address-cells = <3>;
+				#size-cells = <2>;
+				ranges;
+			};
+		};
+
+		pcie0_ep: pcie-ep@1c00000 {
+			compatible = "qcom,sa8775p-pcie-ep";
+			reg = <0x0 0x01c00000 0x0 0x3000>,
+			      <0x0 0x40000000 0x0 0xf20>,
+			      <0x0 0x40000f20 0x0 0xa8>,
+			      <0x0 0x40001000 0x0 0x4000>,
+			      <0x0 0x40200000 0x0 0x1fe00000>,
+			      <0x0 0x01c03000 0x0 0x1000>,
+			      <0x0 0x40005000 0x0 0x2000>;
+			reg-names = "parf", "dbi", "elbi", "atu", "addr_space",
+				    "mmio", "dma";
+
+			clocks = <&gcc GCC_PCIE_0_AUX_CLK>,
+				<&gcc GCC_PCIE_0_CFG_AHB_CLK>,
+				<&gcc GCC_PCIE_0_MSTR_AXI_CLK>,
+				<&gcc GCC_PCIE_0_SLV_AXI_CLK>,
+				<&gcc GCC_PCIE_0_SLV_Q2A_AXI_CLK>;
+
+			clock-names = "aux",
+				      "cfg",
+				      "bus_master",
+				      "bus_slave",
+				      "slave_q2a";
+
+			interrupts = <GIC_SPI 306 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 147 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 630 IRQ_TYPE_LEVEL_HIGH>;
+
+			interrupt-names = "global", "doorbell", "dma";
+
+			interconnects = <&pcie_anoc MASTER_PCIE_0 0 &mc_virt SLAVE_EBI1 0>,
+					<&gem_noc MASTER_APPSS_PROC 0 &config_noc SLAVE_PCIE_0 0>;
+			interconnect-names = "pcie-mem", "cpu-pcie";
+
+			dma-coherent;
+			iommus = <&pcie_smmu 0x0000 0x7f>;
+			resets = <&gcc GCC_PCIE_0_BCR>;
+			reset-names = "core";
+			power-domains = <&gcc PCIE_0_GDSC>;
+			phys = <&pcie0_phy>;
+			phy-names = "pciephy";
+			num-lanes = <2>;
+			linux,pci-domain = <0>;
+
+			status = "disabled";
+		};
+
+		pcie0_phy: phy@1c04000 {
+			compatible = "qcom,sa8775p-qmp-gen4x2-pcie-phy";
+			reg = <0x0 0x1c04000 0x0 0x2000>;
+
+			clocks = <&gcc GCC_PCIE_0_PHY_AUX_CLK>,
+				 <&gcc GCC_PCIE_0_CFG_AHB_CLK>,
+				 <&gcc GCC_PCIE_CLKREF_EN>,
+				 <&gcc GCC_PCIE_0_PHY_RCHNG_CLK>,
+				 <&gcc GCC_PCIE_0_PIPE_CLK>,
+				 <&gcc GCC_PCIE_0_PIPEDIV2_CLK>;
+			clock-names = "aux",
+				      "cfg_ahb",
+				      "ref",
+				      "rchng",
+				      "pipe",
+				      "pipediv2";
+
+			assigned-clocks = <&gcc GCC_PCIE_0_PHY_RCHNG_CLK>;
+			assigned-clock-rates = <100000000>;
+
+			resets = <&gcc GCC_PCIE_0_PHY_BCR>;
+			reset-names = "phy";
+
+			#clock-cells = <0>;
+			clock-output-names = "pcie_0_pipe_clk";
+
+			#phy-cells = <0>;
+
+			status = "disabled";
+		};
+
+		pcie1: pcie@1c10000 {
+			compatible = "qcom,pcie-sa8775p";
+			reg = <0x0 0x01c10000 0x0 0x3000>,
+			      <0x0 0x60000000 0x0 0xf20>,
+			      <0x0 0x60000f20 0x0 0xa8>,
+			      <0x0 0x60001000 0x0 0x4000>,
+			      <0x0 0x60100000 0x0 0x100000>,
+			      <0x0 0x01c13000 0x0 0x1000>;
+			reg-names = "parf", "dbi", "elbi", "atu", "config", "mhi";
+			device_type = "pci";
+
+			#address-cells = <3>;
+			#size-cells = <2>;
+			ranges = <0x01000000 0x0 0x00000000 0x0 0x60200000 0x0 0x100000>,
+				 <0x02000000 0x0 0x60300000 0x0 0x60300000 0x0 0x1fd00000>;
+			bus-range = <0x00 0xff>;
+
+			dma-coherent;
+
+			linux,pci-domain = <1>;
+			num-lanes = <4>;
+
+			interrupts = <GIC_SPI 519 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 140 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 141 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 142 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 143 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 144 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 145 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 146 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 518 IRQ_TYPE_LEVEL_HIGH>;
+			interrupt-names = "msi0",
+					  "msi1",
+					  "msi2",
+					  "msi3",
+					  "msi4",
+					  "msi5",
+					  "msi6",
+					  "msi7",
+					  "global";
+			#interrupt-cells = <1>;
+			interrupt-map-mask = <0 0 0 0x7>;
+			interrupt-map = <0 0 0 1 &intc GIC_SPI 148 IRQ_TYPE_LEVEL_HIGH>,
+					<0 0 0 2 &intc GIC_SPI 149 IRQ_TYPE_LEVEL_HIGH>,
+					<0 0 0 3 &intc GIC_SPI 150 IRQ_TYPE_LEVEL_HIGH>,
+					<0 0 0 4 &intc GIC_SPI 151 IRQ_TYPE_LEVEL_HIGH>;
+
+			clocks = <&gcc GCC_PCIE_1_AUX_CLK>,
+				 <&gcc GCC_PCIE_1_CFG_AHB_CLK>,
+				 <&gcc GCC_PCIE_1_MSTR_AXI_CLK>,
+				 <&gcc GCC_PCIE_1_SLV_AXI_CLK>,
+				 <&gcc GCC_PCIE_1_SLV_Q2A_AXI_CLK>;
+
+			clock-names = "aux",
+				      "cfg",
+				      "bus_master",
+				      "bus_slave",
+				      "slave_q2a";
+
+			assigned-clocks = <&gcc GCC_PCIE_1_AUX_CLK>;
+			assigned-clock-rates = <19200000>;
+
+			interconnects = <&pcie_anoc MASTER_PCIE_1 0 &mc_virt SLAVE_EBI1 0>,
+					<&gem_noc MASTER_APPSS_PROC 0 &config_noc SLAVE_PCIE_1 0>;
+			interconnect-names = "pcie-mem", "cpu-pcie";
+
+			iommu-map = <0x0 &pcie_smmu 0x0080 0x1>,
+				    <0x100 &pcie_smmu 0x0081 0x1>;
+
+			resets = <&gcc GCC_PCIE_1_BCR>,
+				 <&gcc GCC_PCIE_1_LINK_DOWN_BCR>;
+			reset-names = "pci",
+				      "link_down";
+
+			power-domains = <&gcc PCIE_1_GDSC>;
+
+			phys = <&pcie1_phy>;
+			phy-names = "pciephy";
+
+			eq-presets-8gts = /bits/ 16 <0x5555 0x5555 0x5555 0x5555>;
+			eq-presets-16gts = /bits/ 8 <0x55 0x55 0x55 0x55>;
+
+			status = "disabled";
+
+			pcie@0 {
+				device_type = "pci";
+				reg = <0x0 0x0 0x0 0x0 0x0>;
+				bus-range = <0x01 0xff>;
+
+				#address-cells = <3>;
+				#size-cells = <2>;
+				ranges;
+			};
+		};
+
+		pcie1_ep: pcie-ep@1c10000 {
+			compatible = "qcom,sa8775p-pcie-ep";
+			reg = <0x0 0x01c10000 0x0 0x3000>,
+			      <0x0 0x60000000 0x0 0xf20>,
+			      <0x0 0x60000f20 0x0 0xa8>,
+			      <0x0 0x60001000 0x0 0x4000>,
+			      <0x0 0x60200000 0x0 0x1fe00000>,
+			      <0x0 0x01c13000 0x0 0x1000>,
+			      <0x0 0x60005000 0x0 0x2000>;
+			reg-names = "parf", "dbi", "elbi", "atu", "addr_space",
+				    "mmio", "dma";
+
+			clocks = <&gcc GCC_PCIE_1_AUX_CLK>,
+				 <&gcc GCC_PCIE_1_CFG_AHB_CLK>,
+				 <&gcc GCC_PCIE_1_MSTR_AXI_CLK>,
+				 <&gcc GCC_PCIE_1_SLV_AXI_CLK>,
+				 <&gcc GCC_PCIE_1_SLV_Q2A_AXI_CLK>;
+
+			clock-names = "aux",
+				      "cfg",
+				      "bus_master",
+				      "bus_slave",
+				      "slave_q2a";
+
+			interrupts = <GIC_SPI 518 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 152 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 474 IRQ_TYPE_LEVEL_HIGH>;
+
+			interrupt-names = "global", "doorbell", "dma";
+
+			interconnects = <&pcie_anoc MASTER_PCIE_1 0 &mc_virt SLAVE_EBI1 0>,
+					<&gem_noc MASTER_APPSS_PROC 0 &config_noc SLAVE_PCIE_1 0>;
+			interconnect-names = "pcie-mem", "cpu-pcie";
+
+			dma-coherent;
+			iommus = <&pcie_smmu 0x80 0x7f>;
+			resets = <&gcc GCC_PCIE_1_BCR>;
+			reset-names = "core";
+			power-domains = <&gcc PCIE_1_GDSC>;
+			phys = <&pcie1_phy>;
+			phy-names = "pciephy";
+			num-lanes = <4>;
+			linux,pci-domain = <1>;
+
+			status = "disabled";
+		};
+
+		pcie1_phy: phy@1c14000 {
+			compatible = "qcom,sa8775p-qmp-gen4x4-pcie-phy";
+			reg = <0x0 0x1c14000 0x0 0x4000>;
+
+			clocks = <&gcc GCC_PCIE_1_PHY_AUX_CLK>,
+				 <&gcc GCC_PCIE_1_CFG_AHB_CLK>,
+				 <&gcc GCC_PCIE_CLKREF_EN>,
+				 <&gcc GCC_PCIE_1_PHY_RCHNG_CLK>,
+				 <&gcc GCC_PCIE_1_PIPE_CLK>,
+				 <&gcc GCC_PCIE_1_PIPEDIV2_CLK>;
+			clock-names = "aux",
+				      "cfg_ahb",
+				      "ref",
+				      "rchng",
+				      "pipe",
+				      "pipediv2";
+
+			assigned-clocks = <&gcc GCC_PCIE_1_PHY_RCHNG_CLK>;
+			assigned-clock-rates = <100000000>;
+
+			resets = <&gcc GCC_PCIE_1_PHY_BCR>;
+			reset-names = "phy";
+
+			#clock-cells = <0>;
+			clock-output-names = "pcie_1_pipe_clk";
+
+			#phy-cells = <0>;
+
+			status = "disabled";
+		};
+
 		ufs_mem_hc: ufshc@1d84000 {
 			compatible = "qcom,sa8775p-ufshc", "qcom,ufshc", "jedec,ufs-2.0";
 			reg = <0x0 0x01d84000 0x0 0x3000>;
@@ -8305,350 +8651,4 @@ arch_timer: timer {
 			     <GIC_PPI 11 (GIC_CPU_MASK_SIMPLE(8) | IRQ_TYPE_LEVEL_LOW)>,
 			     <GIC_PPI 10 (GIC_CPU_MASK_SIMPLE(8) | IRQ_TYPE_LEVEL_LOW)>;
 	};
-
-	pcie0: pcie@1c00000 {
-		compatible = "qcom,pcie-sa8775p";
-		reg = <0x0 0x01c00000 0x0 0x3000>,
-		      <0x0 0x40000000 0x0 0xf20>,
-		      <0x0 0x40000f20 0x0 0xa8>,
-		      <0x0 0x40001000 0x0 0x4000>,
-		      <0x0 0x40100000 0x0 0x100000>,
-		      <0x0 0x01c03000 0x0 0x1000>;
-		reg-names = "parf", "dbi", "elbi", "atu", "config", "mhi";
-		device_type = "pci";
-
-		#address-cells = <3>;
-		#size-cells = <2>;
-		ranges = <0x01000000 0x0 0x00000000 0x0 0x40200000 0x0 0x100000>,
-			 <0x02000000 0x0 0x40300000 0x0 0x40300000 0x0 0x1fd00000>;
-		bus-range = <0x00 0xff>;
-
-		dma-coherent;
-
-		linux,pci-domain = <0>;
-		num-lanes = <2>;
-
-		interrupts = <GIC_SPI 307 IRQ_TYPE_LEVEL_HIGH>,
-			     <GIC_SPI 308 IRQ_TYPE_LEVEL_HIGH>,
-			     <GIC_SPI 309 IRQ_TYPE_LEVEL_HIGH>,
-			     <GIC_SPI 312 IRQ_TYPE_LEVEL_HIGH>,
-			     <GIC_SPI 313 IRQ_TYPE_LEVEL_HIGH>,
-			     <GIC_SPI 314 IRQ_TYPE_LEVEL_HIGH>,
-			     <GIC_SPI 374 IRQ_TYPE_LEVEL_HIGH>,
-			     <GIC_SPI 375 IRQ_TYPE_LEVEL_HIGH>,
-			     <GIC_SPI 306 IRQ_TYPE_LEVEL_HIGH>;
-		interrupt-names = "msi0",
-				  "msi1",
-				  "msi2",
-				  "msi3",
-				  "msi4",
-				  "msi5",
-				  "msi6",
-				  "msi7",
-				  "global";
-		#interrupt-cells = <1>;
-		interrupt-map-mask = <0 0 0 0x7>;
-		interrupt-map = <0 0 0 1 &intc GIC_SPI 434 IRQ_TYPE_LEVEL_HIGH>,
-				<0 0 0 2 &intc GIC_SPI 435 IRQ_TYPE_LEVEL_HIGH>,
-				<0 0 0 3 &intc GIC_SPI 438 IRQ_TYPE_LEVEL_HIGH>,
-				<0 0 0 4 &intc GIC_SPI 439 IRQ_TYPE_LEVEL_HIGH>;
-
-		clocks = <&gcc GCC_PCIE_0_AUX_CLK>,
-			 <&gcc GCC_PCIE_0_CFG_AHB_CLK>,
-			 <&gcc GCC_PCIE_0_MSTR_AXI_CLK>,
-			 <&gcc GCC_PCIE_0_SLV_AXI_CLK>,
-			 <&gcc GCC_PCIE_0_SLV_Q2A_AXI_CLK>;
-
-		clock-names = "aux",
-			      "cfg",
-			      "bus_master",
-			      "bus_slave",
-			      "slave_q2a";
-
-		assigned-clocks = <&gcc GCC_PCIE_0_AUX_CLK>;
-		assigned-clock-rates = <19200000>;
-
-		interconnects = <&pcie_anoc MASTER_PCIE_0 0 &mc_virt SLAVE_EBI1 0>,
-				<&gem_noc MASTER_APPSS_PROC 0 &config_noc SLAVE_PCIE_0 0>;
-		interconnect-names = "pcie-mem", "cpu-pcie";
-
-		iommu-map = <0x0 &pcie_smmu 0x0000 0x1>,
-			    <0x100 &pcie_smmu 0x0001 0x1>;
-
-		resets = <&gcc GCC_PCIE_0_BCR>,
-			 <&gcc GCC_PCIE_0_LINK_DOWN_BCR>;
-		reset-names = "pci",
-			      "link_down";
-
-		power-domains = <&gcc PCIE_0_GDSC>;
-
-		phys = <&pcie0_phy>;
-		phy-names = "pciephy";
-
-		eq-presets-8gts = /bits/ 16 <0x5555 0x5555>;
-		eq-presets-16gts = /bits/ 8 <0x55 0x55>;
-
-		status = "disabled";
-
-		pcieport0: pcie@0 {
-			device_type = "pci";
-			reg = <0x0 0x0 0x0 0x0 0x0>;
-			bus-range = <0x01 0xff>;
-
-			#address-cells = <3>;
-			#size-cells = <2>;
-			ranges;
-		};
-	};
-
-	pcie0_ep: pcie-ep@1c00000 {
-		compatible = "qcom,sa8775p-pcie-ep";
-		reg = <0x0 0x01c00000 0x0 0x3000>,
-		      <0x0 0x40000000 0x0 0xf20>,
-		      <0x0 0x40000f20 0x0 0xa8>,
-		      <0x0 0x40001000 0x0 0x4000>,
-		      <0x0 0x40200000 0x0 0x1fe00000>,
-		      <0x0 0x01c03000 0x0 0x1000>,
-		      <0x0 0x40005000 0x0 0x2000>;
-		reg-names = "parf", "dbi", "elbi", "atu", "addr_space",
-			    "mmio", "dma";
-
-		clocks = <&gcc GCC_PCIE_0_AUX_CLK>,
-			<&gcc GCC_PCIE_0_CFG_AHB_CLK>,
-			<&gcc GCC_PCIE_0_MSTR_AXI_CLK>,
-			<&gcc GCC_PCIE_0_SLV_AXI_CLK>,
-			<&gcc GCC_PCIE_0_SLV_Q2A_AXI_CLK>;
-
-		clock-names = "aux",
-			      "cfg",
-			      "bus_master",
-			      "bus_slave",
-			      "slave_q2a";
-
-		interrupts = <GIC_SPI 306 IRQ_TYPE_LEVEL_HIGH>,
-			     <GIC_SPI 147 IRQ_TYPE_LEVEL_HIGH>,
-			     <GIC_SPI 630 IRQ_TYPE_LEVEL_HIGH>;
-
-		interrupt-names = "global", "doorbell", "dma";
-
-		interconnects = <&pcie_anoc MASTER_PCIE_0 0 &mc_virt SLAVE_EBI1 0>,
-				<&gem_noc MASTER_APPSS_PROC 0 &config_noc SLAVE_PCIE_0 0>;
-		interconnect-names = "pcie-mem", "cpu-pcie";
-
-		dma-coherent;
-		iommus = <&pcie_smmu 0x0000 0x7f>;
-		resets = <&gcc GCC_PCIE_0_BCR>;
-		reset-names = "core";
-		power-domains = <&gcc PCIE_0_GDSC>;
-		phys = <&pcie0_phy>;
-		phy-names = "pciephy";
-		num-lanes = <2>;
-		linux,pci-domain = <0>;
-
-		status = "disabled";
-	};
-
-	pcie0_phy: phy@1c04000 {
-		compatible = "qcom,sa8775p-qmp-gen4x2-pcie-phy";
-		reg = <0x0 0x1c04000 0x0 0x2000>;
-
-		clocks = <&gcc GCC_PCIE_0_PHY_AUX_CLK>,
-			 <&gcc GCC_PCIE_0_CFG_AHB_CLK>,
-			 <&gcc GCC_PCIE_CLKREF_EN>,
-			 <&gcc GCC_PCIE_0_PHY_RCHNG_CLK>,
-			 <&gcc GCC_PCIE_0_PIPE_CLK>,
-			 <&gcc GCC_PCIE_0_PIPEDIV2_CLK>;
-		clock-names = "aux",
-			      "cfg_ahb",
-			      "ref",
-			      "rchng",
-			      "pipe",
-			      "pipediv2";
-
-		assigned-clocks = <&gcc GCC_PCIE_0_PHY_RCHNG_CLK>;
-		assigned-clock-rates = <100000000>;
-
-		resets = <&gcc GCC_PCIE_0_PHY_BCR>;
-		reset-names = "phy";
-
-		#clock-cells = <0>;
-		clock-output-names = "pcie_0_pipe_clk";
-
-		#phy-cells = <0>;
-
-		status = "disabled";
-	};
-
-	pcie1: pcie@1c10000 {
-		compatible = "qcom,pcie-sa8775p";
-		reg = <0x0 0x01c10000 0x0 0x3000>,
-		      <0x0 0x60000000 0x0 0xf20>,
-		      <0x0 0x60000f20 0x0 0xa8>,
-		      <0x0 0x60001000 0x0 0x4000>,
-		      <0x0 0x60100000 0x0 0x100000>,
-		      <0x0 0x01c13000 0x0 0x1000>;
-		reg-names = "parf", "dbi", "elbi", "atu", "config", "mhi";
-		device_type = "pci";
-
-		#address-cells = <3>;
-		#size-cells = <2>;
-		ranges = <0x01000000 0x0 0x00000000 0x0 0x60200000 0x0 0x100000>,
-			 <0x02000000 0x0 0x60300000 0x0 0x60300000 0x0 0x1fd00000>;
-		bus-range = <0x00 0xff>;
-
-		dma-coherent;
-
-		linux,pci-domain = <1>;
-		num-lanes = <4>;
-
-		interrupts = <GIC_SPI 519 IRQ_TYPE_LEVEL_HIGH>,
-			     <GIC_SPI 140 IRQ_TYPE_LEVEL_HIGH>,
-			     <GIC_SPI 141 IRQ_TYPE_LEVEL_HIGH>,
-			     <GIC_SPI 142 IRQ_TYPE_LEVEL_HIGH>,
-			     <GIC_SPI 143 IRQ_TYPE_LEVEL_HIGH>,
-			     <GIC_SPI 144 IRQ_TYPE_LEVEL_HIGH>,
-			     <GIC_SPI 145 IRQ_TYPE_LEVEL_HIGH>,
-			     <GIC_SPI 146 IRQ_TYPE_LEVEL_HIGH>,
-			     <GIC_SPI 518 IRQ_TYPE_LEVEL_HIGH>;
-		interrupt-names = "msi0",
-				  "msi1",
-				  "msi2",
-				  "msi3",
-				  "msi4",
-				  "msi5",
-				  "msi6",
-				  "msi7",
-				  "global";
-		#interrupt-cells = <1>;
-		interrupt-map-mask = <0 0 0 0x7>;
-		interrupt-map = <0 0 0 1 &intc GIC_SPI 148 IRQ_TYPE_LEVEL_HIGH>,
-				<0 0 0 2 &intc GIC_SPI 149 IRQ_TYPE_LEVEL_HIGH>,
-				<0 0 0 3 &intc GIC_SPI 150 IRQ_TYPE_LEVEL_HIGH>,
-				<0 0 0 4 &intc GIC_SPI 151 IRQ_TYPE_LEVEL_HIGH>;
-
-		clocks = <&gcc GCC_PCIE_1_AUX_CLK>,
-			 <&gcc GCC_PCIE_1_CFG_AHB_CLK>,
-			 <&gcc GCC_PCIE_1_MSTR_AXI_CLK>,
-			 <&gcc GCC_PCIE_1_SLV_AXI_CLK>,
-			 <&gcc GCC_PCIE_1_SLV_Q2A_AXI_CLK>;
-
-		clock-names = "aux",
-			      "cfg",
-			      "bus_master",
-			      "bus_slave",
-			      "slave_q2a";
-
-		assigned-clocks = <&gcc GCC_PCIE_1_AUX_CLK>;
-		assigned-clock-rates = <19200000>;
-
-		interconnects = <&pcie_anoc MASTER_PCIE_1 0 &mc_virt SLAVE_EBI1 0>,
-				<&gem_noc MASTER_APPSS_PROC 0 &config_noc SLAVE_PCIE_1 0>;
-		interconnect-names = "pcie-mem", "cpu-pcie";
-
-		iommu-map = <0x0 &pcie_smmu 0x0080 0x1>,
-			    <0x100 &pcie_smmu 0x0081 0x1>;
-
-		resets = <&gcc GCC_PCIE_1_BCR>,
-			 <&gcc GCC_PCIE_1_LINK_DOWN_BCR>;
-		reset-names = "pci",
-			      "link_down";
-
-		power-domains = <&gcc PCIE_1_GDSC>;
-
-		phys = <&pcie1_phy>;
-		phy-names = "pciephy";
-
-		eq-presets-8gts = /bits/ 16 <0x5555 0x5555 0x5555 0x5555>;
-		eq-presets-16gts = /bits/ 8 <0x55 0x55 0x55 0x55>;
-
-		status = "disabled";
-
-		pcie@0 {
-			device_type = "pci";
-			reg = <0x0 0x0 0x0 0x0 0x0>;
-			bus-range = <0x01 0xff>;
-
-			#address-cells = <3>;
-			#size-cells = <2>;
-			ranges;
-		};
-	};
-
-	pcie1_ep: pcie-ep@1c10000 {
-		compatible = "qcom,sa8775p-pcie-ep";
-		reg = <0x0 0x01c10000 0x0 0x3000>,
-		      <0x0 0x60000000 0x0 0xf20>,
-		      <0x0 0x60000f20 0x0 0xa8>,
-		      <0x0 0x60001000 0x0 0x4000>,
-		      <0x0 0x60200000 0x0 0x1fe00000>,
-		      <0x0 0x01c13000 0x0 0x1000>,
-		      <0x0 0x60005000 0x0 0x2000>;
-		reg-names = "parf", "dbi", "elbi", "atu", "addr_space",
-			    "mmio", "dma";
-
-		clocks = <&gcc GCC_PCIE_1_AUX_CLK>,
-			 <&gcc GCC_PCIE_1_CFG_AHB_CLK>,
-			 <&gcc GCC_PCIE_1_MSTR_AXI_CLK>,
-			 <&gcc GCC_PCIE_1_SLV_AXI_CLK>,
-			 <&gcc GCC_PCIE_1_SLV_Q2A_AXI_CLK>;
-
-		clock-names = "aux",
-			      "cfg",
-			      "bus_master",
-			      "bus_slave",
-			      "slave_q2a";
-
-		interrupts = <GIC_SPI 518 IRQ_TYPE_LEVEL_HIGH>,
-			     <GIC_SPI 152 IRQ_TYPE_LEVEL_HIGH>,
-			     <GIC_SPI 474 IRQ_TYPE_LEVEL_HIGH>;
-
-		interrupt-names = "global", "doorbell", "dma";
-
-		interconnects = <&pcie_anoc MASTER_PCIE_1 0 &mc_virt SLAVE_EBI1 0>,
-				<&gem_noc MASTER_APPSS_PROC 0 &config_noc SLAVE_PCIE_1 0>;
-		interconnect-names = "pcie-mem", "cpu-pcie";
-
-		dma-coherent;
-		iommus = <&pcie_smmu 0x80 0x7f>;
-		resets = <&gcc GCC_PCIE_1_BCR>;
-		reset-names = "core";
-		power-domains = <&gcc PCIE_1_GDSC>;
-		phys = <&pcie1_phy>;
-		phy-names = "pciephy";
-		num-lanes = <4>;
-		linux,pci-domain = <1>;
-
-		status = "disabled";
-	};
-
-	pcie1_phy: phy@1c14000 {
-		compatible = "qcom,sa8775p-qmp-gen4x4-pcie-phy";
-		reg = <0x0 0x1c14000 0x0 0x4000>;
-
-		clocks = <&gcc GCC_PCIE_1_PHY_AUX_CLK>,
-			 <&gcc GCC_PCIE_1_CFG_AHB_CLK>,
-			 <&gcc GCC_PCIE_CLKREF_EN>,
-			 <&gcc GCC_PCIE_1_PHY_RCHNG_CLK>,
-			 <&gcc GCC_PCIE_1_PIPE_CLK>,
-			 <&gcc GCC_PCIE_1_PIPEDIV2_CLK>;
-		clock-names = "aux",
-			      "cfg_ahb",
-			      "ref",
-			      "rchng",
-			      "pipe",
-			      "pipediv2";
-
-		assigned-clocks = <&gcc GCC_PCIE_1_PHY_RCHNG_CLK>;
-		assigned-clock-rates = <100000000>;
-
-		resets = <&gcc GCC_PCIE_1_PHY_BCR>;
-		reset-names = "phy";
-
-		#clock-cells = <0>;
-		clock-output-names = "pcie_1_pipe_clk";
-
-		#phy-cells = <0>;
-
-		status = "disabled";
-	};
 };
-- 
2.53.0




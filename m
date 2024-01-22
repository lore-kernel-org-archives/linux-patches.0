Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C56B41350E8;
	Tue, 23 Jan 2024 00:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969347; cv=none; b=lXkGOf2PWv6C4T2/dRw0wfihgv/vebWaaZsKd+GwU7QQqoRGgZKdTwvUSfx2Jg5+HcsBKDCIX+nLplxShNInm8YtO8K61/a4i3qCTrsiL1XZ9iWkMIRLPQtwAop/8Vm4Gw0n9TpWHqECyupCtIMO+RNVxtrABtgnUGUiI2IgQBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969347; c=relaxed/simple;
	bh=y8bYDMFLZpepWUB5HwyjYQpWZkhtIoLyQqud1cHeah0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TtQa4sXUj2CZrCmjamqqWFIhsYm52QRBt/z9+BwBDqWDVXnatM81MgzYhX8SPGSDnPfVFkQv2DlI5isfHN7Ot2fT8Wknbum8++BXZ/G5/4aDKQk7qGc67H+YjPx7s5OA6oJqJTln1Pv5PPc4QIWQrCsDpV4BLaxKRQX9aWNI9BQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eNHMIR3O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eNHMIR3O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44539C433F1;
	Tue, 23 Jan 2024 00:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969347;
	bh=y8bYDMFLZpepWUB5HwyjYQpWZkhtIoLyQqud1cHeah0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eNHMIR3OfZUmVYntIetvsdiZgf2uyjbUQ4yBbjztN0NrNmcdMKJs8ANvE5f0smPcp
	 aNKPqCALlzoNfIrZ1KqmsCN4KMb4TMFTWAsNUQjfKlVMQSdKhz0h/DVCJsVRCJShMR
	 Qeicic3eOSCNOM/pN+MALMF9BNsNIi3U6ArI+zjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Moudy Ho <moudy.ho@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 163/641] arm64: dts: mediatek: mt8195: revise VDOSYS RDMA node name
Date: Mon, 22 Jan 2024 15:51:07 -0800
Message-ID: <20240122235823.126745295@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Moudy Ho <moudy.ho@mediatek.com>

[ Upstream commit 52f4a10f2a860402c130c5c21d055e721d63a7e9 ]

DMA-related nodes have their own standardized naming. Therefore,
the MT8195 VDOSYS RDMA has been unified and corrected.
Additionally, these modifications will facilitate the further
integration of bindings.

Fixes: 92d2c23dc269 ("arm64: dts: mt8195: add display node for vdosys1")
Signed-off-by: Moudy Ho <moudy.ho@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8195.dtsi | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8195.dtsi b/arch/arm64/boot/dts/mediatek/mt8195.dtsi
index e0ac2e9f5b72..6708c4d21abf 100644
--- a/arch/arm64/boot/dts/mediatek/mt8195.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8195.dtsi
@@ -2873,7 +2873,7 @@ larb3: larb@1c103000 {
 			power-domains = <&spm MT8195_POWER_DOMAIN_VDOSYS1>;
 		};
 
-		vdo1_rdma0: rdma@1c104000 {
+		vdo1_rdma0: dma-controller@1c104000 {
 			compatible = "mediatek,mt8195-vdo1-rdma";
 			reg = <0 0x1c104000 0 0x1000>;
 			interrupts = <GIC_SPI 495 IRQ_TYPE_LEVEL_HIGH 0>;
@@ -2881,9 +2881,10 @@ vdo1_rdma0: rdma@1c104000 {
 			power-domains = <&spm MT8195_POWER_DOMAIN_VDOSYS1>;
 			iommus = <&iommu_vdo M4U_PORT_L2_MDP_RDMA0>;
 			mediatek,gce-client-reg = <&gce0 SUBSYS_1c10XXXX 0x4000 0x1000>;
+			#dma-cells = <1>;
 		};
 
-		vdo1_rdma1: rdma@1c105000 {
+		vdo1_rdma1: dma-controller@1c105000 {
 			compatible = "mediatek,mt8195-vdo1-rdma";
 			reg = <0 0x1c105000 0 0x1000>;
 			interrupts = <GIC_SPI 496 IRQ_TYPE_LEVEL_HIGH 0>;
@@ -2891,9 +2892,10 @@ vdo1_rdma1: rdma@1c105000 {
 			power-domains = <&spm MT8195_POWER_DOMAIN_VDOSYS1>;
 			iommus = <&iommu_vpp M4U_PORT_L3_MDP_RDMA1>;
 			mediatek,gce-client-reg = <&gce0 SUBSYS_1c10XXXX 0x5000 0x1000>;
+			#dma-cells = <1>;
 		};
 
-		vdo1_rdma2: rdma@1c106000 {
+		vdo1_rdma2: dma-controller@1c106000 {
 			compatible = "mediatek,mt8195-vdo1-rdma";
 			reg = <0 0x1c106000 0 0x1000>;
 			interrupts = <GIC_SPI 497 IRQ_TYPE_LEVEL_HIGH 0>;
@@ -2901,9 +2903,10 @@ vdo1_rdma2: rdma@1c106000 {
 			power-domains = <&spm MT8195_POWER_DOMAIN_VDOSYS1>;
 			iommus = <&iommu_vdo M4U_PORT_L2_MDP_RDMA2>;
 			mediatek,gce-client-reg = <&gce0 SUBSYS_1c10XXXX 0x6000 0x1000>;
+			#dma-cells = <1>;
 		};
 
-		vdo1_rdma3: rdma@1c107000 {
+		vdo1_rdma3: dma-controller@1c107000 {
 			compatible = "mediatek,mt8195-vdo1-rdma";
 			reg = <0 0x1c107000 0 0x1000>;
 			interrupts = <GIC_SPI 498 IRQ_TYPE_LEVEL_HIGH 0>;
@@ -2911,9 +2914,10 @@ vdo1_rdma3: rdma@1c107000 {
 			power-domains = <&spm MT8195_POWER_DOMAIN_VDOSYS1>;
 			iommus = <&iommu_vpp M4U_PORT_L3_MDP_RDMA3>;
 			mediatek,gce-client-reg = <&gce0 SUBSYS_1c10XXXX 0x7000 0x1000>;
+			#dma-cells = <1>;
 		};
 
-		vdo1_rdma4: rdma@1c108000 {
+		vdo1_rdma4: dma-controller@1c108000 {
 			compatible = "mediatek,mt8195-vdo1-rdma";
 			reg = <0 0x1c108000 0 0x1000>;
 			interrupts = <GIC_SPI 499 IRQ_TYPE_LEVEL_HIGH 0>;
@@ -2921,9 +2925,10 @@ vdo1_rdma4: rdma@1c108000 {
 			power-domains = <&spm MT8195_POWER_DOMAIN_VDOSYS1>;
 			iommus = <&iommu_vdo M4U_PORT_L2_MDP_RDMA4>;
 			mediatek,gce-client-reg = <&gce0 SUBSYS_1c10XXXX 0x8000 0x1000>;
+			#dma-cells = <1>;
 		};
 
-		vdo1_rdma5: rdma@1c109000 {
+		vdo1_rdma5: dma-controller@1c109000 {
 			compatible = "mediatek,mt8195-vdo1-rdma";
 			reg = <0 0x1c109000 0 0x1000>;
 			interrupts = <GIC_SPI 500 IRQ_TYPE_LEVEL_HIGH 0>;
@@ -2931,9 +2936,10 @@ vdo1_rdma5: rdma@1c109000 {
 			power-domains = <&spm MT8195_POWER_DOMAIN_VDOSYS1>;
 			iommus = <&iommu_vpp M4U_PORT_L3_MDP_RDMA5>;
 			mediatek,gce-client-reg = <&gce0 SUBSYS_1c10XXXX 0x9000 0x1000>;
+			#dma-cells = <1>;
 		};
 
-		vdo1_rdma6: rdma@1c10a000 {
+		vdo1_rdma6: dma-controller@1c10a000 {
 			compatible = "mediatek,mt8195-vdo1-rdma";
 			reg = <0 0x1c10a000 0 0x1000>;
 			interrupts = <GIC_SPI 501 IRQ_TYPE_LEVEL_HIGH 0>;
@@ -2941,9 +2947,10 @@ vdo1_rdma6: rdma@1c10a000 {
 			power-domains = <&spm MT8195_POWER_DOMAIN_VDOSYS1>;
 			iommus = <&iommu_vdo M4U_PORT_L2_MDP_RDMA6>;
 			mediatek,gce-client-reg = <&gce0 SUBSYS_1c10XXXX 0xa000 0x1000>;
+			#dma-cells = <1>;
 		};
 
-		vdo1_rdma7: rdma@1c10b000 {
+		vdo1_rdma7: dma-controller@1c10b000 {
 			compatible = "mediatek,mt8195-vdo1-rdma";
 			reg = <0 0x1c10b000 0 0x1000>;
 			interrupts = <GIC_SPI 502 IRQ_TYPE_LEVEL_HIGH 0>;
@@ -2951,6 +2958,7 @@ vdo1_rdma7: rdma@1c10b000 {
 			power-domains = <&spm MT8195_POWER_DOMAIN_VDOSYS1>;
 			iommus = <&iommu_vpp M4U_PORT_L3_MDP_RDMA7>;
 			mediatek,gce-client-reg = <&gce0 SUBSYS_1c10XXXX 0xb000 0x1000>;
+			#dma-cells = <1>;
 		};
 
 		merge1: vpp-merge@1c10c000 {
-- 
2.43.0




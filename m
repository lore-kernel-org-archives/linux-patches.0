Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0947518027;
	Wed, 28 Jan 2026 15:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615715; cv=none; b=GrBwzRFJtpvmTYLXfGaKu3v7x6HCDVX5pWs+uCVsDvh1sNC8LuuZsCuBkXBNXjMO729pdZ0k1T9hCg6gun8voOdp2yV6ASPguxPjshU4to7U6NORa1KO0Hd1/rCVjXoDHSsI6kVJanrb3EjXeDyjNhHUCeBX6TrxwWCX4Ac3vK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615715; c=relaxed/simple;
	bh=r0WcAE345m3HmM05i24TbMaLcKMPt/bJ/39YW9oSMJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K23N8FKpvpq9rC1qMGdSEL899cZCAGxmOdipmjkvENTUVxoRdkQEFhksEjKhBhasNq0+a0TqdnJXbo5Nq4bxWhHzWPg6MTfU6IBxdqJsCgZT4Wk/BIgUf7ZiMTksHQD2xQLOzud81k/V0WNjndHEVbtRddILApda15SM5TTphsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1wvkyfDK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1wvkyfDK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BFD0C4CEF1;
	Wed, 28 Jan 2026 15:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615714;
	bh=r0WcAE345m3HmM05i24TbMaLcKMPt/bJ/39YW9oSMJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1wvkyfDKz1kv3HvGWT6i/QmVw1VJk4AdVnfG+kgz29VWsHsWOicwsjuLMHTvZcqpB
	 4VHCDeagW5Pnxjob0Aan8GMNDR6pPa2ppv5pptEojQFzed7INod2Kyx4tD+6oD18SK
	 nvbW/OappAJHS/Bm3yQkbA6lBuny26DVk8TXueNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quentin Schulz <quentin.schulz@cherry.de>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.18 065/227] arm64: dts: rockchip: fix unit-address for RK3588 NPUs core1 and core2s IOMMU
Date: Wed, 28 Jan 2026 16:21:50 +0100
Message-ID: <20260128145346.680220784@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

From: Quentin Schulz <quentin.schulz@cherry.de>

commit cd8967ea3105d30adb878a9fea0e34a9378df610 upstream.

The Device Tree specification specifies[1] that

"""
Each node in the devicetree is named according to the following
convention:
	node-name@unit-address
[...]
The unit-address must match the first address specified in the reg
property of the node.
"""

The first address in the reg property is fdaXa000 and not fdaX9000. This
is likely a copy-paste error as the IOMMU for core0 has two entries in
the reg property, the first one being fdab9000 and the second fdaba000.

Let's fix this oversight to match what the spec is expecting.

[1] https://github.com/devicetree-org/devicetree-specification/releases/download/v0.4/devicetree-specification-v0.4.pdf 2.2.1 Node Names

Fixes: a31dfc060a74 ("arm64: dts: rockchip: Add nodes for NPU and its MMU to rk3588-base")
Cc: stable@vger.kernel.org
Signed-off-by: Quentin Schulz <quentin.schulz@cherry.de>
Link: https://patch.msgid.link/20251215-npu-dt-node-address-v1-1-840093e8a2bf@cherry.de
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/rockchip/rk3588-base.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3588-base.dtsi b/arch/arm64/boot/dts/rockchip/rk3588-base.dtsi
index 2a7921793020..7ab12d1054a7 100644
--- a/arch/arm64/boot/dts/rockchip/rk3588-base.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3588-base.dtsi
@@ -1200,7 +1200,7 @@ rknn_core_1: npu@fdac0000 {
 		status = "disabled";
 	};
 
-	rknn_mmu_1: iommu@fdac9000 {
+	rknn_mmu_1: iommu@fdaca000 {
 		compatible = "rockchip,rk3588-iommu", "rockchip,rk3568-iommu";
 		reg = <0x0 0xfdaca000 0x0 0x100>;
 		interrupts = <GIC_SPI 111 IRQ_TYPE_LEVEL_HIGH 0>;
@@ -1230,7 +1230,7 @@ rknn_core_2: npu@fdad0000 {
 		status = "disabled";
 	};
 
-	rknn_mmu_2: iommu@fdad9000 {
+	rknn_mmu_2: iommu@fdada000 {
 		compatible = "rockchip,rk3588-iommu", "rockchip,rk3568-iommu";
 		reg = <0x0 0xfdada000 0x0 0x100>;
 		interrupts = <GIC_SPI 112 IRQ_TYPE_LEVEL_HIGH 0>;
-- 
2.52.0




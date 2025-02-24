Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24F481519A5;
	Mon, 24 Feb 2025 14:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740409096; cv=none; b=J8VoOHhs6Ujyxcnvthff7Bg4hBNcxPaVbhJwLshrwZN2++NzHDf81V3ev7366onLKLjj9TBQLu5n/wSFe6510h4IuiJeYaSGL9QF3hg0y9Xp4sD7KV2EL1fFIP/byR8VZ3vTJup/CN8RVTh1bXz3PoqDKg1OZUqg+Di/Ya7QjNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740409096; c=relaxed/simple;
	bh=tXkPcHhSfnKejVrvRIZV7d45xMbHdFMN6C2pBcAtDD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oj/k6ZZj3OYs0pwW56ysXUaOUN/bgeaiSBPRctfl2IfPFy7MZShvRfAreK6nruWjrhdgnUZ1Tn1ZNeWboGcoAgCWg1S/N41FO4HoYouZT46WPutfJ1vhRA+NRv13bwzm61xh2JPFWrBIptd2GCyFMXTCp1tfzGzHVZbFkEYjLXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SDmv0eho; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SDmv0eho"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D605C4CED6;
	Mon, 24 Feb 2025 14:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740409095;
	bh=tXkPcHhSfnKejVrvRIZV7d45xMbHdFMN6C2pBcAtDD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SDmv0ehoM9PbGVyqsYyDROj3KfWfwyrEEM45I5FPrB3JYvtdEbJz8IcM8zuortY9H
	 wfdlekn/VzhX5IcIVh4EtgX3i1D8AIJ9nydfeb1+3ssy+r0qQFlpHOjYhmq0GTqK/k
	 NOd4OYmUc/l0FsbtLsJDhqWMDHZ1f+wDX2REalZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrick Wildt <patrick@blueri.se>,
	Niklas Cassel <cassel@kernel.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 063/138] arm64: dts: rockchip: adjust SMMU interrupt type on rk3588
Date: Mon, 24 Feb 2025 15:34:53 +0100
Message-ID: <20250224142606.957933098@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Patrick Wildt <patrick@blueri.se>

[ Upstream commit 8546cfd08aa4b982acd2357403a1f15495d622ec ]

The SMMU architecture requires wired interrupts to be edge triggered,
which does not align with the DT description for the RK3588.  This leads
to interrupt storms, as the SMMU continues to hold the pin high and only
pulls it down for a short amount when issuing an IRQ.  Update the DT
description to be in line with the spec and perceived reality.

Signed-off-by: Patrick Wildt <patrick@blueri.se>
Fixes: cd81d3a0695c ("arm64: dts: rockchip: add rk3588 pcie and php IOMMUs")
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Link: https://lore.kernel.org/r/Z6pxme2Chmf3d3uK@windev.fritz.box
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3588-base.dtsi | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3588-base.dtsi b/arch/arm64/boot/dts/rockchip/rk3588-base.dtsi
index a337f3fb8377e..ba6de3976cf83 100644
--- a/arch/arm64/boot/dts/rockchip/rk3588-base.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3588-base.dtsi
@@ -549,10 +549,10 @@ usb_host2_xhci: usb@fcd00000 {
 	mmu600_pcie: iommu@fc900000 {
 		compatible = "arm,smmu-v3";
 		reg = <0x0 0xfc900000 0x0 0x200000>;
-		interrupts = <GIC_SPI 369 IRQ_TYPE_LEVEL_HIGH 0>,
-			     <GIC_SPI 371 IRQ_TYPE_LEVEL_HIGH 0>,
-			     <GIC_SPI 374 IRQ_TYPE_LEVEL_HIGH 0>,
-			     <GIC_SPI 367 IRQ_TYPE_LEVEL_HIGH 0>;
+		interrupts = <GIC_SPI 369 IRQ_TYPE_EDGE_RISING 0>,
+			     <GIC_SPI 371 IRQ_TYPE_EDGE_RISING 0>,
+			     <GIC_SPI 374 IRQ_TYPE_EDGE_RISING 0>,
+			     <GIC_SPI 367 IRQ_TYPE_EDGE_RISING 0>;
 		interrupt-names = "eventq", "gerror", "priq", "cmdq-sync";
 		#iommu-cells = <1>;
 		status = "disabled";
@@ -561,10 +561,10 @@ mmu600_pcie: iommu@fc900000 {
 	mmu600_php: iommu@fcb00000 {
 		compatible = "arm,smmu-v3";
 		reg = <0x0 0xfcb00000 0x0 0x200000>;
-		interrupts = <GIC_SPI 381 IRQ_TYPE_LEVEL_HIGH 0>,
-			     <GIC_SPI 383 IRQ_TYPE_LEVEL_HIGH 0>,
-			     <GIC_SPI 386 IRQ_TYPE_LEVEL_HIGH 0>,
-			     <GIC_SPI 379 IRQ_TYPE_LEVEL_HIGH 0>;
+		interrupts = <GIC_SPI 381 IRQ_TYPE_EDGE_RISING 0>,
+			     <GIC_SPI 383 IRQ_TYPE_EDGE_RISING 0>,
+			     <GIC_SPI 386 IRQ_TYPE_EDGE_RISING 0>,
+			     <GIC_SPI 379 IRQ_TYPE_EDGE_RISING 0>;
 		interrupt-names = "eventq", "gerror", "priq", "cmdq-sync";
 		#iommu-cells = <1>;
 		status = "disabled";
-- 
2.39.5




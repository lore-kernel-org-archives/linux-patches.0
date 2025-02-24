Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C078F824A3;
	Mon, 24 Feb 2025 14:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408543; cv=none; b=Z+bz2o6/kwswStmmLzhqk7rX/bAoTApvUDvYcV4Y+A12KOfd4hSbdu9h5Zsh8zbcA57kwLJ9b4a3JyoWFM2RFSoTD7gW7U0mLy3oP3Owj1HZnyzWCOc6aXQEuStJDxNCg+gCCLwLOUohp9jIPL18g1B3KrFIaLdbLxT3GdXHDyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408543; c=relaxed/simple;
	bh=J7L90U4nRH78G/ZUEsKpU7EKlK78k9IWfp5glK/6F7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PH85+Qg3ZLA1TzxWOmL2F4dV/4HBv6rLSx2YCVT2BUkycgFwTA/vrvDBegtlW1mkReC1DJdzkDlICCJ47VSPXLhufEGrPFXQCu5BIMYC5LBg502Sh/AfKoBFopZG1nf3rOMKIKrW8s3GxwCIeW34ZBwr0AUxuIHyGx39nYV4unc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1nCU1U/l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1nCU1U/l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27F26C4CED6;
	Mon, 24 Feb 2025 14:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408543;
	bh=J7L90U4nRH78G/ZUEsKpU7EKlK78k9IWfp5glK/6F7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1nCU1U/lwwBsUyYgW2Sb5OyjQrxcKyIIN5i243y4q1dm2hXxh8SW9hEH2RVvzSdUL
	 ZuyxuNw3MtABs/q2k0Z2AlM4OK01epQkoj6zTK5u3xT6J13Sff8VQ6dLs2bPkamRVo
	 0LjKcahGda60ClLk4Sce6M8eF81Lwi3G4XRMBowQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrick Wildt <patrick@blueri.se>,
	Niklas Cassel <cassel@kernel.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 087/154] arm64: dts: rockchip: adjust SMMU interrupt type on rk3588
Date: Mon, 24 Feb 2025 15:34:46 +0100
Message-ID: <20250224142610.480835318@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index fc67585b64b7b..1fd8093f2124c 100644
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




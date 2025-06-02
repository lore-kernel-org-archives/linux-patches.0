Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3B611CBA18;
	Mon,  2 Jun 2025 14:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874459; cv=none; b=DxHYJDJ76EimbAgFTIl+EQfZPupCxT/PtzyJfyakti7vUHHawZzSUgMbZBnla5oOUw+Va+0w5xs3JgUoMVGdt91ZQX9yOKacv3Jt0Osuto+4RgjLBIqXg7lHL57eO8BEDrLjH/WsA2+IxndlU2ryU3XLhy8UKZkeHlBsLtVx5jQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874459; c=relaxed/simple;
	bh=fikL6MgJ+qCm5y0+elrR1eIQ7uZbpiwStvK+szkGRVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J8QPntyKC3yTw+2K3585Rk8RlwXvhcDk+1k+tDrVnTKPaiwiLbTrHKlB3ELhK/B98H5lIh8AILGcvkogvKbw7VMIgIXwhM4suqW20CjR3/EjG27t4Lt53aurWCMel00OAZHoyBHwBIzPsV0nMtfJ7zuReH5NEOwyloKMKeCXyAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G8hrH2ed; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G8hrH2ed"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9EEAC4CEEB;
	Mon,  2 Jun 2025 14:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874459;
	bh=fikL6MgJ+qCm5y0+elrR1eIQ7uZbpiwStvK+szkGRVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G8hrH2edPFR4D60kLqxhCnHeAaIOD3ANW4twmIhErPnBEgvWI2JH+XHv1eK0tDe6x
	 yKpLZP+5EW22al2MdqjMvD2cd+olPvEKPkRz/t9jbVvnijrYLpDmfK+r2tkUzMgg1u
	 VmJL15MAcI0NBUgu58TAUUYWveRo2K45XuqOH/og=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 030/204] arm64: dts: rockchip: fix iface clock-name on px30 iommus
Date: Mon,  2 Jun 2025 15:46:03 +0200
Message-ID: <20250602134256.864945464@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Stuebner <heiko@sntech.de>

[ Upstream commit 8e57eed2047b9361deb8c5dc4cc3d4e679c5ce50 ]

The iommu clock names are aclk+iface not aclk+hclk as in the vendor kernel,
so fix that in the px30.dtsi

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://lore.kernel.org/r/20190917082659.25549-1-heiko@sntech.de
Stable-dep-of: 8dee308e4c01 ("iommu/amd: Fix potential buffer overflow in parse_ivrs_acpihid")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/px30.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/px30.dtsi b/arch/arm64/boot/dts/rockchip/px30.dtsi
index 652998c836406..aff72ebfc68d0 100644
--- a/arch/arm64/boot/dts/rockchip/px30.dtsi
+++ b/arch/arm64/boot/dts/rockchip/px30.dtsi
@@ -839,7 +839,7 @@
 		interrupts = <GIC_SPI 77 IRQ_TYPE_LEVEL_HIGH>;
 		interrupt-names = "vopb_mmu";
 		clocks = <&cru ACLK_VOPB>, <&cru HCLK_VOPB>;
-		clock-names = "aclk", "hclk";
+		clock-names = "aclk", "iface";
 		power-domains = <&power PX30_PD_VO>;
 		#iommu-cells = <0>;
 		status = "disabled";
@@ -871,7 +871,7 @@
 		interrupts = <GIC_SPI 78 IRQ_TYPE_LEVEL_HIGH>;
 		interrupt-names = "vopl_mmu";
 		clocks = <&cru ACLK_VOPL>, <&cru HCLK_VOPL>;
-		clock-names = "aclk", "hclk";
+		clock-names = "aclk", "iface";
 		power-domains = <&power PX30_PD_VO>;
 		#iommu-cells = <0>;
 		status = "disabled";
-- 
2.39.5




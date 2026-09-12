Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCAEE3612F6;
	Sat, 12 Sep 2026 07:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199927; cv=none; b=bH1zT3CeZfblF1fEtWHW6TYI5L+LqEugwrh6LMN3VpZJFDU/d1+aAoB9LfDbm4VfqkBZCCvSw+VYFVGhD0dVDbqf782jikJrVh4VgRLQkiqKxYs5ZHMjR7bG6tPWBtyXyg3VqGTcJLqgoW953r/ixMbeSjyxAoixirI3C12K3gU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199927; c=relaxed/simple;
	bh=0pesRuBabeRXUg1+xbh/5lNex61gd+z/U5/VuDr9TWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RV94krKOeg6Ri5/bDNvPAXThwEolV0qCp5czjGeLRPWl51UNqluzIaKKKbUTma3Tb3o49ZgNUpWC5LmrTuCLy5eVDt8yThQyksiXVLzb8ZRF8tZ0gOc+xMiUWOIVRULifFNlCWpVszVUzZi6PBe34AMSCRiF/+pJTSsTUo29U8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DaIsRRjB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DaIsRRjB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 963901F000FF;
	Sat, 12 Sep 2026 07:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199925;
	bh=e1Sc5R2zSFWOPogJB1wOOMDIVCeOlLk0wqTX/5pGMfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DaIsRRjBy9yINsQWm9URaYJM/wDyoG3RIuueI91CyinX7CiidPl3vvPX6ZNEcuneK
	 /mUiu4GFLr4rss168sdC0P4Hl19paW7lkK9E49xuUrq/oM1SRYTQ0lSBhx1CI6d2HE
	 z5iUejLjyzMMZS8Eil2D3GSlV9tllW5zVZ/LFXIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damon Ding <damon.ding@rock-chips.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0642/1815] arm64: dts: rockchip: Add missing hclk for RK3588 eDP0
Date: Sat, 12 Sep 2026 08:39:52 +0200
Message-ID: <20260912065703.951940921@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damon Ding <damon.ding@rock-chips.com>

[ Upstream commit ede2ee37f0a445cacbf24760f53befa10f64994a ]

Add the required HCLK_VO1 bus clock to RK3588 eDP0 node with
corresponding clock-name "hclk". This clock is necessary for the
eDP controller to access video output GRF and work properly.

Previously the clock was enabled implicitly via GRF phandle
reference. Add it explicitly now to align with updated binding.

Fixes: dc79d3d5e7c7 ("arm64: dts: rockchip: Add eDP0 node for RK3588")
Signed-off-by: Damon Ding <damon.ding@rock-chips.com>
Link: https://patch.msgid.link/20260605022305.3058853-2-damon.ding@rock-chips.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3588-base.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3588-base.dtsi b/arch/arm64/boot/dts/rockchip/rk3588-base.dtsi
index fc1fdbfd31622..376ad04e07869 100644
--- a/arch/arm64/boot/dts/rockchip/rk3588-base.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3588-base.dtsi
@@ -1910,8 +1910,8 @@ hdmi0_out: port@1 {
 	edp0: edp@fdec0000 {
 		compatible = "rockchip,rk3588-edp";
 		reg = <0x0 0xfdec0000 0x0 0x1000>;
-		clocks = <&cru CLK_EDP0_24M>, <&cru PCLK_EDP0>;
-		clock-names = "dp", "pclk";
+		clocks = <&cru CLK_EDP0_24M>, <&cru PCLK_EDP0>, <&cru HCLK_VO1>;
+		clock-names = "dp", "pclk", "hclk";
 		interrupts = <GIC_SPI 163 IRQ_TYPE_LEVEL_HIGH 0>;
 		phys = <&hdptxphy0>;
 		phy-names = "dp";
-- 
2.53.0




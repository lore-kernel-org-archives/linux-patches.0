Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C008429005;
	Sat, 12 Sep 2026 10:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208195; cv=none; b=YbSeUlQK81U5823QyQnhRMJSb58vTw+FQkXfLzzNkLM87jT6Rf6klNnObS4+eb57N6Znn7aYvWh2Li6M6fiDyf8zGrpBGzF0YowDMtKK7UFKeVvQ2Eyc1YPe+T3B5DeT7Z0Pmk6Ocz5o7TjFebBvVjOu8baZ6pq9ny4OdeTbjKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208195; c=relaxed/simple;
	bh=gY4yLoyBqFRvhPJbXKUVWH+u/Evz/Pb8CdX+VvmEeyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t0h80VN3iVAf/54kiTB36gnse7SCgFxlVXY+acxX3sZxzXsEU2zLfKv24NNSKTHRWVxI923nGUo55AeB/79GS/E4XX11Y2a6XWhddaqhdd8LAtOV7Jna1Dr+Hi5Krjt+xu+kquP0P5CZA5OppmFzQhjHarq7hXoMcBIoe4zSwWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RKEqyiMJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RKEqyiMJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21A8F1F00893;
	Sat, 12 Sep 2026 10:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208187;
	bh=ASSbLLO8kVXwhVocJrtmoAAKxSZYFDEt1gKrkB0Cj6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RKEqyiMJtZI7yfd4LhtRdhQyShk8qsYBmG1HlFlh7x69s6SleSuvcZt2t3GprOgS3
	 Sj1dZiD3cKfZ0OAZl8ETQOGrkKiNuKQ/ybZugXl30pUmNoyS06gd0b6O02DDhvbeNj
	 pgNKLcq+pjdS2csN92zPtwB9ndSLorOtdoYvaFFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damon Ding <damon.ding@rock-chips.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0568/1518] arm64: dts: rockchip: Add missing hclk for RK3588 eDP1
Date: Sat, 12 Sep 2026 08:45:37 +0200
Message-ID: <20260912065636.280051757@linuxfoundation.org>
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

From: Damon Ding <damon.ding@rock-chips.com>

[ Upstream commit 09820811c549ee2c408defe36b210b13c7a85fcf ]

Add the required HCLK_VO1 bus clock to RK3588 eDP1 node with
corresponding clock-name "hclk". This clock is necessary for
the eDP controller to access video output GRF and work properly.

Previously the clock was enabled implicitly via GRF phandle
reference. Add it explicitly now to align with updated binding.

Fixes: a481bb0b1ad9 ("arm64: dts: rockchip: Add eDP1 dt node for rk3588")
Signed-off-by: Damon Ding <damon.ding@rock-chips.com>
Link: https://patch.msgid.link/20260605022305.3058853-3-damon.ding@rock-chips.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3588-extra.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3588-extra.dtsi b/arch/arm64/boot/dts/rockchip/rk3588-extra.dtsi
index a2640014ee042..b251bb129cdbf 100644
--- a/arch/arm64/boot/dts/rockchip/rk3588-extra.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3588-extra.dtsi
@@ -285,8 +285,8 @@ hdmi1_out: port@1 {
 	edp1: edp@fded0000 {
 		compatible = "rockchip,rk3588-edp";
 		reg = <0x0 0xfded0000 0x0 0x1000>;
-		clocks = <&cru CLK_EDP1_24M>, <&cru PCLK_EDP1>;
-		clock-names = "dp", "pclk";
+		clocks = <&cru CLK_EDP1_24M>, <&cru PCLK_EDP1>, <&cru HCLK_VO1>;
+		clock-names = "dp", "pclk", "hclk";
 		interrupts = <GIC_SPI 164 IRQ_TYPE_LEVEL_HIGH 0>;
 		phys = <&hdptxphy1>;
 		phy-names = "dp";
-- 
2.53.0




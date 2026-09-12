Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ECEF37B036;
	Sat, 12 Sep 2026 10:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208190; cv=none; b=UclLOfu5EsGJhgaLB7yu6WJysw7iu10+Hhg6loU8m3tSVxeX+8Do817cIxJCCNfWPtHL4tiZ8KAg6QxA11Nuxr/5EVVDIvA8s3g3nb++f3L0POmvdm1CPT3JH0lA+zCa6KHRksrN+hN79xnJB5eGMRVFWAc5yVVa6ZmId9rlNbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208190; c=relaxed/simple;
	bh=9TynxuuXqtQqnbqPxMl/nmFj2m1sTd/hHO8AJqjmwH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KJeLfqxk4VWgCZGZsIyLvsCQ67+dc4bKVvNEeu2BvR5o9Q7T5mEOX6zlAkl31LqQJSZnCGpDItLfvoTdwZQY7/OX9/qeACp6zxsQfD3yKhQMFA5DeFxIN2+m7hxnLxUFo2LQ1PPk5t3FuKIj9u76TcQkshz/qIXJEMQ8aM4sV/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JcgXJezR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JcgXJezR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6BC81F000FF;
	Sat, 12 Sep 2026 10:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208184;
	bh=GBGQSU2L8bdWFcNMnly9+HVbEXotqbc+y9We29V1bNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JcgXJezRrYTB1jFe8aCGmEq+x/eXJsAfSkaGTY23XecpYbjnMtTIecuFHmyeullSJ
	 ev2yX0GXCoi5U0snVrGdIHZaGysdmj2xkztSisEudr6+0gbSmxRLORudh6K6G3yxRr
	 9S+AJzlgN0fx5Z+OUMnBuzgPV4WpG2mMQKerNel8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damon Ding <damon.ding@rock-chips.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0567/1518] arm64: dts: rockchip: Add missing hclk for RK3588 eDP0
Date: Sat, 12 Sep 2026 08:45:36 +0200
Message-ID: <20260912065636.256864954@linuxfoundation.org>
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
index 7e74e04057cfd..a031f42c558ed 100644
--- a/arch/arm64/boot/dts/rockchip/rk3588-base.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3588-base.dtsi
@@ -1648,8 +1648,8 @@ hdmi0_out: port@1 {
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




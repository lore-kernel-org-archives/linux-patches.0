Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214230;
	b=NZRf4I4vuuUBLCg65Of7zzVS9ULVnndeUmznOlBottyLTAXkdAx5hwJOfpigYZAnL3WD
	 sbhAm7kVscWuHhwrJXYlSgtzfPpaU7GTmGxf7O80LaF8fPFVC+x7sFWNiDYvcu6UlJhuR
	 Wu7/hooTIDcUL7sssvB4DD9E8QBgMLOsgfDQTv0ZfhCIPiXpvBWEJpvkiF6N2ua3ccLsy
	 Mwh5+DET3hYqdKOjOn7O2+JpkZa7cuOQdeUx+L7yMMf5nNIceJCNDP6i7A09KiZzr9YRn
	 Od1mTD6YqZDhD3Y5IvEXAKijOGFy+39cIm6xKyh6Zvzxl/IXoE4fr0nJgF9kRoUQ09A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214230;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lxsgy+5WSV7qZsX9/as8XL2vg/nGD0qZLLFD3Ye9r1o=;
	b=O+Qmk8G6zZ8aOd77Zd9kly9G0MKPcYkXbSGr9+QWO6RsY7Mz2O9idAJk5+OLHd5EowLf
	 FzTqX/x4zbc+vKLcPCX7KPZN6fRqLhoamCc6piKnp1oZQvhoExa1QQJdbNI4HZgcdrIF7
	 stNKRdUH05qcQzGmwm0pk3Lf4aTzidC01cUgwEKm1mHaeSex1helm32YzTn2Taj5aiHvu
	 k2r8rcoZ+zpN+cIZYFXxlz3zGBFrbvobtUcVYC5aRnpitpVKoBzubPx7EV62FKCUJ+B0l
	 X3aAA0kmVO5qZj9d567Occg/ANPqdYdoXzr9pnoZ7ipryJ6Tgxbvr1ObjEZ/Z+SAC4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lG9ZCXVI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B457D606A329;
	Wed, 28 Oct 2026 19:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lG9ZCXVI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 112831F01825;
	Wed, 28 Oct 2026 19:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214229;
	bh=lxsgy+5WSV7qZsX9/as8XL2vg/nGD0qZLLFD3Ye9r1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lG9ZCXVITthJRbgzLESJwL/VxfjhrktnTR2zpoxMn4aClxphCcpoKegzO1HEoJgdn
	 dZ6CGm/w4wfq36KA6Q6YfQENfnrp0g669ssJKujX+kjt+IezZ9J2uLo26EudL3G5w5
	 lE6wi0bt0Fhi7hJaoiDoGtq5OJ53z8pkqFfbG5X0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andre Przywara <andre.przywara@arm.com>,
	Evgeny Boger <boger@wirenboard.com>,
	Chen-Yu Tsai <wens@csie.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0785/1887] clk: sunxi-ng: h616: Reparent CPU clock during frequency changes
Date: Wed, 28 Oct 2026 17:48:01 +0100
Message-ID: <20261028170517.301743917@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andre Przywara <andre.przywara@arm.com>

[ Upstream commit 087b4083d3f9d202266debc6b684b0662c96f51b ]

The H616 user manual recommends to re-parent the CPU clock during
frequency changes of the PLL, and recommends PLL_PERI0(1X), which runs
at 600 MHz. Also it asks to disable and then re-enable the PLL lock bit,
after the factor changes have been applied.

Add clock notifiers for the PLL and the CPU mux clock, using the existing
notifier callbacks, and tell them to use mux 4 (the PLL_PERI0(1X) source),
and bit 29 (the LOCK_ENABLE) bit. The existing code already follows the
correct algorithms.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Link: https://lore.kernel.org/r/20241025105620.1891596-1-andre.przywara@arm.com
Tested-by: Evgeny Boger <boger@wirenboard.com>
Reviewed-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Stable-dep-of: eb963d7948ce ("clk: sunxi-ng: h616: Reparent GPU clock during frequency changes")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/sunxi-ng/ccu-sun50i-h616.c | 28 ++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/sunxi-ng/ccu-sun50i-h616.c b/drivers/clk/sunxi-ng/ccu-sun50i-h616.c
index 21e918582aa56..e52f94822aff8 100644
--- a/drivers/clk/sunxi-ng/ccu-sun50i-h616.c
+++ b/drivers/clk/sunxi-ng/ccu-sun50i-h616.c
@@ -1090,11 +1090,24 @@ static const u32 usb2_clk_regs[] = {
 	SUN50I_H616_USB3_CLK_REG,
 };
 
+static struct ccu_mux_nb sun50i_h616_cpu_nb = {
+	.common		= &cpux_clk.common,
+	.cm		= &cpux_clk.mux,
+	.delay_us	= 1, /* manual doesn't really say */
+	.bypass_index	= 4, /* PLL_PERI0@600MHz, as recommended by manual */
+};
+
+static struct ccu_pll_nb sun50i_h616_pll_cpu_nb = {
+	.common		= &pll_cpux_clk.common,
+	.enable		= BIT(29),	/* LOCK_ENABLE */
+	.lock		= BIT(28),
+};
+
 static int sun50i_h616_ccu_probe(struct platform_device *pdev)
 {
 	void __iomem *reg;
 	u32 val;
-	int i;
+	int ret, i;
 
 	reg = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(reg))
@@ -1147,7 +1160,18 @@ static int sun50i_h616_ccu_probe(struct platform_device *pdev)
 	val |= BIT(24);
 	writel(val, reg + SUN50I_H616_HDMI_CEC_CLK_REG);
 
-	return devm_sunxi_ccu_probe(&pdev->dev, reg, &sun50i_h616_ccu_desc);
+	ret = devm_sunxi_ccu_probe(&pdev->dev, reg, &sun50i_h616_ccu_desc);
+	if (ret)
+		return ret;
+
+	/* Reparent CPU during CPU PLL rate changes */
+	ccu_mux_notifier_register(pll_cpux_clk.common.hw.clk,
+				  &sun50i_h616_cpu_nb);
+
+	/* Re-lock the CPU PLL after any rate changes */
+	ccu_pll_notifier_register(&sun50i_h616_pll_cpu_nb);
+
+	return 0;
 }
 
 static const struct of_device_id sun50i_h616_ccu_ids[] = {
-- 
2.53.0




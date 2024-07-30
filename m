Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C739114831F;
	Tue, 30 Jul 2024 16:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358097; cv=none; b=CKthiBsLfFzvqunURaqYCEULmNrwVIKkxR7+u17L+8C0ePIKsZtIy3ylfymdVKoPOhIFpoIbhi5/Pqibnfd4K29CGnHKflXKq9CyAduOplD3M/LZc1xuISe7Pq6g41LIxpDje3QGKYqZyd7ztL11Ie5P/57vPFPaRxI/9BiMe4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358097; c=relaxed/simple;
	bh=h2RBh2gxqvMe5+rUcL8V7DSfvkn7WYYSM7zdo1EEfec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TolTes/sENtzcxvOVnC7xleacQWepPFdJfzuVnwh7sov6kUxllVogS6KnIkb9fD4+hDQTadY4VU9yDxnJaG7IPrHt2E68e9fo2SVzt4jW321ZSap98M4HuyE1Oj2GjmJS5ydAmUsOO031grlGCl/BTW3x0857PoCcFECB4MT68k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HUEpjOqj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HUEpjOqj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38D07C32782;
	Tue, 30 Jul 2024 16:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358097;
	bh=h2RBh2gxqvMe5+rUcL8V7DSfvkn7WYYSM7zdo1EEfec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HUEpjOqjVm4S3znjiW/xeU9gUlXAijtbSrcI7sk6yFFiGwkUMRrb8KDUmMYl2iD6J
	 ZM/VF99sQqeVU7kGoO2G6Aa0GsDmo26o3+w16Rs5gTTlDvlU0sVT9mfO1llgfrBrjB
	 1P+242OuLq1uub/NdmzR2V5sUXxKPBjY+Ral14L0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Yashin <dmt.yashin@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 325/568] pinctrl: rockchip: update rk3308 iomux routes
Date: Tue, 30 Jul 2024 17:47:12 +0200
Message-ID: <20240730151652.577710520@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Yashin <dmt.yashin@gmail.com>

[ Upstream commit a8f2548548584549ea29d43431781d67c4afa42b ]

Some of the rk3308 iomux routes in rk3308_mux_route_data belong to
the rk3308b SoC. Remove them and correct i2c3 routes.

Fixes: 7825aeb7b208 ("pinctrl: rockchip: add rk3308 SoC support")
Signed-off-by: Dmitry Yashin <dmt.yashin@gmail.com>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Link: https://lore.kernel.org/r/20240515121634.23945-2-dmt.yashin@gmail.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-rockchip.c | 17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-rockchip.c b/drivers/pinctrl/pinctrl-rockchip.c
index caf8d0a98c327..b02eaba010d10 100644
--- a/drivers/pinctrl/pinctrl-rockchip.c
+++ b/drivers/pinctrl/pinctrl-rockchip.c
@@ -915,9 +915,8 @@ static struct rockchip_mux_route_data rk3308_mux_route_data[] = {
 	RK_MUXROUTE_SAME(0, RK_PC3, 1, 0x314, BIT(16 + 0) | BIT(0)), /* rtc_clk */
 	RK_MUXROUTE_SAME(1, RK_PC6, 2, 0x314, BIT(16 + 2) | BIT(16 + 3)), /* uart2_rxm0 */
 	RK_MUXROUTE_SAME(4, RK_PD2, 2, 0x314, BIT(16 + 2) | BIT(16 + 3) | BIT(2)), /* uart2_rxm1 */
-	RK_MUXROUTE_SAME(0, RK_PB7, 2, 0x608, BIT(16 + 8) | BIT(16 + 9)), /* i2c3_sdam0 */
-	RK_MUXROUTE_SAME(3, RK_PB4, 2, 0x608, BIT(16 + 8) | BIT(16 + 9) | BIT(8)), /* i2c3_sdam1 */
-	RK_MUXROUTE_SAME(2, RK_PA0, 3, 0x608, BIT(16 + 8) | BIT(16 + 9) | BIT(9)), /* i2c3_sdam2 */
+	RK_MUXROUTE_SAME(0, RK_PB7, 2, 0x314, BIT(16 + 4)), /* i2c3_sdam0 */
+	RK_MUXROUTE_SAME(3, RK_PB4, 2, 0x314, BIT(16 + 4) | BIT(4)), /* i2c3_sdam1 */
 	RK_MUXROUTE_SAME(1, RK_PA3, 2, 0x308, BIT(16 + 3)), /* i2s-8ch-1-sclktxm0 */
 	RK_MUXROUTE_SAME(1, RK_PA4, 2, 0x308, BIT(16 + 3)), /* i2s-8ch-1-sclkrxm0 */
 	RK_MUXROUTE_SAME(1, RK_PB5, 2, 0x308, BIT(16 + 3) | BIT(3)), /* i2s-8ch-1-sclktxm1 */
@@ -926,18 +925,6 @@ static struct rockchip_mux_route_data rk3308_mux_route_data[] = {
 	RK_MUXROUTE_SAME(1, RK_PB6, 4, 0x308, BIT(16 + 12) | BIT(16 + 13) | BIT(12)), /* pdm-clkm1 */
 	RK_MUXROUTE_SAME(2, RK_PA6, 2, 0x308, BIT(16 + 12) | BIT(16 + 13) | BIT(13)), /* pdm-clkm2 */
 	RK_MUXROUTE_SAME(2, RK_PA4, 3, 0x600, BIT(16 + 2) | BIT(2)), /* pdm-clkm-m2 */
-	RK_MUXROUTE_SAME(3, RK_PB2, 3, 0x314, BIT(16 + 9)), /* spi1_miso */
-	RK_MUXROUTE_SAME(2, RK_PA4, 2, 0x314, BIT(16 + 9) | BIT(9)), /* spi1_miso_m1 */
-	RK_MUXROUTE_SAME(0, RK_PB3, 3, 0x314, BIT(16 + 10) | BIT(16 + 11)), /* owire_m0 */
-	RK_MUXROUTE_SAME(1, RK_PC6, 7, 0x314, BIT(16 + 10) | BIT(16 + 11) | BIT(10)), /* owire_m1 */
-	RK_MUXROUTE_SAME(2, RK_PA2, 5, 0x314, BIT(16 + 10) | BIT(16 + 11) | BIT(11)), /* owire_m2 */
-	RK_MUXROUTE_SAME(0, RK_PB3, 2, 0x314, BIT(16 + 12) | BIT(16 + 13)), /* can_rxd_m0 */
-	RK_MUXROUTE_SAME(1, RK_PC6, 5, 0x314, BIT(16 + 12) | BIT(16 + 13) | BIT(12)), /* can_rxd_m1 */
-	RK_MUXROUTE_SAME(2, RK_PA2, 4, 0x314, BIT(16 + 12) | BIT(16 + 13) | BIT(13)), /* can_rxd_m2 */
-	RK_MUXROUTE_SAME(1, RK_PC4, 3, 0x314, BIT(16 + 14)), /* mac_rxd0_m0 */
-	RK_MUXROUTE_SAME(4, RK_PA2, 2, 0x314, BIT(16 + 14) | BIT(14)), /* mac_rxd0_m1 */
-	RK_MUXROUTE_SAME(3, RK_PB4, 4, 0x314, BIT(16 + 15)), /* uart3_rx */
-	RK_MUXROUTE_SAME(0, RK_PC1, 3, 0x314, BIT(16 + 15) | BIT(15)), /* uart3_rx_m1 */
 };
 
 static struct rockchip_mux_route_data rk3328_mux_route_data[] = {
-- 
2.43.0




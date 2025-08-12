Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4ABD191F98;
	Tue, 12 Aug 2025 18:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023521; cv=none; b=hVvo4j0SOZGKULPa6w5xR18T0N62UcQj73Y2KscU4wSsBlYA+jIU1g+yQAw0MGcGI5SrvJDUACBVVC4pkeevFgzTjz4MOpsf4rLZqikN7JVZuKRor4/z/f6wRNIeWwCC9lBgwHXgAWmn8wPN/tRybynqHkgxH+ApEM7oMbRxsRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023521; c=relaxed/simple;
	bh=3DBAJFTsUohV2XsA1LvEqGhKuaRHoYFp/p4ZztGii4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MylXgRtO8PuFB7MWZJ9HiI1eh7Hz0JL8VThfv27HPP+YIT69lQv/Ruqm6PPgf+RMk2F/iOHnrHIUf2fHC2gKkmwLVvcwsuoNo7lo0mNdlZwfT80skXDIYDdeJRmfjJ8OijbVl3+7KPEmr6biG3tGPxxlZ1IJKAY//b6nlSk9wAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FZ43neWC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FZ43neWC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FC8DC4CEF0;
	Tue, 12 Aug 2025 18:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023521;
	bh=3DBAJFTsUohV2XsA1LvEqGhKuaRHoYFp/p4ZztGii4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FZ43neWC4GhkpMviDeD15EVW+K9bQELQog+ei+jXdh+Wm6PSvsXQqIXweNM+i9WsU
	 Un9pSQ3Ahzbfd/QTcxdD2aiIWbWdjadutaI7okhzBMLubPuKz6xeKTOoXNWOmK34Sz
	 ZW1XXSYLUIo1PwPfMFhR8XzqpC9SAv5IIOqDLjBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Karlman <jonas@kwiboo.se>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 105/627] arm64: dts: rockchip: Fix pinctrl node names for RK3528
Date: Tue, 12 Aug 2025 19:26:40 +0200
Message-ID: <20250812173423.310638929@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Karlman <jonas@kwiboo.se>

[ Upstream commit f2792bf1c7a54ef23fb3a84286b66f427bfc4853 ]

Following warnings can be observed with CHECK_DTBS=y for the RK3528:

  rk3528-pinctrl.dtsi:101.36-105.5: Warning (node_name_chars_strict):
    /pinctrl/fephy/fephym0-led_dpx: Character '_' not recommended in node name
  rk3528-pinctrl.dtsi:108.38-112.5: Warning (node_name_chars_strict):
    /pinctrl/fephy/fephym0-led_link: Character '_' not recommended in node name
  rk3528-pinctrl.dtsi:115.36-119.5: Warning (node_name_chars_strict):
    /pinctrl/fephy/fephym0-led_spd: Character '_' not recommended in node name
  rk3528-pinctrl.dtsi:122.36-126.5: Warning (node_name_chars_strict):
   /pinctrl/fephy/fephym1-led_dpx: Character '_' not recommended in node name
  rk3528-pinctrl.dtsi:129.38-133.5: Warning (node_name_chars_strict):
    /pinctrl/fephy/fephym1-led_link: Character '_' not recommended in node name
  rk3528-pinctrl.dtsi:136.36-140.5: Warning (node_name_chars_strict):
    /pinctrl/fephy/fephym1-led_spd: Character '_' not recommended in node name
  rk3528-pinctrl.dtsi:782.32-790.5: Warning (node_name_chars_strict):
    /pinctrl/rgmii/rgmii-rx_bus2: Character '_' not recommended in node name
  rk3528-pinctrl.dtsi:793.32-801.5: Warning (node_name_chars_strict):
    /pinctrl/rgmii/rgmii-tx_bus2: Character '_' not recommended in node name
  rk3528-pinctrl.dtsi:804.36-810.5: Warning (node_name_chars_strict):
    /pinctrl/rgmii/rgmii-rgmii_clk: Character '_' not recommended in node name
  rk3528-pinctrl.dtsi:813.36-823.5: Warning (node_name_chars_strict):
    /pinctrl/rgmii/rgmii-rgmii_bus: Character '_' not recommended in node name

Rename the affected nodes to fix these warnings.

Fixes: a31fad19ae39 ("arm64: dts: rockchip: Add pinctrl and gpio nodes for RK3528")
Signed-off-by: Jonas Karlman <jonas@kwiboo.se>
Link: https://lore.kernel.org/r/20250621113859.2146400-1-jonas@kwiboo.se
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/rockchip/rk3528-pinctrl.dtsi     | 20 +++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3528-pinctrl.dtsi b/arch/arm64/boot/dts/rockchip/rk3528-pinctrl.dtsi
index ea051362fb26..59b75c91bbb7 100644
--- a/arch/arm64/boot/dts/rockchip/rk3528-pinctrl.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3528-pinctrl.dtsi
@@ -98,42 +98,42 @@ eth_pins: eth-pins {
 
 	fephy {
 		/omit-if-no-ref/
-		fephym0_led_dpx: fephym0-led_dpx {
+		fephym0_led_dpx: fephym0-led-dpx {
 			rockchip,pins =
 				/* fephy_led_dpx_m0 */
 				<4 RK_PB5 2 &pcfg_pull_none>;
 		};
 
 		/omit-if-no-ref/
-		fephym0_led_link: fephym0-led_link {
+		fephym0_led_link: fephym0-led-link {
 			rockchip,pins =
 				/* fephy_led_link_m0 */
 				<4 RK_PC0 2 &pcfg_pull_none>;
 		};
 
 		/omit-if-no-ref/
-		fephym0_led_spd: fephym0-led_spd {
+		fephym0_led_spd: fephym0-led-spd {
 			rockchip,pins =
 				/* fephy_led_spd_m0 */
 				<4 RK_PB7 2 &pcfg_pull_none>;
 		};
 
 		/omit-if-no-ref/
-		fephym1_led_dpx: fephym1-led_dpx {
+		fephym1_led_dpx: fephym1-led-dpx {
 			rockchip,pins =
 				/* fephy_led_dpx_m1 */
 				<2 RK_PA4 5 &pcfg_pull_none>;
 		};
 
 		/omit-if-no-ref/
-		fephym1_led_link: fephym1-led_link {
+		fephym1_led_link: fephym1-led-link {
 			rockchip,pins =
 				/* fephy_led_link_m1 */
 				<2 RK_PA6 5 &pcfg_pull_none>;
 		};
 
 		/omit-if-no-ref/
-		fephym1_led_spd: fephym1-led_spd {
+		fephym1_led_spd: fephym1-led-spd {
 			rockchip,pins =
 				/* fephy_led_spd_m1 */
 				<2 RK_PA5 5 &pcfg_pull_none>;
@@ -779,7 +779,7 @@ rgmii_miim: rgmii-miim {
 		};
 
 		/omit-if-no-ref/
-		rgmii_rx_bus2: rgmii-rx_bus2 {
+		rgmii_rx_bus2: rgmii-rx-bus2 {
 			rockchip,pins =
 				/* rgmii_rxd0 */
 				<3 RK_PA3 2 &pcfg_pull_none>,
@@ -790,7 +790,7 @@ rgmii_rx_bus2: rgmii-rx_bus2 {
 		};
 
 		/omit-if-no-ref/
-		rgmii_tx_bus2: rgmii-tx_bus2 {
+		rgmii_tx_bus2: rgmii-tx-bus2 {
 			rockchip,pins =
 				/* rgmii_txd0 */
 				<3 RK_PA1 2 &pcfg_pull_none_drv_level_2>,
@@ -801,7 +801,7 @@ rgmii_tx_bus2: rgmii-tx_bus2 {
 		};
 
 		/omit-if-no-ref/
-		rgmii_rgmii_clk: rgmii-rgmii_clk {
+		rgmii_rgmii_clk: rgmii-rgmii-clk {
 			rockchip,pins =
 				/* rgmii_rxclk */
 				<3 RK_PA5 2 &pcfg_pull_none>,
@@ -810,7 +810,7 @@ rgmii_rgmii_clk: rgmii-rgmii_clk {
 		};
 
 		/omit-if-no-ref/
-		rgmii_rgmii_bus: rgmii-rgmii_bus {
+		rgmii_rgmii_bus: rgmii-rgmii-bus {
 			rockchip,pins =
 				/* rgmii_rxd2 */
 				<3 RK_PA7 2 &pcfg_pull_none>,
-- 
2.39.5




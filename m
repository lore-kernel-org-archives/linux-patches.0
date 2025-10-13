Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7765277CB8;
	Mon, 13 Oct 2025 15:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368910; cv=none; b=PB11IiZ2XwWCmDKTgZ8VzDg+iVzsjOge0Ax2CsHltThw9ZPRzGLb81y0i2S/gNbx7Q4f2b0vgHqHQkWEMnAk15sivcU9tnGdN0qtJwps8oz2kQfeI9NV8Jk92xlydYMpi+bXRI00mLos/cksY0oL/y+WZVA5voRtAytnvdvJP98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368910; c=relaxed/simple;
	bh=faKAE1hs4jgVnROFOfG3E5co0iJJ+gQ/EqfsP0Uqzpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aTKdeNA2qaZ/zNrTX5waOyY6NEgoyu6Q+BQ/lUuw8JXN9ojHjz3+FJwj00MCcmQwQQjxlpLFifZ3SP9OJzZhpptN78y6l0uz2CW7s+OKvuy2xJSoWF3cct981K/BM6rYBFaO1pOMyhJstioD+c/b86TUmUDVd/xPZA1XQwCew8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iUBhrSOK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iUBhrSOK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F24A8C4CEE7;
	Mon, 13 Oct 2025 15:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368910;
	bh=faKAE1hs4jgVnROFOfG3E5co0iJJ+gQ/EqfsP0Uqzpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iUBhrSOKTHVtFAa/t2h4l4y/CkQcFjvzo66cCrjTQ2b8mYvSwJ1AXnRYm83oUygxS
	 Jf04lhc4j7fBgMq6IQlL52UViKFF+EWrOloa/HQAHmUpcheVlY47YOVWuRaGXPQzrP
	 0RUeGxlEt8gfCAKLABX2p6vyffNLVPa/ETTaeGX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Annette Kobou <annette.kobou@kontron.de>,
	Frieder Schrempf <frieder.schrempf@kontron.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 062/563] arm64: dts: imx93-kontron: Fix GPIO for panel regulator
Date: Mon, 13 Oct 2025 16:38:43 +0200
Message-ID: <20251013144413.537363771@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Annette Kobou <annette.kobou@kontron.de>

[ Upstream commit f3e011388dd08d15e0414e3b6b974f946305e7af ]

The regulator uses the wrong GPIO. Fix this.

Signed-off-by: Annette Kobou <annette.kobou@kontron.de>
Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Fixes: 2b52fd6035b7 ("arm64: dts: Add support for Kontron i.MX93 OSM-S SoM and BL carrier board")
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/freescale/imx93-kontron-bl-osm-s.dts    | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx93-kontron-bl-osm-s.dts b/arch/arm64/boot/dts/freescale/imx93-kontron-bl-osm-s.dts
index 89e97c604bd3e..9a9e5d0daf3ba 100644
--- a/arch/arm64/boot/dts/freescale/imx93-kontron-bl-osm-s.dts
+++ b/arch/arm64/boot/dts/freescale/imx93-kontron-bl-osm-s.dts
@@ -33,7 +33,9 @@ pwm-beeper {
 
 	reg_vcc_panel: regulator-vcc-panel {
 		compatible = "regulator-fixed";
-		gpio = <&gpio4 3 GPIO_ACTIVE_HIGH>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_reg_vcc_panel>;
+		gpio = <&gpio2 21 GPIO_ACTIVE_HIGH>;
 		enable-active-high;
 		regulator-max-microvolt = <3300000>;
 		regulator-min-microvolt = <3300000>;
@@ -161,3 +163,11 @@ &usdhc2 {
 	vmmc-supply = <&reg_vdd_3v3>;
 	status = "okay";
 };
+
+&iomuxc {
+	pinctrl_reg_vcc_panel: regvccpanelgrp {
+		fsl,pins = <
+			MX93_PAD_GPIO_IO21__GPIO2_IO21		0x31e /* PWM_2 */
+		>;
+	};
+};
-- 
2.51.0




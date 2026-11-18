Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017060;
	b=g6dcbWG2+ZdO8XJZ1G/caTO7/mBrsO9Wq75b/6iNYNGbdj8ddFogWCoTSekc42V76lu0
	 dLQ/TbX3xqTXuorLRnKAzo3D1rzEMuUV7z91HtTnpzIqEZRZBTK7KlrW3XhSqiNjkqAn3
	 ujejiiHbvnPq3J5j3cpphP1sFLs2sP9MKIOJijnEmNOHZ04Q5qpj5sLIjqUXJQwTeGbtL
	 lGSRxOERdHj6yTFqqqxVG92B4b6QBeHr/GhR0dhWvNKXrzSCIpKNSzfA4JwcG+9idKvSl
	 N+OH74SUJQIwRYmlN7dVFxpbb9pJTEEBhq/Qj2X1vRhMxAUB63Yfqe4uoHk+iy0oIfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017060;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tIBKzTEkJflazxIJhu5FtWo5RauArD2trwCYwdeK5L8=;
	b=XkUopgYmDBKWaSp03AVOqMW/2/+1wv0SUfZJay4l6n6rPLePXgOgaPwhf4wgwz2eZY7c
	 DGoAkxBtc5IJXktiPGsa07XWwEuWsv12YJjAKz8+w7AmsQp8HUYAKtynASAlOQUUQoofu
	 /qPJbaWYRBFTBiQNnwadLgJbvpjpMVCzRSDlpszKnXXZa9nd+mUz9Tb2A8syqpwJRRfrt
	 6cHINhA8DyQONURlo+nZ8vWAIdBAnYlfwZZjP0AxCqAK9UBkQRBxmoLJJ1xXJ8r9hnnpe
	 kvGevRLS+/Qt3qmJdPIkirG9zdglLLd5Gg2PtZDjw5w7XHOXcIm9dXsqAartlH1wv9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A1KqNCrl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6160606A32A;
	Wed, 18 Nov 2026 15:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A1KqNCrl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 026441F000C4;
	Wed, 18 Nov 2026 15:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017060;
	bh=tIBKzTEkJflazxIJhu5FtWo5RauArD2trwCYwdeK5L8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A1KqNCrllYUKMnLfagTQGQPIwHjnTnKDOH/hvnIlOtJx0RKN9hagg4kLEVJJWuAAY
	 mj7caFyhmV09VemhDoFUtQ49F9jEIEscxjLC7jdwzDX6HjC6n5nKCCjdMEG7w4jMBf
	 3fKrOtC0Kf+L1FpOg5Auy7udCqNaPTGrfLXU8z94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oualid Derouiche <oualid.derouiche@kontron.de>,
	Frieder Schrempf <frieder.schrempf@kontron.de>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0751/2651] arm64: dts: imx8mp-kontron: Fix LVDS clock frequency for DL device
Date: Wed, 18 Nov 2026 15:33:11 +0100
Message-ID: <20261118150314.918821275@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oualid Derouiche <oualid.derouiche@kontron.de>

[ Upstream commit a5f316e602d3f5852fe2f88226fe64c8a495f479 ]

The panel needs a pixel clock of 50 MHz, which means the LDB
serializer has to run at 50 MHz * 7 = 350 MHz. The LDB rate itself
is set by the fsl-ldb driver, but VIDEO_PLL1 needs to be pinned to
700 MHz, so that both the LDB clock (/2) and the pixel clock (/14)
can be derived from it exactly.

Fixes: 946ab10e3f40 ("arm64: dts: Add support for Kontron OSM-S i.MX8MP SoM and BL carrier board")
Signed-off-by: Oualid Derouiche <oualid.derouiche@kontron.de>
Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-kontron-dl.dtso | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-kontron-dl.dtso b/arch/arm64/boot/dts/freescale/imx8mp-kontron-dl.dtso
index 41a2bb74f1565..88b30ca66adf5 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-kontron-dl.dtso
+++ b/arch/arm64/boot/dts/freescale/imx8mp-kontron-dl.dtso
@@ -6,6 +6,7 @@
 /dts-v1/;
 /plugin/;
 
+#include <dt-bindings/clock/imx8mp-clock.h>
 #include <dt-bindings/gpio/gpio.h>
 #include <dt-bindings/interrupt-controller/irq.h>
 #include "imx8mp-pinfunc.h"
@@ -99,6 +100,16 @@ &ldb_lvds_ch0 {
 
 &lvds_bridge {
 	status = "okay";
+	/*
+	 * The video PLL clock frequency needs to be configured manually.
+	 * The panel needs a LVDS clock of 50 MHz * 7 = 350 MHz.
+	 * IMX8MP_CLK_MEDIA_LDB = IMX8MP_CLK_MEDIA_DISP2_PIX * 7
+	 * IMX8MP_VIDEO_PLL1 = IMX8MP_CLK_MEDIA_LDB * 2
+	 */
+	assigned-clocks = <&clk IMX8MP_CLK_MEDIA_LDB>,
+			  <&clk IMX8MP_VIDEO_PLL1>;
+	assigned-clock-parents = <&clk IMX8MP_VIDEO_PLL1_OUT>;
+	assigned-clock-rates = <0>, <700000000>;
 };
 
 /* redefine to remove touch controller GPIOs */
-- 
2.53.0




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024283;
	b=y2233kVA5NE9ZmZScoi94dUDBku5ifqwSlYgRdGBwXdArMy67Lpzo+sPIRvWh6NBBoih
	 nVpmqQNYb7Vit1odk3mcU1CwZm+pEvAWmDr8xa5FVrFe72UmkWrrdPXPhFrlfIJvoNeKm
	 b60WLyXBRlLAxSSE4MjI4+2PpB4tqDRoRIjrk2VgislvRU7tcPkri4PkZ06oVPY0PeheI
	 bKna+EHQtBqUcfJraZAmpkm/+SqXV3nj92ENiJyn0LosHn0g7WVW6wiXYKNBwYAZ3RsPy
	 kGV0FrmIXSFRBZQQvsCFSDk8DK+jlFPshN/MCJYOzu8gcz24ORNhUxBRzn6gS8bOTTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024283;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0ntIps/DShshIakJ9MDbrk8LYPbMqxzRCsCwaZm+Ti0=;
	b=u+bSPXeK8JQk6WcyOWGKjsb1FwENIT4bsf2NEdz/T0eb00og0+C+Ufnc7Ee74Y4UGLt/
	 1FvYZd5hJi+hnfGTr/ih16xGtXX4HYHuJyAFM1vqI4V6VrjRemr91AVQTbYzVl93CPwmt
	 KLL8XahQuldMtKHYJPywFt3qok5s400Pci1oD0MO695ghKYMx17x3qqK1RIuego4nSB8Z
	 xFw4NhGCYoUUsWe59atV8Ab8fERdE62YheVIw8MTyg+pR/yHTyypFklqQcwDxMGELJCWj
	 MJhaJ6lznVCd3dCcJVJBgmheR/Ceaiv6Th8LT/OtbYuVnJBNSuil9QZynmam3zzR9Mw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sIPbVkuX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4909D606A31C;
	Wed, 18 Nov 2026 17:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sIPbVkuX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 207D21F000C4;
	Wed, 18 Nov 2026 17:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024282;
	bh=0ntIps/DShshIakJ9MDbrk8LYPbMqxzRCsCwaZm+Ti0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sIPbVkuX8eaRsje/QPxB7gxLGdCK+C+uD7bF8430bOytal2EPHW29eGhbF4CGanas
	 RtMaYl92Ahhv8HEXeRs+ZzZMzWS/tMA7QeIn9Nya+0h+TBe04nMN5aGVmN3rP+hE77
	 5IuRlP/HpVlO2WBntA2dGRs4OzdYK44hMZDAO8DU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oualid Derouiche <oualid.derouiche@kontron.de>,
	Frieder Schrempf <frieder.schrempf@kontron.de>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0670/2151] arm64: dts: imx8mp-kontron: Fix LVDS clock frequency for DL device
Date: Wed, 18 Nov 2026 15:40:05 +0100
Message-ID: <20261118150146.224770045@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 7131e9a499ae1..7a7d7ea21110d 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-kontron-dl.dtso
+++ b/arch/arm64/boot/dts/freescale/imx8mp-kontron-dl.dtso
@@ -6,6 +6,7 @@
 /dts-v1/;
 /plugin/;
 
+#include <dt-bindings/clock/imx8mp-clock.h>
 #include <dt-bindings/gpio/gpio.h>
 #include "imx8mp-pinfunc.h"
 
@@ -98,6 +99,16 @@ &ldb_lvds_ch0 {
 
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




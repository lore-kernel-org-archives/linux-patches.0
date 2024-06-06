Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8EC419D09B;
	Thu,  6 Jun 2024 14:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683093; cv=none; b=qQvFQitSHTaY8Uc95/Z8sqH/Gz25j6Q8ytAQeOQaaggYMNYUYjygxEsJTuwTwf1GeWOp6vVjKb2MrtmQw5VUaqD1gY1tuxfoBndsvZNnVXqafPeruHMuwQW6RVnmlPxTs6YyEluAEZZZLa1G2nP05niwTz9G/KvacRa0nxNMT5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683093; c=relaxed/simple;
	bh=gRAd/cFo2qs1KgX5lDtP4id55wB8XMEm58zwnOVhewc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ve9Bx/RMWP6i2u4+rIwNCQ0A21UwLODIGW+dw1i5YzY19LKDxbW9fV5L4g2W1RM5zRN4AY6UvAbVC1jvJK1pu707JjSU4e45tXhvJGee/9L7ZTIGVxGmQ6fAYHexfQSlqK8Xg+ikfrO5qP4Jcc0SVWqzfZMVAHyQSm+MsOcoDic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oQeLtTr+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oQeLtTr+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B50D1C4AF0F;
	Thu,  6 Jun 2024 14:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683093;
	bh=gRAd/cFo2qs1KgX5lDtP4id55wB8XMEm58zwnOVhewc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oQeLtTr+LoCdsqG2LlDiYsMWEIokCtlSshEwrN0inCQLymThYXJU++HIEYl7ANKPJ
	 07OCx6v3rx1Z0h33BBVNe/x1YtAJ9kB1O459G2cKRNPd+351RRQbwd2RdJtRs9/EVy
	 zpgPegRFAGbPWAApBQroX3lNowQEtU0W9YrqDSm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Arnd Bergmann <arnd@arndb.de>,
	Maxime Ripard <mripard@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.9 365/374] Revert "drm: Make drivers depends on DRM_DW_HDMI"
Date: Thu,  6 Jun 2024 16:05:44 +0200
Message-ID: <20240606131704.107673854@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

commit 8f7f115596d3dccedc06f5813e0269734f5cc534 upstream.

This reverts commit c0e0f139354c01e0213204e4a96e7076e5a3e396, as helper
code should always be selected by the driver that needs it, for the
convenience of the final user configuring a kernel.

The user who configures a kernel should not need to know which helpers
are needed for the driver he is interested in.  Making a driver depend
on helper code means that the user needs to know which helpers to enable
first, which is very user-unfriendly.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Link: https://patchwork.freedesktop.org/patch/msgid/bd93d43b07f8ed6368119f4a5ddac2ee80debe53.1713780345.git.geert+renesas@glider.be
Signed-off-by: Maxime Ripard <mripard@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/bridge/imx/Kconfig      |    4 ++--
 drivers/gpu/drm/imx/ipuv3/Kconfig       |    5 ++---
 drivers/gpu/drm/ingenic/Kconfig         |    2 +-
 drivers/gpu/drm/meson/Kconfig           |    2 +-
 drivers/gpu/drm/renesas/rcar-du/Kconfig |    2 +-
 drivers/gpu/drm/rockchip/Kconfig        |    2 +-
 drivers/gpu/drm/sun4i/Kconfig           |    2 +-
 7 files changed, 9 insertions(+), 10 deletions(-)

--- a/drivers/gpu/drm/bridge/imx/Kconfig
+++ b/drivers/gpu/drm/bridge/imx/Kconfig
@@ -5,9 +5,9 @@ config DRM_IMX_LDB_HELPER
 
 config DRM_IMX8MP_DW_HDMI_BRIDGE
 	tristate "Freescale i.MX8MP HDMI-TX bridge support"
-	depends on COMMON_CLK
-	depends on DRM_DW_HDMI
 	depends on OF
+	depends on COMMON_CLK
+	select DRM_DW_HDMI
 	imply DRM_IMX8MP_HDMI_PVI
 	imply PHY_FSL_SAMSUNG_HDMI_PHY
 	help
--- a/drivers/gpu/drm/imx/ipuv3/Kconfig
+++ b/drivers/gpu/drm/imx/ipuv3/Kconfig
@@ -35,8 +35,7 @@ config DRM_IMX_LDB
 
 config DRM_IMX_HDMI
 	tristate "Freescale i.MX DRM HDMI"
-	depends on DRM_DW_HDMI
-	depends on DRM_IMX
-	depends on OF
+	select DRM_DW_HDMI
+	depends on DRM_IMX && OF
 	help
 	  Choose this if you want to use HDMI on i.MX6.
--- a/drivers/gpu/drm/ingenic/Kconfig
+++ b/drivers/gpu/drm/ingenic/Kconfig
@@ -27,8 +27,8 @@ config DRM_INGENIC_IPU
 
 config DRM_INGENIC_DW_HDMI
 	tristate "Ingenic specific support for Synopsys DW HDMI"
-	depends on DRM_DW_HDMI
 	depends on MACH_JZ4780
+	select DRM_DW_HDMI
 	help
 	  Choose this option to enable Synopsys DesignWare HDMI based driver.
 	  If you want to enable HDMI on Ingenic JZ4780 based SoC, you should
--- a/drivers/gpu/drm/meson/Kconfig
+++ b/drivers/gpu/drm/meson/Kconfig
@@ -13,9 +13,9 @@ config DRM_MESON
 
 config DRM_MESON_DW_HDMI
 	tristate "HDMI Synopsys Controller support for Amlogic Meson Display"
-	depends on DRM_DW_HDMI
 	depends on DRM_MESON
 	default y if DRM_MESON
+	select DRM_DW_HDMI
 	imply DRM_DW_HDMI_I2S_AUDIO
 
 config DRM_MESON_DW_MIPI_DSI
--- a/drivers/gpu/drm/renesas/rcar-du/Kconfig
+++ b/drivers/gpu/drm/renesas/rcar-du/Kconfig
@@ -25,8 +25,8 @@ config DRM_RCAR_CMM
 config DRM_RCAR_DW_HDMI
 	tristate "R-Car Gen3 and RZ/G2 DU HDMI Encoder Support"
 	depends on DRM && OF
-	depends on DRM_DW_HDMI
 	depends on DRM_RCAR_DU || COMPILE_TEST
+	select DRM_DW_HDMI
 	help
 	  Enable support for R-Car Gen3 or RZ/G2 internal HDMI encoder.
 
--- a/drivers/gpu/drm/rockchip/Kconfig
+++ b/drivers/gpu/drm/rockchip/Kconfig
@@ -7,6 +7,7 @@ config DRM_ROCKCHIP
 	select DRM_PANEL
 	select VIDEOMODE_HELPERS
 	select DRM_ANALOGIX_DP if ROCKCHIP_ANALOGIX_DP
+	select DRM_DW_HDMI if ROCKCHIP_DW_HDMI
 	select DRM_DW_MIPI_DSI if ROCKCHIP_DW_MIPI_DSI
 	select GENERIC_PHY if ROCKCHIP_DW_MIPI_DSI
 	select GENERIC_PHY_MIPI_DPHY if ROCKCHIP_DW_MIPI_DSI
@@ -56,7 +57,6 @@ config ROCKCHIP_CDN_DP
 
 config ROCKCHIP_DW_HDMI
 	bool "Rockchip specific extensions for Synopsys DW HDMI"
-	depends on DRM_DW_HDMI
 	help
 	  This selects support for Rockchip SoC specific extensions
 	  for the Synopsys DesignWare HDMI driver. If you want to
--- a/drivers/gpu/drm/sun4i/Kconfig
+++ b/drivers/gpu/drm/sun4i/Kconfig
@@ -57,8 +57,8 @@ config DRM_SUN6I_DSI
 config DRM_SUN8I_DW_HDMI
 	tristate "Support for Allwinner version of DesignWare HDMI"
 	depends on DRM_SUN4I
-	depends on DRM_DW_HDMI
 	default DRM_SUN4I
+	select DRM_DW_HDMI
 	help
 	  Choose this option if you have an Allwinner SoC with the
 	  DesignWare HDMI controller. SoCs that support HDMI and



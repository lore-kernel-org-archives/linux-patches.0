Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 636C2199242;
	Thu,  6 Jun 2024 14:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682988; cv=none; b=tmbom8NIATtMcgPSN7TXk8BWGZI6PYR9pZR12qJdvsyAOSWx5qIRHx78+QA5Pfn5jFyppM0NhvYWLIoqpPgbPW7iVZ65z1mKZtDLl6vtwxsRy3WdPMWBYU+cehUeKGrim5PTHQKtW9f8o8iiVCNjJ1RsgRg/NqdKyf0s1tQCexI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682988; c=relaxed/simple;
	bh=QXuo7h5724iPyBDbrHQi6RnDbjN5C7igPNHAdb3hvDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dUxh1sGucIyeMJ4B5Hkl52yp1zG8VYvOUWoTPvIdmEHHDn5mIcBT/5ak2r5nFjt8k7XGHu1g09Z00of4SAzvSP2s8R/pbaEyS2edEspLNgSR1GPJCi4/h2489jKVHdszGkztjf0KHAJ99hGPXosoj69Z313cc+17bQ7Mbc6dXJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XF/wgTtk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XF/wgTtk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E8A6C32781;
	Thu,  6 Jun 2024 14:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682988;
	bh=QXuo7h5724iPyBDbrHQi6RnDbjN5C7igPNHAdb3hvDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XF/wgTtk++M48nnIs1J3J3TVcyktTzafjPz9H+EEixS7yEtbDKw3g+fCjO32wMb8l
	 Qkd7+EUvoXfY2aMY//ECWn6yiTx3Xu80jV1TTu7VbrOqhw74QY2tTHiIUUQZnK3qJf
	 Iv/ilm3O+m5+is03AnSynV/eBUBPJwH4vQGfwDMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 176/374] drm: Make drivers depends on DRM_DW_HDMI
Date: Thu,  6 Jun 2024 16:02:35 +0200
Message-ID: <20240606131657.782089059@linuxfoundation.org>
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

From: Maxime Ripard <mripard@kernel.org>

[ Upstream commit c0e0f139354c01e0213204e4a96e7076e5a3e396 ]

DRM_DW_HDMI has a number of dependencies that might not be enabled.
However, drivers were used to selecting it while not enforcing the
DRM_DW_HDMI dependencies.

This could result in Kconfig warnings (and further build breakages) such
as:

  Kconfig warnings: (for reference only)
     WARNING: unmet direct dependencies detected for DRM_DW_HDMI
     Depends on [n]: HAS_IOMEM [=y] && DRM [=m] && DRM_BRIDGE [=y] && DRM_DISPLAY_HELPER [=n]
     Selected by [m]:
     - DRM_SUN8I_DW_HDMI [=m] && HAS_IOMEM [=y] && DRM_SUN4I [=m]

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202403262127.kZkttfNz-lkp@intel.com/
Acked-by: Jani Nikula <jani.nikula@intel.com>
Link: https://lore.kernel.org/r/20240327-kms-kconfig-helpers-v3-7-eafee11b84b3@kernel.org
Signed-off-by: Maxime Ripard <mripard@kernel.org>
Stable-dep-of: cbdbd9ca718e ("drm/bridge: imx: Fix unmet depenency for PHY_FSL_SAMSUNG_HDMI_PHY")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/imx/Kconfig      | 4 ++--
 drivers/gpu/drm/imx/ipuv3/Kconfig       | 5 +++--
 drivers/gpu/drm/ingenic/Kconfig         | 2 +-
 drivers/gpu/drm/meson/Kconfig           | 2 +-
 drivers/gpu/drm/renesas/rcar-du/Kconfig | 2 +-
 drivers/gpu/drm/rockchip/Kconfig        | 2 +-
 drivers/gpu/drm/sun4i/Kconfig           | 2 +-
 7 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/bridge/imx/Kconfig b/drivers/gpu/drm/bridge/imx/Kconfig
index 5965e8027529a..7687ed652df5b 100644
--- a/drivers/gpu/drm/bridge/imx/Kconfig
+++ b/drivers/gpu/drm/bridge/imx/Kconfig
@@ -5,9 +5,9 @@ config DRM_IMX_LDB_HELPER
 
 config DRM_IMX8MP_DW_HDMI_BRIDGE
 	tristate "Freescale i.MX8MP HDMI-TX bridge support"
-	depends on OF
 	depends on COMMON_CLK
-	select DRM_DW_HDMI
+	depends on DRM_DW_HDMI
+	depends on OF
 	select DRM_IMX8MP_HDMI_PVI
 	select PHY_FSL_SAMSUNG_HDMI_PHY
 	help
diff --git a/drivers/gpu/drm/imx/ipuv3/Kconfig b/drivers/gpu/drm/imx/ipuv3/Kconfig
index bacf0655ebaf3..5d810ac02171d 100644
--- a/drivers/gpu/drm/imx/ipuv3/Kconfig
+++ b/drivers/gpu/drm/imx/ipuv3/Kconfig
@@ -35,7 +35,8 @@ config DRM_IMX_LDB
 
 config DRM_IMX_HDMI
 	tristate "Freescale i.MX DRM HDMI"
-	select DRM_DW_HDMI
-	depends on DRM_IMX && OF
+	depends on DRM_DW_HDMI
+	depends on DRM_IMX
+	depends on OF
 	help
 	  Choose this if you want to use HDMI on i.MX6.
diff --git a/drivers/gpu/drm/ingenic/Kconfig b/drivers/gpu/drm/ingenic/Kconfig
index 3db117c5edd91..23effeb2ac721 100644
--- a/drivers/gpu/drm/ingenic/Kconfig
+++ b/drivers/gpu/drm/ingenic/Kconfig
@@ -27,8 +27,8 @@ config DRM_INGENIC_IPU
 
 config DRM_INGENIC_DW_HDMI
 	tristate "Ingenic specific support for Synopsys DW HDMI"
+	depends on DRM_DW_HDMI
 	depends on MACH_JZ4780
-	select DRM_DW_HDMI
 	help
 	  Choose this option to enable Synopsys DesignWare HDMI based driver.
 	  If you want to enable HDMI on Ingenic JZ4780 based SoC, you should
diff --git a/drivers/gpu/drm/meson/Kconfig b/drivers/gpu/drm/meson/Kconfig
index 615fdd0ce41b4..5520b9e3f0107 100644
--- a/drivers/gpu/drm/meson/Kconfig
+++ b/drivers/gpu/drm/meson/Kconfig
@@ -13,9 +13,9 @@ config DRM_MESON
 
 config DRM_MESON_DW_HDMI
 	tristate "HDMI Synopsys Controller support for Amlogic Meson Display"
+	depends on DRM_DW_HDMI
 	depends on DRM_MESON
 	default y if DRM_MESON
-	select DRM_DW_HDMI
 	imply DRM_DW_HDMI_I2S_AUDIO
 
 config DRM_MESON_DW_MIPI_DSI
diff --git a/drivers/gpu/drm/renesas/rcar-du/Kconfig b/drivers/gpu/drm/renesas/rcar-du/Kconfig
index 53c356aed5d52..2dc739db2ba33 100644
--- a/drivers/gpu/drm/renesas/rcar-du/Kconfig
+++ b/drivers/gpu/drm/renesas/rcar-du/Kconfig
@@ -25,8 +25,8 @@ config DRM_RCAR_CMM
 config DRM_RCAR_DW_HDMI
 	tristate "R-Car Gen3 and RZ/G2 DU HDMI Encoder Support"
 	depends on DRM && OF
+	depends on DRM_DW_HDMI
 	depends on DRM_RCAR_DU || COMPILE_TEST
-	select DRM_DW_HDMI
 	help
 	  Enable support for R-Car Gen3 or RZ/G2 internal HDMI encoder.
 
diff --git a/drivers/gpu/drm/rockchip/Kconfig b/drivers/gpu/drm/rockchip/Kconfig
index 1bf3e2829cd07..0d5260e10f272 100644
--- a/drivers/gpu/drm/rockchip/Kconfig
+++ b/drivers/gpu/drm/rockchip/Kconfig
@@ -7,7 +7,6 @@ config DRM_ROCKCHIP
 	select DRM_PANEL
 	select VIDEOMODE_HELPERS
 	select DRM_ANALOGIX_DP if ROCKCHIP_ANALOGIX_DP
-	select DRM_DW_HDMI if ROCKCHIP_DW_HDMI
 	select DRM_DW_MIPI_DSI if ROCKCHIP_DW_MIPI_DSI
 	select GENERIC_PHY if ROCKCHIP_DW_MIPI_DSI
 	select GENERIC_PHY_MIPI_DPHY if ROCKCHIP_DW_MIPI_DSI
@@ -57,6 +56,7 @@ config ROCKCHIP_CDN_DP
 
 config ROCKCHIP_DW_HDMI
 	bool "Rockchip specific extensions for Synopsys DW HDMI"
+	depends on DRM_DW_HDMI
 	help
 	  This selects support for Rockchip SoC specific extensions
 	  for the Synopsys DesignWare HDMI driver. If you want to
diff --git a/drivers/gpu/drm/sun4i/Kconfig b/drivers/gpu/drm/sun4i/Kconfig
index 4741d9f6544c2..5b19c7cb7b7eb 100644
--- a/drivers/gpu/drm/sun4i/Kconfig
+++ b/drivers/gpu/drm/sun4i/Kconfig
@@ -57,8 +57,8 @@ config DRM_SUN6I_DSI
 config DRM_SUN8I_DW_HDMI
 	tristate "Support for Allwinner version of DesignWare HDMI"
 	depends on DRM_SUN4I
+	depends on DRM_DW_HDMI
 	default DRM_SUN4I
-	select DRM_DW_HDMI
 	help
 	  Choose this option if you have an Allwinner SoC with the
 	  DesignWare HDMI controller. SoCs that support HDMI and
-- 
2.43.0




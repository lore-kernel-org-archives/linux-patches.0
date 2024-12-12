Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A17C9223E8C;
	Thu, 12 Dec 2024 16:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022201; cv=none; b=ezBLNoi93EXQcK+s49urKgY9IqS7u99NQSE8hzCR6ZImaUzWLWhec5MI/tQ/QeJ6fVn4+Pt/Ly4T6zXiF22V2msv7JVdUWdgja9AmNFinM32wjPc255LL/E/R9ePR19xpU8FE0yb+JnKLlDrOSlvmkYSLiZFxhFjEOckIvOmyy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022201; c=relaxed/simple;
	bh=69jT4KTrEuMDHkh6He+Cz/9yCt60hCClANUDqWrJaQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=smWbuur7c8CDwcyXxNvOUcI6tLXi0nKxEG+u6wH8QCIevXXlZwz+Kg8QlbTBJylTwbKspC3cTZYTCUyVYIiF2NtBz8m4Dh6w0OjsE1UqVkxbxTtj8h4/Ccs7kSTXtoBdJ3X43l2oHPiNLhRX9on6IsokxBO9CQ5+HNflx7RoEgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IzyxgVft; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IzyxgVft"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A546DC4CECE;
	Thu, 12 Dec 2024 16:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022201;
	bh=69jT4KTrEuMDHkh6He+Cz/9yCt60hCClANUDqWrJaQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IzyxgVftusta2dvh4wh03JQpDIKsDtkgE2feaH5FrVkquho+eX96Cz+8qUttg7/NN
	 CCZ+I9EfSF3SnHiNnyZcRmD3XIsBMnbjh0I9p4xbLgtFYtTSp6KfaXnIhVGDUXnt1l
	 Q7ifVjNDZcg7XQ4G4qaVi10lBuE/ShE7VI4k9oGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Schiffer <matthias.schiffer@tq-group.com>,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 175/565] drm: fsl-dcu: enable PIXCLK on LS1021A
Date: Thu, 12 Dec 2024 15:56:10 +0100
Message-ID: <20241212144318.391854497@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthias Schiffer <matthias.schiffer@tq-group.com>

[ Upstream commit ffcde9e44d3e18fde3d18bfff8d9318935413bfd ]

The PIXCLK needs to be enabled in SCFG before accessing certain DCU
registers, or the access will hang. For simplicity, the PIXCLK is enabled
unconditionally, resulting in increased power consumption.

Signed-off-by: Matthias Schiffer <matthias.schiffer@tq-group.com>
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Fixes: 109eee2f2a18 ("drm/layerscape: Add Freescale DCU DRM driver")
Acked-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240926055552.1632448-2-alexander.stein@ew.tq-group.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/fsl-dcu/Kconfig           |  1 +
 drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_drv.c | 15 +++++++++++++++
 drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_drv.h |  3 +++
 3 files changed, 19 insertions(+)

diff --git a/drivers/gpu/drm/fsl-dcu/Kconfig b/drivers/gpu/drm/fsl-dcu/Kconfig
index d7dd8ba90e3af..9e5a35e7c00cc 100644
--- a/drivers/gpu/drm/fsl-dcu/Kconfig
+++ b/drivers/gpu/drm/fsl-dcu/Kconfig
@@ -8,6 +8,7 @@ config DRM_FSL_DCU
 	select DRM_PANEL
 	select REGMAP_MMIO
 	select VIDEOMODE_HELPERS
+	select MFD_SYSCON if SOC_LS1021A
 	help
 	  Choose this option if you have an Freescale DCU chipset.
 	  If M is selected the module will be called fsl-dcu-drm.
diff --git a/drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_drv.c b/drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_drv.c
index 660fe573db969..ab1d718fda5b5 100644
--- a/drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_drv.c
+++ b/drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_drv.c
@@ -100,6 +100,7 @@ static void fsl_dcu_irq_uninstall(struct drm_device *dev)
 static int fsl_dcu_load(struct drm_device *dev, unsigned long flags)
 {
 	struct fsl_dcu_drm_device *fsl_dev = dev->dev_private;
+	struct regmap *scfg;
 	int ret;
 
 	ret = fsl_dcu_drm_modeset_init(fsl_dev);
@@ -108,6 +109,20 @@ static int fsl_dcu_load(struct drm_device *dev, unsigned long flags)
 		return ret;
 	}
 
+	scfg = syscon_regmap_lookup_by_compatible("fsl,ls1021a-scfg");
+	if (PTR_ERR(scfg) != -ENODEV) {
+		/*
+		 * For simplicity, enable the PIXCLK unconditionally,
+		 * resulting in increased power consumption. Disabling
+		 * the clock in PM or on unload could be implemented as
+		 * a future improvement.
+		 */
+		ret = regmap_update_bits(scfg, SCFG_PIXCLKCR, SCFG_PIXCLKCR_PXCEN,
+					 SCFG_PIXCLKCR_PXCEN);
+		if (ret < 0)
+			return dev_err_probe(dev->dev, ret, "failed to enable pixclk\n");
+	}
+
 	ret = drm_vblank_init(dev, dev->mode_config.num_crtc);
 	if (ret < 0) {
 		dev_err(dev->dev, "failed to initialize vblank\n");
diff --git a/drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_drv.h b/drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_drv.h
index e2049a0e8a92a..566396013c04a 100644
--- a/drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_drv.h
+++ b/drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_drv.h
@@ -160,6 +160,9 @@
 #define FSL_DCU_ARGB4444		12
 #define FSL_DCU_YUV422			14
 
+#define SCFG_PIXCLKCR			0x28
+#define SCFG_PIXCLKCR_PXCEN		BIT(31)
+
 #define VF610_LAYER_REG_NUM		9
 #define LS1021A_LAYER_REG_NUM		10
 
-- 
2.43.0




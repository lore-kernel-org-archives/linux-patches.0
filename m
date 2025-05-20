Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14701288D6;
	Tue, 20 May 2025 14:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750421; cv=none; b=gOa7mpuZzT6YfgELiP3s6M2D2Euxps8L6E8FTFAQZMMK8iYsZEMrJhNuLSEk+jtiM0FpcTNpSBEiAIFI3RS9ivDhhY9PN+mjovoOMrainKrqAcahrPKcZRuI+4DG8ZYhBvI9HmmOgACTKutoE0+nkLPfgYdf3WXgyYAY6bTpCOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750421; c=relaxed/simple;
	bh=CvO5JhzQBv71vGHVEP6HkG7EPRAdMeAMh+Qg1o/axrw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qlDj2O8bZqZCPv9TbEek5ujJHSssGEXeSy3dbeHEzdnCrNqvl82OPvZFcqU8OUdr06Jv9AMjThy7HPn5gX8iFU+PxZERePdwEQmzBYdET9gzFz1mMrfzhG+rLule8VNSW+6rb/Q67w7qIyYQIa2RFoYTytIJ9JNTHwKJGpeFZRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nvHEuVT3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nvHEuVT3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84AE5C4CEEA;
	Tue, 20 May 2025 14:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750420;
	bh=CvO5JhzQBv71vGHVEP6HkG7EPRAdMeAMh+Qg1o/axrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nvHEuVT30mKCijlhjbk5NNQJYQIAejhrQOIK9N/dlUkVUB6+RROs/xexuZMBQKEs8
	 exIHE3HHnTh21gYTsQ0+YzrFlzFlo9kSW9xc27TCFEp3uCjbXr2L+9mZmncI9DYr40
	 gsJeeiR/wvWXYiy9p0Khj2YjL5KqYpElXfDMrTq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	=?UTF-8?q?Noralf=20Tr=C3=B8nnes?= <noralf@tronnes.org>,
	Fabio Estevam <festevam@denx.de>
Subject: [PATCH 6.12 139/143] drm/panel-mipi-dbi: Run DRM default client setup
Date: Tue, 20 May 2025 15:51:34 +0200
Message-ID: <20250520125815.482251665@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
References: <20250520125810.036375422@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

commit 1b0caa5f5ac20bcaf82fc89a5c849b21ce3bfdf6 upstream.

Call drm_client_setup() to run the kernel's default client setup
for DRM. Set fbdev_probe in struct drm_driver, so that the client
setup can start the common fbdev client.

v5:
- select DRM_CLIENT_SELECTION

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Cc: "Noralf Trønnes" <noralf@tronnes.org>
Acked-by: Noralf Trønnes <noralf@tronnes.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240924071734.98201-32-tzimmermann@suse.de
Signed-off-by: Fabio Estevam <festevam@denx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/tiny/Kconfig          |    1 +
 drivers/gpu/drm/tiny/panel-mipi-dbi.c |    4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/tiny/Kconfig
+++ b/drivers/gpu/drm/tiny/Kconfig
@@ -67,6 +67,7 @@ config DRM_OFDRM
 config DRM_PANEL_MIPI_DBI
 	tristate "DRM support for MIPI DBI compatible panels"
 	depends on DRM && SPI
+	select DRM_CLIENT_SELECTION
 	select DRM_KMS_HELPER
 	select DRM_GEM_DMA_HELPER
 	select DRM_MIPI_DBI
--- a/drivers/gpu/drm/tiny/panel-mipi-dbi.c
+++ b/drivers/gpu/drm/tiny/panel-mipi-dbi.c
@@ -15,6 +15,7 @@
 #include <linux/spi/spi.h>
 
 #include <drm/drm_atomic_helper.h>
+#include <drm/drm_client_setup.h>
 #include <drm/drm_drv.h>
 #include <drm/drm_fbdev_dma.h>
 #include <drm/drm_gem_atomic_helper.h>
@@ -264,6 +265,7 @@ static const struct drm_driver panel_mip
 	.driver_features	= DRIVER_GEM | DRIVER_MODESET | DRIVER_ATOMIC,
 	.fops			= &panel_mipi_dbi_fops,
 	DRM_GEM_DMA_DRIVER_OPS_VMAP,
+	DRM_FBDEV_DMA_DRIVER_OPS,
 	.debugfs_init		= mipi_dbi_debugfs_init,
 	.name			= "panel-mipi-dbi",
 	.desc			= "MIPI DBI compatible display panel",
@@ -388,7 +390,7 @@ static int panel_mipi_dbi_spi_probe(stru
 
 	spi_set_drvdata(spi, drm);
 
-	drm_fbdev_dma_setup(drm, 0);
+	drm_client_setup(drm, NULL);
 
 	return 0;
 }



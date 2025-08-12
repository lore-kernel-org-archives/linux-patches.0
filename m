Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EBCD1DB92A;
	Tue, 12 Aug 2025 18:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023680; cv=none; b=EZ18HsZhjzwO540ixfCYzxIF2c3S24/boZRlU+7GRMSvSi+4zNkJVG7GWWnMSxQO090KVYJSr2x0YAeLX9RMqkKpxVpVKSPa/m1MwkIyEk8/m9f70gFhosyHano6Dee9xwPOKWRZR6aFvKb+B8C8RHcTDPejrsnch9TwP7cOBjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023680; c=relaxed/simple;
	bh=3WK1qTxPhRYeSXzIfLVsmBJqm4cUnzgN79uBGoykzz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PD2tox5cGLQ5oEFeapeJ+FvaBJqLznXrpwp2Qg2Xg5XBHJ0DnaN1xyUIpBjESJlUzeV82N5l46LpXQdmizs1kexyX8sUxB0Qtx+sJE6AbX/K9PS73a9NHquHmAl98Z1rGBcg4MmwhUqFDZHQO6tTpmPvSWQBRM1aYmXaAC7ASrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nN84bO42; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nN84bO42"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25F46C4CEF0;
	Tue, 12 Aug 2025 18:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023679;
	bh=3WK1qTxPhRYeSXzIfLVsmBJqm4cUnzgN79uBGoykzz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nN84bO42yl8V2mcsKnA92zi+QGe8qV7c0iCfM0Ar6lB0pGLMTP9DEUx1KKe9hm/F4
	 VKQ/6P7Os48ai3U1hGYXtbzF4O0ickmjg+pDoWevhKp5trS2zvpJOtAxLtNI6YTEjz
	 dJPio2J5DfX5lQ8GzyE+0ZJO4pKdIxP+tTmkrYOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 133/627] drm/sitronix: Remove broken backwards-compatibility layer
Date: Tue, 12 Aug 2025 19:27:08 +0200
Message-ID: <20250812173424.372450659@linuxfoundation.org>
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

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit a3f7d26dfce9e2d547a58f4941881843a391a6cc ]

When moving the Sitronix DRM drivers and renaming their Kconfig symbols,
the old symbols were kept, aiming to provide a seamless migration path
when running "make olddefconfig" or "make oldconfig".

However, the old compatibility symbols are not visible.  Hence unless
they are selected by another symbol (which they are not), they can never
be enabled, and no backwards compatibility is provided.

Drop the broken mechanism and the old symbols.

Fixes: 9b8f32002cddf792 ("drm/sitronix: move tiny Sitronix drivers to their own subdir")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://lore.kernel.org/r/20395b14effe5e2e05a4f0856fdcda51c410329d.1747751592.git.geert+renesas@glider.be
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sitronix/Kconfig | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/gpu/drm/sitronix/Kconfig b/drivers/gpu/drm/sitronix/Kconfig
index 741d1bb4b83f..6de7d92d9b74 100644
--- a/drivers/gpu/drm/sitronix/Kconfig
+++ b/drivers/gpu/drm/sitronix/Kconfig
@@ -11,10 +11,6 @@ config DRM_ST7571_I2C
 
 	  if M is selected the module will be called st7571-i2c.
 
-config TINYDRM_ST7586
-	tristate
-	default n
-
 config DRM_ST7586
 	tristate "DRM support for Sitronix ST7586 display panels"
 	depends on DRM && SPI
@@ -22,17 +18,12 @@ config DRM_ST7586
 	select DRM_KMS_HELPER
 	select DRM_GEM_DMA_HELPER
 	select DRM_MIPI_DBI
-	default TINYDRM_ST7586
 	help
 	  DRM driver for the following Sitronix ST7586 panels:
 	  * LEGO MINDSTORMS EV3
 
 	  If M is selected the module will be called st7586.
 
-config TINYDRM_ST7735R
-	tristate
-	default n
-
 config DRM_ST7735R
 	tristate "DRM support for Sitronix ST7715R/ST7735R display panels"
 	depends on DRM && SPI
@@ -41,7 +32,6 @@ config DRM_ST7735R
 	select DRM_GEM_DMA_HELPER
 	select DRM_MIPI_DBI
 	select BACKLIGHT_CLASS_DEVICE
-	default TINYDRM_ST7735R
 	help
 	  DRM driver for Sitronix ST7715R/ST7735R with one of the following
 	  LCDs:
-- 
2.39.5




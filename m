Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A30054706F;
	Thu, 17 Sep 2026 17:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667436; cv=none; b=juxISj5qFqvsuW/fnG+hXDn4eipk4ygbgyXS5PCLdI4thXMQ3ZksyYNHbEAFXHL7+8Jp+gomeEGnLSN+1ZyZ6XmEs+m4SkPxXvuuJmX89ueM5uDsnB2Tl0FB3WLgwhxiArM+gpb7w3OsJJsKMpoUhngZNGRs29bi8Cm2ePv945w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667436; c=relaxed/simple;
	bh=ZUgYq+Z3SWkGzeO+uRPPcSXYNWom6YWRaqn/BwRLTog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MCxOq+nlEAfqR36wRHOjdr3aZKVu25EsKUMXLNK7+2VLnDIbbL+jzozORp2UhqkCTqNZmli4mlbQTGP3YUuGvEvRlz4FHhzVziDWIGlYKfM7PGc8Wte6nzyOwfqfpQGeMOX78MaGX2Nj0Qi+wDWkbtXZQECpBsQNm7JlEnyK9LI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kQOmnnsi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kQOmnnsi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91AF71F000FF;
	Thu, 17 Sep 2026 17:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667435;
	bh=DcjRwUitzJ3gjNz5qJ/UQrH69GMpP1X5/uej2Fjvur4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kQOmnnsiE+mmtEwCUKzwgQ4Sv8hYnjdfHErLwgxG46anwWCyr943UoMdoAMzLGJeM
	 GxOtD7T7E84H99j+JzuAIKoKc4KsjbmnG4/KimkyqdPeAXfSVXaDCcys5VZZTsBY8M
	 aCQZ9zGM9+jOyOwqD5K6nmDwG6O98D3wJVYzRO00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heidelberg <david@ixit.cz>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0044/1102] drm/panel: Enable GPIOLIB for panels which uses functions from it
Date: Thu, 17 Sep 2026 15:59:47 +0100
Message-ID: <20260917151540.554129579@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Heidelberg <david@ixit.cz>

[ Upstream commit ae3aa8cf5fd5ccb428a814e7eb38ae33ad1cfa34 ]

These panels used on sdm845 devices are using GPIOLIB functions,
ensure it's enabled.

Signed-off-by: David Heidelberg <david@ixit.cz>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20260505-panel-clean-up-kconfig-dep-v2-4-9cc31d6e6919@ixit.cz
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/Kconfig | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/panel/Kconfig b/drivers/gpu/drm/panel/Kconfig
index d3a9a9fafe4ec..a8cf1b0a512f2 100644
--- a/drivers/gpu/drm/panel/Kconfig
+++ b/drivers/gpu/drm/panel/Kconfig
@@ -98,6 +98,7 @@ config DRM_PANEL_BOE_TV101WUM_LL2
 
 config DRM_PANEL_EBBG_FT8719
 	tristate "EBBG FT8719 panel driver"
+	depends on GPIOLIB
 	depends on OF
 	depends on DRM_MIPI_DSI
 	depends on BACKLIGHT_CLASS_DEVICE
@@ -273,7 +274,8 @@ config DRM_PANEL_JADARD_JD9365DA_H3
 
 config DRM_PANEL_JDI_LPM102A188A
 	tristate "JDI LPM102A188A DSI panel"
-	depends on OF && GPIOLIB
+	depends on GPIOLIB
+	depends on OF
 	depends on DRM_MIPI_DSI
 	depends on BACKLIGHT_CLASS_DEVICE
 	help
@@ -375,6 +377,7 @@ config DRM_PANEL_LG_LG4573
 
 config DRM_PANEL_LG_SW43408
 	tristate "LG SW43408 panel"
+	depends on GPIOLIB
 	depends on OF
 	depends on DRM_MIPI_DSI
 	depends on BACKLIGHT_CLASS_DEVICE
@@ -479,6 +482,7 @@ config DRM_PANEL_NOVATEK_NT36523
 
 config DRM_PANEL_NOVATEK_NT36672A
 	tristate "Novatek NT36672A DSI panel"
+	depends on GPIOLIB
 	depends on OF
 	depends on DRM_MIPI_DSI
 	depends on BACKLIGHT_CLASS_DEVICE
@@ -489,6 +493,7 @@ config DRM_PANEL_NOVATEK_NT36672A
 
 config DRM_PANEL_NOVATEK_NT36672E
 	tristate "Novatek NT36672E DSI panel"
+	depends on GPIOLIB
 	depends on OF
 	depends on DRM_MIPI_DSI
 	depends on BACKLIGHT_CLASS_DEVICE
@@ -595,7 +600,8 @@ config DRM_PANEL_RAYDIUM_RM692E5
 
 config DRM_PANEL_RAYDIUM_RM69380
 	tristate "Raydium RM69380-based DSI panel"
-	depends on OF && GPIOLIB
+	depends on GPIOLIB
+	depends on OF
 	depends on DRM_MIPI_DSI
 	depends on BACKLIGHT_CLASS_DEVICE
 	help
@@ -954,6 +960,7 @@ config DRM_PANEL_VISIONOX_R66451
 
 config DRM_PANEL_VISIONOX_RM69299
 	tristate "Visionox RM69299"
+	depends on GPIOLIB
 	depends on OF
 	depends on DRM_MIPI_DSI
 	help
-- 
2.53.0




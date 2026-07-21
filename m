Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C456C30F80C;
	Tue, 21 Jul 2026 17:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655701; cv=none; b=aD+VEJ10oR0bGIqV+8z/ffsDbJnR6A/y0fzlTqxcoFFQEL3p+f98enWq6peA996YavMv09QurIke8l2HEAj7EHwWHa9Mkqdt7NMkqxl7DNEHQ2bOOFkEtXYOXLnbFkBhhMEsBT6cbUD4yrUHPvku1phgAD/f6hIAlokXf3EXA7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655701; c=relaxed/simple;
	bh=jWvLcUDkI3JH952WFi1+hj6D8/00W0jYkA3fwpFVtTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fEFe32oyuy+a3hSGKUerNfkcNzz9hToQ0LRaxUTiH3xOJ+TvMv9BYBp9zfbbjYrd+wICEIBifiqQDBFqIluIu8xXggC7WuhzwKAOfvetAFmD4swCqT1BOOcIBlr/n2VlIE1se7e7PvPOqfblA486KNO2/OYXRow4SkXu15HQDsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iPPGzmMs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iPPGzmMs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF11E1F000E9;
	Tue, 21 Jul 2026 17:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655699;
	bh=4QId7ikM1El7uTynlSsZo+Vx0GXcRvGQQrb6LAGbPfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iPPGzmMsRlncsEnG4L+f+qSfzJgsc9VWobJ229t8A894Yfkz/gZKrHQFc3ZW1ur+I
	 mQ8F0tflcwxizZOuSCnrFmQIOmJFI2CnlvMyq5PkBLmDr7qyUjJVoID4FmHJenlbML
	 VlKx1DJoaQ1sPBZoZpX1sT7aqdXVWz5JJlEZ5qWE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heidelberg <david@ixit.cz>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0109/1611] drm/panel: Clean up S6E3HA2 config dependencies and fill help text
Date: Tue, 21 Jul 2026 17:03:45 +0200
Message-ID: <20260721152517.301691605@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Heidelberg <david@ixit.cz>

[ Upstream commit 632a8aa96d0717aa92cb63e3939d09b896223b4c ]

As per the config name this Display IC features a DSI command-mode
interface (or the command to switch to video mode is not
known/documented) and does not use any of the video-mode helper
utilities, hence should not select VIDEOMODE_HELPERS. In addition it
uses devm_gpiod_get() and related functions from GPIOLIB.

Fixes: 779679d3c164 ("drm/panel: Add support for S6E3HA8 panel driver")
Signed-off-by: David Heidelberg <david@ixit.cz>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20260505-panel-clean-up-kconfig-dep-v2-3-9cc31d6e6919@ixit.cz
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/Kconfig | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panel/Kconfig b/drivers/gpu/drm/panel/Kconfig
index 407c5f6a268b2e..1516c6fa265db7 100644
--- a/drivers/gpu/drm/panel/Kconfig
+++ b/drivers/gpu/drm/panel/Kconfig
@@ -810,11 +810,18 @@ config DRM_PANEL_SAMSUNG_S6E3HA2
 
 config DRM_PANEL_SAMSUNG_S6E3HA8
 	tristate "Samsung S6E3HA8 DSI video mode panel"
+	depends on GPIOLIB
 	depends on OF
 	depends on DRM_MIPI_DSI
 	depends on BACKLIGHT_CLASS_DEVICE
 	select DRM_DISPLAY_DSC_HELPER
-	select VIDEOMODE_HELPERS
+	help
+	  Say Y or M here if you want to enable support for the
+	  Samsung S6E3HA8 DDIC and connected MIPI DSI panel.
+	  Currently supported panels:
+
+	    Samsung AMB577PX01 (found in the Samsung S9 smartphone)
+
 
 config DRM_PANEL_SAMSUNG_S6E63J0X03
 	tristate "Samsung S6E63J0X03 DSI command mode panel"
-- 
2.53.0




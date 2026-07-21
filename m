Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4410746AA82;
	Tue, 21 Jul 2026 15:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648287; cv=none; b=JRkZLwCgtfbOMlftnz4e79o+hYMJ1pBcDgfdweLQVFg5LG0ArDqdiO2djLk5pP13nDGXEA/2JIVHmUseNo9coGg48eOOu9OTQXenKSp9/wPMV84/9sw3JYB+UYX4Q2KFNdKGxrjayP2xru6ztc+RmOigawZuILn0u4wv/EbaB7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648287; c=relaxed/simple;
	bh=cXFgVqFfWmuPDXWPYM2rjd+md/I9LGLPADPrU4pLA5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j4usd3Q48ooub0tvIPuWAM0UD4Z29H+LD1KvR4QTZyPr2Uy9JWftF/h5qIIwZbcCir/aTvFWkyMXDQiO1EiC2iDWhQuicpYELS7K2Lpm5X3loKXZUX9/IkM0j6WpXdRAHSHPHPRBoZ1BFKSD8v0CnWqqBszgPK5PfBVlG+Z2LtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GHddGHUs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GHddGHUs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9FDF1F000E9;
	Tue, 21 Jul 2026 15:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648286;
	bh=kwhFY21o6Np4XnYlSHIxA6PAyr6BK8eLKKAGKY8Wh5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GHddGHUscTc8KGCKdE3hfCz3eyeilSSSUuNHu4RA5YM+jrpPJJPFc2KwHaxxBJN4R
	 Ur1wabYIz5gpbArMKQUE+VFaqFC7QJ3nqjSoNkvAeKliP0Nu28Lq+owB6WH+NE/EjS
	 ExTK462xK4pGBpDdMzPt7iB471ySWu4kPIfG/5RA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heidelberg <david@ixit.cz>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0143/2077] drm/panel: Clean up S6E3FC2X01 config dependencies
Date: Tue, 21 Jul 2026 16:56:56 +0200
Message-ID: <20260721152556.060164696@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Heidelberg <david@ixit.cz>

[ Upstream commit faf497d2f1ff15756981c6e65a9c3d8bf192a969 ]

As per the config name this Display IC features a DSI command-mode
interface (or the command to switch to video mode is not
known/documented) and does not use any of the video-mode helper
utilities, hence should not select VIDEOMODE_HELPERS.  In addition it
uses devm_gpiod_get() and related functions from GPIOLIB.

Fixes: 88148c30ef26 ("drm/panel: Add Samsung S6E3FC2X01 DDIC with AMS641RW panel")
Signed-off-by: David Heidelberg <david@ixit.cz>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20260505-panel-clean-up-kconfig-dep-v2-2-9cc31d6e6919@ixit.cz
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panel/Kconfig b/drivers/gpu/drm/panel/Kconfig
index 28802f86a538fe..56b4c464ec9b30 100644
--- a/drivers/gpu/drm/panel/Kconfig
+++ b/drivers/gpu/drm/panel/Kconfig
@@ -890,10 +890,10 @@ config DRM_PANEL_SAMSUNG_S6D7AA0
 
 config DRM_PANEL_SAMSUNG_S6E3FC2X01
 	tristate "Samsung S6E3FC2X01 DSI panel controller"
+	depends on GPIOLIB
 	depends on OF
 	depends on DRM_MIPI_DSI
 	depends on BACKLIGHT_CLASS_DEVICE
-	select VIDEOMODE_HELPERS
 	help
 	  Say Y or M here if you want to enable support for the
 	  Samsung S6E3FC2 DDIC and connected MIPI DSI panel.
-- 
2.53.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3878546AA68;
	Tue, 21 Jul 2026 15:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648290; cv=none; b=pHK+M1mkJB7c0DprehoCRsuGq54xMDBVG1jAMdM6RzxyFa/SPosjIzvaTDywb8YF6AvkUL/BS8tlIK/dEJFvBA8jNOaEQDHCxjphsPrSBsLYm730t1IGE75gVHpUCVba36aoDyMjof15h9kt4EakUenBylc2SFq25+CNDtZgg6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648290; c=relaxed/simple;
	bh=y8DZLzUN+JKnq89Gaiv9gZaPw6of0dO2gQFAtib1Zww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=igXkAlrRfs7pefCDDV6bxMFUVVdGo/kbLdTRZRTlSYJ3zdC3OuwNUfgSP3+7ggEkLEyCQnx84DVDftw5oGNjVwOdf/rXpelwpkU8BVGuP2icm8E982KlyF08XUtfdeshyJT8QrF+bOOztLK4oNgQ8GwY1UCxUnWr2cQKmvP5Crk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P9Dj48+m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P9Dj48+m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EF741F000E9;
	Tue, 21 Jul 2026 15:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648288;
	bh=XLHO4YRaMjwgBAgqfH8id6g06aG/IkONwhoG2Nfer3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P9Dj48+mbmKC4S/f6UafrbDUOTxwC8JUJFFDaCbm63D3yICTp93OfMnOevm2DQbIQ
	 0PeJP0luz8ID3dARONDvBBGl0hXctjGrBGXcqvFsgPdtv0LgCkqg4iTomJTCvbKzlQ
	 CVmw9KaYmZEfphJGs5unYGeUkDD2TZMv7/qvLM9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heidelberg <david@ixit.cz>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0144/2077] drm/panel: Clean up S6E3HA2 config dependencies and fill help text
Date: Tue, 21 Jul 2026 16:56:57 +0200
Message-ID: <20260721152556.084221711@linuxfoundation.org>
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
index 56b4c464ec9b30..b2153e04a59af7 100644
--- a/drivers/gpu/drm/panel/Kconfig
+++ b/drivers/gpu/drm/panel/Kconfig
@@ -910,11 +910,18 @@ config DRM_PANEL_SAMSUNG_S6E3HA2
 
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




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A492F3A8CC
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Epa3oMEC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4165EC433C7;
	Wed, 15 Nov 2023 19:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077293;
	bh=nlygXryv5WuSeD1yY8M7C2IbYtKn8Dgc82k9/TMiii0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Epa3oMECkrb4dkkJZX3oQUAS86uQasyd4utudyfNgFOaZ4WGqHoptgSO3B5rjbe4q
	 uhPQuUSIPimMNECxzG73xcIsl34OoHZOlT7LrKtxZ3TVgjmbDEQMxilLh3XHD0hjDs
	 RP8AhklqdccgnfanY5KZ+FJ5cBMD45T/1+y2AlEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Aleksandr Nogikh <nogikh@google.com>,
	Adam Ford <aford173@gmail.com>,
	Maxime Ripard <maxime.ripard@bootlin.com>,
	=?UTF-8?q?Guido=20G=C3=BCnther?= <agx@sigxcpu.org>,
	Robert Chiras <robert.chiras@nxp.com>,
	Sam Ravnborg <sam@ravnborg.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Andrzej Hajda <andrzej.hajda@intel.com>,
	Robert Foss <rfoss@kernel.org>,
	David Airlie <airlied@gmail.com>,
	Daniel Vetter <daniel@ffwll.ch>,
	dri-devel@lists.freedesktop.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 215/603] drm: bridge: for GENERIC_PHY_MIPI_DPHY also select GENERIC_PHY
Date: Wed, 15 Nov 2023 14:12:40 -0500
Message-ID: <20231115191628.156983839@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 96413b355a49fd684430a230479bd231d977894f ]

Three DRM bridge drivers select GENERIC_PHY_MIPI_DPHY when GENERIC_PHY
might not be set.  This causes Kconfig warnings and a build error.

WARNING: unmet direct dependencies detected for GENERIC_PHY_MIPI_DPHY
  Depends on [n]: GENERIC_PHY [=n]
  Selected by [y]:
  - DRM_NWL_MIPI_DSI [=y] && DRM_BRIDGE [=y] && DRM [=y] && COMMON_CLK [=y] && OF [=y] && HAS_IOMEM [=y]
  - DRM_SAMSUNG_DSIM [=y] && DRM [=y] && DRM_BRIDGE [=y] && COMMON_CLK [=y] && OF [=y] && HAS_IOMEM [=y]

(drm/bridge/cadence/Kconfig was found by inspection.)

aarch64-linux-ld: drivers/gpu/drm/bridge/samsung-dsim.o: in function `samsung_dsim_set_phy_ctrl':
drivers/gpu/drm/bridge/samsung-dsim.c:731: undefined reference to `phy_mipi_dphy_get_default_config_for_hsclk'

Prevent these warnings and build error by also selecting GENERIC_PHY
whenever selecting GENERIC_PHY_MIPI_DPHY.

Fixes: fced5a364dee ("drm/bridge: cdns: Convert to phy framework")
Fixes: 44cfc6233447 ("drm/bridge: Add NWL MIPI DSI host controller support")
Fixes: 171b3b1e0f8b ("drm: bridge: samsung-dsim: Select GENERIC_PHY_MIPI_DPHY")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Aleksandr Nogikh <nogikh@google.com>
Link: lore.kernel.org/r/20230803144227.2187749-1-nogikh@google.com
Cc: Adam Ford <aford173@gmail.com>
Cc: Maxime Ripard <maxime.ripard@bootlin.com>
Cc: Guido Günther <agx@sigxcpu.org>
Cc: Robert Chiras <robert.chiras@nxp.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Neil Armstrong <neil.armstrong@linaro.org>
Cc: Andrzej Hajda <andrzej.hajda@intel.com>
Cc: Robert Foss <rfoss@kernel.org>
Cc: David Airlie <airlied@gmail.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: dri-devel@lists.freedesktop.org
Reviewed-by: Adam Ford <aford173@gmail.com>
Tested-by: Aleksandr Nogikh <nogikh@google.com>
Reviewed-by: Guido Günther <agx@sigxcpu.org>
Signed-off-by: Robert Foss <rfoss@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20230804030140.21395-1-rdunlap@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/Kconfig         | 2 ++
 drivers/gpu/drm/bridge/cadence/Kconfig | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/bridge/Kconfig b/drivers/gpu/drm/bridge/Kconfig
index 44a660a4bdbfc..ba82a1142adf7 100644
--- a/drivers/gpu/drm/bridge/Kconfig
+++ b/drivers/gpu/drm/bridge/Kconfig
@@ -181,6 +181,7 @@ config DRM_NWL_MIPI_DSI
 	select DRM_KMS_HELPER
 	select DRM_MIPI_DSI
 	select DRM_PANEL_BRIDGE
+	select GENERIC_PHY
 	select GENERIC_PHY_MIPI_DPHY
 	select MFD_SYSCON
 	select MULTIPLEXER
@@ -227,6 +228,7 @@ config DRM_SAMSUNG_DSIM
 	select DRM_KMS_HELPER
 	select DRM_MIPI_DSI
 	select DRM_PANEL_BRIDGE
+	select GENERIC_PHY
 	select GENERIC_PHY_MIPI_DPHY
 	help
 	  The Samsung MIPI DSIM bridge controller driver.
diff --git a/drivers/gpu/drm/bridge/cadence/Kconfig b/drivers/gpu/drm/bridge/cadence/Kconfig
index ec35215a20034..cced81633ddcd 100644
--- a/drivers/gpu/drm/bridge/cadence/Kconfig
+++ b/drivers/gpu/drm/bridge/cadence/Kconfig
@@ -4,6 +4,7 @@ config DRM_CDNS_DSI
 	select DRM_KMS_HELPER
 	select DRM_MIPI_DSI
 	select DRM_PANEL_BRIDGE
+	select GENERIC_PHY
 	select GENERIC_PHY_MIPI_DPHY
 	depends on OF
 	help
-- 
2.42.0




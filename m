Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D489C28B511;
	Wed, 23 Apr 2025 15:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420671; cv=none; b=oI+d6pCjxlS8tclpSh2OBRLxKWDIvdsG1aQijpEsJCvf130wLdQw2jL63xoOi6J9mvUA29oCOJkwABg6k0EK+fxY3A+PgYwRkgyLi4K9fNpdU/utsLvyQdYfOIupo3Drv6sCOEVu17Cs+YRZHJvvG63Q8UttQBb2c+c9V7zGQms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420671; c=relaxed/simple;
	bh=y9xOxbOvr5scDOv4oWgLO8YXxi6AVUvoDXS7AYWUl2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b2xfJt89o4r/5F2/BdObMuNsyf85IoktxjzmALR9GPHcJlkfUQApPmTZ66SqPh/mWiLWzJpSKtNVnhPhBsZDUqfseVqFF/dqfBxbRgoh7iT4YEQS6W66spyqLj8wxrT+6xzQK6D/mUU2Tlst5138KFAB68Wi0z6/fx+cMFwLD3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fwYAziGt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fwYAziGt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64FF9C4CEE2;
	Wed, 23 Apr 2025 15:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420671;
	bh=y9xOxbOvr5scDOv4oWgLO8YXxi6AVUvoDXS7AYWUl2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fwYAziGtnB3AfGJPonF5uZjPyAjjJgsNzWg9to8+fqY4PpmJY/+FQo+mFunBLt0IE
	 p44mXNSYa0cQNawer2PAkpqAdaZkYeYqB8lL6Re9ts+Dw3DhqG43uVZM5nVTPZtr6r
	 UdG4ZlrbK+vkvQznanu1mKsNibgErO6hG9vujxdY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Wyatt <fewtarius@steamfork.org>,
	John Edwards <uejji@uejji.net>,
	Paco Avelar <pacoavelar@hotmail.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 056/291] drm: panel-orientation-quirks: Add quirks for AYA NEO Flip DS and KB
Date: Wed, 23 Apr 2025 16:40:45 +0200
Message-ID: <20250423142626.670098000@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Wyatt <fewtarius@steamfork.org>

[ Upstream commit 529741c331da1fbf54f86c6ec3a4558b9b0b16dc ]

The AYA NEO Flip DS and KB both use a 1080x1920 portrait LCD panel.  The
Flip DS additionally uses a 640x960 portrait LCD panel as a second display.

Add DMI matches to correctly rotate these panels.

Signed-off-by: Andrew Wyatt <fewtarius@steamfork.org>
Co-developed-by: John Edwards <uejji@uejji.net>
Signed-off-by: John Edwards <uejji@uejji.net>
Tested-by: Paco Avelar <pacoavelar@hotmail.com>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20250213222455.93533-3-uejji@uejji.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_panel_orientation_quirks.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/gpu/drm/drm_panel_orientation_quirks.c b/drivers/gpu/drm/drm_panel_orientation_quirks.c
index 7bf096ddeb06d..d9ed6214cf28b 100644
--- a/drivers/gpu/drm/drm_panel_orientation_quirks.c
+++ b/drivers/gpu/drm/drm_panel_orientation_quirks.c
@@ -93,6 +93,12 @@ static const struct drm_dmi_panel_orientation_data onegx1_pro = {
 	.orientation = DRM_MODE_PANEL_ORIENTATION_RIGHT_UP,
 };
 
+static const struct drm_dmi_panel_orientation_data lcd640x960_leftside_up = {
+	.width = 640,
+	.height = 960,
+	.orientation = DRM_MODE_PANEL_ORIENTATION_LEFT_UP,
+};
+
 static const struct drm_dmi_panel_orientation_data lcd720x1280_rightside_up = {
 	.width = 720,
 	.height = 1280,
@@ -202,6 +208,18 @@ static const struct dmi_system_id orientation_data[] = {
 		  DMI_MATCH(DMI_PRODUCT_NAME, "AIR"),
 		},
 		.driver_data = (void *)&lcd1080x1920_leftside_up,
+	}, {    /* AYA NEO Flip DS Bottom Screen */
+		.matches = {
+		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "AYANEO"),
+		  DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "FLIP DS"),
+		},
+		.driver_data = (void *)&lcd640x960_leftside_up,
+	}, {    /* AYA NEO Flip KB/DS Top Screen */
+		.matches = {
+		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "AYANEO"),
+		  DMI_MATCH(DMI_PRODUCT_NAME, "FLIP"),
+		},
+		.driver_data = (void *)&lcd1080x1920_leftside_up,
 	}, {	/* AYA NEO Founder */
 		.matches = {
 		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "AYA NEO"),
-- 
2.39.5




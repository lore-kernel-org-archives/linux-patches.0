Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A0A74ED1B7;
	Thu, 17 Sep 2026 16:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661127; cv=none; b=pTBkWhky5w+KYEsAq6YX2Et8sRSGf0zu21nFmCx4RjD3nOiHoLGTHYjLgae3urV6HrfDiYo6L7Zz0u01NMMn4R21UGP0/zCUIrv7BRziWDw7TSaHZLU/lceJVb0v5z05J21JT6JwxI/KEjkrxITdp6NT+H4h5JntEsBXpG6vq4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661127; c=relaxed/simple;
	bh=uzScEWWlllsItuzETzXbFpP+P86W8ZE63QcIS8nclus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jW1w+IVryPY3zqtS7vqKbdv1uQbejvQlCHsQVsbUXlsQTD9KehEeUgVT8hEIIJXHDzsvAqEYG3LXG3eBdl79g8P7crELizxqSpvwITim9+6JueyG0d/oaiFvvE0qLhYXWXYLexet7NkkcPxpuskIdCA4YMbmNvNM00y1CUSioVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uKhfkiAD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uKhfkiAD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4DD51F00893;
	Thu, 17 Sep 2026 16:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661126;
	bh=Uh2mtH1+EUHZwcmtjLO+sNXwWMMJQT+JkSy1ykzlgpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uKhfkiAD8efQMKMkY1hSDREWGy16zJA4f470/zc+sxJcjWVU8NFe2JvyEc9O8oiCZ
	 uzsDLW3jpwrLvlujmUaEz71YnvPsIdGPdXbRBySJGtk4kWh7oGetUHYJOAfl7NL/B2
	 Y0FRKtR/cKtEslm03LXpoCsHq6PJcr+ygBcXQ5CE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Maxime Ripard <mripard@kernel.org>,
	Albert Esteve <aesteve@redhat.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0092/1250] drm/panel/tdo-tl070wsh30: Use refcounted allocation in place of devm_kzalloc()
Date: Thu, 17 Sep 2026 15:58:07 +0100
Message-ID: <20260917151554.479919443@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Albert Esteve <aesteve@redhat.com>

[ Upstream commit 928decbed75bf215a8d0eecc88aa2edc77023db2 ]

Move to using the new API devm_drm_panel_alloc() to allocate the
panel. In the call to the new API, avoid using explicit type and use
__typeof() for more type safety.

Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Albert Esteve <aesteve@redhat.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patch.msgid.link/20260508-drm_panel_init_rm-v2-6-0bd4ac429971@redhat.com
Signed-off-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-tdo-tl070wsh30.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/panel/panel-tdo-tl070wsh30.c b/drivers/gpu/drm/panel/panel-tdo-tl070wsh30.c
index 227f97f9b136f..13cfe252a838d 100644
--- a/drivers/gpu/drm/panel/panel-tdo-tl070wsh30.c
+++ b/drivers/gpu/drm/panel/panel-tdo-tl070wsh30.c
@@ -162,9 +162,6 @@ static int tdo_tl070wsh30_panel_add(struct tdo_tl070wsh30_panel *tdo_tl070wsh30)
 		return err;
 	}
 
-	drm_panel_init(&tdo_tl070wsh30->base, &tdo_tl070wsh30->link->dev,
-		       &tdo_tl070wsh30_panel_funcs, DRM_MODE_CONNECTOR_DSI);
-
 	err = drm_panel_of_backlight(&tdo_tl070wsh30->base);
 	if (err)
 		return err;
@@ -183,10 +180,13 @@ static int tdo_tl070wsh30_panel_probe(struct mipi_dsi_device *dsi)
 	dsi->format = MIPI_DSI_FMT_RGB888;
 	dsi->mode_flags = MIPI_DSI_MODE_VIDEO | MIPI_DSI_MODE_VIDEO_BURST | MIPI_DSI_MODE_LPM;
 
-	tdo_tl070wsh30 = devm_kzalloc(&dsi->dev, sizeof(*tdo_tl070wsh30),
-				    GFP_KERNEL);
-	if (!tdo_tl070wsh30)
-		return -ENOMEM;
+	tdo_tl070wsh30 = devm_drm_panel_alloc(&dsi->dev,
+					      __typeof(*tdo_tl070wsh30), base,
+					      &tdo_tl070wsh30_panel_funcs,
+					      DRM_MODE_CONNECTOR_DSI);
+
+	if (IS_ERR(tdo_tl070wsh30))
+		return PTR_ERR(tdo_tl070wsh30);
 
 	mipi_dsi_set_drvdata(dsi, tdo_tl070wsh30);
 	tdo_tl070wsh30->link = dsi;
-- 
2.53.0




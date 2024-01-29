Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 241BC15AAD4;
	Mon, 29 Jan 2024 17:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548408; cv=none; b=JwL6CI8pEw+29Wl5Nx62CNFwAjMVJmNuV/obPXX0f1nRIlsHK1QWHxYyjYTmfK1rWFJyFU5nd0pLBl6pAWAoCJkFh56OqHqdpMK3CYEnPt/QfQh2lv9+ljLlqgzGpzEMbz3dtuSdaOTdVRRmzwqDWrjJC0pAt29CfCzVw+vHQIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548408; c=relaxed/simple;
	bh=jU6BnYcxmSsB+duncfaTsuraTaaQAm33Ebl63d4Qlak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JZvVIuZzmG83zTwBa7HR6BCdKumjWg80koLGz6PGxYJ2TtXw0qZhR0NeQn1bG5WzJ3tIXty4jJk9uZ1jbK5wK+rZFbeePuhBu+SOYls44JPQtYS+DKWXbcfLbBJzb+G0bcvdNJ4pffe+LoogU8K1Tq77Cpx4DTplDB9Nf1QHnJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L3Bsly6o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L3Bsly6o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 883DCC433F1;
	Mon, 29 Jan 2024 17:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548407;
	bh=jU6BnYcxmSsB+duncfaTsuraTaaQAm33Ebl63d4Qlak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L3Bsly6ocJUBQWPQJbdZR8LvwvYjVLzjGbYOPeBnM1RsitMdECLQ7HY1BPlldE4B6
	 W+8TuMtiW7eI+oh96ZF3xnbavLOikX98D9VP7Wv67+mveVyv8YbtZgIAMYxHRSBNCl
	 RGQG1V/2bu53hB0NYpL/t+5dv2Jt/VBvnUAQtle8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Niebel <Markus.Niebel@ew.tq-group.com>,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Sam Ravnborg <sam@ravnborg.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 167/185] drm: panel-simple: add missing bus flags for Tianma tm070jvhg[30/33]
Date: Mon, 29 Jan 2024 09:06:07 -0800
Message-ID: <20240129170003.956034698@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markus Niebel <Markus.Niebel@ew.tq-group.com>

[ Upstream commit 45dd7df26cee741b31c25ffdd44fb8794eb45ccd ]

The DE signal is active high on this display, fill in the missing
bus_flags. This aligns panel_desc with its display_timing.

Fixes: 9a2654c0f62a ("drm/panel: Add and fill drm_panel type field")
Fixes: b3bfcdf8a3b6 ("drm/panel: simple: add Tianma TM070JVHG33")

Signed-off-by: Markus Niebel <Markus.Niebel@ew.tq-group.com>
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Reviewed-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://lore.kernel.org/r/20231012084208.2731650-1-alexander.stein@ew.tq-group.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20231012084208.2731650-1-alexander.stein@ew.tq-group.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-simple.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index 005377f58eb4..b714ee1bcbaa 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -3603,6 +3603,7 @@ static const struct panel_desc tianma_tm070jdhg30 = {
 	},
 	.bus_format = MEDIA_BUS_FMT_RGB888_1X7X4_SPWG,
 	.connector_type = DRM_MODE_CONNECTOR_LVDS,
+	.bus_flags = DRM_BUS_FLAG_DE_HIGH,
 };
 
 static const struct panel_desc tianma_tm070jvhg33 = {
@@ -3615,6 +3616,7 @@ static const struct panel_desc tianma_tm070jvhg33 = {
 	},
 	.bus_format = MEDIA_BUS_FMT_RGB888_1X7X4_SPWG,
 	.connector_type = DRM_MODE_CONNECTOR_LVDS,
+	.bus_flags = DRM_BUS_FLAG_DE_HIGH,
 };
 
 static const struct display_timing tianma_tm070rvhg71_timing = {
-- 
2.43.0




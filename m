Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591358;
	b=ObOUohqUgMeai3K3qxakloW+cf6CdkSlPv8xHWHbbaFPnyzqbGbY6aQTpw5I6tRnvwrH
	 Jos8dbprkQtdsDyyBastfSrW29YVw0yVnMHkBBnugrUH74D7epD+PokWZNOFsMbqBqrEL
	 uoyisXwKl4LWGhczsOQBIYJcSKehTiynatIkhkl05Qk/WWfw9uZkiz+WDs0TvyNcw4zaO
	 SFmUG6dhvBUCg+WxgwRWBlClToDs3Y+DfaxW2o7OmMtXZbvHmAAS45kZ4eaiZ2EObkgM0
	 VFvkXdyqvD4wldsCubcBi08jsd1N2oDNQfXXoLXhgzXshov2nvNr1kvffT1xki9J8VQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591358;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Z6TaLcnJUaQDmbxCSPcNjFIS8m5JazygO8opSnCUUSw=;
	b=Ykq64IlvplneKsY6kj4ogtTmS7d4DRiibI1FeDfm44T1G3lFxXrkfnrIsiL0ps8JynXA
	 0+MZgmOZ3NkBavPpDrgMWhxkfssy1gIjgsuvag4nGLfSCJmoBObCU9X/TEVR8Y3Y6fd93
	 MYGD86DMYfc4S0sZcolBtBMUCIGD7uFZ1p880XAyjMF5VDXhFWtfjtlaIXECyObPiHX6r
	 peR5u5olk4GbvbzO9Ma+QBz1J4RsdXjoLW0EfSEvu57alNcicsJKOGmV+k9B/MiGmKlsx
	 CWJfWAEGOcZkA2elFBkBlYOAbByd47eXaL6usJqDY3Q0HFYLGPGe+AnI4dpcAInAncw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jq9p98GD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0B8B606B22D;
	Fri, 13 Nov 2026 17:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jq9p98GD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BF5A1F000C5;
	Fri, 13 Nov 2026 17:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591358;
	bh=Z6TaLcnJUaQDmbxCSPcNjFIS8m5JazygO8opSnCUUSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jq9p98GD75fg2/YW6JwO9BChkuMpzV1RkEDM+r7tqrqOY6HIB0ZjypI5BzNAkOOaP
	 y0RQoB5EEcnPfZPD11mOnkkheu20OBW3K6Hw9wNiBdl1nOHSjsFTjPffcDNNJc5ql4
	 0ZwccmXzU/ErNIslNn0nWlNZEbjx0/uSzmVJjVS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anusha Srivatsa <asrivats@redhat.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 463/670] panel/ebbg-ft8719: Use refcounted allocation in place of devm_kzalloc()
Date: Fri, 13 Nov 2026 10:50:27 -0500
Message-ID: <20261113153827.646502184@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anusha Srivatsa <asrivats@redhat.com>

[ Upstream commit b30a15a4e7e54b676d6c395e71daf5f286997731 ]

Move to using the new API devm_drm_panel_alloc() to allocate the
panel.

Signed-off-by: Anusha Srivatsa <asrivats@redhat.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20250401-b4-drm-panel-mass-driver-convert-v1-9-cdd7615e1f93@redhat.com
Signed-off-by: Maxime Ripard <mripard@kernel.org>
Stable-dep-of: 4eeeac9d7c36 ("drm/panel: ebbg-ft8719: Set prepare_prev_first")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-ebbg-ft8719.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/panel/panel-ebbg-ft8719.c b/drivers/gpu/drm/panel/panel-ebbg-ft8719.c
index e85d63a176d04..74b56ee42fa49 100644
--- a/drivers/gpu/drm/panel/panel-ebbg-ft8719.c
+++ b/drivers/gpu/drm/panel/panel-ebbg-ft8719.c
@@ -198,9 +198,11 @@ static int ebbg_ft8719_probe(struct mipi_dsi_device *dsi)
 	struct ebbg_ft8719 *ctx;
 	int i, ret;
 
-	ctx = devm_kzalloc(dev, sizeof(*ctx), GFP_KERNEL);
-	if (!ctx)
-		return -ENOMEM;
+	ctx = devm_drm_panel_alloc(dev, struct ebbg_ft8719, panel,
+				   &ebbg_ft8719_panel_funcs,
+				   DRM_MODE_CONNECTOR_DSI);
+	if (IS_ERR(ctx))
+		return PTR_ERR(ctx);
 
 	for (i = 0; i < ARRAY_SIZE(ctx->supplies); i++)
 		ctx->supplies[i].supply = regulator_names[i];
@@ -231,9 +233,6 @@ static int ebbg_ft8719_probe(struct mipi_dsi_device *dsi)
 	dsi->mode_flags = MIPI_DSI_MODE_VIDEO | MIPI_DSI_MODE_VIDEO_BURST |
 			  MIPI_DSI_CLOCK_NON_CONTINUOUS;
 
-	drm_panel_init(&ctx->panel, dev, &ebbg_ft8719_panel_funcs,
-		       DRM_MODE_CONNECTOR_DSI);
-
 	ret = drm_panel_of_backlight(&ctx->panel);
 	if (ret)
 		return dev_err_probe(dev, ret, "Failed to get backlight\n");
-- 
2.53.0




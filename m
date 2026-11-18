Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038135;
	b=HNYcnuAeHq7KtjT+e0Qffa1A2LUSLDSoUjboB5RW+XncN9xarpaAxaJuiN7ugYsp+xp4
	 6ZsS/7pYjiDybMZ+YVa7eoMXqtThjOtiA4j3Y+vsHr/FHcfscd9HasiPe9nHwa1wnrRPA
	 YcNUGXcOF46zWN6uAh29VHyV1leDLiEOQ5VynQx3fi1V/cWk6sgGYBFDVdVkKLZ1ZEsAr
	 zcL5+WjvjgSrJPo6srj1FMM8cYJWXyDv2t0wlmiGjQ7vbwOos2HDpttKna4DZiysBHR7X
	 lW0S+QO3Ewh5zmlWUuk8+1ChE7RycAyNzjuR5H9fWHFd8xq328B+jVg7tv0lkmKNOEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038135;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vcfc7mIeQmwb+q3gMH8dfNph42et8DWk5aQRLmasjSQ=;
	b=EnupHguXkh70vPVmk0zxHlCHcvYVjXD+j5DM0G3fo1wAVRlSolV/OcAJ2uEClE1Qz9Cj
	 oaLVYyfDTU+Q1DVDPYsF9GMdlrzWVw1W1r6myKUlccvLaYg6eHGBeheQM0C1SxoOW8uU/
	 3yD08MWuQ7N6vIuiMfdKiZw6Sjyl5P2LnyFdstp81AOFD5q8ymV0DwVWnS21aGguqxK2q
	 4omq248XnUzcH3sY5A3HxvI5aUq22lwzXCWKrn2q1IunxiXJ9DKxi6HvwUfctyydlyAEC
	 o0IqJxgEmk17Gu8yNRouJh1QXwXLSnuRwZC7Sc4dTbtfono7OlaqsUxQgYOxZ7pgN+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TyKJ6Hym;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86268606A325;
	Wed, 18 Nov 2026 21:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TyKJ6Hym
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBFAF1F000C4;
	Wed, 18 Nov 2026 21:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038135;
	bh=vcfc7mIeQmwb+q3gMH8dfNph42et8DWk5aQRLmasjSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TyKJ6HymXBZxCpU8Egn283ZSROApHEW0htGpwIm8L9LouDebtL/G0twZBFGorYA1L
	 O/yyfAQsIX3WQzRTm3FdffymOUnaby06gVNaiNQ/sKeNk2qTB681HSNNYGdkdp72l3
	 V4zu2RMSY1C56HZjbA+VHFKGByTbn0vj2w9RwuGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anusha Srivatsa <asrivats@redhat.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1637/3318] panel/ebbg-ft8719: Use refcounted allocation in place of devm_kzalloc()
Date: Wed, 18 Nov 2026 15:37:39 +0100
Message-ID: <20261118150410.865173472@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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




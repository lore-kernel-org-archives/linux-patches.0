Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92877335567;
	Fri,  9 Jan 2026 12:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961518; cv=none; b=Iog6sA91r4WRDViwFsBDIerP+ZMag0KkT4N0eloAMbXvPU5A3hndaAvmuP91iaB4s2qnynd1y57l5VvfCnO1vTpxb+GGa8DKEJSkPlg71fksn9y6h2R8vEhdciHXLVXCCrYoGvIglt1vtYa0W8xmpfSdIB1exXRr0gJy6D7NHYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961518; c=relaxed/simple;
	bh=dJjk/wu6Fxk+JA9EPVSo6ICD5iq5rRQmrBD/hfreiS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gEmxR+SeSitIQH/WLr4TiFJUhbJiCWCDIDceeqhvoOA+KqgQjTISftP/PPP5z0VGaHkUXgdlVG6HJQLWww7VLWTAtRu4GiAnlI6Y0xD3Pkrjo2vKFG0t9BCwG1ldZiSzwzvdQIrOuDjEv2vzhNHO1QzQg5Sy6OYnl2NvMrKLAus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PCENn5yC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PCENn5yC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17C0EC4CEF1;
	Fri,  9 Jan 2026 12:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961518;
	bh=dJjk/wu6Fxk+JA9EPVSo6ICD5iq5rRQmrBD/hfreiS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PCENn5yCfDCfO7v5tweekAARLW7P19t3Mo5S/wx5A8ocGBZg4Mm8LxEb1o5Caswzd
	 bn0SM0oL6IoNZijSQRmLAWGBoKwEr6mnjnp4XIM3IdHJgs4o9bbF9JyQe8s7V3gRhC
	 hUnf+7hoHNTNYvybkeahT2NmZJ+B9FCozRKKFBM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	=?UTF-8?q?Guido=20G=C3=BCnther?= <agx@sigxcpu.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 043/634] drm/panel: visionox-rm69299: Dont clear all mode flags
Date: Fri,  9 Jan 2026 12:35:21 +0100
Message-ID: <20260109112119.066675756@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guido Günther <agx@sigxcpu.org>

[ Upstream commit 39144b611e9cd4f5814f4098c891b545dd70c536 ]

Don't clear all mode flags. We only want to maek sure we use HS mode
during unprepare.

Fixes: c7f66d32dd431 ("drm/panel: add support for rm69299 visionox panel")
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Guido Günther <agx@sigxcpu.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20250910-shift6mq-panel-v3-2-a7729911afb9@sigxcpu.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-visionox-rm69299.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panel/panel-visionox-rm69299.c b/drivers/gpu/drm/panel/panel-visionox-rm69299.c
index b380bbb0e0d0a..eb8bc6f6c118c 100644
--- a/drivers/gpu/drm/panel/panel-visionox-rm69299.c
+++ b/drivers/gpu/drm/panel/panel-visionox-rm69299.c
@@ -64,7 +64,7 @@ static int visionox_rm69299_unprepare(struct drm_panel *panel)
 	struct visionox_rm69299 *ctx = panel_to_ctx(panel);
 	int ret;
 
-	ctx->dsi->mode_flags = 0;
+	ctx->dsi->mode_flags &= ~MIPI_DSI_MODE_LPM;
 
 	ret = mipi_dsi_dcs_write(ctx->dsi, MIPI_DCS_SET_DISPLAY_OFF, NULL, 0);
 	if (ret < 0)
-- 
2.51.0




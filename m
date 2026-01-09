Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9594C32FA3D;
	Fri,  9 Jan 2026 11:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959428; cv=none; b=cswg1ITcrcnALzJohGNQ3+G/dl6zbi9lyh0zu57MpTrcG+3ymeCTy9CrHzAiG7QX/+ZflqQOO62r6UtrSTwN2CONX/IHAptugehHJ9fU/GflQ1HlbINGRMldphU4mh+xXqDVHr17jfxkPs5j+4htFuKrwG76cQZFoSt8dqREWDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959428; c=relaxed/simple;
	bh=vahHbinXbuBlr+93G5DEIm2FtdC3GiyXhB/x7wAr0Mk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UwXcMxI9/9bA42MMhv523q2w5L+3A2w26rESvz7C/CHbhX/fj16PQrX1M51gXW37EVt7TJfngfYVQi5AMpFZrqzFIjGOotAfAOnp+qI4KEZU3VTjLlUnUY9lPZzXMSdza6b6ECkzVTZ/GTHFo88mPHKOnOzyCodGOggabELALM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=licZ5lHi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="licZ5lHi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB822C4CEF1;
	Fri,  9 Jan 2026 11:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959428;
	bh=vahHbinXbuBlr+93G5DEIm2FtdC3GiyXhB/x7wAr0Mk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=licZ5lHiG0CT2rLlPK81qqrSksXwLUcAdgFbqW1udfl+H3IXxaqZXfm06DXaG7wLc
	 2dfISTvtRueq1Dhs6N2ZswXjLCMSROdu6K/7TEw/X51SmFffIWETiC+82sXC+2nPT9
	 F/FINC4+Ofyh6IZXD9OZ6533uUchDjGsOWcTw5d4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	=?UTF-8?q?Guido=20G=C3=BCnther?= <agx@sigxcpu.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 049/737] drm/panel: visionox-rm69299: Dont clear all mode flags
Date: Fri,  9 Jan 2026 12:33:08 +0100
Message-ID: <20260109112135.839525466@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 6e946e5a036ee..fa784b9998eb0 100644
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




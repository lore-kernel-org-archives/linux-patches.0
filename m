Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D1CD2D2491;
	Thu, 15 Jan 2026 17:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497310; cv=none; b=pM3I9oIB/A84t5SbdEiRS00PBZP2gUuY36npLIzwt5Q9NMaBBAfQbOme5O3LTNgTXD2Y9nWNqWIU4w420tdy6ZFapTK+9BWNDXfWfgBQ6ifNMcDDMPhey7Dr1Wj9WVDLk2pnEga/tRiDBc6bb+DS7TvSbHR34LsI2kRSDbpQXZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497310; c=relaxed/simple;
	bh=h6ku0b3XUN9s422Z2WlFr0NkIULXzzTE3GmwcePygNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Tps3rMhpXSWA8RElJD7hCpxD+EHLXDQZI5ly1eD9itrdqo/E+6ML102uC8RfME03S2lG99LnBU73va5FQCJlG05QFoWCXQwrKLHXxrA4PYKYphWQLMPLkdEdz0SDwZiA10r0Yt6GdYBQzrHfpH1/XniV+xZfszZ1wqx8QCB/vDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YB35PODn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YB35PODn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B789C116D0;
	Thu, 15 Jan 2026 17:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497309;
	bh=h6ku0b3XUN9s422Z2WlFr0NkIULXzzTE3GmwcePygNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YB35PODn5SzrXAcNzCeAuQ9Sud/blF/GEyXAz8Oll6Dr2021wUB7Do20GSrJcf+CY
	 8jDS/Wg6fRCO1mEHVQZfXBIWhXHaii/vPQ219J5rp8wtZhMLO6wLqly/fsvw2QOkw/
	 J+QrXloHkKM8fjegWAHokBpWxep0DirqKiTI7Lig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	=?UTF-8?q?Guido=20G=C3=BCnther?= <agx@sigxcpu.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 037/554] drm/panel: visionox-rm69299: Dont clear all mode flags
Date: Thu, 15 Jan 2026 17:41:43 +0100
Message-ID: <20260115164247.583492208@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6134432e4918d..2260d5abf1ae8 100644
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




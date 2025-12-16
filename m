Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 642793451A3;
	Tue, 16 Dec 2025 11:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885008; cv=none; b=gUNo7z7OqgyfiQeJG3n78H9fELyFxqw4jujFD3lukDkQafnnr422DWNUiQ+qx5zekZ9Hu5CvtJTlRBjCZIJTX74gjmffS4nmTmqZ2fER2d7vm/zqXc+QI0eELyA9MI3a6D0dxgEU+Dupb+L2nxInaAZOYTjk5t7msBmRFhff8GE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885008; c=relaxed/simple;
	bh=2N1EY4cQuA/v4iTibFnAxOIxaZ/ICOYsB+UBpgLnaIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ikL9v/UWQXtMmLtXT23crsD97es/GIialq1SZx1YT4FEY1+dGv9YKibM3COPlbwBsZvhQNi3f8BFQmY4BQIZL/Cky1JYX1EBTIeN4tqLWXdVAWlbql9qRLjxMEdiyGlDxClHDYh2Q6D3s60BKIP/ytaHWLOnSs7opsozh8yJ32c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kk9l7Kx5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kk9l7Kx5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1FB9C4CEF1;
	Tue, 16 Dec 2025 11:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885008;
	bh=2N1EY4cQuA/v4iTibFnAxOIxaZ/ICOYsB+UBpgLnaIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kk9l7Kx564NT8CVryvaDCcoXoR7O08AwMyrCSntxhqZ3tpDbMImOEz2gNEVkqwcet
	 6XJNG8W/XyErPpveS0tDNAhWriN2j6dwy9dQj2MhUl5PfdGvXfGI32MshAkiFz2mcF
	 df9CrEkBMnemZ8BD+yAJNsDwugvklbhHFfWh8Hjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	=?UTF-8?q?Guido=20G=C3=BCnther?= <agx@sigxcpu.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 011/507] drm/panel: visionox-rm69299: Dont clear all mode flags
Date: Tue, 16 Dec 2025 12:07:32 +0100
Message-ID: <20251216111345.943549177@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 5491d601681cf..66c30db3b73a7 100644
--- a/drivers/gpu/drm/panel/panel-visionox-rm69299.c
+++ b/drivers/gpu/drm/panel/panel-visionox-rm69299.c
@@ -192,7 +192,7 @@ static int visionox_rm69299_unprepare(struct drm_panel *panel)
 	struct visionox_rm69299 *ctx = panel_to_ctx(panel);
 	struct mipi_dsi_multi_context dsi_ctx = { .dsi = ctx->dsi };
 
-	ctx->dsi->mode_flags = 0;
+	ctx->dsi->mode_flags &= ~MIPI_DSI_MODE_LPM;
 
 	mipi_dsi_dcs_set_display_off_multi(&dsi_ctx);
 
-- 
2.51.0




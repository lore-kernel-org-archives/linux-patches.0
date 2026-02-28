Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56941338939
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301737; cv=none; b=n7IP9uiue1MEc44l1jlOiMSkCK3LUcD60AL4Jshn8jGOQm6vbuG5sGQ9Ae6CzQpzgvfshcCkbDex8KCCWMAVZLdG0GXNvLX62EIVCVHWY2ROM4q0gyTSEseB+lHXo3O/1vyybAgEflw9atVaDc6Va6bDk2xI3RiXy2dPCJyXmt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301737; c=relaxed/simple;
	bh=EpyK56U2RkFVIxg2Ee30uwVDDY9vqz9L0MsvwP0SBk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=auaA0wqSQzg3wF79nvpM2sH07B92YE8Hz1cedhW74htg02ezt/yfjGtKATzIZuRu5QJAZhHnZZfRs0Ya7bM+qFxTd+ftnAAZ0nayAGCkCE/HYmQ8vnNqIltNHjn3vKZejwC0xzILhIln/PbtTHan6/PoMHBiKkHG6KpB/sFGO3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jGcbO/45; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jGcbO/45"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3554C116D0;
	Sat, 28 Feb 2026 18:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301737;
	bh=EpyK56U2RkFVIxg2Ee30uwVDDY9vqz9L0MsvwP0SBk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jGcbO/45r1N0nTypR7XKSVJQNLiFTnrutzfgf2XkEZMZF8H/sI690N4VZ2ri9qYMI
	 6elA9TGaRajDiI3qL7Gix2G7BqpTdnLPwIl3FrD2XupIK9q3C8dXh24WvMQ0PP2vfn
	 oqynmjXtO/Nyu3iE+jM5s2y+71bsLHuYG77nCu55/rAB11RjSJZek0hfyqya6WXk9g
	 h1kAagD5lgEwX3LujQg8BbcTgpnFFGfiFzs4goeMu+o0tjLbYztC/T92UwrVAfEeky
	 Kt2rz0PtLEPsKrJYMoZrsVQ/K+KHPaLvoCLVMtoEmL5M5gzGCXMZm1IbkMTVDn9AyM
	 q306LvRVjYOGQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: David Heidelberg <david@ixit.cz>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 137/385] drm/panel: sw43408: Remove manual invocation of unprepare at remove
Date: Sat, 28 Feb 2026 12:55:59 -0500
Message-ID: <20260228180011.1568201-137-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: David Heidelberg <david@ixit.cz>

[ Upstream commit cbc1e99a9e0a6c8b22ddcbb40ca37457066f9493 ]

The drm_panel_remove should take care of disable/unprepare. Remove the
manual call from the sw43408_remove function.

Fixes: 069a6c0e94f9 ("drm: panel: Add LG sw43408 panel driver")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: David Heidelberg <david@ixit.cz>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20251214-pixel-3-v7-5-b1c0cf6f224d@ixit.cz
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-lg-sw43408.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/gpu/drm/panel/panel-lg-sw43408.c b/drivers/gpu/drm/panel/panel-lg-sw43408.c
index f3dcc39670eae..8109ded2fe563 100644
--- a/drivers/gpu/drm/panel/panel-lg-sw43408.c
+++ b/drivers/gpu/drm/panel/panel-lg-sw43408.c
@@ -294,10 +294,6 @@ static void sw43408_remove(struct mipi_dsi_device *dsi)
 	struct sw43408_panel *ctx = mipi_dsi_get_drvdata(dsi);
 	int ret;
 
-	ret = sw43408_unprepare(&ctx->base);
-	if (ret < 0)
-		dev_err(&dsi->dev, "failed to unprepare panel: %d\n", ret);
-
 	ret = mipi_dsi_detach(dsi);
 	if (ret < 0)
 		dev_err(&dsi->dev, "failed to detach from DSI host: %d\n", ret);
-- 
2.51.0


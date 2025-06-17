Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA3852FA65D;
	Tue, 17 Jun 2025 16:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178988; cv=none; b=EgYCNPpqy4LxDkq5/X1QX6Dh7hIBicYjFotkbjNpQQmXE6OJDUC6dxNMAzyAHFqHrvmKi2RRnjZ22t97099jV2+GYnUt4ew+h+kgY7iPDvk/7a6pjQvfKfmofrFp+sfnaAGWzT2pcnzoVoonRS2VAOUXs59IuBdrzWTdf9jPIh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178988; c=relaxed/simple;
	bh=D6XxDsy9ddTvoVICQzDH31Yyhohn8TxzZveTqKVsyGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lc7anrckCcSOhU2zG4J7ZHeg1uuqF7cEInzWys/fcjtbodiv6Ia/CekkOi00TWAhBdwPbI3TYhgwiptBR5UMS5OuQ52mIWm540COm4b8sogxHuTncomB3kQXOUwTLMu+ze4c4RV/K2SN7fuJF588luACQCJxKnat8FyT0fwKExg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GfreC3vF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GfreC3vF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49F65C4CEE3;
	Tue, 17 Jun 2025 16:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178987;
	bh=D6XxDsy9ddTvoVICQzDH31Yyhohn8TxzZveTqKVsyGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GfreC3vFnyjztklThFi2ge2uC5H/ztXvIa8Dkq3h1xafMi3jj6xjU4Y6R0nLz5wHh
	 4b5aWy1W/9f2a5b+zT/8cEFjQoyK2QLCaqOPRvu4HbfaU4GZSYimM69HGSS4whDzR1
	 iz/3N/Pv8jKyb4Qjlsh+kTow8c1rnB8utlVXH2+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Walle <mwalle@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 606/780] drm/panel-simple: fix the warnings for the Evervision VGG644804
Date: Tue, 17 Jun 2025 17:25:14 +0200
Message-ID: <20250617152516.159437739@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Walle <mwalle@kernel.org>

[ Upstream commit 5dc1ea903588a73fb03b3a3e5a041a7c63a4bccd ]

The panel lacked the connector type which causes a warning. Adding the
connector type reveals wrong bus_flags and bits per pixel. Fix all of
it.

Fixes: 1319f2178bdf ("drm/panel-simple: add Evervision VGG644804 panel entry")
Signed-off-by: Michael Walle <mwalle@kernel.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20250520074110.655114-1-mwalle@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-simple.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index 33a37539de574..3aaac96c0bfbf 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -2199,13 +2199,14 @@ static const struct display_timing evervision_vgg644804_timing = {
 static const struct panel_desc evervision_vgg644804 = {
 	.timings = &evervision_vgg644804_timing,
 	.num_timings = 1,
-	.bpc = 8,
+	.bpc = 6,
 	.size = {
 		.width = 115,
 		.height = 86,
 	},
 	.bus_format = MEDIA_BUS_FMT_RGB666_1X7X3_SPWG,
-	.bus_flags = DRM_BUS_FLAG_DE_HIGH | DRM_BUS_FLAG_PIXDATA_SAMPLE_NEGEDGE,
+	.bus_flags = DRM_BUS_FLAG_DE_HIGH,
+	.connector_type = DRM_MODE_CONNECTOR_LVDS,
 };
 
 static const struct display_timing evervision_vgg804821_timing = {
-- 
2.39.5




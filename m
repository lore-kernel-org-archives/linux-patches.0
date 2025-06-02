Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3EA31A4F12;
	Mon,  2 Jun 2025 14:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875266; cv=none; b=CpIeZz+ODOGQEE6DqbewweFdLUMGwRwC5n7c+PEhjgtvFFGokMxqPFFNuxBgrl+yUBUSegyKEQ33sQmk9n/c7NQqYkvBzaBMTw6N2H2zl6E9osVRuQjYKbLP+huAWrkbKr/HdPkBV36SebfwNj/npYjBWiHKbc+0GnEYlkAC1G4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875266; c=relaxed/simple;
	bh=1PujuLhoZK2VrerA6nYXKLt8oPmbKHhHTnPsWltr9Aw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TBVHkyJIMOdgORy8AXrXUZrs14Er+uOvWJXVKgFAxGi3PkE088wSWvMbNPiB/DNPaZl5omIzg0DUvMjagoUbkqsj5QJuAO/NIOeSgjvfeVwmqyaXtB49RSO+lCJ0xT37CB35H7NzYPL5lcrBDH6qGc2L3GOM9Di2sIPK+epJdJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RsfP0fvJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RsfP0fvJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AB87C4CEEB;
	Mon,  2 Jun 2025 14:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875266;
	bh=1PujuLhoZK2VrerA6nYXKLt8oPmbKHhHTnPsWltr9Aw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RsfP0fvJ8ubEjXC6vndei1HgKVW6Ao+aDmIobVBfOnhzyg0mv1DLm8k8+v2e0E6hc
	 BQ5PruSN5t3QKQJNBiIw2FBxPX7N5LmCgaXj4QmdGvjrsI0sttFkUqkG90rzl6WZzz
	 pCII4cKdCDK9OfjHRL0nYL9rYfyRNX7HcuMjxTG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Baker <kevinb@ventureresearch.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 080/270] drm/panel: simple: Update timings for AUO G101EVN010
Date: Mon,  2 Jun 2025 15:46:05 +0200
Message-ID: <20250602134310.446872415@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kevin Baker <kevinb@ventureresearch.com>

[ Upstream commit 7c6fa1797a725732981f2d77711c867166737719 ]

Switch to panel timings based on datasheet for the AUO G101EVN01.0
LVDS panel. Default timings were tested on the panel.

Previous mode-based timings resulted in horizontal display shift.

Signed-off-by: Kevin Baker <kevinb@ventureresearch.com>
Fixes: 4fb86404a977 ("drm/panel: simple: Add AUO G101EVN010 panel support")
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20250505170256.1385113-1-kevinb@ventureresearch.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20250505170256.1385113-1-kevinb@ventureresearch.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-simple.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index 07b59021008ea..9cc9c950604a0 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -964,27 +964,28 @@ static const struct panel_desc auo_g070vvn01 = {
 	},
 };
 
-static const struct drm_display_mode auo_g101evn010_mode = {
-	.clock = 68930,
-	.hdisplay = 1280,
-	.hsync_start = 1280 + 82,
-	.hsync_end = 1280 + 82 + 2,
-	.htotal = 1280 + 82 + 2 + 84,
-	.vdisplay = 800,
-	.vsync_start = 800 + 8,
-	.vsync_end = 800 + 8 + 2,
-	.vtotal = 800 + 8 + 2 + 6,
+static const struct display_timing auo_g101evn010_timing = {
+	.pixelclock = { 64000000, 68930000, 85000000 },
+	.hactive = { 1280, 1280, 1280 },
+	.hfront_porch = { 8, 64, 256 },
+	.hback_porch = { 8, 64, 256 },
+	.hsync_len = { 40, 168, 767 },
+	.vactive = { 800, 800, 800 },
+	.vfront_porch = { 4, 8, 100 },
+	.vback_porch = { 4, 8, 100 },
+	.vsync_len = { 8, 16, 223 },
 };
 
 static const struct panel_desc auo_g101evn010 = {
-	.modes = &auo_g101evn010_mode,
-	.num_modes = 1,
+	.timings = &auo_g101evn010_timing,
+	.num_timings = 1,
 	.bpc = 6,
 	.size = {
 		.width = 216,
 		.height = 135,
 	},
 	.bus_format = MEDIA_BUS_FMT_RGB666_1X7X3_SPWG,
+	.bus_flags = DRM_BUS_FLAG_DE_HIGH,
 	.connector_type = DRM_MODE_CONNECTOR_LVDS,
 };
 
-- 
2.39.5




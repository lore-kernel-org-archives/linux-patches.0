Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81FDB50B419;
	Thu, 17 Sep 2026 17:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667612; cv=none; b=J9qvetgy4xjdQw/3ZV1jQqFZerhf5hztDmgoG5EUzZKBRXxwzkx32+69JTRGQt83vO7PWwEDrNaayecqITBazLhep7q1jwpr0BhMWGoFb8/yb+aZShuAVURstIu6xsaJnO4rM3y4ogpBnNaQF0XRkN2HTbV0QHsxmrKzz31XPz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667612; c=relaxed/simple;
	bh=Ii44vrC4wg9hKwLt+9BHtqRzzjSvQItyohirssuahsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FcKmfUHErdR7zeXsYReXuSXzwwD/VJvdoQi4aoJcfxVyBKL3v3BT0r2zOb9qlgw6fDa3FkQSczaqpxRAlkPzwpcLT15ZCm+qHNaUKs6QJDgWJf2u+K2NexJq5243s+RiTg/hixFoskuvD+DH0n3bWlOaQ4kUHf1W9XF3wOLRbHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WPOp+H2A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WPOp+H2A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7A651F000FF;
	Thu, 17 Sep 2026 17:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667610;
	bh=pQ5zdcCSw3mSGU/K/rUcSUOHsgnZVc2bFSyrlQpfvr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WPOp+H2A07Vw1PH2tTtO1IyT28xl4wpyO6CIC8GtkmxNIxldReWibws3yzPSg05k/
	 ywg5I2WomoDVQmK3PPm8Px6IKbhGtc5uMr7etXOdJPhYfkcafOoo2uP9K8EvFNJ9nl
	 D4097h6ye4x3o4fQC6hSgb00+RmuRFJqCxbXJzcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Trimarchi <michael@amarulasolutions.com>,
	Dario Binacchi <dario.binacchi@amarulasolutions.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0150/1102] drm/panel: simple: Add AM-1280800W8TZQW-T00H
Date: Thu, 17 Sep 2026 16:01:33 +0100
Message-ID: <20260917151543.294672785@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dario Binacchi <dario.binacchi@amarulasolutions.com>

[ Upstream commit 6acb810ebc5d8dea5c250326c14dc44e32dc8e92 ]

Add Ampire, AM-1280800W8TZQW-T00H 10.1" TFT LCD panel timings.

Co-developed-by: Michael Trimarchi <michael@amarulasolutions.com>
Signed-off-by: Michael Trimarchi <michael@amarulasolutions.com>
Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20260515082232.1766586-2-dario.binacchi@amarulasolutions.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-simple.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index a0e2da2953768..e54b8f164adb8 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -785,6 +785,31 @@ static const struct panel_desc ampire_am_1280800n3tzqw_t00h = {
 	.connector_type = DRM_MODE_CONNECTOR_LVDS,
 };
 
+static const struct drm_display_mode ampire_am_1280800w8tzqw_t00h_mode = {
+	.clock = 72400,
+	.hdisplay = 1280,
+	.hsync_start = 1280 + 40,
+	.hsync_end = 1280 + 40 + 80,
+	.htotal = 1280 + 40 + 80 + 40,
+	.vdisplay = 800,
+	.vsync_start = 800 + 10,
+	.vsync_end = 800 + 10 + 18,
+	.vtotal = 800 + 10 + 18 + 10,
+};
+
+static const struct panel_desc ampire_am_1280800w8tzqw_t00h = {
+	.modes = &ampire_am_1280800w8tzqw_t00h_mode,
+	.num_modes = 1,
+	.bpc = 8,
+	.size = {
+		.width = 217,
+		.height = 136,
+	},
+	.bus_flags = DRM_BUS_FLAG_DE_HIGH,
+	.bus_format = MEDIA_BUS_FMT_RGB888_1X7X4_SPWG,
+	.connector_type = DRM_MODE_CONNECTOR_LVDS,
+};
+
 static const struct drm_display_mode ampire_am_480272h3tmqw_t01h_mode = {
 	.clock = 9000,
 	.hdisplay = 480,
@@ -4623,6 +4648,9 @@ static const struct of_device_id platform_of_match[] = {
 	{
 		.compatible = "ampire,am-1280800n3tzqw-t00h",
 		.data = &ampire_am_1280800n3tzqw_t00h,
+	}, {
+		.compatible = "ampire,am-1280800w8tzqw-t00h",
+		.data = &ampire_am_1280800w8tzqw_t00h,
 	}, {
 		.compatible = "ampire,am-480272h3tmqw-t01h",
 		.data = &ampire_am_480272h3tmqw_t01h,
-- 
2.53.0




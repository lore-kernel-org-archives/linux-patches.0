Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6766D213E6B;
	Thu, 12 Dec 2024 16:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021212; cv=none; b=qM+hjq/KnoHcbTX0xKNNU6GXo3zuJ06UNHgumlL6y1O1/gzFLupWD5CUydVY9BZdTRAtSztd3UZ4Nbi29n2z/uIps0sCqqjWrSh8s4GwCrgJg1NT74hGztsWwq3kxAVIhEgJ0qw6oYpN1tIPuYKkDZCYs1lo9h9DRqrxxiL5wJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021212; c=relaxed/simple;
	bh=I7tgmevK8Uwp1CAr5G11rvL7aspCPZZPGhRpI8tr2oo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mBf1eIxJ4mj/w7rvVu19NWmjcN9Io096tCf0661Fv/kU3fagxF6KNzDotgajBY4GGt6t/UeZ+Tj+4sfLNEWKMoxUkAeiwQGuK/Ext1Qw+Q7aH6LBw0PWrD/iYf6aJmvi61LC/+zUfAaHoeLeUqQsydk88Y9n7TE7/yvqOH3Gjw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ASuayulc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ASuayulc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ED57C4CECE;
	Thu, 12 Dec 2024 16:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021212;
	bh=I7tgmevK8Uwp1CAr5G11rvL7aspCPZZPGhRpI8tr2oo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ASuayulceiZ9Kj0LqFw9l788TZjL1rVPp2nACg7CMy2QlJiA0mqCQDmjUyDrmbzcW
	 yjL4SlQLv+FlCkmnSQG2h7nchZjqLqUTRw8m6iGQyI6ZepRkvqknmUFQKpvX5Ry0Y8
	 Y2Z8UQCEis5dfwhhtrLFz5tiw8YxqUG8SkqRUmYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manikandan Muralidharan <manikandan.m@microchip.com>,
	Dharma Balasubiramani <dharma.b@microchip.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 676/772] drm/panel: simple: Add Microchip AC69T88A LVDS Display panel
Date: Thu, 12 Dec 2024 16:00:21 +0100
Message-ID: <20241212144417.852695307@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manikandan Muralidharan <manikandan.m@microchip.com>

[ Upstream commit 40da1463cd6879f542238b36c1148f517927c595 ]

Add support for Microchip AC69T88A 5 inch TFT LCD 800x480
Display module with LVDS interface.The panel uses the Sitronix
ST7262 800x480 Display driver

Signed-off-by: Manikandan Muralidharan <manikandan.m@microchip.com>
Signed-off-by: Dharma Balasubiramani <dharma.b@microchip.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240919091548.430285-2-manikandan.m@microchip.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-simple.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index b560d62b6e219..a35e94e2ffd06 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -3908,6 +3908,31 @@ static const struct panel_desc yes_optoelectronics_ytc700tlag_05_201c = {
 	.connector_type = DRM_MODE_CONNECTOR_LVDS,
 };
 
+static const struct drm_display_mode mchp_ac69t88a_mode = {
+	.clock = 25000,
+	.hdisplay = 800,
+	.hsync_start = 800 + 88,
+	.hsync_end = 800 + 88 + 5,
+	.htotal = 800 + 88 + 5 + 40,
+	.vdisplay = 480,
+	.vsync_start = 480 + 23,
+	.vsync_end = 480 + 23 + 5,
+	.vtotal = 480 + 23 + 5 + 1,
+};
+
+static const struct panel_desc mchp_ac69t88a = {
+	.modes = &mchp_ac69t88a_mode,
+	.num_modes = 1,
+	.bpc = 8,
+	.size = {
+		.width = 108,
+		.height = 65,
+	},
+	.bus_flags = DRM_BUS_FLAG_DE_HIGH,
+	.bus_format = MEDIA_BUS_FMT_RGB888_1X7X4_JEIDA,
+	.connector_type = DRM_MODE_CONNECTOR_LVDS,
+};
+
 static const struct drm_display_mode arm_rtsm_mode[] = {
 	{
 		.clock = 65000,
@@ -4325,6 +4350,9 @@ static const struct of_device_id platform_of_match[] = {
 	}, {
 		.compatible = "yes-optoelectronics,ytc700tlag-05-201c",
 		.data = &yes_optoelectronics_ytc700tlag_05_201c,
+	}, {
+		.compatible = "microchip,ac69t88a",
+		.data = &mchp_ac69t88a,
 	}, {
 		/* Must be the last entry */
 		.compatible = "panel-dpi",
-- 
2.43.0




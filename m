Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC0022DB794;
	Wed, 30 Sep 2026 18:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794275; cv=none; b=oFJynzejCTi9ueRwqnHs1zl2Lg+q7B/MjskpYbAithc2CR57ilG695hlnaje6zvxA5M+vpW3K1FxUJnxUlNyTiVpFPB8RFsNk/EBfQz43zFjDHteMfnNkJL8QOcPC5q6a+C0zmpeXIvFeTKKFmKna0lSN9cZfqEmisjjMlJpSr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794275; c=relaxed/simple;
	bh=s6ngACJ/wrxipgcO0780l55BBw/+Hh6W27mPefIjv4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ALCxyw5iLTxKMzCKrMCNrgKGq2zCF9T6I+FrCRKVIe700cAzAOW5LSfnxr5ilyHJeA5BKfVfHFFBwruLTPekF+WfnOr7SBzJJYkJBogfymgI1W8N0WtlpaijROwbqhYV7i+ZLbVwzfpqmyAYglJkSlXS08cNyu1aiSF7f2qncy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NxiGbabu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NxiGbabu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 308111F000FF;
	Wed, 30 Sep 2026 18:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794273;
	bh=XhUJkM/vcjtzRKgkoo8q3rih4otc7EG+w5GyPP0+mow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NxiGbabuEipwXEc4PbbjZIkC/qaipHPQX0nNFWf3VFrUU4i/lND+PE+KlIXJQcdnn
	 Z0X1y8MrcBD0cJmBf9QFjEFr7/wSFQ31fAHNKOwrIj3Tj+62UyMEXzpiwH2fcsqVpX
	 qmvawe3Kntb/xSneo2cl+nHrKtBh7xZ1ggSIfZpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Trimarchi <michael@amarulasolutions.com>,
	Dario Binacchi <dario.binacchi@amarulasolutions.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0108/1193] drm/panel: simple: Add AM-1280800W8TZQW-T00H
Date: Wed, 30 Sep 2026 17:13:12 +0200
Message-ID: <20260930152436.630661625@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 7620ac20393b7..213604d46bbd3 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -737,6 +737,31 @@ static const struct panel_desc ampire_am_1280800n3tzqw_t00h = {
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
@@ -4144,6 +4169,9 @@ static const struct of_device_id platform_of_match[] = {
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




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 983B226F46F;
	Wed, 25 Feb 2026 01:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983942; cv=none; b=pph71wyvuod/IK2QppRLrQy2mro/m9rKYcPCpcG/hgH2A/eOVfTUte3XzfL/6T6BQCpXVyfMkIpIoXrDN/knvA3muqMWUbmnttwhPecfhAmRtCVfEZs/a/JWLi4emmPuCVlp3KlrQdJd3L14elsqvoz0Xfbi40NLpoBEnaskHy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983942; c=relaxed/simple;
	bh=gMXob7u3ke+uQgs3glbPp2kh/0H+ucA/mUfrUUjvI7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CKunYFlAYR2WzAXeDUuSq/qYvPne3Si+YozNjqe0Z/qhOp3AvrIM4lbsWXpwp98Un3BAoIN5CjhXMCDcx7kFAH65kRfyQjSs/RHdOGbf+skEsg0ECBdEurKgX4OQtRaezjSXgMR54u11z95P7KZlFnITJBXAqc4cirx+VgdIQuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iPDSyNuQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iPDSyNuQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57E27C116D0;
	Wed, 25 Feb 2026 01:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983942;
	bh=gMXob7u3ke+uQgs3glbPp2kh/0H+ucA/mUfrUUjvI7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iPDSyNuQF0Zqkk4CWsNQT1lRedbHI5JLHAXJYwkAwbLA1ESKJAG/Mz0oHKGQL0pMS
	 Vb+/nT/+VnlWfMHtLEkSibxHKGVS6noAjElyjR7bydahQIoNHaVM1xrlK79W4sDqCg
	 wCGafkp74i5ZIe9uL18C0Yg3c/1ihCTZQXbd+UQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baihan Li <libaihan@huawei.com>,
	Yongbang Shi <shiyongbang@huawei.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Tao Tian <tiantao6@hisilicon.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 206/641] drm/hisilicon/hibmc: add dp mode valid check
Date: Tue, 24 Feb 2026 17:18:52 -0800
Message-ID: <20260225012353.952126268@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baihan Li <libaihan@huawei.com>

[ Upstream commit 607805abfb747b98f43aa57d6d9ba4caed4d106f ]

If DP is connected, check the DP BW in mode_valid_ctx() to ensure
that DP's link rate supports high-resolution data transmission.

Fixes: 0ab6ea261c1f ("drm/hisilicon/hibmc: add dp module in hibmc")
Signed-off-by: Baihan Li <libaihan@huawei.com>
Signed-off-by: Yongbang Shi <shiyongbang@huawei.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Tao Tian <tiantao6@hisilicon.com>
Link: https://patch.msgid.link/20251210023759.3944834-3-shiyongbang@huawei.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/hisilicon/hibmc/dp/dp_config.h    |  2 ++
 drivers/gpu/drm/hisilicon/hibmc/dp/dp_hw.c    | 10 ++++++++++
 drivers/gpu/drm/hisilicon/hibmc/dp/dp_hw.h    |  2 ++
 .../gpu/drm/hisilicon/hibmc/hibmc_drm_dp.c    | 19 +++++++++++++++++++
 4 files changed, 33 insertions(+)

diff --git a/drivers/gpu/drm/hisilicon/hibmc/dp/dp_config.h b/drivers/gpu/drm/hisilicon/hibmc/dp/dp_config.h
index 08f9e1caf7fcb..efb30a7584758 100644
--- a/drivers/gpu/drm/hisilicon/hibmc/dp/dp_config.h
+++ b/drivers/gpu/drm/hisilicon/hibmc/dp/dp_config.h
@@ -17,5 +17,7 @@
 #define HIBMC_DP_LINK_RATE_CAL		27
 #define HIBMC_DP_SYNC_DELAY(lanes)	((lanes) == 0x2 ? 86 : 46)
 #define HIBMC_DP_INT_ENABLE		0xc
+/* HIBMC_DP_LINK_RATE_CAL * 10000 * 80% = 216000 */
+#define DP_MODE_VALI_CAL		216000
 
 #endif
diff --git a/drivers/gpu/drm/hisilicon/hibmc/dp/dp_hw.c b/drivers/gpu/drm/hisilicon/hibmc/dp/dp_hw.c
index 0ec6ace2d0822..37549dafa06ca 100644
--- a/drivers/gpu/drm/hisilicon/hibmc/dp/dp_hw.c
+++ b/drivers/gpu/drm/hisilicon/hibmc/dp/dp_hw.c
@@ -264,6 +264,16 @@ void hibmc_dp_reset_link(struct hibmc_dp *dp)
 	dp->dp_dev->link.status.channel_equalized = false;
 }
 
+u8 hibmc_dp_get_link_rate(struct hibmc_dp *dp)
+{
+	return dp->dp_dev->link.cap.link_rate;
+}
+
+u8 hibmc_dp_get_lanes(struct hibmc_dp *dp)
+{
+	return dp->dp_dev->link.cap.lanes;
+}
+
 static const struct hibmc_dp_color_raw g_rgb_raw[] = {
 	{CBAR_COLOR_BAR, 0x000, 0x000, 0x000},
 	{CBAR_WHITE,     0xfff, 0xfff, 0xfff},
diff --git a/drivers/gpu/drm/hisilicon/hibmc/dp/dp_hw.h b/drivers/gpu/drm/hisilicon/hibmc/dp/dp_hw.h
index 59c1eae153c55..31316fe1ea8db 100644
--- a/drivers/gpu/drm/hisilicon/hibmc/dp/dp_hw.h
+++ b/drivers/gpu/drm/hisilicon/hibmc/dp/dp_hw.h
@@ -66,5 +66,7 @@ void hibmc_dp_hpd_cfg(struct hibmc_dp *dp);
 void hibmc_dp_enable_int(struct hibmc_dp *dp);
 void hibmc_dp_disable_int(struct hibmc_dp *dp);
 bool hibmc_dp_check_hpd_status(struct hibmc_dp *dp, int exp_status);
+u8 hibmc_dp_get_link_rate(struct hibmc_dp *dp);
+u8 hibmc_dp_get_lanes(struct hibmc_dp *dp);
 
 #endif
diff --git a/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_dp.c b/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_dp.c
index 4a66a107900a1..616821e3c933b 100644
--- a/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_dp.c
+++ b/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_dp.c
@@ -13,6 +13,7 @@
 #include "hibmc_drm_drv.h"
 #include "dp/dp_hw.h"
 #include "dp/dp_comm.h"
+#include "dp/dp_config.h"
 
 #define DP_MASKED_SINK_HPD_PLUG_INT	BIT(2)
 
@@ -81,9 +82,27 @@ static int hibmc_dp_detect(struct drm_connector *connector,
 	return connector_status_disconnected;
 }
 
+static int hibmc_dp_mode_valid(struct drm_connector *connector,
+			       const struct drm_display_mode *mode,
+			       struct drm_modeset_acquire_ctx *ctx,
+			       enum drm_mode_status *status)
+{
+	struct hibmc_dp *dp = to_hibmc_dp(connector);
+	u64 cur_val, max_val;
+
+	/* check DP link BW */
+	cur_val = (u64)mode->clock * HIBMC_DP_BPP;
+	max_val = (u64)hibmc_dp_get_link_rate(dp) * DP_MODE_VALI_CAL * hibmc_dp_get_lanes(dp);
+
+	*status = cur_val > max_val ? MODE_CLOCK_HIGH : MODE_OK;
+
+	return 0;
+}
+
 static const struct drm_connector_helper_funcs hibmc_dp_conn_helper_funcs = {
 	.get_modes = hibmc_dp_connector_get_modes,
 	.detect_ctx = hibmc_dp_detect,
+	.mode_valid_ctx = hibmc_dp_mode_valid,
 };
 
 static int hibmc_dp_late_register(struct drm_connector *connector)
-- 
2.51.0




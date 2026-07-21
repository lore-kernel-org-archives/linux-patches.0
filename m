Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB9C646AA6B;
	Tue, 21 Jul 2026 15:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648443; cv=none; b=l+LWyrK4YoQVUrz2E61KOWlI9Vh30JII34ACfgDiLQ7JyTqOpJXAXtsd+vZtDiOcpnglTZ/GvaC2B6vjXycR5iioHww2PNi3neeWBx3Yo96XoIlDKstQSPlF5U2EHCkiqFKTkhYKIrrIBPbTdZgjwGSfc1aUtAtzwIV8wNvGjNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648443; c=relaxed/simple;
	bh=XVIZtermlfWFbKOKU/PG7JPFP5uzafy/y0Sj2j68WUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m6yXum/u9Bt18CuhBkOUj6xrp2varG/82L3dToxCVzP+YXALC7VXqBAj/2AbA2SMrYfSXbN/LWXgGxNEhaCseDmMM8Q0bPwKb+EqDt7GdE2Psm/Ky2usLDVsCIMHRO96fSmL1i+mknax5uxWYBlMhljLmDJevclh1mfF3+P3oAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q+IChCAX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q+IChCAX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CD9E1F000E9;
	Tue, 21 Jul 2026 15:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648441;
	bh=MAr5XiYy9yV077XMNCZRcNbfizVytDLck5ZSNAJ/HZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q+IChCAX+uPVaarqxAgnfRX+0E99PHEHPuRsBj895E7F6v6qr4p5GicTRwmu+XHSm
	 7OVtqWwUUx0puCAWvExaKHvTvlazIUUcG6NaXmdsapSxMeJEXOkfuiftWRY9WdGOr1
	 KDGDWTUBQmNXllejnw4p7FkztckkgYFK9nLqQOdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lin He <helin52@huawei.com>,
	Yongbang Shi <shiyongbang@huawei.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0201/2077] drm/hisilicon/hibmc: add updating link cap in DP detect()
Date: Tue, 21 Jul 2026 16:57:54 +0200
Message-ID: <20260721152557.422111511@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lin He <helin52@huawei.com>

[ Upstream commit 7d380ef98dd469747b6df43fb0243301b0caaacf ]

In the past, the link cap is updated in link training at encoder enable
stage, but the hibmc_dp_mode_valid() is called before it, which will use
DP link's rate and lanes. So add the hibmc_dp_update_caps() in
hibmc_dp_update_caps() to avoid some potential risks.

Fixes: 607805abfb74 ("drm/hisilicon/hibmc: add dp mode valid check")
Signed-off-by: Lin He <helin52@huawei.com>
Signed-off-by: Yongbang Shi <shiyongbang@huawei.com>
Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patch.msgid.link/20260509032302.2057227-2-shiyongbang@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/hisilicon/hibmc/dp/dp_comm.h   | 1 +
 drivers/gpu/drm/hisilicon/hibmc/dp/dp_link.c   | 2 +-
 drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_dp.c | 2 ++
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/hisilicon/hibmc/dp/dp_comm.h b/drivers/gpu/drm/hisilicon/hibmc/dp/dp_comm.h
index f9ee7ebfec55c3..f53dac256ee0be 100644
--- a/drivers/gpu/drm/hisilicon/hibmc/dp/dp_comm.h
+++ b/drivers/gpu/drm/hisilicon/hibmc/dp/dp_comm.h
@@ -69,5 +69,6 @@ int hibmc_dp_link_training(struct hibmc_dp_dev *dp);
 int hibmc_dp_serdes_init(struct hibmc_dp_dev *dp);
 int hibmc_dp_serdes_rate_switch(u8 rate, struct hibmc_dp_dev *dp);
 int hibmc_dp_serdes_set_tx_cfg(struct hibmc_dp_dev *dp, u8 train_set[HIBMC_DP_LANE_NUM_MAX]);
+void hibmc_dp_update_caps(struct hibmc_dp_dev *dp);
 
 #endif
diff --git a/drivers/gpu/drm/hisilicon/hibmc/dp/dp_link.c b/drivers/gpu/drm/hisilicon/hibmc/dp/dp_link.c
index 0726cb5b736e60..8c53f16db5160f 100644
--- a/drivers/gpu/drm/hisilicon/hibmc/dp/dp_link.c
+++ b/drivers/gpu/drm/hisilicon/hibmc/dp/dp_link.c
@@ -325,7 +325,7 @@ static int hibmc_dp_link_downgrade_training_eq(struct hibmc_dp_dev *dp)
 	return hibmc_dp_link_reduce_rate(dp);
 }
 
-static void hibmc_dp_update_caps(struct hibmc_dp_dev *dp)
+void hibmc_dp_update_caps(struct hibmc_dp_dev *dp)
 {
 	dp->link.cap.link_rate = dp->dpcd[DP_MAX_LINK_RATE];
 	if (dp->link.cap.link_rate > DP_LINK_BW_8_1 || !dp->link.cap.link_rate)
diff --git a/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_dp.c b/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_dp.c
index 616821e3c933bc..35dff7bfbf76f3 100644
--- a/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_dp.c
+++ b/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_dp.c
@@ -41,6 +41,8 @@ static bool hibmc_dp_get_dpcd(struct hibmc_dp_dev *dp_dev)
 	if (ret)
 		return false;
 
+	hibmc_dp_update_caps(dp_dev);
+
 	dp_dev->is_branch = drm_dp_is_branch(dp_dev->dpcd);
 
 	ret = drm_dp_read_desc(dp_dev->aux, &dp_dev->desc, dp_dev->is_branch);
-- 
2.53.0




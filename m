Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59A93405845;
	Tue, 21 Jul 2026 17:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655790; cv=none; b=MM4tsWhma/Iu15Nj0O+dSqruSqM0ajM2EI67KRvUMH2I0fMGz5WWRA32s1GO7knjj5O6Yl1REfVoOCoSXuLcDPsflyJdXDhjNl7B9pl/aiNR2aKcQxUzvGLR2OO0UoW6GYIAsfR6Xy6IFEHhBDUCmFa83vWMmPLP3mBm5YUH/S8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655790; c=relaxed/simple;
	bh=t+z7hfr5z1wBVkBoWoDoN+4Dy1xztuyANP31yc7YSY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DW6lbBXiwt0Qgg4ikib4dNcM+28bkSNcchAQhsCidbJkawTnM2fCUraJUcieIfqC7YIv8SbeQJ7ANU9z5j5rrXyw5Cc/fymLU6/x1dU+bul9ATP6LdDui0HXI90T0qfD1JlhDma+EzUp+O2lI1xEH+Z2fOk8lUqWpyDwEeMCJSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IQJU8tcQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IQJU8tcQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90DF41F00A3E;
	Tue, 21 Jul 2026 17:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655789;
	bh=aTrTOTnKMofxkwULa0G1yYj+VN0wl8wW2tvQRJPJiI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IQJU8tcQ0WGQJRQQFZ32QmySxqZtzf63PeA4mcn+u67+4+D3f5LF6QoSepOP/aGm3
	 OSyU319jN4RV79se0kzy3jNiwDQ61rgMJz25zxulyANIICayQTUBJEFnRm9S7+wnqQ
	 lR/HZqdSPhwQMR3U3yIcoydnkDzgueYSXHUbtivM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lin He <helin52@huawei.com>,
	Yongbang Shi <shiyongbang@huawei.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0140/1611] drm/hisilicon/hibmc: add updating link cap in DP detect()
Date: Tue, 21 Jul 2026 17:04:16 +0200
Message-ID: <20260721152518.023744276@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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




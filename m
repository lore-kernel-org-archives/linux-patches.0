Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7961923D7FA;
	Tue, 26 Aug 2025 11:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207977; cv=none; b=ewlqMj6N2Fq8fDb6HkHTsObDixc0nknGdCF0wb+dsJ1QASvrrAE3DSWtO4yRzUdUQtBcNm++/a6tWue2s5iTL3m3HjyemiaFRieEJB2dZSQn78CohJlOldPWXAoT97N7RYV++kVVxGFZY27mjSJnYe0uundFlGAg90+L3hJlAfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207977; c=relaxed/simple;
	bh=lpKXFFWp+C0Tu33nCx4E1UK2wxZ1JHyv5Cpxl2/RDb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KVGdAuxcYGOm2+ERa4gKxZLXdjKH5aU8tnHapmJeQCdXjJnBP4VockFJ2xswyu3nprBIfQ5jt/C+fdBu3GBdvDO3ZZ4YvHR9bkWGdcgCWQ9LRqKL9SriiyyA22WIL+Vkf5FuQheMbC7NP1Vvfq0LnsWiTxqFJVouWYZh8PIbzfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pr3xpSzO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pr3xpSzO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0770C4CEF1;
	Tue, 26 Aug 2025 11:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207977;
	bh=lpKXFFWp+C0Tu33nCx4E1UK2wxZ1JHyv5Cpxl2/RDb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pr3xpSzOaOELBH4Y1/VWABUlvrjx/eEGAgkBdpB23DiIrIgVKaBye0iVga3W5d5zY
	 ehgeGLqvke9rT74RXk4e7Fd5vB/o4OXkTj3PzUPK0fRS1T8bNKoOcUM1H03NBDYCcZ
	 aMw6jC7NXVbUY6e2+pvve5wQSO1FZHTqxmrry0Us=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baihan Li <libaihan@huawei.com>,
	Yongbang Shi <shiyongbang@huawei.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 391/457] drm/hisilicon/hibmc: fix rare monitors cannot display problem
Date: Tue, 26 Aug 2025 13:11:15 +0200
Message-ID: <20250826110946.958384548@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baihan Li <libaihan@huawei.com>

[ Upstream commit 9f98b429ba67d430b873e06bcfb90afa22888978 ]

In some case, the dp link training success at 8.1Gbps, but the sink's
maximum supported rate is less than 8.1G. So change the default 8.1Gbps
link rate to the rate that reads from devices' capabilities.

Fixes: 54063d86e036 ("drm/hisilicon/hibmc: add dp link moduel in hibmc drivers")
Signed-off-by: Baihan Li <libaihan@huawei.com>
Signed-off-by: Yongbang Shi <shiyongbang@huawei.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250813094238.3722345-6-shiyongbang@huawei.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/hisilicon/hibmc/dp/dp_link.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/hisilicon/hibmc/dp/dp_link.c b/drivers/gpu/drm/hisilicon/hibmc/dp/dp_link.c
index 74f7832ea53e..0726cb5b736e 100644
--- a/drivers/gpu/drm/hisilicon/hibmc/dp/dp_link.c
+++ b/drivers/gpu/drm/hisilicon/hibmc/dp/dp_link.c
@@ -325,6 +325,17 @@ static int hibmc_dp_link_downgrade_training_eq(struct hibmc_dp_dev *dp)
 	return hibmc_dp_link_reduce_rate(dp);
 }
 
+static void hibmc_dp_update_caps(struct hibmc_dp_dev *dp)
+{
+	dp->link.cap.link_rate = dp->dpcd[DP_MAX_LINK_RATE];
+	if (dp->link.cap.link_rate > DP_LINK_BW_8_1 || !dp->link.cap.link_rate)
+		dp->link.cap.link_rate = DP_LINK_BW_8_1;
+
+	dp->link.cap.lanes = dp->dpcd[DP_MAX_LANE_COUNT] & DP_MAX_LANE_COUNT_MASK;
+	if (dp->link.cap.lanes > HIBMC_DP_LANE_NUM_MAX)
+		dp->link.cap.lanes = HIBMC_DP_LANE_NUM_MAX;
+}
+
 int hibmc_dp_link_training(struct hibmc_dp_dev *dp)
 {
 	struct hibmc_dp_link *link = &dp->link;
@@ -334,8 +345,7 @@ int hibmc_dp_link_training(struct hibmc_dp_dev *dp)
 	if (ret)
 		drm_err(dp->dev, "dp aux read dpcd failed, ret: %d\n", ret);
 
-	dp->link.cap.link_rate = dp->dpcd[DP_MAX_LINK_RATE];
-	dp->link.cap.lanes = 0x2;
+	hibmc_dp_update_caps(dp);
 
 	ret = hibmc_dp_get_serdes_rate_cfg(dp);
 	if (ret < 0)
-- 
2.50.1




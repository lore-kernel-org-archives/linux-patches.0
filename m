Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AAC41519AA;
	Wed,  5 Feb 2025 14:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764141; cv=none; b=brWyntos4TIlURXcKqmx5/2vP1Z5OOmN6I9CvF/m/Yj07AYnaw0GyeygTkd/8soYwZCRRUYrCd7pHydFWxvPFugFq6dhBtQoTcJjsS6EZ7ZfMSxCE9BdLke55RTKn/d5U4PvPX9HNbeOlCHy2cxk9cYreo7BIFQVTGFhUuvt3cA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764141; c=relaxed/simple;
	bh=gb26pmD4sLbI9roPfeQFCPLejU3Nz/ZJrUYz2wq8R1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a5AqiyagV79LFJAmisnG1Hj9LMGqDW0yEWLUQAXvX2ladoylBZovALPK5lOB4fXpEnxEHqj7w4zKfopxsAbfeUWLtbb6E5pFeM8JJY1m/ykFNbytt0arHAfxHtA/MK1j3ORDDbAyVsRhAHmztre4TkQbv93B1mS5GARGPyHV24A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kD7+RBoB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kD7+RBoB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83F95C4CED6;
	Wed,  5 Feb 2025 14:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764141;
	bh=gb26pmD4sLbI9roPfeQFCPLejU3Nz/ZJrUYz2wq8R1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kD7+RBoBgqsGzIS7lYG7aT8XT0mIjnHLTYi8N6fCNVH4d+xhCBEBBdm1eVfofLSRY
	 cSDKJvWntINbVRKYSu9hwtdc8OMtZeBn/Wuhx9v5gnU6tr/9HulMVg1mVjlswRM7HP
	 nmT7poUXWBLQXXDH1c0uFQT1VZKMH3gMzoWZHwOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 051/623] drm/msm/dp: do not touch the MMSS_DP_INTF_CONFIG for tpg
Date: Wed,  5 Feb 2025 14:36:33 +0100
Message-ID: <20250205134458.182539920@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abhinav Kumar <quic_abhinavk@quicinc.com>

[ Upstream commit 9ffbf5ef0e8d6e1b76440a6d77311d0c5d6e3979 ]

MMSS_DP_INTF_CONFIG has already been setup by the main datapath
for DP to account for widebus to be used/unused etc.

In current implementation, TPG only switches the DP controller
to use the main datapath stream OR use the test pattern but expects
the rest of the controller to be already setup.

Keeping the same behavior intact, drop the clearing of MMSS_DP_INTF_CONFIG
from the msm_dp_catalog_panel_tpg_enable() API.

Fixes: 757a2f36ab09 ("drm/msm/dp: enable widebus feature for display port")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/626888/
Link: https://lore.kernel.org/r/20241202-tpg-v1-2-0fd6b518b914@quicinc.com
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dp/dp_catalog.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/dp/dp_catalog.c b/drivers/gpu/drm/msm/dp/dp_catalog.c
index b4c8856fb25d0..2a755a06ac490 100644
--- a/drivers/gpu/drm/msm/dp/dp_catalog.c
+++ b/drivers/gpu/drm/msm/dp/dp_catalog.c
@@ -1036,7 +1036,6 @@ void msm_dp_catalog_panel_tpg_enable(struct msm_dp_catalog *msm_dp_catalog,
 	display_hctl = (hsync_end_x << 16) | hsync_start_x;
 
 
-	msm_dp_write_p0(catalog, MMSS_DP_INTF_CONFIG, 0x0);
 	msm_dp_write_p0(catalog, MMSS_DP_INTF_HSYNC_CTL, hsync_ctl);
 	msm_dp_write_p0(catalog, MMSS_DP_INTF_VSYNC_PERIOD_F0, vsync_period *
 			hsync_period);
-- 
2.39.5




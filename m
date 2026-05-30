Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABD7F481DD;
	Sat, 30 May 2026 17:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161060; cv=none; b=YGoSOIzdTPVih7q20hsHeOsFO67UcYymno+vVn+qoZ9T7OFdcOYwL/gUThxcOJf3jm3uhxQmTT0unIvOr+nPk6kfxzREq439mPTJvD0CbDysZsykTIuehxu1R/3b37osJPYt7GDeGoXuiDiWtRrzMfMh3eWvoHnRPxwuL5b1hD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161060; c=relaxed/simple;
	bh=qv5EZXkzAd2SZvGPgFWm9nNbl/7fyTpv2P/j8a8e5j4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NZ/0xBCxFQ2P2gwTtlpGavR8X1AzYjtvATZe9qqX6oOS75CJECDb5z15aMNyQ3uBUMM7xDKufa6mf1Z/Jy+/TkFkbSRBkp02KVsLjIdJdpDZl46g8Aq/0NbOLWx6g2HwPBZvkKE8spzO6ySjk/5kY7MK/CGuvV8lEtvqCv7qWvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LTYO94Qv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LTYO94Qv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C987B1F00893;
	Sat, 30 May 2026 17:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161059;
	bh=ywqzY1sHld65+B5O8bTk1TsAi/2cnhcnsqzxWtrjds0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LTYO94Qvbc5+k2AR0VaozkGOvtKKEfQOnRj776p6O5a8I4CubGK3Ih3U1W4Be5oiy
	 xJ/Gxe1hFaE6ZGno9fwATaqpEeL91lfgimG4pgeGr0LoNmjUqqO42C7Q/CEqu7PKR/
	 SsjYVE4SAtLA3IFcqg7onVGDpRX8QHdar04zwxeE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Alexander Koskovich <akoskovich@pm.me>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 514/969] drm/msm/dsi: rename MSM8998 DSI version from V2_2_0 to V2_0_0
Date: Sat, 30 May 2026 18:00:38 +0200
Message-ID: <20260530160314.532489092@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Koskovich <akoskovich@pm.me>

[ Upstream commit 913a709dea0eff9c7b2e9470f8c8594b9a0114ab ]

The MSM8998 DSI controller is v2.0.0 as stated in commit 7b8c9e203039
("drm/msm/dsi: Add support for MSM8998 DSI controller"). The value was
always correct just the name was wrong.

Rename and reorder to maintain version sorting.

Fixes: 7b8c9e203039 ("drm/msm/dsi: Add support for MSM8998 DSI controller")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Alexander Koskovich <akoskovich@pm.me>
Patchwork: https://patchwork.freedesktop.org/patch/713717/
Link: https://lore.kernel.org/r/20260324-dsi-rgb101010-support-v5-3-ff6afc904115@pm.me
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dsi/dsi_cfg.c | 4 ++--
 drivers/gpu/drm/msm/dsi/dsi_cfg.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/msm/dsi/dsi_cfg.c b/drivers/gpu/drm/msm/dsi/dsi_cfg.c
index e0bd452a9f1e6..4c1c2a77dec98 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_cfg.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_cfg.c
@@ -286,10 +286,10 @@ static const struct msm_dsi_cfg_handler dsi_cfg_handlers[] = {
 		&msm8996_dsi_cfg, &msm_dsi_6g_host_ops},
 	{MSM_DSI_VER_MAJOR_6G, MSM_DSI_6G_VER_MINOR_V1_4_2,
 		&msm8976_dsi_cfg, &msm_dsi_6g_host_ops},
+	{MSM_DSI_VER_MAJOR_6G, MSM_DSI_6G_VER_MINOR_V2_0_0,
+		&msm8998_dsi_cfg, &msm_dsi_6g_v2_host_ops},
 	{MSM_DSI_VER_MAJOR_6G, MSM_DSI_6G_VER_MINOR_V2_1_0,
 		&sdm660_dsi_cfg, &msm_dsi_6g_v2_host_ops},
-	{MSM_DSI_VER_MAJOR_6G, MSM_DSI_6G_VER_MINOR_V2_2_0,
-		&msm8998_dsi_cfg, &msm_dsi_6g_v2_host_ops},
 	{MSM_DSI_VER_MAJOR_6G, MSM_DSI_6G_VER_MINOR_V2_2_1,
 		&sdm845_dsi_cfg, &msm_dsi_6g_v2_host_ops},
 	{MSM_DSI_VER_MAJOR_6G, MSM_DSI_6G_VER_MINOR_V2_3_0,
diff --git a/drivers/gpu/drm/msm/dsi/dsi_cfg.h b/drivers/gpu/drm/msm/dsi/dsi_cfg.h
index 8f04e685a74e9..7b56fc9297212 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_cfg.h
+++ b/drivers/gpu/drm/msm/dsi/dsi_cfg.h
@@ -18,8 +18,8 @@
 #define MSM_DSI_6G_VER_MINOR_V1_3_1	0x10030001
 #define MSM_DSI_6G_VER_MINOR_V1_4_1	0x10040001
 #define MSM_DSI_6G_VER_MINOR_V1_4_2	0x10040002
+#define MSM_DSI_6G_VER_MINOR_V2_0_0	0x20000000
 #define MSM_DSI_6G_VER_MINOR_V2_1_0	0x20010000
-#define MSM_DSI_6G_VER_MINOR_V2_2_0	0x20000000
 #define MSM_DSI_6G_VER_MINOR_V2_2_1	0x20020001
 #define MSM_DSI_6G_VER_MINOR_V2_3_0	0x20030000
 #define MSM_DSI_6G_VER_MINOR_V2_4_0	0x20040000
-- 
2.53.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7C0B77F1E;
	Mon, 15 Apr 2024 14:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191103; cv=none; b=XqOLh5SlqOaAIK3lg5izBaWsMh29L4BViyInPp4W2mC/czUm7Z3aaWLlc68CIpb2WcTWNl95HcjI9JRbjO6jSaJjlLqQyuN1WVY5zIUd0wAkgE0lh9ToKzyUz+oOSggYUAesteS9r0zA5HSsLWggtElRm9YBpc0nbdYRTKBsCVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191103; c=relaxed/simple;
	bh=3H5RK2uQCFiLPTkYqWH7xxpLc4RkH91L6FOoexApv3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kevipBcZXdAX31ZPMwlDLKEbgLtXCbAZEBOGuwhyoWGNZO0UHKxfRAxKbzrUDCeNVjJ1hRK3JSfOC9xwz6GpmdAFDtrTIHrXX9zIXKZhMjI3IzK35f5HmX/iHYhUP5HqaDRuJxGfjlzcUct6WioEst72AHRlGX4hNeydChzf88I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xcRxHazs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xcRxHazs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B77FC2BD11;
	Mon, 15 Apr 2024 14:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191103;
	bh=3H5RK2uQCFiLPTkYqWH7xxpLc4RkH91L6FOoexApv3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xcRxHazsa46NXgZy3hg7LTDhnNk++D5tX2iJH6Dl6NaMDHm92KXulen81XjwF29kr
	 ZPTyLrNVTPo9bXbF2OI/yx01DTQTUs5WqrFh4JFmRUs8mKn3mlNlyOCkvphjm5Vok8
	 z02iT4lnjtoSMq7kpw0zPo3n1+SxbUenYkCs/f1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 033/172] drm/msm/dpu: dont allow overriding data from catalog
Date: Mon, 15 Apr 2024 16:18:52 +0200
Message-ID: <20240415142001.438439088@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 4f3b77ae5ff5b5ba9d99c5d5450db388dbee5107 ]

The data from catalog is marked as const, so it is a part of the RO
segment. Allowing userspace to write to it through debugfs can cause
protection faults. Set debugfs file mode to read-only for debug entries
corresponding to perf_cfg coming from catalog.

Fixes: abda0d925f9c ("drm/msm/dpu: Mark various data tables as const")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/582844/
Link: https://lore.kernel.org/r/20240314-dpu-perf-rework-v3-1-79fa4e065574@linaro.org
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c
index ef871239adb2a..68fae048a9a83 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c
@@ -459,15 +459,15 @@ int dpu_core_perf_debugfs_init(struct dpu_kms *dpu_kms, struct dentry *parent)
 			&perf->core_clk_rate);
 	debugfs_create_u32("enable_bw_release", 0600, entry,
 			(u32 *)&perf->enable_bw_release);
-	debugfs_create_u32("threshold_low", 0600, entry,
+	debugfs_create_u32("threshold_low", 0400, entry,
 			(u32 *)&perf->perf_cfg->max_bw_low);
-	debugfs_create_u32("threshold_high", 0600, entry,
+	debugfs_create_u32("threshold_high", 0400, entry,
 			(u32 *)&perf->perf_cfg->max_bw_high);
-	debugfs_create_u32("min_core_ib", 0600, entry,
+	debugfs_create_u32("min_core_ib", 0400, entry,
 			(u32 *)&perf->perf_cfg->min_core_ib);
-	debugfs_create_u32("min_llcc_ib", 0600, entry,
+	debugfs_create_u32("min_llcc_ib", 0400, entry,
 			(u32 *)&perf->perf_cfg->min_llcc_ib);
-	debugfs_create_u32("min_dram_ib", 0600, entry,
+	debugfs_create_u32("min_dram_ib", 0400, entry,
 			(u32 *)&perf->perf_cfg->min_dram_ib);
 	debugfs_create_file("perf_mode", 0600, entry,
 			(u32 *)perf, &dpu_core_perf_mode_fops);
-- 
2.43.0




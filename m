Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16C962F617C;
	Sat, 12 Sep 2026 12:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215626; cv=none; b=DZzhq5I7Ub+7e/dnWcBLmLsc0oF3cMrLyiCzzXpOxTFsyQ2vWjz/EQKspbVgHlEH92TFdJ8tZUNtbyeELWoEsxcHALhfk1GlRSrS79vHFpZUbHn7Nyt5iluVK7J6Aag/Liw9LJfOI6T34IobNRnbFedn97U9vVR6o/HrOqqbSJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215626; c=relaxed/simple;
	bh=8iENTYuuB50cfbk7HsuueBTTlaaZvLV05tysyLyMU3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sQI0FtXOZQtIMwxoDCczrTm25AUbX9DiPIqC9dPVPe+b7K9raWeGOrB2aRcNcEb50c7hBoijVxbKaQu32wt8GvyK9SlyyZyJGI0+vfLgXkz5kIaQ1oMtge7e50GS8J3GPUl7AHySu8q71KzeXnaPHdj9CoVd++qdLa5HaKgi0xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WpqyncVG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WpqyncVG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 292151F000FF;
	Sat, 12 Sep 2026 12:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215624;
	bh=/vGdxCIc5rBigdxTqPfePLyDO9UQ6hxFJzEcBwmE/Yk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WpqyncVGN0kcupbGx1aIOBfsZFAYQnYYVPAU2rg4HV2rjHU00nIJRrQ/mJqX4s2np
	 gHaJqr9/x09NzR0UjrHvse8u53GdIq/QKeuMyJQ7KeKtZ82yS5BwykeLCS9bEKkLx0
	 Vp6cK3gjlQHiVf1UYZsH3xKcdFR841990mYaHmIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shivam Rawat <shivrawa@qti.qualcomm.com>,
	Akhil P Oommen <akhilpo@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 6.12 0571/1376] drm/msm/a6xx: Fix stale rpmh votes after suspend
Date: Sat, 12 Sep 2026 08:49:57 +0200
Message-ID: <20260912065620.255760858@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Shivam Rawat <shivrawa@qti.qualcomm.com>

[ Upstream commit d9108bfdb746edacdb05bd27959a4ae63c6c7f3f ]

There are stale RPMH votes (BCM votes) observed after GMU suspend. This
is because the rpmh stop sequences are skipped during gmu suspend. Fix
this and also move GMU to reset state to avoid any further activity.

Fixes: f248d5d5159a ("drm/msm/a6xx: Fix PDC sleep sequence")
Signed-off-by: Shivam Rawat <shivrawa@qti.qualcomm.com>
Signed-off-by: Akhil P Oommen <akhilpo@oss.qualcomm.com>
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8650-HDK
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/730652/
Message-ID: <20260605-assorted-fixes-june-v1-1-2caa04f7287c@oss.qualcomm.com>
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gmu.c b/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
index 3e36cec3801ed..99c3abd90c190 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
@@ -514,7 +514,7 @@ static void a6xx_rpmh_stop(struct a6xx_gmu *gmu)
 	int ret;
 	u32 val;
 
-	if (test_and_clear_bit(GMU_STATUS_FW_START, &gmu->status))
+	if (!test_and_clear_bit(GMU_STATUS_FW_START, &gmu->status))
 		return;
 
 	gmu_write(gmu, REG_A6XX_GMU_RSCC_CONTROL_REQ, 1);
@@ -1186,6 +1186,9 @@ static void a6xx_gmu_shutdown(struct a6xx_gmu *gmu)
 	/* Stop the interrupts and mask the hardware */
 	a6xx_gmu_irq_disable(gmu);
 
+	/* Halt the gmu cm3 core */
+	gmu_write(gmu, REG_A6XX_GMU_CM3_SYSRESET, 1);
+
 	/* Tell RPMh to power off the GPU */
 	a6xx_rpmh_stop(gmu);
 
-- 
2.53.0




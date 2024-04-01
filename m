Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E9BEC129;
	Mon,  1 Apr 2024 16:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988518; cv=none; b=HIyHYjSe+1wDdsWoj/HrCIX4ka0yQnNiSOGKiJ/whUH3xt4gylyqlb/xNoAfTOeTntyT5zp83aqmCn6KU0C75/cZ1K41Qk085Yzb2mdPb1MmlW7JhNvaYoSLBD7GsF6eYPf1tBSWsZhPFAA3GFzsLot0UnVBh+eE04s0PGS22Hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988518; c=relaxed/simple;
	bh=JR9WSgUy1OO3w25xkzpFdFVRmj+Eh1dxFfRCRlDK/ng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JO9QUEYmchBGL3x1+wfonC4IaCD+KenMP14FwNmPMLQIYNvmlFGNxxfpXYPuSydVk3Rf3LyhtMjhyWuqmQXKzNQfzNmC92flfy9ZSpSGN+oRDbUVfm+0QSmSc66DzlXeGWceXZLsJucQTSe9HyDnV8jw+vt9++xzlzfBae/e8ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zZ0yj9/T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zZ0yj9/T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05FDDC433C7;
	Mon,  1 Apr 2024 16:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988518;
	bh=JR9WSgUy1OO3w25xkzpFdFVRmj+Eh1dxFfRCRlDK/ng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zZ0yj9/T398Wq6qSu7SIlD8SFDFzASHKZ2WD6lPLNWbd7raiJ0mZzUss/2DnD0LvB
	 /ACcjiADdWk+YPoRTFXiQlLRO4aNDrxDBlGLdvvDCX7MoB0p4rBr91RBSvXuOQfYvu
	 X5NTtwBWs+ACIJoedSA1sXen1yJa0ntnExO2vQus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Jun <Jun.Ma2@amd.com>,
	Yin Zhenguo <zhenguo.yin@amd.com>,
	Lazar Lijo <lijo.lazar@amd.com>,
	Alex Deucher <Alexander.Deucher@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 209/432] drm/amdgpu/pm: Fix NULL pointer dereference when get power limit
Date: Mon,  1 Apr 2024 17:43:16 +0200
Message-ID: <20240401152559.372485115@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Jun <Jun.Ma2@amd.com>

[ Upstream commit 08ae9ef829b8055c2fdc8cfee37510c1f4721a07 ]

Because powerplay_table initialization is skipped under
sriov case, We check and set default lower and upper OD
value if powerplay_table is NULL.

Fixes: 7968e9748fbb ("drm/amdgpu/pm: Fix the power1_min_cap value")
Signed-off-by: Ma Jun <Jun.Ma2@amd.com>
Reported-by: Yin Zhenguo <zhenguo.yin@amd.com>
Suggested-by: Lazar Lijo <lijo.lazar@amd.com>
Suggested-by: Alex Deucher <Alexander.Deucher@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c    | 14 ++++++++------
 drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c  | 16 +++++++++-------
 .../drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c  | 14 ++++++++------
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c | 14 ++++++++------
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c | 14 ++++++++------
 5 files changed, 41 insertions(+), 31 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c
index 294a890beceb4..df4e02d0d1264 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c
@@ -1286,7 +1286,7 @@ static int arcturus_get_power_limit(struct smu_context *smu,
 	struct smu_11_0_powerplay_table *powerplay_table =
 		(struct smu_11_0_powerplay_table *)smu->smu_table.power_play_table;
 	PPTable_t *pptable = smu->smu_table.driver_pptable;
-	uint32_t power_limit, od_percent_upper, od_percent_lower;
+	uint32_t power_limit, od_percent_upper = 0, od_percent_lower = 0;
 
 	if (smu_v11_0_get_current_power_limit(smu, &power_limit)) {
 		/* the last hope to figure out the ppt limit */
@@ -1303,12 +1303,14 @@ static int arcturus_get_power_limit(struct smu_context *smu,
 	if (default_power_limit)
 		*default_power_limit = power_limit;
 
-	if (smu->od_enabled)
-		od_percent_upper = le32_to_cpu(powerplay_table->overdrive_table.max[SMU_11_0_ODSETTING_POWERPERCENTAGE]);
-	else
-		od_percent_upper = 0;
+	if (powerplay_table) {
+		if (smu->od_enabled)
+			od_percent_upper = le32_to_cpu(powerplay_table->overdrive_table.max[SMU_11_0_ODSETTING_POWERPERCENTAGE]);
+		else
+			od_percent_upper = 0;
 
-	od_percent_lower = le32_to_cpu(powerplay_table->overdrive_table.min[SMU_11_0_ODSETTING_POWERPERCENTAGE]);
+		od_percent_lower = le32_to_cpu(powerplay_table->overdrive_table.min[SMU_11_0_ODSETTING_POWERPERCENTAGE]);
+	}
 
 	dev_dbg(smu->adev->dev, "od percent upper:%d, od percent lower:%d (default power: %d)\n",
 							od_percent_upper, od_percent_lower, power_limit);
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c
index aefe72c8abd2d..d36ad0e4e18e2 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c
@@ -2339,7 +2339,7 @@ static int navi10_get_power_limit(struct smu_context *smu,
 		(struct smu_11_0_powerplay_table *)smu->smu_table.power_play_table;
 	struct smu_11_0_overdrive_table *od_settings = smu->od_settings;
 	PPTable_t *pptable = smu->smu_table.driver_pptable;
-	uint32_t power_limit, od_percent_upper, od_percent_lower;
+	uint32_t power_limit, od_percent_upper = 0, od_percent_lower = 0;
 
 	if (smu_v11_0_get_current_power_limit(smu, &power_limit)) {
 		/* the last hope to figure out the ppt limit */
@@ -2356,13 +2356,15 @@ static int navi10_get_power_limit(struct smu_context *smu,
 	if (default_power_limit)
 		*default_power_limit = power_limit;
 
-	if (smu->od_enabled &&
-		    navi10_od_feature_is_supported(od_settings, SMU_11_0_ODCAP_POWER_LIMIT))
-		od_percent_upper = le32_to_cpu(powerplay_table->overdrive_table.max[SMU_11_0_ODSETTING_POWERPERCENTAGE]);
-	else
-		od_percent_upper = 0;
+	if (powerplay_table) {
+		if (smu->od_enabled &&
+			    navi10_od_feature_is_supported(od_settings, SMU_11_0_ODCAP_POWER_LIMIT))
+			od_percent_upper = le32_to_cpu(powerplay_table->overdrive_table.max[SMU_11_0_ODSETTING_POWERPERCENTAGE]);
+		else
+			od_percent_upper = 0;
 
-	od_percent_lower = le32_to_cpu(powerplay_table->overdrive_table.min[SMU_11_0_ODSETTING_POWERPERCENTAGE]);
+		od_percent_lower = le32_to_cpu(powerplay_table->overdrive_table.min[SMU_11_0_ODSETTING_POWERPERCENTAGE]);
+	}
 
 	dev_dbg(smu->adev->dev, "od percent upper:%d, od percent lower:%d (default power: %d)\n",
 					od_percent_upper, od_percent_lower, power_limit);
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
index fa953d4445487..3bb5856655181 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
@@ -625,7 +625,7 @@ static int sienna_cichlid_get_power_limit(struct smu_context *smu,
 {
 	struct smu_11_0_7_powerplay_table *powerplay_table =
 		(struct smu_11_0_7_powerplay_table *)smu->smu_table.power_play_table;
-	uint32_t power_limit, od_percent_upper, od_percent_lower;
+	uint32_t power_limit, od_percent_upper = 0, od_percent_lower = 0;
 	uint16_t *table_member;
 
 	GET_PPTABLE_MEMBER(SocketPowerLimitAc, &table_member);
@@ -640,12 +640,14 @@ static int sienna_cichlid_get_power_limit(struct smu_context *smu,
 	if (default_power_limit)
 		*default_power_limit = power_limit;
 
-	if (smu->od_enabled)
-		od_percent_upper = le32_to_cpu(powerplay_table->overdrive_table.max[SMU_11_0_7_ODSETTING_POWERPERCENTAGE]);
-	else
-		od_percent_upper = 0;
+	if (powerplay_table) {
+		if (smu->od_enabled)
+			od_percent_upper = le32_to_cpu(powerplay_table->overdrive_table.max[SMU_11_0_7_ODSETTING_POWERPERCENTAGE]);
+		else
+			od_percent_upper = 0;
 
-	od_percent_lower = le32_to_cpu(powerplay_table->overdrive_table.min[SMU_11_0_7_ODSETTING_POWERPERCENTAGE]);
+		od_percent_lower = le32_to_cpu(powerplay_table->overdrive_table.min[SMU_11_0_7_ODSETTING_POWERPERCENTAGE]);
+	}
 
 	dev_dbg(smu->adev->dev, "od percent upper:%d, od percent lower:%d (default power: %d)\n",
 					od_percent_upper, od_percent_lower, power_limit);
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
index ac3c9e0966ed6..e5cae0919d474 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
@@ -2351,7 +2351,7 @@ static int smu_v13_0_0_get_power_limit(struct smu_context *smu,
 		(struct smu_13_0_0_powerplay_table *)table_context->power_play_table;
 	PPTable_t *pptable = table_context->driver_pptable;
 	SkuTable_t *skutable = &pptable->SkuTable;
-	uint32_t power_limit, od_percent_upper, od_percent_lower;
+	uint32_t power_limit, od_percent_upper = 0, od_percent_lower = 0;
 	uint32_t msg_limit = skutable->MsgLimits.Power[PPT_THROTTLER_PPT0][POWER_SOURCE_AC];
 
 	if (smu_v13_0_get_current_power_limit(smu, &power_limit))
@@ -2364,12 +2364,14 @@ static int smu_v13_0_0_get_power_limit(struct smu_context *smu,
 	if (default_power_limit)
 		*default_power_limit = power_limit;
 
-	if (smu->od_enabled)
-		od_percent_upper = le32_to_cpu(powerplay_table->overdrive_table.max[SMU_13_0_0_ODSETTING_POWERPERCENTAGE]);
-	else
-		od_percent_upper = 0;
+	if (powerplay_table) {
+		if (smu->od_enabled)
+			od_percent_upper = le32_to_cpu(powerplay_table->overdrive_table.max[SMU_13_0_0_ODSETTING_POWERPERCENTAGE]);
+		else
+			od_percent_upper = 0;
 
-	od_percent_lower = le32_to_cpu(powerplay_table->overdrive_table.min[SMU_13_0_0_ODSETTING_POWERPERCENTAGE]);
+		od_percent_lower = le32_to_cpu(powerplay_table->overdrive_table.min[SMU_13_0_0_ODSETTING_POWERPERCENTAGE]);
+	}
 
 	dev_dbg(smu->adev->dev, "od percent upper:%d, od percent lower:%d (default power: %d)\n",
 					od_percent_upper, od_percent_lower, power_limit);
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
index b296c5f9d98d0..374a4a954b944 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
@@ -2315,7 +2315,7 @@ static int smu_v13_0_7_get_power_limit(struct smu_context *smu,
 		(struct smu_13_0_7_powerplay_table *)table_context->power_play_table;
 	PPTable_t *pptable = table_context->driver_pptable;
 	SkuTable_t *skutable = &pptable->SkuTable;
-	uint32_t power_limit, od_percent_upper, od_percent_lower;
+	uint32_t power_limit, od_percent_upper = 0, od_percent_lower = 0;
 	uint32_t msg_limit = skutable->MsgLimits.Power[PPT_THROTTLER_PPT0][POWER_SOURCE_AC];
 
 	if (smu_v13_0_get_current_power_limit(smu, &power_limit))
@@ -2328,12 +2328,14 @@ static int smu_v13_0_7_get_power_limit(struct smu_context *smu,
 	if (default_power_limit)
 		*default_power_limit = power_limit;
 
-	if (smu->od_enabled)
-		od_percent_upper = le32_to_cpu(powerplay_table->overdrive_table.max[SMU_13_0_7_ODSETTING_POWERPERCENTAGE]);
-	else
-		od_percent_upper = 0;
+	if (powerplay_table) {
+		if (smu->od_enabled)
+			od_percent_upper = le32_to_cpu(powerplay_table->overdrive_table.max[SMU_13_0_7_ODSETTING_POWERPERCENTAGE]);
+		else
+			od_percent_upper = 0;
 
-	od_percent_lower = le32_to_cpu(powerplay_table->overdrive_table.min[SMU_13_0_7_ODSETTING_POWERPERCENTAGE]);
+		od_percent_lower = le32_to_cpu(powerplay_table->overdrive_table.min[SMU_13_0_7_ODSETTING_POWERPERCENTAGE]);
+	}
 
 	dev_dbg(smu->adev->dev, "od percent upper:%d, od percent lower:%d (default power: %d)\n",
 					od_percent_upper, od_percent_lower, power_limit);
-- 
2.43.0




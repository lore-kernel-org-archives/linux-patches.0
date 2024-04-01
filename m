Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 353D8446AC;
	Mon,  1 Apr 2024 15:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987175; cv=none; b=Bo6UQuLBf/vr+Gl0v/xAku2I1BRKKxa7i7SaLwEjSunG8yDdx1fxIk92kek7iuBLSAJHRKGD/xJ2d7tCyCBY6m5JSqt3jMOMlXy1ghd8dv0vsz5ft1uQcHAX0gDTTAlyjAvsV5CNyhdQTbRoiA55AEHwTtn7tA1Q65YFgdE2r0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987175; c=relaxed/simple;
	bh=devAEDwOWGcrsE2ipZDVbXg6adHtjkxcnBgXupGNuqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fWp9cZigle1Ylxg13AdsPOeEkmd/7aA/LeILrVhMimlSgSz1XeEInDRYTzMJ3y3nujjRtLyqjW8kyd74WA2SqpYIRoym87SedcPlvGkxENxbpGWFTihypYKkHMRhFVpXygsiuAMgB73OEns45olMiKNWR9G9kAFQVq3bljuQulc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Eo6XOwgW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Eo6XOwgW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A4F7C433F1;
	Mon,  1 Apr 2024 15:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987174;
	bh=devAEDwOWGcrsE2ipZDVbXg6adHtjkxcnBgXupGNuqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Eo6XOwgWnknAl18umMc6NxxJcsdlJZOBBSPd1Exyxji3L1L8XEyMUT2p/U+62+MF3
	 pchO517mlD8bsVFg2e4wv9NJ8Uo9DnQYwb1xGUFXfalAwuMci1v7T1zMIdCdowDqsf
	 df+m0455PZUfzlhNuTQJPfe+ljySqaCKSPrS/ubs=
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
Subject: [PATCH 6.8 207/399] drm/amdgpu/pm: Fix NULL pointer dereference when get power limit
Date: Mon,  1 Apr 2024 17:42:53 +0200
Message-ID: <20240401152555.361156827@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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
index 1d96eb274d72d..a406372e79d86 100644
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
index ed189a3878ebe..65bba5fc2335e 100644
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
index e2ad2b972ab0b..395718b48131b 100644
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
index 9b80f18ea6c35..7873f024d4294 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
@@ -2356,7 +2356,7 @@ static int smu_v13_0_0_get_power_limit(struct smu_context *smu,
 		(struct smu_13_0_0_powerplay_table *)table_context->power_play_table;
 	PPTable_t *pptable = table_context->driver_pptable;
 	SkuTable_t *skutable = &pptable->SkuTable;
-	uint32_t power_limit, od_percent_upper, od_percent_lower;
+	uint32_t power_limit, od_percent_upper = 0, od_percent_lower = 0;
 	uint32_t msg_limit = skutable->MsgLimits.Power[PPT_THROTTLER_PPT0][POWER_SOURCE_AC];
 
 	if (smu_v13_0_get_current_power_limit(smu, &power_limit))
@@ -2369,12 +2369,14 @@ static int smu_v13_0_0_get_power_limit(struct smu_context *smu,
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
index 3dc7b60cb0754..8abf0a772e6b0 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
@@ -2320,7 +2320,7 @@ static int smu_v13_0_7_get_power_limit(struct smu_context *smu,
 		(struct smu_13_0_7_powerplay_table *)table_context->power_play_table;
 	PPTable_t *pptable = table_context->driver_pptable;
 	SkuTable_t *skutable = &pptable->SkuTable;
-	uint32_t power_limit, od_percent_upper, od_percent_lower;
+	uint32_t power_limit, od_percent_upper = 0, od_percent_lower = 0;
 	uint32_t msg_limit = skutable->MsgLimits.Power[PPT_THROTTLER_PPT0][POWER_SOURCE_AC];
 
 	if (smu_v13_0_get_current_power_limit(smu, &power_limit))
@@ -2333,12 +2333,14 @@ static int smu_v13_0_7_get_power_limit(struct smu_context *smu,
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




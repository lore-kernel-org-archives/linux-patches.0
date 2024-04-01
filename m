Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60409C129;
	Mon,  1 Apr 2024 16:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988522; cv=none; b=KgKi1q1oSEB5y538WrGhPbk6SEBp+po0tgInQMPB9jbkVWe598oSXgzFxjCHgkOnacjzXRR4beDx1o17eI1A2KO0lyzZKXO4Dtfb4jrN9Eb27CyvIPi02RRNWn14Vr6MdI+xTekEtcwGEVpGRJtOQvRq3b+s6Yoi10bOAcee8NI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988522; c=relaxed/simple;
	bh=a3qKAe2JmsKH+LAzcf4TV8R2dSKHGVbgMh/JOYZUKcY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D2Vjpd2zYEnoAxmf0bdq4Yo9HqHi8BsP3r3n/oz2/5/u88egKfP/UNcoRj7mdX8XKapWTaTXXM0tt0WJc97wO2e4h018U92tnYZUkujMcGRVhe6qVCPv6KWM9DNkStssnL41C2Id40lQYexWvonPSVM4aJQ7e3D0/IGdrz4BQFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zJBM6DVl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zJBM6DVl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0595C433C7;
	Mon,  1 Apr 2024 16:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988522;
	bh=a3qKAe2JmsKH+LAzcf4TV8R2dSKHGVbgMh/JOYZUKcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zJBM6DVlopmT9dSBqYLaSC9lxxFBQG3/nQOk74K5g7CgJRdI/eBhztb9JpPzCcToi
	 75M6HgJdnMu5lssUDK9qAx4S2tY9CgMKqSTogwVyCwnny+HYYbnaMQx7VwNC0i/XLo
	 JGDaNvjqTXF/zYRQLLnos8XOJy5mKLPRWLk0f8/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Jun <Jun.Ma2@amd.com>,
	Lazar Lijo <lijo.lazar@amd.com>,
	Alex Deucher <Alexander.Deucher@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 210/432] drm/amdgpu/pm: Check the validity of overdiver power limit
Date: Mon,  1 Apr 2024 17:43:17 +0200
Message-ID: <20240401152559.407514599@linuxfoundation.org>
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

[ Upstream commit e17718251addb31e1771fd28735ec410e6ca650a ]

Check the validity of overdriver power limit before using it.

Fixes: 7968e9748fbb ("drm/amdgpu/pm: Fix the power1_min_cap value")
Signed-off-by: Ma Jun <Jun.Ma2@amd.com>
Suggested-by: Lazar Lijo <lijo.lazar@amd.com>
Suggested-by: Alex Deucher <Alexander.Deucher@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c | 11 +++++----
 .../gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c   |  9 ++++----
 .../amd/pm/swsmu/smu11/sienna_cichlid_ppt.c   | 23 +++++++++++--------
 .../drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c  | 10 ++++----
 .../drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c  | 10 ++++----
 5 files changed, 37 insertions(+), 26 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c
index df4e02d0d1264..ac04ed1e49f35 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c
@@ -1285,6 +1285,7 @@ static int arcturus_get_power_limit(struct smu_context *smu,
 {
 	struct smu_11_0_powerplay_table *powerplay_table =
 		(struct smu_11_0_powerplay_table *)smu->smu_table.power_play_table;
+	struct smu_11_0_overdrive_table *od_settings = smu->od_settings;
 	PPTable_t *pptable = smu->smu_table.driver_pptable;
 	uint32_t power_limit, od_percent_upper = 0, od_percent_lower = 0;
 
@@ -1304,12 +1305,14 @@ static int arcturus_get_power_limit(struct smu_context *smu,
 		*default_power_limit = power_limit;
 
 	if (powerplay_table) {
-		if (smu->od_enabled)
+		if (smu->od_enabled &&
+				od_settings->cap[SMU_11_0_ODCAP_POWER_LIMIT]) {
 			od_percent_upper = le32_to_cpu(powerplay_table->overdrive_table.max[SMU_11_0_ODSETTING_POWERPERCENTAGE]);
-		else
+			od_percent_lower = le32_to_cpu(powerplay_table->overdrive_table.min[SMU_11_0_ODSETTING_POWERPERCENTAGE]);
+		} else if (od_settings->cap[SMU_11_0_ODCAP_POWER_LIMIT]) {
 			od_percent_upper = 0;
-
-		od_percent_lower = le32_to_cpu(powerplay_table->overdrive_table.min[SMU_11_0_ODSETTING_POWERPERCENTAGE]);
+			od_percent_lower = le32_to_cpu(powerplay_table->overdrive_table.min[SMU_11_0_ODSETTING_POWERPERCENTAGE]);
+		}
 	}
 
 	dev_dbg(smu->adev->dev, "od percent upper:%d, od percent lower:%d (default power: %d)\n",
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c
index d36ad0e4e18e2..082101845968c 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c
@@ -2358,12 +2358,13 @@ static int navi10_get_power_limit(struct smu_context *smu,
 
 	if (powerplay_table) {
 		if (smu->od_enabled &&
-			    navi10_od_feature_is_supported(od_settings, SMU_11_0_ODCAP_POWER_LIMIT))
+			    navi10_od_feature_is_supported(od_settings, SMU_11_0_ODCAP_POWER_LIMIT)) {
 			od_percent_upper = le32_to_cpu(powerplay_table->overdrive_table.max[SMU_11_0_ODSETTING_POWERPERCENTAGE]);
-		else
+			od_percent_lower = le32_to_cpu(powerplay_table->overdrive_table.min[SMU_11_0_ODSETTING_POWERPERCENTAGE]);
+		} else if (navi10_od_feature_is_supported(od_settings, SMU_11_0_ODCAP_POWER_LIMIT)) {
 			od_percent_upper = 0;
-
-		od_percent_lower = le32_to_cpu(powerplay_table->overdrive_table.min[SMU_11_0_ODSETTING_POWERPERCENTAGE]);
+			od_percent_lower = le32_to_cpu(powerplay_table->overdrive_table.min[SMU_11_0_ODSETTING_POWERPERCENTAGE]);
+		}
 	}
 
 	dev_dbg(smu->adev->dev, "od percent upper:%d, od percent lower:%d (default power: %d)\n",
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
index 3bb5856655181..6f37ca7a06184 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
@@ -617,6 +617,12 @@ static uint32_t sienna_cichlid_get_throttler_status_locked(struct smu_context *s
 	return throttler_status;
 }
 
+static bool sienna_cichlid_is_od_feature_supported(struct smu_11_0_7_overdrive_table *od_table,
+						   enum SMU_11_0_7_ODFEATURE_CAP cap)
+{
+	return od_table->cap[cap];
+}
+
 static int sienna_cichlid_get_power_limit(struct smu_context *smu,
 					  uint32_t *current_power_limit,
 					  uint32_t *default_power_limit,
@@ -625,6 +631,7 @@ static int sienna_cichlid_get_power_limit(struct smu_context *smu,
 {
 	struct smu_11_0_7_powerplay_table *powerplay_table =
 		(struct smu_11_0_7_powerplay_table *)smu->smu_table.power_play_table;
+	struct smu_11_0_7_overdrive_table *od_settings = smu->od_settings;
 	uint32_t power_limit, od_percent_upper = 0, od_percent_lower = 0;
 	uint16_t *table_member;
 
@@ -641,12 +648,14 @@ static int sienna_cichlid_get_power_limit(struct smu_context *smu,
 		*default_power_limit = power_limit;
 
 	if (powerplay_table) {
-		if (smu->od_enabled)
+		if (smu->od_enabled &&
+				sienna_cichlid_is_od_feature_supported(od_settings, SMU_11_0_7_ODCAP_POWER_LIMIT)) {
 			od_percent_upper = le32_to_cpu(powerplay_table->overdrive_table.max[SMU_11_0_7_ODSETTING_POWERPERCENTAGE]);
-		else
+			od_percent_lower = le32_to_cpu(powerplay_table->overdrive_table.min[SMU_11_0_7_ODSETTING_POWERPERCENTAGE]);
+		} else if ((sienna_cichlid_is_od_feature_supported(od_settings, SMU_11_0_7_ODCAP_POWER_LIMIT))) {
 			od_percent_upper = 0;
-
-		od_percent_lower = le32_to_cpu(powerplay_table->overdrive_table.min[SMU_11_0_7_ODSETTING_POWERPERCENTAGE]);
+			od_percent_lower = le32_to_cpu(powerplay_table->overdrive_table.min[SMU_11_0_7_ODSETTING_POWERPERCENTAGE]);
+		}
 	}
 
 	dev_dbg(smu->adev->dev, "od percent upper:%d, od percent lower:%d (default power: %d)\n",
@@ -1252,12 +1261,6 @@ static bool sienna_cichlid_is_support_fine_grained_dpm(struct smu_context *smu,
 	return dpm_desc->SnapToDiscrete == 0;
 }
 
-static bool sienna_cichlid_is_od_feature_supported(struct smu_11_0_7_overdrive_table *od_table,
-						   enum SMU_11_0_7_ODFEATURE_CAP cap)
-{
-	return od_table->cap[cap];
-}
-
 static void sienna_cichlid_get_od_setting_range(struct smu_11_0_7_overdrive_table *od_table,
 						enum SMU_11_0_7_ODSETTING_ID setting,
 						uint32_t *min, uint32_t *max)
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
index e5cae0919d474..9ac6c408d2b68 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
@@ -2365,12 +2365,14 @@ static int smu_v13_0_0_get_power_limit(struct smu_context *smu,
 		*default_power_limit = power_limit;
 
 	if (powerplay_table) {
-		if (smu->od_enabled)
+		if (smu->od_enabled &&
+				smu_v13_0_0_is_od_feature_supported(smu, PP_OD_FEATURE_PPT_BIT)) {
 			od_percent_upper = le32_to_cpu(powerplay_table->overdrive_table.max[SMU_13_0_0_ODSETTING_POWERPERCENTAGE]);
-		else
+			od_percent_lower = le32_to_cpu(powerplay_table->overdrive_table.min[SMU_13_0_0_ODSETTING_POWERPERCENTAGE]);
+		} else if (smu_v13_0_0_is_od_feature_supported(smu, PP_OD_FEATURE_PPT_BIT)) {
 			od_percent_upper = 0;
-
-		od_percent_lower = le32_to_cpu(powerplay_table->overdrive_table.min[SMU_13_0_0_ODSETTING_POWERPERCENTAGE]);
+			od_percent_lower = le32_to_cpu(powerplay_table->overdrive_table.min[SMU_13_0_0_ODSETTING_POWERPERCENTAGE]);
+		}
 	}
 
 	dev_dbg(smu->adev->dev, "od percent upper:%d, od percent lower:%d (default power: %d)\n",
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
index 374a4a954b944..402e0d184e147 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
@@ -2329,12 +2329,14 @@ static int smu_v13_0_7_get_power_limit(struct smu_context *smu,
 		*default_power_limit = power_limit;
 
 	if (powerplay_table) {
-		if (smu->od_enabled)
+		if (smu->od_enabled &&
+				(smu_v13_0_7_is_od_feature_supported(smu, PP_OD_FEATURE_PPT_BIT))) {
 			od_percent_upper = le32_to_cpu(powerplay_table->overdrive_table.max[SMU_13_0_7_ODSETTING_POWERPERCENTAGE]);
-		else
+			od_percent_lower = le32_to_cpu(powerplay_table->overdrive_table.min[SMU_13_0_7_ODSETTING_POWERPERCENTAGE]);
+		} else if (smu_v13_0_7_is_od_feature_supported(smu, PP_OD_FEATURE_PPT_BIT)) {
 			od_percent_upper = 0;
-
-		od_percent_lower = le32_to_cpu(powerplay_table->overdrive_table.min[SMU_13_0_7_ODSETTING_POWERPERCENTAGE]);
+			od_percent_lower = le32_to_cpu(powerplay_table->overdrive_table.min[SMU_13_0_7_ODSETTING_POWERPERCENTAGE]);
+		}
 	}
 
 	dev_dbg(smu->adev->dev, "od percent upper:%d, od percent lower:%d (default power: %d)\n",
-- 
2.43.0




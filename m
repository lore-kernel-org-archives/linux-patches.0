Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591437;
	b=tycDZ66MHlNRTXCgVdTZqUDuV5xZfh/tEhhoJm587l1RGol4iXnHw9um1Hk0htgpK+sm
	 32GKg+wc+0cy/sEOuUuXZ6ZExEoIZGIjgBv+0FY9uo/L8OtZVDVJyrnk6qqxBxZMVHR8o
	 V96bWsk8o/y6OIFeh1sPAyLoef7DQbEvNJvbKjF76a5IrX5SKfhTCU7n/RWJnIIVTd2IQ
	 4dgdYIm05TFfmvcpSioszLxvGmCwsSxQBj7lhvOV2UEW5MjExSWd0bbqrl/fBJaqotIjD
	 69p1YRu1UPwfZ4I09hQUhCHcFAh240WhCPNp2ngCTYMKGfy5xk91Rw1rBb0wr3llzzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591437;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b3xtOFqxwCQ9Ql8BGdhsJCrGEJ6x6jdjVzSTW67VmMw=;
	b=kEA4GCw9qRHVns5/RtdNrBj70tU39FOy/aolaJ8ooH7K9PLVhn7zu1O6fNlptR3slAhJ
	 1KG5vrw7xse9iaxw6+15xT3vyJyXHEGdMVHrxqoh2o9lyPFeMUdqChP4Fny/m1eef0juf
	 dTX2Xq/Vz7IMFJuuz/RtWdjeLfRGrb/M4p1gVr2uDQFzH0aYUlxDbt0mHdlMB99IPD8I0
	 DdZohDXSuF80T9zTgNBSbaN/q6n3yuW5pI+o1ZgeWQQ4XElvh0rse4tmEAbxM5A2TzkIX
	 hzBqGMSfUlrdiGbMDeInKr2fFS9U0pL7ss58rdNHYVr8hfcgeuBXcP5AV5jTjJQ1WtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a4X2aYQz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48402607C340;
	Fri, 13 Nov 2026 17:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a4X2aYQz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E768A1F000C4;
	Fri, 13 Nov 2026 17:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591437;
	bh=b3xtOFqxwCQ9Ql8BGdhsJCrGEJ6x6jdjVzSTW67VmMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a4X2aYQzi+br4q3X9HLveWch5vCXPC79ZgOIX7mabf+sr4ln4nFvvdqqnf6iQ2/wn
	 ddXkoiuYiI9gPhefp/8hnspT44nv/SS5+bYArghIBVf5sGi9HIKxpxYQnQWBJ3kxbu
	 2NtzTSOaTPC7kf3fekU5FzExUWjEAQIHIHqDnPew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kenneth Feng <kenneth.feng@amd.com>,
	Kevin Wang <kevin.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 529/670] drm/amd/pm:restate all customized OD features on every table upload for smu 13.0.0/smu 14.0.2
Date: Fri, 13 Nov 2026 10:51:33 -0500
Message-ID: <20261113153829.847243746@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kenneth Feng <kenneth.feng@amd.com>

[ Upstream commit 44d0d3031e47973ed65fd327669d5e2eaaf6c565 ]

PMFW interprets OverDriveTable.FeatureCtrlMask as the complete set of
overdrive features that are currently overridden, not as a delta
describing the operation at hand. On import it resets every feature
whose bit is clear back to its default value - for the VF curve that
means zeroing VoltageOffsetPerZoneBoundary[] outright.

The driver assumed the opposite. smu_v14_0_2_od_edit_dpm_table() clears
the mask after a successful commit, so a subsequent above-default
power1_cap write goes through smu_v14_0_2_set_ppt_limit() and uploads a
table carrying only PP_OD_FEATURE_PPT_BIT. PMFW then drops the user's
voltage offset and reverts to the stock V/F curve, while the driver's
cached user table still reports the offset through pp_od_clk_voltage.

Closes: https://gitlab.freedesktop.org/drm/amd/-/work_items/5935
Signed-off-by: Kenneth Feng <kenneth.feng@amd.com>
Reviewed-by: Kevin Wang <kevin.wang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 1b63bb397db208a8f84778a9d9cafc93da9373eb)
Cc: stable@vger.kernel.org
[ sashal: Adapted set_ppt_limit() changes to existing set_power_limit() functions with cached power-limit checks. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/inc/amdgpu_smu.h |  2 +
 .../drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c  | 34 +++++++----------
 .../drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c  | 31 +++++++--------
 .../drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c  | 38 +++++++++++--------
 4 files changed, 52 insertions(+), 53 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/inc/amdgpu_smu.h b/drivers/gpu/drm/amd/pm/swsmu/inc/amdgpu_smu.h
index 0145aff45c385..9521be67373a4 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/inc/amdgpu_smu.h
+++ b/drivers/gpu/drm/amd/pm/swsmu/inc/amdgpu_smu.h
@@ -358,6 +358,8 @@ struct smu_table_context {
 	void                            *boot_overdrive_table;
 	void				*user_overdrive_table;
 
+	uint32_t			user_od_feature_mask;
+
 	uint32_t			gpu_metrics_table_size;
 	void				*gpu_metrics_table;
 };
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
index 6d178621ade16..5793f85d16fe3 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
@@ -1610,7 +1610,6 @@ static int smu_v13_0_0_od_edit_dpm_table(struct smu_context *smu,
 	struct amdgpu_device *adev = smu->adev;
 	uint32_t offset_of_voltageoffset;
 	int32_t minimum, maximum;
-	uint32_t feature_ctrlmask;
 	int i, ret = 0;
 
 	switch (type) {
@@ -1890,21 +1889,16 @@ static int smu_v13_0_0_od_edit_dpm_table(struct smu_context *smu,
 			if (ret)
 				return ret;
 		} else {
-			feature_ctrlmask = od_table->OverDriveTable.FeatureCtrlMask;
 			memcpy(od_table,
 		       table_context->boot_overdrive_table,
 		       sizeof(OverDriveTableExternal_t));
-			od_table->OverDriveTable.FeatureCtrlMask = feature_ctrlmask;
+			od_table->OverDriveTable.FeatureCtrlMask = 0;
+			table_context->user_od_feature_mask = 0;
 		}
 		fallthrough;
 	case PP_OD_COMMIT_DPM_TABLE:
-		/*
-		 * The member below instructs PMFW the settings focused in
-		 * this single operation.
-		 * `uint32_t FeatureCtrlMask;`
-		 * It does not contain actual informations about user's custom
-		 * settings. Thus we do not cache it.
-		 */
+		table_context->user_od_feature_mask =
+			od_table->OverDriveTable.FeatureCtrlMask;
 		offset_of_voltageoffset = offsetof(OverDriveTable_t, VoltageOffsetPerZoneBoundary);
 		if (memcmp((u8 *)od_table + offset_of_voltageoffset,
 			   table_context->user_overdrive_table + offset_of_voltageoffset,
@@ -1917,7 +1911,6 @@ static int smu_v13_0_0_od_edit_dpm_table(struct smu_context *smu,
 				return ret;
 			}
 
-			od_table->OverDriveTable.FeatureCtrlMask = 0;
 			memcpy(table_context->user_overdrive_table + offset_of_voltageoffset,
 			       (u8 *)od_table + offset_of_voltageoffset,
 			       sizeof(OverDriveTableExternal_t) - offset_of_voltageoffset);
@@ -2191,6 +2184,7 @@ static int smu_v13_0_0_set_default_od_settings(struct smu_context *smu)
 		       boot_od_table,
 		       sizeof(OverDriveTableExternal_t));
 		smu->user_dpm_profile.user_od = false;
+		smu->smu_table.user_od_feature_mask = 0;
 	} else if (smu->user_dpm_profile.user_od) {
 		memcpy(&user_od_table_bak,
 		       user_od_table,
@@ -2236,11 +2230,8 @@ static int smu_v13_0_0_restore_user_od_settings(struct smu_context *smu)
 	OverDriveTableExternal_t *od_table = table_context->overdrive_table;
 	OverDriveTableExternal_t *user_od_table = table_context->user_overdrive_table;
 	int res;
-
-	user_od_table->OverDriveTable.FeatureCtrlMask = BIT(PP_OD_FEATURE_GFXCLK_BIT) |
-							BIT(PP_OD_FEATURE_UCLK_BIT) |
-							BIT(PP_OD_FEATURE_GFX_VF_CURVE_BIT) |
-							BIT(PP_OD_FEATURE_FAN_CURVE_BIT);
+	user_od_table->OverDriveTable.FeatureCtrlMask =
+		table_context->user_od_feature_mask;
 	res = smu_v13_0_0_upload_overdrive_table(smu, user_od_table);
 	user_od_table->OverDriveTable.FeatureCtrlMask = 0;
 	if (res == 0)
@@ -3060,8 +3051,10 @@ static int smu_v13_0_0_set_power_limit(struct smu_context *smu,
 	if (limit <= msg_limit) {
 		if (smu->current_power_limit > msg_limit) {
 			od_table->OverDriveTable.Ppt = 0;
-			od_table->OverDriveTable.FeatureCtrlMask |= 1U << PP_OD_FEATURE_PPT_BIT;
-
+			table_context->user_od_feature_mask &=
+				~(1U << PP_OD_FEATURE_PPT_BIT);
+			od_table->OverDriveTable.FeatureCtrlMask =
+				table_context->user_od_feature_mask;
 			ret = smu_v13_0_0_upload_overdrive_table(smu, od_table);
 			if (ret) {
 				dev_err(smu->adev->dev, "Failed to upload overdrive table!\n");
@@ -3075,8 +3068,9 @@ static int smu_v13_0_0_set_power_limit(struct smu_context *smu,
 			return ret;
 
 		od_table->OverDriveTable.Ppt = (limit * 100) / msg_limit - 100;
-		od_table->OverDriveTable.FeatureCtrlMask |= 1U << PP_OD_FEATURE_PPT_BIT;
-
+		table_context->user_od_feature_mask |= 1U << PP_OD_FEATURE_PPT_BIT;
+		od_table->OverDriveTable.FeatureCtrlMask =
+			table_context->user_od_feature_mask;
 		ret = smu_v13_0_0_upload_overdrive_table(smu, od_table);
 		if (ret) {
 		  dev_err(smu->adev->dev, "Failed to upload overdrive table!\n");
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
index 7a0e82a96a1c1..9467db88969c6 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
@@ -1598,7 +1598,6 @@ static int smu_v13_0_7_od_edit_dpm_table(struct smu_context *smu,
 	struct amdgpu_device *adev = smu->adev;
 	uint32_t offset_of_voltageoffset;
 	int32_t minimum, maximum;
-	uint32_t feature_ctrlmask;
 	int i, ret = 0;
 
 	switch (type) {
@@ -1878,22 +1877,17 @@ static int smu_v13_0_7_od_edit_dpm_table(struct smu_context *smu,
 			if (ret)
 				return ret;
 		} else {
-			feature_ctrlmask = od_table->OverDriveTable.FeatureCtrlMask;
 			memcpy(od_table,
 					table_context->boot_overdrive_table,
 					sizeof(OverDriveTableExternal_t));
-			od_table->OverDriveTable.FeatureCtrlMask = feature_ctrlmask;
+			od_table->OverDriveTable.FeatureCtrlMask = 0;
+			table_context->user_od_feature_mask = 0;
 		}
 		fallthrough;
 
 	case PP_OD_COMMIT_DPM_TABLE:
-		/*
-		 * The member below instructs PMFW the settings focused in
-		 * this single operation.
-		 * `uint32_t FeatureCtrlMask;`
-		 * It does not contain actual informations about user's custom
-		 * settings. Thus we do not cache it.
-		 */
+		table_context->user_od_feature_mask =
+			od_table->OverDriveTable.FeatureCtrlMask;
 		offset_of_voltageoffset = offsetof(OverDriveTable_t, VoltageOffsetPerZoneBoundary);
 		if (memcmp((u8 *)od_table + offset_of_voltageoffset,
 			   table_context->user_overdrive_table + offset_of_voltageoffset,
@@ -1906,7 +1900,6 @@ static int smu_v13_0_7_od_edit_dpm_table(struct smu_context *smu,
 				return ret;
 			}
 
-			od_table->OverDriveTable.FeatureCtrlMask = 0;
 			memcpy(table_context->user_overdrive_table + offset_of_voltageoffset,
 			       (u8 *)od_table + offset_of_voltageoffset,
 			       sizeof(OverDriveTableExternal_t) - offset_of_voltageoffset);
@@ -2174,6 +2167,7 @@ static int smu_v13_0_7_set_default_od_settings(struct smu_context *smu)
 		       boot_od_table,
 		       sizeof(OverDriveTableExternal_t));
 		smu->user_dpm_profile.user_od = false;
+		smu->smu_table.user_od_feature_mask = 0;
 	} else if (smu->user_dpm_profile.user_od) {
 		memcpy(&user_od_table_bak,
 		       user_od_table,
@@ -2220,10 +2214,8 @@ static int smu_v13_0_7_restore_user_od_settings(struct smu_context *smu)
 	OverDriveTableExternal_t *user_od_table = table_context->user_overdrive_table;
 	int res;
 
-	user_od_table->OverDriveTable.FeatureCtrlMask = BIT(PP_OD_FEATURE_GFXCLK_BIT) |
-							BIT(PP_OD_FEATURE_UCLK_BIT) |
-							BIT(PP_OD_FEATURE_GFX_VF_CURVE_BIT) |
-							BIT(PP_OD_FEATURE_FAN_CURVE_BIT);
+	user_od_table->OverDriveTable.FeatureCtrlMask =
+		table_context->user_od_feature_mask;
 	res = smu_v13_0_7_upload_overdrive_table(smu, user_od_table);
 	user_od_table->OverDriveTable.FeatureCtrlMask = 0;
 	if (res == 0)
@@ -2641,7 +2633,10 @@ static int smu_v13_0_7_set_power_limit(struct smu_context *smu,
 	if (limit <= msg_limit) {
 		if (smu->current_power_limit > msg_limit) {
 			od_table->OverDriveTable.Ppt = 0;
-			od_table->OverDriveTable.FeatureCtrlMask |= 1U << PP_OD_FEATURE_PPT_BIT;
+			table_context->user_od_feature_mask &=
+				~(1U << PP_OD_FEATURE_PPT_BIT);
+			od_table->OverDriveTable.FeatureCtrlMask =
+				table_context->user_od_feature_mask;
 
 			ret = smu_v13_0_7_upload_overdrive_table(smu, od_table);
 			if (ret) {
@@ -2656,7 +2651,9 @@ static int smu_v13_0_7_set_power_limit(struct smu_context *smu,
 			return ret;
 
 		od_table->OverDriveTable.Ppt = (limit * 100) / msg_limit - 100;
-		od_table->OverDriveTable.FeatureCtrlMask |= 1U << PP_OD_FEATURE_PPT_BIT;
+		table_context->user_od_feature_mask |= 1U << PP_OD_FEATURE_PPT_BIT;
+		od_table->OverDriveTable.FeatureCtrlMask =
+			table_context->user_od_feature_mask;
 
 		ret = smu_v13_0_7_upload_overdrive_table(smu, od_table);
 		if (ret) {
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c
index b2c32b2d2e510..33da78b53a866 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c
@@ -2350,6 +2350,7 @@ static int smu_v14_0_2_set_default_od_settings(struct smu_context *smu)
 		       boot_od_table,
 		       sizeof(OverDriveTableExternal_t));
 		smu->user_dpm_profile.user_od = false;
+		smu->smu_table.user_od_feature_mask = 0;
 	} else if (smu->user_dpm_profile.user_od) {
 		memcpy(&user_od_table_bak,
 		       user_od_table,
@@ -2394,11 +2395,8 @@ static int smu_v14_0_2_restore_user_od_settings(struct smu_context *smu)
 	OverDriveTableExternal_t *user_od_table = table_context->user_overdrive_table;
 	int res;
 
-	user_od_table->OverDriveTable.FeatureCtrlMask = BIT(PP_OD_FEATURE_GFXCLK_BIT) |
-							BIT(PP_OD_FEATURE_UCLK_BIT) |
-							BIT(PP_OD_FEATURE_GFX_VF_CURVE_BIT) |
-							BIT(PP_OD_FEATURE_FAN_CURVE_BIT) |
-							BIT(PP_OD_FEATURE_ZERO_FAN_BIT);
+	user_od_table->OverDriveTable.FeatureCtrlMask =
+		table_context->user_od_feature_mask;
 	res = smu_v14_0_2_upload_overdrive_table(smu, user_od_table);
 	user_od_table->OverDriveTable.FeatureCtrlMask = 0;
 	if (res == 0)
@@ -2473,7 +2471,6 @@ static int smu_v14_0_2_od_edit_dpm_table(struct smu_context *smu,
 	struct amdgpu_device *adev = smu->adev;
 	uint32_t offset_of_voltageoffset;
 	int32_t minimum, maximum;
-	uint32_t feature_ctrlmask;
 	int i, ret = 0;
 
 	switch (type) {
@@ -2720,21 +2717,26 @@ static int smu_v14_0_2_od_edit_dpm_table(struct smu_context *smu,
 			if (ret)
 				return ret;
 		} else {
-			feature_ctrlmask = od_table->OverDriveTable.FeatureCtrlMask;
 			memcpy(od_table,
 		       table_context->boot_overdrive_table,
 		       sizeof(OverDriveTableExternal_t));
-			od_table->OverDriveTable.FeatureCtrlMask = feature_ctrlmask;
+			od_table->OverDriveTable.FeatureCtrlMask = 0;
+			table_context->user_od_feature_mask = 0;
 		}
 		fallthrough;
 	case PP_OD_COMMIT_DPM_TABLE:
 		/*
-		 * The member below instructs PMFW the settings focused in
-		 * this single operation.
-		 * `uint32_t FeatureCtrlMask;`
-		 * It does not contain actual informations about user's custom
-		 * settings. Thus we do not cache it.
+		 * PMFW interprets FeatureCtrlMask as the complete set of OD
+		 * features that are currently overridden, not as a delta
+		 * describing this single operation. Any feature whose bit is
+		 * clear gets reset to its default on import. od_table's mask
+		 * has accumulated every feature the user touched since the
+		 * last full restore, so record it and keep restating it on
+		 * subsequent uploads.
 		 */
+		table_context->user_od_feature_mask =
+			od_table->OverDriveTable.FeatureCtrlMask;
+
 		offset_of_voltageoffset = offsetof(OverDriveTable_t, VoltageOffsetPerZoneBoundary);
 		if (memcmp((u8 *)od_table + offset_of_voltageoffset,
 			   table_context->user_overdrive_table + offset_of_voltageoffset,
@@ -2747,7 +2749,6 @@ static int smu_v14_0_2_od_edit_dpm_table(struct smu_context *smu,
 				return ret;
 			}
 
-			od_table->OverDriveTable.FeatureCtrlMask = 0;
 			memcpy(table_context->user_overdrive_table + offset_of_voltageoffset,
 			       (u8 *)od_table + offset_of_voltageoffset,
 			       sizeof(OverDriveTableExternal_t) - offset_of_voltageoffset);
@@ -2785,7 +2786,10 @@ static int smu_v14_0_2_set_power_limit(struct smu_context *smu,
 	if (limit <= msg_limit) {
 		if (smu->current_power_limit > msg_limit) {
 			od_table->OverDriveTable.Ppt = 0;
-			od_table->OverDriveTable.FeatureCtrlMask |= 1U << PP_OD_FEATURE_PPT_BIT;
+			table_context->user_od_feature_mask &=
+				~(1U << PP_OD_FEATURE_PPT_BIT);
+			od_table->OverDriveTable.FeatureCtrlMask =
+				table_context->user_od_feature_mask;
 
 			ret = smu_v14_0_2_upload_overdrive_table(smu, od_table);
 			if (ret) {
@@ -2800,7 +2804,9 @@ static int smu_v14_0_2_set_power_limit(struct smu_context *smu,
 			return ret;
 
 		od_table->OverDriveTable.Ppt = (limit * 100) / msg_limit - 100;
-		od_table->OverDriveTable.FeatureCtrlMask |= 1U << PP_OD_FEATURE_PPT_BIT;
+		table_context->user_od_feature_mask |= 1U << PP_OD_FEATURE_PPT_BIT;
+		od_table->OverDriveTable.FeatureCtrlMask =
+			table_context->user_od_feature_mask;
 
 		ret = smu_v14_0_2_upload_overdrive_table(smu, od_table);
 		if (ret) {
-- 
2.53.0




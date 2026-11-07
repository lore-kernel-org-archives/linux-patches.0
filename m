Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065159;
	b=YXBDmD/6uO1jTgJJMzqR666gcA6n0gyqAtDOcdH88PGHVNS8by/abREC74Us5t01uzyY
	 hqwFfvxO0n8Zo4YnhiX9YpZhSNArkXVVTyHNPi25NP0c3Bz+brN3zhAArylRA+emgKd21
	 rMcZNs5UdGxFsV2/+oTPaBQUM3rs0olcj8xXvl2eJgW0T/wPb2hCrG4luXMVW34mXPXXI
	 FJ1bpIyEhnmPRmnSaH364HHnV03iQrp5oN+SXRIcDOxFAKsPtBp4wR1f4vj2hhPSMSNkc
	 P/o/FbDIcEmY/k3b+AweK9F977MsyhmIY1mCf/U8OokbQNc9PkBJf2fmYoDO2uTRpjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065159;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CAh0v02elfD772DEUDvlRz7irlTrYS23opX6zWMkr20=;
	b=Iv6wPk06TT2CI7RattCkDHKOWkkoqRQ1B/gaokE9smgNe/OQyErLNM685Q8GJIxRHb/Q
	 V88oHIVcytv4f2Q1O+ABJl3RiHnuU1aEcPHpEalmH5bKADY5hbrIrAHzOsH5Zb7ghnPOP
	 kr5PCXpZtdpgUnZv0WZvHqcbNrxUMppgTQg69R7GuNOd0s+c9Bo62UAiggaX8kzvL88V8
	 xTOC6GCTf/QnMsczAQAbX8m+AHyPWEKoQF5FBnEUK26FDarkf1qJvuGASGSFkkwEmENks
	 8joLfHK7zjikxLFwTIufq2NND5T6UanIXqHo7vxNWp78zz8epuJpi9msGX5PZN1qc/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WT3g32vE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC93C606D801;
	Sat,  7 Nov 2026 15:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WT3g32vE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9673C1F008A2;
	Sat,  7 Nov 2026 15:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065158;
	bh=CAh0v02elfD772DEUDvlRz7irlTrYS23opX6zWMkr20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WT3g32vEWZak46sAvXO7RMZLdGYEF5S8fOyo5zKYLGOUbgldWUbwFjfcmejKVGJZ/
	 RrG7gn4hrn42vkcurLoym0eyVzZeUVaq72NSmOOcZkXeeX/iUiVJnl6YAZdP73p9pt
	 CRGarxvNg/vlkVeR+y/XAMq66UZfOjkhAdaJOaTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kenneth Feng <kenneth.feng@amd.com>,
	Kevin Wang <kevin.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0967/1257] drm/amd/pm:restate all customized OD features on every table upload for smu 13.0.0/smu 14.0.2
Date: Sat,  7 Nov 2026 08:54:23 -0500
Message-ID: <20261107135006.065281984@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/inc/amdgpu_smu.h |  2 +
 .../drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c  | 35 +++++++----------
 .../drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c  | 32 +++++++---------
 .../drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c  | 38 +++++++++++--------
 4 files changed, 52 insertions(+), 55 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/inc/amdgpu_smu.h b/drivers/gpu/drm/amd/pm/swsmu/inc/amdgpu_smu.h
index 3ec65630ab99c..e354abfef2eba 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/inc/amdgpu_smu.h
+++ b/drivers/gpu/drm/amd/pm/swsmu/inc/amdgpu_smu.h
@@ -433,6 +433,8 @@ struct smu_table_context {
 	void                            *boot_overdrive_table;
 	void				*user_overdrive_table;
 
+	uint32_t			user_od_feature_mask;
+
 	struct smu_driver_table driver_tables[SMU_DRIVER_TABLE_COUNT];
 };
 
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
index a29e76b03476b..6ce0195f0a4f1 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
@@ -1569,7 +1569,6 @@ static int smu_v13_0_0_od_edit_dpm_table(struct smu_context *smu,
 	struct amdgpu_device *adev = smu->adev;
 	uint32_t offset_of_voltageoffset;
 	int32_t minimum, maximum;
-	uint32_t feature_ctrlmask;
 	int i, ret = 0;
 
 	switch (type) {
@@ -1891,21 +1890,16 @@ static int smu_v13_0_0_od_edit_dpm_table(struct smu_context *smu,
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
@@ -1918,7 +1912,6 @@ static int smu_v13_0_0_od_edit_dpm_table(struct smu_context *smu,
 				return ret;
 			}
 
-			od_table->OverDriveTable.FeatureCtrlMask = 0;
 			memcpy(table_context->user_overdrive_table + offset_of_voltageoffset,
 			       (u8 *)od_table + offset_of_voltageoffset,
 			       sizeof(OverDriveTableExternal_t) - offset_of_voltageoffset);
@@ -2201,6 +2194,7 @@ static int smu_v13_0_0_set_default_od_settings(struct smu_context *smu)
 		       boot_od_table,
 		       sizeof(OverDriveTableExternal_t));
 		smu->user_dpm_profile.user_od = false;
+		smu->smu_table.user_od_feature_mask = 0;
 	} else if (smu->user_dpm_profile.user_od) {
 		memcpy(&user_od_table_bak,
 		       user_od_table,
@@ -2250,12 +2244,8 @@ static int smu_v13_0_0_restore_user_od_settings(struct smu_context *smu)
 	OverDriveTableExternal_t *od_table = table_context->overdrive_table;
 	OverDriveTableExternal_t *user_od_table = table_context->user_overdrive_table;
 	int res;
-
-	user_od_table->OverDriveTable.FeatureCtrlMask = BIT(PP_OD_FEATURE_GFXCLK_BIT) |
-							BIT(PP_OD_FEATURE_UCLK_BIT) |
-							BIT(PP_OD_FEATURE_GFX_VF_CURVE_BIT) |
-							BIT(PP_OD_FEATURE_FAN_CURVE_BIT) |
-							BIT(PP_OD_FEATURE_ZERO_FAN_BIT);
+	user_od_table->OverDriveTable.FeatureCtrlMask =
+		table_context->user_od_feature_mask;
 	res = smu_v13_0_0_upload_overdrive_table(smu, user_od_table);
 	user_od_table->OverDriveTable.FeatureCtrlMask = 0;
 	if (res == 0)
@@ -3069,8 +3059,10 @@ static int smu_v13_0_0_set_ppt_limit(struct smu_context *smu,
 
 		if (current_od_table.OverDriveTable.Ppt) {
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
@@ -3084,8 +3076,9 @@ static int smu_v13_0_0_set_ppt_limit(struct smu_context *smu,
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
index 5fe409a237726..51e419e6380c1 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
@@ -1578,7 +1578,6 @@ static int smu_v13_0_7_od_edit_dpm_table(struct smu_context *smu,
 	struct amdgpu_device *adev = smu->adev;
 	uint32_t offset_of_voltageoffset;
 	int32_t minimum, maximum;
-	uint32_t feature_ctrlmask;
 	int i, ret = 0;
 
 	switch (type) {
@@ -1900,22 +1899,17 @@ static int smu_v13_0_7_od_edit_dpm_table(struct smu_context *smu,
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
@@ -1928,7 +1922,6 @@ static int smu_v13_0_7_od_edit_dpm_table(struct smu_context *smu,
 				return ret;
 			}
 
-			od_table->OverDriveTable.FeatureCtrlMask = 0;
 			memcpy(table_context->user_overdrive_table + offset_of_voltageoffset,
 			       (u8 *)od_table + offset_of_voltageoffset,
 			       sizeof(OverDriveTableExternal_t) - offset_of_voltageoffset);
@@ -2203,6 +2196,7 @@ static int smu_v13_0_7_set_default_od_settings(struct smu_context *smu)
 		       boot_od_table,
 		       sizeof(OverDriveTableExternal_t));
 		smu->user_dpm_profile.user_od = false;
+		smu->smu_table.user_od_feature_mask = 0;
 	} else if (smu->user_dpm_profile.user_od) {
 		memcpy(&user_od_table_bak,
 		       user_od_table,
@@ -2253,11 +2247,8 @@ static int smu_v13_0_7_restore_user_od_settings(struct smu_context *smu)
 	OverDriveTableExternal_t *user_od_table = table_context->user_overdrive_table;
 	int res;
 
-	user_od_table->OverDriveTable.FeatureCtrlMask = BIT(PP_OD_FEATURE_GFXCLK_BIT) |
-							BIT(PP_OD_FEATURE_UCLK_BIT) |
-							BIT(PP_OD_FEATURE_GFX_VF_CURVE_BIT) |
-							BIT(PP_OD_FEATURE_FAN_CURVE_BIT) |
-							BIT(PP_OD_FEATURE_ZERO_FAN_BIT);
+	user_od_table->OverDriveTable.FeatureCtrlMask =
+		table_context->user_od_feature_mask;
 	res = smu_v13_0_7_upload_overdrive_table(smu, user_od_table);
 	user_od_table->OverDriveTable.FeatureCtrlMask = 0;
 	if (res == 0)
@@ -2689,7 +2680,10 @@ static int smu_v13_0_7_set_ppt_limit(struct smu_context *smu,
 
 		if (current_od_table.OverDriveTable.Ppt) {
 			od_table->OverDriveTable.Ppt = 0;
-			od_table->OverDriveTable.FeatureCtrlMask |= 1U << PP_OD_FEATURE_PPT_BIT;
+			table_context->user_od_feature_mask &=
+				~(1U << PP_OD_FEATURE_PPT_BIT);
+			od_table->OverDriveTable.FeatureCtrlMask =
+				table_context->user_od_feature_mask;
 
 			ret = smu_v13_0_7_upload_overdrive_table(smu, od_table);
 			if (ret) {
@@ -2704,7 +2698,9 @@ static int smu_v13_0_7_set_ppt_limit(struct smu_context *smu,
 			return ret;
 
 		od_table->OverDriveTable.Ppt = (limit * 100) / msg_limit - 100;
-		od_table->OverDriveTable.FeatureCtrlMask |= 1U << PP_OD_FEATURE_PPT_BIT;
+		table_context->user_od_feature_mask |= 1U << PP_OD_FEATURE_PPT_BIT;
+		od_table->OverDriveTable.FeatureCtrlMask =
+			table_context->user_od_feature_mask;
 
 		ret = smu_v13_0_7_upload_overdrive_table(smu, od_table);
 		if (ret) {
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c
index 6621e50de9651..566b7f2b00f0e 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c
@@ -2385,6 +2385,7 @@ static int smu_v14_0_2_set_default_od_settings(struct smu_context *smu)
 		       boot_od_table,
 		       sizeof(OverDriveTableExternal_t));
 		smu->user_dpm_profile.user_od = false;
+		smu->smu_table.user_od_feature_mask = 0;
 	} else if (smu->user_dpm_profile.user_od) {
 		memcpy(&user_od_table_bak,
 		       user_od_table,
@@ -2433,11 +2434,8 @@ static int smu_v14_0_2_restore_user_od_settings(struct smu_context *smu)
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
@@ -2522,7 +2520,6 @@ static int smu_v14_0_2_od_edit_dpm_table(struct smu_context *smu,
 	struct amdgpu_device *adev = smu->adev;
 	uint32_t offset_of_voltageoffset;
 	int32_t minimum, maximum;
-	uint32_t feature_ctrlmask;
 	int i, ret = 0;
 
 	switch (type) {
@@ -2811,21 +2808,26 @@ static int smu_v14_0_2_od_edit_dpm_table(struct smu_context *smu,
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
@@ -2838,7 +2840,6 @@ static int smu_v14_0_2_od_edit_dpm_table(struct smu_context *smu,
 				return ret;
 			}
 
-			od_table->OverDriveTable.FeatureCtrlMask = 0;
 			memcpy(table_context->user_overdrive_table + offset_of_voltageoffset,
 			       (u8 *)od_table + offset_of_voltageoffset,
 			       sizeof(OverDriveTableExternal_t) - offset_of_voltageoffset);
@@ -2882,7 +2883,10 @@ static int smu_v14_0_2_set_ppt_limit(struct smu_context *smu,
 
 		if (current_od_table.OverDriveTable.Ppt) {
 			od_table->OverDriveTable.Ppt = 0;
-			od_table->OverDriveTable.FeatureCtrlMask |= 1U << PP_OD_FEATURE_PPT_BIT;
+			table_context->user_od_feature_mask &=
+				~(1U << PP_OD_FEATURE_PPT_BIT);
+			od_table->OverDriveTable.FeatureCtrlMask =
+				table_context->user_od_feature_mask;
 
 			ret = smu_v14_0_2_upload_overdrive_table(smu, od_table);
 			if (ret) {
@@ -2897,7 +2901,9 @@ static int smu_v14_0_2_set_ppt_limit(struct smu_context *smu,
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




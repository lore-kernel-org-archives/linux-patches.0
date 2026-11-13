Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590652;
	b=k1abKOvAoJYPOJewmipOJqIPgIV5x3ifTgcSF3ttXRtAq0SKsiWu892pLKpKiYUxe2rY
	 nXcA7gt37WvgKi7ODMEbMlnRuFm0slmHG4BNKYKCOzaJg4s+lScYpnnJW9kiBcWyC83e8
	 ukWIugWvJiI0jAy9r5V3ccS/eSLqLb259QcvKKszxMopANvqs+bT3sdgQgjb6d1x/OMOx
	 QrRaQ32p4oi61TnhEfwVFqqpS+SMUNfxQDGlq0/LbuBY+uK4tYPWUXk81PAP9pi3aQh/P
	 gvSV2Jrt5VqNhQYOs8XvTrQgeRdW+NsbB5ubitVBzD5zrhPN/8WzncWxAK2H6l9Ysbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590652;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YtNFSBwa9NrkALyYOLo5/Um6JCwHDjWGYzvI2jjxjSA=;
	b=qu+h7C/A4R477xgpu67T8cOPY8oFCCZO6+lNvhOalzqYOy5r+BQ9rHJrGM/Lls67dDpT
	 dYsG2hqbgEhUNWiIdqd7UATNpfzbr38CS80ugOYTuhtaldEPKmxzGMfP7/bXgG0oS0ue9
	 dZYd6UVl/ltDycbwUbsgqnAJq5b9uCXC+dORnIlhBAWHcrbOG4mqCFJvofc10c1BFnBrf
	 wHnxZ/BYs+RL4ouBksNGlArgTknRV53ibXEiFQ5Gtkr/0Cowz9+DrOc5wvibi7S2Z+gEH
	 DzVWla3gHRs5+RlPdPBIEYn09G2uUy5i2CCcbmQWiorTL4sU47wL1Ms4j5L4J5raiaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hcZlQ9fq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44A4460776CF;
	Fri, 13 Nov 2026 17:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hcZlQ9fq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF6131F000C7;
	Fri, 13 Nov 2026 17:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590652;
	bh=YtNFSBwa9NrkALyYOLo5/Um6JCwHDjWGYzvI2jjxjSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hcZlQ9fqaGAjDFcwYusyQcouT+PvVGRX1f/yAAxYo9r0jI26yYvAsDQR4FRi0/aRe
	 2JTpmpQJAHhrcFmEBeJABA4++CISWdvj4nRMnqsx51u7x5tdFMUIBE3r1jqlsAUbgr
	 Z6ElXq502D+Djokbr0eiIkrStllRkhWIzuNZDrQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kenneth Feng <kenneth.feng@amd.com>,
	Kevin Wang <kevin.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 572/686] drm/amd/pm:restate all customized OD features on every table upload for smu 13.0.0/smu 14.0.2
Date: Fri, 13 Nov 2026 10:51:45 -0500
Message-ID: <20261113153841.043118137@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adjusted smu_table_context context for existing gpu_metrics_table_size and gpu_metrics_table fields instead of driver_tables ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/inc/amdgpu_smu.h |  2 +
 .../drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c  | 35 +++++++----------
 .../drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c  | 32 +++++++---------
 .../drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c  | 38 +++++++++++--------
 4 files changed, 52 insertions(+), 55 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/inc/amdgpu_smu.h b/drivers/gpu/drm/amd/pm/swsmu/inc/amdgpu_smu.h
index e00beb901d906..0557fbf9649c8 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/inc/amdgpu_smu.h
+++ b/drivers/gpu/drm/amd/pm/swsmu/inc/amdgpu_smu.h
@@ -370,6 +370,8 @@ struct smu_table_context {
 	void                            *boot_overdrive_table;
 	void				*user_overdrive_table;
 
+	uint32_t			user_od_feature_mask;
+
 	uint32_t			gpu_metrics_table_size;
 	void				*gpu_metrics_table;
 };
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
index e463a39efab22..9d2d630bba240 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
@@ -1643,7 +1643,6 @@ static int smu_v13_0_0_od_edit_dpm_table(struct smu_context *smu,
 	struct amdgpu_device *adev = smu->adev;
 	uint32_t offset_of_voltageoffset;
 	int32_t minimum, maximum;
-	uint32_t feature_ctrlmask;
 	int i, ret = 0;
 
 	switch (type) {
@@ -1965,21 +1964,16 @@ static int smu_v13_0_0_od_edit_dpm_table(struct smu_context *smu,
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
@@ -1992,7 +1986,6 @@ static int smu_v13_0_0_od_edit_dpm_table(struct smu_context *smu,
 				return ret;
 			}
 
-			od_table->OverDriveTable.FeatureCtrlMask = 0;
 			memcpy(table_context->user_overdrive_table + offset_of_voltageoffset,
 			       (u8 *)od_table + offset_of_voltageoffset,
 			       sizeof(OverDriveTableExternal_t) - offset_of_voltageoffset);
@@ -2271,6 +2264,7 @@ static int smu_v13_0_0_set_default_od_settings(struct smu_context *smu)
 		       boot_od_table,
 		       sizeof(OverDriveTableExternal_t));
 		smu->user_dpm_profile.user_od = false;
+		smu->smu_table.user_od_feature_mask = 0;
 	} else if (smu->user_dpm_profile.user_od) {
 		memcpy(&user_od_table_bak,
 		       user_od_table,
@@ -2320,12 +2314,8 @@ static int smu_v13_0_0_restore_user_od_settings(struct smu_context *smu)
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
@@ -3130,8 +3120,10 @@ static int smu_v13_0_0_set_power_limit(struct smu_context *smu,
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
@@ -3145,8 +3137,9 @@ static int smu_v13_0_0_set_power_limit(struct smu_context *smu,
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
index 0af98b5bf0ac2..9947b3f6bb5fb 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
@@ -1631,7 +1631,6 @@ static int smu_v13_0_7_od_edit_dpm_table(struct smu_context *smu,
 	struct amdgpu_device *adev = smu->adev;
 	uint32_t offset_of_voltageoffset;
 	int32_t minimum, maximum;
-	uint32_t feature_ctrlmask;
 	int i, ret = 0;
 
 	switch (type) {
@@ -1953,22 +1952,17 @@ static int smu_v13_0_7_od_edit_dpm_table(struct smu_context *smu,
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
@@ -1981,7 +1975,6 @@ static int smu_v13_0_7_od_edit_dpm_table(struct smu_context *smu,
 				return ret;
 			}
 
-			od_table->OverDriveTable.FeatureCtrlMask = 0;
 			memcpy(table_context->user_overdrive_table + offset_of_voltageoffset,
 			       (u8 *)od_table + offset_of_voltageoffset,
 			       sizeof(OverDriveTableExternal_t) - offset_of_voltageoffset);
@@ -2254,6 +2247,7 @@ static int smu_v13_0_7_set_default_od_settings(struct smu_context *smu)
 		       boot_od_table,
 		       sizeof(OverDriveTableExternal_t));
 		smu->user_dpm_profile.user_od = false;
+		smu->smu_table.user_od_feature_mask = 0;
 	} else if (smu->user_dpm_profile.user_od) {
 		memcpy(&user_od_table_bak,
 		       user_od_table,
@@ -2304,11 +2298,8 @@ static int smu_v13_0_7_restore_user_od_settings(struct smu_context *smu)
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
@@ -2726,7 +2717,10 @@ static int smu_v13_0_7_set_power_limit(struct smu_context *smu,
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
@@ -2741,7 +2735,9 @@ static int smu_v13_0_7_set_power_limit(struct smu_context *smu,
 			return ret;
 
 		od_table->OverDriveTable.Ppt = (limit * 100) / msg_limit - 100;
-		od_table->OverDriveTable.FeatureCtrlMask |= 1U << PP_OD_FEATURE_PPT_BIT;
+		table_context->user_od_feature_mask |= 1U << PP_OD_FEATURE_PPT_BIT;
+		od_table->OverDriveTable.FeatureCtrlMask =
+			table_context->user_od_feature_mask;
 
 		ret = smu_v13_0_7_upload_overdrive_table(smu, od_table);
 		if (ret) {
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c
index f8761a64a6e12..88bbc30b5ec96 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c
@@ -2391,6 +2391,7 @@ static int smu_v14_0_2_set_default_od_settings(struct smu_context *smu)
 		       boot_od_table,
 		       sizeof(OverDriveTableExternal_t));
 		smu->user_dpm_profile.user_od = false;
+		smu->smu_table.user_od_feature_mask = 0;
 	} else if (smu->user_dpm_profile.user_od) {
 		memcpy(&user_od_table_bak,
 		       user_od_table,
@@ -2439,11 +2440,8 @@ static int smu_v14_0_2_restore_user_od_settings(struct smu_context *smu)
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
@@ -2528,7 +2526,6 @@ static int smu_v14_0_2_od_edit_dpm_table(struct smu_context *smu,
 	struct amdgpu_device *adev = smu->adev;
 	uint32_t offset_of_voltageoffset;
 	int32_t minimum, maximum;
-	uint32_t feature_ctrlmask;
 	int i, ret = 0;
 
 	switch (type) {
@@ -2817,21 +2814,26 @@ static int smu_v14_0_2_od_edit_dpm_table(struct smu_context *smu,
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
@@ -2844,7 +2846,6 @@ static int smu_v14_0_2_od_edit_dpm_table(struct smu_context *smu,
 				return ret;
 			}
 
-			od_table->OverDriveTable.FeatureCtrlMask = 0;
 			memcpy(table_context->user_overdrive_table + offset_of_voltageoffset,
 			       (u8 *)od_table + offset_of_voltageoffset,
 			       sizeof(OverDriveTableExternal_t) - offset_of_voltageoffset);
@@ -2882,7 +2883,10 @@ static int smu_v14_0_2_set_power_limit(struct smu_context *smu,
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
@@ -2897,7 +2901,9 @@ static int smu_v14_0_2_set_power_limit(struct smu_context *smu,
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




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038428;
	b=tFiV58zTW2q/mw7dgst9WmafH4UvSZQ9Xng78/L7mJZkS0mbRStEGhK+GA8Y7/fQfobX
	 UuQ7wL1iQvLXdRApBQ4sTAZfUtmFkjStB5/HJcGR/lkZMnwfu+I3FMgaBLrn8e1LsiOPl
	 TqZ+yhNMMec1gKvwVMunEI490am+QmUumYmwG37gckXvyvolddPz7+5RlO53v3/J5yxZd
	 Sd/fZTq3F9JBXz+MWaulXBwyNZNyLsRceyg6Z24ShVtzyl1gBShJiAqD1kG71Gi3bngXX
	 MkhF7/9jTvKjat2APeiRgiKfbSR36pQWg59bk38WSVXK+076otK4UI2h77dXhl6CQwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038428;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BUnHSMhnPuVtnX7bPju59q1SfmK/8HmDUNJSZXQBVWE=;
	b=46IEcA2TNA6QhgPKMPX6a5JrXJ2hPFDCJTeyyuJq8hP9CGVexbity0IaFhbAD8FN+nwT
	 mtLzM6SP2sgk46QwG8ro6bZY1IKokGB6RnSL/Z44M83SLPosXpGrZt/VFX1qinEDTnvR2
	 WXORCQbeoaPipw6ANo1o+nh5tM/wohVLFvf/CbD0q537tsovqiJYGYctAueg/GqDJyyUU
	 YMKz+bxTxZvHiXfcTsaM4fwAHtp8BUquVXUfUTD7rRIq+cNayRq8A5VX0+MsMMcZmSvir
	 s9QTBAHB6dc3EI5U3bQAU1uwk/Y0Ian31ozgswNdAIjmtQoZVJV/lZRIwA3EcdrHJaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dh9fHxmS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84DC6606A31C;
	Wed, 18 Nov 2026 21:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dh9fHxmS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA76F1F000C6;
	Wed, 18 Nov 2026 21:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038428;
	bh=BUnHSMhnPuVtnX7bPju59q1SfmK/8HmDUNJSZXQBVWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dh9fHxmSSj75Nscz0nGfqKm7I5cbVRfidg45KkO1jo3I/dvYVCEbptQl3iM11d0X5
	 x4GHmRWaCc2P4C7qJ7/gspeMtQcgqxhhgqZeJN3lzENs+fiZvezq05lgQMWTZ1W6Fo
	 fBgeyD7CLEu5UIDA3foVRXRcLu26MTotKemTg5UA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kenneth Feng <kenneth.feng@amd.com>,
	Kevin Wang <kevin.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1699/3318] drm/amd/pm:restate all customized OD features on every table upload for smu 13.0.0/smu 14.0.2
Date: Wed, 18 Nov 2026 15:38:41 +0100
Message-ID: <20261118150412.809977629@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: applied mask-reset changes directly to the existing full-reset case because the newer per-feature reset helper is absent ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/inc/amdgpu_smu.h |  2 ++
 .../drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c  | 22 ++++++-------------
 .../drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c  | 21 ++++++------------
 3 files changed, 16 insertions(+), 29 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/inc/amdgpu_smu.h b/drivers/gpu/drm/amd/pm/swsmu/inc/amdgpu_smu.h
index 72ed836328966..6172b02dffcc9 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/inc/amdgpu_smu.h
+++ b/drivers/gpu/drm/amd/pm/swsmu/inc/amdgpu_smu.h
@@ -353,6 +353,8 @@ struct smu_table_context {
 	void                            *boot_overdrive_table;
 	void				*user_overdrive_table;
 
+	uint32_t			user_od_feature_mask;
+
 	uint32_t			gpu_metrics_table_size;
 	void				*gpu_metrics_table;
 };
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
index 6ef3140edacd1..5e257c55a92eb 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
@@ -1378,7 +1378,6 @@ static int smu_v13_0_0_od_edit_dpm_table(struct smu_context *smu,
 	struct amdgpu_device *adev = smu->adev;
 	uint32_t offset_of_voltageoffset;
 	int32_t minimum, maximum;
-	uint32_t feature_ctrlmask;
 	int i, ret = 0;
 
 	switch (type) {
@@ -1530,21 +1529,16 @@ static int smu_v13_0_0_od_edit_dpm_table(struct smu_context *smu,
 		break;
 
 	case PP_OD_RESTORE_DEFAULT_TABLE:
-		feature_ctrlmask = od_table->OverDriveTable.FeatureCtrlMask;
 		memcpy(od_table,
 		       table_context->boot_overdrive_table,
 		       sizeof(OverDriveTableExternal_t));
-		od_table->OverDriveTable.FeatureCtrlMask = feature_ctrlmask;
+		od_table->OverDriveTable.FeatureCtrlMask = 0;
+		table_context->user_od_feature_mask = 0;
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
@@ -1557,7 +1551,6 @@ static int smu_v13_0_0_od_edit_dpm_table(struct smu_context *smu,
 				return ret;
 			}
 
-			od_table->OverDriveTable.FeatureCtrlMask = 0;
 			memcpy(table_context->user_overdrive_table + offset_of_voltageoffset,
 			       (u8 *)od_table + offset_of_voltageoffset,
 			       sizeof(OverDriveTableExternal_t) - offset_of_voltageoffset);
@@ -1813,6 +1806,7 @@ static int smu_v13_0_0_set_default_od_settings(struct smu_context *smu)
 		       boot_od_table,
 		       sizeof(OverDriveTableExternal_t));
 		smu->user_dpm_profile.user_od = false;
+		smu->smu_table.user_od_feature_mask = 0;
 	} else if (smu->user_dpm_profile.user_od) {
 		memcpy(&user_od_table_bak,
 		       user_od_table,
@@ -1842,10 +1836,8 @@ static int smu_v13_0_0_restore_user_od_settings(struct smu_context *smu)
 	OverDriveTableExternal_t *od_table = table_context->overdrive_table;
 	OverDriveTableExternal_t *user_od_table = table_context->user_overdrive_table;
 	int res;
-
-	user_od_table->OverDriveTable.FeatureCtrlMask = 1U << PP_OD_FEATURE_GFXCLK_BIT |
-							1U << PP_OD_FEATURE_UCLK_BIT |
-							1U << PP_OD_FEATURE_GFX_VF_CURVE_BIT;
+	user_od_table->OverDriveTable.FeatureCtrlMask =
+		table_context->user_od_feature_mask;
 	res = smu_v13_0_0_upload_overdrive_table(smu, user_od_table);
 	user_od_table->OverDriveTable.FeatureCtrlMask = 0;
 	if (res == 0)
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
index df99d185cf8e0..b97015fc3c8a4 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
@@ -1359,7 +1359,6 @@ static int smu_v13_0_7_od_edit_dpm_table(struct smu_context *smu,
 	struct amdgpu_device *adev = smu->adev;
 	uint32_t offset_of_voltageoffset;
 	int32_t minimum, maximum;
-	uint32_t feature_ctrlmask;
 	int i, ret = 0;
 
 	switch (type) {
@@ -1511,21 +1510,16 @@ static int smu_v13_0_7_od_edit_dpm_table(struct smu_context *smu,
 		break;
 
 	case PP_OD_RESTORE_DEFAULT_TABLE:
-		feature_ctrlmask = od_table->OverDriveTable.FeatureCtrlMask;
 		memcpy(od_table,
 		       table_context->boot_overdrive_table,
 		       sizeof(OverDriveTableExternal_t));
-		od_table->OverDriveTable.FeatureCtrlMask = feature_ctrlmask;
+		od_table->OverDriveTable.FeatureCtrlMask = 0;
+		table_context->user_od_feature_mask = 0;
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
@@ -1538,7 +1532,6 @@ static int smu_v13_0_7_od_edit_dpm_table(struct smu_context *smu,
 				return ret;
 			}
 
-			od_table->OverDriveTable.FeatureCtrlMask = 0;
 			memcpy(table_context->user_overdrive_table + offset_of_voltageoffset,
 			       (u8 *)od_table + offset_of_voltageoffset,
 			       sizeof(OverDriveTableExternal_t) - offset_of_voltageoffset);
@@ -1791,6 +1784,7 @@ static int smu_v13_0_7_set_default_od_settings(struct smu_context *smu)
 		       boot_od_table,
 		       sizeof(OverDriveTableExternal_t));
 		smu->user_dpm_profile.user_od = false;
+		smu->smu_table.user_od_feature_mask = 0;
 	} else if (smu->user_dpm_profile.user_od) {
 		memcpy(&user_od_table_bak,
 		       user_od_table,
@@ -1821,9 +1815,8 @@ static int smu_v13_0_7_restore_user_od_settings(struct smu_context *smu)
 	OverDriveTableExternal_t *user_od_table = table_context->user_overdrive_table;
 	int res;
 
-	user_od_table->OverDriveTable.FeatureCtrlMask = 1U << PP_OD_FEATURE_GFXCLK_BIT |
-							1U << PP_OD_FEATURE_UCLK_BIT |
-							1U << PP_OD_FEATURE_GFX_VF_CURVE_BIT;
+	user_od_table->OverDriveTable.FeatureCtrlMask =
+		table_context->user_od_feature_mask;
 	res = smu_v13_0_7_upload_overdrive_table(smu, user_od_table);
 	user_od_table->OverDriveTable.FeatureCtrlMask = 0;
 	if (res == 0)
-- 
2.53.0




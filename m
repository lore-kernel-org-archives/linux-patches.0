Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065495;
	b=aczQQpkou0D2gJSSoiv1FnCQrmuB4k7HApkR4M2ocpBiRBm6aJWV6q/F5sxUDKDaOhCs
	 CeAo9x3JHyn1kceJMAvceWioo7r8HAHA8dwTJ9xwUm9Km7Wb9/QW/KZEJh3LO+PRERmBt
	 O1Yn/LeNQ8zLoehkClGRGGkFTEvd2vwIG8Gj34bXu2HwfG4P7fObAOocTjbWweMCQ9Q4U
	 ozoIYGbxEbXaBp1NTxHP5oiRQ3iavHKID6K+SPmhtPIrf4U9EHYkreQfzEl/jpWDgoDtR
	 5TRRkkWNjLk2lUTgSNTg1nxMnshP9abS9GMymMV+MG65crxPFupFCQ5/FjxmTgENV/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065495;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=f0EZr3ZiIAcFQDubbcW+g6pu/EhipJfMsGVzn50QeE8=;
	b=lwiNANijoTJQ/nS965DOIxxeuBTpB4MkO5OMB5zpIjEUNNCv3wwVtN3agsj/Hdju3ZT1
	 fjnmADrJfV+XcSLR3AauFNhbAUWkbBVkjYbzWKcySfqUJK4Z+UtFAxjH52iqr7W2TE3eN
	 TxlftFF5elEVKpV0goOKyjjIJvuq8JbgQFG79eDdBf8lnvGIfMrsOzSYYFmItkr5JMVGr
	 T/fYdpZ2M/N3WNumYxRZqHOocUKMgCGfFvtL3kNxEu8OiEJ7A6X/shpNoBUHUlDVBuKe9
	 dc+/3NeWUIuJOI9D1vZSFOujUf9QQZWMZg7ky5SlaQZVaevyb4iSdWjkGWPQN7005pQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Io0LMPB6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B863606A33D;
	Sat,  7 Nov 2026 15:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Io0LMPB6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9364E1F0089F;
	Sat,  7 Nov 2026 15:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065494;
	bh=f0EZr3ZiIAcFQDubbcW+g6pu/EhipJfMsGVzn50QeE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Io0LMPB6Vvqm+qlRX93bbI16jZhwv2EGXFHtHVll+MxB1PgjdWJklBMYY8JvstJnN
	 0pwElngFCVXSVONQVT2cccbHwkT7zzJ0TUA3OUa5pFTBJuUyXdw76dtiPfk+at3sQT
	 VAFUTbz3cWQufUBPT3ubYbyqj8qtB7ACrtu0AqJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Wang <kevin.wang@amd.com>,
	Kenneth Feng <kenneth.feng@amd.com>,
	=?UTF-8?q?Jos=C3=A9=20Miguel=20Sarasola?= <alosarjos@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1184/1257] drm/amd/pm: preserve committed OD features for SMU 13.0.0/13.0.7
Date: Sat,  7 Nov 2026 08:58:00 -0500
Message-ID: <20261107135011.872142703@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kevin Wang <kevin.wang@amd.com>

[ Upstream commit 6027db7db773714f2e05df82093276f2a52a1fba ]

PMFW treats FeatureCtrlMask as the complete set of active OD features.
Uploads containing only newly edited bits can drop earlier settings.

Fix the OD state handling to:

- preserve committed features across later commits
- keep staged OD settings out of power-cap writes
- update cached state only after successful uploads
- clear restored features only after they return to defaults
- restore PPT for the current AC/DC source after resume

Closes: https://gitlab.freedesktop.org/drm/amd/-/work_items/3625
Signed-off-by: Kevin Wang <kevin.wang@amd.com>
Reviewed-by: Kenneth Feng <kenneth.feng@amd.com>
Tested-by: José Miguel Sarasola <alosarjos@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit adf63026e1fa706de48d986ac6c1a7cb64cbf927)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c  | 193 +++++++++++++-----
 .../drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c  | 193 +++++++++++++-----
 2 files changed, 293 insertions(+), 93 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
index 6ce0195f0a4f1..aaafe07ffdad3 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
@@ -63,6 +63,9 @@ static void smu_v13_0_0_get_od_setting_limits(struct smu_context *smu,
 					      int od_feature_bit,
 					      int32_t *min, int32_t *max);
 static int smu_v13_0_0_init_ppt_limits(struct smu_context *smu);
+static int
+smu_v13_0_0_upload_overdrive_table(struct smu_context *smu,
+				   OverDriveTableExternal_t *od_table);
 
 static const struct smu_feature_bits smu_v13_0_0_dpm_features = {
 	.bits = {
@@ -1079,6 +1082,93 @@ static bool smu_v13_0_0_is_od_feature_supported(struct smu_context *smu,
 	return feature_enabled;
 }
 
+static u32
+smu_v13_0_0_filter_od_feature_mask(struct smu_context *smu, u32 feature_mask)
+{
+	PPTable_t *pptable = smu->smu_table.driver_pptable;
+	u32 supported_mask =
+		pptable->SkuTable.OverDriveLimitsBasicMax.FeatureCtrlMask;
+
+	return feature_mask & supported_mask;
+}
+
+static bool smu_v13_0_0_fan_is_default(const OverDriveTable_t *od,
+				       const OverDriveTable_t *boot)
+{
+	return !memcmp(od->FanLinearPwmPoints, boot->FanLinearPwmPoints,
+			sizeof(od->FanLinearPwmPoints)) &&
+		!memcmp(od->FanLinearTempPoints, boot->FanLinearTempPoints,
+			sizeof(od->FanLinearTempPoints)) &&
+		od->FanMinimumPwm == boot->FanMinimumPwm &&
+		od->AcousticTargetRpmThreshold == boot->AcousticTargetRpmThreshold &&
+		od->AcousticLimitRpmThreshold == boot->AcousticLimitRpmThreshold &&
+		od->FanTargetTemperature == boot->FanTargetTemperature &&
+		od->FanMode == boot->FanMode;
+}
+
+static bool smu_v13_0_0_zero_fan_is_default(const OverDriveTable_t *od,
+					    const OverDriveTable_t *boot)
+{
+	return od->FanZeroRpmEnable == boot->FanZeroRpmEnable &&
+		od->FanZeroRpmStopTemp == boot->FanZeroRpmStopTemp;
+}
+
+static u32 smu_v13_0_0_normalize_feature_mask(const OverDriveTable_t *od,
+					      const OverDriveTable_t *boot,
+					      u32 feature_mask)
+{
+	if (od->GfxclkFmin == boot->GfxclkFmin &&
+	    od->GfxclkFmax == boot->GfxclkFmax)
+		feature_mask &= ~BIT(PP_OD_FEATURE_GFXCLK_BIT);
+	if (od->UclkFmin == boot->UclkFmin &&
+	    od->UclkFmax == boot->UclkFmax)
+		feature_mask &= ~BIT(PP_OD_FEATURE_UCLK_BIT);
+	if (!memcmp(od->VoltageOffsetPerZoneBoundary,
+		    boot->VoltageOffsetPerZoneBoundary,
+		    sizeof(od->VoltageOffsetPerZoneBoundary)))
+		feature_mask &= ~BIT(PP_OD_FEATURE_GFX_VF_CURVE_BIT);
+	if (smu_v13_0_0_fan_is_default(od, boot))
+		feature_mask &= ~BIT(PP_OD_FEATURE_FAN_CURVE_BIT);
+	if (smu_v13_0_0_zero_fan_is_default(od, boot))
+		feature_mask &= ~BIT(PP_OD_FEATURE_ZERO_FAN_BIT);
+	if (!od->Ppt)
+		feature_mask &= ~BIT(PP_OD_FEATURE_PPT_BIT);
+
+	return feature_mask;
+}
+
+static int
+smu_v13_0_0_upload_ppt_overdrive_table(struct smu_context *smu, s16 ppt)
+{
+	struct smu_table_context *table_context = &smu->smu_table;
+	OverDriveTableExternal_t *od_table = table_context->overdrive_table;
+	OverDriveTableExternal_t *user_od_table = table_context->user_overdrive_table;
+	OverDriveTableExternal_t upload_table;
+	u32 next_mask = table_context->user_od_feature_mask;
+	int ret;
+
+	/* Do not commit OD settings staged after the last c operation. */
+	memcpy(&upload_table, user_od_table, sizeof(upload_table));
+	upload_table.OverDriveTable.Ppt = ppt;
+	if (ppt)
+		next_mask |= BIT(PP_OD_FEATURE_PPT_BIT);
+	else
+		next_mask &= ~BIT(PP_OD_FEATURE_PPT_BIT);
+	upload_table.OverDriveTable.FeatureCtrlMask =
+		smu_v13_0_0_filter_od_feature_mask(smu, next_mask);
+
+	ret = smu_v13_0_0_upload_overdrive_table(smu, &upload_table);
+	if (ret)
+		return ret;
+
+	table_context->user_od_feature_mask =
+		upload_table.OverDriveTable.FeatureCtrlMask;
+	od_table->OverDriveTable.Ppt = ppt;
+	user_od_table->OverDriveTable.Ppt = ppt;
+
+	return 0;
+}
+
 static void smu_v13_0_0_get_od_setting_limits(struct smu_context *smu,
 					      int od_feature_bit,
 					      int32_t *min,
@@ -1514,41 +1604,30 @@ static int smu_v13_0_0_od_restore_table_single(struct smu_context *smu, long inp
 					boot_overdrive_table->OverDriveTable.FanLinearPwmPoints[i];
 		}
 		od_table->OverDriveTable.FanMode = FAN_MODE_AUTO;
-		od_table->OverDriveTable.FeatureCtrlMask |= BIT(PP_OD_FEATURE_FAN_CURVE_BIT);
 		break;
 	case PP_OD_EDIT_ACOUSTIC_LIMIT:
 		od_table->OverDriveTable.AcousticLimitRpmThreshold =
 					boot_overdrive_table->OverDriveTable.AcousticLimitRpmThreshold;
-		od_table->OverDriveTable.FanMode = FAN_MODE_AUTO;
-		od_table->OverDriveTable.FeatureCtrlMask |= BIT(PP_OD_FEATURE_FAN_CURVE_BIT);
 		break;
 	case PP_OD_EDIT_ACOUSTIC_TARGET:
 		od_table->OverDriveTable.AcousticTargetRpmThreshold =
 					boot_overdrive_table->OverDriveTable.AcousticTargetRpmThreshold;
-		od_table->OverDriveTable.FanMode = FAN_MODE_AUTO;
-		od_table->OverDriveTable.FeatureCtrlMask |= BIT(PP_OD_FEATURE_FAN_CURVE_BIT);
 		break;
 	case PP_OD_EDIT_FAN_TARGET_TEMPERATURE:
 		od_table->OverDriveTable.FanTargetTemperature =
 					boot_overdrive_table->OverDriveTable.FanTargetTemperature;
-		od_table->OverDriveTable.FanMode = FAN_MODE_AUTO;
-		od_table->OverDriveTable.FeatureCtrlMask |= BIT(PP_OD_FEATURE_FAN_CURVE_BIT);
 		break;
 	case PP_OD_EDIT_FAN_MINIMUM_PWM:
 		od_table->OverDriveTable.FanMinimumPwm =
 					boot_overdrive_table->OverDriveTable.FanMinimumPwm;
-		od_table->OverDriveTable.FanMode = FAN_MODE_AUTO;
-		od_table->OverDriveTable.FeatureCtrlMask |= BIT(PP_OD_FEATURE_FAN_CURVE_BIT);
 		break;
 	case PP_OD_EDIT_FAN_ZERO_RPM_ENABLE:
 		od_table->OverDriveTable.FanZeroRpmEnable =
 					boot_overdrive_table->OverDriveTable.FanZeroRpmEnable;
-		od_table->OverDriveTable.FeatureCtrlMask |= BIT(PP_OD_FEATURE_ZERO_FAN_BIT);
 		break;
 	case PP_OD_EDIT_FAN_ZERO_RPM_STOP_TEMP:
 		od_table->OverDriveTable.FanZeroRpmStopTemp =
 					boot_overdrive_table->OverDriveTable.FanZeroRpmStopTemp;
-		od_table->OverDriveTable.FeatureCtrlMask |= BIT(PP_OD_FEATURE_ZERO_FAN_BIT);
 		break;
 	default:
 		dev_info(adev->dev, "Invalid table index: %ld\n", input);
@@ -1566,9 +1645,17 @@ static int smu_v13_0_0_od_edit_dpm_table(struct smu_context *smu,
 	struct smu_table_context *table_context = &smu->smu_table;
 	OverDriveTableExternal_t *od_table =
 		(OverDriveTableExternal_t *)table_context->overdrive_table;
+	OverDriveTableExternal_t *user_od_table =
+		(OverDriveTableExternal_t *)table_context->user_overdrive_table;
+	OverDriveTableExternal_t *boot_od_table =
+		(OverDriveTableExternal_t *)table_context->boot_overdrive_table;
+	OverDriveTableExternal_t upload_table;
+	OverDriveTable_t *od = &od_table->OverDriveTable;
+	OverDriveTable_t *boot = &boot_od_table->OverDriveTable;
 	struct amdgpu_device *adev = smu->adev;
 	uint32_t offset_of_voltageoffset;
 	int32_t minimum, maximum;
+	u32 next_mask;
 	int i, ret = 0;
 
 	switch (type) {
@@ -1892,36 +1979,41 @@ static int smu_v13_0_0_od_edit_dpm_table(struct smu_context *smu,
 		} else {
 			memcpy(od_table,
 		       table_context->boot_overdrive_table,
-		       sizeof(OverDriveTableExternal_t));
+			       sizeof(OverDriveTableExternal_t));
 			od_table->OverDriveTable.FeatureCtrlMask = 0;
-			table_context->user_od_feature_mask = 0;
 		}
 		fallthrough;
 	case PP_OD_COMMIT_DPM_TABLE:
-		table_context->user_od_feature_mask =
-			od_table->OverDriveTable.FeatureCtrlMask;
 		offset_of_voltageoffset = offsetof(OverDriveTable_t, VoltageOffsetPerZoneBoundary);
-		if (memcmp((u8 *)od_table + offset_of_voltageoffset,
-			   table_context->user_overdrive_table + offset_of_voltageoffset,
-			   sizeof(OverDriveTableExternal_t) - offset_of_voltageoffset)) {
-			smu_v13_0_0_dump_od_table(smu, od_table);
+		next_mask = smu_v13_0_0_filter_od_feature_mask(smu,
+							       table_context->user_od_feature_mask |
+							       od->FeatureCtrlMask);
+		next_mask = smu_v13_0_0_normalize_feature_mask(od, boot,
+							       next_mask);
 
-			ret = smu_v13_0_0_upload_overdrive_table(smu, od_table);
+		if (memcmp((u8 *)od_table + offset_of_voltageoffset,
+			   (u8 *)user_od_table + offset_of_voltageoffset,
+			   sizeof(OverDriveTableExternal_t) - offset_of_voltageoffset) ||
+		    next_mask != table_context->user_od_feature_mask) {
+			memcpy(&upload_table, od_table, sizeof(upload_table));
+			upload_table.OverDriveTable.FeatureCtrlMask = next_mask;
+			smu_v13_0_0_dump_od_table(smu, &upload_table);
+
+			ret = smu_v13_0_0_upload_overdrive_table(smu, &upload_table);
 			if (ret) {
 				dev_err(adev->dev, "Failed to upload overdrive table!\n");
 				return ret;
 			}
 
-			memcpy(table_context->user_overdrive_table + offset_of_voltageoffset,
+			table_context->user_od_feature_mask = next_mask;
+			od_table->OverDriveTable.FeatureCtrlMask = 0;
+			memcpy((u8 *)user_od_table + offset_of_voltageoffset,
 			       (u8 *)od_table + offset_of_voltageoffset,
 			       sizeof(OverDriveTableExternal_t) - offset_of_voltageoffset);
+			user_od_table->OverDriveTable.FeatureCtrlMask = 0;
 
-			if (!memcmp(table_context->user_overdrive_table,
-				    table_context->boot_overdrive_table,
-				    sizeof(OverDriveTableExternal_t)))
-				smu->user_dpm_profile.user_od = false;
-			else
-				smu->user_dpm_profile.user_od = true;
+			smu->user_dpm_profile.user_od =
+				!!(next_mask & ~BIT(PP_OD_FEATURE_PPT_BIT));
 		}
 		break;
 
@@ -2184,6 +2276,7 @@ static int smu_v13_0_0_set_default_od_settings(struct smu_context *smu)
 	memcpy(od_table,
 	       boot_od_table,
 	       sizeof(OverDriveTableExternal_t));
+	od_table->OverDriveTable.FeatureCtrlMask = 0;
 
 	/*
 	 * For S3/S4/Runpm resume, we need to setup those overdrive tables again,
@@ -2193,6 +2286,7 @@ static int smu_v13_0_0_set_default_od_settings(struct smu_context *smu)
 		memcpy(user_od_table,
 		       boot_od_table,
 		       sizeof(OverDriveTableExternal_t));
+		user_od_table->OverDriveTable.FeatureCtrlMask = 0;
 		smu->user_dpm_profile.user_od = false;
 		smu->smu_table.user_od_feature_mask = 0;
 	} else if (smu->user_dpm_profile.user_od) {
@@ -2231,6 +2325,14 @@ static int smu_v13_0_0_set_default_od_settings(struct smu_context *smu)
 			user_od_table_bak.OverDriveTable.FanZeroRpmEnable;
 		user_od_table->OverDriveTable.FanZeroRpmStopTemp =
 			user_od_table_bak.OverDriveTable.FanZeroRpmStopTemp;
+		user_od_table->OverDriveTable.FanMode =
+			user_od_table_bak.OverDriveTable.FanMode;
+		user_od_table->OverDriveTable.FeatureCtrlMask = 0;
+	}
+	if (smu->adev->in_suspend) {
+		user_od_table->OverDriveTable.Ppt = 0;
+		smu->smu_table.user_od_feature_mask &=
+			~BIT(PP_OD_FEATURE_PPT_BIT);
 	}
 
 	smu_v13_0_0_set_supported_od_feature_mask(smu);
@@ -2243,13 +2345,22 @@ static int smu_v13_0_0_restore_user_od_settings(struct smu_context *smu)
 	struct smu_table_context *table_context = &smu->smu_table;
 	OverDriveTableExternal_t *od_table = table_context->overdrive_table;
 	OverDriveTableExternal_t *user_od_table = table_context->user_overdrive_table;
+	OverDriveTableExternal_t upload_table;
+	u32 next_mask;
 	int res;
-	user_od_table->OverDriveTable.FeatureCtrlMask =
-		table_context->user_od_feature_mask;
-	res = smu_v13_0_0_upload_overdrive_table(smu, user_od_table);
-	user_od_table->OverDriveTable.FeatureCtrlMask = 0;
-	if (res == 0)
+
+	next_mask = smu_v13_0_0_filter_od_feature_mask(smu,
+						       table_context->user_od_feature_mask);
+	memcpy(&upload_table, user_od_table, sizeof(upload_table));
+	upload_table.OverDriveTable.FeatureCtrlMask = next_mask;
+	res = smu_v13_0_0_upload_overdrive_table(smu, &upload_table);
+	if (res == 0) {
+		table_context->user_od_feature_mask = next_mask;
+		smu->user_dpm_profile.user_od =
+			!!(next_mask & ~BIT(PP_OD_FEATURE_PPT_BIT));
 		memcpy(od_table, user_od_table, sizeof(OverDriveTableExternal_t));
+		od_table->OverDriveTable.FeatureCtrlMask = 0;
+	}
 
 	return res;
 }
@@ -3043,10 +3154,8 @@ static int smu_v13_0_0_set_ppt_limit(struct smu_context *smu,
 	SkuTable_t *skutable = &pptable->SkuTable;
 	uint32_t msg_limit = skutable->MsgLimits.Power
 		[PPT_THROTTLER_PPT0][POWER_SOURCE_AC];
-	struct smu_table_context *table_context = &smu->smu_table;
-	OverDriveTableExternal_t *od_table =
-		(OverDriveTableExternal_t *)table_context->overdrive_table;
 	OverDriveTableExternal_t current_od_table;
+	s16 ppt;
 	int ret = 0;
 
 	if (limit_type != SMU_PPT_LIMIT_PPT0)
@@ -3058,12 +3167,7 @@ static int smu_v13_0_0_set_ppt_limit(struct smu_context *smu,
 			return ret;
 
 		if (current_od_table.OverDriveTable.Ppt) {
-			od_table->OverDriveTable.Ppt = 0;
-			table_context->user_od_feature_mask &=
-				~(1U << PP_OD_FEATURE_PPT_BIT);
-			od_table->OverDriveTable.FeatureCtrlMask =
-				table_context->user_od_feature_mask;
-			ret = smu_v13_0_0_upload_overdrive_table(smu, od_table);
+			ret = smu_v13_0_0_upload_ppt_overdrive_table(smu, 0);
 			if (ret) {
 				dev_err(smu->adev->dev, "Failed to upload overdrive table!\n");
 				return ret;
@@ -3075,11 +3179,8 @@ static int smu_v13_0_0_set_ppt_limit(struct smu_context *smu,
 		if (ret)
 			return ret;
 
-		od_table->OverDriveTable.Ppt = (limit * 100) / msg_limit - 100;
-		table_context->user_od_feature_mask |= 1U << PP_OD_FEATURE_PPT_BIT;
-		od_table->OverDriveTable.FeatureCtrlMask =
-			table_context->user_od_feature_mask;
-		ret = smu_v13_0_0_upload_overdrive_table(smu, od_table);
+		ppt = (limit * 100) / msg_limit - 100;
+		ret = smu_v13_0_0_upload_ppt_overdrive_table(smu, ppt);
 		if (ret) {
 		  dev_err(smu->adev->dev, "Failed to upload overdrive table!\n");
 		  return ret;
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
index 51e419e6380c1..8285d4a91589a 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
@@ -63,6 +63,9 @@ static void smu_v13_0_7_get_od_setting_limits(struct smu_context *smu,
 					      int od_feature_bit,
 					      int32_t *min, int32_t *max);
 static int smu_v13_0_7_init_ppt_limits(struct smu_context *smu);
+static int
+smu_v13_0_7_upload_overdrive_table(struct smu_context *smu,
+				   OverDriveTableExternal_t *od_table);
 
 static const struct smu_feature_bits smu_v13_0_7_dpm_features = {
 	.bits = {
@@ -94,6 +97,7 @@ static const struct smu_feature_bits smu_v13_0_7_dpm_features = {
 #define PP_OD_FEATURE_GFXCLK_FMAX			1
 #define PP_OD_FEATURE_UCLK_FMIN				2
 #define PP_OD_FEATURE_UCLK_FMAX				3
+
 #define PP_OD_FEATURE_GFX_VF_CURVE			4
 #define PP_OD_FEATURE_FAN_CURVE_TEMP			5
 #define PP_OD_FEATURE_FAN_CURVE_PWM			6
@@ -1089,6 +1093,93 @@ static bool smu_v13_0_7_is_od_feature_supported(struct smu_context *smu,
 	return feature_enabled;
 }
 
+static u32
+smu_v13_0_7_filter_od_feature_mask(struct smu_context *smu, u32 feature_mask)
+{
+	PPTable_t *pptable = smu->smu_table.driver_pptable;
+	u32 supported_mask =
+		pptable->SkuTable.OverDriveLimitsBasicMax.FeatureCtrlMask;
+
+	return feature_mask & supported_mask;
+}
+
+static bool smu_v13_0_7_fan_is_default(const OverDriveTable_t *od,
+				       const OverDriveTable_t *boot)
+{
+	return !memcmp(od->FanLinearPwmPoints, boot->FanLinearPwmPoints,
+			sizeof(od->FanLinearPwmPoints)) &&
+		!memcmp(od->FanLinearTempPoints, boot->FanLinearTempPoints,
+			sizeof(od->FanLinearTempPoints)) &&
+		od->FanMinimumPwm == boot->FanMinimumPwm &&
+		od->AcousticTargetRpmThreshold == boot->AcousticTargetRpmThreshold &&
+		od->AcousticLimitRpmThreshold == boot->AcousticLimitRpmThreshold &&
+		od->FanTargetTemperature == boot->FanTargetTemperature &&
+		od->FanMode == boot->FanMode;
+}
+
+static bool smu_v13_0_7_zero_fan_is_default(const OverDriveTable_t *od,
+					    const OverDriveTable_t *boot)
+{
+	return od->FanZeroRpmEnable == boot->FanZeroRpmEnable &&
+		od->FanZeroRpmStopTemp == boot->FanZeroRpmStopTemp;
+}
+
+static u32 smu_v13_0_7_normalize_feature_mask(const OverDriveTable_t *od,
+					      const OverDriveTable_t *boot,
+					      u32 feature_mask)
+{
+	if (od->GfxclkFmin == boot->GfxclkFmin &&
+	    od->GfxclkFmax == boot->GfxclkFmax)
+		feature_mask &= ~BIT(PP_OD_FEATURE_GFXCLK_BIT);
+	if (od->UclkFmin == boot->UclkFmin &&
+	    od->UclkFmax == boot->UclkFmax)
+		feature_mask &= ~BIT(PP_OD_FEATURE_UCLK_BIT);
+	if (!memcmp(od->VoltageOffsetPerZoneBoundary,
+		    boot->VoltageOffsetPerZoneBoundary,
+		    sizeof(od->VoltageOffsetPerZoneBoundary)))
+		feature_mask &= ~BIT(PP_OD_FEATURE_GFX_VF_CURVE_BIT);
+	if (smu_v13_0_7_fan_is_default(od, boot))
+		feature_mask &= ~BIT(PP_OD_FEATURE_FAN_CURVE_BIT);
+	if (smu_v13_0_7_zero_fan_is_default(od, boot))
+		feature_mask &= ~BIT(PP_OD_FEATURE_ZERO_FAN_BIT);
+	if (!od->Ppt)
+		feature_mask &= ~BIT(PP_OD_FEATURE_PPT_BIT);
+
+	return feature_mask;
+}
+
+static int
+smu_v13_0_7_upload_ppt_overdrive_table(struct smu_context *smu, s16 ppt)
+{
+	struct smu_table_context *table_context = &smu->smu_table;
+	OverDriveTableExternal_t *od_table = table_context->overdrive_table;
+	OverDriveTableExternal_t *user_od_table = table_context->user_overdrive_table;
+	OverDriveTableExternal_t upload_table;
+	u32 next_mask = table_context->user_od_feature_mask;
+	int ret;
+
+	/* Do not commit OD settings staged after the last c operation. */
+	memcpy(&upload_table, user_od_table, sizeof(upload_table));
+	upload_table.OverDriveTable.Ppt = ppt;
+	if (ppt)
+		next_mask |= BIT(PP_OD_FEATURE_PPT_BIT);
+	else
+		next_mask &= ~BIT(PP_OD_FEATURE_PPT_BIT);
+	upload_table.OverDriveTable.FeatureCtrlMask =
+		smu_v13_0_7_filter_od_feature_mask(smu, next_mask);
+
+	ret = smu_v13_0_7_upload_overdrive_table(smu, &upload_table);
+	if (ret)
+		return ret;
+
+	table_context->user_od_feature_mask =
+		upload_table.OverDriveTable.FeatureCtrlMask;
+	od_table->OverDriveTable.Ppt = ppt;
+	user_od_table->OverDriveTable.Ppt = ppt;
+
+	return 0;
+}
+
 static void smu_v13_0_7_get_od_setting_limits(struct smu_context *smu,
 					      int od_feature_bit,
 					      int32_t *min,
@@ -1523,41 +1614,30 @@ static int smu_v13_0_7_od_restore_table_single(struct smu_context *smu, long inp
 					boot_overdrive_table->OverDriveTable.FanLinearPwmPoints[i];
 		}
 		od_table->OverDriveTable.FanMode = FAN_MODE_AUTO;
-		od_table->OverDriveTable.FeatureCtrlMask |= BIT(PP_OD_FEATURE_FAN_CURVE_BIT);
 		break;
 	case PP_OD_EDIT_ACOUSTIC_LIMIT:
 		od_table->OverDriveTable.AcousticLimitRpmThreshold =
 					boot_overdrive_table->OverDriveTable.AcousticLimitRpmThreshold;
-		od_table->OverDriveTable.FanMode = FAN_MODE_AUTO;
-		od_table->OverDriveTable.FeatureCtrlMask |= BIT(PP_OD_FEATURE_FAN_CURVE_BIT);
 		break;
 	case PP_OD_EDIT_ACOUSTIC_TARGET:
 		od_table->OverDriveTable.AcousticTargetRpmThreshold =
 					boot_overdrive_table->OverDriveTable.AcousticTargetRpmThreshold;
-		od_table->OverDriveTable.FanMode = FAN_MODE_AUTO;
-		od_table->OverDriveTable.FeatureCtrlMask |= BIT(PP_OD_FEATURE_FAN_CURVE_BIT);
 		break;
 	case PP_OD_EDIT_FAN_TARGET_TEMPERATURE:
 		od_table->OverDriveTable.FanTargetTemperature =
 					boot_overdrive_table->OverDriveTable.FanTargetTemperature;
-		od_table->OverDriveTable.FanMode = FAN_MODE_AUTO;
-		od_table->OverDriveTable.FeatureCtrlMask |= BIT(PP_OD_FEATURE_FAN_CURVE_BIT);
 		break;
 	case PP_OD_EDIT_FAN_MINIMUM_PWM:
 		od_table->OverDriveTable.FanMinimumPwm =
 					boot_overdrive_table->OverDriveTable.FanMinimumPwm;
-		od_table->OverDriveTable.FanMode = FAN_MODE_AUTO;
-		od_table->OverDriveTable.FeatureCtrlMask |= BIT(PP_OD_FEATURE_FAN_CURVE_BIT);
 		break;
 	case PP_OD_EDIT_FAN_ZERO_RPM_ENABLE:
 		od_table->OverDriveTable.FanZeroRpmEnable =
 					boot_overdrive_table->OverDriveTable.FanZeroRpmEnable;
-		od_table->OverDriveTable.FeatureCtrlMask |= BIT(PP_OD_FEATURE_ZERO_FAN_BIT);
 		break;
 	case PP_OD_EDIT_FAN_ZERO_RPM_STOP_TEMP:
 		od_table->OverDriveTable.FanZeroRpmStopTemp =
 					boot_overdrive_table->OverDriveTable.FanZeroRpmStopTemp;
-		od_table->OverDriveTable.FeatureCtrlMask |= BIT(PP_OD_FEATURE_ZERO_FAN_BIT);
 		break;
 	default:
 		dev_info(adev->dev, "Invalid table index: %ld\n", input);
@@ -1575,9 +1655,17 @@ static int smu_v13_0_7_od_edit_dpm_table(struct smu_context *smu,
 	struct smu_table_context *table_context = &smu->smu_table;
 	OverDriveTableExternal_t *od_table =
 		(OverDriveTableExternal_t *)table_context->overdrive_table;
+	OverDriveTableExternal_t *user_od_table =
+		(OverDriveTableExternal_t *)table_context->user_overdrive_table;
+	OverDriveTableExternal_t *boot_od_table =
+		(OverDriveTableExternal_t *)table_context->boot_overdrive_table;
+	OverDriveTableExternal_t upload_table;
+	OverDriveTable_t *od = &od_table->OverDriveTable;
+	OverDriveTable_t *boot = &boot_od_table->OverDriveTable;
 	struct amdgpu_device *adev = smu->adev;
 	uint32_t offset_of_voltageoffset;
 	int32_t minimum, maximum;
+	u32 next_mask;
 	int i, ret = 0;
 
 	switch (type) {
@@ -1903,35 +1991,40 @@ static int smu_v13_0_7_od_edit_dpm_table(struct smu_context *smu,
 					table_context->boot_overdrive_table,
 					sizeof(OverDriveTableExternal_t));
 			od_table->OverDriveTable.FeatureCtrlMask = 0;
-			table_context->user_od_feature_mask = 0;
 		}
 		fallthrough;
 
 	case PP_OD_COMMIT_DPM_TABLE:
-		table_context->user_od_feature_mask =
-			od_table->OverDriveTable.FeatureCtrlMask;
 		offset_of_voltageoffset = offsetof(OverDriveTable_t, VoltageOffsetPerZoneBoundary);
-		if (memcmp((u8 *)od_table + offset_of_voltageoffset,
-			   table_context->user_overdrive_table + offset_of_voltageoffset,
-			   sizeof(OverDriveTableExternal_t) - offset_of_voltageoffset)) {
-			smu_v13_0_7_dump_od_table(smu, od_table);
+		next_mask = smu_v13_0_7_filter_od_feature_mask(smu,
+							       table_context->user_od_feature_mask |
+							       od->FeatureCtrlMask);
+		next_mask = smu_v13_0_7_normalize_feature_mask(od, boot,
+							       next_mask);
 
-			ret = smu_v13_0_7_upload_overdrive_table(smu, od_table);
+		if (memcmp((u8 *)od_table + offset_of_voltageoffset,
+			   (u8 *)user_od_table + offset_of_voltageoffset,
+			   sizeof(OverDriveTableExternal_t) - offset_of_voltageoffset) ||
+		    next_mask != table_context->user_od_feature_mask) {
+			memcpy(&upload_table, od_table, sizeof(upload_table));
+			upload_table.OverDriveTable.FeatureCtrlMask = next_mask;
+			smu_v13_0_7_dump_od_table(smu, &upload_table);
+
+			ret = smu_v13_0_7_upload_overdrive_table(smu, &upload_table);
 			if (ret) {
 				dev_err(adev->dev, "Failed to upload overdrive table!\n");
 				return ret;
 			}
 
-			memcpy(table_context->user_overdrive_table + offset_of_voltageoffset,
+			table_context->user_od_feature_mask = next_mask;
+			od_table->OverDriveTable.FeatureCtrlMask = 0;
+			memcpy((u8 *)user_od_table + offset_of_voltageoffset,
 			       (u8 *)od_table + offset_of_voltageoffset,
 			       sizeof(OverDriveTableExternal_t) - offset_of_voltageoffset);
+			user_od_table->OverDriveTable.FeatureCtrlMask = 0;
 
-			if (!memcmp(table_context->user_overdrive_table,
-				    table_context->boot_overdrive_table,
-				    sizeof(OverDriveTableExternal_t)))
-				smu->user_dpm_profile.user_od = false;
-			else
-				smu->user_dpm_profile.user_od = true;
+			smu->user_dpm_profile.user_od =
+				!!(next_mask & ~BIT(PP_OD_FEATURE_PPT_BIT));
 		}
 		break;
 
@@ -2186,6 +2279,7 @@ static int smu_v13_0_7_set_default_od_settings(struct smu_context *smu)
 	memcpy(od_table,
 	       boot_od_table,
 	       sizeof(OverDriveTableExternal_t));
+	od_table->OverDriveTable.FeatureCtrlMask = 0;
 
 	/*
 	 * For S3/S4/Runpm resume, we need to setup those overdrive tables again,
@@ -2195,6 +2289,7 @@ static int smu_v13_0_7_set_default_od_settings(struct smu_context *smu)
 		memcpy(user_od_table,
 		       boot_od_table,
 		       sizeof(OverDriveTableExternal_t));
+		user_od_table->OverDriveTable.FeatureCtrlMask = 0;
 		smu->user_dpm_profile.user_od = false;
 		smu->smu_table.user_od_feature_mask = 0;
 	} else if (smu->user_dpm_profile.user_od) {
@@ -2233,6 +2328,14 @@ static int smu_v13_0_7_set_default_od_settings(struct smu_context *smu)
 			user_od_table_bak.OverDriveTable.FanZeroRpmEnable;
 		user_od_table->OverDriveTable.FanZeroRpmStopTemp =
 			user_od_table_bak.OverDriveTable.FanZeroRpmStopTemp;
+		user_od_table->OverDriveTable.FanMode =
+			user_od_table_bak.OverDriveTable.FanMode;
+		user_od_table->OverDriveTable.FeatureCtrlMask = 0;
+	}
+	if (smu->adev->in_suspend) {
+		user_od_table->OverDriveTable.Ppt = 0;
+		smu->smu_table.user_od_feature_mask &=
+			~BIT(PP_OD_FEATURE_PPT_BIT);
 	}
 
 	smu_v13_0_7_set_supported_od_feature_mask(smu);
@@ -2245,14 +2348,22 @@ static int smu_v13_0_7_restore_user_od_settings(struct smu_context *smu)
 	struct smu_table_context *table_context = &smu->smu_table;
 	OverDriveTableExternal_t *od_table = table_context->overdrive_table;
 	OverDriveTableExternal_t *user_od_table = table_context->user_overdrive_table;
+	OverDriveTableExternal_t upload_table;
+	u32 next_mask;
 	int res;
 
-	user_od_table->OverDriveTable.FeatureCtrlMask =
-		table_context->user_od_feature_mask;
-	res = smu_v13_0_7_upload_overdrive_table(smu, user_od_table);
-	user_od_table->OverDriveTable.FeatureCtrlMask = 0;
-	if (res == 0)
+	next_mask = smu_v13_0_7_filter_od_feature_mask(smu,
+						       table_context->user_od_feature_mask);
+	memcpy(&upload_table, user_od_table, sizeof(upload_table));
+	upload_table.OverDriveTable.FeatureCtrlMask = next_mask;
+	res = smu_v13_0_7_upload_overdrive_table(smu, &upload_table);
+	if (res == 0) {
+		table_context->user_od_feature_mask = next_mask;
+		smu->user_dpm_profile.user_od =
+			!!(next_mask & ~BIT(PP_OD_FEATURE_PPT_BIT));
 		memcpy(od_table, user_od_table, sizeof(OverDriveTableExternal_t));
+		od_table->OverDriveTable.FeatureCtrlMask = 0;
+	}
 
 	return res;
 }
@@ -2664,10 +2775,8 @@ static int smu_v13_0_7_set_ppt_limit(struct smu_context *smu,
 	SkuTable_t *skutable = &pptable->SkuTable;
 	uint32_t msg_limit = skutable->MsgLimits.Power
 		[PPT_THROTTLER_PPT0][POWER_SOURCE_AC];
-	struct smu_table_context *table_context = &smu->smu_table;
-	OverDriveTableExternal_t *od_table =
-		(OverDriveTableExternal_t *)table_context->overdrive_table;
 	OverDriveTableExternal_t current_od_table;
+	s16 ppt;
 	int ret = 0;
 
 	if (limit_type != SMU_PPT_LIMIT_PPT0)
@@ -2679,13 +2788,7 @@ static int smu_v13_0_7_set_ppt_limit(struct smu_context *smu,
 			return ret;
 
 		if (current_od_table.OverDriveTable.Ppt) {
-			od_table->OverDriveTable.Ppt = 0;
-			table_context->user_od_feature_mask &=
-				~(1U << PP_OD_FEATURE_PPT_BIT);
-			od_table->OverDriveTable.FeatureCtrlMask =
-				table_context->user_od_feature_mask;
-
-			ret = smu_v13_0_7_upload_overdrive_table(smu, od_table);
+			ret = smu_v13_0_7_upload_ppt_overdrive_table(smu, 0);
 			if (ret) {
 				dev_err(smu->adev->dev, "Failed to upload overdrive table!\n");
 				return ret;
@@ -2697,12 +2800,8 @@ static int smu_v13_0_7_set_ppt_limit(struct smu_context *smu,
 		if (ret)
 			return ret;
 
-		od_table->OverDriveTable.Ppt = (limit * 100) / msg_limit - 100;
-		table_context->user_od_feature_mask |= 1U << PP_OD_FEATURE_PPT_BIT;
-		od_table->OverDriveTable.FeatureCtrlMask =
-			table_context->user_od_feature_mask;
-
-		ret = smu_v13_0_7_upload_overdrive_table(smu, od_table);
+		ppt = (limit * 100) / msg_limit - 100;
+		ret = smu_v13_0_7_upload_ppt_overdrive_table(smu, ppt);
 		if (ret) {
 		  dev_err(smu->adev->dev, "Failed to upload overdrive table!\n");
 		  return ret;
-- 
2.53.0




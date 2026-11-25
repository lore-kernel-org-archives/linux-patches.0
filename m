Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622307;
	b=IM45m+A7uMBSh/YUVTuZpiWr6uTzEuXsqvNirPq/O5O7R+tgoRIt60zNRjmO+bgEofby
	 S4ikVcYdqelgbXMSOQvyakNyvx8oK+rejqFNFcSNfXx3/l04EOmxrjZqpVP46mJ2dSqtN
	 9lqNsJ/y/rynWtW/q+PK//4onTJhGRGh20RcoEJeLeRNK19kmhEY/lto+lmL2q2Ag0z9i
	 4J6lwpdw/oDIDW+4ugjSrdoqGueTiglTqGjpG143W1fgywz/7BEp8XpnyEoSY81MgcV5D
	 tjf3IycYllvTbulcCFmzBbwMyVFkhNK4iREVSCBkUPeO6CVot4+EQ0aX+iH/tv5pbTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622307;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=VYkmLsGqTIiz+RAMbZTzCVhgqhA+neI6uDFLQyyr+SM=;
	b=dVLL0q8FipTFnNUkeCEy+JwBdk/Ij1ofeQW0pZq0h8jb7IP2UTJsYaxuHBCvNw+gACz1
	 WNPzbqN6cAKWrwZDA3dcNiVpOoh5o+B9M3tulfVlsue8I3dBgiHHvwIKz8o9BcnkoBoaf
	 Mjp4juiwcrbyPLpfEVGfB+tDgomshamOrFP4WeyK7L40gWhW5F7hAHeRrqx37pTZxfGwq
	 28ygnVQtLbKYZsryIZAN2Njrlx9yC4Fbh3TwRJ7kAlpiSp7h3n7ve4/7qgJczGzFdxbWG
	 bSOJjUocZkCpe9sYVEHkWo5JJnRp7xLDwmV1XzknhSUsILi+vscist3FasqjUo+7uTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="g9/sR236";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AFB0606A327;
	Wed, 25 Nov 2026 15:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g9/sR236
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9A191F000C6;
	Wed, 25 Nov 2026 15:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622306;
	bh=VYkmLsGqTIiz+RAMbZTzCVhgqhA+neI6uDFLQyyr+SM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g9/sR236qsVu4eVDdOHiGu4lFcMpNJfSNE+PctAtVQzFroGGFX9OhNHjSf9YDYp1u
	 TzstOkpQGQTwDbiVDxO9pyDJQeoutG1txFKsbsqTyq/YFIOwx3nFcUlZVGM0PILHVM
	 zgE3Gjt/YP+dzixapHJBL/pV7Gl7PK1wqV+V8xUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Wang <kevin.wang@amd.com>,
	Kenneth Feng <kenneth.feng@amd.com>,
	=?UTF-8?q?Jos=C3=A9=20Miguel=20Sarasola?= <alosarjos@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 494/990] drm/amd/pm: preserve committed OD features for SMU 13.0.0/13.0.7
Date: Wed, 25 Nov 2026 15:31:01 +0100
Message-ID: <20261125143833.666457979@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Low-limit power-cap branch tests smu->current_power_limit > msg_limit instead of upstream's firmware Ppt readback, and uses older set_power_limit naming, with the forward declaration anchored on a different function. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c  | 193 +++++++++++++-----
 .../drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c  | 193 +++++++++++++-----
 2 files changed, 293 insertions(+), 93 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
index 9d2d630bba240..4ed3bbc3effef 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
@@ -62,6 +62,9 @@
 static void smu_v13_0_0_get_od_setting_limits(struct smu_context *smu,
 					      int od_feature_bit,
 					      int32_t *min, int32_t *max);
+static int
+smu_v13_0_0_upload_overdrive_table(struct smu_context *smu,
+				   OverDriveTableExternal_t *od_table);
 
 #define FEATURE_MASK(feature) (1ULL << feature)
 #define SMC_DPM_FEATURE ( \
@@ -1096,6 +1099,93 @@ static bool smu_v13_0_0_is_od_feature_supported(struct smu_context *smu,
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
@@ -1588,41 +1678,30 @@ static int smu_v13_0_0_od_restore_table_single(struct smu_context *smu, long inp
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
@@ -1640,9 +1719,17 @@ static int smu_v13_0_0_od_edit_dpm_table(struct smu_context *smu,
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
@@ -1966,36 +2053,41 @@ static int smu_v13_0_0_od_edit_dpm_table(struct smu_context *smu,
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
 
@@ -2254,6 +2346,7 @@ static int smu_v13_0_0_set_default_od_settings(struct smu_context *smu)
 	memcpy(od_table,
 	       boot_od_table,
 	       sizeof(OverDriveTableExternal_t));
+	od_table->OverDriveTable.FeatureCtrlMask = 0;
 
 	/*
 	 * For S3/S4/Runpm resume, we need to setup those overdrive tables again,
@@ -2263,6 +2356,7 @@ static int smu_v13_0_0_set_default_od_settings(struct smu_context *smu)
 		memcpy(user_od_table,
 		       boot_od_table,
 		       sizeof(OverDriveTableExternal_t));
+		user_od_table->OverDriveTable.FeatureCtrlMask = 0;
 		smu->user_dpm_profile.user_od = false;
 		smu->smu_table.user_od_feature_mask = 0;
 	} else if (smu->user_dpm_profile.user_od) {
@@ -2301,6 +2395,14 @@ static int smu_v13_0_0_set_default_od_settings(struct smu_context *smu)
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
@@ -2313,13 +2415,22 @@ static int smu_v13_0_0_restore_user_od_settings(struct smu_context *smu)
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
@@ -3109,9 +3220,7 @@ static int smu_v13_0_0_set_power_limit(struct smu_context *smu,
 	PPTable_t *pptable = smu->smu_table.driver_pptable;
 	SkuTable_t *skutable = &pptable->SkuTable;
 	uint32_t msg_limit = skutable->MsgLimits.Power[PPT_THROTTLER_PPT0][POWER_SOURCE_AC];
-	struct smu_table_context *table_context = &smu->smu_table;
-	OverDriveTableExternal_t *od_table =
-		(OverDriveTableExternal_t *)table_context->overdrive_table;
+	s16 ppt;
 	int ret = 0;
 
 	if (limit_type != SMU_DEFAULT_PPT_LIMIT)
@@ -3119,12 +3228,7 @@ static int smu_v13_0_0_set_power_limit(struct smu_context *smu,
 
 	if (limit <= msg_limit) {
 		if (smu->current_power_limit > msg_limit) {
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
@@ -3136,11 +3240,8 @@ static int smu_v13_0_0_set_power_limit(struct smu_context *smu,
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
index 5df28b89cb696..dab5514b1832b 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
@@ -62,6 +62,9 @@
 static void smu_v13_0_7_get_od_setting_limits(struct smu_context *smu,
 					      int od_feature_bit,
 					      int32_t *min, int32_t *max);
+static int
+smu_v13_0_7_upload_overdrive_table(struct smu_context *smu,
+				   OverDriveTableExternal_t *od_table);
 
 #define FEATURE_MASK(feature) (1ULL << feature)
 #define SMC_DPM_FEATURE ( \
@@ -80,6 +83,7 @@ static void smu_v13_0_7_get_od_setting_limits(struct smu_context *smu,
 #define PP_OD_FEATURE_GFXCLK_FMAX			1
 #define PP_OD_FEATURE_UCLK_FMIN				2
 #define PP_OD_FEATURE_UCLK_FMAX				3
+
 #define PP_OD_FEATURE_GFX_VF_CURVE			4
 #define PP_OD_FEATURE_FAN_CURVE_TEMP			5
 #define PP_OD_FEATURE_FAN_CURVE_PWM			6
@@ -1085,6 +1089,93 @@ static bool smu_v13_0_7_is_od_feature_supported(struct smu_context *smu,
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
@@ -1576,41 +1667,30 @@ static int smu_v13_0_7_od_restore_table_single(struct smu_context *smu, long inp
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
@@ -1628,9 +1708,17 @@ static int smu_v13_0_7_od_edit_dpm_table(struct smu_context *smu,
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
@@ -1956,35 +2044,40 @@ static int smu_v13_0_7_od_edit_dpm_table(struct smu_context *smu,
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
 
@@ -2237,6 +2330,7 @@ static int smu_v13_0_7_set_default_od_settings(struct smu_context *smu)
 	memcpy(od_table,
 	       boot_od_table,
 	       sizeof(OverDriveTableExternal_t));
+	od_table->OverDriveTable.FeatureCtrlMask = 0;
 
 	/*
 	 * For S3/S4/Runpm resume, we need to setup those overdrive tables again,
@@ -2246,6 +2340,7 @@ static int smu_v13_0_7_set_default_od_settings(struct smu_context *smu)
 		memcpy(user_od_table,
 		       boot_od_table,
 		       sizeof(OverDriveTableExternal_t));
+		user_od_table->OverDriveTable.FeatureCtrlMask = 0;
 		smu->user_dpm_profile.user_od = false;
 		smu->smu_table.user_od_feature_mask = 0;
 	} else if (smu->user_dpm_profile.user_od) {
@@ -2284,6 +2379,14 @@ static int smu_v13_0_7_set_default_od_settings(struct smu_context *smu)
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
@@ -2296,14 +2399,22 @@ static int smu_v13_0_7_restore_user_od_settings(struct smu_context *smu)
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
@@ -2706,9 +2817,7 @@ static int smu_v13_0_7_set_power_limit(struct smu_context *smu,
 	PPTable_t *pptable = smu->smu_table.driver_pptable;
 	SkuTable_t *skutable = &pptable->SkuTable;
 	uint32_t msg_limit = skutable->MsgLimits.Power[PPT_THROTTLER_PPT0][POWER_SOURCE_AC];
-	struct smu_table_context *table_context = &smu->smu_table;
-	OverDriveTableExternal_t *od_table =
-		(OverDriveTableExternal_t *)table_context->overdrive_table;
+	s16 ppt;
 	int ret = 0;
 
 	if (limit_type != SMU_DEFAULT_PPT_LIMIT)
@@ -2716,13 +2825,7 @@ static int smu_v13_0_7_set_power_limit(struct smu_context *smu,
 
 	if (limit <= msg_limit) {
 		if (smu->current_power_limit > msg_limit) {
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
@@ -2734,12 +2837,8 @@ static int smu_v13_0_7_set_power_limit(struct smu_context *smu,
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




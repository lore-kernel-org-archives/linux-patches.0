Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622196;
	b=v5ILls8EghxeJHU+cRyhtoh7Lz34gWX5IkDO7jCqxGAngIkKafOZki8jeOGledaYKvr+
	 P1jQg1rNK6X69Io0dXZDAZsc9bWQ1TQtL8s58kFyidbeALvknKvNhqUy77VqgOFG1xUB1
	 ZYjLggqZhMVdQjzQHrJcfxR44G/ilaF5/T2P/JukPtcmIJIjpDdRNBaLbm9Iwmj4vItBi
	 CJc3tPZSJTlLULwkF4wp/KwYFzgtXljeTf/CbrDtvFhCLsfWcAr9w8JpA4hHphWhcBiM/
	 QjNw+PjH1ciC1WxQfobK7nI7wG/3ESImtp5MZ1hbebejLGjYrbofJZHBmJPct9L+umg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622196;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Anh6n5kZhopbbboaC54+jSq0g1O+c2hDbWC0sthW+cU=;
	b=MZ2EnBErdaFC0zq6/yBM8cvYllDobWG00MOlV4lRfrROjqd5iTvfDo+WJvApjTC08yPt
	 2Ppez3vnuyKdbfKaxWNr0I4wZaNmeNlDdiJbu9eZdhsKtxSK5msw1O78Bv2N3BRvgH4ob
	 AoMCjBLPAfiUBz8ScKgbM+hP+MNczWMo+mcKi9cE48dXUeuaCGYKORH4wrkBIrRWwwh1T
	 ORqhJmBBs8PFURzda+qK8YD22RopRNrk9L8JucB3o9YxxcztkmtKH73HM4lbCTWyAOyAb
	 gdOhLxCoYtodENfcQToNvkiOT7k7+zp242NQT55yivawG+UB/kVeNnnHoNAWBOnWEuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="vUl6i/EZ";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDB86606A329;
	Wed, 25 Nov 2026 15:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vUl6i/EZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A2E51F000E0;
	Wed, 25 Nov 2026 15:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622196;
	bh=Anh6n5kZhopbbboaC54+jSq0g1O+c2hDbWC0sthW+cU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vUl6i/EZsyIV1dtPs4S9Ba2bK+YEINJ0ET5DBAPVxzhYlMIIlk0v5s3uVwk+/KdqF
	 S36fv2Iq59ccjZn1lGxZx7UWF7RjOCT8kBvZ21kEAtfyCPR0mYrMvr6fG4vL+nsQKz
	 RjObpEa8K1kcuL7y9e/gyeQGqsH7L7Kt/BTo6gww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Balasubramani Vivekanandan <balasubramani.vivekanandan@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 461/990] drm/xe/pvc: Drop pre-prod workarounds
Date: Wed, 25 Nov 2026 15:30:28 +0100
Message-ID: <20261125143832.894428795@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Roper <matthew.d.roper@intel.com>

[ Upstream commit 4405938293631604f0bec290c2e30bd392608393 ]

Production PVC hardware had a graphics stepping of C0.  Xe1 platforms
already aren't officially supported by the Xe driver, but pre-production
steppings are especially out of scope (and 'has_pre_prod_wa' is not set
in the device descriptor).  Drop the workarounds that aren't relevant to
production hardware.

v2:
 - Drop the stream->override_gucrc which is no longer set anywhere after
   the removal of Wa_1509372804.  (Bala)
 - Drop xe_guc_rc_set_mode / xe_guc_rc_unset_mode which are no longer
   used after the removal of Wa_1509372804.

Bspec: 44484
Cc: Balasubramani Vivekanandan <balasubramani.vivekanandan@intel.com>
Reviewed-by: Balasubramani Vivekanandan <balasubramani.vivekanandan@intel.com>
Link: https://patch.msgid.link/20260220-forupstream-wa_cleanup-v2-2-b12005a05af6@intel.com
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Stable-dep-of: 557c7b434378 ("drm/xe: Sync Wa_16023105232 in xe_was to match OOB rule")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_guc.c        |  3 ---
 drivers/gpu/drm/xe/xe_guc_rc.c     | 29 -----------------------------
 drivers/gpu/drm/xe/xe_guc_rc.h     |  2 --
 drivers/gpu/drm/xe/xe_oa.c         | 19 -------------------
 drivers/gpu/drm/xe/xe_oa_types.h   |  3 ---
 drivers/gpu/drm/xe/xe_wa.c         |  5 -----
 drivers/gpu/drm/xe/xe_wa_oob.rules |  2 --
 7 files changed, 63 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_guc.c b/drivers/gpu/drm/xe/xe_guc.c
index 5a8244633b67f..6a3546d7a47ba 100644
--- a/drivers/gpu/drm/xe/xe_guc.c
+++ b/drivers/gpu/drm/xe/xe_guc.c
@@ -205,9 +205,6 @@ static u32 guc_ctl_wa_flags(struct xe_guc *guc)
 	    !xe_hw_engine_mask_per_class(gt, XE_ENGINE_CLASS_RENDER))
 		flags |= GUC_WA_RCS_REGS_IN_CCS_REGS_LIST;
 
-	if (XE_GT_WA(gt, 1509372804))
-		flags |= GUC_WA_RENDER_RST_RC6_EXIT;
-
 	if (XE_GT_WA(gt, 14018913170))
 		flags |= GUC_WA_ENABLE_TSC_CHECK_ON_RC6;
 
diff --git a/drivers/gpu/drm/xe/xe_guc_rc.c b/drivers/gpu/drm/xe/xe_guc_rc.c
index 427a889b2a1e0..99fa127b261ff 100644
--- a/drivers/gpu/drm/xe/xe_guc_rc.c
+++ b/drivers/gpu/drm/xe/xe_guc_rc.c
@@ -129,32 +129,3 @@ int xe_guc_rc_enable(struct xe_guc *guc)
 
 	return guc_action_setup_gucrc(guc, GUCRC_FIRMWARE_CONTROL);
 }
-
-/**
- * xe_guc_rc_set_mode() - set new GUCRC mode
- * @guc: Xe GuC instance
- * @mode: new value of the mode.
- *
- * Function to set GuC RC mode to one of the enum values.
- *
- * Returns: 0 on success, negative error code on error
- */
-int xe_guc_rc_set_mode(struct xe_guc *guc, enum slpc_gucrc_mode mode)
-{
-	guard(xe_pm_runtime_noresume)(guc_to_xe(guc));
-	return xe_guc_pc_action_set_param(&guc->pc, SLPC_PARAM_PWRGATE_RC_MODE, mode);
-}
-
-/**
- * xe_guc_rc_unset_mode() - revert to default mode
- * @guc: Xe GuC instance
- *
- * Function to revert GuC RC mode to platform defaults.
- *
- * Returns: 0 on success, negative error code on error
- */
-int xe_guc_rc_unset_mode(struct xe_guc *guc)
-{
-	guard(xe_pm_runtime_noresume)(guc_to_xe(guc));
-	return xe_guc_pc_action_unset_param(&guc->pc, SLPC_PARAM_PWRGATE_RC_MODE);
-}
diff --git a/drivers/gpu/drm/xe/xe_guc_rc.h b/drivers/gpu/drm/xe/xe_guc_rc.h
index f1f949e7ecc0c..b083fc364dd43 100644
--- a/drivers/gpu/drm/xe/xe_guc_rc.h
+++ b/drivers/gpu/drm/xe/xe_guc_rc.h
@@ -12,7 +12,5 @@ enum slpc_gucrc_mode;
 int xe_guc_rc_init(struct xe_guc *guc);
 int xe_guc_rc_enable(struct xe_guc *guc);
 void xe_guc_rc_disable(struct xe_guc *guc);
-int xe_guc_rc_set_mode(struct xe_guc *guc, enum slpc_gucrc_mode mode);
-int xe_guc_rc_unset_mode(struct xe_guc *guc);
 
 #endif
diff --git a/drivers/gpu/drm/xe/xe_oa.c b/drivers/gpu/drm/xe/xe_oa.c
index 905c7eae6413c..e7861f135f552 100644
--- a/drivers/gpu/drm/xe/xe_oa.c
+++ b/drivers/gpu/drm/xe/xe_oa.c
@@ -875,10 +875,6 @@ static void xe_oa_stream_destroy(struct xe_oa_stream *stream)
 	xe_force_wake_put(gt_to_fw(gt), XE_FORCEWAKE_ALL);
 	xe_pm_runtime_put(stream->oa->xe);
 
-	/* Wa_1509372804:pvc: Unset the override of GUCRC mode to enable rc6 */
-	if (stream->override_gucrc)
-		xe_gt_WARN_ON(gt, xe_guc_rc_unset_mode(&gt->uc.guc));
-
 	xe_oa_free_configs(stream);
 	xe_file_put(stream->xef);
 }
@@ -1778,18 +1774,6 @@ static int xe_oa_stream_init(struct xe_oa_stream *stream,
 		goto exit;
 	}
 
-	/*
-	 * GuC reset of engines causes OA to lose configuration
-	 * state. Prevent this by overriding GUCRC mode.
-	 */
-	if (XE_GT_WA(stream->gt, 1509372804)) {
-		ret = xe_guc_rc_set_mode(&gt->uc.guc, SLPC_GUCRC_MODE_GUCRC_NO_RC6);
-		if (ret)
-			goto err_free_configs;
-
-		stream->override_gucrc = true;
-	}
-
 	/* Take runtime pm ref and forcewake to disable RC6 */
 	xe_pm_runtime_get(stream->oa->xe);
 	fw_ref = xe_force_wake_get(gt_to_fw(gt), XE_FORCEWAKE_ALL);
@@ -1840,9 +1824,6 @@ static int xe_oa_stream_init(struct xe_oa_stream *stream,
 err_fw_put:
 	xe_force_wake_put(gt_to_fw(gt), fw_ref);
 	xe_pm_runtime_put(stream->oa->xe);
-	if (stream->override_gucrc)
-		xe_gt_WARN_ON(gt, xe_guc_rc_unset_mode(&gt->uc.guc));
-err_free_configs:
 	xe_oa_free_configs(stream);
 exit:
 	xe_file_put(stream->xef);
diff --git a/drivers/gpu/drm/xe/xe_oa_types.h b/drivers/gpu/drm/xe/xe_oa_types.h
index 48f9520f560c2..468b23d333e1f 100644
--- a/drivers/gpu/drm/xe/xe_oa_types.h
+++ b/drivers/gpu/drm/xe/xe_oa_types.h
@@ -241,9 +241,6 @@ struct xe_oa_stream {
 	/** @poll_period_ns: hrtimer period for checking OA buffer for available data */
 	u64 poll_period_ns;
 
-	/** @override_gucrc: GuC RC has been overridden for the OA stream */
-	bool override_gucrc;
-
 	/** @oa_status: temporary storage for oa_status register value */
 	u32 oa_status;
 
diff --git a/drivers/gpu/drm/xe/xe_wa.c b/drivers/gpu/drm/xe/xe_wa.c
index e4810821d4813..0a59fd3ef7690 100644
--- a/drivers/gpu/drm/xe/xe_wa.c
+++ b/drivers/gpu/drm/xe/xe_wa.c
@@ -475,11 +475,6 @@ static const struct xe_rtp_entry_sr engine_was[] = {
 		       ENGINE_CLASS(COMPUTE)),
 	  XE_RTP_ACTIONS(SET(RING_HWSTAM(RENDER_RING_BASE), ~0))
 	},
-	{ XE_RTP_NAME("14014999345"),
-	  XE_RTP_RULES(PLATFORM(PVC), ENGINE_CLASS(COMPUTE),
-		       GRAPHICS_STEP(B0, C0)),
-	  XE_RTP_ACTIONS(SET(CACHE_MODE_SS, DISABLE_ECC))
-	},
 
 	/* Xe_LPG */
 
diff --git a/drivers/gpu/drm/xe/xe_wa_oob.rules b/drivers/gpu/drm/xe/xe_wa_oob.rules
index 31b5062585eb3..40ffe05ea2701 100644
--- a/drivers/gpu/drm/xe/xe_wa_oob.rules
+++ b/drivers/gpu/drm/xe/xe_wa_oob.rules
@@ -9,7 +9,6 @@
 22012727685	SUBPLATFORM(DG2, G11)
 22016596838	PLATFORM(PVC)
 18020744125	PLATFORM(PVC)
-1509372804	PLATFORM(PVC), GRAPHICS_STEP(A0, C0)
 1409600907	GRAPHICS_VERSION_RANGE(1200, 1250)
 14016763929	SUBPLATFORM(DG2, G10)
 		SUBPLATFORM(DG2, G12)
@@ -60,7 +59,6 @@
 18013179988	GRAPHICS_VERSION(1255)
 		GRAPHICS_VERSION_RANGE(1270, 1274)
 1508761755	GRAPHICS_VERSION(1255)
-		GRAPHICS_VERSION(1260), GRAPHICS_STEP(A0, B0)
 16023105232	GRAPHICS_VERSION_RANGE(2001, 3001)
 		MEDIA_VERSION_RANGE(1301, 3000)
 		MEDIA_VERSION(3002)
-- 
2.53.0




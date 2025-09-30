Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D262F2236EB;
	Tue, 30 Sep 2025 15:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244733; cv=none; b=gOZk/PUJtetp91i3xMdBMg+nNrt0/vkRr8ricdVhNBAUd80fNTC8hd1tWzgZDX0roFRg2FR1AFGbtg1woN6CCWS3jnMJn14AEhDHggyE7O8P6AKI2jx5N+iTnfl4aw/bU3RsloGVM+1gHyHmqFOHIaf6d+OnorjIbZwVe3XPBqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244733; c=relaxed/simple;
	bh=jpRRhj58syMdMlpHBQBS+PQ1xY0ox+SQNrm4x+Oldbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hnoQZq3AcHTD/BibdCAAxDh6ZHoXQYKjtKtCI/gaek9Nt36ZWLjqJAaKgxaJvFD3dKLhs9bGjMY+7R89hdn1lj7QX8F4P4Tkf9C1FeYX1iGGl4ivx5bqISWotdKG6kDaqfpuDv+yhlHizgSzX1FMjzvvjvDeWU7oEgBY8+gT62E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CDTBc4RD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CDTBc4RD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FC7BC4CEF0;
	Tue, 30 Sep 2025 15:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244733;
	bh=jpRRhj58syMdMlpHBQBS+PQ1xY0ox+SQNrm4x+Oldbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CDTBc4RDiWUFX0FK0X37wjxDaWwA047AUHs7dPitcX7dK6G/tzSeoRNF0mDPfBXpJ
	 FXnFOTTLwYr0SmzYlNeF2mAyje/NRLYU0whJc2ac6RZip8tB3ImLCcyFFr1mfFD/d1
	 8oiA0H9xg8HUe1vhqgWeBunGPFtUpYd+07mJhyCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Iy=C3=A1n=20M=C3=A9ndez=20Veiga?= <me@iyanmv.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 098/143] Revert "drm/xe/guc: Enable extended CAT error reporting"
Date: Tue, 30 Sep 2025 16:47:02 +0200
Message-ID: <20250930143835.132782571@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit a7ffcea8631af91479cab10aa7fbfd0722f01d9a.

Reported-by: Iyán Méndez Veiga <me@iyanmv.com>
Link: https://lore.kernel.org/stable/aNlW7ekiC0dNPxU3@laps/T/#t
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/abi/guc_actions_abi.h |  4 --
 drivers/gpu/drm/xe/abi/guc_klvs_abi.h    | 15 -------
 drivers/gpu/drm/xe/xe_guc.c              | 56 ------------------------
 drivers/gpu/drm/xe/xe_guc.h              |  1 -
 drivers/gpu/drm/xe/xe_guc_submit.c       | 21 ++-------
 drivers/gpu/drm/xe/xe_uc.c               |  4 --
 6 files changed, 3 insertions(+), 98 deletions(-)

diff --git a/drivers/gpu/drm/xe/abi/guc_actions_abi.h b/drivers/gpu/drm/xe/abi/guc_actions_abi.h
index b55d4cfb483a1..448afb86e05c7 100644
--- a/drivers/gpu/drm/xe/abi/guc_actions_abi.h
+++ b/drivers/gpu/drm/xe/abi/guc_actions_abi.h
@@ -142,7 +142,6 @@ enum xe_guc_action {
 	XE_GUC_ACTION_SET_ENG_UTIL_BUFF = 0x550A,
 	XE_GUC_ACTION_SET_DEVICE_ENGINE_ACTIVITY_BUFFER = 0x550C,
 	XE_GUC_ACTION_SET_FUNCTION_ENGINE_ACTIVITY_BUFFER = 0x550D,
-	XE_GUC_ACTION_OPT_IN_FEATURE_KLV = 0x550E,
 	XE_GUC_ACTION_NOTIFY_MEMORY_CAT_ERROR = 0x6000,
 	XE_GUC_ACTION_REPORT_PAGE_FAULT_REQ_DESC = 0x6002,
 	XE_GUC_ACTION_PAGE_FAULT_RES_DESC = 0x6003,
@@ -241,7 +240,4 @@ enum xe_guc_g2g_type {
 #define XE_G2G_DEREGISTER_TILE	REG_GENMASK(15, 12)
 #define XE_G2G_DEREGISTER_TYPE	REG_GENMASK(11, 8)
 
-/* invalid type for XE_GUC_ACTION_NOTIFY_MEMORY_CAT_ERROR */
-#define XE_GUC_CAT_ERR_TYPE_INVALID 0xdeadbeef
-
 #endif
diff --git a/drivers/gpu/drm/xe/abi/guc_klvs_abi.h b/drivers/gpu/drm/xe/abi/guc_klvs_abi.h
index 5b2502bec2dcc..7de8f827281fc 100644
--- a/drivers/gpu/drm/xe/abi/guc_klvs_abi.h
+++ b/drivers/gpu/drm/xe/abi/guc_klvs_abi.h
@@ -16,7 +16,6 @@
  *  +===+=======+==============================================================+
  *  | 0 | 31:16 | **KEY** - KLV key identifier                                 |
  *  |   |       |   - `GuC Self Config KLVs`_                                  |
- *  |   |       |   - `GuC Opt In Feature KLVs`_                               |
  *  |   |       |   - `GuC VGT Policy KLVs`_                                   |
  *  |   |       |   - `GuC VF Configuration KLVs`_                             |
  *  |   |       |                                                              |
@@ -125,20 +124,6 @@ enum  {
 	GUC_CONTEXT_POLICIES_KLV_NUM_IDS = 5,
 };
 
-/**
- * DOC: GuC Opt In Feature KLVs
- *
- * `GuC KLV`_ keys available for use with OPT_IN_FEATURE_KLV
- *
- *  _`GUC_KLV_OPT_IN_FEATURE_EXT_CAT_ERR_TYPE` : 0x4001
- *      Adds an extra dword to the XE_GUC_ACTION_NOTIFY_MEMORY_CAT_ERROR G2H
- *      containing the type of the CAT error. On HW that does not support
- *      reporting the CAT error type, the extra dword is set to 0xdeadbeef.
- */
-
-#define GUC_KLV_OPT_IN_FEATURE_EXT_CAT_ERR_TYPE_KEY 0x4001
-#define GUC_KLV_OPT_IN_FEATURE_EXT_CAT_ERR_TYPE_LEN 0u
-
 /**
  * DOC: GuC VGT Policy KLVs
  *
diff --git a/drivers/gpu/drm/xe/xe_guc.c b/drivers/gpu/drm/xe/xe_guc.c
index 2efc0298e1a4c..bac5471a1a780 100644
--- a/drivers/gpu/drm/xe/xe_guc.c
+++ b/drivers/gpu/drm/xe/xe_guc.c
@@ -29,7 +29,6 @@
 #include "xe_guc_db_mgr.h"
 #include "xe_guc_engine_activity.h"
 #include "xe_guc_hwconfig.h"
-#include "xe_guc_klv_helpers.h"
 #include "xe_guc_log.h"
 #include "xe_guc_pc.h"
 #include "xe_guc_relay.h"
@@ -571,57 +570,6 @@ static int guc_g2g_start(struct xe_guc *guc)
 	return err;
 }
 
-static int __guc_opt_in_features_enable(struct xe_guc *guc, u64 addr, u32 num_dwords)
-{
-	u32 action[] = {
-		XE_GUC_ACTION_OPT_IN_FEATURE_KLV,
-		lower_32_bits(addr),
-		upper_32_bits(addr),
-		num_dwords
-	};
-
-	return xe_guc_ct_send_block(&guc->ct, action, ARRAY_SIZE(action));
-}
-
-#define OPT_IN_MAX_DWORDS 16
-int xe_guc_opt_in_features_enable(struct xe_guc *guc)
-{
-	struct xe_device *xe = guc_to_xe(guc);
-	CLASS(xe_guc_buf, buf)(&guc->buf, OPT_IN_MAX_DWORDS);
-	u32 count = 0;
-	u32 *klvs;
-	int ret;
-
-	if (!xe_guc_buf_is_valid(buf))
-		return -ENOBUFS;
-
-	klvs = xe_guc_buf_cpu_ptr(buf);
-
-	/*
-	 * The extra CAT error type opt-in was added in GuC v70.17.0, which maps
-	 * to compatibility version v1.7.0.
-	 * Note that the GuC allows enabling this KLV even on platforms that do
-	 * not support the extra type; in such case the returned type variable
-	 * will be set to a known invalid value which we can check against.
-	 */
-	if (GUC_SUBMIT_VER(guc) >= MAKE_GUC_VER(1, 7, 0))
-		klvs[count++] = PREP_GUC_KLV_TAG(OPT_IN_FEATURE_EXT_CAT_ERR_TYPE);
-
-	if (count) {
-		xe_assert(xe, count <= OPT_IN_MAX_DWORDS);
-
-		ret = __guc_opt_in_features_enable(guc, xe_guc_buf_flush(buf), count);
-		if (ret < 0) {
-			xe_gt_err(guc_to_gt(guc),
-				  "failed to enable GuC opt-in features: %pe\n",
-				  ERR_PTR(ret));
-			return ret;
-		}
-	}
-
-	return 0;
-}
-
 static void guc_fini_hw(void *arg)
 {
 	struct xe_guc *guc = arg;
@@ -815,10 +763,6 @@ int xe_guc_post_load_init(struct xe_guc *guc)
 
 	xe_guc_ads_populate_post_load(&guc->ads);
 
-	ret = xe_guc_opt_in_features_enable(guc);
-	if (ret)
-		return ret;
-
 	if (xe_guc_g2g_wanted(guc_to_xe(guc))) {
 		ret = guc_g2g_start(guc);
 		if (ret)
diff --git a/drivers/gpu/drm/xe/xe_guc.h b/drivers/gpu/drm/xe/xe_guc.h
index 4a66575f017d2..58338be445585 100644
--- a/drivers/gpu/drm/xe/xe_guc.h
+++ b/drivers/gpu/drm/xe/xe_guc.h
@@ -33,7 +33,6 @@ int xe_guc_reset(struct xe_guc *guc);
 int xe_guc_upload(struct xe_guc *guc);
 int xe_guc_min_load_for_hwconfig(struct xe_guc *guc);
 int xe_guc_enable_communication(struct xe_guc *guc);
-int xe_guc_opt_in_features_enable(struct xe_guc *guc);
 int xe_guc_suspend(struct xe_guc *guc);
 void xe_guc_notify(struct xe_guc *guc);
 int xe_guc_auth_huc(struct xe_guc *guc, u32 rsa_addr);
diff --git a/drivers/gpu/drm/xe/xe_guc_submit.c b/drivers/gpu/drm/xe/xe_guc_submit.c
index e670dcb0f0932..45a21af126927 100644
--- a/drivers/gpu/drm/xe/xe_guc_submit.c
+++ b/drivers/gpu/drm/xe/xe_guc_submit.c
@@ -2088,16 +2088,12 @@ int xe_guc_exec_queue_memory_cat_error_handler(struct xe_guc *guc, u32 *msg,
 	struct xe_gt *gt = guc_to_gt(guc);
 	struct xe_exec_queue *q;
 	u32 guc_id;
-	u32 type = XE_GUC_CAT_ERR_TYPE_INVALID;
 
-	if (unlikely(!len || len > 2))
+	if (unlikely(len < 1))
 		return -EPROTO;
 
 	guc_id = msg[0];
 
-	if (len == 2)
-		type = msg[1];
-
 	if (guc_id == GUC_ID_UNKNOWN) {
 		/*
 		 * GuC uses GUC_ID_UNKNOWN if it can not map the CAT fault to any PF/VF
@@ -2111,19 +2107,8 @@ int xe_guc_exec_queue_memory_cat_error_handler(struct xe_guc *guc, u32 *msg,
 	if (unlikely(!q))
 		return -EPROTO;
 
-	/*
-	 * The type is HW-defined and changes based on platform, so we don't
-	 * decode it in the kernel and only check if it is valid.
-	 * See bspec 54047 and 72187 for details.
-	 */
-	if (type != XE_GUC_CAT_ERR_TYPE_INVALID)
-		xe_gt_dbg(gt,
-			  "Engine memory CAT error [%u]: class=%s, logical_mask: 0x%x, guc_id=%d",
-			  type, xe_hw_engine_class_to_str(q->class), q->logical_mask, guc_id);
-	else
-		xe_gt_dbg(gt,
-			  "Engine memory CAT error: class=%s, logical_mask: 0x%x, guc_id=%d",
-			  xe_hw_engine_class_to_str(q->class), q->logical_mask, guc_id);
+	xe_gt_dbg(gt, "Engine memory cat error: engine_class=%s, logical_mask: 0x%x, guc_id=%d",
+		  xe_hw_engine_class_to_str(q->class), q->logical_mask, guc_id);
 
 	trace_xe_exec_queue_memory_cat_error(q);
 
diff --git a/drivers/gpu/drm/xe/xe_uc.c b/drivers/gpu/drm/xe/xe_uc.c
index 5c45b0f072a4c..3a8751a8b92dd 100644
--- a/drivers/gpu/drm/xe/xe_uc.c
+++ b/drivers/gpu/drm/xe/xe_uc.c
@@ -165,10 +165,6 @@ static int vf_uc_init_hw(struct xe_uc *uc)
 
 	uc->guc.submission_state.enabled = true;
 
-	err = xe_guc_opt_in_features_enable(&uc->guc);
-	if (err)
-		return err;
-
 	err = xe_gt_record_default_lrcs(uc_to_gt(uc));
 	if (err)
 		return err;
-- 
2.51.0




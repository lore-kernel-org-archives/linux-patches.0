Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622193;
	b=SmQKE/mULN+/0FlFeE5HQBW9BEDEN1gh4jtOzw5G1r54TgMrJzkrPHPvS1XUdfaObXv5
	 zkovsw/DnTv/onBBqajpYUuwmplfpBzgUvZWwY2AvBtCKdGvusY6417/66WkpW1t2Che5
	 kS3KTG7H0Y6Tdn9Z546aan0uxDXatagK1h8zC8y5ZfJCzSJIdko0YC5ewSsihNEn/GHJP
	 DLhICzk0SOYUCj5PM05ENILF5vec2s4T3CvAz0TSYgNPTHJaFbYRyxp9CCUf/HC6U0kMh
	 Nd4QIIE0npXuLgzapWySrwtm+ILVH3BwkME4r758YJwe2xHXUMm1/jTn7vUJqv89UKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622193;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UpgysnHal32qYVrcZInZLHo993FysfJZXzowtgLKH6o=;
	b=f8nlLe2qgaXPvJpr8DIdi7cR04/i7WKlKcEnyWrVqwQ1SFmGpv0cwev5Sd2sw0vSTWBs
	 csokoaHI8uLe7vloQ1wfbSHrmIwiT48qElj9h+Bds0my/nl9NM8qA44EbHsh+Z/q4sVcX
	 ho/jMeekUKU9aaWl9p78WZSoHlM4VixoizuBmZPJfM6GmmsSo8chCeymNLB4s8rxH6CL7
	 ejXUWtyEZdxlyktyCa2XQpeishAI4EHAni6E2umfo09hsaCLtS/p9sIS5DBCNOBCv2vuD
	 SaWNyAjtZnxtocnENgYMLUfMxifzhwAVHvNpjPubUQKEaqBIVq7E77XBW+BblXLKzWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SAQlbTPa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F1A606A327;
	Wed, 25 Nov 2026 15:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SAQlbTPa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4F921F000D1;
	Wed, 25 Nov 2026 15:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622193;
	bh=UpgysnHal32qYVrcZInZLHo993FysfJZXzowtgLKH6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SAQlbTPauuPDQjZ+N+Uc2DZ7efMgzABC8tx6cS7ZWUHBku2BcrHxwxgbzXQgxJW0d
	 WxY++sJIJ5pBXECcDFx3IHukGq7Hm+sc/9GsnfL0qcuWfjszKq/uGTWUYuC19ht8NN
	 1tvwrGS4r6gdxi3QSfRjPaTq3x4HJr9DuDTUNT9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Riana Tauro <riana.tauro@intel.com>,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	Vinay Belgaumkar <vinay.belgaumkar@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 460/990] drm/xe: Add a wrapper for SLPC set/unset params
Date: Wed, 25 Nov 2026 15:30:27 +0100
Message-ID: <20261125143832.871231670@linuxfoundation.org>
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

From: Vinay Belgaumkar <vinay.belgaumkar@intel.com>

[ Upstream commit fabedb758fcb16fcd80230c28356f8aaff972446 ]

Also, extract out the GuC RC related set/unset param functions
into xe_guc_rc file. GuC still allows us to override GuC RC mode
using an SLPC H2G interface. Continue to use that interface, but
move the related code to the newly created xe_guc_rc file.

Cc: Riana Tauro <riana.tauro@intel.com>
Cc: Michal Wajdeczko <michal.wajdeczko@intel.com>
Reviewed-by: Riana Tauro <riana.tauro@intel.com>
Reviewed-by: Michal Wajdeczko <michal.wajdeczko@intel.com>
Signed-off-by: Vinay Belgaumkar <vinay.belgaumkar@intel.com>
Link: https://patch.msgid.link/20260204014234.2867763-4-vinay.belgaumkar@intel.com
Stable-dep-of: 557c7b434378 ("drm/xe: Sync Wa_16023105232 in xe_was to match OOB rule")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_guc_pc.c | 56 +++++++++++++++++++---------------
 drivers/gpu/drm/xe/xe_guc_pc.h |  5 ++-
 drivers/gpu/drm/xe/xe_guc_rc.c | 30 ++++++++++++++++++
 drivers/gpu/drm/xe/xe_guc_rc.h |  3 ++
 drivers/gpu/drm/xe/xe_oa.c     |  9 +++---
 5 files changed, 70 insertions(+), 33 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_guc_pc.c b/drivers/gpu/drm/xe/xe_guc_pc.c
index 47281c46f0631..da2661e46f12b 100644
--- a/drivers/gpu/drm/xe/xe_guc_pc.c
+++ b/drivers/gpu/drm/xe/xe_guc_pc.c
@@ -281,6 +281,37 @@ static int pc_action_unset_param(struct xe_guc_pc *pc, u8 id)
 	return ret;
 }
 
+/**
+ * xe_guc_pc_action_set_param() - Set value of SLPC param
+ * @pc: Xe_GuC_PC instance
+ * @id: Param id
+ * @value: Value to set
+ *
+ * This function can be used to set any SLPC param.
+ *
+ * Return: 0 on Success
+ */
+int xe_guc_pc_action_set_param(struct xe_guc_pc *pc, u8 id, u32 value)
+{
+	xe_device_assert_mem_access(pc_to_xe(pc));
+	return pc_action_set_param(pc, id, value);
+}
+
+/**
+ * xe_guc_pc_action_unset_param() - Revert to default value
+ * @pc: Xe_GuC_PC instance
+ * @id: Param id
+ *
+ * This function can be used revert any SLPC param to its default value.
+ *
+ * Return: 0 on Success
+ */
+int xe_guc_pc_action_unset_param(struct xe_guc_pc *pc, u8 id)
+{
+	xe_device_assert_mem_access(pc_to_xe(pc));
+	return pc_action_unset_param(pc, id);
+}
+
 static u32 decode_freq(u32 raw)
 {
 	return DIV_ROUND_CLOSEST(raw * GT_FREQUENCY_MULTIPLIER,
@@ -1063,31 +1094,6 @@ int xe_guc_pc_restore_stashed_freq(struct xe_guc_pc *pc)
 	return ret;
 }
 
-/**
- * xe_guc_pc_override_gucrc_mode - override GUCRC mode
- * @pc: Xe_GuC_PC instance
- * @mode: new value of the mode.
- *
- * Return: 0 on success, negative error code on error
- */
-int xe_guc_pc_override_gucrc_mode(struct xe_guc_pc *pc, enum slpc_gucrc_mode mode)
-{
-	guard(xe_pm_runtime)(pc_to_xe(pc));
-	return pc_action_set_param(pc, SLPC_PARAM_PWRGATE_RC_MODE, mode);
-}
-
-/**
- * xe_guc_pc_unset_gucrc_mode - unset GUCRC mode override
- * @pc: Xe_GuC_PC instance
- *
- * Return: 0 on success, negative error code on error
- */
-int xe_guc_pc_unset_gucrc_mode(struct xe_guc_pc *pc)
-{
-	guard(xe_pm_runtime)(pc_to_xe(pc));
-	return pc_action_unset_param(pc, SLPC_PARAM_PWRGATE_RC_MODE);
-}
-
 static void pc_init_pcode_freq(struct xe_guc_pc *pc)
 {
 	u32 min = DIV_ROUND_CLOSEST(pc->rpn_freq, GT_FREQUENCY_MULTIPLIER);
diff --git a/drivers/gpu/drm/xe/xe_guc_pc.h b/drivers/gpu/drm/xe/xe_guc_pc.h
index 1b95873b262e3..0678a4e787b3f 100644
--- a/drivers/gpu/drm/xe/xe_guc_pc.h
+++ b/drivers/gpu/drm/xe/xe_guc_pc.h
@@ -9,15 +9,14 @@
 #include <linux/types.h>
 
 struct xe_guc_pc;
-enum slpc_gucrc_mode;
 struct drm_printer;
 
 int xe_guc_pc_init(struct xe_guc_pc *pc);
 int xe_guc_pc_start(struct xe_guc_pc *pc);
 int xe_guc_pc_stop(struct xe_guc_pc *pc);
-int xe_guc_pc_override_gucrc_mode(struct xe_guc_pc *pc, enum slpc_gucrc_mode mode);
-int xe_guc_pc_unset_gucrc_mode(struct xe_guc_pc *pc);
 void xe_guc_pc_print(struct xe_guc_pc *pc, struct drm_printer *p);
+int xe_guc_pc_action_set_param(struct xe_guc_pc *pc, u8 id, u32 value);
+int xe_guc_pc_action_unset_param(struct xe_guc_pc *pc, u8 id);
 
 u32 xe_guc_pc_get_act_freq(struct xe_guc_pc *pc);
 int xe_guc_pc_get_cur_freq(struct xe_guc_pc *pc, u32 *freq);
diff --git a/drivers/gpu/drm/xe/xe_guc_rc.c b/drivers/gpu/drm/xe/xe_guc_rc.c
index 6c4591e712d9d..427a889b2a1e0 100644
--- a/drivers/gpu/drm/xe/xe_guc_rc.c
+++ b/drivers/gpu/drm/xe/xe_guc_rc.c
@@ -13,6 +13,7 @@
 #include "xe_gt_printk.h"
 #include "xe_guc.h"
 #include "xe_guc_ct.h"
+#include "xe_guc_pc.h"
 #include "xe_guc_rc.h"
 #include "xe_pm.h"
 
@@ -128,3 +129,32 @@ int xe_guc_rc_enable(struct xe_guc *guc)
 
 	return guc_action_setup_gucrc(guc, GUCRC_FIRMWARE_CONTROL);
 }
+
+/**
+ * xe_guc_rc_set_mode() - set new GUCRC mode
+ * @guc: Xe GuC instance
+ * @mode: new value of the mode.
+ *
+ * Function to set GuC RC mode to one of the enum values.
+ *
+ * Returns: 0 on success, negative error code on error
+ */
+int xe_guc_rc_set_mode(struct xe_guc *guc, enum slpc_gucrc_mode mode)
+{
+	guard(xe_pm_runtime_noresume)(guc_to_xe(guc));
+	return xe_guc_pc_action_set_param(&guc->pc, SLPC_PARAM_PWRGATE_RC_MODE, mode);
+}
+
+/**
+ * xe_guc_rc_unset_mode() - revert to default mode
+ * @guc: Xe GuC instance
+ *
+ * Function to revert GuC RC mode to platform defaults.
+ *
+ * Returns: 0 on success, negative error code on error
+ */
+int xe_guc_rc_unset_mode(struct xe_guc *guc)
+{
+	guard(xe_pm_runtime_noresume)(guc_to_xe(guc));
+	return xe_guc_pc_action_unset_param(&guc->pc, SLPC_PARAM_PWRGATE_RC_MODE);
+}
diff --git a/drivers/gpu/drm/xe/xe_guc_rc.h b/drivers/gpu/drm/xe/xe_guc_rc.h
index 2e7e15e2be506..f1f949e7ecc0c 100644
--- a/drivers/gpu/drm/xe/xe_guc_rc.h
+++ b/drivers/gpu/drm/xe/xe_guc_rc.h
@@ -7,9 +7,12 @@
 #define _XE_GUC_RC_H_
 
 struct xe_guc;
+enum slpc_gucrc_mode;
 
 int xe_guc_rc_init(struct xe_guc *guc);
 int xe_guc_rc_enable(struct xe_guc *guc);
 void xe_guc_rc_disable(struct xe_guc *guc);
+int xe_guc_rc_set_mode(struct xe_guc *guc, enum slpc_gucrc_mode mode);
+int xe_guc_rc_unset_mode(struct xe_guc *guc);
 
 #endif
diff --git a/drivers/gpu/drm/xe/xe_oa.c b/drivers/gpu/drm/xe/xe_oa.c
index b88d3d39aea66..905c7eae6413c 100644
--- a/drivers/gpu/drm/xe/xe_oa.c
+++ b/drivers/gpu/drm/xe/xe_oa.c
@@ -29,7 +29,7 @@
 #include "xe_gt.h"
 #include "xe_gt_mcr.h"
 #include "xe_gt_printk.h"
-#include "xe_guc_pc.h"
+#include "xe_guc_rc.h"
 #include "xe_macros.h"
 #include "xe_mmio.h"
 #include "xe_oa.h"
@@ -877,7 +877,7 @@ static void xe_oa_stream_destroy(struct xe_oa_stream *stream)
 
 	/* Wa_1509372804:pvc: Unset the override of GUCRC mode to enable rc6 */
 	if (stream->override_gucrc)
-		xe_gt_WARN_ON(gt, xe_guc_pc_unset_gucrc_mode(&gt->uc.guc.pc));
+		xe_gt_WARN_ON(gt, xe_guc_rc_unset_mode(&gt->uc.guc));
 
 	xe_oa_free_configs(stream);
 	xe_file_put(stream->xef);
@@ -1783,8 +1783,7 @@ static int xe_oa_stream_init(struct xe_oa_stream *stream,
 	 * state. Prevent this by overriding GUCRC mode.
 	 */
 	if (XE_GT_WA(stream->gt, 1509372804)) {
-		ret = xe_guc_pc_override_gucrc_mode(&gt->uc.guc.pc,
-						    SLPC_GUCRC_MODE_GUCRC_NO_RC6);
+		ret = xe_guc_rc_set_mode(&gt->uc.guc, SLPC_GUCRC_MODE_GUCRC_NO_RC6);
 		if (ret)
 			goto err_free_configs;
 
@@ -1842,7 +1841,7 @@ static int xe_oa_stream_init(struct xe_oa_stream *stream,
 	xe_force_wake_put(gt_to_fw(gt), fw_ref);
 	xe_pm_runtime_put(stream->oa->xe);
 	if (stream->override_gucrc)
-		xe_gt_WARN_ON(gt, xe_guc_pc_unset_gucrc_mode(&gt->uc.guc.pc));
+		xe_gt_WARN_ON(gt, xe_guc_rc_unset_mode(&gt->uc.guc));
 err_free_configs:
 	xe_oa_free_configs(stream);
 exit:
-- 
2.53.0




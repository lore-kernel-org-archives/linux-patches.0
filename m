Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 075A42528E4;
	Tue, 29 Apr 2025 16:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945726; cv=none; b=EFzD2etKio6ucIGI8Huq7m1AdE8SwKSn0txtMzWSeobZsoAHIHb2jDfYKu8+gYGI5kCQ2AgdUzc3FA02XGWKfySw/QIMR5Wa484vQRrj54zBh7A819EOf/ac1xmM5DVftdVoFJ1+JxE8dRbcrtnnAsrN35xQD38r7PpmFQmeQ+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945726; c=relaxed/simple;
	bh=FrMp5FzOZs4cKNy+sG4++gKqvp5dxqvyJFhKcouyJOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lef9MoVeTe9Q6xwCv8iDnbg7tchVy57xQUkvY06XmV8a/ppnd4BrKTp3mtGMgQfzH5ucwIgxeYrcfVdsiWJjrokkMr1O1Hg2nPwCbDt1BV/EgLBVa9o2++xBYTrJNCyoVcM19MZkQ/CJzNTz+pJKhI+GYdMDAQZpCc8uDDkkskI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W6ecHIGz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W6ecHIGz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C9A3C4CEE9;
	Tue, 29 Apr 2025 16:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945725;
	bh=FrMp5FzOZs4cKNy+sG4++gKqvp5dxqvyJFhKcouyJOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W6ecHIGzC0zwfj+lWwGCHT13HgbQaVcQN1VclIGUAA1MpNTNQ6jNGyh9vonLap/w7
	 DwZrR/vlpssxjNHU85M45yzabmN32REWLX+ktO8yJGOBFQ2VTER8+mAKf4H7z0ee01
	 ThuNbVSxiSXIe3JqIZLiyNrrKKr5Aa/s7A4cSCb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 029/311] drm/xe: Add performance tunings to debugfs
Date: Tue, 29 Apr 2025 18:37:46 +0200
Message-ID: <20250429161122.231114162@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>

[ Upstream commit 067a974fd8a9ea43f97ca184e2768b583f2f8c44 ]

Add a list of active tunings to debugfs, analogous to the existing
list of workarounds.

Rationale being that it seems to make sense to either have both or none.

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Cc: Matt Roper <matthew.d.roper@intel.com>
Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250227101304.46660-6-tvrtko.ursulin@igalia.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Stable-dep-of: 262de94a3a7e ("drm/xe: Ensure fixed_slice_mode gets set after ccs_mode change")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_gt.c         |  4 ++
 drivers/gpu/drm/xe/xe_gt_debugfs.c | 11 ++++++
 drivers/gpu/drm/xe/xe_gt_types.h   | 10 +++++
 drivers/gpu/drm/xe/xe_tuning.c     | 59 ++++++++++++++++++++++++++++++
 drivers/gpu/drm/xe/xe_tuning.h     |  3 ++
 5 files changed, 87 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_gt.c b/drivers/gpu/drm/xe/xe_gt.c
index 8a20e6744836c..94eed1315b0f1 100644
--- a/drivers/gpu/drm/xe/xe_gt.c
+++ b/drivers/gpu/drm/xe/xe_gt.c
@@ -381,6 +381,10 @@ int xe_gt_init_early(struct xe_gt *gt)
 	if (err)
 		return err;
 
+	err = xe_tuning_init(gt);
+	if (err)
+		return err;
+
 	xe_wa_process_oob(gt);
 
 	xe_force_wake_init_gt(gt, gt_to_fw(gt));
diff --git a/drivers/gpu/drm/xe/xe_gt_debugfs.c b/drivers/gpu/drm/xe/xe_gt_debugfs.c
index e7792858b1e46..2d63a69cbfa38 100644
--- a/drivers/gpu/drm/xe/xe_gt_debugfs.c
+++ b/drivers/gpu/drm/xe/xe_gt_debugfs.c
@@ -30,6 +30,7 @@
 #include "xe_reg_sr.h"
 #include "xe_reg_whitelist.h"
 #include "xe_sriov.h"
+#include "xe_tuning.h"
 #include "xe_uc_debugfs.h"
 #include "xe_wa.h"
 
@@ -217,6 +218,15 @@ static int workarounds(struct xe_gt *gt, struct drm_printer *p)
 	return 0;
 }
 
+static int tunings(struct xe_gt *gt, struct drm_printer *p)
+{
+	xe_pm_runtime_get(gt_to_xe(gt));
+	xe_tuning_dump(gt, p);
+	xe_pm_runtime_put(gt_to_xe(gt));
+
+	return 0;
+}
+
 static int pat(struct xe_gt *gt, struct drm_printer *p)
 {
 	xe_pm_runtime_get(gt_to_xe(gt));
@@ -300,6 +310,7 @@ static const struct drm_info_list debugfs_list[] = {
 	{"powergate_info", .show = xe_gt_debugfs_simple_show, .data = powergate_info},
 	{"register-save-restore", .show = xe_gt_debugfs_simple_show, .data = register_save_restore},
 	{"workarounds", .show = xe_gt_debugfs_simple_show, .data = workarounds},
+	{"tunings", .show = xe_gt_debugfs_simple_show, .data = tunings},
 	{"pat", .show = xe_gt_debugfs_simple_show, .data = pat},
 	{"mocs", .show = xe_gt_debugfs_simple_show, .data = mocs},
 	{"default_lrc_rcs", .show = xe_gt_debugfs_simple_show, .data = rcs_default_lrc},
diff --git a/drivers/gpu/drm/xe/xe_gt_types.h b/drivers/gpu/drm/xe/xe_gt_types.h
index 6e66bf0e8b3f7..dd2969a1846dd 100644
--- a/drivers/gpu/drm/xe/xe_gt_types.h
+++ b/drivers/gpu/drm/xe/xe_gt_types.h
@@ -413,6 +413,16 @@ struct xe_gt {
 		bool oob_initialized;
 	} wa_active;
 
+	/** @tuning_active: keep track of active tunings */
+	struct {
+		/** @tuning_active.gt: bitmap with active GT tunings */
+		unsigned long *gt;
+		/** @tuning_active.engine: bitmap with active engine tunings */
+		unsigned long *engine;
+		/** @tuning_active.lrc: bitmap with active LRC tunings */
+		unsigned long *lrc;
+	} tuning_active;
+
 	/** @user_engines: engines present in GT and available to userspace */
 	struct {
 		/**
diff --git a/drivers/gpu/drm/xe/xe_tuning.c b/drivers/gpu/drm/xe/xe_tuning.c
index 3c78f3d715591..23c46dd85e149 100644
--- a/drivers/gpu/drm/xe/xe_tuning.c
+++ b/drivers/gpu/drm/xe/xe_tuning.c
@@ -7,6 +7,8 @@
 
 #include <kunit/visibility.h>
 
+#include <drm/drm_managed.h>
+
 #include "regs/xe_gt_regs.h"
 #include "xe_gt_types.h"
 #include "xe_platform_types.h"
@@ -135,10 +137,44 @@ static const struct xe_rtp_entry_sr lrc_tunings[] = {
 	{}
 };
 
+/**
+ * xe_tuning_init - initialize gt with tunings bookkeeping
+ * @gt: GT instance to initialize
+ *
+ * Returns 0 for success, negative error code otherwise.
+ */
+int xe_tuning_init(struct xe_gt *gt)
+{
+	struct xe_device *xe = gt_to_xe(gt);
+	size_t n_lrc, n_engine, n_gt, total;
+	unsigned long *p;
+
+	n_gt = BITS_TO_LONGS(ARRAY_SIZE(gt_tunings));
+	n_engine = BITS_TO_LONGS(ARRAY_SIZE(engine_tunings));
+	n_lrc = BITS_TO_LONGS(ARRAY_SIZE(lrc_tunings));
+	total = n_gt + n_engine + n_lrc;
+
+	p = drmm_kzalloc(&xe->drm, sizeof(*p) * total, GFP_KERNEL);
+	if (!p)
+		return -ENOMEM;
+
+	gt->tuning_active.gt = p;
+	p += n_gt;
+	gt->tuning_active.engine = p;
+	p += n_engine;
+	gt->tuning_active.lrc = p;
+
+	return 0;
+}
+ALLOW_ERROR_INJECTION(xe_tuning_init, ERRNO); /* See xe_pci_probe() */
+
 void xe_tuning_process_gt(struct xe_gt *gt)
 {
 	struct xe_rtp_process_ctx ctx = XE_RTP_PROCESS_CTX_INITIALIZER(gt);
 
+	xe_rtp_process_ctx_enable_active_tracking(&ctx,
+						  gt->tuning_active.gt,
+						  ARRAY_SIZE(gt_tunings));
 	xe_rtp_process_to_sr(&ctx, gt_tunings, &gt->reg_sr);
 }
 EXPORT_SYMBOL_IF_KUNIT(xe_tuning_process_gt);
@@ -147,6 +183,9 @@ void xe_tuning_process_engine(struct xe_hw_engine *hwe)
 {
 	struct xe_rtp_process_ctx ctx = XE_RTP_PROCESS_CTX_INITIALIZER(hwe);
 
+	xe_rtp_process_ctx_enable_active_tracking(&ctx,
+						  hwe->gt->tuning_active.engine,
+						  ARRAY_SIZE(engine_tunings));
 	xe_rtp_process_to_sr(&ctx, engine_tunings, &hwe->reg_sr);
 }
 EXPORT_SYMBOL_IF_KUNIT(xe_tuning_process_engine);
@@ -163,5 +202,25 @@ void xe_tuning_process_lrc(struct xe_hw_engine *hwe)
 {
 	struct xe_rtp_process_ctx ctx = XE_RTP_PROCESS_CTX_INITIALIZER(hwe);
 
+	xe_rtp_process_ctx_enable_active_tracking(&ctx,
+						  hwe->gt->tuning_active.lrc,
+						  ARRAY_SIZE(lrc_tunings));
 	xe_rtp_process_to_sr(&ctx, lrc_tunings, &hwe->reg_lrc);
 }
+
+void xe_tuning_dump(struct xe_gt *gt, struct drm_printer *p)
+{
+	size_t idx;
+
+	drm_printf(p, "GT Tunings\n");
+	for_each_set_bit(idx, gt->tuning_active.gt, ARRAY_SIZE(gt_tunings))
+		drm_printf_indent(p, 1, "%s\n", gt_tunings[idx].name);
+
+	drm_printf(p, "\nEngine Tunings\n");
+	for_each_set_bit(idx, gt->tuning_active.engine, ARRAY_SIZE(engine_tunings))
+		drm_printf_indent(p, 1, "%s\n", engine_tunings[idx].name);
+
+	drm_printf(p, "\nLRC Tunings\n");
+	for_each_set_bit(idx, gt->tuning_active.lrc, ARRAY_SIZE(lrc_tunings))
+		drm_printf_indent(p, 1, "%s\n", lrc_tunings[idx].name);
+}
diff --git a/drivers/gpu/drm/xe/xe_tuning.h b/drivers/gpu/drm/xe/xe_tuning.h
index 4f9c3ac3b5162..dd0d3ccc9c654 100644
--- a/drivers/gpu/drm/xe/xe_tuning.h
+++ b/drivers/gpu/drm/xe/xe_tuning.h
@@ -6,11 +6,14 @@
 #ifndef _XE_TUNING_
 #define _XE_TUNING_
 
+struct drm_printer;
 struct xe_gt;
 struct xe_hw_engine;
 
+int xe_tuning_init(struct xe_gt *gt);
 void xe_tuning_process_gt(struct xe_gt *gt);
 void xe_tuning_process_engine(struct xe_hw_engine *hwe);
 void xe_tuning_process_lrc(struct xe_hw_engine *hwe);
+void xe_tuning_dump(struct xe_gt *gt, struct drm_printer *p);
 
 #endif
-- 
2.39.5




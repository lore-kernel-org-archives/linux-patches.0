Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 962EA33A702;
	Thu, 28 May 2026 20:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999066; cv=none; b=aEY9LsKQaOW7usZPdWrNYnuXYvaw+NTv0wb0OP0NR6MXiT5X0UiFBEXVeAUgAHB1bazBNrtPKJTgYkSOyTL4UVP8Hno1dzHvWbqPiJ1r/r3FVlUn9woqpYtUbeepcmWFePpRCldvElTJAHwPhgidHm5LqQmEbGKNm1lyNusb9XU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999066; c=relaxed/simple;
	bh=aH+kJbDz3hLb0XICd8cFhWIPATI6IKPux8P3YURShXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h2opvP13lX9kzkKY0HKX1bhK39PU3w5x20nKX2L8SxsEzcCVNnn6fGEf9Pcw+IDkpYpv2BBWqfly7IhMlAywT+myihxrpvz4asL+9vdtLSkOZBqHdgaoFi4VIMVWMamkUi2Lbh+KVoMQsGGvBb429Hqv5CjEMfBDk6ffymi1ZD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mKkSDtJY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mKkSDtJY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA4D21F000E9;
	Thu, 28 May 2026 20:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999065;
	bh=oRi+xa2J00+5XhJrSV0Ri9YJjLMILbdaqQCl4cp73xc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mKkSDtJYQThWyxAufP8gHDPGc8Bgh32Y0bxsLOU9YwsGEX1tAWwlbtNOxEosGhATL
	 FMAGD39hkfuid2ajecht8qciah4mlokUzaW1rBdhmwKxTDrM7LHqQR0MwGORYrG0aA
	 2CJe1zxmyky79knjYTgVMeX8O2IIeBmRvl8oGC5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	Mohanram Meenakshisundaram <mohanram.meenakshisundaram@intel.com>,
	Shuicheng Lin <shuicheng.lin@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 360/461] drm/xe/vf: Fix signature of print functions
Date: Thu, 28 May 2026 21:48:09 +0200
Message-ID: <20260528194657.848478669@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Wajdeczko <michal.wajdeczko@intel.com>

[ Upstream commit 9bb2f1d7e6e58b8e434ddc2048c661bf87ccdf2a ]

We have plugged-in existing VF print functions into our GT debugfs
show helper as-is, but we missed that the helper expects functions
to return int, while they were defined as void. This can lead to
errors being reported when CFI is enabled.

Fixes: 63d8cb8fe3dd ("drm/xe/vf: Expose SR-IOV VF attributes to GT debugfs")
Signed-off-by: Michal Wajdeczko <michal.wajdeczko@intel.com>
Cc: Mohanram Meenakshisundaram <mohanram.meenakshisundaram@intel.com>
Reviewed-by: Shuicheng Lin <shuicheng.lin@intel.com>
Link: https://patch.msgid.link/20260514155726.7165-1-michal.wajdeczko@intel.com
(cherry picked from commit 314e31c9a8a1c421ee4f7f755b9348aefbbca090)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_gt_sriov_vf.c | 24 ++++++++++++++++++------
 drivers/gpu/drm/xe/xe_gt_sriov_vf.h |  6 +++---
 2 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_gt_sriov_vf.c b/drivers/gpu/drm/xe/xe_gt_sriov_vf.c
index 30e8c2cf5f09a..82703a25e96d9 100644
--- a/drivers/gpu/drm/xe/xe_gt_sriov_vf.c
+++ b/drivers/gpu/drm/xe/xe_gt_sriov_vf.c
@@ -1129,13 +1129,15 @@ void xe_gt_sriov_vf_write32(struct xe_gt *gt, struct xe_reg reg, u32 val)
 }
 
 /**
- * xe_gt_sriov_vf_print_config - Print VF self config.
+ * xe_gt_sriov_vf_print_config() - Print VF self config.
  * @gt: the &xe_gt
  * @p: the &drm_printer
  *
  * This function is for VF use only.
+ *
+ * Return: always 0.
  */
-void xe_gt_sriov_vf_print_config(struct xe_gt *gt, struct drm_printer *p)
+int xe_gt_sriov_vf_print_config(struct xe_gt *gt, struct drm_printer *p)
 {
 	struct xe_gt_sriov_vf_selfconfig *config = &gt->sriov.vf.self_config;
 	struct xe_device *xe = gt_to_xe(gt);
@@ -1162,16 +1164,20 @@ void xe_gt_sriov_vf_print_config(struct xe_gt *gt, struct drm_printer *p)
 
 	drm_printf(p, "GuC contexts:\t%u\n", config->num_ctxs);
 	drm_printf(p, "GuC doorbells:\t%u\n", config->num_dbs);
+
+	return 0;
 }
 
 /**
- * xe_gt_sriov_vf_print_runtime - Print VF's runtime regs received from PF.
+ * xe_gt_sriov_vf_print_runtime() - Print VF's runtime regs received from PF.
  * @gt: the &xe_gt
  * @p: the &drm_printer
  *
  * This function is for VF use only.
+ *
+ * Return: always 0.
  */
-void xe_gt_sriov_vf_print_runtime(struct xe_gt *gt, struct drm_printer *p)
+int xe_gt_sriov_vf_print_runtime(struct xe_gt *gt, struct drm_printer *p)
 {
 	struct vf_runtime_reg *vf_regs = gt->sriov.vf.runtime.regs;
 	unsigned int size = gt->sriov.vf.runtime.num_regs;
@@ -1180,16 +1186,20 @@ void xe_gt_sriov_vf_print_runtime(struct xe_gt *gt, struct drm_printer *p)
 
 	for (; size--; vf_regs++)
 		drm_printf(p, "%#x = %#x\n", vf_regs->offset, vf_regs->value);
+
+	return 0;
 }
 
 /**
- * xe_gt_sriov_vf_print_version - Print VF ABI versions.
+ * xe_gt_sriov_vf_print_version() - Print VF ABI versions.
  * @gt: the &xe_gt
  * @p: the &drm_printer
  *
  * This function is for VF use only.
+ *
+ * Return: always 0.
  */
-void xe_gt_sriov_vf_print_version(struct xe_gt *gt, struct drm_printer *p)
+int xe_gt_sriov_vf_print_version(struct xe_gt *gt, struct drm_printer *p)
 {
 	struct xe_device *xe = gt_to_xe(gt);
 	struct xe_uc_fw_version *guc_version = &gt->sriov.vf.guc_version;
@@ -1219,6 +1229,8 @@ void xe_gt_sriov_vf_print_version(struct xe_gt *gt, struct drm_printer *p)
 		   GUC_RELAY_VERSION_LATEST_MAJOR, GUC_RELAY_VERSION_LATEST_MINOR);
 	drm_printf(p, "\thandshake:\t%u.%u\n",
 		   pf_version->major, pf_version->minor);
+
+	return 0;
 }
 
 static bool vf_post_migration_shutdown(struct xe_gt *gt)
diff --git a/drivers/gpu/drm/xe/xe_gt_sriov_vf.h b/drivers/gpu/drm/xe/xe_gt_sriov_vf.h
index 7d97189c2d3d9..4f1c7aa422e7b 100644
--- a/drivers/gpu/drm/xe/xe_gt_sriov_vf.h
+++ b/drivers/gpu/drm/xe/xe_gt_sriov_vf.h
@@ -35,9 +35,9 @@ bool xe_gt_sriov_vf_sched_groups_enabled(struct xe_gt *gt);
 u32 xe_gt_sriov_vf_read32(struct xe_gt *gt, struct xe_reg reg);
 void xe_gt_sriov_vf_write32(struct xe_gt *gt, struct xe_reg reg, u32 val);
 
-void xe_gt_sriov_vf_print_config(struct xe_gt *gt, struct drm_printer *p);
-void xe_gt_sriov_vf_print_runtime(struct xe_gt *gt, struct drm_printer *p);
-void xe_gt_sriov_vf_print_version(struct xe_gt *gt, struct drm_printer *p);
+int xe_gt_sriov_vf_print_config(struct xe_gt *gt, struct drm_printer *p);
+int xe_gt_sriov_vf_print_runtime(struct xe_gt *gt, struct drm_printer *p);
+int xe_gt_sriov_vf_print_version(struct xe_gt *gt, struct drm_printer *p);
 
 void xe_gt_sriov_vf_wait_valid_ggtt(struct xe_gt *gt);
 
-- 
2.53.0




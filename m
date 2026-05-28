Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65D7025F7B9;
	Thu, 28 May 2026 20:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000244; cv=none; b=Dp8S0DY5TO+pU1GsC3EAdv8vS9+PZnUj6UsAJtokfv7YQUJFSwN9tVg7VGpTpfWGI5RNjuydZQK/aAYdzguZ2aQDqQf5Vjt/2mSsRXXJ7CDWDbF+/04+hwaxLYSFjZTFvuhslep4fi0b+u+CYxIil8s2lClqyEToTLlyKalILKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000244; c=relaxed/simple;
	bh=ibmaIlaCDbL8FRESqkTWUSJp2Sx39U3U/HH/Zyef+aw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fp8NV5PBFMjPkHXz16WYnAL9dkqN7n4Tn6TOtMVSvIstxVWL9cJ9IldVIyLvyWReclKKg7+WujBgx1Xk1X8ekSF/uTcZrrniHJQLYyiY+M64aNti9o5puXxHzXmLCf6UYOb3wLpoUxsdgjxFncT4cjY3W7R27QEDEPEbcLkHQe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rroxGYAB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rroxGYAB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C46321F000E9;
	Thu, 28 May 2026 20:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000243;
	bh=LRiHtIn5oKzx1Gw8YoTuQOko6Q/DTaiB2q0qDmANaBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rroxGYABFzg0CoUVorrwzJIaeDXewEQ6yDRsDGTO2KT5VWfRaGokRxpqKFmA1/Mz5
	 ME5SXntIvvlmBhwjd45Ev07o0DjKwcBAWBNRDR0Oc4Y2ZEtrXanpaQekJURDsxiCLC
	 uXcsREEmRmKEhs9F/9+7EwGrmx98iGtlZ6QsuDLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	Mohanram Meenakshisundaram <mohanram.meenakshisundaram@intel.com>,
	Shuicheng Lin <shuicheng.lin@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 316/377] drm/xe/vf: Fix signature of print functions
Date: Thu, 28 May 2026 21:49:14 +0200
Message-ID: <20260528194647.542398166@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 0461d55134874..ca58ef3f9fd39 100644
--- a/drivers/gpu/drm/xe/xe_gt_sriov_vf.c
+++ b/drivers/gpu/drm/xe/xe_gt_sriov_vf.c
@@ -1030,13 +1030,15 @@ void xe_gt_sriov_vf_write32(struct xe_gt *gt, struct xe_reg reg, u32 val)
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
@@ -1060,16 +1062,20 @@ void xe_gt_sriov_vf_print_config(struct xe_gt *gt, struct drm_printer *p)
 
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
@@ -1078,16 +1084,20 @@ void xe_gt_sriov_vf_print_runtime(struct xe_gt *gt, struct drm_printer *p)
 
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
@@ -1117,4 +1127,6 @@ void xe_gt_sriov_vf_print_version(struct xe_gt *gt, struct drm_printer *p)
 		   GUC_RELAY_VERSION_LATEST_MAJOR, GUC_RELAY_VERSION_LATEST_MINOR);
 	drm_printf(p, "\thandshake:\t%u.%u\n",
 		   pf_version->major, pf_version->minor);
+
+	return 0;
 }
diff --git a/drivers/gpu/drm/xe/xe_gt_sriov_vf.h b/drivers/gpu/drm/xe/xe_gt_sriov_vf.h
index 0af1dc769fe09..7f6c59b1ef7b6 100644
--- a/drivers/gpu/drm/xe/xe_gt_sriov_vf.h
+++ b/drivers/gpu/drm/xe/xe_gt_sriov_vf.h
@@ -35,8 +35,8 @@ s64 xe_gt_sriov_vf_ggtt_shift(struct xe_gt *gt);
 u32 xe_gt_sriov_vf_read32(struct xe_gt *gt, struct xe_reg reg);
 void xe_gt_sriov_vf_write32(struct xe_gt *gt, struct xe_reg reg, u32 val);
 
-void xe_gt_sriov_vf_print_config(struct xe_gt *gt, struct drm_printer *p);
-void xe_gt_sriov_vf_print_runtime(struct xe_gt *gt, struct drm_printer *p);
-void xe_gt_sriov_vf_print_version(struct xe_gt *gt, struct drm_printer *p);
+int xe_gt_sriov_vf_print_config(struct xe_gt *gt, struct drm_printer *p);
+int xe_gt_sriov_vf_print_runtime(struct xe_gt *gt, struct drm_printer *p);
+int xe_gt_sriov_vf_print_version(struct xe_gt *gt, struct drm_printer *p);
 
 #endif
-- 
2.53.0




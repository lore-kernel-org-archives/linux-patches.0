Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622323;
	b=E04XUZdTkNDo5rh7YwoJSBcDK09Xg5LA4jYiSIc2j2K7tLghFnIqKoqH51r8jBRs94UD
	 GMSt7YISGI8n/3agSufKa+c6qV0OfTSYa8N2dAJwyJzr6W+AyZumvb4Y6r+oaNQWHTjyg
	 3IEGgLS/5atQznB31+kVa3sWe1Ih8+EC1flEWmHbLkWgHSRsbfLxgdgr4rZybzc1+InFa
	 bkmeHTCmJ+833DEfEk/MUuuDLgHgohvZHfnhn3gmdt0kLD6gnreiytkkcuR2HNebvq1Nu
	 D85qsKySgrjw0kxzdkTs4TEsV+Km7GK9kI95/fv9n/ZXl2OwsSO0XV0S+khvou9ZGPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622323;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=G57U9cCrCGDuepfptGlTLijDst3jA+55gNLnCO6SsE0=;
	b=VGVwwMhbPh1jcKVYZAVi9NOG5pXPYSbMMHq2ud+EVmxiKEwZn1VkpaS7FhjpvNkZGGVo
	 9bLMxqepDV2edrjQ973C2CXD0IkuMUkC+1x2k7LFKI/AJCnfBq1fh8NDpg9CT+ZMY5x8A
	 5fGY0ejtmVdd/nHLbYu/Gx0rfVadd57eQz+qquDzg+CS796jUPimofXE8W1FwLmsBxpD5
	 mcsUdsBz4qFqExEq2w5Np2cGgNDk92D2lBD/8VUWgsT0fSp/5ZhC6EKBosSMfnJBWsWk2
	 hjlnDIejZxL5HPiAEWiX0EsfmrSWLJDJ2iHrBVEe2Bjd9aAbIPt2Onxsh1aQErtM6Zw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2NpRRakz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B4B5606A691;
	Wed, 25 Nov 2026 15:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2NpRRakz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DEB21F000E0;
	Wed, 25 Nov 2026 15:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622323;
	bh=G57U9cCrCGDuepfptGlTLijDst3jA+55gNLnCO6SsE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2NpRRakzLCAGVgnTwPFbabXFr+A92ar6zr+4i/FLugRr0WqYiy7tRo8xQiEOIeBsF
	 k+ukkvv/9FAPCPhgJHACJ3lE5URGduShRR5ajLIBFDmwzRcjQfOf/SQfA+31J6zSgL
	 9aRyo7673RCb5rHW2C/nxU4TOKZ2/JPOr3MXbzus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sk Anirban <sk.anirban@intel.com>,
	Vinay Belgaumkar <vinay.belgaumkar@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 456/990] drm/xe/guc: Eliminate RPe caching for SLPC parameter handling
Date: Wed, 25 Nov 2026 15:30:23 +0100
Message-ID: <20261125143832.776354227@linuxfoundation.org>
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

From: Sk Anirban <sk.anirban@intel.com>

[ Upstream commit 2917e17b5fd25447a702e79f4ecba3e3b3e08d58 ]

RPe is runtime-determined by PCODE and caching it caused stale values,
leading to incorrect GuC SLPC parameter settings.
Drop the cached rpe_freq field and query fresh values from hardware
on each use to ensure GuC SLPC parameters reflect current RPe.

v2: Remove cached RPe frequency field (Rodrigo)
v3: Remove extra variable (Vinay)
    Modify function name (Vinay)
v4: Maintain a separate function for PVC (Rodrigo)
v5: Avoid RPn update while fetching RPe frequency (Rodrigo)
v6: Split platform-specific RPe comments (Vinay)

Closes: https://gitlab.freedesktop.org/drm/xe/kernel/-/issues/5166
Signed-off-by: Sk Anirban <sk.anirban@intel.com>
Reviewed-by: Vinay Belgaumkar <vinay.belgaumkar@intel.com>
Link: https://patch.msgid.link/20251112185153.3593145-5-sk.anirban@intel.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Stable-dep-of: 557c7b434378 ("drm/xe: Sync Wa_16023105232 in xe_was to match OOB rule")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_guc_pc.c       | 61 +++++++++++++++-------------
 drivers/gpu/drm/xe/xe_guc_pc_types.h |  2 -
 2 files changed, 32 insertions(+), 31 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_guc_pc.c b/drivers/gpu/drm/xe/xe_guc_pc.c
index a3e9796e6430f..e41d97263eb62 100644
--- a/drivers/gpu/drm/xe/xe_guc_pc.c
+++ b/drivers/gpu/drm/xe/xe_guc_pc.c
@@ -348,7 +348,7 @@ static int pc_set_min_freq(struct xe_guc_pc *pc, u32 freq)
 	 * Our goal is to have the admin choices respected.
 	 */
 	pc_action_set_param(pc, SLPC_PARAM_IGNORE_EFFICIENT_FREQUENCY,
-			    freq < pc->rpe_freq);
+			    freq < xe_guc_pc_get_rpe_freq(pc));
 
 	return pc_action_set_param(pc,
 				   SLPC_PARAM_GLOBAL_MIN_GT_UNSLICE_FREQ_MHZ,
@@ -393,7 +393,7 @@ static void mtl_update_rpa_value(struct xe_guc_pc *pc)
 	pc->rpa_freq = decode_freq(REG_FIELD_GET(MTL_RPA_MASK, reg));
 }
 
-static void mtl_update_rpe_value(struct xe_guc_pc *pc)
+static u32 mtl_get_rpe_freq(struct xe_guc_pc *pc)
 {
 	struct xe_gt *gt = pc_to_gt(pc);
 	u32 reg;
@@ -403,7 +403,7 @@ static void mtl_update_rpe_value(struct xe_guc_pc *pc)
 	else
 		reg = xe_mmio_read32(&gt->mmio, MTL_GT_RPE_FREQUENCY);
 
-	pc->rpe_freq = decode_freq(REG_FIELD_GET(MTL_RPE_MASK, reg));
+	return decode_freq(REG_FIELD_GET(MTL_RPE_MASK, reg));
 }
 
 static void tgl_update_rpa_value(struct xe_guc_pc *pc)
@@ -426,24 +426,29 @@ static void tgl_update_rpa_value(struct xe_guc_pc *pc)
 	}
 }
 
-static void tgl_update_rpe_value(struct xe_guc_pc *pc)
+static u32 pvc_get_rpe_freq(struct xe_guc_pc *pc)
 {
 	struct xe_gt *gt = pc_to_gt(pc);
-	struct xe_device *xe = gt_to_xe(gt);
 	u32 reg;
 
 	/*
 	 * For PVC we still need to use fused RP1 as the approximation for RPe
-	 * For other platforms than PVC we get the resolved RPe directly from
+	 */
+	reg = xe_mmio_read32(&gt->mmio, PVC_RP_STATE_CAP);
+	return REG_FIELD_GET(RP1_MASK, reg) * GT_FREQUENCY_MULTIPLIER;
+}
+
+static u32 tgl_get_rpe_freq(struct xe_guc_pc *pc)
+{
+	struct xe_gt *gt = pc_to_gt(pc);
+	u32 reg;
+
+	/*
+	 * For other platforms than PVC, we get the resolved RPe directly from
 	 * PCODE at a different register
 	 */
-	if (xe->info.platform == XE_PVC) {
-		reg = xe_mmio_read32(&gt->mmio, PVC_RP_STATE_CAP);
-		pc->rpe_freq = REG_FIELD_GET(RP1_MASK, reg) * GT_FREQUENCY_MULTIPLIER;
-	} else {
-		reg = xe_mmio_read32(&gt->mmio, FREQ_INFO_REC);
-		pc->rpe_freq = REG_FIELD_GET(RPE_MASK, reg) * GT_FREQUENCY_MULTIPLIER;
-	}
+	reg = xe_mmio_read32(&gt->mmio, FREQ_INFO_REC);
+	return REG_FIELD_GET(RPE_MASK, reg) * GT_FREQUENCY_MULTIPLIER;
 }
 
 static void pc_update_rp_values(struct xe_guc_pc *pc)
@@ -451,20 +456,10 @@ static void pc_update_rp_values(struct xe_guc_pc *pc)
 	struct xe_gt *gt = pc_to_gt(pc);
 	struct xe_device *xe = gt_to_xe(gt);
 
-	if (GRAPHICS_VERx100(xe) >= 1270) {
+	if (GRAPHICS_VERx100(xe) >= 1270)
 		mtl_update_rpa_value(pc);
-		mtl_update_rpe_value(pc);
-	} else {
+	else
 		tgl_update_rpa_value(pc);
-		tgl_update_rpe_value(pc);
-	}
-
-	/*
-	 * RPe is decided at runtime by PCODE. In the rare case where that's
-	 * smaller than the fused min, we will trust the PCODE and use that
-	 * as our minimum one.
-	 */
-	pc->rpn_freq = min(pc->rpn_freq, pc->rpe_freq);
 }
 
 /**
@@ -578,9 +573,17 @@ u32 xe_guc_pc_get_rpa_freq(struct xe_guc_pc *pc)
  */
 u32 xe_guc_pc_get_rpe_freq(struct xe_guc_pc *pc)
 {
-	pc_update_rp_values(pc);
+	struct xe_device *xe = pc_to_xe(pc);
+	u32 freq;
 
-	return pc->rpe_freq;
+	if (GRAPHICS_VERx100(xe) == 1260)
+		freq = pvc_get_rpe_freq(pc);
+	else if (GRAPHICS_VERx100(xe) >= 1270)
+		freq = mtl_get_rpe_freq(pc);
+	else
+		freq = tgl_get_rpe_freq(pc);
+
+	return freq;
 }
 
 /**
@@ -1039,7 +1042,7 @@ static int pc_set_mert_freq_cap(struct xe_guc_pc *pc)
 	/*
 	 * Ensure min and max are bound by MERT_FREQ_CAP until driver loads.
 	 */
-	ret = pc_set_min_freq(pc, min(pc->rpe_freq, pc_max_freq_cap(pc)));
+	ret = pc_set_min_freq(pc, min(xe_guc_pc_get_rpe_freq(pc), pc_max_freq_cap(pc)));
 	if (!ret)
 		ret = pc_set_max_freq(pc, min(pc->rp0_freq, pc_max_freq_cap(pc)));
 
@@ -1391,7 +1394,7 @@ static void xe_guc_pc_fini_hw(void *arg)
 	XE_WARN_ON(xe_guc_pc_stop(pc));
 
 	/* Bind requested freq to mert_freq_cap before unload */
-	pc_set_cur_freq(pc, min(pc_max_freq_cap(pc), pc->rpe_freq));
+	pc_set_cur_freq(pc, min(pc_max_freq_cap(pc), xe_guc_pc_get_rpe_freq(pc)));
 
 	xe_force_wake_put(gt_to_fw(pc_to_gt(pc)), fw_ref);
 }
diff --git a/drivers/gpu/drm/xe/xe_guc_pc_types.h b/drivers/gpu/drm/xe/xe_guc_pc_types.h
index 5e4ea53fbee6e..f27c05d817065 100644
--- a/drivers/gpu/drm/xe/xe_guc_pc_types.h
+++ b/drivers/gpu/drm/xe/xe_guc_pc_types.h
@@ -21,8 +21,6 @@ struct xe_guc_pc {
 	u32 rp0_freq;
 	/** @rpa_freq: HW RPa frequency - The Achievable one */
 	u32 rpa_freq;
-	/** @rpe_freq: HW RPe frequency - The Efficient one */
-	u32 rpe_freq;
 	/** @rpn_freq: HW RPN frequency - The Minimum one */
 	u32 rpn_freq;
 	/** @user_requested_min: Stash the minimum requested freq by user */
-- 
2.53.0




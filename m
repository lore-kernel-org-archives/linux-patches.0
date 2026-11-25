Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619224;
	b=wG6GG9LhqvQR5s8zepTuJwDs3Jv6agBiAc3H+DKXpyYhYp8Rc0NYdVqdKlPtc/WwqL+m
	 E3FUdnY5TcLsYVVSK+SA/sLIQNXbOt4W3thyNmdGzQbgtv6Klgegq/n4WgIXKhE+kVKNq
	 GbDkamF6s8aU7n0oh5wtBQCOznjUtH8M/RkmVh37pDjrmxcvRhfmcPD/tOX5DXfOxlzZJ
	 T0EbLZyG3CjlF3lxBkNtlt5aO/Jx14N1NuWjVxPIH+xy1vAKqOWt/U2/r4Tb1gcRW2vE1
	 pD/+GBQ2Cf6YEUvg3y0MJpcx067M+6OOQO/eGX+GxA1p/XXTKOzzPnZtisUrXQi7wtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619224;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=WurF2/d21WLttWJvGOe3YrZV1vLMsN3czJUZxdEkKis=;
	b=kMmzewNeqD3q+KG15AvGqmPl8GCsnBT44Ph/nZ9iycUBYQi+yK/vOT9mhvgzFqGWFz7t
	 VSBaj2HKr4WlHbIYsWssGpoTakum8/inXxDA5ewO16B1qnpfoMa7dcfY/sDtSIfaE6hqh
	 l77v8jIbA2gISHlGXAYrQH3u+iTGicZA6Jc+HxZiBW8GWHnGeg+diPVbMAQHXNHUi11fz
	 E1koEUBRWRI5bjr2qxX7kHgnkc3bp0HvkAtTEzVDXSU5RiiZGNgQkBO9P0QLvMFRmj6hp
	 vPYIFLU2sVkXQVazDyssd3N/Yld3/URmFo+m/WAkkbTQA4oNRIObzO0/GQwqtjVOrIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wfZyjBWh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 692FF606A323;
	Wed, 25 Nov 2026 15:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wfZyjBWh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49FFE1F000C0;
	Wed, 25 Nov 2026 15:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619223;
	bh=WurF2/d21WLttWJvGOe3YrZV1vLMsN3czJUZxdEkKis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wfZyjBWhCbBnUW2sq/D60Ojw779V/eOZ39WVmBD4tVCVqnPDTdPBhCOgS+3HJoPOI
	 Dq39nwpGzJhA/IEWqzSrOdTjEESWgh7BXgKaaip80FtIZsy1jm6D1jjYxCLerkSpkH
	 vVFJpZH84RJtSIpomtlFlZtcKnNxFhjeyVhoKicQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Satyanarayana K V P <satyanarayana.k.v.p@intel.com>,
	=?UTF-8?q?Piotr=20Pi=C3=B3rkowski?= <piotr.piorkowski@intel.com>,
	=?UTF-8?q?Micha=C5=82=20Winiarski?= <michal.winiarski@intel.com>,
	Stuart Summers <stuart.summers@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0529/1005] drm/xe/pf: Program LMTT directory pointer from each GTs init path
Date: Wed, 25 Nov 2026 15:31:07 +0100
Message-ID: <20261125143834.139372980@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Satyanarayana K V P <satyanarayana.k.v.p@intel.com>

[ Upstream commit 3654a4d734df960d303d2494037606c72525c0a3 ]

The LMTT directory pointer is configured on every GT of the tile only
from the primary GT's init/reset flow. On new platforms, both primary and
media GTs have their own forcewake. Primary GT's init holds only its own
forcewake, so the media GT write can be lost.

Program the LMTT directory pointer from each GT's own init and restart
path, while that GT's forcewake is held.

Also use MCR registers for primary GT and unicast registers for media GT.

Fixes: ad69d62588cd ("drm/xe/pf: Program LMTT directory pointer on all GTs within a tile")
Signed-off-by: Satyanarayana K V P <satyanarayana.k.v.p@intel.com>
Cc: Piotr Piórkowski <piotr.piorkowski@intel.com>
Cc: Michał Winiarski <michal.winiarski@intel.com>
Cc: Stuart Summers <stuart.summers@intel.com>
Cc: Matt Roper <matthew.d.roper@intel.com>
Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Link: https://patch.msgid.link/20261105114923.880265-4-satyanarayana.k.v.p@intel.com
(cherry picked from commit a8653bee6a0404e9962e80894eae0afab355cbd3)
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/regs/xe_gt_regs.h |  1 +
 drivers/gpu/drm/xe/xe_gt.c           | 14 +++----
 drivers/gpu/drm/xe/xe_lmtt.c         | 58 +++++++++++++++++++++-------
 drivers/gpu/drm/xe/xe_lmtt.h         |  5 ++-
 4 files changed, 55 insertions(+), 23 deletions(-)

diff --git a/drivers/gpu/drm/xe/regs/xe_gt_regs.h b/drivers/gpu/drm/xe/regs/xe_gt_regs.h
index 247a736a54aaa..f8c14a7f92747 100644
--- a/drivers/gpu/drm/xe/regs/xe_gt_regs.h
+++ b/drivers/gpu/drm/xe/regs/xe_gt_regs.h
@@ -107,6 +107,7 @@
 #define GAMSTLB_CTRL2				XE_REG_MCR(0x4788)
 #define   STLB_SINGLE_BANK_MODE			REG_BIT(11)
 
+#define XE2_LMEM_CFG_MCR			XE_REG_MCR(0x48b0)
 #define XE2_LMEM_CFG				XE_REG(0x48b0)
 
 #define XE2_GAMWALK_CTRL			0x47e4
diff --git a/drivers/gpu/drm/xe/xe_gt.c b/drivers/gpu/drm/xe/xe_gt.c
index ca7f9b806bac9..2176254b10f2a 100644
--- a/drivers/gpu/drm/xe/xe_gt.c
+++ b/drivers/gpu/drm/xe/xe_gt.c
@@ -704,11 +704,10 @@ static int gt_init_with_all_forcewake(struct xe_gt *gt)
 		xe_gt_apply_ccs_mode(gt);
 	}
 
-	if (IS_SRIOV_PF(gt_to_xe(gt)) && xe_gt_is_main_type(gt))
-		xe_lmtt_init_hw(&gt_to_tile(gt)->sriov.pf.lmtt);
-
-	if (IS_SRIOV_PF(gt_to_xe(gt)))
+	if (IS_SRIOV_PF(gt_to_xe(gt))) {
+		xe_lmtt_init_hw(gt);
 		xe_gt_sriov_pf_init_hw(gt);
+	}
 
 	/* Last action registered here so devres drains resets before teardown */
 	err = devm_add_action_or_reset(xe->drm.dev, gt_worker_disable, gt);
@@ -905,11 +904,10 @@ static int do_gt_restart(struct xe_gt *gt)
 	if (err)
 		return err;
 
-	if (IS_SRIOV_PF(gt_to_xe(gt)) && xe_gt_is_main_type(gt))
-		xe_lmtt_init_hw(&gt_to_tile(gt)->sriov.pf.lmtt);
-
-	if (IS_SRIOV_PF(gt_to_xe(gt)))
+	if (IS_SRIOV_PF(gt_to_xe(gt))) {
+		xe_lmtt_init_hw(gt);
 		xe_gt_sriov_pf_init_hw(gt);
+	}
 
 	xe_mocs_init(gt);
 
diff --git a/drivers/gpu/drm/xe/xe_lmtt.c b/drivers/gpu/drm/xe/xe_lmtt.c
index 0c726eda93906..8a5a434931b04 100644
--- a/drivers/gpu/drm/xe/xe_lmtt.c
+++ b/drivers/gpu/drm/xe/xe_lmtt.c
@@ -12,7 +12,8 @@
 
 #include "xe_assert.h"
 #include "xe_bo.h"
-#include "xe_tlb_inval.h"
+#include "xe_gt.h"
+#include "xe_gt_mcr.h"
 #include "xe_lmtt.h"
 #include "xe_map.h"
 #include "xe_mert.h"
@@ -21,6 +22,7 @@
 #include "xe_sriov.h"
 #include "xe_tile.h"
 #include "xe_tile_sriov_printk.h"
+#include "xe_tlb_inval.h"
 
 /**
  * DOC: Local Memory Translation Table
@@ -210,14 +212,43 @@ int xe_lmtt_init(struct xe_lmtt *lmtt)
 	return err;
 }
 
-static void lmtt_setup_dir_ptr(struct xe_lmtt *lmtt)
+static void lmtt_setup_dir_ptr_gt(struct xe_gt *gt, u32 config)
+{
+	struct xe_device *xe = gt_to_xe(gt);
+	struct xe_reg_mcr reg_mcr;
+	struct xe_reg reg;
+	u32 val_read;
+
+	if (GRAPHICS_VER(xe) < 20) {
+		reg = LMEM_CFG;
+		xe_mmio_write32(&gt->mmio, reg, config);
+		return;
+	}
+
+	if (xe_gt_is_main_type(gt)) {
+		reg_mcr = XE2_LMEM_CFG_MCR;
+		xe_gt_mcr_multicast_write(gt, reg_mcr, config);
+		val_read = xe_gt_mcr_unicast_read_any(gt, reg_mcr);
+		xe_gt_assert_msg(gt, val_read == config, "LMEM_CFG_MCR: %#x != %#x\n",
+				 config, val_read);
+	} else {
+		reg = XE2_LMEM_CFG;
+		xe_mmio_write32(&gt->mmio, reg, config);
+
+		if (MEDIA_VER(xe) >= 35) {
+			val_read = xe_mmio_read32(&gt->mmio, reg);
+			xe_gt_assert_msg(gt, val_read == config, "LMEM_CFG: %#x != %#x\n",
+					 config, val_read);
+		}
+	}
+}
+
+static void lmtt_setup_dir_ptr(struct xe_lmtt *lmtt, struct xe_gt *gt)
 {
 	struct xe_tile *tile = lmtt_to_tile(lmtt);
 	struct xe_device *xe = tile_to_xe(tile);
 	dma_addr_t offset = xe_bo_main_addr(lmtt->pd->bo, XE_PAGE_SIZE);
-	struct xe_gt *gt;
 	u32 config;
-	u8 id;
 
 	lmtt_debug(lmtt, "DIR offset %pad\n", &offset);
 	lmtt_assert(lmtt, xe_bo_is_vram(lmtt->pd->bo));
@@ -225,31 +256,32 @@ static void lmtt_setup_dir_ptr(struct xe_lmtt *lmtt)
 
 	config = LMEM_EN | REG_FIELD_PREP(LMTT_DIR_PTR, offset / SZ_64K);
 
-	for_each_gt_on_tile(gt, tile, id)
-		xe_mmio_write32(&gt->mmio,
-				GRAPHICS_VER(xe) >= 20 ? XE2_LMEM_CFG : LMEM_CFG,
-				config);
+	lmtt_setup_dir_ptr_gt(gt, config);
 
-	if (xe_device_has_mert(xe) && xe_tile_is_root(tile))
+	if (xe_device_has_mert(xe) && xe_tile_is_root(tile) &&
+	    xe_gt_is_main_type(gt))
 		xe_mmio_write32(&tile->mmio, MERT_LMEM_CFG, config);
 }
 
 /**
  * xe_lmtt_init_hw - Perform LMTT hardware initialization.
- * @lmtt: the &xe_lmtt to initialize
+ * @gt: the &xe_gt for which lmtt is initialized
  *
  * This function is a second step of the LMTT initialization.
- * This function registers LMTT Root Directory prepared in xe_lmtt_init().
+ * This function registers LMTT Root Directory prepared in xe_lmtt_init()
+ * on the given GT.
  *
  * This function shall be called after every hardware reset.
  * This function shall be called only when running as a PF driver.
  */
-void xe_lmtt_init_hw(struct xe_lmtt *lmtt)
+void xe_lmtt_init_hw(struct xe_gt *gt)
 {
+	struct xe_lmtt *lmtt = &gt_to_tile(gt)->sriov.pf.lmtt;
+
 	if (!lmtt->pd)
 		return;
 
-	lmtt_setup_dir_ptr(lmtt);
+	lmtt_setup_dir_ptr(lmtt, gt);
 }
 
 static int lmtt_invalidate_hw(struct xe_lmtt *lmtt)
diff --git a/drivers/gpu/drm/xe/xe_lmtt.h b/drivers/gpu/drm/xe/xe_lmtt.h
index 8fa387b38c520..5ef065dd573c0 100644
--- a/drivers/gpu/drm/xe/xe_lmtt.h
+++ b/drivers/gpu/drm/xe/xe_lmtt.h
@@ -9,12 +9,13 @@
 #include <linux/types.h>
 
 struct xe_bo;
+struct xe_gt;
 struct xe_lmtt;
 struct xe_lmtt_ops;
 
 #ifdef CONFIG_PCI_IOV
 int xe_lmtt_init(struct xe_lmtt *lmtt);
-void xe_lmtt_init_hw(struct xe_lmtt *lmtt);
+void xe_lmtt_init_hw(struct xe_gt *gt);
 void xe_lmtt_invalidate_hw(struct xe_lmtt *lmtt);
 int xe_lmtt_prepare_pages(struct xe_lmtt *lmtt, unsigned int vfid, u64 range);
 int xe_lmtt_populate_pages(struct xe_lmtt *lmtt, unsigned int vfid, struct xe_bo *bo, u64 offset);
@@ -23,7 +24,7 @@ u64 xe_lmtt_estimate_pt_size(struct xe_lmtt *lmtt, u64 size);
 u64 xe_lmtt_page_size(struct xe_lmtt *lmtt);
 #else
 static inline int xe_lmtt_init(struct xe_lmtt *lmtt) { return 0; }
-static inline void xe_lmtt_init_hw(struct xe_lmtt *lmtt) { }
+static inline void xe_lmtt_init_hw(struct xe_gt *gt) { }
 #endif
 
 #endif
-- 
2.53.0




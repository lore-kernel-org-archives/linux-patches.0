Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 363D82773F4;
	Tue, 21 Oct 2025 20:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077601; cv=none; b=k/FHjBKhRlWKa18YouwrTVUu54h9mXsQhURg6ns8Jqp8GH2ffpCxjeA0hQp7hMzWgPcw3xWw7DD3j1HitFrQAE+hvpKSXo4s7iThCHm5/1TH+rs9VZ/+ukdaR7uEuV/8dgiMFJxstVCSRyoWpcqyDK2sTenXvguB6TDTZnNKlHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077601; c=relaxed/simple;
	bh=NoT6ZXm+VeiHlXEpE/2P2UD89ev1rEc29cAdxBprxVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VLZsuDYtb1BpsjIBAjMRwypZ32OrCklTFRZHv0BRO372WKMV/16TvJ0AGp4X61NBRrketYOUdd6zu6JohWqczL5GL3L8jPZv4AUcO1heCI/5tytgRNkKkmpCHfptdW3AVRC2usJggZA0/pAWDorqOYEVs5BcOd8iUla2F6uvGtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bsllmSQD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bsllmSQD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ECBBC4CEF1;
	Tue, 21 Oct 2025 20:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077601;
	bh=NoT6ZXm+VeiHlXEpE/2P2UD89ev1rEc29cAdxBprxVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bsllmSQDCiewTNFav1qKwqRdCnQErymqFBZLbGAwwFi7SWjsjwt149WATNru8EH8Q
	 hw1KTUWPnfGIE26p3gqKTgyqsyIyRZsAr0MMyqGn/R2FuYQ3E1c5H95XqtCUmbU2QI
	 XTxVzt/QVCf/1Xs+eGvF/B868KkJc+it/5lNBa0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Piotr=20Pi=C3=B3rkowski?= <piotr.piorkowski@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Satyanarayana K V P <satyanarayana.k.v.p@intel.com>
Subject: [PATCH 6.17 156/159] drm/xe: Move struct xe_vram_region to a dedicated header
Date: Tue, 21 Oct 2025 21:52:13 +0200
Message-ID: <20251021195046.928645258@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Piotr Piórkowski <piotr.piorkowski@intel.com>

[ Upstream commit 7a20b4f558f4291161f71a5b7384262db9ccd6b0 ]

Let's move the xe_vram_region structure to a new header dedicated to VRAM
to improve modularity and avoid unnecessary dependencies when only
VRAM-related structures are needed.

v2: Fix build if CONFIG_DRM_XE_DEVMEM_MIRROR is enabled
v3: Fix build if CONFIG_DRM_XE_DISPLAY is enabled
v4: Move helper to get tile dpagemap to xe_svm.c

Signed-off-by: Piotr Piórkowski <piotr.piorkowski@intel.com>
Suggested-by: Jani Nikula <jani.nikula@intel.com>
Reviewed-by: Satyanarayana K V P <satyanarayana.k.v.p@intel.com> # rev3
Acked-by: Matthew Brost <matthew.brost@intel.com>
Link: https://lore.kernel.org/r/20250714184818.89201-4-piotr.piorkowski@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Stable-dep-of: d30203739be7 ("drm/xe: Move rebar to be done earlier")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/display/xe_fb_pin.c        |    1 
 drivers/gpu/drm/xe/display/xe_plane_initial.c |    1 
 drivers/gpu/drm/xe/xe_bo.c                    |    1 
 drivers/gpu/drm/xe/xe_bo_types.h              |    1 
 drivers/gpu/drm/xe/xe_device.c                |    1 
 drivers/gpu/drm/xe/xe_device_types.h          |   60 ---------------------
 drivers/gpu/drm/xe/xe_gt_sriov_pf_config.c    |    1 
 drivers/gpu/drm/xe/xe_svm.c                   |    8 ++
 drivers/gpu/drm/xe/xe_tile.c                  |    1 
 drivers/gpu/drm/xe/xe_tile.h                  |   12 ----
 drivers/gpu/drm/xe/xe_ttm_vram_mgr.c          |    1 
 drivers/gpu/drm/xe/xe_vram.c                  |    1 
 drivers/gpu/drm/xe/xe_vram_types.h            |   74 ++++++++++++++++++++++++++
 13 files changed, 91 insertions(+), 72 deletions(-)
 create mode 100644 drivers/gpu/drm/xe/xe_vram_types.h

--- a/drivers/gpu/drm/xe/display/xe_fb_pin.c
+++ b/drivers/gpu/drm/xe/display/xe_fb_pin.c
@@ -16,6 +16,7 @@
 #include "xe_device.h"
 #include "xe_ggtt.h"
 #include "xe_pm.h"
+#include "xe_vram_types.h"
 
 static void
 write_dpt_rotated(struct xe_bo *bo, struct iosys_map *map, u32 *dpt_ofs, u32 bo_ofs,
--- a/drivers/gpu/drm/xe/display/xe_plane_initial.c
+++ b/drivers/gpu/drm/xe/display/xe_plane_initial.c
@@ -21,6 +21,7 @@
 #include "intel_plane.h"
 #include "intel_plane_initial.h"
 #include "xe_bo.h"
+#include "xe_vram_types.h"
 #include "xe_wa.h"
 
 #include <generated/xe_wa_oob.h>
--- a/drivers/gpu/drm/xe/xe_bo.c
+++ b/drivers/gpu/drm/xe/xe_bo.c
@@ -36,6 +36,7 @@
 #include "xe_trace_bo.h"
 #include "xe_ttm_stolen_mgr.h"
 #include "xe_vm.h"
+#include "xe_vram_types.h"
 
 const char *const xe_mem_type_to_name[TTM_NUM_MEM_TYPES]  = {
 	[XE_PL_SYSTEM] = "system",
--- a/drivers/gpu/drm/xe/xe_bo_types.h
+++ b/drivers/gpu/drm/xe/xe_bo_types.h
@@ -9,6 +9,7 @@
 #include <linux/iosys-map.h>
 
 #include <drm/drm_gpusvm.h>
+#include <drm/drm_pagemap.h>
 #include <drm/ttm/ttm_bo.h>
 #include <drm/ttm/ttm_device.h>
 #include <drm/ttm/ttm_placement.h>
--- a/drivers/gpu/drm/xe/xe_device.c
+++ b/drivers/gpu/drm/xe/xe_device.c
@@ -64,6 +64,7 @@
 #include "xe_ttm_sys_mgr.h"
 #include "xe_vm.h"
 #include "xe_vram.h"
+#include "xe_vram_types.h"
 #include "xe_vsec.h"
 #include "xe_wait_user_fence.h"
 #include "xe_wa.h"
--- a/drivers/gpu/drm/xe/xe_device_types.h
+++ b/drivers/gpu/drm/xe/xe_device_types.h
@@ -10,7 +10,6 @@
 
 #include <drm/drm_device.h>
 #include <drm/drm_file.h>
-#include <drm/drm_pagemap.h>
 #include <drm/ttm/ttm_device.h>
 
 #include "xe_devcoredump_types.h"
@@ -26,7 +25,6 @@
 #include "xe_sriov_vf_types.h"
 #include "xe_step_types.h"
 #include "xe_survivability_mode_types.h"
-#include "xe_ttm_vram_mgr_types.h"
 
 #if IS_ENABLED(CONFIG_DRM_XE_DEBUG)
 #define TEST_VM_OPS_ERROR
@@ -39,6 +37,7 @@ struct xe_ggtt;
 struct xe_i2c;
 struct xe_pat_ops;
 struct xe_pxp;
+struct xe_vram_region;
 
 #define XE_BO_INVALID_OFFSET	LONG_MAX
 
@@ -72,63 +71,6 @@ struct xe_pxp;
 		 struct xe_tile * : (tile__)->xe)
 
 /**
- * struct xe_vram_region - memory region structure
- * This is used to describe a memory region in xe
- * device, such as HBM memory or CXL extension memory.
- */
-struct xe_vram_region {
-	/** @tile: Back pointer to tile */
-	struct xe_tile *tile;
-	/** @io_start: IO start address of this VRAM instance */
-	resource_size_t io_start;
-	/**
-	 * @io_size: IO size of this VRAM instance
-	 *
-	 * This represents how much of this VRAM we can access
-	 * via the CPU through the VRAM BAR. This can be smaller
-	 * than @usable_size, in which case only part of VRAM is CPU
-	 * accessible (typically the first 256M). This
-	 * configuration is known as small-bar.
-	 */
-	resource_size_t io_size;
-	/** @dpa_base: This memory regions's DPA (device physical address) base */
-	resource_size_t dpa_base;
-	/**
-	 * @usable_size: usable size of VRAM
-	 *
-	 * Usable size of VRAM excluding reserved portions
-	 * (e.g stolen mem)
-	 */
-	resource_size_t usable_size;
-	/**
-	 * @actual_physical_size: Actual VRAM size
-	 *
-	 * Actual VRAM size including reserved portions
-	 * (e.g stolen mem)
-	 */
-	resource_size_t actual_physical_size;
-	/** @mapping: pointer to VRAM mappable space */
-	void __iomem *mapping;
-	/** @ttm: VRAM TTM manager */
-	struct xe_ttm_vram_mgr ttm;
-#if IS_ENABLED(CONFIG_DRM_XE_PAGEMAP)
-	/** @pagemap: Used to remap device memory as ZONE_DEVICE */
-	struct dev_pagemap pagemap;
-	/**
-	 * @dpagemap: The struct drm_pagemap of the ZONE_DEVICE memory
-	 * pages of this tile.
-	 */
-	struct drm_pagemap dpagemap;
-	/**
-	 * @hpa_base: base host physical address
-	 *
-	 * This is generated when remap device memory as ZONE_DEVICE
-	 */
-	resource_size_t hpa_base;
-#endif
-};
-
-/**
  * struct xe_mmio - register mmio structure
  *
  * Represents an MMIO region that the CPU may use to access registers.  A
--- a/drivers/gpu/drm/xe/xe_gt_sriov_pf_config.c
+++ b/drivers/gpu/drm/xe/xe_gt_sriov_pf_config.c
@@ -33,6 +33,7 @@
 #include "xe_migrate.h"
 #include "xe_sriov.h"
 #include "xe_ttm_vram_mgr.h"
+#include "xe_vram_types.h"
 #include "xe_wopcm.h"
 
 #define make_u64_from_u32(hi, lo) ((u64)((u64)(u32)(hi) << 32 | (u32)(lo)))
--- a/drivers/gpu/drm/xe/xe_svm.c
+++ b/drivers/gpu/drm/xe/xe_svm.c
@@ -17,6 +17,7 @@
 #include "xe_ttm_vram_mgr.h"
 #include "xe_vm.h"
 #include "xe_vm_types.h"
+#include "xe_vram_types.h"
 
 static bool xe_svm_range_in_vram(struct xe_svm_range *range)
 {
@@ -989,6 +990,11 @@ int xe_svm_range_get_pages(struct xe_vm
 
 #if IS_ENABLED(CONFIG_DRM_XE_PAGEMAP)
 
+static struct drm_pagemap *tile_local_pagemap(struct xe_tile *tile)
+{
+	return &tile->mem.vram->dpagemap;
+}
+
 /**
  * xe_svm_alloc_vram()- Allocate device memory pages for range,
  * migrating existing data.
@@ -1006,7 +1012,7 @@ int xe_svm_alloc_vram(struct xe_tile *ti
 	xe_assert(tile_to_xe(tile), range->base.flags.migrate_devmem);
 	range_debug(range, "ALLOCATE VRAM");
 
-	dpagemap = xe_tile_local_pagemap(tile);
+	dpagemap = tile_local_pagemap(tile);
 	return drm_pagemap_populate_mm(dpagemap, xe_svm_range_start(range),
 				       xe_svm_range_end(range),
 				       range->base.gpusvm->mm,
--- a/drivers/gpu/drm/xe/xe_tile.c
+++ b/drivers/gpu/drm/xe/xe_tile.c
@@ -20,6 +20,7 @@
 #include "xe_ttm_vram_mgr.h"
 #include "xe_wa.h"
 #include "xe_vram.h"
+#include "xe_vram_types.h"
 
 /**
  * DOC: Multi-tile Design
--- a/drivers/gpu/drm/xe/xe_tile.h
+++ b/drivers/gpu/drm/xe/xe_tile.h
@@ -18,18 +18,6 @@ int xe_tile_alloc_vram(struct xe_tile *t
 
 void xe_tile_migrate_wait(struct xe_tile *tile);
 
-#if IS_ENABLED(CONFIG_DRM_XE_PAGEMAP)
-static inline struct drm_pagemap *xe_tile_local_pagemap(struct xe_tile *tile)
-{
-	return &tile->mem.vram->dpagemap;
-}
-#else
-static inline struct drm_pagemap *xe_tile_local_pagemap(struct xe_tile *tile)
-{
-	return NULL;
-}
-#endif
-
 static inline bool xe_tile_is_root(struct xe_tile *tile)
 {
 	return tile->id == 0;
--- a/drivers/gpu/drm/xe/xe_ttm_vram_mgr.c
+++ b/drivers/gpu/drm/xe/xe_ttm_vram_mgr.c
@@ -15,6 +15,7 @@
 #include "xe_gt.h"
 #include "xe_res_cursor.h"
 #include "xe_ttm_vram_mgr.h"
+#include "xe_vram_types.h"
 
 static inline struct drm_buddy_block *
 xe_ttm_vram_mgr_first_block(struct list_head *list)
--- a/drivers/gpu/drm/xe/xe_vram.c
+++ b/drivers/gpu/drm/xe/xe_vram.c
@@ -21,6 +21,7 @@
 #include "xe_module.h"
 #include "xe_sriov.h"
 #include "xe_vram.h"
+#include "xe_vram_types.h"
 
 #define BAR_SIZE_SHIFT 20
 
--- /dev/null
+++ b/drivers/gpu/drm/xe/xe_vram_types.h
@@ -0,0 +1,74 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * Copyright © 2025 Intel Corporation
+ */
+
+#ifndef _XE_VRAM_TYPES_H_
+#define _XE_VRAM_TYPES_H_
+
+#if IS_ENABLED(CONFIG_DRM_XE_PAGEMAP)
+#include <drm/drm_pagemap.h>
+#endif
+
+#include "xe_ttm_vram_mgr_types.h"
+
+struct xe_tile;
+
+/**
+ * struct xe_vram_region - memory region structure
+ * This is used to describe a memory region in xe
+ * device, such as HBM memory or CXL extension memory.
+ */
+struct xe_vram_region {
+	/** @tile: Back pointer to tile */
+	struct xe_tile *tile;
+	/** @io_start: IO start address of this VRAM instance */
+	resource_size_t io_start;
+	/**
+	 * @io_size: IO size of this VRAM instance
+	 *
+	 * This represents how much of this VRAM we can access
+	 * via the CPU through the VRAM BAR. This can be smaller
+	 * than @usable_size, in which case only part of VRAM is CPU
+	 * accessible (typically the first 256M). This
+	 * configuration is known as small-bar.
+	 */
+	resource_size_t io_size;
+	/** @dpa_base: This memory regions's DPA (device physical address) base */
+	resource_size_t dpa_base;
+	/**
+	 * @usable_size: usable size of VRAM
+	 *
+	 * Usable size of VRAM excluding reserved portions
+	 * (e.g stolen mem)
+	 */
+	resource_size_t usable_size;
+	/**
+	 * @actual_physical_size: Actual VRAM size
+	 *
+	 * Actual VRAM size including reserved portions
+	 * (e.g stolen mem)
+	 */
+	resource_size_t actual_physical_size;
+	/** @mapping: pointer to VRAM mappable space */
+	void __iomem *mapping;
+	/** @ttm: VRAM TTM manager */
+	struct xe_ttm_vram_mgr ttm;
+#if IS_ENABLED(CONFIG_DRM_XE_PAGEMAP)
+	/** @pagemap: Used to remap device memory as ZONE_DEVICE */
+	struct dev_pagemap pagemap;
+	/**
+	 * @dpagemap: The struct drm_pagemap of the ZONE_DEVICE memory
+	 * pages of this tile.
+	 */
+	struct drm_pagemap dpagemap;
+	/**
+	 * @hpa_base: base host physical address
+	 *
+	 * This is generated when remap device memory as ZONE_DEVICE
+	 */
+	resource_size_t hpa_base;
+#endif
+};
+
+#endif



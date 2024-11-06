Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8213F198E96;
	Wed,  6 Nov 2024 12:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896418; cv=none; b=R2wgCSFU+oQe/3u3vJb9rCjWl8wOLGjr5PiudKHRKc9WAJ6LCZYyr9Azm7a235MxLTs4ft6H3+UnfavkKM/ilW9nOOscKBATvwI6TUeSrvKZZNh2cwJ/CNhQ3V9AEqvSTyl6rAxsTNU9DwVwvE1TUXWszuseNvEmFkvpXYiOE1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896418; c=relaxed/simple;
	bh=pBYWOSBjPbFG6BVZ97ldA1kYRxxx7sN93b8QUOIR86g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oIMGpducblpGY2oat+com0u/xr9N6oYFUc/OmaQDAYmlCMw5wSWf1aPBYqPt9jxFit+E27wpLSE/6yGP7HIFY/E2dNQJHNci3A7m5DsNtBGtpXzNO+WVkFr2xGt3tjGCqcS2XLLkSOA7WsusDARtSL5DwrXkmb2uV5ydYdRgdgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qfM5Uwb8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qfM5Uwb8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 063E1C4CECD;
	Wed,  6 Nov 2024 12:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896418;
	bh=pBYWOSBjPbFG6BVZ97ldA1kYRxxx7sN93b8QUOIR86g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qfM5Uwb8Kl03RIhH0/cuvhKfmnk9ApMt8v1d2ql5Nnw5Io6BW4a2ILYcYx2EMvFw+
	 MwDjzbxc04HiOX+k8KEOfnBgxdXOTNm2mi1m+ZLQuvQAIpTLg4jmq0seHuI5exlM8J
	 ELTqL3fTy9cf6rpWcEC3k40cfghDAv1TInAoDnr0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 194/245] drm/xe: Kill regs/xe_sriov_regs.h
Date: Wed,  6 Nov 2024 13:04:07 +0100
Message-ID: <20241106120324.018793089@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Wajdeczko <michal.wajdeczko@intel.com>

[ Upstream commit 466a6c3855cf00653c14a92a6e9f8ae50077b77d ]

There is no real benefit to maintain a separate file. The register
definitions related to SR-IOV can be placed in existing headers.

Signed-off-by: Michal Wajdeczko <michal.wajdeczko@intel.com>
Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
Reviewed-by: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240702183704.1022-3-michal.wajdeczko@intel.com
Stable-dep-of: 993ca0eccec6 ("drm/xe: Add mmio read before GGTT invalidate")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/regs/xe_gt_regs.h    |  6 ++++++
 drivers/gpu/drm/xe/regs/xe_regs.h       |  6 ++++++
 drivers/gpu/drm/xe/regs/xe_sriov_regs.h | 23 -----------------------
 drivers/gpu/drm/xe/xe_gt_sriov_pf.c     |  2 +-
 drivers/gpu/drm/xe/xe_lmtt.c            |  2 +-
 drivers/gpu/drm/xe/xe_sriov.c           |  2 +-
 6 files changed, 15 insertions(+), 26 deletions(-)
 delete mode 100644 drivers/gpu/drm/xe/regs/xe_sriov_regs.h

diff --git a/drivers/gpu/drm/xe/regs/xe_gt_regs.h b/drivers/gpu/drm/xe/regs/xe_gt_regs.h
index 3c28650400586..a8c4998384d68 100644
--- a/drivers/gpu/drm/xe/regs/xe_gt_regs.h
+++ b/drivers/gpu/drm/xe/regs/xe_gt_regs.h
@@ -91,6 +91,8 @@
 #define VE1_AUX_INV				XE_REG(0x42b8)
 #define   AUX_INV				REG_BIT(0)
 
+#define XE2_LMEM_CFG				XE_REG(0x48b0)
+
 #define XEHP_TILE_ADDR_RANGE(_idx)		XE_REG_MCR(0x4900 + (_idx) * 4)
 #define XEHP_FLAT_CCS_BASE_ADDR			XE_REG_MCR(0x4910)
 #define XEHP_FLAT_CCS_PTR			REG_GENMASK(31, 8)
@@ -403,6 +405,10 @@
 #define   INVALIDATION_BROADCAST_MODE_DIS	REG_BIT(12)
 #define   GLOBAL_INVALIDATION_MODE		REG_BIT(2)
 
+#define LMEM_CFG				XE_REG(0xcf58)
+#define   LMEM_EN				REG_BIT(31)
+#define   LMTT_DIR_PTR				REG_GENMASK(30, 0) /* in multiples of 64KB */
+
 #define HALF_SLICE_CHICKEN5			XE_REG_MCR(0xe188, XE_REG_OPTION_MASKED)
 #define   DISABLE_SAMPLE_G_PERFORMANCE		REG_BIT(0)
 
diff --git a/drivers/gpu/drm/xe/regs/xe_regs.h b/drivers/gpu/drm/xe/regs/xe_regs.h
index 23ecba38ed419..55bf47c990169 100644
--- a/drivers/gpu/drm/xe/regs/xe_regs.h
+++ b/drivers/gpu/drm/xe/regs/xe_regs.h
@@ -30,6 +30,9 @@
 #define GU_DEBUG				XE_REG(0x101018)
 #define   DRIVERFLR_STATUS			REG_BIT(31)
 
+#define VIRTUAL_CTRL_REG			XE_REG(0x10108c)
+#define   GUEST_GTT_UPDATE_EN			REG_BIT(8)
+
 #define XEHP_MTCFG_ADDR				XE_REG(0x101800)
 #define   TILE_COUNT				REG_GENMASK(15, 8)
 
@@ -66,6 +69,9 @@
 #define   DISPLAY_IRQ				REG_BIT(16)
 #define   GT_DW_IRQ(x)				REG_BIT(x)
 
+#define VF_CAP_REG				XE_REG(0x1901f8, XE_REG_OPTION_VF)
+#define   VF_CAP				REG_BIT(0)
+
 #define PVC_RP_STATE_CAP			XE_REG(0x281014)
 
 #endif
diff --git a/drivers/gpu/drm/xe/regs/xe_sriov_regs.h b/drivers/gpu/drm/xe/regs/xe_sriov_regs.h
deleted file mode 100644
index 017b4ddd1ecf4..0000000000000
--- a/drivers/gpu/drm/xe/regs/xe_sriov_regs.h
+++ /dev/null
@@ -1,23 +0,0 @@
-/* SPDX-License-Identifier: MIT */
-/*
- * Copyright © 2023 Intel Corporation
- */
-
-#ifndef _REGS_XE_SRIOV_REGS_H_
-#define _REGS_XE_SRIOV_REGS_H_
-
-#include "regs/xe_reg_defs.h"
-
-#define XE2_LMEM_CFG			XE_REG(0x48b0)
-
-#define LMEM_CFG			XE_REG(0xcf58)
-#define   LMEM_EN			REG_BIT(31)
-#define   LMTT_DIR_PTR			REG_GENMASK(30, 0) /* in multiples of 64KB */
-
-#define VIRTUAL_CTRL_REG		XE_REG(0x10108c)
-#define   GUEST_GTT_UPDATE_EN		REG_BIT(8)
-
-#define VF_CAP_REG			XE_REG(0x1901f8, XE_REG_OPTION_VF)
-#define   VF_CAP			REG_BIT(0)
-
-#endif
diff --git a/drivers/gpu/drm/xe/xe_gt_sriov_pf.c b/drivers/gpu/drm/xe/xe_gt_sriov_pf.c
index 9dbba9ab7a9ab..ef239440963ce 100644
--- a/drivers/gpu/drm/xe/xe_gt_sriov_pf.c
+++ b/drivers/gpu/drm/xe/xe_gt_sriov_pf.c
@@ -5,7 +5,7 @@
 
 #include <drm/drm_managed.h>
 
-#include "regs/xe_sriov_regs.h"
+#include "regs/xe_regs.h"
 
 #include "xe_gt_sriov_pf.h"
 #include "xe_gt_sriov_pf_config.h"
diff --git a/drivers/gpu/drm/xe/xe_lmtt.c b/drivers/gpu/drm/xe/xe_lmtt.c
index 418661a889183..c5fdb36b6d336 100644
--- a/drivers/gpu/drm/xe/xe_lmtt.c
+++ b/drivers/gpu/drm/xe/xe_lmtt.c
@@ -7,7 +7,7 @@
 
 #include <drm/drm_managed.h>
 
-#include "regs/xe_sriov_regs.h"
+#include "regs/xe_gt_regs.h"
 
 #include "xe_assert.h"
 #include "xe_bo.h"
diff --git a/drivers/gpu/drm/xe/xe_sriov.c b/drivers/gpu/drm/xe/xe_sriov.c
index a274a5fb14018..5a1d65e4f19f2 100644
--- a/drivers/gpu/drm/xe/xe_sriov.c
+++ b/drivers/gpu/drm/xe/xe_sriov.c
@@ -5,7 +5,7 @@
 
 #include <drm/drm_managed.h>
 
-#include "regs/xe_sriov_regs.h"
+#include "regs/xe_regs.h"
 
 #include "xe_assert.h"
 #include "xe_device.h"
-- 
2.43.0




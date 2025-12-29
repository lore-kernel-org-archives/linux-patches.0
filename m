Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3066133123E;
	Mon, 29 Dec 2025 16:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025175; cv=none; b=bnyW5oUbtOg5IhOoKpx78PyQi+zgtHPicYiNgn3xs/zpQ3O9mjrpyCHrk3sGQb7cOgDKAnIF9kw7WXLay6QODrzgmsZoXGM33h0cHaz3ngDzlZbCb/pGWY5mJQXx4VVCFb4dl7YuLwfBT24b0TiUs3fSrdhJKXPUlMcSUEVMiOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025175; c=relaxed/simple;
	bh=L94UCDhBxCQQRaoBDg5LZaXehYBALwiV+JtM3xFSXuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZSmspALUnkuZTsrDvZh0tQzOYZclVRs8wfQVWt30OVECCkWw5M3SLW4UYcm36z7rVQ0Vgv/thvT5tz040xRNf+IhN4KAo7egZD8mjySvFd0gmclI3Q93gXobTseKAonJ6Rn46Ik5FlryWH3AOuuOT3tE7ZcZ0F1/ZXFGZ6wEzAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PP616K/q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PP616K/q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0073C4CEF7;
	Mon, 29 Dec 2025 16:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025175;
	bh=L94UCDhBxCQQRaoBDg5LZaXehYBALwiV+JtM3xFSXuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PP616K/qfh1NmBCaGr1UE1BTom4A1+rgo1tOVInV2E486T/XSISAuncZI3IjRaeMi
	 5M2QlEEdmxZLcZbfS3t3ctFYfr4nHiOn8rQFjJ1i5eEP/+ZyPY+bEs6gnErPuDoO6G
	 8EY2oru0804gyrjkq7HXBa2dRukeBV93Z3u3LM58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Roper <matthew.d.roper@intel.com>,
	Vinay Belgaumkar <vinay.belgaumkar@intel.com>,
	Riana Tauro <riana.tauro@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 120/430] drm/xe: Apply Wa_14020316580 in xe_gt_idle_enable_pg()
Date: Mon, 29 Dec 2025 17:08:42 +0100
Message-ID: <20251229160728.782438749@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vinay Belgaumkar <vinay.belgaumkar@intel.com>

[ Upstream commit c88a0731ed95f9705deb127a7f1927fa59aa742b ]

Wa_14020316580 was getting clobbered by power gating init code
later in the driver load sequence. Move the Wa so that
it applies correctly.

Fixes: 7cd05ef89c9d ("drm/xe/xe2hpm: Add initial set of workarounds")
Suggested-by: Matt Roper <matthew.d.roper@intel.com>
Signed-off-by: Vinay Belgaumkar <vinay.belgaumkar@intel.com>
Reviewed-by: Riana Tauro <riana.tauro@intel.com>
Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
Link: https://patch.msgid.link/20251129052548.70766-1-vinay.belgaumkar@intel.com
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
(cherry picked from commit 8b5502145351bde87f522df082b9e41356898ba3)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_gt_idle.c    | 8 ++++++++
 drivers/gpu/drm/xe/xe_wa.c         | 8 --------
 drivers/gpu/drm/xe/xe_wa_oob.rules | 1 +
 3 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_gt_idle.c b/drivers/gpu/drm/xe/xe_gt_idle.c
index bdc9d9877ec4..3e3d1d52f630 100644
--- a/drivers/gpu/drm/xe/xe_gt_idle.c
+++ b/drivers/gpu/drm/xe/xe_gt_idle.c
@@ -5,6 +5,7 @@
 
 #include <drm/drm_managed.h>
 
+#include <generated/xe_wa_oob.h>
 #include "xe_force_wake.h"
 #include "xe_device.h"
 #include "xe_gt.h"
@@ -16,6 +17,7 @@
 #include "xe_mmio.h"
 #include "xe_pm.h"
 #include "xe_sriov.h"
+#include "xe_wa.h"
 
 /**
  * DOC: Xe GT Idle
@@ -145,6 +147,12 @@ void xe_gt_idle_enable_pg(struct xe_gt *gt)
 		xe_mmio_write32(mmio, RENDER_POWERGATE_IDLE_HYSTERESIS, 25);
 	}
 
+	if (XE_GT_WA(gt, 14020316580))
+		gtidle->powergate_enable &= ~(VDN_HCP_POWERGATE_ENABLE(0) |
+					      VDN_MFXVDENC_POWERGATE_ENABLE(0) |
+					      VDN_HCP_POWERGATE_ENABLE(2) |
+					      VDN_MFXVDENC_POWERGATE_ENABLE(2));
+
 	xe_mmio_write32(mmio, POWERGATE_ENABLE, gtidle->powergate_enable);
 	xe_force_wake_put(gt_to_fw(gt), fw_ref);
 }
diff --git a/drivers/gpu/drm/xe/xe_wa.c b/drivers/gpu/drm/xe/xe_wa.c
index 3cf30718b200..d209434fd7fc 100644
--- a/drivers/gpu/drm/xe/xe_wa.c
+++ b/drivers/gpu/drm/xe/xe_wa.c
@@ -270,14 +270,6 @@ static const struct xe_rtp_entry_sr gt_was[] = {
 	  XE_RTP_ACTIONS(SET(VDBOX_CGCTL3F1C(0), MFXPIPE_CLKGATE_DIS)),
 	  XE_RTP_ENTRY_FLAG(FOREACH_ENGINE),
 	},
-	{ XE_RTP_NAME("14020316580"),
-	  XE_RTP_RULES(MEDIA_VERSION(1301)),
-	  XE_RTP_ACTIONS(CLR(POWERGATE_ENABLE,
-			     VDN_HCP_POWERGATE_ENABLE(0) |
-			     VDN_MFXVDENC_POWERGATE_ENABLE(0) |
-			     VDN_HCP_POWERGATE_ENABLE(2) |
-			     VDN_MFXVDENC_POWERGATE_ENABLE(2))),
-	},
 	{ XE_RTP_NAME("14019449301"),
 	  XE_RTP_RULES(MEDIA_VERSION(1301), ENGINE_CLASS(VIDEO_DECODE)),
 	  XE_RTP_ACTIONS(SET(VDBOX_CGCTL3F08(0), CG3DDISHRS_CLKGATE_DIS)),
diff --git a/drivers/gpu/drm/xe/xe_wa_oob.rules b/drivers/gpu/drm/xe/xe_wa_oob.rules
index f3a6d5d239ce..1d32fa1c3b2d 100644
--- a/drivers/gpu/drm/xe/xe_wa_oob.rules
+++ b/drivers/gpu/drm/xe/xe_wa_oob.rules
@@ -81,3 +81,4 @@
 
 15015404425_disable	PLATFORM(PANTHERLAKE), MEDIA_STEP(B0, FOREVER)
 16026007364    MEDIA_VERSION(3000)
+14020316580    MEDIA_VERSION(1301)
-- 
2.51.0




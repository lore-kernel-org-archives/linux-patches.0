Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22779325710
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300981; cv=none; b=m5vyNivniULkYXKYt0K0OKYA/JFBp+IZVixDww0ym/xMX8HMM/miaQ70xxjDeFN2okLl7k8ObfMs0U0M4pm9eTVj9I15oPKuWSRlZW/R3C9O17T9cmIYnVVI0XrvvgJB+YueIeo9hsGJ68J1p33IpVETZyx0JjN4mfD6oBbD2dM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300981; c=relaxed/simple;
	bh=ksckGtWC6IJx2KZE6NBw8nlzZwgZJfr+zBZlmHI7CW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QmvRK8HAF2JQVwMo98T4vPCY+cejNVolmBaoacADWmoGZzfe4i4jGT4s+Mup0i1Ve0nzch5q8mUlY1FWubsSNkZT5WraEgA2qC/D5RqglcJRwAx9CelPUJrDdB9yaw+3Hc3D5XSIqiI3yhjBviG2hZ9afKJLesvTSxQIPgYKowc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PdEh8vPc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PdEh8vPc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86728C116D0;
	Sat, 28 Feb 2026 17:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300981;
	bh=ksckGtWC6IJx2KZE6NBw8nlzZwgZJfr+zBZlmHI7CW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PdEh8vPcBOn+aT0p98KQ/w3EjxiOxRNLnECIWcCpG2xeFUFN1LKqPVNQ+vRlFj8Be
	 X6WQUcocktIjRbnKbQQ+eIlmeBLvoiLzipi9s3oLeGkhBjpaWW/cToOqMXbc2Lg9oh
	 Jw/FJJQYOY312QDsq/vSpWb3zlYSWdzazjpoPtipJla4K2knWazjIWYTh+ZEmBSGtj
	 tnnFhqXabSeBbqv7JfaGBe8/xQRdfd7TA/QcM6v9cfH6e0t1jeGCxEfr/sIgGLKZaV
	 mPY+GmbkVfN/78MwMQAqM28SzOruqeUMFpfMOIjTFobuBGptk+P44scePrkTzQRpbY
	 g7a7DvvAcaoWw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Balasubramani Vivekanandan <balasubramani.vivekanandan@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 110/752] drm/xe/xe3_lpg: Apply Wa_16028005424
Date: Sat, 28 Feb 2026 12:37:01 -0500
Message-ID: <20260228174750.1542406-110-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Balasubramani Vivekanandan <balasubramani.vivekanandan@intel.com>

[ Upstream commit 9d94c1cf6ef938abd4b849b66f8eab11e3c537ef ]

Applied Wa_16028005424 to Graphics version from 30.00 to 30.05

Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
Signed-off-by: Balasubramani Vivekanandan <balasubramani.vivekanandan@intel.com>
Link: https://patch.msgid.link/20251121100822.20076-2-balasubramani.vivekanandan@intel.com
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/regs/xe_guc_regs.h | 3 +++
 drivers/gpu/drm/xe/xe_wa.c            | 5 +++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/xe/regs/xe_guc_regs.h b/drivers/gpu/drm/xe/regs/xe_guc_regs.h
index 2118f7dec287f..87984713dd126 100644
--- a/drivers/gpu/drm/xe/regs/xe_guc_regs.h
+++ b/drivers/gpu/drm/xe/regs/xe_guc_regs.h
@@ -90,6 +90,9 @@
 #define GUC_SEND_INTERRUPT			XE_REG(0xc4c8)
 #define   GUC_SEND_TRIGGER			REG_BIT(0)
 
+#define GUC_INTR_CHICKEN			XE_REG(0xc50c)
+#define   DISABLE_SIGNALING_ENGINES		REG_BIT(1)
+
 #define GUC_BCS_RCS_IER				XE_REG(0xc550)
 #define GUC_VCS2_VCS1_IER			XE_REG(0xc554)
 #define GUC_WD_VECS_IER				XE_REG(0xc558)
diff --git a/drivers/gpu/drm/xe/xe_wa.c b/drivers/gpu/drm/xe/xe_wa.c
index 2a2e9f2c09163..89472b7362c22 100644
--- a/drivers/gpu/drm/xe/xe_wa.c
+++ b/drivers/gpu/drm/xe/xe_wa.c
@@ -15,6 +15,7 @@
 
 #include "regs/xe_engine_regs.h"
 #include "regs/xe_gt_regs.h"
+#include "regs/xe_guc_regs.h"
 #include "regs/xe_regs.h"
 #include "xe_device_types.h"
 #include "xe_force_wake.h"
@@ -315,6 +316,10 @@ static const struct xe_rtp_entry_sr gt_was[] = {
 	  XE_RTP_ACTIONS(SET(VDBOX_CGCTL3F10(0), RAMDFTUNIT_CLKGATE_DIS)),
 	  XE_RTP_ENTRY_FLAG(FOREACH_ENGINE),
 	},
+	{ XE_RTP_NAME("16028005424"),
+	  XE_RTP_RULES(GRAPHICS_VERSION_RANGE(3000, 3005)),
+	  XE_RTP_ACTIONS(SET(GUC_INTR_CHICKEN, DISABLE_SIGNALING_ENGINES))
+	},
 };
 
 static const struct xe_rtp_entry_sr engine_was[] = {
-- 
2.51.0


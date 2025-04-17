Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6717F259CA8;
	Thu, 17 Apr 2025 17:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912530; cv=none; b=OAk2PnRxw8Lxsa084zV2fESyYsIeyu5xJNvlQ7+2QFNmRnFV4e5SkCjiyttIPMRfPlGOjB6ayyD0zVIBGEnqJXXdgJAhN0XJf3g0ktr3claiWbYubPvBfjpDgXrVUHJxD8kOYZtPzliV/WNKU/RkwsSMK6DxSG+T9bYjW6IfVPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912530; c=relaxed/simple;
	bh=4WolgiHYVpc72efqyBWV2K5VuS7XOkBdMlWISFdPf98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fs5/W3hv/8I91czhOIb+2umBu0tw2vYVhcJ3rVTV2FgZN40gUu8iZ0Ndy+H9XBJnMWDny0d+aQmrSrdh5mqVVTDefMoqa5c8l8rHQbqY5YQVRMofV3BeMG5Sg+LxLdmoGO6SjrYQkft8EhesXLBwVOJnyiQUm9vTukEPDql1UKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hXem9OGm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hXem9OGm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED6A0C4CEE7;
	Thu, 17 Apr 2025 17:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912530;
	bh=4WolgiHYVpc72efqyBWV2K5VuS7XOkBdMlWISFdPf98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hXem9OGmfPEwOtB5FbAcMJMt8lHB39d5+e6uBW9sP0/ytBXydUxTrGDIEXar898M5
	 VavXftca3tkY1GRBOQP4EUw92balUqAGHewPmiIQ1bc9KaG5CsnlWO6gc3h/uMWIJ+
	 kbZBCI0rfZKMCqpB0dqnVPfbPSvt5nnFdsvzXx34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Andi Shyti <andi.shyti@intel.com>,
	Andrzej Hajda <andrzej.hajda@intel.com>,
	Badal Nilawar <badal.nilawar@intel.com>,
	Sk Anirban <sk.anirban@intel.com>,
	Karthik Poosa <karthik.poosa@intel.com>,
	Anshuman Gupta <anshuman.gupta@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 010/449] drm/i915: Disable RPG during live selftest
Date: Thu, 17 Apr 2025 19:44:58 +0200
Message-ID: <20250417175118.400511120@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

From: Badal Nilawar <badal.nilawar@intel.com>

[ Upstream commit 9d3d9776bd3bd9c32d460dfe6c3363134de578bc ]

The Forcewake timeout issue has been observed on Gen 12.0 and above.
To address this, disable Render Power-Gating (RPG) during live self-tests
for these generations. The temporary workaround 'drm/i915/mtl: do not
enable render power-gating on MTL' disables RPG globally, which is
unnecessary since the issues were only seen during self-tests.

v2: take runtime pm wakeref

Closes: https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/9413
Fixes: 25e7976db86b ("drm/i915/mtl: do not enable render power-gating on MTL")
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Andi Shyti <andi.shyti@intel.com>
Cc: Andrzej Hajda <andrzej.hajda@intel.com>
Signed-off-by: Badal Nilawar <badal.nilawar@intel.com>
Signed-off-by: Sk Anirban <sk.anirban@intel.com>
Reviewed-by: Karthik Poosa <karthik.poosa@intel.com>
Signed-off-by: Anshuman Gupta <anshuman.gupta@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250310152821.2931678-1-sk.anirban@intel.com
(cherry picked from commit 0a4ae87706c6d15d14648e428c3a76351f823e48)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/intel_rc6.c           | 19 ++++---------------
 .../gpu/drm/i915/selftests/i915_selftest.c    | 18 ++++++++++++++++++
 2 files changed, 22 insertions(+), 15 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_rc6.c b/drivers/gpu/drm/i915/gt/intel_rc6.c
index 9378d5901c493..9ca42589da4da 100644
--- a/drivers/gpu/drm/i915/gt/intel_rc6.c
+++ b/drivers/gpu/drm/i915/gt/intel_rc6.c
@@ -117,21 +117,10 @@ static void gen11_rc6_enable(struct intel_rc6 *rc6)
 			GEN6_RC_CTL_RC6_ENABLE |
 			GEN6_RC_CTL_EI_MODE(1);
 
-	/*
-	 * BSpec 52698 - Render powergating must be off.
-	 * FIXME BSpec is outdated, disabling powergating for MTL is just
-	 * temporary wa and should be removed after fixing real cause
-	 * of forcewake timeouts.
-	 */
-	if (IS_GFX_GT_IP_RANGE(gt, IP_VER(12, 70), IP_VER(12, 74)))
-		pg_enable =
-			GEN9_MEDIA_PG_ENABLE |
-			GEN11_MEDIA_SAMPLER_PG_ENABLE;
-	else
-		pg_enable =
-			GEN9_RENDER_PG_ENABLE |
-			GEN9_MEDIA_PG_ENABLE |
-			GEN11_MEDIA_SAMPLER_PG_ENABLE;
+	pg_enable =
+		GEN9_RENDER_PG_ENABLE |
+		GEN9_MEDIA_PG_ENABLE |
+		GEN11_MEDIA_SAMPLER_PG_ENABLE;
 
 	if (GRAPHICS_VER(gt->i915) >= 12 && !IS_DG1(gt->i915)) {
 		for (i = 0; i < I915_MAX_VCS; i++)
diff --git a/drivers/gpu/drm/i915/selftests/i915_selftest.c b/drivers/gpu/drm/i915/selftests/i915_selftest.c
index fee76c1d2f450..889281819c5b1 100644
--- a/drivers/gpu/drm/i915/selftests/i915_selftest.c
+++ b/drivers/gpu/drm/i915/selftests/i915_selftest.c
@@ -23,7 +23,9 @@
 
 #include <linux/random.h>
 
+#include "gt/intel_gt.h"
 #include "gt/intel_gt_pm.h"
+#include "gt/intel_gt_regs.h"
 #include "gt/uc/intel_gsc_fw.h"
 
 #include "i915_driver.h"
@@ -253,11 +255,27 @@ int i915_mock_selftests(void)
 int i915_live_selftests(struct pci_dev *pdev)
 {
 	struct drm_i915_private *i915 = pdev_to_i915(pdev);
+	struct intel_uncore *uncore = &i915->uncore;
 	int err;
+	u32 pg_enable;
+	intel_wakeref_t wakeref;
 
 	if (!i915_selftest.live)
 		return 0;
 
+	/*
+	 * FIXME Disable render powergating, this is temporary wa and should be removed
+	 * after fixing real cause of forcewake timeouts.
+	 */
+	with_intel_runtime_pm(uncore->rpm, wakeref) {
+		if (IS_GFX_GT_IP_RANGE(to_gt(i915), IP_VER(12, 00), IP_VER(12, 74))) {
+			pg_enable = intel_uncore_read(uncore, GEN9_PG_ENABLE);
+			if (pg_enable & GEN9_RENDER_PG_ENABLE)
+				intel_uncore_write_fw(uncore, GEN9_PG_ENABLE,
+						      pg_enable & ~GEN9_RENDER_PG_ENABLE);
+		}
+	}
+
 	__wait_gsc_proxy_completed(i915);
 	__wait_gsc_huc_load_completed(i915);
 
-- 
2.39.5




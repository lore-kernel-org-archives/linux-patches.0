Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65C891CAA99;
	Thu, 17 Apr 2025 18:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915079; cv=none; b=CysrTJrDJwoaPoFf5lx9pGPYjjrjqt5jvbcorcguj/78ZFKMoog5iKO4DXtNeOPmJW0RAC81YVqCKfFIcBSk0PbXNAYByrM9D5ddeAZ4g1kI+UKG4Qt5ZPIVyQPOwin7pHVSp5VMaJtlgeXdi4zrbag2wBoCu3HjvsS06cEN8/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915079; c=relaxed/simple;
	bh=oHglasHZppoNrMXhwRhp85TObudixNods4wSeyR802Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VLPSf9s+9XBO2jEh2n6aFr62vxu3zkwq8Pdustu2c2zYdsJNO7/+Bqlb6ha3C3Fvy8pAmp2SFg8wB8vLCWhOmIzykcL6WKcANiTHcRXy3X6rR1LbTA6cq7Mc88iGIbTPxQbbi6H1UBnqfeChVkvmKDcWUtiC2xtICUb2xNtqIWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aV8JGYQq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aV8JGYQq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4517C4CEE7;
	Thu, 17 Apr 2025 18:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915079;
	bh=oHglasHZppoNrMXhwRhp85TObudixNods4wSeyR802Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aV8JGYQq6tRzQypJ5la74iuqzc72d1Czu2dcMSbTPqWrpFW7Uzh4IqS7ex1dPTC6w
	 Uui6SzpKhgcQW6Qra9So5Rbs6zIZfh+/lIclQYL7YeHKZ+eSwoLLPPZLo0403jyc2G
	 dgjgyRT+7oOPCnqCH3a4Ei2cWt6GmfCxjoaEWsvg=
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
Subject: [PATCH 6.12 012/393] drm/i915: Disable RPG during live selftest
Date: Thu, 17 Apr 2025 19:47:01 +0200
Message-ID: <20250417175108.072909977@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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




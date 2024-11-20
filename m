Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8ED115853A;
	Wed, 20 Nov 2024 12:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107492; cv=none; b=FqYoT4gRJXiK+kEJraKR6zIWnhOBkx34QNig+wdoaeYGbu/cKNoknqraBpMcpHHJZSmGGuAnyObheSztodo+lb8VadSFVbyWlGwNKxW9e2VI77eqVuoa9Ni0DF6l/mt3uJ4hoxjsC521Ee9qeGYeQrQ5a+P5DXOC3pZoqSTjYDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107492; c=relaxed/simple;
	bh=nDslfztBgp3P6YbS7FGvka3S8aKs2Qg7BVELawI0sys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SB8Jb71h1GGaC5Phzdo3d7MltIGhI8nDuP7kND6/gxmesrP+1rbLQNDYCqhMZaDjxPHYyD1I9e93A4IuncXwSxFOi/gqQs6ZTLAQ/Y5PxEUro3lHB/kq8o8Hsm7IceKmobQts5BRT+NW+SVCkuX1ctGq2l3OCvm3i4K4NfE8Vv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L4SW1eqA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L4SW1eqA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71CD6C4CED2;
	Wed, 20 Nov 2024 12:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107492;
	bh=nDslfztBgp3P6YbS7FGvka3S8aKs2Qg7BVELawI0sys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L4SW1eqAABHsPVrRqXeHMPPeAAqqUGcPHkaw3gwAwSlZFypXXjutXvPZ9noUZdaWH
	 Sc9lv+KCF9wh1oASzd1MX3TUxkWFlAbMi0EHOzuUdg6kQlAAsStJXvTNjGPtbZiUdr
	 YFUL09ptmyQWrVALgSkdkLLhFnB8tUZ2nxd1JISQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
	John Harrison <John.C.Harrison@Intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 014/107] drm/i915/gsc: ARL-H and ARL-U need a newer GSC FW.
Date: Wed, 20 Nov 2024 13:55:49 +0100
Message-ID: <20241120125630.001587958@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.681745345@linuxfoundation.org>
References: <20241120125629.681745345@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>

[ Upstream commit db0fc586edde83ff7ff65fea56c4f72dae511764 ]

All MTL and ARL SKUs share the same GSC FW, but the newer platforms are
only supported in newer blobs. In particular, ARL-S is supported
starting from 102.0.10.1878 (which is already the minimum required
version for ARL in the code), while ARL-H and ARL-U are supported from
102.1.15.1926. Therefore, the driver needs to check which specific ARL
subplatform its running on when verifying that the GSC FW is new enough
for it.

Fixes: 2955ae8186c8 ("drm/i915: ARL requires a newer GSC firmware")
Signed-off-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Cc: John Harrison <John.C.Harrison@Intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Reviewed-by: John Harrison <John.C.Harrison@Intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241028233132.149745-1-daniele.ceraolospurio@intel.com
(cherry picked from commit 3c1d5ced18db8a67251c8436cf9bdc061f972bdb)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/uc/intel_gsc_fw.c | 50 +++++++++++++++--------
 drivers/gpu/drm/i915/i915_drv.h           |  8 +++-
 drivers/gpu/drm/i915/intel_device_info.c  | 24 ++++++++---
 drivers/gpu/drm/i915/intel_device_info.h  |  4 +-
 include/drm/intel/i915_pciids.h           | 19 +++++++--
 5 files changed, 75 insertions(+), 30 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/uc/intel_gsc_fw.c b/drivers/gpu/drm/i915/gt/uc/intel_gsc_fw.c
index 551b0d7974ff1..5dc0ccd076363 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_gsc_fw.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_gsc_fw.c
@@ -80,6 +80,7 @@ int intel_gsc_fw_get_binary_info(struct intel_uc_fw *gsc_fw, const void *data, s
 	const struct intel_gsc_cpd_header_v2 *cpd_header = NULL;
 	const struct intel_gsc_cpd_entry *cpd_entry = NULL;
 	const struct intel_gsc_manifest_header *manifest;
+	struct intel_uc_fw_ver min_ver = { 0 };
 	size_t min_size = sizeof(*layout);
 	int i;
 
@@ -212,33 +213,46 @@ int intel_gsc_fw_get_binary_info(struct intel_uc_fw *gsc_fw, const void *data, s
 		}
 	}
 
-	if (IS_ARROWLAKE(gt->i915)) {
+	/*
+	 * ARL SKUs require newer firmwares, but the blob is actually common
+	 * across all MTL and ARL SKUs, so we need to do an explicit version check
+	 * here rather than using a separate table entry. If a too old version
+	 * is found, then just don't use GSC rather than aborting the driver load.
+	 * Note that the major number in the GSC FW version is used to indicate
+	 * the platform, so we expect it to always be 102 for MTL/ARL binaries.
+	 */
+	if (IS_ARROWLAKE_S(gt->i915))
+		min_ver = (struct intel_uc_fw_ver){ 102, 0, 10, 1878 };
+	else if (IS_ARROWLAKE_H(gt->i915) || IS_ARROWLAKE_U(gt->i915))
+		min_ver = (struct intel_uc_fw_ver){ 102, 1, 15, 1926 };
+
+	if (IS_METEORLAKE(gt->i915) && gsc->release.major != 102) {
+		gt_info(gt, "Invalid GSC firmware for MTL/ARL, got %d.%d.%d.%d but need 102.x.x.x",
+			gsc->release.major, gsc->release.minor,
+			gsc->release.patch, gsc->release.build);
+			return -EINVAL;
+	}
+
+	if (min_ver.major) {
 		bool too_old = false;
 
-		/*
-		 * ARL requires a newer firmware than MTL did (102.0.10.1878) but the
-		 * firmware is actually common. So, need to do an explicit version check
-		 * here rather than using a separate table entry. And if the older
-		 * MTL-only version is found, then just don't use GSC rather than aborting
-		 * the driver load.
-		 */
-		if (gsc->release.major < 102) {
+		if (gsc->release.minor < min_ver.minor) {
 			too_old = true;
-		} else if (gsc->release.major == 102) {
-			if (gsc->release.minor == 0) {
-				if (gsc->release.patch < 10) {
+		} else if (gsc->release.minor == min_ver.minor) {
+			if (gsc->release.patch < min_ver.patch) {
+				too_old = true;
+			} else if (gsc->release.patch == min_ver.patch) {
+				if (gsc->release.build < min_ver.build)
 					too_old = true;
-				} else if (gsc->release.patch == 10) {
-					if (gsc->release.build < 1878)
-						too_old = true;
-				}
 			}
 		}
 
 		if (too_old) {
-			gt_info(gt, "GSC firmware too old for ARL, got %d.%d.%d.%d but need at least 102.0.10.1878",
+			gt_info(gt, "GSC firmware too old for ARL, got %d.%d.%d.%d but need at least %d.%d.%d.%d",
 				gsc->release.major, gsc->release.minor,
-				gsc->release.patch, gsc->release.build);
+				gsc->release.patch, gsc->release.build,
+				min_ver.major, min_ver.minor,
+				min_ver.patch, min_ver.build);
 			return -EINVAL;
 		}
 	}
diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index 110340e02a021..0c0c666f11ea2 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -546,8 +546,12 @@ IS_SUBPLATFORM(const struct drm_i915_private *i915,
 #define IS_LUNARLAKE(i915) (0 && i915)
 #define IS_BATTLEMAGE(i915)  (0 && i915)
 
-#define IS_ARROWLAKE(i915) \
-	IS_SUBPLATFORM(i915, INTEL_METEORLAKE, INTEL_SUBPLATFORM_ARL)
+#define IS_ARROWLAKE_H(i915) \
+	IS_SUBPLATFORM(i915, INTEL_METEORLAKE, INTEL_SUBPLATFORM_ARL_H)
+#define IS_ARROWLAKE_U(i915) \
+	IS_SUBPLATFORM(i915, INTEL_METEORLAKE, INTEL_SUBPLATFORM_ARL_U)
+#define IS_ARROWLAKE_S(i915) \
+	IS_SUBPLATFORM(i915, INTEL_METEORLAKE, INTEL_SUBPLATFORM_ARL_S)
 #define IS_DG2_G10(i915) \
 	IS_SUBPLATFORM(i915, INTEL_DG2, INTEL_SUBPLATFORM_G10)
 #define IS_DG2_G11(i915) \
diff --git a/drivers/gpu/drm/i915/intel_device_info.c b/drivers/gpu/drm/i915/intel_device_info.c
index 01a6502530501..bd0cb707e9d49 100644
--- a/drivers/gpu/drm/i915/intel_device_info.c
+++ b/drivers/gpu/drm/i915/intel_device_info.c
@@ -202,8 +202,16 @@ static const u16 subplatform_g12_ids[] = {
 	INTEL_DG2_G12_IDS(ID),
 };
 
-static const u16 subplatform_arl_ids[] = {
-	INTEL_ARL_IDS(ID),
+static const u16 subplatform_arl_h_ids[] = {
+	INTEL_ARL_H_IDS(ID),
+};
+
+static const u16 subplatform_arl_u_ids[] = {
+	INTEL_ARL_U_IDS(ID),
+};
+
+static const u16 subplatform_arl_s_ids[] = {
+	INTEL_ARL_S_IDS(ID),
 };
 
 static bool find_devid(u16 id, const u16 *p, unsigned int num)
@@ -263,9 +271,15 @@ static void intel_device_info_subplatform_init(struct drm_i915_private *i915)
 	} else if (find_devid(devid, subplatform_g12_ids,
 			      ARRAY_SIZE(subplatform_g12_ids))) {
 		mask = BIT(INTEL_SUBPLATFORM_G12);
-	} else if (find_devid(devid, subplatform_arl_ids,
-			      ARRAY_SIZE(subplatform_arl_ids))) {
-		mask = BIT(INTEL_SUBPLATFORM_ARL);
+	} else if (find_devid(devid, subplatform_arl_h_ids,
+			      ARRAY_SIZE(subplatform_arl_h_ids))) {
+		mask = BIT(INTEL_SUBPLATFORM_ARL_H);
+	} else if (find_devid(devid, subplatform_arl_u_ids,
+			      ARRAY_SIZE(subplatform_arl_u_ids))) {
+		mask = BIT(INTEL_SUBPLATFORM_ARL_U);
+	} else if (find_devid(devid, subplatform_arl_s_ids,
+			      ARRAY_SIZE(subplatform_arl_s_ids))) {
+		mask = BIT(INTEL_SUBPLATFORM_ARL_S);
 	}
 
 	GEM_BUG_ON(mask & ~INTEL_SUBPLATFORM_MASK);
diff --git a/drivers/gpu/drm/i915/intel_device_info.h b/drivers/gpu/drm/i915/intel_device_info.h
index 643ff1bf74eeb..a9fcaf33df9e2 100644
--- a/drivers/gpu/drm/i915/intel_device_info.h
+++ b/drivers/gpu/drm/i915/intel_device_info.h
@@ -128,7 +128,9 @@ enum intel_platform {
 #define INTEL_SUBPLATFORM_RPLU  2
 
 /* MTL */
-#define INTEL_SUBPLATFORM_ARL	0
+#define INTEL_SUBPLATFORM_ARL_H	0
+#define INTEL_SUBPLATFORM_ARL_U	1
+#define INTEL_SUBPLATFORM_ARL_S	2
 
 enum intel_ppgtt_type {
 	INTEL_PPGTT_NONE = I915_GEM_PPGTT_NONE,
diff --git a/include/drm/intel/i915_pciids.h b/include/drm/intel/i915_pciids.h
index 2bf03ebfcf73d..f35534522d333 100644
--- a/include/drm/intel/i915_pciids.h
+++ b/include/drm/intel/i915_pciids.h
@@ -771,13 +771,24 @@
 	INTEL_ATS_M150_IDS(MACRO__, ## __VA_ARGS__), \
 	INTEL_ATS_M75_IDS(MACRO__, ## __VA_ARGS__)
 
-/* MTL */
-#define INTEL_ARL_IDS(MACRO__, ...) \
-	MACRO__(0x7D41, ## __VA_ARGS__), \
+/* ARL */
+#define INTEL_ARL_H_IDS(MACRO__, ...) \
 	MACRO__(0x7D51, ## __VA_ARGS__), \
-	MACRO__(0x7D67, ## __VA_ARGS__), \
 	MACRO__(0x7DD1, ## __VA_ARGS__)
 
+#define INTEL_ARL_U_IDS(MACRO__, ...) \
+	MACRO__(0x7D41, ## __VA_ARGS__) \
+
+#define INTEL_ARL_S_IDS(MACRO__, ...) \
+	MACRO__(0x7D67, ## __VA_ARGS__), \
+	MACRO__(0xB640, ## __VA_ARGS__)
+
+#define INTEL_ARL_IDS(MACRO__, ...) \
+	INTEL_ARL_H_IDS(MACRO__, ## __VA_ARGS__), \
+	INTEL_ARL_U_IDS(MACRO__, ## __VA_ARGS__), \
+	INTEL_ARL_S_IDS(MACRO__, ## __VA_ARGS__)
+
+/* MTL */
 #define INTEL_MTL_IDS(MACRO__, ...) \
 	INTEL_ARL_IDS(MACRO__, ## __VA_ARGS__), \
 	MACRO__(0x7D40, ## __VA_ARGS__), \
-- 
2.43.0




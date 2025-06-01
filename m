Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D62A26560C;
	Sun,  1 Jun 2025 23:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748820755; cv=none; b=I3BXEIX+fDmMA6HYhl8h82MRBev8QmG5zWAvTHmXlkkiYx4j8V9tjVQsrmzgA40/L9D8lTrjN2yaH9bAwkXZDANJDH3RQMwdCxSEc6/M/uRASnNDrx5AjyHlNCFjU0BHgGawKRzi3NMJwy4jMc4+V9Yrsm/1JcgK67WKlaOyn1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748820755; c=relaxed/simple;
	bh=k1q+6w4j+/OQ6O9VJKMhIU7QvOTA20QxDLPZ3YxI6Sg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hlK7Pzx3dgKKx2MJ2bKrwHqfShHoz7iSo5Ypb0IaAYO0QBqm/CvN8pAGFGav4ZQSsxZNM2j3WsO5CrEY7MjcCQdBYJWE1gPNB6x80YD5C2Z5L8BMeOMjsB0sgdyvwTQ4+YNhhIPp2Ah8BBjHGUFYUax8XpEITaJXqXkkN39gFBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CHump6gc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CHump6gc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2758C4CEF1;
	Sun,  1 Jun 2025 23:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748820755;
	bh=k1q+6w4j+/OQ6O9VJKMhIU7QvOTA20QxDLPZ3YxI6Sg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CHump6gc4Sx57G56iYaQWtNICRL85yp0z3WG54wh5E4huvx4XeE3bK0QO+zZ3sefq
	 hJZZ7kgo3mbf3sZ7LJnWR8aiwGOt6ovllG67EpojaBjDpxenIi6uRMqjb2FUY7I96c
	 AqmC/QNKNgh+fCo+UyZsoSMIZiFyzpGPP07IxtsIiE+ONB5OMV4lS619ISEPpFz5AO
	 NVaZDM7D8W9MIzm2fERUstSwxQfY4In+jlWiGlKngnOiu5xveu/83X5ccg8qpg10Xq
	 k14i9zw0F3oyvcwV90zowxLw5arxRU3sPRcztwVlrpjMjAqjPDL6S0vlqMTbhUPULL
	 Nl4D6k/lilzfQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mario Limonciello <mario.limonciello@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	harry.wentland@amd.com,
	sunpeng.li@amd.com,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	chiahsuan.chung@amd.com,
	Wayne.Lin@amd.com,
	aurabindo.pillai@amd.com,
	dominik.kaszewski@amd.com,
	mwen@igalia.com,
	Roman.Li@amd.com,
	hamzamahfooz@linux.microsoft.com,
	lumag@kernel.org,
	linux-kernel@vger.kernel.org,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.14 061/102] drm/amd/display: Restructure DMI quirks
Date: Sun,  1 Jun 2025 19:28:53 -0400
Message-Id: <20250601232937.3510379-61-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250601232937.3510379-1-sashal@kernel.org>
References: <20250601232937.3510379-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.9
Content-Transfer-Encoding: 8bit

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit de6485e3df24170d71706d6f2c55a496443c3803 ]

[Why]
DMI quirks are relatively big code that makes amdgpu_dm 200 lines
larger.

[How]
Move DMI quirks into a dedicated source file and make all quirks
variables for `struct amdgpu_display_manager`.

Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Ray Wu <ray.wu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

NO This commit should **not** be backported to stable kernel trees.
Here's my detailed analysis: **Reasons Against Backporting:** 1. **Pure
Code Restructuring Without Bug Fixes**: This commit is explicitly a
refactoring change that moves DMI quirks code from `amdgpu_dm.c` to a
new dedicated file `amdgpu_dm_quirks.c`. The commit message clearly
states the motivation is to reduce the size of `amdgpu_dm.c` by 200
lines, not to fix any bugs or address user-facing issues. 2. **No
Functional Changes**: Examining the code changes reveals this is purely
organizational: - The same DMI quirk table entries are moved verbatim
from `amdgpu_dm.c` to `amdgpu_dm_quirks.c` - The same callback functions
(`edp0_on_dp1_callback`, `aux_hpd_discon_callback`) are preserved - The
logic in `retrieve_dmi_info()` remains functionally identical, just
relocated - The quirk variables are moved from a local static structure
to fields in `struct amdgpu_display_manager` 3. **Architectural Change
Rather Than Stability Fix**: The commit introduces: - A new source file
(`amdgpu_dm_quirks.c`) - Updates to the Makefile to include the new file
- Header changes to expose the `retrieve_dmi_info()` function -
Structural changes to how quirk data is stored (moving from static
variables to struct members) 4. **Follows Pattern of Non-Backportable
Commits**: Looking at the similar commits provided: - Similar Commit #1
(Status: NO) was a merge/restructuring commit that combined files -
Similar Commit #5 (Status: NO) was a simple message fix - The "YES"
status commits were all functional fixes addressing specific bugs or
adding hardware support 5. **Risk vs. Benefit Analysis**: - **Risk**:
Introduces potential for merge conflicts, build issues, or subtle
behavioral changes in stable kernels - **Benefit**: Zero functional
improvement for end users - purely improves code organization for
developers 6. **Stable Tree Policy Violation**: This change violates the
stable tree principle of only including important bug fixes. Code
reorganization, while beneficial for future development, doesn't meet
the criteria for stable backporting. The commit is a good software
engineering practice for the main development tree but represents
exactly the type of change that should remain in the development kernel
and not be backported to stable releases where the focus should be on
critical fixes and hardware support.

 .../gpu/drm/amd/display/amdgpu_dm/Makefile    |   1 +
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 152 +--------------
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h |   9 +
 .../amd/display/amdgpu_dm/amdgpu_dm_quirks.c  | 178 ++++++++++++++++++
 4 files changed, 191 insertions(+), 149 deletions(-)
 create mode 100644 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_quirks.c

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/Makefile b/drivers/gpu/drm/amd/display/amdgpu_dm/Makefile
index ab2a97e354da1..7329b8cc2576e 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/Makefile
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/Makefile
@@ -38,6 +38,7 @@ AMDGPUDM = \
 	amdgpu_dm_pp_smu.o \
 	amdgpu_dm_psr.o \
 	amdgpu_dm_replay.o \
+	amdgpu_dm_quirks.o \
 	amdgpu_dm_wb.o
 
 ifdef CONFIG_DRM_AMD_DC_FP
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 2cd7adea178d5..250e0a726feb2 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -80,7 +80,6 @@
 #include <linux/power_supply.h>
 #include <linux/firmware.h>
 #include <linux/component.h>
-#include <linux/dmi.h>
 #include <linux/sort.h>
 
 #include <drm/display/drm_dp_mst_helper.h>
@@ -1630,153 +1629,6 @@ static bool dm_should_disable_stutter(struct pci_dev *pdev)
 	return false;
 }
 
-struct amdgpu_dm_quirks {
-	bool aux_hpd_discon;
-	bool support_edp0_on_dp1;
-};
-
-static struct amdgpu_dm_quirks quirk_entries = {
-	.aux_hpd_discon = false,
-	.support_edp0_on_dp1 = false
-};
-
-static int edp0_on_dp1_callback(const struct dmi_system_id *id)
-{
-	quirk_entries.support_edp0_on_dp1 = true;
-	return 0;
-}
-
-static int aux_hpd_discon_callback(const struct dmi_system_id *id)
-{
-	quirk_entries.aux_hpd_discon = true;
-	return 0;
-}
-
-static const struct dmi_system_id dmi_quirk_table[] = {
-	{
-		.callback = aux_hpd_discon_callback,
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Precision 3660"),
-		},
-	},
-	{
-		.callback = aux_hpd_discon_callback,
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Precision 3260"),
-		},
-	},
-	{
-		.callback = aux_hpd_discon_callback,
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Precision 3460"),
-		},
-	},
-	{
-		.callback = aux_hpd_discon_callback,
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex Tower Plus 7010"),
-		},
-	},
-	{
-		.callback = aux_hpd_discon_callback,
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex Tower 7010"),
-		},
-	},
-	{
-		.callback = aux_hpd_discon_callback,
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex SFF Plus 7010"),
-		},
-	},
-	{
-		.callback = aux_hpd_discon_callback,
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex SFF 7010"),
-		},
-	},
-	{
-		.callback = aux_hpd_discon_callback,
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex Micro Plus 7010"),
-		},
-	},
-	{
-		.callback = aux_hpd_discon_callback,
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex Micro 7010"),
-		},
-	},
-	{
-		.callback = edp0_on_dp1_callback,
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "HP Elite mt645 G8 Mobile Thin Client"),
-		},
-	},
-	{
-		.callback = edp0_on_dp1_callback,
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "HP EliteBook 645 14 inch G11 Notebook PC"),
-		},
-	},
-	{
-		.callback = edp0_on_dp1_callback,
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "HP EliteBook 665 16 inch G11 Notebook PC"),
-		},
-	},
-	{
-		.callback = edp0_on_dp1_callback,
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "HP ProBook 445 14 inch G11 Notebook PC"),
-		},
-	},
-	{
-		.callback = edp0_on_dp1_callback,
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "HP ProBook 465 16 inch G11 Notebook PC"),
-		},
-	},
-	{}
-	/* TODO: refactor this from a fixed table to a dynamic option */
-};
-
-static void retrieve_dmi_info(struct amdgpu_display_manager *dm, struct dc_init_data *init_data)
-{
-	int dmi_id;
-	struct drm_device *dev = dm->ddev;
-
-	dm->aux_hpd_discon_quirk = false;
-	init_data->flags.support_edp0_on_dp1 = false;
-
-	dmi_id = dmi_check_system(dmi_quirk_table);
-
-	if (!dmi_id)
-		return;
-
-	if (quirk_entries.aux_hpd_discon) {
-		dm->aux_hpd_discon_quirk = true;
-		drm_info(dev, "aux_hpd_discon_quirk attached\n");
-	}
-	if (quirk_entries.support_edp0_on_dp1) {
-		init_data->flags.support_edp0_on_dp1 = true;
-		drm_info(dev, "support_edp0_on_dp1 attached\n");
-	}
-}
 
 void*
 dm_allocate_gpu_mem(
@@ -2062,7 +1914,9 @@ static int amdgpu_dm_init(struct amdgpu_device *adev)
 	if (amdgpu_ip_version(adev, DCE_HWIP, 0) >= IP_VERSION(3, 0, 0))
 		init_data.num_virtual_links = 1;
 
-	retrieve_dmi_info(&adev->dm, &init_data);
+	retrieve_dmi_info(&adev->dm);
+	if (adev->dm.edp0_on_dp1_quirk)
+		init_data.flags.support_edp0_on_dp1 = true;
 
 	if (adev->dm.bb_from_dmub)
 		init_data.bb_from_dmub = adev->dm.bb_from_dmub;
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
index 195fec9048df7..330e4c5c33f06 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
@@ -593,6 +593,13 @@ struct amdgpu_display_manager {
 	 */
 	bool aux_hpd_discon_quirk;
 
+	/**
+	 * @edp0_on_dp1_quirk:
+	 *
+	 * quirk for platforms that put edp0 on DP1.
+	 */
+	bool edp0_on_dp1_quirk;
+
 	/**
 	 * @dpia_aux_lock:
 	 *
@@ -1018,4 +1025,6 @@ void hdmi_cec_set_edid(struct amdgpu_dm_connector *aconnector);
 void hdmi_cec_unset_edid(struct amdgpu_dm_connector *aconnector);
 int amdgpu_dm_initialize_hdmi_connector(struct amdgpu_dm_connector *aconnector);
 
+void retrieve_dmi_info(struct amdgpu_display_manager *dm);
+
 #endif /* __AMDGPU_DM_H__ */
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_quirks.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_quirks.c
new file mode 100644
index 0000000000000..1da07ebf9217c
--- /dev/null
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_quirks.c
@@ -0,0 +1,178 @@
+// SPDX-License-Identifier: MIT
+/*
+ * Copyright 2025 Advanced Micro Devices, Inc.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicense,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
+ * THE COPYRIGHT HOLDER(S) OR AUTHOR(S) BE LIABLE FOR ANY CLAIM, DAMAGES OR
+ * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
+ * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
+ * OTHER DEALINGS IN THE SOFTWARE.
+ *
+ * Authors: AMD
+ *
+ */
+
+#include <linux/dmi.h>
+
+#include "amdgpu.h"
+#include "amdgpu_dm.h"
+
+struct amdgpu_dm_quirks {
+	bool aux_hpd_discon;
+	bool support_edp0_on_dp1;
+};
+
+static struct amdgpu_dm_quirks quirk_entries = {
+	.aux_hpd_discon = false,
+	.support_edp0_on_dp1 = false
+};
+
+static int edp0_on_dp1_callback(const struct dmi_system_id *id)
+{
+	quirk_entries.support_edp0_on_dp1 = true;
+	return 0;
+}
+
+static int aux_hpd_discon_callback(const struct dmi_system_id *id)
+{
+	quirk_entries.aux_hpd_discon = true;
+	return 0;
+}
+
+static const struct dmi_system_id dmi_quirk_table[] = {
+	{
+		.callback = aux_hpd_discon_callback,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Precision 3660"),
+		},
+	},
+	{
+		.callback = aux_hpd_discon_callback,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Precision 3260"),
+		},
+	},
+	{
+		.callback = aux_hpd_discon_callback,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Precision 3460"),
+		},
+	},
+	{
+		.callback = aux_hpd_discon_callback,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex Tower Plus 7010"),
+		},
+	},
+	{
+		.callback = aux_hpd_discon_callback,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex Tower 7010"),
+		},
+	},
+	{
+		.callback = aux_hpd_discon_callback,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex SFF Plus 7010"),
+		},
+	},
+	{
+		.callback = aux_hpd_discon_callback,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex SFF 7010"),
+		},
+	},
+	{
+		.callback = aux_hpd_discon_callback,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex Micro Plus 7010"),
+		},
+	},
+	{
+		.callback = aux_hpd_discon_callback,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex Micro 7010"),
+		},
+	},
+	{
+		.callback = edp0_on_dp1_callback,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "HP Elite mt645 G8 Mobile Thin Client"),
+		},
+	},
+	{
+		.callback = edp0_on_dp1_callback,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "HP EliteBook 645 14 inch G11 Notebook PC"),
+		},
+	},
+	{
+		.callback = edp0_on_dp1_callback,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "HP EliteBook 665 16 inch G11 Notebook PC"),
+		},
+	},
+	{
+		.callback = edp0_on_dp1_callback,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "HP ProBook 445 14 inch G11 Notebook PC"),
+		},
+	},
+	{
+		.callback = edp0_on_dp1_callback,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "HP ProBook 465 16 inch G11 Notebook PC"),
+		},
+	},
+	{}
+	/* TODO: refactor this from a fixed table to a dynamic option */
+};
+
+void retrieve_dmi_info(struct amdgpu_display_manager *dm)
+{
+	struct drm_device *dev = dm->ddev;
+	int dmi_id;
+
+	dm->aux_hpd_discon_quirk = false;
+	dm->edp0_on_dp1_quirk = false;
+
+	dmi_id = dmi_check_system(dmi_quirk_table);
+
+	if (!dmi_id)
+		return;
+
+	if (quirk_entries.aux_hpd_discon) {
+		dm->aux_hpd_discon_quirk = true;
+		drm_info(dev, "aux_hpd_discon_quirk attached\n");
+	}
+	if (quirk_entries.support_edp0_on_dp1) {
+		dm->edp0_on_dp1_quirk = true;
+		drm_info(dev, "support_edp0_on_dp1 attached\n");
+	}
+}
-- 
2.39.5


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B79CA25F7AD;
	Wed, 23 Apr 2025 15:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421663; cv=none; b=sygfYZNJCXOPj2pkKqJY9PP0lijlFlYbNjNGitmZkvBtPLl6ncKGPYeCE0kZHn/WbUZ/37U7Iy7hOXsIEQNZg3XOquRBfpnprhZ7pjLxU3GDwKA7PlNU+nCHb0e2CNeezuSzvIRZgTSX9RUPdhiRlchrJFzquAEym6QynMCpeTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421663; c=relaxed/simple;
	bh=1EiJT7MHQbsIdVHsSS+v+N1zuSwrc+ewB0LqRy+pivw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IElp8xuSWNanbbIzhtP4SmpKsDFx2FT2/5f98CzcInleLtaaxvH4JQHrS+AsJuRhk0NMHh1AnsVwycQWWCfXzvN1kGvoGAITEWovwQ0V9w7RhXDChtRYrlCKv7GdFtFh2Myao08Q9c2XFhtoFYWVPuijmOW0bptgM8dyDhMBCl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QTecdKYg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QTecdKYg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4289AC4CEE8;
	Wed, 23 Apr 2025 15:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421663;
	bh=1EiJT7MHQbsIdVHsSS+v+N1zuSwrc+ewB0LqRy+pivw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QTecdKYgK0zLI63qP2NMT5tB4bBm/WJLLYHona6hO0ZzHQz9m48SRITBSgjlVX2QO
	 ytKfYv/c72dtAbIP9Sl12WMft6xlPYtm39K5Zgr6svObOAR9xv6BkjytxROUo79PQe
	 FPQD7A/5RBqB4mqymOSw4ksBu+XnEKGPcsWmc678=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.14 217/241] drm/amd/display/dml2: use vzalloc rather than kzalloc
Date: Wed, 23 Apr 2025 16:44:41 +0200
Message-ID: <20250423142629.426409566@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

From: Alex Deucher <alexander.deucher@amd.com>

commit cd9e6d6fdd2de60bfb4672387c17d4ee7157cf8e upstream.

The structures are large and they do not require contiguous
memory so use vzalloc.

Fixes: 70839da63605 ("drm/amd/display: Add new DCN401 sources")
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4126
Cc: Aurabindo Pillai <aurabindo.pillai@amd.com>
Reviewed-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 20c50a9a793300a1fc82f3ddd0e3c68f8213fbef)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_wrapper.c |   11 ++++++-----
 drivers/gpu/drm/amd/display/dc/dml2/dml2_wrapper.c        |    6 ++++--
 2 files changed, 10 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_wrapper.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_wrapper.c
@@ -2,6 +2,7 @@
 //
 // Copyright 2024 Advanced Micro Devices, Inc.
 
+#include <linux/vmalloc.h>
 
 #include "dml2_internal_types.h"
 #include "dml_top.h"
@@ -13,11 +14,11 @@
 
 static bool dml21_allocate_memory(struct dml2_context **dml_ctx)
 {
-	*dml_ctx = kzalloc(sizeof(struct dml2_context), GFP_KERNEL);
+	*dml_ctx = vzalloc(sizeof(struct dml2_context));
 	if (!(*dml_ctx))
 		return false;
 
-	(*dml_ctx)->v21.dml_init.dml2_instance = kzalloc(sizeof(struct dml2_instance), GFP_KERNEL);
+	(*dml_ctx)->v21.dml_init.dml2_instance = vzalloc(sizeof(struct dml2_instance));
 	if (!((*dml_ctx)->v21.dml_init.dml2_instance))
 		return false;
 
@@ -27,7 +28,7 @@ static bool dml21_allocate_memory(struct
 	(*dml_ctx)->v21.mode_support.display_config = &(*dml_ctx)->v21.display_config;
 	(*dml_ctx)->v21.mode_programming.display_config = (*dml_ctx)->v21.mode_support.display_config;
 
-	(*dml_ctx)->v21.mode_programming.programming = kzalloc(sizeof(struct dml2_display_cfg_programming), GFP_KERNEL);
+	(*dml_ctx)->v21.mode_programming.programming = vzalloc(sizeof(struct dml2_display_cfg_programming));
 	if (!((*dml_ctx)->v21.mode_programming.programming))
 		return false;
 
@@ -115,8 +116,8 @@ bool dml21_create(const struct dc *in_dc
 
 void dml21_destroy(struct dml2_context *dml2)
 {
-	kfree(dml2->v21.dml_init.dml2_instance);
-	kfree(dml2->v21.mode_programming.programming);
+	vfree(dml2->v21.dml_init.dml2_instance);
+	vfree(dml2->v21.mode_programming.programming);
 }
 
 static void dml21_calculate_rq_and_dlg_params(const struct dc *dc, struct dc_state *context, struct resource_context *out_new_hw_state,
--- a/drivers/gpu/drm/amd/display/dc/dml2/dml2_wrapper.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml2_wrapper.c
@@ -24,6 +24,8 @@
  *
  */
 
+#include <linux/vmalloc.h>
+
 #include "display_mode_core.h"
 #include "dml2_internal_types.h"
 #include "dml2_utils.h"
@@ -747,7 +749,7 @@ bool dml2_validate(const struct dc *in_d
 
 static inline struct dml2_context *dml2_allocate_memory(void)
 {
-	return (struct dml2_context *) kzalloc(sizeof(struct dml2_context), GFP_KERNEL);
+	return (struct dml2_context *) vzalloc(sizeof(struct dml2_context));
 }
 
 static void dml2_init(const struct dc *in_dc, const struct dml2_configuration_options *config, struct dml2_context **dml2)
@@ -815,7 +817,7 @@ void dml2_destroy(struct dml2_context *d
 
 	if (dml2->architecture == dml2_architecture_21)
 		dml21_destroy(dml2);
-	kfree(dml2);
+	vfree(dml2);
 }
 
 void dml2_extract_dram_and_fclk_change_support(struct dml2_context *dml2,



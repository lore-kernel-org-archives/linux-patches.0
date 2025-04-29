Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 757AD82C60;
	Tue, 29 Apr 2025 17:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947603; cv=none; b=BW3nH6a/I7aCa4dq93w7XjhyaUrsBZEkYCTLAVpE15NM6O0KscSpW2t3Y5mCfRKUG4qMRQz1Og3GnqcNn26WKVlFh3CntauK8v5lT+queT+W37A8uvq5gC7OA8OxLeuJA2NzrswIQo5NLLpTmsBa6qf1y42uXFn30Ojch5cE2lQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947603; c=relaxed/simple;
	bh=04cfMzGGoff2MCzLGlDhncJQi+O2q6p+BXdaGeEfkgM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cuvHv+TRsrKEIVBSXFufuqdy1iv2V+exj3Bwt7FzOJ9AOIl6fngYf/Zu99t5nQlzlfbnH5JMJgEhgwN4Nsz8DTj2k48buvhDNW7UMzoJR1lB/vV6NWRLob28MkNn/+FUCk2tSvWurgUSbdo57cwB7L0sNjAsDltPR+h4it9st5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FRhWwoeJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FRhWwoeJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 797D0C4CEE3;
	Tue, 29 Apr 2025 17:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947602;
	bh=04cfMzGGoff2MCzLGlDhncJQi+O2q6p+BXdaGeEfkgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FRhWwoeJBuPWAMnes9geUnAhZV3xBJDq0mP5rDmxebT6/c4jE+SjGgDcJPaRSVb8i
	 jKV0QP4R4t5aEMEPTPoH64ddoncrRC3UQJTRJ8mHc6fJA9v2g6ntfWRzinoJq0F4Ew
	 xDMED5lE2yEjYCSsXsT0I07xXoaXfrGaiSr5PhnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 048/280] drm/amd/display/dml2: use vzalloc rather than kzalloc
Date: Tue, 29 Apr 2025 18:39:49 +0200
Message-ID: <20250429161117.083641422@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit cd9e6d6fdd2de60bfb4672387c17d4ee7157cf8e ]

The structures are large and they do not require contiguous
memory so use vzalloc.

Fixes: 70839da63605 ("drm/amd/display: Add new DCN401 sources")
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4126
Cc: Aurabindo Pillai <aurabindo.pillai@amd.com>
Reviewed-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 20c50a9a793300a1fc82f3ddd0e3c68f8213fbef)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/dml2/dml21/dml21_wrapper.c | 11 ++++++-----
 drivers/gpu/drm/amd/display/dc/dml2/dml2_wrapper.c    |  6 ++++--
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_wrapper.c b/drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_wrapper.c
index dedf0fd3eb276..e3e4f40bd4123 100644
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
 
@@ -27,7 +28,7 @@ static bool dml21_allocate_memory(struct dml2_context **dml_ctx)
 	(*dml_ctx)->v21.mode_support.display_config = &(*dml_ctx)->v21.display_config;
 	(*dml_ctx)->v21.mode_programming.display_config = (*dml_ctx)->v21.mode_support.display_config;
 
-	(*dml_ctx)->v21.mode_programming.programming = kzalloc(sizeof(struct dml2_display_cfg_programming), GFP_KERNEL);
+	(*dml_ctx)->v21.mode_programming.programming = vzalloc(sizeof(struct dml2_display_cfg_programming));
 	if (!((*dml_ctx)->v21.mode_programming.programming))
 		return false;
 
@@ -116,8 +117,8 @@ bool dml21_create(const struct dc *in_dc, struct dml2_context **dml_ctx, const s
 
 void dml21_destroy(struct dml2_context *dml2)
 {
-	kfree(dml2->v21.dml_init.dml2_instance);
-	kfree(dml2->v21.mode_programming.programming);
+	vfree(dml2->v21.dml_init.dml2_instance);
+	vfree(dml2->v21.mode_programming.programming);
 }
 
 static void dml21_calculate_rq_and_dlg_params(const struct dc *dc, struct dc_state *context, struct resource_context *out_new_hw_state,
diff --git a/drivers/gpu/drm/amd/display/dc/dml2/dml2_wrapper.c b/drivers/gpu/drm/amd/display/dc/dml2/dml2_wrapper.c
index cb2cb89dfecb2..03812f862b3d6 100644
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
@@ -749,7 +751,7 @@ bool dml2_validate(const struct dc *in_dc, struct dc_state *context, struct dml2
 
 static inline struct dml2_context *dml2_allocate_memory(void)
 {
-	return (struct dml2_context *) kzalloc(sizeof(struct dml2_context), GFP_KERNEL);
+	return (struct dml2_context *) vzalloc(sizeof(struct dml2_context));
 }
 
 static void dml2_init(const struct dc *in_dc, const struct dml2_configuration_options *config, struct dml2_context **dml2)
@@ -820,7 +822,7 @@ void dml2_destroy(struct dml2_context *dml2)
 
 	if (dml2->architecture == dml2_architecture_21)
 		dml21_destroy(dml2);
-	kfree(dml2);
+	vfree(dml2);
 }
 
 void dml2_extract_dram_and_fclk_change_support(struct dml2_context *dml2,
-- 
2.39.5




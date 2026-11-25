Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620898;
	b=Pp9lX49QW7FNDZGMlADKW74sZgwwSZc04yAOZgrpC0dUsJwcRpzU17jzWW9gV0uNR9Yv
	 zq8Q6PZKUXaqJAHJkSfnPJ+1RHurWYuT+v/MrrXuO9PYzFIM9aW9dxNGu9Fu8VdpQDEdk
	 4jILziDs+DFZAuB3L5+UItOf1PthS6Ff7tJ9KIeQXP3toG6pgrFZ4oH9Mzr2XW2Ki3PhY
	 UV2/5FDzsNzdcp0aztifXf3K0RiQFPsiUn8ifM+Yqb3q4aOsPvy9MW041VFU1TH4mjeMO
	 oDShuZrpUhqhIePS46PBgfVc6ReFyn67nvfixC+JFFRkeNU8YqeGUK7/9mBf9RBUGkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620898;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3r7kPA+R+yxbHgixpPUwnrVZRMCCZoQ+zc7wV22jYzc=;
	b=N0exRig0lwVXwT6IrWuWVDq2f9Zu3cFlKAuzWexDm4f5U9UUsnmslZeRhr8DZXqnM87v
	 lbuyxRq6eFnUH37pnqOEnKxDYbdz6iFPbP22KRz/Y5boqeUjHFgUIS+/lLOrb4heVQ+HH
	 vV1dD4IqEdHo+hKWwqT7POUIfB/Kc5eQgJMM7itrftqbuLjpH35bCUpJV0preF0e/K0WK
	 L9iDgOzTNSl8UC/9WDXNTfYHCQu0BiLSc1jM6C3DRGOBhEG7mDH1nDKZx/kLlYy7vD0+G
	 YtQu5ZPy8B8ZpOl8j5q5FnkQK0uW4Eq+aoAr+TLoTpxC1Xs0wDPs8snjNcRjs1fGk/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=maKaPAOS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8ED9606A327;
	Wed, 25 Nov 2026 15:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=maKaPAOS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF5E81F000E1;
	Wed, 25 Nov 2026 15:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620898;
	bh=3r7kPA+R+yxbHgixpPUwnrVZRMCCZoQ+zc7wV22jYzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=maKaPAOS7y+O3VafCBm8YXsv/u0omufHeMj1WQowe28uLjx1WujYKbtvCVlIPbcj7
	 aCE61d2AMyOd4HRdPRezlMwY3qXWK2PNelDeAC9anRSP4vj906oL/QRnwqJ/yoDf+4
	 eBeoeMlWYMTnULD5A2oy2n4pFlpPYHEetI+agBj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Feng Ning <feng@innora.ai>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 056/990] staging: media: atomisp: use array3_size() for overflow-safe allocation
Date: Wed, 25 Nov 2026 15:23:43 +0100
Message-ID: <20261125143823.399694677@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Feng Ning <feng@innora.ai>

commit d178c7ca8fefc28115d35b94c3b1f4d653e34182 upstream.

Replace open-coded width * height * sizeof() multiplications with
array3_size() to prevent integer overflow in buffer allocations.

The atomisp driver computes DVS, morphing table, shading table and
statistics buffer sizes using unchecked arithmetic.  When dimensions
are attacker-controlled or simply large, the product can silently wrap,
causing kvmalloc() to allocate an undersized buffer.

array3_size() saturates to SIZE_MAX on overflow, so kvmalloc() returns
NULL instead of succeeding with too few bytes.

Signed-off-by: Feng Ning <feng@innora.ai>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../media/atomisp/pci/sh_css_param_dvs.c      | 11 +++---
 .../media/atomisp/pci/sh_css_param_shading.c  |  4 ++-
 .../staging/media/atomisp/pci/sh_css_params.c | 35 +++++++++++--------
 3 files changed, 31 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/sh_css_param_dvs.c b/drivers/staging/media/atomisp/pci/sh_css_param_dvs.c
index 7fa4aab35b061..19c82464b6867 100644
--- a/drivers/staging/media/atomisp/pci/sh_css_param_dvs.c
+++ b/drivers/staging/media/atomisp/pci/sh_css_param_dvs.c
@@ -4,6 +4,7 @@
  * Copyright (c) 2015, Intel Corporation.
  */
 
+#include <linux/overflow.h>
 #include "sh_css_param_dvs.h"
 #include <assert_support.h>
 #include <type_support.h>
@@ -49,7 +50,7 @@ alloc_dvs_6axis_table(const struct ia_css_resolution *frame_res,
 		}
 
 		/* Generate Y buffers  */
-		dvs_config->xcoords_y = kvmalloc(width_y * height_y * sizeof(uint32_t),
+		dvs_config->xcoords_y = kvmalloc(array3_size(width_y, height_y, sizeof(uint32_t)),
 						 GFP_KERNEL);
 		if (!dvs_config->xcoords_y) {
 			IA_CSS_ERROR("out of memory");
@@ -57,7 +58,7 @@ alloc_dvs_6axis_table(const struct ia_css_resolution *frame_res,
 			goto exit;
 		}
 
-		dvs_config->ycoords_y = kvmalloc(width_y * height_y * sizeof(uint32_t),
+		dvs_config->ycoords_y = kvmalloc(array3_size(width_y, height_y, sizeof(uint32_t)),
 						 GFP_KERNEL);
 		if (!dvs_config->ycoords_y) {
 			IA_CSS_ERROR("out of memory");
@@ -68,7 +69,8 @@ alloc_dvs_6axis_table(const struct ia_css_resolution *frame_res,
 		/* Generate UV buffers  */
 		IA_CSS_LOG("UV W %d H %d", width_uv, height_uv);
 
-		dvs_config->xcoords_uv = kvmalloc(width_uv * height_uv * sizeof(uint32_t),
+		dvs_config->xcoords_uv = kvmalloc(array3_size(width_uv, height_uv,
+							      sizeof(uint32_t)),
 						  GFP_KERNEL);
 		if (!dvs_config->xcoords_uv) {
 			IA_CSS_ERROR("out of memory");
@@ -76,7 +78,8 @@ alloc_dvs_6axis_table(const struct ia_css_resolution *frame_res,
 			goto exit;
 		}
 
-		dvs_config->ycoords_uv = kvmalloc(width_uv * height_uv * sizeof(uint32_t),
+		dvs_config->ycoords_uv = kvmalloc(array3_size(width_uv, height_uv,
+							      sizeof(uint32_t)),
 						  GFP_KERNEL);
 		if (!dvs_config->ycoords_uv) {
 			IA_CSS_ERROR("out of memory");
diff --git a/drivers/staging/media/atomisp/pci/sh_css_param_shading.c b/drivers/staging/media/atomisp/pci/sh_css_param_shading.c
index 513e272f2fdc0..cbe703f0f7bef 100644
--- a/drivers/staging/media/atomisp/pci/sh_css_param_shading.c
+++ b/drivers/staging/media/atomisp/pci/sh_css_param_shading.c
@@ -4,6 +4,7 @@
  * Copyright (c) 2015, Intel Corporation.
  */
 
+#include <linux/overflow.h>
 #include <linux/math.h>
 #include <linux/slab.h>
 
@@ -339,7 +340,8 @@ ia_css_shading_table_alloc(
 	me->fraction_bits = 0;
 	for (i = 0; i < IA_CSS_SC_NUM_COLORS; i++) {
 		me->data[i] =
-		    kvmalloc(width * height * sizeof(*me->data[0]),
+		    kvmalloc(array3_size(width, height,
+					 sizeof(*me->data[0])),
 			     GFP_KERNEL);
 		if (!me->data[i]) {
 			unsigned int j;
diff --git a/drivers/staging/media/atomisp/pci/sh_css_params.c b/drivers/staging/media/atomisp/pci/sh_css_params.c
index 11d62313c9086..dda55369b5bb4 100644
--- a/drivers/staging/media/atomisp/pci/sh_css_params.c
+++ b/drivers/staging/media/atomisp/pci/sh_css_params.c
@@ -4,6 +4,7 @@
  * Copyright (c) 2015, Intel Corporation.
  */
 
+#include <linux/overflow.h>
 #include <linux/math.h>
 
 #include "gdc_device.h"		/* gdc_lut_store(), ... */
@@ -1381,11 +1382,11 @@ struct ia_css_morph_table *ia_css_morph_table_allocate(
 	}
 
 	for (i = 0; i < IA_CSS_MORPH_TABLE_NUM_PLANES; i++) {
-		me->coordinates_x[i] = kvmalloc(height * width *
-						sizeof(*me->coordinates_x[i]),
+		me->coordinates_x[i] = kvmalloc(array3_size(height, width,
+							    sizeof(*me->coordinates_x[i])),
 						GFP_KERNEL);
-		me->coordinates_y[i] = kvmalloc(height * width *
-						sizeof(*me->coordinates_y[i]),
+		me->coordinates_y[i] = kvmalloc(array3_size(height, width,
+							    sizeof(*me->coordinates_y[i])),
 						GFP_KERNEL);
 
 		if ((!me->coordinates_x[i]) ||
@@ -4206,13 +4207,17 @@ ia_css_dvs_statistics_allocate(const struct ia_css_dvs_grid_info *grid)
 		goto err;
 
 	me->grid = *grid;
-	me->hor_proj = kvmalloc(grid->height * IA_CSS_DVS_NUM_COEF_TYPES *
-				sizeof(*me->hor_proj), GFP_KERNEL);
+	me->hor_proj = kvmalloc(array3_size(grid->height,
+					    IA_CSS_DVS_NUM_COEF_TYPES,
+						sizeof(*me->hor_proj)),
+				GFP_KERNEL);
 	if (!me->hor_proj)
 		goto err;
 
-	me->ver_proj = kvmalloc(grid->width * IA_CSS_DVS_NUM_COEF_TYPES *
-				sizeof(*me->ver_proj), GFP_KERNEL);
+	me->ver_proj = kvmalloc(array3_size(grid->width,
+					    IA_CSS_DVS_NUM_COEF_TYPES,
+						sizeof(*me->ver_proj)),
+				GFP_KERNEL);
 	if (!me->ver_proj)
 		goto err;
 
@@ -4479,24 +4484,26 @@ ia_css_dvs2_6axis_config_allocate(const struct ia_css_stream *stream)
 				    params->pipe_dvs_6axis_config[IA_CSS_PIPE_ID_VIDEO]->height_uv;
 	IA_CSS_LOG("table Y: W %d H %d", width_y, height_y);
 	IA_CSS_LOG("table UV: W %d H %d", width_uv, height_uv);
-	dvs_config->xcoords_y = kvmalloc(width_y * height_y * sizeof(uint32_t),
+	dvs_config->xcoords_y = kvmalloc(array3_size(width_y, height_y,
+						     sizeof(uint32_t)),
 					 GFP_KERNEL);
 	if (!dvs_config->xcoords_y)
 		goto err;
 
-	dvs_config->ycoords_y = kvmalloc(width_y * height_y * sizeof(uint32_t),
+	dvs_config->ycoords_y = kvmalloc(array3_size(width_y, height_y,
+						     sizeof(uint32_t)),
 					 GFP_KERNEL);
 	if (!dvs_config->ycoords_y)
 		goto err;
 
-	dvs_config->xcoords_uv = kvmalloc(width_uv * height_uv *
-					  sizeof(uint32_t),
+	dvs_config->xcoords_uv = kvmalloc(array3_size(width_uv, height_uv,
+						      sizeof(uint32_t)),
 					  GFP_KERNEL);
 	if (!dvs_config->xcoords_uv)
 		goto err;
 
-	dvs_config->ycoords_uv = kvmalloc(width_uv * height_uv *
-					  sizeof(uint32_t),
+	dvs_config->ycoords_uv = kvmalloc(array3_size(width_uv, height_uv,
+						      sizeof(uint32_t)),
 					  GFP_KERNEL);
 	if (!dvs_config->ycoords_uv)
 		goto err;
-- 
2.53.0




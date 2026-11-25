Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623967;
	b=sbcF3dX1LLzuZFDzeGSsf9aICaYmkdP4GYchw6FvwxAhsKj3SLaQYNnd5ISUqNZ3NU6c
	 5UZOqQVChe05RU7d8l+65Upe7HlScZP8SrO506gJ3tUOt4RNc/6/o2x7cbuxJYzfCf4/T
	 /A97+oQ7C2VuTrCNexStO5+fT6oFLD94Rj6JB9EgR5N+ZNkyT38LKFDnEFkl5seKGaBkY
	 q98oV8GUtfrho0XAzEpnUyrYm4UvZHrBnwVBfhBspkuOw2BcPSlGMY7/AeBKEJtBvO7RV
	 FjPI2cK0HJhCOBfVwUevPdLLqm1IiSc+zAvLIpm7S9I3Uu5dB7qubo9it6LiwvN8aJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623967;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zFk5H3z0J6ROGQBF3/wKTXwPx7RGff9rhp8O7/sYhec=;
	b=nskLOlKvfmXKCfTVjWM+KHehTWX4IY9BVn9pHl3VKhrfJqPGMR5HpuHFHKJRcp19SakG
	 EESfMn8XJvyCxiRAWkzhCgwjZ7ecj0ZfJUNjrZ4Q/jKGqNoackqBpBY3q3azMmfTRYRsk
	 AL5bIko68T30M+m1nJV/5NGFypvppV6RBa+53vceav8vHHTBhP0Hez0sscFmKImYv6Gb5
	 oRyhESUdakguFwcgPKoURRR4TBZFEMefxhzLL+tNI7/2+GXWqsXkq5gadc3FhNO2MaHql
	 lH2ozV7ngVPqFNsZejyTQRkHaMEaSkccmOwrRZCQ4xaEVl8PwKAkEOjziRPtNeqCkTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NTTAKayT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62976606A326;
	Wed, 25 Nov 2026 16:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NTTAKayT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87C011F000C6;
	Wed, 25 Nov 2026 16:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623967;
	bh=zFk5H3z0J6ROGQBF3/wKTXwPx7RGff9rhp8O7/sYhec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NTTAKayTgbWVCOdDssIj6Qvip8XK3iWoBGbb3apf4PAChFhMt0V+YOFfSwhiHUgoe
	 TMXHgGF2IbBMeJkPww/PsjUULdFV7hnIY9tSb+QTt1ahpUAEhk1XUKKoZImQ+U86Bw
	 tvcH/A/p7lOekKxsyJb40CovC6ZOSlMzNyd41ojM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Feng Ning <feng@innora.ai>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 044/816] staging: media: atomisp: use array3_size() for overflow-safe allocation
Date: Wed, 25 Nov 2026 15:26:32 +0100
Message-ID: <20261125143850.241883184@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 5174bc210ae17..f70dd99030e9e 100644
--- a/drivers/staging/media/atomisp/pci/sh_css_param_dvs.c
+++ b/drivers/staging/media/atomisp/pci/sh_css_param_dvs.c
@@ -13,6 +13,7 @@
  * more details.
  */
 
+#include <linux/overflow.h>
 #include "sh_css_param_dvs.h"
 #include <assert_support.h>
 #include <type_support.h>
@@ -58,7 +59,7 @@ alloc_dvs_6axis_table(const struct ia_css_resolution *frame_res,
 		}
 
 		/* Generate Y buffers  */
-		dvs_config->xcoords_y = kvmalloc(width_y * height_y * sizeof(uint32_t),
+		dvs_config->xcoords_y = kvmalloc(array3_size(width_y, height_y, sizeof(uint32_t)),
 						 GFP_KERNEL);
 		if (!dvs_config->xcoords_y) {
 			IA_CSS_ERROR("out of memory");
@@ -66,7 +67,7 @@ alloc_dvs_6axis_table(const struct ia_css_resolution *frame_res,
 			goto exit;
 		}
 
-		dvs_config->ycoords_y = kvmalloc(width_y * height_y * sizeof(uint32_t),
+		dvs_config->ycoords_y = kvmalloc(array3_size(width_y, height_y, sizeof(uint32_t)),
 						 GFP_KERNEL);
 		if (!dvs_config->ycoords_y) {
 			IA_CSS_ERROR("out of memory");
@@ -77,7 +78,8 @@ alloc_dvs_6axis_table(const struct ia_css_resolution *frame_res,
 		/* Generate UV buffers  */
 		IA_CSS_LOG("UV W %d H %d", width_uv, height_uv);
 
-		dvs_config->xcoords_uv = kvmalloc(width_uv * height_uv * sizeof(uint32_t),
+		dvs_config->xcoords_uv = kvmalloc(array3_size(width_uv, height_uv,
+							      sizeof(uint32_t)),
 						  GFP_KERNEL);
 		if (!dvs_config->xcoords_uv) {
 			IA_CSS_ERROR("out of memory");
@@ -85,7 +87,8 @@ alloc_dvs_6axis_table(const struct ia_css_resolution *frame_res,
 			goto exit;
 		}
 
-		dvs_config->ycoords_uv = kvmalloc(width_uv * height_uv * sizeof(uint32_t),
+		dvs_config->ycoords_uv = kvmalloc(array3_size(width_uv, height_uv,
+							      sizeof(uint32_t)),
 						  GFP_KERNEL);
 		if (!dvs_config->ycoords_uv) {
 			IA_CSS_ERROR("out of memory");
diff --git a/drivers/staging/media/atomisp/pci/sh_css_param_shading.c b/drivers/staging/media/atomisp/pci/sh_css_param_shading.c
index 5b43cc6562690..0441d7f47a610 100644
--- a/drivers/staging/media/atomisp/pci/sh_css_param_shading.c
+++ b/drivers/staging/media/atomisp/pci/sh_css_param_shading.c
@@ -13,6 +13,7 @@
  * more details.
  */
 
+#include <linux/overflow.h>
 #include <linux/math.h>
 #include <linux/slab.h>
 
@@ -348,7 +349,8 @@ ia_css_shading_table_alloc(
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
index b1feb6f6ebe89..76e0b475b12e9 100644
--- a/drivers/staging/media/atomisp/pci/sh_css_params.c
+++ b/drivers/staging/media/atomisp/pci/sh_css_params.c
@@ -13,6 +13,7 @@
  * more details.
  */
 
+#include <linux/overflow.h>
 #include "gdc_device.h"		/* gdc_lut_store(), ... */
 #include "isp.h"			/* ISP_VEC_ELEMBITS */
 #include "vamem.h"
@@ -1390,11 +1391,11 @@ struct ia_css_morph_table *ia_css_morph_table_allocate(
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
@@ -4215,13 +4216,17 @@ ia_css_dvs_statistics_allocate(const struct ia_css_dvs_grid_info *grid)
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
 
@@ -4488,24 +4493,26 @@ ia_css_dvs2_6axis_config_allocate(const struct ia_css_stream *stream)
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




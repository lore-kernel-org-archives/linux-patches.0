Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704904;
	b=1un3645mUDov2mSwKmxtyechVybz7mVO0RGJVGSdQtwIrOGTwhwJNzymj7jR55MBGiSJ
	 7k7ZnYyiiZRuRhcSsEL5AwVReiIFzi2jRg/vq9tlrM5gpBfKdU8NvRGDW0fchqCP/R10N
	 iAHMSw1OC2QWfDci8Pi9jUJ57WI8wzO0z/ktZBJREBhOFhch4FYEavCS1ECmCVHdacskz
	 O/58sdVyDyc5Rr0ISPlAE2CvAe78mX7Mrh6/GluWqzlGMlRi6TErdm7UBBCyuM//L1Nh0
	 RXdbTQWjOeqJf4wowZnCKKusBMkYep81754WtfoYoAknwsznjOq0fAjLYPQjzW2CF8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704904;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uwUkrsgG+D9fwCYlt/q8cJx7FM7Sd0OYyLguZDCqXM8=;
	b=fTb4Zs1/4/jZKUeWjfB9P1iAPA4sCxGIARGJ/30FTKRM2fRlMaBlpNWLarucHxYRZc3/
	 aa2yX0QFxe1Tax5nU3Tdxfxmk9xX0ZGMM4kldsc03mLL33rZThnMO/hTGXbpBoNjJHVoa
	 M/VIOAfUMSyYXiosPUyyYKdSC0SpkKnC7M+U/HuAHxv5lQSIH37O4U3KR+gFG2CLCJ3V9
	 UNWNKstBQFJlBEMyjyb78k7rdCtt19c0fl7qlvL+E8k5sjnf+CAC3NONG0182HF7OZpSL
	 jxvaJ0uNBVbIk+eWzkDkAvpQZPdX3j0IGk2YN3KM/AQylvkUAPhpSHRs9Sb7BXUxJSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=spFEtYal;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50371606A31E;
	Thu, 26 Nov 2026 14:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=spFEtYal
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08B241F000CF;
	Thu, 26 Nov 2026 14:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704903;
	bh=uwUkrsgG+D9fwCYlt/q8cJx7FM7Sd0OYyLguZDCqXM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=spFEtYalhW/lZ+DsUgvqmxG48oFJUp/1yseEQ6lJz5JoaWdcUm/Ccmr5TkXbmqNzx
	 T+w7uV36Veb+PH2V+l+gMu6IEhzSwVmB5IkelGPwkvhzXvr5/rUrkON/L7ts619ZJa
	 ILOrMPFLXCPaYwPJ21/OkgLXbYYhrQH6CYzoXXj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Feng Ning <feng@innora.ai>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 016/319] staging: media: atomisp: use array3_size() for overflow-safe allocation
Date: Thu, 26 Nov 2026 15:36:24 +0100
Message-ID: <20261126144007.106787630@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index ff0082d02af3e..0d08629797a47 100644
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
index 69cc4e423d8b1..460a8099af8e5 100644
--- a/drivers/staging/media/atomisp/pci/sh_css_param_shading.c
+++ b/drivers/staging/media/atomisp/pci/sh_css_param_shading.c
@@ -13,6 +13,7 @@
  * more details.
  */
 
+#include <linux/overflow.h>
 #include <linux/slab.h>
 
 #include <math_support.h>
@@ -350,7 +351,8 @@ ia_css_shading_table_alloc(
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
index 85cf280bd12a8..a7983a656a482 100644
--- a/drivers/staging/media/atomisp/pci/sh_css_params.c
+++ b/drivers/staging/media/atomisp/pci/sh_css_params.c
@@ -13,6 +13,7 @@
  * more details.
  */
 
+#include <linux/overflow.h>
 #include "gdc_device.h"		/* gdc_lut_store(), ... */
 #include "isp.h"			/* ISP_VEC_ELEMBITS */
 #include "vamem.h"
@@ -1402,11 +1403,11 @@ struct ia_css_morph_table *ia_css_morph_table_allocate(
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
@@ -4369,13 +4370,17 @@ ia_css_dvs_statistics_allocate(const struct ia_css_dvs_grid_info *grid)
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
 
@@ -4642,24 +4647,26 @@ ia_css_dvs2_6axis_config_allocate(const struct ia_css_stream *stream)
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




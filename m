Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED0E22A7E4;
	Thu, 12 Dec 2024 16:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022082; cv=none; b=lU29rdd/Aiha9qkPQFlgzH35fk3ndqvUbIRQsgbE1xGfItm6z1645kbyLw3RX5sCx2KStfiiFGW9H4HOuez7SsTFCAdkH17ZMukHwfjnKcNKDFZH4aXDteHN6zd2o4w5o6t3P+ZNwTLLHCjGc5DEbWkL5ZnCztST1r9HKdBuoc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022082; c=relaxed/simple;
	bh=to2ElEYT1dP/EB2PMkrk3YR3lvHqS9u/udmpJfjz6mc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eRoe634kX14kNu/mZzSU/38b8Mwmsg+e1jxKeNwLn5/yRwzUJqrTEZ+JQpfwSQSeF1KEW49VjRJbZ/DENC3Uh9a8ilEAhlGSvGdLuEGmRAjJgiWFf4B2zrOLImwhWJTUcwxlCLL9CUTU/mtM9NZjI65f0GQ5JLfp03y5/Ce/7/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZYXq2XWW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZYXq2XWW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F19EAC4CECE;
	Thu, 12 Dec 2024 16:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022082;
	bh=to2ElEYT1dP/EB2PMkrk3YR3lvHqS9u/udmpJfjz6mc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZYXq2XWWF7ygmUNClMTIF1BsWGe4/PYogwafzj3Cc7j8TM7rta0kwcFw46qzFame6
	 TPFbNumQT2lMpz1Lb9nnGDLbLDjNSR27ooiDtr49r9wMRcjtE+lfW3WmNNUJjtdBCx
	 Ng3lwBWhgMnCnicoFD81as9JtUwa4AZLlQAa2BGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 142/565] media: atomisp: remove #ifdef HAS_NO_HMEM
Date: Thu, 12 Dec 2024 15:55:37 +0100
Message-ID: <20241212144317.101164085@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

[ Upstream commit 63705da3dfc8922a2dbfc3c805a5faadb4416954 ]

This is not defined anywhere, so, solve the ifdefs, getting
rid of them.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Stable-dep-of: ed61c5913950 ("media: atomisp: Add check for rgby_data memory allocation failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../atomisp/pci/isp/kernels/bh/bh_2/ia_css_bh.host.c   |  2 --
 .../raw_aa_binning_1.0/ia_css_raa.host.c               |  2 --
 .../pci/isp/kernels/s3a/s3a_1.0/ia_css_s3a.host.c      |  5 -----
 .../media/atomisp/pci/runtime/binary/src/binary.c      |  4 ----
 drivers/staging/media/atomisp/pci/sh_css_params.c      | 10 ----------
 5 files changed, 23 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/isp/kernels/bh/bh_2/ia_css_bh.host.c b/drivers/staging/media/atomisp/pci/isp/kernels/bh/bh_2/ia_css_bh.host.c
index 82aa69b74677c..2091f001502d4 100644
--- a/drivers/staging/media/atomisp/pci/isp/kernels/bh/bh_2/ia_css_bh.host.c
+++ b/drivers/staging/media/atomisp/pci/isp/kernels/bh/bh_2/ia_css_bh.host.c
@@ -13,7 +13,6 @@
  * more details.
  */
 
-#if !defined(HAS_NO_HMEM)
 
 #include "ia_css_types.h"
 #include "sh_css_internal.h"
@@ -63,4 +62,3 @@ ia_css_bh_encode(
 	    uDIGIT_FITTING(from->ae_y_coef_b, 16, SH_CSS_AE_YCOEF_SHIFT);
 }
 
-#endif
diff --git a/drivers/staging/media/atomisp/pci/isp/kernels/raw_aa_binning/raw_aa_binning_1.0/ia_css_raa.host.c b/drivers/staging/media/atomisp/pci/isp/kernels/raw_aa_binning/raw_aa_binning_1.0/ia_css_raa.host.c
index 29c707ecf9f3b..9b756daddee06 100644
--- a/drivers/staging/media/atomisp/pci/isp/kernels/raw_aa_binning/raw_aa_binning_1.0/ia_css_raa.host.c
+++ b/drivers/staging/media/atomisp/pci/isp/kernels/raw_aa_binning/raw_aa_binning_1.0/ia_css_raa.host.c
@@ -13,7 +13,6 @@
  * more details.
  */
 
-#if !defined(HAS_NO_HMEM)
 
 #include "ia_css_types.h"
 #include "sh_css_internal.h"
@@ -32,4 +31,3 @@ ia_css_raa_encode(
 	(void)from;
 }
 
-#endif
diff --git a/drivers/staging/media/atomisp/pci/isp/kernels/s3a/s3a_1.0/ia_css_s3a.host.c b/drivers/staging/media/atomisp/pci/isp/kernels/s3a/s3a_1.0/ia_css_s3a.host.c
index ba52c80df4a58..bd7b89d9475bf 100644
--- a/drivers/staging/media/atomisp/pci/isp/kernels/s3a/s3a_1.0/ia_css_s3a.host.c
+++ b/drivers/staging/media/atomisp/pci/isp/kernels/s3a/s3a_1.0/ia_css_s3a.host.c
@@ -227,10 +227,6 @@ ia_css_s3a_hmem_decode(
     struct ia_css_3a_statistics *host_stats,
     const struct ia_css_bh_table *hmem_buf)
 {
-#if defined(HAS_NO_HMEM)
-	(void)host_stats;
-	(void)hmem_buf;
-#else
 	struct ia_css_3a_rgby_output	*out_ptr;
 	int			i;
 
@@ -291,7 +287,6 @@ ia_css_s3a_hmem_decode(
 	out_ptr[0].g -= diff;
 	out_ptr[0].b -= diff;
 	out_ptr[0].y -= diff;
-#endif
 }
 
 void
diff --git a/drivers/staging/media/atomisp/pci/runtime/binary/src/binary.c b/drivers/staging/media/atomisp/pci/runtime/binary/src/binary.c
index 060d387495704..002bd8cf28634 100644
--- a/drivers/staging/media/atomisp/pci/runtime/binary/src/binary.c
+++ b/drivers/staging/media/atomisp/pci/runtime/binary/src/binary.c
@@ -805,11 +805,7 @@ ia_css_binary_3a_grid_info(const struct ia_css_binary *binary,
 	s3a_info->deci_factor_log2  = binary->deci_factor_log2;
 	s3a_info->elem_bit_depth    = SH_CSS_BAYER_BITS;
 	s3a_info->use_dmem          = binary->info->sp.s3a.s3atbl_use_dmem;
-#if defined(HAS_NO_HMEM)
-	s3a_info->has_histogram     = 1;
-#else
 	s3a_info->has_histogram     = 0;
-#endif
 	IA_CSS_LEAVE_ERR_PRIVATE(err);
 	return err;
 }
diff --git a/drivers/staging/media/atomisp/pci/sh_css_params.c b/drivers/staging/media/atomisp/pci/sh_css_params.c
index deecffd438aeb..013eac639f669 100644
--- a/drivers/staging/media/atomisp/pci/sh_css_params.c
+++ b/drivers/staging/media/atomisp/pci/sh_css_params.c
@@ -16,12 +16,10 @@
 #include "gdc_device.h"		/* gdc_lut_store(), ... */
 #include "isp.h"			/* ISP_VEC_ELEMBITS */
 #include "vamem.h"
-#if !defined(HAS_NO_HMEM)
 #ifndef __INLINE_HMEM__
 #define __INLINE_HMEM__
 #endif
 #include "hmem.h"
-#endif /* !defined(HAS_NO_HMEM) */
 #define IA_CSS_INCLUDE_PARAMETERS
 #define IA_CSS_INCLUDE_ACC_PARAMETERS
 
@@ -1510,10 +1508,8 @@ ia_css_translate_3a_statistics(
 		ia_css_s3a_vmem_decode(host_stats, isp_stats->vmem_stats_hi,
 				       isp_stats->vmem_stats_lo);
 	}
-#if !defined(HAS_NO_HMEM)
 	IA_CSS_LOG("3A: HMEM");
 	ia_css_s3a_hmem_decode(host_stats, isp_stats->hmem_stats);
-#endif
 
 	IA_CSS_LEAVE("void");
 }
@@ -2250,9 +2246,7 @@ ia_css_isp_3a_statistics_allocate(const struct ia_css_3a_grid_info *grid)
 		me->vmem_size = ISP_S3ATBL_HI_LO_STRIDE_BYTES *
 				grid->aligned_height;
 	}
-#if !defined(HAS_NO_HMEM)
 	me->hmem_size = sizeof_hmem(HMEM0_ID);
-#endif
 
 	/* All subsections need to be aligned to the system bus width */
 	me->dmem_size = CEIL_MUL(me->dmem_size, HIVE_ISP_DDR_WORD_BYTES);
@@ -4339,12 +4333,8 @@ ia_css_3a_statistics_allocate(const struct ia_css_3a_grid_info *grid)
 	me->data = kvmalloc(grid_size * sizeof(*me->data), GFP_KERNEL);
 	if (!me->data)
 		goto err;
-#if !defined(HAS_NO_HMEM)
 	/* No weighted histogram, no structure, treat the histogram data as a byte dump in a byte array */
 	me->rgby_data = kvmalloc(sizeof_hmem(HMEM0_ID), GFP_KERNEL);
-#else
-	me->rgby_data = NULL;
-#endif
 
 	IA_CSS_LEAVE("return=%p", me);
 	return me;
-- 
2.43.0




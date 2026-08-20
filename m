Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 249E137D12E;
	Thu, 20 Aug 2026 15:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238283; cv=none; b=HpPSMv/skAjafqa3aKtiesVkLI9tvbNoxdRDjwpaGRudtvzoQOmlFuTwUx/P5YmhXVIokcRBo/ZwIaug/Gy74hLqqrVLrM4lgHWhzxDr/p41ilR3pEH4w5rYA54aUM2gNNp7z2wO2w+yd92i60yz3jBfPoi+wqWzGAV5SRah2sA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238283; c=relaxed/simple;
	bh=dAtYFKYc95tXwNFoIru0jBFLj6ymGTSqEGWK4CS0E9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gckeWHfY6eyEgSscQ4wmnIra50BODU+DwL2r9MWU8qU5+59RaxzuinMzdVPVcCXKzQf85fA/UvuttlRrCl+/92e/9nrgkIO8gRFyULFaodxK02iMtYEVJghDzwEbm1Th8c/N1ek5Ea5dbhWbcIy4jN2zjZgbq63VMSbUlCAxEpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FLfB0FlD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FLfB0FlD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 760F01F000E9;
	Thu, 20 Aug 2026 15:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238282;
	bh=vxJVqtXwpxsPRq25PIyW8XRALWHDt+XOlgpYKbxP3S4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FLfB0FlDw2QmdNiRYRQsJsZbusJDPlb4L61o3lszDyFai2yJkrzdNMm2UFwZYdgZL
	 wYNXMPdwKNg+Vl5ygYb0sgLHF/Ff1bwz8gtIMupUiJZRsQKIx2NC5tTcESoRwCRkXl
	 QDnsAi4EsAOz13nbUsLRIhee0OxI9zmaWDVboXbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Jia Yao <jia.yao@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
Subject: [PATCH 7.1 092/228] drm/xe/guc_ads: allocate UM queues in VRAM on dGFX
Date: Thu, 20 Aug 2026 16:53:54 +0200
Message-ID: <20260820145247.450988398@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jia Yao <jia.yao@intel.com>

commit f342810a141f8a7e8b3786a6e4b6c0695a078a74 upstream.

On iGPU, the UM queue BO is allocated in system memory. On dGFX, the BO
was previously created in system memory and later reallocated in
xe_guc_realloc_post_hwconfig().  Allocate the UM queue BO directly in
VRAM on dGFX, where it is ultimately required.

Fixes: 9c57bc08652a ("drm/xe/lnl: Drop force_probe requirement")
Cc: Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: <stable@vger.kernel.org> # v6.12+
Signed-off-by: Jia Yao <jia.yao@intel.com>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Link: https://patch.msgid.link/20260804165057.129529-3-jia.yao@intel.com
(cherry picked from commit ace076ef0a854ab5940bacc539bf66afd61d118c)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_guc.c     |    6 ------
 drivers/gpu/drm/xe/xe_guc_ads.c |    8 +++++---
 2 files changed, 5 insertions(+), 9 deletions(-)

--- a/drivers/gpu/drm/xe/xe_guc.c
+++ b/drivers/gpu/drm/xe/xe_guc.c
@@ -714,12 +714,6 @@ static int xe_guc_realloc_post_hwconfig(
 	if (ret)
 		return ret;
 
-	if (guc->ads.um_queue_bo) {
-		ret = xe_managed_bo_reinit_in_vram(xe, tile, &guc->ads.um_queue_bo);
-		if (ret)
-			return ret;
-	}
-
 	return 0;
 }
 
--- a/drivers/gpu/drm/xe/xe_guc_ads.c
+++ b/drivers/gpu/drm/xe/xe_guc_ads.c
@@ -390,15 +390,17 @@ int xe_guc_ads_init(struct xe_guc_ads *a
 		/*
 		 * Allocate a separate BO for the HW fault ring (UM queues).
 		 *
-		 * Round the size up to the next power of two so that
+		 * Round the size up to the next power of two so that on iGPU
 		 * (system memory, no IOMMU) the TTM pool issues a single
 		 * alloc_pages(order=N) call, maximising the chance of getting
 		 * a physically contiguous block.  GuC requires contiguous DPA.
 		 */
-		size_t um_size = roundup_pow_of_two(GUC_UM_QUEUE_SIZE *
+		size_t um_size = IS_DGFX(xe) ?
+				 GUC_UM_QUEUE_SIZE * GUC_UM_HW_QUEUE_MAX :
+				 roundup_pow_of_two(GUC_UM_QUEUE_SIZE *
 						    GUC_UM_HW_QUEUE_MAX);
 
-		u32 um_flags = XE_BO_FLAG_SYSTEM |
+		u32 um_flags = XE_BO_FLAG_VRAM_IF_DGFX(tile) |
 			       XE_BO_FLAG_GGTT |
 			       XE_BO_FLAG_GGTT_INVALIDATE |
 			       XE_BO_FLAG_PINNED_NORESTORE;



Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025042;
	b=nBXhMuIb6pGHFRP06YvEBdRuFA2EnPsNa3bX2tHS9s75cYkfK6BUjOo0MbR9XK9Pt4E7
	 7fFwNYA7bu7rKyKtxmbNnbWv8jHX7upu1J+vTYO0DoPLCD+Q3/e7DRTQOGeJbP8fNJrgW
	 /ynKZeS+N+pshzKj2oEPiAlTVVTvM29BtYOrxPhAuOYYidmk626iTBfX9qv/GhnkONtLs
	 q33JjPVPYKX4hMlQdRWH/qsnHz3O9PFGkzQtS4xGgPoFjdzUNx3HsS5phGJjDDEI6dhx8
	 tLDjhzTABHWI7UFCuLzlNp/oqqAUwKSlMlcF1S8diSz/RQFPFEgh3qkJ21RZky5uKtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025042;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=3m3oegS/Sxtv5EII9Eb5YjkrwidmSM0gtUJ6AO+yElw=;
	b=vA4luVCMNF3JzANB6jzzFlIQAo2+nEEQE6LsvFD1BDjxKlcD45WQAVg19VtD/u9eXBaW
	 gyOUlSHwzytPMCqTJrjtMFKGznBPc27IoMW63JfhKl7wG9M43b+6ZARbMSkEckqqX+0Ih
	 lP7jVDFIECRbOXqxlJI1cSJXiQh9aEepgcxL5dHx1aWCpNnqwWw6ujd2CywgVDDpBmpML
	 Bjlq+7E6JIkZLc1zHsIaoxeXzXIyoloVkQ5eh1VSa9hgfhmMu7zhc+THaPdkSRWQ2OYOx
	 g2Y/QFA5MuB883Ea633LtoRxHgZK3kcUfftdaAGCVO3W4EQt9tE16Rq9UpcnkD2uKwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WwV7GpF1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F05C6606A31C;
	Wed, 18 Nov 2026 18:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WwV7GpF1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D6741F000C4;
	Wed, 18 Nov 2026 18:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025041;
	bh=3m3oegS/Sxtv5EII9Eb5YjkrwidmSM0gtUJ6AO+yElw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WwV7GpF1BBi2x/QDunJrkwchpck7CCvzst3HA/XIdp7cfLB2xZw49RwLnElQot3bq
	 iwvivD5PSYM8i1NmrBmP0DebViKk5P0zxVezDpIiDn3u/FLzbgpxLEamQANBlxsR2I
	 1RoBOE8zHs50iACHSKIy3u2m2GGGbGek2RBQbpy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sunil Khatri <sunil.khatri@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0940/2151] drm/amdgpu/userq: use drm_exec in amdgpu_userq_fence_read_wptr
Date: Wed, 18 Nov 2026 15:44:35 +0100
Message-ID: <20261118150156.720449729@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sunil Khatri <sunil.khatri@amd.com>

[ Upstream commit 3aab50410653fe7eb35eb6f9c2b27e3549ab09e6 ]

To access the bo from vm mapping first lock the root bo and
then the object bo of the mapping to make sure both locks
are taken safely.

Signed-off-by: Sunil Khatri <sunil.khatri@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: c7ae3b204328 ("drm/amdgpu/userq: fix reading the WPTR at a non-zero BO offset")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/amdgpu/amdgpu_userq_fence.c   | 55 +++++++++----------
 1 file changed, 26 insertions(+), 29 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c
index 8310cbebcaf32..e4c5674c91fea 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c
@@ -370,51 +370,48 @@ static int amdgpu_userq_fence_read_wptr(struct amdgpu_usermode_queue *queue,
 {
 	struct amdgpu_bo_va_mapping *mapping;
 	struct amdgpu_bo *bo;
+	struct drm_exec exec;
 	u64 addr, *ptr;
-	int r;
-
-	r = amdgpu_bo_reserve(queue->vm->root.bo, false);
-	if (r)
-		return r;
+	int ret;
 
 	addr = queue->userq_prop->wptr_gpu_addr;
 	addr &= AMDGPU_GMC_HOLE_MASK;
 
-	mapping = amdgpu_vm_bo_lookup_mapping(queue->vm, addr >> PAGE_SHIFT);
-	if (!mapping) {
-		amdgpu_bo_unreserve(queue->vm->root.bo);
-		DRM_ERROR("Failed to lookup amdgpu_bo_va_mapping\n");
-		return -EINVAL;
-	}
+	drm_exec_init(&exec, DRM_EXEC_IGNORE_DUPLICATES, 2);
+	drm_exec_until_all_locked(&exec) {
+		ret = amdgpu_vm_lock_pd(queue->vm, &exec, 1);
+		drm_exec_retry_on_contention(&exec);
+		if (unlikely(ret))
+			goto lock_error;
 
-	bo = amdgpu_bo_ref(mapping->bo_va->base.bo);
-	amdgpu_bo_unreserve(queue->vm->root.bo);
-	r = amdgpu_bo_reserve(bo, true);
-	if (r) {
-		amdgpu_bo_unref(&bo);
-		DRM_ERROR("Failed to reserve userqueue wptr bo");
-		return r;
+		mapping = amdgpu_vm_bo_lookup_mapping(queue->vm, addr >> PAGE_SHIFT);
+		if (!mapping) {
+			ret = -EINVAL;
+			goto lock_error;
+		}
+
+		ret = drm_exec_lock_obj(&exec, &mapping->bo_va->base.bo->tbo.base);
+		drm_exec_retry_on_contention(&exec);
+		if (unlikely(ret))
+			goto lock_error;
 	}
 
-	r = amdgpu_bo_kmap(bo, (void **)&ptr);
-	if (r) {
+	bo = mapping->bo_va->base.bo;
+	ret = amdgpu_bo_kmap(bo, (void **)&ptr);
+	if (ret) {
 		DRM_ERROR("Failed mapping the userqueue wptr bo");
-		goto map_error;
+		goto lock_error;
 	}
 
 	*wptr = le64_to_cpu(*ptr);
 
 	amdgpu_bo_kunmap(bo);
-	amdgpu_bo_unreserve(bo);
-	amdgpu_bo_unref(&bo);
-
+	drm_exec_fini(&exec);
 	return 0;
 
-map_error:
-	amdgpu_bo_unreserve(bo);
-	amdgpu_bo_unref(&bo);
-
-	return r;
+lock_error:
+	drm_exec_fini(&exec);
+	return ret;
 }
 
 static void amdgpu_userq_fence_cleanup(struct dma_fence *fence)
-- 
2.53.0




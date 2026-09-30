Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A77F5226BF;
	Wed, 30 Sep 2026 17:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790373; cv=none; b=mrLm1P7nkAnH2ySGZxpb+ONiBGCfeE9yGZ+9walXZQdp5rlQITOdc5SWQZxfcBA0xGkJ0ctNgnHE40MgDUnl6EgrcuNeN7aF6fLV9GPRRaSFIinpy/By+Cwvyg3drbfDHTXGSvpr7H3XqehK4LGwARkKHS9SkmfYBzJQoOF3nLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790373; c=relaxed/simple;
	bh=iltx4OXhBdRlhDSrICaSxtPhH4vPhoLMAp+iAXswt60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bE/ABBKllRZ1W83GaxQ6CMhrOStrlLy3ai/wO5oeUZlSqkZLtmLA32rWNm2rS1uCchxeUuSWWcPWm/mMxjh/EbqtpcSKH84prs2wvgtLLxXkAcJWwj1A8iS6Ubgko3EYhrWP7L+9uEWqMz3urlAGkqg5s0RhjNNzyMkkHPf8iS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gDlTy9dT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gDlTy9dT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C37181F000FF;
	Wed, 30 Sep 2026 17:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790372;
	bh=Fbu4cDNTG7zevArRwi9rOo7LPX7iv8cb9GH1ojgXmDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gDlTy9dT6ci64yA8hSIdLiGJFfJbCATzgk3VgYLVd43QhgEHaFoiDlWj2hiR7smTH
	 Tpcg5UOVYnGoKxhurU44O8PQ6tRldnuVcTb5l5YnRdRvdJbdGF3jHQSo+mdkp/zwZb
	 Z0kuVgzk2EHCmFO6Q6vvgg9KKwRN472uxpxQXvKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Martin <Andrew.Martin@amd.com>,
	Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 806/877] drm/amdgpu: Failed to check various return code
Date: Wed, 30 Sep 2026 17:28:37 +0200
Message-ID: <20260930152432.109472938@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Andrew Martin <Andrew.Martin@amd.com>

[ Upstream commit 357ef5b3b7e98b4d21cb0abc1bde1140332c7eb8 ]

Clean up code to quiet the compiler on us failing to check the return
code.

Signed-off-by: Andrew Martin <Andrew.Martin@amd.com>
Reviewed-by: Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 5155002b03b2 ("drm/amdgpu: fix rmmio iounmap skipped on device removal")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c       |    2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c |   14 +++++++-------
 2 files changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c
@@ -368,7 +368,7 @@ void amdgpu_amdkfd_free_gtt_mem(struct a
 {
 	struct amdgpu_bo **bo = (struct amdgpu_bo **) mem_obj;
 
-	amdgpu_bo_reserve(*bo, true);
+	(void)amdgpu_bo_reserve(*bo, true);
 	amdgpu_bo_kunmap(*bo);
 	amdgpu_bo_unpin(*bo);
 	amdgpu_bo_unreserve(*bo);
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -722,7 +722,7 @@ kfd_mem_dmaunmap_userptr(struct kgd_mem
 		return;
 
 	amdgpu_bo_placement_from_domain(bo, AMDGPU_GEM_DOMAIN_CPU);
-	ttm_bo_validate(&bo->tbo, &bo->placement, &ctx);
+	(void)ttm_bo_validate(&bo->tbo, &bo->placement, &ctx);
 
 	dma_unmap_sgtable(adev->dev, ttm->sg, direction, 0);
 	sg_free_table(ttm->sg);
@@ -771,7 +771,7 @@ kfd_mem_dmaunmap_sg_bo(struct kgd_mem *m
 	}
 
 	amdgpu_bo_placement_from_domain(bo, AMDGPU_GEM_DOMAIN_CPU);
-	ttm_bo_validate(&bo->tbo, &bo->placement, &ctx);
+	(void)ttm_bo_validate(&bo->tbo, &bo->placement, &ctx);
 
 	dir = mem->alloc_flags & KFD_IOC_ALLOC_MEM_FLAGS_WRITABLE ?
 				DMA_BIDIRECTIONAL : DMA_TO_DEVICE;
@@ -981,7 +981,7 @@ unwind:
 		if (!attachment[i])
 			continue;
 		if (attachment[i]->bo_va) {
-			amdgpu_bo_reserve(bo[i], true);
+			(void)amdgpu_bo_reserve(bo[i], true);
 			if (--attachment[i]->bo_va->ref_count == 0)
 				amdgpu_vm_bo_del(adev, attachment[i]->bo_va);
 			amdgpu_bo_unreserve(bo[i]);
@@ -1251,11 +1251,11 @@ static int unmap_bo_from_gpuvm(struct kg
 		return -EBUSY;
 	}
 
-	amdgpu_vm_bo_unmap(adev, bo_va, entry->va);
+	(void)amdgpu_vm_bo_unmap(adev, bo_va, entry->va);
 
-	amdgpu_vm_clear_freed(adev, vm, &bo_va->last_pt_update);
+	(void)amdgpu_vm_clear_freed(adev, vm, &bo_va->last_pt_update);
 
-	amdgpu_sync_fence(sync, bo_va->last_pt_update);
+	(void)amdgpu_sync_fence(sync, bo_va->last_pt_update);
 
 	return 0;
 }
@@ -2358,7 +2358,7 @@ void amdgpu_amdkfd_gpuvm_unmap_gtt_bo_fr
 {
 	struct amdgpu_bo *bo = mem->bo;
 
-	amdgpu_bo_reserve(bo, true);
+	(void)amdgpu_bo_reserve(bo, true);
 	amdgpu_bo_kunmap(bo);
 	amdgpu_bo_unpin(bo);
 	amdgpu_bo_unreserve(bo);



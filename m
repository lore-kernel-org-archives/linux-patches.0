Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6F69253358;
	Tue, 29 Apr 2025 17:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947359; cv=none; b=iRGAC4fGgKB4ECM7lZNdb88O7jRYjKVSoMuouaNG9qZ1VMQIHZcPj/qMV8lpc9VrWmJEhdfgwUsF1B46rWbvAI4UAbbAQVGaDQjZHiSv/Cl7saUSWVqzlb8AVlgiYcNEfqF0b1isjnRLviXbI4hisIzuW3wYSHDKX5V67dLEs1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947359; c=relaxed/simple;
	bh=AoOLKmORzRebcz+vbpVvtGcoskGB0ToTNDuOiqYTlfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tEb6OWHm5WnyJGzff3FFvg6Tmlaul+i+OH0F5gzA2SlVT1bM5Wci2FV8pN2pd74JIF4hiR+NbQZeToIBBjtsPLRjHzH7goW4en+6e3jVeF/hVASeGZKK50vjcU6hrIePmHcTZSuEhk5p+A6q7JyWJUItgUK6eftsynuVBTWT4j4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZuYVkmW5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZuYVkmW5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBC9CC4CEF0;
	Tue, 29 Apr 2025 17:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947359;
	bh=AoOLKmORzRebcz+vbpVvtGcoskGB0ToTNDuOiqYTlfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZuYVkmW50izFA4BPcjZxNpXwcRhCC2KvjCbm0yXWPiXXBgGyHaJiUuMd+tr5yztT8
	 x/kcePZQs7BuBRSnOtlqGORSsAHRO4y1pWmXX8wJBvzP/AFoO03vpK7kEwQhCVYs1C
	 X+7sDrY7bajS48LDYReo542kWSrC5F4MeeLHiYwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Ramesh Errabolu <Ramesh.Errabolu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 228/286] drm/amdgpu: Remove amdgpu_device arg from free_sgt api (v2)
Date: Tue, 29 Apr 2025 18:42:12 +0200
Message-ID: <20250429161117.315852744@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
User-Agent: quilt/0.68
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ramesh Errabolu <Ramesh.Errabolu@amd.com>

[ Upstream commit 5392b2af97dc5802991f953eb2687e538da4688c ]

Currently callers have to provide handle of amdgpu_device,
which is not used by the implementation. It is unlikely this
parameter will become useful in future, thus removing it

v2: squash in unused variable fix

Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Ramesh Errabolu <Ramesh.Errabolu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: c0dd8a9253fa ("drm/amdgpu/dma_buf: fix page_link check")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c  | 7 +------
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.h      | 3 +--
 drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c | 4 +---
 3 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c
index e93ccdc5faf4e..bbbacc7b6c463 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c
@@ -357,17 +357,12 @@ static void amdgpu_dma_buf_unmap(struct dma_buf_attachment *attach,
 				 struct sg_table *sgt,
 				 enum dma_data_direction dir)
 {
-	struct dma_buf *dma_buf = attach->dmabuf;
-	struct drm_gem_object *obj = dma_buf->priv;
-	struct amdgpu_bo *bo = gem_to_amdgpu_bo(obj);
-	struct amdgpu_device *adev = amdgpu_ttm_adev(bo->tbo.bdev);
-
 	if (sgt->sgl->page_link) {
 		dma_unmap_sgtable(attach->dev, sgt, dir, 0);
 		sg_free_table(sgt);
 		kfree(sgt);
 	} else {
-		amdgpu_vram_mgr_free_sgt(adev, attach->dev, dir, sgt);
+		amdgpu_vram_mgr_free_sgt(attach->dev, dir, sgt);
 	}
 }
 
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.h
index a87951b2f06dd..bd873b1b760cf 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.h
@@ -113,8 +113,7 @@ int amdgpu_vram_mgr_alloc_sgt(struct amdgpu_device *adev,
 			      struct device *dev,
 			      enum dma_data_direction dir,
 			      struct sg_table **sgt);
-void amdgpu_vram_mgr_free_sgt(struct amdgpu_device *adev,
-			      struct device *dev,
+void amdgpu_vram_mgr_free_sgt(struct device *dev,
 			      enum dma_data_direction dir,
 			      struct sg_table *sgt);
 uint64_t amdgpu_vram_mgr_usage(struct ttm_resource_manager *man);
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
index 2c3a94e939bab..ad72db21b8d62 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
@@ -530,15 +530,13 @@ int amdgpu_vram_mgr_alloc_sgt(struct amdgpu_device *adev,
 /**
  * amdgpu_vram_mgr_alloc_sgt - allocate and fill a sg table
  *
- * @adev: amdgpu device pointer
  * @dev: device pointer
  * @dir: data direction of resource to unmap
  * @sgt: sg table to free
  *
  * Free a previously allocate sg table.
  */
-void amdgpu_vram_mgr_free_sgt(struct amdgpu_device *adev,
-			      struct device *dev,
+void amdgpu_vram_mgr_free_sgt(struct device *dev,
 			      enum dma_data_direction dir,
 			      struct sg_table *sgt)
 {
-- 
2.39.5




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208431;
	b=jX4Z9huZr9YG11WhyDJ6wVuZtk81oKwtW0/6o8EFg0tTx38Eq9jFBRAyzRC5qXBbP1nP
	 kXPosJSRnh4tAJKDtC3H26CUYvX/VdanM33iUWy+6stFr3dBa9BroFyHxVmzDz/nzJOdo
	 89EjMyVeWnEqWa71STy6Q5f0h+i9Ou39vllNWq3KDAJE6nOEnhe4UVnVJp6nguctqQTaj
	 V1Bm+zgrRixbjy7cd7HKazQ5j8EQyQ7KMxoB0cL/MtalqdX1ZgfwKQkRlEXfxlxAKCqGq
	 KfghT41CZAMR0LdOlmtRIZvUwfIxWDBta/WFkgvohtBV0LpipR80pk5V0abYKR+uLDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208431;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=OeNMX5+Vhs3b4EGmX9yRKFXmssIrNadxqjU2N2DXOcA=;
	b=gC6VnDA/Ewa3skCqswaQCZYp2+36V58c5XhRf8BlyPILdP7L8t7r6WkN/Y1rFChuIRt2
	 +no5oCytXozpv8Izei9lfSSLEGNTJl8V4vFJpJ5a/7CbPYm2QbadNxglWDboHiDV/cLam
	 v1t708shLpjYV2pRIP9WZgH1Q4ctX49NPRtmBSOwPZoScAkvSBnBlUyFBaTuFymubb7rF
	 n+z6XCSgVHgz9wlw92Q+JH0qMju9PpxM/Jt9kJnl4MvX5BFSL+DJLpWJbt/20W+gvr/4w
	 E49+uWKm1QCZGBc6wj1XaS6e/+u9pfc8Qxi83HSpOhohKK+2LtoOG2pTqjUxpVZyAfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j6GFNpfT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BE13606A31D;
	Wed, 28 Oct 2026 17:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j6GFNpfT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD3521F01828;
	Wed, 28 Oct 2026 17:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208431;
	bh=OeNMX5+Vhs3b4EGmX9yRKFXmssIrNadxqjU2N2DXOcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j6GFNpfTWxT2rZo6AN7piXvmBd83l2kMMVygKp1QHaCcn/Kiv4JxkgXymRgM9XT4h
	 C4rfnq3KakR8cMNNets1ccV3XaV0C1FDARkGO4JM9HGAgXhoAozRCv+OXgobfvBYNq
	 c5p0AtcXCpR+d3oLnyw8yJS4eexuzGRUTT6GthRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Dave Airlie <airlied@redhat.com>,
	Huang Rui <ray.huang@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 117/516] drm/nouveau: switch over to the new pin interface
Date: Wed, 28 Oct 2026 17:54:29 +0100
Message-ID: <20261028170006.290105212@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian König <christian.koenig@amd.com>

[ Upstream commit 6797cea18d3982fce6a7d63e51b4cea0e3c8eb06 ]

Stop using TTM_PL_FLAG_NO_EVICT.

Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Dave Airlie <airlied@redhat.com>
Reviewed-by: Huang Rui <ray.huang@amd.com>
Link: https://patchwork.freedesktop.org/patch/391606/?series=81973&rev=1
Stable-dep-of: 6a6870d3077f ("drm/nouveau: don't bump pin count on failed re-pin in nouveau_bo_pin_locked()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nouveau_bo.c   | 48 +++++++-------------------
 drivers/gpu/drm/nouveau/nouveau_bo.h   |  3 --
 drivers/gpu/drm/nouveau/nouveau_chan.c |  2 +-
 3 files changed, 13 insertions(+), 40 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_bo.c b/drivers/gpu/drm/nouveau/nouveau_bo.c
index d9106f14fde50..bc3ffd2c942fd 100644
--- a/drivers/gpu/drm/nouveau/nouveau_bo.c
+++ b/drivers/gpu/drm/nouveau/nouveau_bo.c
@@ -139,7 +139,7 @@ nouveau_bo_del_ttm(struct ttm_buffer_object *bo)
 	struct drm_device *dev = drm->dev;
 	struct nouveau_bo *nvbo = nouveau_bo(bo);
 
-	WARN_ON(nvbo->pin_refcnt > 0);
+	WARN_ON(nvbo->bo.pin_count > 0);
 	nouveau_bo_del_io_reserve_lru(bo);
 	nv10_bo_put_tile_region(dev, nvbo->tile, NULL);
 
@@ -421,9 +421,8 @@ nouveau_bo_placement_set(struct nouveau_bo *nvbo, uint32_t domain,
 {
 	struct nouveau_drm *drm = nouveau_bdev(nvbo->bo.bdev);
 	struct ttm_placement *pl = &nvbo->placement;
-	uint32_t flags = (nvbo->force_coherent ? TTM_PL_FLAG_UNCACHED :
-						 TTM_PL_MASK_CACHING) |
-			 (nvbo->pin_refcnt ? TTM_PL_FLAG_NO_EVICT : 0);
+	uint32_t flags = nvbo->force_coherent ? TTM_PL_FLAG_UNCACHED :
+						TTM_PL_MASK_CACHING;
 
 	pl->placement = nvbo->placements;
 	set_placement_list(drm, nvbo->placements, &pl->num_placement,
@@ -457,7 +456,7 @@ nouveau_bo_pin(struct nouveau_bo *nvbo, uint32_t domain, bool contig)
 		}
 	}
 
-	if (nvbo->pin_refcnt) {
+	if (nvbo->bo.pin_count) {
 		bool error = evict;
 
 		switch (bo->mem.mem_type) {
@@ -476,7 +475,7 @@ nouveau_bo_pin(struct nouveau_bo *nvbo, uint32_t domain, bool contig)
 				 bo->mem.mem_type, domain);
 			ret = -EBUSY;
 		}
-		nvbo->pin_refcnt++;
+		ttm_bo_pin(&nvbo->bo);
 		goto out;
 	}
 
@@ -487,18 +486,12 @@ nouveau_bo_pin(struct nouveau_bo *nvbo, uint32_t domain, bool contig)
 			goto out;
 	}
 
-	nvbo->pin_refcnt++;
 	nouveau_bo_placement_set(nvbo, domain, 0);
-
-	/* drop pin_refcnt temporarily, so we don't trip the assertion
-	 * in nouveau_bo_move() that makes sure we're not trying to
-	 * move a pinned buffer
-	 */
-	nvbo->pin_refcnt--;
 	ret = nouveau_bo_validate(nvbo, false, false);
 	if (ret)
 		goto out;
-	nvbo->pin_refcnt++;
+
+	ttm_bo_pin(&nvbo->bo);
 
 	switch (bo->mem.mem_type) {
 	case TTM_PL_VRAM:
@@ -523,30 +516,14 @@ nouveau_bo_unpin(struct nouveau_bo *nvbo)
 {
 	struct nouveau_drm *drm = nouveau_bdev(nvbo->bo.bdev);
 	struct ttm_buffer_object *bo = &nvbo->bo;
-	int ret, ref;
+	int ret;
 
 	ret = ttm_bo_reserve(bo, false, false, NULL);
 	if (ret)
 		return ret;
 
-	ref = --nvbo->pin_refcnt;
-	WARN_ON_ONCE(ref < 0);
-	if (ref)
-		goto out;
-
-	switch (bo->mem.mem_type) {
-	case TTM_PL_VRAM:
-		nouveau_bo_placement_set(nvbo, NOUVEAU_GEM_DOMAIN_VRAM, 0);
-		break;
-	case TTM_PL_TT:
-		nouveau_bo_placement_set(nvbo, NOUVEAU_GEM_DOMAIN_GART, 0);
-		break;
-	default:
-		break;
-	}
-
-	ret = nouveau_bo_validate(nvbo, false, false);
-	if (ret == 0) {
+	ttm_bo_unpin(&nvbo->bo);
+	if (!nvbo->bo.pin_count) {
 		switch (bo->mem.mem_type) {
 		case TTM_PL_VRAM:
 			drm->gem.vram_available += bo->mem.size;
@@ -559,9 +536,8 @@ nouveau_bo_unpin(struct nouveau_bo *nvbo)
 		}
 	}
 
-out:
 	ttm_bo_unreserve(bo);
-	return ret;
+	return 0;
 }
 
 int
@@ -1078,7 +1054,7 @@ nouveau_bo_move(struct ttm_buffer_object *bo, bool evict,
 	if (ret)
 		return ret;
 
-	if (nvbo->pin_refcnt)
+	if (nvbo->bo.pin_count)
 		NV_WARN(drm, "Moving pinned object %p!\n", nvbo);
 
 	if (drm->client.device.info.family < NV_DEVICE_INFO_V0_TESLA) {
diff --git a/drivers/gpu/drm/nouveau/nouveau_bo.h b/drivers/gpu/drm/nouveau/nouveau_bo.h
index 2a23c82074362..ff68ded8d590d 100644
--- a/drivers/gpu/drm/nouveau/nouveau_bo.h
+++ b/drivers/gpu/drm/nouveau/nouveau_bo.h
@@ -40,9 +40,6 @@ struct nouveau_bo {
 
 	struct nouveau_drm_tile *tile;
 
-	/* protect by the ttm reservation lock */
-	int pin_refcnt;
-
 	struct ttm_bo_kmap_obj dma_buf_vmap;
 };
 
diff --git a/drivers/gpu/drm/nouveau/nouveau_chan.c b/drivers/gpu/drm/nouveau/nouveau_chan.c
index 9b6f2c1414d72..e48f1f7eb3705 100644
--- a/drivers/gpu/drm/nouveau/nouveau_chan.c
+++ b/drivers/gpu/drm/nouveau/nouveau_chan.c
@@ -107,7 +107,7 @@ nouveau_channel_del(struct nouveau_channel **pchan)
 		nvif_object_dtor(&chan->push.ctxdma);
 		nouveau_vma_del(&chan->push.vma);
 		nouveau_bo_unmap(chan->push.buffer);
-		if (chan->push.buffer && chan->push.buffer->pin_refcnt)
+		if (chan->push.buffer && chan->push.buffer->bo.pin_count)
 			nouveau_bo_unpin(chan->push.buffer);
 		nouveau_bo_ref(NULL, &chan->push.buffer);
 		kfree(chan);
-- 
2.53.0




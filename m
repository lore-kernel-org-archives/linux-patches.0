Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BE9F37204A;
	Sat, 12 Sep 2026 07:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197155; cv=none; b=FjIUdFjks8iTYR4Hy72YDW2IMMOc0CVPzbumiAfDI41bzvyLt7fRbZzqrZe43jkpTxrpdLYZkd7D1/7cRnABEWKYeBfeOHXrhIsB7okgBVDqwSIpTi6KxTIu+JwmBFW1pWiX5cBBQ8QUYxIGfBzJMJzCuQ2krlofn5La6qe0S0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197155; c=relaxed/simple;
	bh=ze2f/IOfXZcJzAY/1RvPea05sK1M//kiUOtHLoVLpz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rO7eyblj3F+MhkxvcCJ5yVvjSs1FLhczIif8qkCkLtmior43PM4a6ceQzu5zQtEVWQZ46NY80PsMF522CKeRqLxw72LrOf/zigH/IHMlsRWdqPM1/ftd6h12kh+F4LuSuDpHZxNPD/S494bdRSBS+u1A5LTAYhn0MMuLgJ4CqUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uw0c7pPn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uw0c7pPn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A210F1F000FF;
	Sat, 12 Sep 2026 07:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197154;
	bh=lNrDpgpn78ZA2TmmImZsCUTCJCBtW7yFdydwcKI7w1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uw0c7pPnrYkA8fCEyp4trMXfRRm1ZffH1noBdaJROjL5JVJbq1hLDJOUp/CkdHTf4
	 PWtIGjN1D1Uoi3DB9nsBD/b9hYGHCBUc1a9cnegHtLx+2qRXHYPcbDeDYehgArjDTC
	 /GwRsTi6YqA8Js2qOYJpcSO7z9OQQgst1bNfIw18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Price <steven.price@arm.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	=?UTF-8?q?Adri=C3=A1n=20Larumbe?= <adrian.larumbe@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0112/1815] drm/panthor: Pass vm_bind_op to vm_prepare_map_op_ctx
Date: Sat, 12 Sep 2026 08:31:02 +0200
Message-ID: <20260912065651.639059198@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrián Larumbe <adrian.larumbe@collabora.com>

[ Upstream commit 3ed4e3988525d0f2af836f581956b1f594f9d47c ]

Instead of passing its constituent elements, pass the whole struct to
simplify the function prototype.

Reviewed-by: Steven Price <steven.price@arm.com>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Signed-off-by: Adrián Larumbe <adrian.larumbe@collabora.com>
Link: https://patch.msgid.link/20260522185206.2798288-3-adrian.larumbe@collabora.com
Signed-off-by: Steven Price <steven.price@arm.com>
Stable-dep-of: 5fb40edc7439 ("drm/panthor: Fix NPD issue on partial unmap of an evicted BO")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_mmu.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/panthor/panthor_mmu.c b/drivers/gpu/drm/panthor/panthor_mmu.c
index e10dbd18d8cf9..b4e52db982f3c 100644
--- a/drivers/gpu/drm/panthor/panthor_mmu.c
+++ b/drivers/gpu/drm/panthor/panthor_mmu.c
@@ -1282,9 +1282,7 @@ static int panthor_vm_op_ctx_prealloc_pts(struct panthor_vm_op_ctx *op_ctx)
 static int panthor_vm_prepare_map_op_ctx(struct panthor_vm_op_ctx *op_ctx,
 					 struct panthor_vm *vm,
 					 struct panthor_gem_object *bo,
-					 u64 offset,
-					 u64 size, u64 va,
-					 u32 flags)
+					 const struct drm_panthor_vm_bind_op *op)
 {
 	struct drm_gpuvm_bo *preallocated_vm_bo;
 	struct sg_table *sgt = NULL;
@@ -1293,12 +1291,12 @@ static int panthor_vm_prepare_map_op_ctx(struct panthor_vm_op_ctx *op_ctx,
 	if (!bo)
 		return -EINVAL;
 
-	if ((flags & ~PANTHOR_VM_BIND_OP_MAP_FLAGS) ||
-	    (flags & DRM_PANTHOR_VM_BIND_OP_TYPE_MASK) != DRM_PANTHOR_VM_BIND_OP_TYPE_MAP)
+	if ((op->flags & ~PANTHOR_VM_BIND_OP_MAP_FLAGS) ||
+	    (op->flags & DRM_PANTHOR_VM_BIND_OP_TYPE_MASK) != DRM_PANTHOR_VM_BIND_OP_TYPE_MAP)
 		return -EINVAL;
 
 	/* Make sure the VA and size are in-bounds. */
-	if (size > bo->base.size || offset > bo->base.size - size)
+	if (op->size > bo->base.size || op->bo_offset > bo->base.size - op->size)
 		return -EINVAL;
 
 	/* If the BO has an exclusive VM attached, it can't be mapped to other VMs. */
@@ -1306,7 +1304,7 @@ static int panthor_vm_prepare_map_op_ctx(struct panthor_vm_op_ctx *op_ctx,
 	    bo->exclusive_vm_root_gem != panthor_vm_root_gem(vm))
 		return -EINVAL;
 
-	panthor_vm_init_op_ctx(op_ctx, size, va, flags);
+	panthor_vm_init_op_ctx(op_ctx, op->size, op->va, op->flags);
 
 	ret = panthor_vm_op_ctx_prealloc_vmas(op_ctx);
 	if (ret)
@@ -1335,7 +1333,7 @@ static int panthor_vm_prepare_map_op_ctx(struct panthor_vm_op_ctx *op_ctx,
 	}
 
 	op_ctx->map.vm_bo = drm_gpuvm_bo_obtain_prealloc(preallocated_vm_bo);
-	op_ctx->map.bo_offset = offset;
+	op_ctx->map.bo_offset = op->bo_offset;
 
 	ret = panthor_vm_op_ctx_prealloc_pts(op_ctx);
 	if (ret)
@@ -2862,10 +2860,7 @@ panthor_vm_bind_prepare_op_ctx(struct drm_file *file,
 		gem = drm_gem_object_lookup(file, op->bo_handle);
 		ret = panthor_vm_prepare_map_op_ctx(op_ctx, vm,
 						    gem ? to_panthor_bo(gem) : NULL,
-						    op->bo_offset,
-						    op->size,
-						    op->va,
-						    op->flags);
+						    op);
 		drm_gem_object_put(gem);
 		return ret;
 
@@ -3061,10 +3056,16 @@ int panthor_vm_bind_exec_sync_op(struct drm_file *file,
 int panthor_vm_map_bo_range(struct panthor_vm *vm, struct panthor_gem_object *bo,
 			    u64 offset, u64 size, u64 va, u32 flags)
 {
+	struct drm_panthor_vm_bind_op op = {
+		.bo_offset = offset,
+		.size = size,
+		.va = va,
+		.flags = flags,
+	};
 	struct panthor_vm_op_ctx op_ctx;
 	int ret;
 
-	ret = panthor_vm_prepare_map_op_ctx(&op_ctx, vm, bo, offset, size, va, flags);
+	ret = panthor_vm_prepare_map_op_ctx(&op_ctx, vm, bo, &op);
 	if (ret)
 		return ret;
 
-- 
2.53.0




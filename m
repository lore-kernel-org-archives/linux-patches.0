Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD51F47A882;
	Fri,  7 Aug 2026 14:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114669; cv=none; b=AUDn7fiMSEY/teISOvWYL4w7ulOFeRv1toc/xTp6NrY6VA0AHrZSQyx2UMCx0BPJ5DMIWXdaYz360RJpHE+ikFoEXadnU/U48VAiAImfUiMXFFuAQwLaj2HKhtzFAp1qN3tl1d+G6FOWf/6FVhW965F1DC3VJ7UA3V8yUHGlI4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114669; c=relaxed/simple;
	bh=9ZnHeKBcPjY8slJnKObXCGqVz91I3s4NUxY3ao+tfXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CDD3vBA1xkS9DqRLrXkykpm3XSBkvLjAp10rOhjW6ovWRunac0GO489nIBpUU+uMrUw7G5j+0FpotckxeKxdSFKbQkd9+UNGp66eLQ8mOKEOY1wq/aLzmXxU64ByLa4X1ry8f4rz3wP6itxfT7y3tv40TzSbNXOjEUmD7B+G9bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mGrN69vk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mGrN69vk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4278A1F000E9;
	Fri,  7 Aug 2026 14:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114667;
	bh=mw5j9D2Kh98sdj/1vF0UNm84ioT+nFtzbGCZX216JlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mGrN69vkS0W13G6pQRZA13EpwHzhlSJ5osWxT2B+cbm7/e52fRpVDl9bnnt80eWhF
	 xxiTyXhNGMbNDU+pTW5Yl46QnL2dVXNfvrd92DArhDJOPTXqUaoQZDrBpYN2uNqwuJ
	 VcF9LhlA/gFpphakn6fwlX9QxswJfUH86pa+ZXp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 320/337] drm/xe: Rename ___xe_bo_create_locked()
Date: Fri,  7 Aug 2026 16:38:43 +0200
Message-ID: <20260807143425.470337774@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Hellström <thomas.hellstrom@linux.intel.com>

[ Upstream commit 550a42a8daee1b056f9b3e6c858e57451a5b315a ]

Don't start external function names with underscores.
Rename to xe_bo_init_locked().

Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Link: https://lore.kernel.org/r/20250908101246.65025-10-thomas.hellstrom@linux.intel.com
Stable-dep-of: 62775525a27c ("drm/xe: Hold a dma-buf reference for imported BOs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_bo.c      |   20 ++++++++++----------
 drivers/gpu/drm/xe/xe_bo.h      |   10 +++++-----
 drivers/gpu/drm/xe/xe_dma_buf.c |    6 +++---
 3 files changed, 18 insertions(+), 18 deletions(-)

--- a/drivers/gpu/drm/xe/xe_bo.c
+++ b/drivers/gpu/drm/xe/xe_bo.c
@@ -1288,11 +1288,11 @@ void xe_bo_free(struct xe_bo *bo)
 	kfree(bo);
 }
 
-struct xe_bo *___xe_bo_create_locked(struct xe_device *xe, struct xe_bo *bo,
-				     struct xe_tile *tile, struct dma_resv *resv,
-				     struct ttm_lru_bulk_move *bulk, size_t size,
-				     u16 cpu_caching, enum ttm_bo_type type,
-				     u32 flags)
+struct xe_bo *xe_bo_init_locked(struct xe_device *xe, struct xe_bo *bo,
+				struct xe_tile *tile, struct dma_resv *resv,
+				struct ttm_lru_bulk_move *bulk, size_t size,
+				u16 cpu_caching, enum ttm_bo_type type,
+				u32 flags)
 {
 	struct ttm_operation_ctx ctx = {
 		.interruptible = true,
@@ -1487,11 +1487,11 @@ __xe_bo_create_locked(struct xe_device *
 		}
 	}
 
-	bo = ___xe_bo_create_locked(xe, bo, tile, vm ? xe_vm_resv(vm) : NULL,
-				    vm && !xe_vm_in_fault_mode(vm) &&
-				    flags & XE_BO_FLAG_USER ?
-				    &vm->lru_bulk_move : NULL, size,
-				    cpu_caching, type, flags);
+	bo = xe_bo_init_locked(xe, bo, tile, vm ? xe_vm_resv(vm) : NULL,
+			       vm && !xe_vm_in_fault_mode(vm) &&
+			       flags & XE_BO_FLAG_USER ?
+			       &vm->lru_bulk_move : NULL, size,
+			       cpu_caching, type, flags);
 	if (IS_ERR(bo))
 		return bo;
 
--- a/drivers/gpu/drm/xe/xe_bo.h
+++ b/drivers/gpu/drm/xe/xe_bo.h
@@ -80,11 +80,11 @@ struct sg_table;
 struct xe_bo *xe_bo_alloc(void);
 void xe_bo_free(struct xe_bo *bo);
 
-struct xe_bo *___xe_bo_create_locked(struct xe_device *xe, struct xe_bo *bo,
-				     struct xe_tile *tile, struct dma_resv *resv,
-				     struct ttm_lru_bulk_move *bulk, size_t size,
-				     u16 cpu_caching, enum ttm_bo_type type,
-				     u32 flags);
+struct xe_bo *xe_bo_init_locked(struct xe_device *xe, struct xe_bo *bo,
+				struct xe_tile *tile, struct dma_resv *resv,
+				struct ttm_lru_bulk_move *bulk, size_t size,
+				u16 cpu_caching, enum ttm_bo_type type,
+				u32 flags);
 struct xe_bo *
 xe_bo_create_locked_range(struct xe_device *xe,
 			  struct xe_tile *tile, struct xe_vm *vm,
--- a/drivers/gpu/drm/xe/xe_dma_buf.c
+++ b/drivers/gpu/drm/xe/xe_dma_buf.c
@@ -212,9 +212,9 @@ xe_dma_buf_init_obj(struct drm_device *d
 	int ret;
 
 	dma_resv_lock(resv, NULL);
-	bo = ___xe_bo_create_locked(xe, storage, NULL, resv, NULL, dma_buf->size,
-				    0, /* Will require 1way or 2way for vm_bind */
-				    ttm_bo_type_sg, XE_BO_FLAG_SYSTEM);
+	bo = xe_bo_init_locked(xe, storage, NULL, resv, NULL, dma_buf->size,
+			       0, /* Will require 1way or 2way for vm_bind */
+			       ttm_bo_type_sg, XE_BO_FLAG_SYSTEM);
 	if (IS_ERR(bo)) {
 		ret = PTR_ERR(bo);
 		goto error;



Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039039;
	b=n6TnAIMLtSpktFf6LGlhIRX7xeGwPrU7N9JSCb6ZtvXyZ/QbWMg8bh8OE9xslsvbtjZ5
	 Jt1OD0YSj72nIyXEq43Eo/4YH1iaMmzS/6B9F2c3te6vrwtf5tqxjDdYwfBlK21pOb6XU
	 C3lYJk8s8Fa5rg/mdIYbTgO6Juemv+Rx4Jb5BC/DaSNSlbX0ex5/wvbyBVes+OMEtq9FM
	 Ji01ykZ8qpxkJbCvGMBRDgfc4Jv+SJFdmBs4VrP07J7OFq2paZmTBVM58NCzMcJzpdUYC
	 DAGgK5t2agVOaQkkUAusRaTeK5/OjqJHc7uzWVYrovoIeMPDQhCmSomcjGjzVpesmiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039039;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EF/Y5Au4/pZSIz71FPGabsrKPLgGs5lF3wetIO76DnE=;
	b=jO7lts+utkfzqH3iBLtEeyIMcHrLuF2nI4DZ2S6AoYfKpfDYGYJ/gri3vS4UGLTMCJrr
	 +fH3n0SkBQNZrCXWAfsfVlrP3ztBH/NsuXSFlO6R1GxTncrDJOCB3Hh8XFnSoTC13yxvu
	 O8gXQLRSGZm1lU/ORVgqcvhXer+YCILDnkvvqqqw7QiBiPzz1cu3ertvW1x3iit1aDHxB
	 xBfAS5ZITl4ci03igcXq/3poQiRpKUhwDsozUh9cwK5sUXjBKehiAwdkKILo5cV/bZZzF
	 QvCCaGkTAjJ68QDq7yKpc0n3stMULdJlYjySfhb/i8h52dp44k+mlPCjnvZbVtYgQsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vbFY4YkK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D258606A31C;
	Wed, 18 Nov 2026 21:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vbFY4YkK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD3861F000C4;
	Wed, 18 Nov 2026 21:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039039;
	bh=EF/Y5Au4/pZSIz71FPGabsrKPLgGs5lF3wetIO76DnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vbFY4YkKT0us4Ek7vPiMh0emvpCaL2vQNC9kVu+EzNroiO0BcIU/ZtnsEV3BteTb4
	 ja1ZX/dZ9C0UMGEGGnBrOEXjHhns7X83lnyRDVnrKSditLGcaAAdoYue58pMqCKtcH
	 0t4+4e6OhRJsjT9v7NGPYfDJHhppRp0JNXw8GlBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Kuehling <felix.kuehling@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1955/3318] drm/amdkfd: use the queues process info for the WPTR BO eviction fence
Date: Wed, 18 Nov 2026 15:42:57 +0100
Message-ID: <20261118150420.731856966@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Zhang <Jesse.Zhang@amd.com>

[ Upstream commit da2897ee8b811945fd40ecc4aaf03291c14ce61c ]

amdgpu_amdkfd_map_gtt_bo_to_gart() removes the eviction fence of
bo->vm_bo->vm->process_info from the WPTR BO of a new queue. bo->vm_bo
is the VM which opened the BO last, not necessarily the KFD process' VM,
and a render node VM has no process info.

On navi31, an unprivileged process which exports its WPTR BO with
AMDKFD_IOC_EXPORT_DMABUF and imports it on a second render node fd
oopses in AMDKFD_IOC_CREATE_QUEUE:

  BUG: kernel NULL pointer dereference, address: 0000000000000060
  RIP: 0010:amdgpu_amdkfd_map_gtt_bo_to_gart+0x86/0x1a0 [amdgpu]
   init_user_queue.part.0+0x180/0x250 [amdgpu]
   pqm_create_queue+0x32d/0x730 [amdgpu]
   kfd_ioctl_create_queue+0x583/0x9f0 [amdgpu]

Pass the process info of the queue instead. With the fix, the queue is
created and destroyed normally.

Fixes: 7f347e3f8217 ("drm/amdkfd: Fix NULL pointer error for GC 11.0.1 on mGPU")
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 6b4157498a176bd1c6083f6bb5aaf8a257a2027e)
Cc: stable@vger.kernel.org
[ sashal: adapted process_info passing to kfd_ioctl_create_queue() using p->kgd_process_info instead of pqm->process->kgd_process_info ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h       | 3 ++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c | 8 +++++---
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c         | 3 ++-
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
index 1be8c4a676096..938a29f8ad837 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
@@ -309,7 +309,8 @@ int amdgpu_amdkfd_gpuvm_map_gtt_bo_to_kernel(struct kgd_mem *mem,
 					     void **kptr, uint64_t *size);
 void amdgpu_amdkfd_gpuvm_unmap_gtt_bo_from_kernel(struct kgd_mem *mem);
 
-int amdgpu_amdkfd_map_gtt_bo_to_gart(struct amdgpu_device *adev, struct amdgpu_bo *bo);
+int amdgpu_amdkfd_map_gtt_bo_to_gart(struct amdgpu_device *adev, struct amdgpu_bo *bo,
+				     struct amdkfd_process_info *process_info);
 
 int amdgpu_amdkfd_gpuvm_restore_process_bos(void *process_info,
 					    struct dma_fence **ef);
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
index 05426ac8d9e14..ab04dce3c7ea9 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -2180,11 +2180,13 @@ int amdgpu_amdkfd_gpuvm_sync_memory(
  * amdgpu_amdkfd_map_gtt_bo_to_gart - Map BO to GART and increment reference count
  * @adev: Device to which allocated BO belongs
  * @bo: Buffer object to be mapped
+ * @process_info: KFD process info of the queue the BO is for
  *
  * Before return, bo reference count is incremented. To release the reference and unpin/
  * unmap the BO, call amdgpu_amdkfd_free_gtt_mem.
  */
-int amdgpu_amdkfd_map_gtt_bo_to_gart(struct amdgpu_device *adev, struct amdgpu_bo *bo)
+int amdgpu_amdkfd_map_gtt_bo_to_gart(struct amdgpu_device *adev, struct amdgpu_bo *bo,
+				     struct amdkfd_process_info *process_info)
 {
 	int ret;
 
@@ -2206,8 +2208,8 @@ int amdgpu_amdkfd_map_gtt_bo_to_gart(struct amdgpu_device *adev, struct amdgpu_b
 		goto err_map_bo_gart_failed;
 	}
 
-	amdgpu_amdkfd_remove_eviction_fence(
-		bo, bo->vm_bo->vm->process_info->eviction_fence);
+	/* bo->vm_bo can be the VM of any file which opened the BO */
+	amdgpu_amdkfd_remove_eviction_fence(bo, process_info->eviction_fence);
 
 	amdgpu_bo_unreserve(bo);
 
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
index 44cd1b54d020e..a538331477085 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -375,7 +375,8 @@ static int kfd_ioctl_create_queue(struct file *filep, struct kfd_process *p,
 			goto err_wptr_map_gart;
 		}
 
-		err = amdgpu_amdkfd_map_gtt_bo_to_gart(dev->adev, wptr_bo);
+		err = amdgpu_amdkfd_map_gtt_bo_to_gart(dev->adev, wptr_bo,
+						    p->kgd_process_info);
 		if (err) {
 			pr_err("Failed to map wptr bo to GART\n");
 			goto err_wptr_map_gart;
-- 
2.53.0




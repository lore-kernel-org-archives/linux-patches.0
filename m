Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028752;
	b=rTlmMf8yzFRH2OgJ4nNuGaxVzdv3Csqo90JMzBO6vOjAdotlKA1EwsI+jrdWQydU1vS4
	 iTyfBk3qjX+KY9drXdaUzsvhJaN+ALI8/Rgs0t659YJ82hPNLZaT72/A4CImFORYAzjJb
	 JYeqI0Aum72ceqOsiLYoFHZMGnq17T6BKDZcO547PsktahD9HcEixpb5JU5IG7c3b47CC
	 mbxbgf7T/zmPw5G494uR+90lKklgV4CM1V7VoVawzcs9Db+Wtxi+QuE4a3mxHNdhpGFHk
	 5suYqNmTTlEmMbKcAOzKq/NovwRCowNmSo1RBe426Y3FbRWhTIDOGKgxxj40/heHBZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028752;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Mz6Lpo6lrhyJbUV/jgIJyvionOJu+HsfcXZ3EpcatGs=;
	b=Eugb7oqpJ6WRRKA0US2aE68AYvDtsVZHId9dxzUzBC5EkqMt15fDsF05dUlQf8vISecF
	 25cECVQIlcwG0r0HJ5/uGXeDU45Un+VyrbBCbiJy6YmbUIICgNOQCWhWL2eQOn/zfrylQ
	 kUAaFjKKoGgAWCtTklBURf9ZrsTMrbdLZ0Q1oL054GoEpn93bJm+2vkZOZTgfs73Ymng0
	 MrR7pWPtHSWko5bUOW6fB5/LfPpUYmierywdv1UHQfAJbxWzkbwTyCrzqVtORCoZr53m+
	 22fze2nsnjBcQT215Fm6vZsnFvQA04eakbFukd/e5LkzW1tbi3xiqhFPIuWh3j1U0dg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XA94Q3Ec;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A816606A331;
	Wed, 18 Nov 2026 19:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XA94Q3Ec
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 800751F000C4;
	Wed, 18 Nov 2026 19:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028752;
	bh=Mz6Lpo6lrhyJbUV/jgIJyvionOJu+HsfcXZ3EpcatGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XA94Q3EcBhqJATaUMMae+0wFxpP/tVyaCoz/8uUdaH1oU2cVv33qxOSjvI1WnK5Jz
	 Wj2gxB+odVji7cuheCHTjuItvyIO2fzvSpuFzhWwwJMBeM3/g0v03fjMM0SkualXzN
	 /2Ocic9zd9O1nPy7uAiEdYH/TzhzDNUOZMkclbus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Kuehling <felix.kuehling@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0105/1756] drm/amdkfd: use the queues process info for the WPTR BO eviction fence
Date: Wed, 18 Nov 2026 15:37:12 +0100
Message-ID: <20261118150012.399976801@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h             | 3 ++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c       | 8 +++++---
 drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c | 3 ++-
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
index b921587d428cc..f5374b6f2501b 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
@@ -324,7 +324,8 @@ int amdgpu_amdkfd_gpuvm_map_gtt_bo_to_kernel(struct kgd_mem *mem,
 					     void **kptr, uint64_t *size);
 void amdgpu_amdkfd_gpuvm_unmap_gtt_bo_from_kernel(struct kgd_mem *mem);
 
-int amdgpu_amdkfd_map_gtt_bo_to_gart(struct amdgpu_bo *bo, struct amdgpu_bo **bo_gart);
+int amdgpu_amdkfd_map_gtt_bo_to_gart(struct amdgpu_bo *bo, struct amdgpu_bo **bo_gart,
+				     struct amdkfd_process_info *process_info);
 
 int amdgpu_amdkfd_gpuvm_restore_process_bos(void *process_info,
 					    struct dma_fence __rcu **ef);
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
index 55834719e9848..318d731bf9ecd 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -2248,11 +2248,13 @@ int amdgpu_amdkfd_gpuvm_sync_memory(
  * amdgpu_amdkfd_map_gtt_bo_to_gart - Map BO to GART and increment reference count
  * @bo: Buffer object to be mapped
  * @bo_gart: Return bo reference
+ * @process_info: KFD process info of the queue the BO is for
  *
  * Before return, bo reference count is incremented. To release the reference and unpin/
  * unmap the BO, call amdgpu_amdkfd_free_gtt_mem.
  */
-int amdgpu_amdkfd_map_gtt_bo_to_gart(struct amdgpu_bo *bo, struct amdgpu_bo **bo_gart)
+int amdgpu_amdkfd_map_gtt_bo_to_gart(struct amdgpu_bo *bo, struct amdgpu_bo **bo_gart,
+				     struct amdkfd_process_info *process_info)
 {
 	int ret;
 
@@ -2274,8 +2276,8 @@ int amdgpu_amdkfd_map_gtt_bo_to_gart(struct amdgpu_bo *bo, struct amdgpu_bo **bo
 		goto err_map_bo_gart_failed;
 	}
 
-	amdgpu_amdkfd_remove_eviction_fence(
-		bo, bo->vm_bo->vm->process_info->eviction_fence);
+	/* bo->vm_bo can be the VM of any file which opened the BO */
+	amdgpu_amdkfd_remove_eviction_fence(bo, process_info->eviction_fence);
 
 	amdgpu_bo_unreserve(bo);
 
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c b/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
index 4a3ed391b3c7b..819c7f5fb16f8 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
@@ -285,7 +285,8 @@ static int init_user_queue(struct process_queue_manager *pqm,
 		}
 
 		retval = amdgpu_amdkfd_map_gtt_bo_to_gart(q_properties->wptr_bo,
-							  &(*q)->wptr_bo_gart);
+							  &(*q)->wptr_bo_gart,
+							  pqm->process->kgd_process_info);
 		if (retval) {
 			pr_err("Failed to map wptr bo to GART\n");
 			goto free_gang_ctx_bo;
-- 
2.53.0




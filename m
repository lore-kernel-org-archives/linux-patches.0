Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047622;
	b=FHC6XBSg638fAkKxbrupEK0lGTalR4LgksNVFK18n3VcfVVw62MmZIRigz1g70dWMUI1
	 jfZn9EoqAmmfabKSPt4YP7hVzXdbLQ31QkbXsOkwlxP0Dvm77ZL8TjlLa4tlUaBvhsaeh
	 NJUDRWhrOly0MZPO3o8tLcgy9oJKJ4U+Ik4+q8twxq0/PFJY7SeD715gZtyfqnL0DKbgk
	 9MdzpC0mpcTGdDl/qHl7hkA1rTLUnqwcVqDxZUQhLufbpW/fXwD2m3v3Lq/bAKiLVkcGh
	 onKLWuUOPB9iLHxOsqKhNJiImtkA0nOl6DG4Uczp0kzwyIRUV7KuCV0BWBy+n5YJREg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047622;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tWSAqsTBro0/JWuHWPKvYPDAN7pu6IExOi5fMgcfH/A=;
	b=P5J8kayvDrBbyMyQzqcs1HmNtdsgFCsbVcsyfMSY3M9f73u57XUIYXdyAl1+j6aq7/wz
	 XQYrwH1m81pJeber25pd/aodY/yDPJzx8isMDlwC5jA5FERyWJD3yqGjM/pODOSaCJOLa
	 wsbxMgiXko62cZSQZiImcBKSl/2/dcKIY1x5p+mGdUDESOrYZf0i7dq2H7GpGoGjHs75L
	 GZzdGH5DbBgslLrbnA30Co+b8V5JKQ6zMjqcd2K1GsXuYegpfMuL6zfCGpfxTcJOpDG0o
	 2G67u9ZcrCvPsK7NVfDctJPYQqc4W8w0iKRkQ/CqwcPZWDd3bt00SMFsB+V7UR9IRhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ig5OYrhC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3153606A320;
	Thu, 19 Nov 2026 00:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ig5OYrhC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EE751F000C4;
	Thu, 19 Nov 2026 00:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047622;
	bh=tWSAqsTBro0/JWuHWPKvYPDAN7pu6IExOi5fMgcfH/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ig5OYrhCRwPxKefwveLOql1UpM1sVTW3j9BJ74/VpvGdYBGy1aLlQD/ipw7P2mIwK
	 u4nA6MEEgO/l8E2JjrgfIaX48kcu2BSod69DnG2/VzuYCC5/aex1Ttrc0+MrtV0Ocp
	 ytHHuKvM8HoJD7TYGp26GtkmXYOYOZFRBGFVUAzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Kuehling <felix.kuehling@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1704/2857] drm/amdkfd: use the queues process info for the WPTR BO eviction fence
Date: Wed, 18 Nov 2026 15:45:38 +0100
Message-ID: <20261118150302.686763132@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adapted the process_info argument to the existing adev-based mapping API in kfd_ioctl_create_queue() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h       | 3 ++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c | 8 +++++---
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c         | 3 ++-
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
index ba065f7887aad..ed0f5e76324e0 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
@@ -294,7 +294,8 @@ int amdgpu_amdkfd_gpuvm_map_gtt_bo_to_kernel(struct kgd_mem *mem,
 					     void **kptr, uint64_t *size);
 void amdgpu_amdkfd_gpuvm_unmap_gtt_bo_from_kernel(struct kgd_mem *mem);
 
-int amdgpu_amdkfd_map_gtt_bo_to_gart(struct amdgpu_device *adev, struct amdgpu_bo *bo);
+int amdgpu_amdkfd_map_gtt_bo_to_gart(struct amdgpu_device *adev, struct amdgpu_bo *bo,
+				     struct amdkfd_process_info *process_info);
 
 int amdgpu_amdkfd_gpuvm_restore_process_bos(void *process_info,
 					    struct dma_fence **ef);
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
index eb4d652afbb60..49b9e0033be9e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -2163,11 +2163,13 @@ int amdgpu_amdkfd_gpuvm_sync_memory(
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
 
@@ -2189,8 +2191,8 @@ int amdgpu_amdkfd_map_gtt_bo_to_gart(struct amdgpu_device *adev, struct amdgpu_b
 		goto err_map_bo_gart_failed;
 	}
 
-	amdgpu_amdkfd_remove_eviction_fence(
-		bo, bo->vm_bo->vm->process_info->eviction_fence);
+	/* bo->vm_bo can be the VM of any file which opened the BO */
+	amdgpu_amdkfd_remove_eviction_fence(bo, process_info->eviction_fence);
 
 	amdgpu_bo_unreserve(bo);
 
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
index a08c84556ace4..4212d8c77de3b 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -368,7 +368,8 @@ static int kfd_ioctl_create_queue(struct file *filep, struct kfd_process *p,
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




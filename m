Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065157;
	b=GNRhcQTIhf4AN2ZquvL4W6BQ3JBPd7FnN/OQDdH5lmuLnooSnLquPZ1LqgMF92H1C1PX
	 DPmP7xZleoYRYVYwrH6cB0ao470rPJ8wM+7FluS+aBL8Msny45TInlnY+qhEFT9VZav1R
	 igJyO44RnHy/fU28+Y6sxJutj+xxD/gy4XFxSxVGNwTrI6ff42a6+ajCveJEEtBGkJWNj
	 /8oC35LquASCWh2QXMZMVeAdLlS4NbvUENHDGe7K55sYDaJZYsbtw0ym+h5jvtEWC+8wk
	 F6t6gVV/vUe5H6mb8iNfHGtQ+HLIBi0HmJKZoEtvw2Jk4E4jWT6Cc9tpHuYTt9hdslA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065157;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=niYGLqQNCpHF2SuWSonMGt9b4c26VMBrNr56ypXslKw=;
	b=j7dy97V54jOjMA88B7GCqweWR0z/8i+dYO8OWeiO5cLEGDfRvM8uL9J9/WCXQ8ePdsyn
	 DcP/hdF155sIXYswgcxwhp1RjKqnvqS6qKfjQKCG3c04EIc1vvny/w1rc0QuJsrYH79Up
	 7UHfabvXVKqDQy2Pksfv+ag3psx54j8FgSCQ10Dcnzvrde8b79en2LS+cHnbR/KMreT1I
	 O2P4ZOv0ccaLr5Uv3VQo6Y7XgZczJ/a5/bg0NCFjLWGUn6toKJ/vkfslLleFVXmUXevWx
	 CRhoImRha4/GVitwqwbsi9IxmRdGzqPA3Yp15QgU+fm3YpLixXFx8C0Uuw9TRr2rkLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NSEEctqG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F33F606A335;
	Sat,  7 Nov 2026 15:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NSEEctqG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45FAD1F0089F;
	Sat,  7 Nov 2026 15:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065157;
	bh=niYGLqQNCpHF2SuWSonMGt9b4c26VMBrNr56ypXslKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NSEEctqG1IwluXqr4OcHn+WioTThuAwFjbfE8LcjDViBWm5KcqxbmGsUDUbFEifpe
	 UELhzxmfhrJc887ll+kkAigRdUvRtnz82R13HoUxEv2keaXb/8/jlqgeNzu6Yod8q/
	 TKwHhM+X5DaC+Gxn635xqcHQKCR8OOtSX0xPxQd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prike Liang <Prike.Liang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	John Fisher <jfisher84@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0966/1257] drm/amdgpu: wait for pending page table updates before switching a VM to CPU updates
Date: Sat,  7 Nov 2026 08:54:22 -0500
Message-ID: <20261107135006.021150366@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Fisher <jfisher84@gmail.com>

[ Upstream commit 53d9ef2f518add783bb48a69d77bbc8aea99e911 ]

amdgpu_vm_make_compute() switches a VM from SDMA to CPU page table
updates when a KFD process acquires it. It syncs "with the last SDMA
update/clear" through amdgpu_bo_sync_wait() on the root PD, but that
walks the reservation with DMA_RESV_USAGE_READ, and the clears of the
VM's page tables (the root PD from amdgpu_vm_init(), and the PDs/PTs
the seq64 mapping allocates at the render node's open) are added there
by amdgpu_vm_sdma_commit() with DMA_RESV_USAGE_BOOKKEEP only:
amdgpu_vm_pt_clear() commits them with a NULL fence, so they do not
reach vm->last_update. The CPU path's own waits (amdgpu_vm_cpu_update(),
amdgpu_bo_kmap()) use DMA_RESV_USAGE_KERNEL. None of them waits for a
clear that is still queued.

When one is, the CPU writes the first entries of the new compute VM (the
KFD trap handler's TBA/TMA page at AMDGPU_VA_RESERVED_TRAP_START, mapped
during ACQUIRE_VM) into a page directory the SDMA then clears. The
entries are gone, the handler's page is unmapped, and the first wave
save of any queue of the process faults in the SQC instruction fetch at
the handler's address (GCVM_L2_PROTECTION_FAULT_STATUS 0x008012B1,
PERMISSION_FAULTS 0xb). The MES then fails REMOVE_QUEUE and SUSPEND, and
the device takes a MODE1 reset with VRAM lost on 7.2.9; on 7.3-rc6 the
queue is reset instead.

The window is the time between the render node's open and ACQUIRE_VM.
ROCr spends milliseconds there and is practically never hit; a minimal
KFD client that opens the render node and acquires the VM at once is hit
most of the time. On a Radeon AI PRO R9700 (gfx1201, Resizable BAR, so
vm_update_mode defaults to CPU updates for compute VMs), a wave reading
the trap handler's page right after queue creation found it unmapped in
8 of 12 runs; a 5 ms sleep between the open and ACQUIRE_VM made that 0
of 9, and the same sleep after queue creation instead 3 of 3.

The wait covered these jobs until commit 926c79ad6ecd ("drm/amdgpu:
promote the implicit sync to the dependent read fences") narrowed
amdgpu_sync_resv() from DMA_RESV_USAGE_BOOKKEEP to DMA_RESV_USAGE_READ;
the VM's page table jobs have been added with BOOKKEEP since commit
4247084057cf ("drm/amdgpu: use DMA_RESV_USAGE_BOOKKEEP v2"), so from
v6.16 on the sync in amdgpu_vm_make_compute() waits for nothing of
them.

Record the clears in vm->last_update, as amdgpu_vm_update_pdes() does
with its updates, and wait for it, uninterruptibly, before switching the
update functions. The clears all go through vm->delayed, so the last one
covers the earlier ones; immediate clears are not recorded, as before.

With this, on 7.3-rc6 and on 7.2.9, the same client reads the handler
10 of 10 times, 8 busy queues on the 4 compute slots complete in 5 of 5
runs on 7.3-rc6 and 3 of 3 on 7.2.9 (1 of 6 before), 16 and 32 queues
complete on 7.3-rc6, and two processes with 8 queues each complete
together on both, with no fault.

Fixes: 926c79ad6ecd ("drm/amdgpu: promote the implicit sync to the dependent read fences")
Cc: Prike Liang <Prike.Liang@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: John Fisher <jfisher84@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 9ec91b35baba45209c3fcd00f086224a158dd512)
Cc: stable@vger.kernel.org # v6.16+
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c    | 5 +----
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm_pt.c | 2 +-
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
index 4a63b472f68ec..fc3a8d38d5149 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -2725,10 +2725,7 @@ int amdgpu_vm_make_compute(struct amdgpu_device *adev, struct amdgpu_vm *vm)
 
 	if (vm->use_cpu_for_update) {
 		/* Sync with last SDMA update/clear before switching to CPU */
-		r = amdgpu_bo_sync_wait(vm->root.bo,
-					AMDGPU_FENCE_OWNER_UNDEFINED, true);
-		if (r)
-			goto unreserve_bo;
+		dma_fence_wait(vm->last_update, false);
 
 		vm->update_funcs = &amdgpu_vm_cpu_funcs;
 		r = amdgpu_vm_pt_map_tables(adev, vm);
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_pt.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_pt.c
index e43a60d098082..cef4171b4ad06 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_pt.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_pt.c
@@ -422,7 +422,7 @@ int amdgpu_vm_pt_clear(struct amdgpu_device *adev, struct amdgpu_vm *vm,
 	if (r)
 		goto exit;
 
-	r = vm->update_funcs->commit(&params, NULL);
+	r = vm->update_funcs->commit(&params, &vm->last_update);
 exit:
 	drm_dev_exit(idx);
 	return r;
-- 
2.53.0




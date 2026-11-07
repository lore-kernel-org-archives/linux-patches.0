Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063568;
	b=CGmsj+ENI6+rvTEzeZKlUWHkZqFj4huMsxPzSFunR2NfME34i3oKXugJsLlf7wdfrrAr
	 Gf8JrUnSp14fxXB50YycOkCxSn8/qoDd39tLghiF3VF0g8E2YtV4HCESfqv6VXEIusE/X
	 Me43ldF5BoM9gJ+G3iM5LWkf8hJ1ZxqZDh7UcU/W2Z4F5Emp5dlA6hN0WTeikhMMVDy0j
	 aoJieZWQ5/8TtYCHNcDvLtMu+5TB5b53gxlVrT56KaRkyI9i8kq+K1XjZCd949DPSJ4m9
	 XZKPj5OnVxS6jAjJIiA5FO7g7/LDP/UMHn70hb34lSZU0CaYukX6vJP8m+K/HPRrLeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063568;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=8sUS5acLTqwJn2JhgBewO6iLxphVLkVhG0l+ofZveYA=;
	b=f204Ey0buEDf5lfIOKAFM+XLd/+ca3jy2DbXT2UMkEx2ICFj4PvnNuvAWorYyBRNU4Rj
	 MBUwB7YskbjGSFAJy9lxlmAE0TactyPNVTDFJJY0jY9ey2K581x83R7dq+xLbmNVEUIw/
	 zhxJUHkiNvS9YZnXbTDsWdu2ysnJN5hEeT5GbQUZOlzPFow7UgF3Knth+0aut9eOkBSHD
	 I3TJnLANs5LegHoyrButI2YUwa+fKPE8B56B2OrzTRbSFRIe1MzOEfbYHkJFEGOHduT1s
	 qXMNb/kP+vOdVUXvCm8I5ck/0n2M2jKqPasoFrTdcnvrQJkmv4FSvzsji00Gm1Cpy0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="FR54c/7Q";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3E00606D829;
	Sat,  7 Nov 2026 14:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FR54c/7Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61AEF1F008A3;
	Sat,  7 Nov 2026 14:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063567;
	bh=8sUS5acLTqwJn2JhgBewO6iLxphVLkVhG0l+ofZveYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FR54c/7Q4kqjKUA6/ZVGpq0k39azov8E9y0J4jzW/jLWSJi+VDYY6BLSmnJHwUhfR
	 0mtfS+Q09XLvOeXiLxenvijMHmbK+MQv3sL3OTCYyS+OGp3bb3kCRrkvbSMFznrudn
	 /gekpquijzghrycGFEyg4+JBTp8dk8KX19kaYn64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prike Liang <Prike.Liang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	John Fisher <jfisher84@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 682/869] drm/amdgpu: wait for pending page table updates before switching a VM to CPU updates
Date: Sat,  7 Nov 2026 08:56:04 -0500
Message-ID: <20261107134916.182936862@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
index f78ac6777ee5c..c9614a99b40d1 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -2720,10 +2720,7 @@ int amdgpu_vm_make_compute(struct amdgpu_device *adev, struct amdgpu_vm *vm)
 
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
index f794fb1cc06e6..a05f34259d578 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_pt.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_pt.c
@@ -421,7 +421,7 @@ int amdgpu_vm_pt_clear(struct amdgpu_device *adev, struct amdgpu_vm *vm,
 	if (r)
 		goto exit;
 
-	r = vm->update_funcs->commit(&params, NULL);
+	r = vm->update_funcs->commit(&params, &vm->last_update);
 exit:
 	drm_dev_exit(idx);
 	return r;
-- 
2.53.0




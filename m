Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065156;
	b=YnZSvxlHPlsyVh5BSX/nBu45OuEdx/QygBL5LYe9usLRa4po1sjMWpsqJPRbMMsgmx/u
	 y+hJKefZ6jcwluKq70+bfhbRv2zjDA8kQ4d+4fgjBw8c4e/5Xl15ooAeFbSF1B/dQy8IX
	 pRn6BY8QTqOqmYPexCMO/v7pi47au7UIif6vwYNaBchCjij364gTgUY4IPHZVshoZg4+q
	 2nxv841c8My3FQYhiCZk5Dq9AaZ8cXekwE6E5gaMECDulOhvxkoiu9jOZz9rOPw1BGUVS
	 d6x2WgcqDTT+X9BT1/SRZjKmPwTQBw4PaRH0ZUUIRs2uh6S0CMts/8W2wlke11KPqCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065156;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MTWv04G0+6QCJ0Rd5WalZ9hTpPdz/PwmnSsFXygwMk8=;
	b=Ox1ktWvlISuEU54Oo6BQclACYtmTrX/9JDC2KgXQpatLEYGn1xvY8el9NaZ3BXdOcyrI
	 7HqbHryuNRtwsyTw2liV3vG98Eqk7xrPKi2CiAT1hE5hLsUc9OsgfumHQ8XJ03e83zGFK
	 D98uFaEltuZAEjzYNDqbMMMdRafJeCk2gvYF2+72p6vju+QV6+LBFlICZVTokZAhrZcjx
	 kdAu/D3GL9oRW4Q3IpteOdj7UCgBJNo5ytYEo6HB5iu1UShwLmogNsC2qPPr6zEw8b135
	 suSMV34KFJFO5kDaUcfeVEeHOdpuOd+LbUZmp1bZZ5ViEeyGCUEeVJYeBdoLC7DGgVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LySbRxdS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E3B7606A32E;
	Sat,  7 Nov 2026 15:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LySbRxdS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD1C71F0089F;
	Sat,  7 Nov 2026 15:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065155;
	bh=MTWv04G0+6QCJ0Rd5WalZ9hTpPdz/PwmnSsFXygwMk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LySbRxdS9wdp4uYMcCc8+hHpUlOLo6DxGknTyj6FLszGzclFoAUOletinlPjunVcf
	 8J8a+Vvn+f8ZBa8PvGzKvRfHvdwAqn99ZBTdRoCuYJ4RptU1herjYaLad/5rtSN7NE
	 WiHLHGjSpIdKnkjdVQn6K9hp3lWtD8Gm6nZZ3rSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Kuehling <felix.kuehling@amd.com>,
	William Palacek <William.Palacek@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0965/1257] drm/amdkfd: wait for a GPU reset before freeing a BO
Date: Sat,  7 Nov 2026 08:54:21 -0500
Message-ID: <20261107135005.989518435@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: William Palacek <William.Palacek@amd.com>

[ Upstream commit 47d799a718439764432d8ef3a0952af45f025f76 ]

When a GPU reset takes the reset domain, KFD eviction cannot unmap
user queues: execute_queues_cpsch() fails its trylock with -EIO, so
the queues keep running until the ASIC is reset. The TLB flush is also
skipped while the reset is in progress. If the process unmaps and frees
a BO in that window, its pages are released while a queue can still
access them through stale translations.

On MI300X, munmap() then crashes in free_swap_cache() on a small bogus
page pointer in its mmu_gather batch page:

  BUG: unable to handle page fault for address: 0000000000002900
  RIP: 0010:free_swap_cache+0x5/0xb0
  Call Trace:
   free_pages_and_swap_cache+0x3a/0x60
   tlb_batch_pages_flush+0x43/0x80
   tlb_flush_mmu+0x3d/0x110
   zap_pte_range+0x80d/0xcd0
   ...
   do_vmi_align_munmap+0x3e8/0x5b0
   do_vmi_munmap+0xdf/0x190
   __vm_munmap+0xad/0x180
   __x64_sys_munmap+0x1b/0x30

In a traced crash the bogus pointer was the read pointer value of an SDMA
queue the process had just destroyed, at the read pointer's page offset:
the queue's writeback landed in its freed rptr page after the page was
reused as the batch page.

commit f0b4440cdc18 ("drm/amdkfd: Fix mode1 reset crash issue") fixed
this race on process exit by waiting for the reset to complete before
freeing the process's BOs. Free through the ioctl has the same race.
Wait for the reset there too, using the same helper.

Fixes: 9c33e5fd4fb6 ("drm/amdgpu: fix locking scope when flushing tlb")
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: William Palacek <William.Palacek@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 06ff8ce77726b15a98fcc285dd6005cb3f48558b)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c | 3 +++
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h    | 1 +
 drivers/gpu/drm/amd/amdkfd/kfd_process.c | 2 +-
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
index 3081d9aaf053a..3831451240e97 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -1303,6 +1303,9 @@ static int kfd_ioctl_free_memory_of_gpu(struct file *filep,
 		goto err_unlock;
 	}
 
+	/* Queues a reset could not stop may still access the buffer */
+	kfd_process_wait_gpu_reset_complete(p);
+
 	ret = amdgpu_amdkfd_gpuvm_free_memory_of_gpu(pdd->dev->adev,
 				(struct kgd_mem *)mem, pdd->drm_priv, &size);
 
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_priv.h b/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
index aab7292e2cb12..f405f476ed182 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
@@ -1135,6 +1135,7 @@ void kfd_unref_process(struct kfd_process *p);
 int kfd_process_evict_queues(struct kfd_process *p, uint32_t trigger);
 int kfd_process_restore_queues(struct kfd_process *p);
 void kfd_suspend_all_processes(void);
+void kfd_process_wait_gpu_reset_complete(struct kfd_process *p);
 int kfd_resume_all_processes(void);
 
 struct kfd_process_device *kfd_process_device_data_by_id(struct kfd_process *process,
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_process.c b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
index dda300786bc4e..586a6dd53883f 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
@@ -1292,7 +1292,7 @@ static void kfd_process_remove_sysfs(struct kfd_process *p)
 /*
  * If any GPU is ongoing reset, wait for reset complete.
  */
-static void kfd_process_wait_gpu_reset_complete(struct kfd_process *p)
+void kfd_process_wait_gpu_reset_complete(struct kfd_process *p)
 {
 	int i;
 
-- 
2.53.0




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022595;
	b=vEDnbAjTZd2AvN+I35PNnFkSRQoPW78XuL1bS5rCTaPoD1vJmRpiEjBUTotVBqQzDwT+
	 bNnVF/fXN/bmCvYytLGKjIhkaGgX2ZtqjLGZQBsu3YClz9rMwOl3QPcu6PZHdCyQPs3VA
	 KJgy0GxQxfTlViFxJ5xLfLQF+gC/YGXEQIQb6mcUg7n389QUV3k+Jltaq0Es+Dw1OsfON
	 2e+1zF/hehYlJcmZuWRfYNEn9B5pNTvEzuGar9TKeOJnv4ndpUQbz6k+XlhXUgUSHlv/0
	 Spjf6W4kVzfRNjkj1BXrZj7SUUNt/pl84B7207MoTJD+aF6XCiN9izpP3jFptsuofgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022595;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cONEhnU80wwZ/4zAdjOsXMTHnbADB+vLb0XEQ/7zKxc=;
	b=5XmuYraLUhimmFLloh+7UBmZCtiIfe8zikRPBMAGPrg+p7qYYCDhU7Y6x12hFquAwo0L
	 +25ySPUfvIM7ElQnoI7Lu6stueL1STBnNFAj37jYkRYP6Ghu7SMjBthcICT16elnivF/y
	 ORSlwSyAUyyMhiiHfheJpVwg0rfwfdFaEi352iIahcTfHuYkNen8je0/gyOG1rgmC98tz
	 d6NYL5pCUm4bZvGnyNkXyuUqt7oy61YMmTgcWKlB+nXWLkOg6D3hcunvu0AWw+93zyqHr
	 Jv4gtwT27w5BDb/7mv+lrS+Wzw/j84K0+bcsqWZdkcSXnntfjW88oqgIDP3nTfe/p7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EL534oyn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80C41606A31C;
	Wed, 18 Nov 2026 17:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EL534oyn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5648D1F000C4;
	Wed, 18 Nov 2026 17:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022594;
	bh=cONEhnU80wwZ/4zAdjOsXMTHnbADB+vLb0XEQ/7zKxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EL534oynxa4VdMGBKYKQsMB33mOyI/2eld55mNg/WqixfmcCXaBLHjEQMcf9OmwKI
	 LUXzxo6Xfn43xGKg7K6kAPa1PXJal6AzBJ1h50nagv9ocGVe5nEuNnc07NoGQ+qTE9
	 RvYNj3Cl15W4TktJ6sgAHy9/q42qKV+6wS6tdFRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prike Liang <Prike.Liang@amd.com>,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0069/2151] drm/amdgpu/userq: wait for GPU reset before mapping or unmapping queues
Date: Wed, 18 Nov 2026 15:30:04 +0100
Message-ID: <20261118150124.276474730@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prike Liang <Prike.Liang@amd.com>

[ Upstream commit 623507b8f4fe24851b2f1cb2c177f8ae3c8584b8 ]

The user queue map and unmap helpers talk to the MES, but only the
create path holds reset_domain->sem around them. The eviction, restore,
destroy and suspend paths can submit to the MES while a GPU reset is in
progress:

  WARNING: amdgpu_device.c:928 at amdgpu_device_skip_hw_access+0x73/0x90 [amdgpu]
  Workqueue: events amdgpu_eviction_fence_suspend_worker [amdgpu]
  Call Trace:
   amdgpu_mm_wdoorbell64+0x20/0x70 [amdgpu]
   mes_v11_0_ring_set_wptr+0x71/0x80 [amdgpu]
   amdgpu_ring_commit+0x5b/0xa0 [amdgpu]
   mes_v11_0_submit_pkt_and_poll_completion.constprop.0+0x207/0x520 [amdgpu]
   mes_v11_0_remove_hw_queue+0xd9/0x100 [amdgpu]
   mes_userq_unmap+0xc3/0x140 [amdgpu]
   amdgpu_userq_unmap_helper+0x67/0x280 [amdgpu]
   amdgpu_userq_evict+0x52/0xf0 [amdgpu]
   amdgpu_eviction_fence_suspend_worker+0x55/0xe0 [amdgpu]

Take the semaphore for read in the helpers instead, around both the MES
call and the queue state check and update. The reset changes the queue
state from amdgpu_userq_pre_reset()/post_reset(), so every caller now
waits for a running reset and acts on the state it left behind.

Signed-off-by: Prike Liang <Prike.Liang@amd.com>
Reviewed-by: Vitaly Prosyak <vitaly.prosyak@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit e6a8b8588f43bd4d7054ac47cccc35f56ad2df90)
Cc: stable@vger.kernel.org
[ sashal: left amdgpu_userq_create() unchanged because the outer reset semaphore lock was already absent ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c
index a0bf7c82b83b6..0b3502f3f1e23 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c
@@ -27,6 +27,7 @@
 #include <linux/pm_runtime.h>
 
 #include "amdgpu.h"
+#include "amdgpu_reset.h"
 #include "amdgpu_vm.h"
 #include "amdgpu_userq.h"
 #include "amdgpu_userq_fence.h"
@@ -148,6 +149,8 @@ amdgpu_userq_unmap_helper(struct amdgpu_userq_mgr *uq_mgr,
 		adev->userq_funcs[queue->queue_type];
 	int r = 0;
 
+	/* The reset changes the queue state and the MES is unusable meanwhile */
+	guard(rwsem_read)(&adev->reset_domain->sem);
 	if ((queue->state == AMDGPU_USERQ_STATE_MAPPED) ||
 		(queue->state == AMDGPU_USERQ_STATE_PREEMPTED)) {
 		r = userq_funcs->unmap(uq_mgr, queue);
@@ -168,6 +171,8 @@ amdgpu_userq_map_helper(struct amdgpu_userq_mgr *uq_mgr,
 		adev->userq_funcs[queue->queue_type];
 	int r = 0;
 
+	/* The reset changes the queue state and the MES is unusable meanwhile */
+	guard(rwsem_read)(&adev->reset_domain->sem);
 	if (queue->state == AMDGPU_USERQ_STATE_UNMAPPED) {
 		r = userq_funcs->map(uq_mgr, queue);
 		if (r) {
-- 
2.53.0




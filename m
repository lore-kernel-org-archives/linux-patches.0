Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585760;
	b=gR0UTd7f//H1FbIkQN3iXpD3dxU5xTCF6VQhRYhuO1RZdNIo4uNDxBxZmaliz75EfwZy
	 4oxJdAFsmmg9KB0GUT2h2+x0gEa00F012sele3Yuu5XW+rHoCj/5nnTh4cmeDzIRPTe7U
	 USFHI20JLvDsDhtBqVG24sIg+opq8ns4CGaXyI5hCi3NLzD+yPUtK5GDYQJ2Xi7od0I7l
	 +msyrUvQ0vy/7QUZ6kAjD2A4bumiJTYeP0j5WUCpyJol5ujeUDMEUPtlbS5oqOOonrKj0
	 1b3EEOues6tNzTI67BhaZGFD7GsFR/QcHpR/qM3/UaZNuqIxZ6AY5Z/wKhsBBooF+VA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585760;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cxKDzVsoJtk7uy+W6rjZNigXNr3gkksmvDXeG+G6Dg4=;
	b=A1eIAxwC+yCXdNFlw9OWUmZVOmogL5IywB/MdnK5mZ4fsJqQj5kRn8m8qSwN/1bh6JIm
	 bt7sFXYBi5Lw8+q/HfY7AXUBa94Duve3ppeA6xoEXmkAdiNymz6QGvI/KghXeZer/iftl
	 lOeAuJeMZIw85kR4WRYv8Iy+xMZb5Bqyj6FJuPg0IVVoYt8Rtedf3Oyx/EIWZxBkBToGP
	 lQj6yBI6bJNO5dgbcuhZ7v6+IZkZXPZ0a56D2Oet6I5rvbU28hho12A0k/dez/8nOqVv6
	 cTilhgD+6WbvqAkVj1Tn2Fgwwe6VIUk500NPUqSCsXSITgdCIBGZqs3kIwiWgoh2QqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QyOeTNMp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 384D0606AE20;
	Fri, 13 Nov 2026 16:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QyOeTNMp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D72581F000C4;
	Fri, 13 Nov 2026 16:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585760;
	bh=cxKDzVsoJtk7uy+W6rjZNigXNr3gkksmvDXeG+G6Dg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QyOeTNMp1AiM5hzCLIzdLYYqZy/grxGLqlm9DYN2kHGJEDcQ2BTUaEtzzrjx+EgpN
	 KrpBXFNbfiBPJ4Ti7JefZr1t+VRHuvzTvv2GG3lpdRbzKo1piKtJYkpvCFPiPFtfE6
	 58DoRsrOu1UThMKf9M6YhhgXQJpctf1Skx4P1nTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prike Liang <Prike.Liang@amd.com>,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 353/507] drm/amdgpu/userq: wait for GPU reset before mapping or unmapping queues
Date: Fri, 13 Nov 2026 10:50:57 -0500
Message-ID: <20261113153807.441406668@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c
index b3dc5dd49a647..dcccf6a9682c1 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c
@@ -365,6 +365,8 @@ static int amdgpu_userq_unmap_helper(struct amdgpu_usermode_queue *queue)
 		adev->userq_funcs[queue->queue_type];
 	int r;
 
+	/* The reset changes the queue state and the MES is unusable meanwhile */
+	guard(rwsem_read)(&adev->reset_domain->sem);
 	if ((queue->state == AMDGPU_USERQ_STATE_MAPPED) ||
 	    (queue->state == AMDGPU_USERQ_STATE_PREEMPTED)) {
 		trace_amdgpu_userq_state_start(queue);
@@ -391,6 +393,8 @@ static int amdgpu_userq_map_helper(struct amdgpu_usermode_queue *queue)
 		adev->userq_funcs[queue->queue_type];
 	int r;
 
+	/* The reset changes the queue state and the MES is unusable meanwhile */
+	guard(rwsem_read)(&adev->reset_domain->sem);
 	if (queue->state == AMDGPU_USERQ_STATE_UNMAPPED) {
 		trace_amdgpu_userq_state_start(queue);
 
@@ -751,12 +755,7 @@ amdgpu_userq_create(struct drm_file *filp, union drm_amdgpu_userq *args)
 	if (!adev->userq_halt_for_enforce_isolation ||
 	    ((queue->queue_type != AMDGPU_HW_IP_GFX) &&
 	     (queue->queue_type != AMDGPU_HW_IP_COMPUTE))) {
-		/* Serialize the map against an in-progress GPU reset (MES is
-		 * unresponsive during recovery), matching amdgpu_userq_detach_doorbell().
-		 */
-		down_read(&adev->reset_domain->sem);
 		r = amdgpu_userq_map_helper(queue);
-		up_read(&adev->reset_domain->sem);
 		if (r) {
 			drm_file_err(uq_mgr->file, "Failed to map Queue\n");
 			trace_amdgpu_userq_create_end(queue, r);
-- 
2.53.0




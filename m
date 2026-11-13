Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585762;
	b=P1HRmddNWzoNPWif5LAi/VESl5cTfS/88K0i3veWCDWrmcvK6xka+x5e7DZ35+vf3tFM
	 mp/NmSjboIUWfKplMWCAE0WXISLTvUD1EOtn6FA2kTVsDRI1sMshwiVOdmj7Dq9pv3d2p
	 WTX/0tEIcOvB3xZbH12+/eEqXEmrIrlPskdSgM0Oy9ZUD+pCRgi5LPeO3iJT+cK7GbqL+
	 nMyQOYgVlEtZn28Sdg4qqeW8szu3NTT3nEtjaxywLsh6VrDxHhqCy602DweCfNWZi0Qz6
	 Gpxx49eo6WvwrhB58rDpdOFsxz8wIcy5ubMK1TcxRU//rSuPOZzHKbCNiZI+PGHQ11Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585762;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=bY/dD8C2Z1BdpUK7ov2cU8N3q+6SLrRT3IdmcIWjMpM=;
	b=YlixkHn5095XGuN+Ame8zYxTQVMRHq0C1FyfwCBR9nUO8cs3Tvz+O7nJET+s7W2f3T0X
	 ira/2EBa1A+2kNDS/aWkE7LXs2uHKHifPlEzKq8JX0UuXxJNhOFgPoCAa/T5cC0SYMAlr
	 L5I2kVIIzuIvG6+Vhp3YxNw0Bxd62PH+N5vRlzIjjWLo7/m69ZNNDn6Tc1sS8q/8K5p5m
	 +LZQ1CKSWtuqlhBsXeR3nmnjG5riQJ8n6Izaz3TbilkRsyjAG48MSI3Hula2XdPu13fEy
	 sfKCV4nzhgFIUl44FhFdSZKYO/DAxHoLF7WazU1hfuDH7OsvuPqE+9ptkQv5xjkCjQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kXi5vbCC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABE38606A334;
	Fri, 13 Nov 2026 16:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kXi5vbCC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 584461F000C5;
	Fri, 13 Nov 2026 16:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585762;
	bh=bY/dD8C2Z1BdpUK7ov2cU8N3q+6SLrRT3IdmcIWjMpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kXi5vbCCOT+cyoswz4YolS3n8BxwUhgpCcao0W8CKmPhrtyLnFYBoLIdCJbXuR0oG
	 e2XfdZQ53jnZ7YDloSACkrJknpg+n2HSHAd/NOrJ2/nGGBVRSZW9BMD+TZ6o3979PM
	 /RlUyw9nWNQXCvZFEN5GrI0gzFwGp8+iKUwckuGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 355/507] drm/amdgpu/userq: validate the moved individual BOs on restore
Date: Fri, 13 Nov 2026 10:50:59 -0500
Message-ID: <20261113153807.680582609@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Zhang <Jesse.Zhang@amd.com>

[ Upstream commit ce5f2a25bdf6b2bccfc4ffb5e4c5f12e97eeace1 ]

An individual BO of a user queue VM, i.e. one which doesn't share the
root reservation, goes to the individual needs_update list when it is
evicted. The user queue restore looked at vm->invalidated for them, which
the VM state machine rework turned into the always_valid evicted list and
commit 18decfc9e8cc ("drm/amdgpu/userq: actually validate userq BOs")
into the individual evicted one. That list only holds imported DMA-bufs of
compute VMs though, so for a user queue VM nothing is validated.

The restore then neither locks such a BO nor moves it back. Its PTEs are
updated to wherever it is now, cleared if it went to system memory, and
it doesn't get the new eviction fence, so it can move again under the
running queue.

On navi48, once the BOs of an SDMA user queue are evicted from GTT
(debugfs amdgpu_evict_gtt) the queue faults on its ring and rptr:

  amdgpu 0000:03:00.0:   in page starting at address 0x0000000100000000 from client 10
  amdgpu 0000:03:00.0: 	 Faulty UTCL2 client ID: SDMA0 (0xd)
  amdgpu 0000:03:00.0:   in page starting at address 0x0000000100101000 from client 10

Validate the BOs on the individual needs_update list like before.

Fixes: 4cdbba5a16aa ("drm/amdgpu: restructure VM state machine v4")
Fixes: 18decfc9e8cc ("drm/amdgpu/userq: actually validate userq BOs")
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit eb0d94765d4be18d41e93ad09947dd9cc06ed31a)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c
index dcccf6a9682c1..053ead0d690f1 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c
@@ -972,7 +972,11 @@ static int amdgpu_userq_validate_vm(void *param, struct amdgpu_bo *bo)
 	return ttm_bo_validate(&bo->tbo, &bo->placement, &ctx);
 }
 
-/* Handle all BOs on the invalidated list, validate them and update the PTs */
+/*
+ * Handle all individual BOs which were moved, lock and validate them and
+ * update the PTs. An evicted individual BO lands on the needs_update list,
+ * the evicted one only holds imported DMA-bufs of compute VMs.
+ */
 static int
 amdgpu_userq_bo_validate(struct amdgpu_device *adev, struct drm_exec *exec,
 			 struct amdgpu_vm *vm)
@@ -983,8 +987,8 @@ amdgpu_userq_bo_validate(struct amdgpu_device *adev, struct drm_exec *exec,
 	int ret;
 
 	spin_lock(&vm->individual_lock);
-	while (!list_empty(&vm->individual.evicted)) {
-		bo_va = list_first_entry(&vm->individual.evicted,
+	while (!list_empty(&vm->individual.needs_update)) {
+		bo_va = list_first_entry(&vm->individual.needs_update,
 					 struct amdgpu_bo_va,
 					 base.vm_status);
 		bo = bo_va->base.bo;
-- 
2.53.0




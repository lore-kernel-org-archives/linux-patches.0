Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585839;
	b=NAkU7HJdRaMPfetHG0DXELL4uNuNVX/98W3nHCbReNe6rAd9E+fj+BrvkCKXLnGIAP1n
	 IYHp1/jK/2tYlh4yLlP8HIAZTuL9iFZB1VF0+LARfnIZ5y6O+uw8ioBNn91jFdV0YbGcy
	 qIpdPLKXEphSK0UZftqFyqLYZxyg2M47dl8eORzUb0Gso4nKQWTwCx0K9ESv+rBgdaHHe
	 pTH1YDcpMgCqItqFOpEnCGkHuHQXxerYbYxhf2/+gNxzGxnIQcjINYgrZAIWog2W6zYGP
	 tzU1Kch9QuqIylUNwNPE99CV9s7Uowvm1bojU3DnxPYp5mDGULU1xvUTqWcjrm/XAtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585839;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6C+zv1fQV5b6nuUmArbgA235hYHu08qwDvZanMItXBs=;
	b=e4kQztJNhYcuHsQLGWIYmsjSlvrMG4HdbmEmz1bDlBIq/mcnaMY0SovtUlxjrEsDblk6
	 Snryi1GhPdtZRxCdoU6Q8MIxand5Uy7Y3RG2Ypa+4utVlODcHx9EX2FA5tqUO9JX4pyg5
	 sXppbJ5yb0/r1n8JIsv/g55e2mEtxWO64k5w6o7XJJwyMW4/l+UewJOP1cb/uXXhQIRus
	 x6mNRGpn+u+aNZlcFEas0RK1Lqfdt0lj8cPwlJnDFvCXTUSZJSY0YPeIde3+mLjHJEUd+
	 y0d4sB0Zsr+HAoLpoVzYzGP+PX207sTnxy7iBGYthjakxraZ7MXCz4q5BpLe4uW/mXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jqVOZSHK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0D8E606BAA7;
	Fri, 13 Nov 2026 16:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jqVOZSHK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CAA11F000C4;
	Fri, 13 Nov 2026 16:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585838;
	bh=6C+zv1fQV5b6nuUmArbgA235hYHu08qwDvZanMItXBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jqVOZSHKbHZJmUvPcNHSoHDBYGnp96zYLJJCbpXOdzTJq/trld+yEEVddVsZ+lrvQ
	 SmxN+L4qTS0EQ1Tc2RmVz+Y2DOPYGictXrJStsVgkOyVkA83JRRweD4u7aeVHz3sDC
	 aIWaOEKPbQLk2gPpQuoH9obTmsaSAaxfqBjNiT0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Kuehling <felix.kuehling@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 375/507] drm/amdgpu: drop the dma-buf reference when a KFD import fails
Date: Fri, 13 Nov 2026 10:51:19 -0500
Message-ID: <20261113153808.905593477@linuxfoundation.org>
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

From: Jesse Zhang <Jesse.Zhang@amd.com>

[ Upstream commit fb900f8bfd8a16126affd186d21001e4c6533324 ]

import_obj_create() takes a reference on the dma-buf for the new kgd_mem,
but the error path after validating the BO doesn't drop it. Since the
validation reserves the BO interruptibly, an import failing with
-ERESTARTSYS leaks the exported BO with its memory, and keeps the module
in use.

Importing a 64 MiB VRAM BO in a loop while getting SIGUSR1
every 20 us and another thread changes the BO's mappings:

  INFO: 171821 imports, VRAM used before 65 MiB, after 129 MiB
  modprobe: FATAL: Module amdgpu is in use.

Drop the reference, and free the sync object and the mutex of the kgd_mem
as well. With that VRAM usage returns to 65 MiB after the same test.

Fixes: 0e2e7c5b3d71 ("drm/amdgpu: Attach eviction fence on alloc")
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit b4d1eca2729840148ff2ea957724ce764ca5a94e)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
index b59329c42597e..501b1a9f27070 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -2475,6 +2475,9 @@ static int import_obj_create(struct amdgpu_device *adev,
 
 err_remove_mem:
 	remove_kgd_mem_from_kfd_bo_list(*mem, avm->process_info);
+	amdgpu_sync_free(&(*mem)->sync);
+	mutex_destroy(&(*mem)->lock);
+	dma_buf_put(dma_buf);
 	drm_vma_node_revoke(&obj->vma_node, drm_priv);
 err_free_mem:
 	kfree(*mem);
-- 
2.53.0




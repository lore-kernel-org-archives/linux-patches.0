Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590512;
	b=OBx4srfE1T0WJQ47Xlm3laiawizWem47DJC3zKlWO4dCM5zWZgNUUotaSivt7kzZHvkw
	 ltj+Q7iYXwYLux1bF3jzUvAQjqQ52/dw7RGvvdar8ygAsbs4+VjUl0PheKeFl6avRvjxV
	 slbnbXC9i5ecNPVNvgofWwlA1LkHYY2ImRizkHVP3dHfBxkTryua3JGicwsPMidAgSvte
	 114V7hXk2NsN79tjtLcvl2cO7QHVwEnIUZMZdBfZRs5xWgR7lWnu9O1dyl/ZHpnB1Mt8a
	 Raw/uh8lXnlBaogoFRS0G8EaZzTuzVKTzJ0NVMz9Yk173YXTAxvICreLYVmHlkQ9+Lg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590512;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kX5tA9D6uZYm6XEgFhXFVS/UUBh+C5WxyKO5h63B78Q=;
	b=nemN2X4XIWt6LVOhhQs6NqhrsdKeRiPtTUVgr7PCcbd87Tsxvq7tnhEtDSb8BXpLBbK0
	 xm60/59VN09pZ0SRdODNf+QIvi2sRw3vmliruUbHIEQUcp0NiPl2/L98tB1gZIdoleTd0
	 eqJ2yNDnTaWgl6iqi+Dl9pOQJySZSQHzv4cgm1+YpBwU7ih0Gbrhip5akNBYXPnkzrFX/
	 i45GnnGhVNCrLb5ziroBtVwvQP8jLm37wxS1KnCRBqryhyhMyx3GPej20HXvW0WbvCwPk
	 rLZ6dOgXVtNq6BojoUoflLoUoqpHE4vYRzTs5eFidyyAkFSxhX+y0LtX5OtEDCFrgCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CuzOsOd8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BA606073208;
	Fri, 13 Nov 2026 17:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CuzOsOd8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27B641F000C4;
	Fri, 13 Nov 2026 17:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590512;
	bh=kX5tA9D6uZYm6XEgFhXFVS/UUBh+C5WxyKO5h63B78Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CuzOsOd8R/wz7x1DkP7RtH9Ojw1yeDvhgx4x7T2ytRufOoi1Md50JrOnpa+VFS0mE
	 eez9TF4n13kkN4ZQXk+yLa9AmLXt3sqcQA9z26G8qYlY5buLqCWY1yv4nJdhnkvJ/i
	 ZlkVBGA2qssGR+TAEXNaw2UgEE1V803WbVWwc8vI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Kuehling <felix.kuehling@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 415/686] drm/amdgpu: drop the dma-buf reference when a KFD import fails
Date: Fri, 13 Nov 2026 10:49:08 -0500
Message-ID: <20261113153835.025036925@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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
index 359ce3f696375..c57d9e4837d68 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -2450,6 +2450,9 @@ static int import_obj_create(struct amdgpu_device *adev,
 
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




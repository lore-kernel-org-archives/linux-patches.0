Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065160;
	b=rBP7vCd+JXsbf/9K5H/m2XnEYUbbm9RYp58XebJ2wAAquAQEzzMYUx30lz8sqSPygHTo
	 sWLOkx6CPd3Lk4uj71RyB5fEK6c+jAw2XNSlcCenw9GT6pPrB6fU7o6dqirjzFKqosfP5
	 0SF4gMtoI4OibNGnZc1ZF2/oNjqh9u2QkaIzPHaaPS7x2aj04AExEa8SfINzHmFP3upCN
	 J+CDManMSmtK1qP20ZYFlhKGeQTAfEUwAPDrJ8ye4sk1pN0c8VmOUHfzk3MCOdK2QrLh3
	 bCGKIvOlgYqa/ZNx5iBglP14DXFTgJyySDXbmXfpmIhsK+kvd7Gm+C40eRSPl+h3UtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065160;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kObEcWgCGXuXrBuEkVws+brHOjoduG4gHTc8zx+X8Z0=;
	b=4b8E1NVyRPt3CwU7Inn72fRgzW3VsUahPrU15PU1VgxJiUK9whaeON+rU5+EHnsULWGn
	 xtPF4H/UVfJ88tfiFp6VAZ23XqQyAIycuJwAKo43ihwAsLDnvj3FeMg92XZRl0RR4s7uc
	 aQx4M4vM3vTaPnzfLaCxTjJYHtEOvjtqOis2RxYkF2oCoPcqVSSHCNyAR0lCv/NxlkVJP
	 6bjxGlHqdaPtkKgbSswhNNJcyB+HU5QqkqSuGAsOvWxMHOY8QiK2YEPKwbM+rG8LUJwNI
	 a0mUnFLqDSlpzUNtmtb2OLs5yJHNh3vYG5fVGIMyAiszL77+lBRsYu9PLkee8HUAz+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zvcvSUmD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90E90606A339;
	Sat,  7 Nov 2026 15:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zvcvSUmD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E4A11F0089F;
	Sat,  7 Nov 2026 15:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065160;
	bh=kObEcWgCGXuXrBuEkVws+brHOjoduG4gHTc8zx+X8Z0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zvcvSUmDjVMFUPNQ1C5vMsU9cNKxPIdR3tCgUOxh8FdXIpDRDtDYz/nwhsOJXARZL
	 tmiAtOePPoqsXqJwEzz0QPJB9vm6DKz0AyS/tRU/oedpdzrpS8xlXlfY4wqaigEUBR
	 XhnRl++5c4SWKQDpivOsqFeoS43QVAi2LrJ4uRuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Phillips <daniel.phillips@amd.com>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0968/1257] amdkfd: Fix memory availability double accounting of kfd pinned objects
Date: Sat,  7 Nov 2026 08:54:24 -0500
Message-ID: <20261107135006.092034972@linuxfoundation.org>
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

From: Daniel Phillips <daniel.phillips@amd.com>

[ Upstream commit 16df12d7158fb55f20d6e985abd1996cbabab9f8 ]

Pinned objects that are not kfd objects reduce the total vram available
to kfd, so we subtract the total size of pinned objects from kdf vram
availability. However this double counts objects pinned by kfd itself,
because they are counted both as used and pinned. So track the total
size of objects pinned by kfd and add it back to kfd availability to
remove the double accounting.

Signed-off-by: Daniel Phillips <daniel.phillips@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit b8257bdb26ca5d9a75f4b81f629422f17afa221b)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h       |  1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c | 11 +++++++++++
 2 files changed, 12 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
index 1b7dc0d3963b8..056dd7375d24f 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
@@ -106,6 +106,7 @@ struct amdgpu_kfd_dev {
 	struct kfd_dev *dev;
 	int64_t vram_used[MAX_XCP];
 	uint64_t vram_used_aligned[MAX_XCP];
+	atomic64_t vram_pinned;
 	bool init_complete;
 	struct work_struct reset_work;
 
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
index d66881684ee56..0ac243467422f 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -1536,6 +1536,11 @@ static int amdgpu_amdkfd_gpuvm_pin_bo(struct amdgpu_bo *bo, u32 domain)
 		pr_err("Error in Pinning BO to domain: %d\n", domain);
 
 	amdgpu_bo_sync_wait(bo, AMDGPU_FENCE_OWNER_KFD, false);
+
+	if (!ret && bo->tbo.resource->mem_type == TTM_PL_VRAM)
+		atomic64_add(amdgpu_bo_size(bo),
+			&amdgpu_ttm_adev(bo->tbo.bdev)->kfd.vram_pinned);
+
 out:
 	amdgpu_bo_unreserve(bo);
 	return ret;
@@ -1558,6 +1563,11 @@ static void amdgpu_amdkfd_gpuvm_unpin_bo(struct amdgpu_bo *bo)
 		return;
 
 	amdgpu_bo_unpin(bo);
+
+	if (bo->tbo.resource->mem_type == TTM_PL_VRAM)
+		atomic64_sub(amdgpu_bo_size(bo),
+			&amdgpu_ttm_adev(bo->tbo.bdev)->kfd.vram_pinned);
+
 	amdgpu_bo_unreserve(bo);
 }
 
@@ -1679,6 +1689,7 @@ size_t amdgpu_amdkfd_get_available_memory(struct amdgpu_device *adev,
 		vram_available = KFD_XCP_MEMORY_SIZE(adev, xcp_id)
 			- adev->kfd.vram_used_aligned[xcp_id]
 			- atomic64_read(&adev->vram_pin_size)
+			+ atomic64_read(&adev->kfd.vram_pinned)
 			- reserved_for_pt
 			- reserved_for_ras;
 
-- 
2.53.0




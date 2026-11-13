Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585754;
	b=wQtuowhzEev8v+TUNeb2pDV6rmD7KP98wKfOkH5r8zB05+I70prxJdBMx2xrA6pSl0K/
	 oxTjvMFDZ4I9Ml3GAlRvZ6twAQ6VqYVrsKZGPeWLwVc1Hagx0aRGRAwhsXJqFl6TDuvC3
	 /POHC5nryyyF7zk5VmrnE+6EgMZvhjtexW1Ef6ab2boYr9lGUvkC6orenzepyIUvU0JfD
	 dU1/H4DbeTHsuSlswWY6l45C5lwZgB+jnUhFeAVxzXZQVrGTuXDZWxq2b8rPAUHspiBpY
	 F2WHD/MR15jx6+4qhknzAchC0qS6yuHUMJ6QUL25DUPEFI+LsfuLh3NVdd8BqUFoG3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585754;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=xBj/pQZda1S80BuzLMO+q+Sm3q2tl4q933QtBKEIgk4=;
	b=bsS8+TMuxvumf5EAXhra3FyCswNLnyhVkId/NgXbV8PcGDODv8sHlZ5ZYNa1IyJQpHNs
	 fghZLuYhsyDPJK0QE1tE+ku1pKcYwT3m6jAvVXlYLLNJubSkGo2aScSjDNQ2U17jR6w4q
	 4VAADgf+SvKuK8Lq83tXYaDbtIrM10Iqp45I+yoWLB+eh6IdeGW7tjQnjlRSU16rBEQBb
	 SUqXX0SWSg6qITjyBLUsb71Buk4b8W1PtV5Zw32fp0HouXzQMpmN0VImusyanSYf2rNju
	 tW8jG9G5zWsVApXtsSjLymBDvae6tHvvbtM/m+bTcAT87SnGtNOtOWBPmEhXPKPDzzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d9UfMQDb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19EFF606AE26;
	Fri, 13 Nov 2026 16:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d9UfMQDb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB13D1F000C4;
	Fri, 13 Nov 2026 16:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585754;
	bh=xBj/pQZda1S80BuzLMO+q+Sm3q2tl4q933QtBKEIgk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d9UfMQDbILqvZ7gLbWLBr2At6V5GM962nB7rwzrHC7PJXLub1C2q/JYHg5P0mLcEy
	 0KhSV8J5v9y8soHBIYGD88LBiS1r9GHdQaXRm4+o/qCoJH3Twe8Iv9OpIoRqDysifU
	 Xh8kzkpvLjxa3roQltOL0oDgYQ9VzU9xNLPUkKv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 349/507] drm/amdgpu: sign extend the addresses GEM_OP(GET_MAPPING_INFO) returns
Date: Fri, 13 Nov 2026 10:50:53 -0500
Message-ID: <20261113153807.263338053@linuxfoundation.org>
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

[ Upstream commit 37cfaaa6b5e9448ef786342d470d0e0b8eb89fa6 ]

GEM_VA takes the GPU virtual addresses above the VA hole sign extended,
like the rest of the UAPI, but GET_MAPPING_INFO reports them without the
upper bits, so they land in the hole. Mappings in the upper half of the
address space can't be recreated or removed with what it returns. On
navi31:

  MAP at 0xffff800100000000                 -> 0
  GET_MAPPING_INFO                          -> addr 0x800100000000
  UNMAP at 0x800100000000                   -> -EINVAL

Sign extend the addresses before handing them out.

Fixes: 4d82724f7f2b ("drm/amdgpu: Add mapping info option for GEM_OP ioctl")
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 9d5524a339390da9145b19bfb40da45640332fb3)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
index afd8502a2bc49..cd05921aede54 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
@@ -1033,6 +1033,7 @@ int amdgpu_gem_va_ioctl(struct drm_device *dev, void *data,
 int amdgpu_gem_op_ioctl(struct drm_device *dev, void *data,
 			struct drm_file *filp)
 {
+	struct amdgpu_device *adev = drm_to_adev(dev);
 	struct drm_amdgpu_gem_op *args = data;
 	struct drm_gem_object *gobj;
 	struct amdgpu_vm_bo_base *base;
@@ -1139,7 +1140,8 @@ int amdgpu_gem_op_ioctl(struct drm_device *dev, void *data,
 
 		amdgpu_vm_bo_va_for_each_valid_mapping(bo_va, mapping) {
 			if (num_mappings < args->num_entries) {
-				vm_entries[num_mappings].addr = mapping->start * AMDGPU_GPU_PAGE_SIZE;
+				vm_entries[num_mappings].addr =
+					amdgpu_gmc_sign_extend(mapping->start * AMDGPU_GPU_PAGE_SIZE);
 				vm_entries[num_mappings].size = (mapping->last - mapping->start + 1) * AMDGPU_GPU_PAGE_SIZE;
 				vm_entries[num_mappings].offset = mapping->offset;
 				vm_entries[num_mappings].flags = mapping->flags;
@@ -1149,7 +1151,8 @@ int amdgpu_gem_op_ioctl(struct drm_device *dev, void *data,
 
 		amdgpu_vm_bo_va_for_each_invalid_mapping(bo_va, mapping) {
 			if (num_mappings < args->num_entries) {
-				vm_entries[num_mappings].addr = mapping->start * AMDGPU_GPU_PAGE_SIZE;
+				vm_entries[num_mappings].addr =
+					amdgpu_gmc_sign_extend(mapping->start * AMDGPU_GPU_PAGE_SIZE);
 				vm_entries[num_mappings].size = (mapping->last - mapping->start + 1) * AMDGPU_GPU_PAGE_SIZE;
 				vm_entries[num_mappings].offset = mapping->offset;
 				vm_entries[num_mappings].flags = mapping->flags;
-- 
2.53.0




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022503;
	b=VZDZMjaBGLBNywluM2LFZ6joHV3ZcbL8AAj55+2mh+VgMcwJbW+OIgCiI3pyxR/FKpiK
	 22K14oeUUqrElzmSgbao+0OkL8bb5m/ySXfsxz+AfzT9nvkIkoQnxcBx1mItOBEjQPDep
	 R5zA8mGkiAonK/e003VMGXotX5YJXchRzoCEeRtW5Fs/3m5ZaCJ0oDHjA25KkkR43d6Xp
	 5sQ1/Ak3BdYcBsgkttvTZJOEB8WcNlJ8jeh/ruf9Z/+LUAs3rEcG4r3Dz2Uf5S4fiTt2c
	 /Xzc1BMpIanmB5Q/HETwWSWa8cFaPFWMhvGdX7pNYKbv0TKxVy0KncfDn1tSmtAc5ZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022503;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=I34DTP0eXjaGUfyxfu71vSthMkdvzZeQtnak+u4dUNg=;
	b=XLbQ0q5t94w+nv9ltyQ11+CKg2HocwQCb9z9CzYS1C36tF9NQLHy86oSWMOLUqPrwktZ
	 8+eduHqocvQMjn2LcK+zQO9YTywbH+o0xV2t83LDDogHStvIvfusmwtGdXW9Qnu0hVaZc
	 LXKhGzSJnLpSduyBnweMVB9FFSF4/iYmFstENMpDjQNqUZDnZPO3t4Jkqrp0aO0WI9W5r
	 ZCiZ8ROIBIMuLVh+nkkHQUgjcQsWfuVpWhvYIhTZLLWbgy6fVESAsw6tso1WHgLtVYxLG
	 dsf/mxUkBc8anzj7+uc+xQ7Mxg332B06Q06XsuJEl13jmn6wmKdHD87BSdlkXebSUBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y0V+2bUh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AE09606A32F;
	Wed, 18 Nov 2026 17:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y0V+2bUh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABEC41F000C8;
	Wed, 18 Nov 2026 17:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022503;
	bh=I34DTP0eXjaGUfyxfu71vSthMkdvzZeQtnak+u4dUNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y0V+2bUhm+P1UA/7pkdh3LhHuLbG29yAGLBOrvNb1pQQNZtaPq3vPhW/VudjePFIY
	 eh2I9jtt2IupsXWTam+gn2c3sXO9bYjy+3ZLpVvlQnMfZeFhOlBUvvyFfZu2QkQCM9
	 f8gRk02AoDo2YYqqvp3cYO2OLb2YMk8Xsfj72iR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0035/2151] drm/amdgpu: sign extend the addresses GEM_OP(GET_MAPPING_INFO) returns
Date: Wed, 18 Nov 2026 15:29:30 +0100
Message-ID: <20261118150122.936615250@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Omitted the unused adev declaration because amdgpu_gmc_sign_extend() is an inline function with fixed address limits. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
index 3b03157faa7e8..d9548f97986ea 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
@@ -1118,7 +1118,8 @@ int amdgpu_gem_op_ioctl(struct drm_device *dev, void *data,
 
 		amdgpu_vm_bo_va_for_each_valid_mapping(bo_va, mapping) {
 			if (num_mappings < args->num_entries) {
-				vm_entries[num_mappings].addr = mapping->start * AMDGPU_GPU_PAGE_SIZE;
+				vm_entries[num_mappings].addr =
+					amdgpu_gmc_sign_extend(mapping->start * AMDGPU_GPU_PAGE_SIZE);
 				vm_entries[num_mappings].size = (mapping->last - mapping->start + 1) * AMDGPU_GPU_PAGE_SIZE;
 				vm_entries[num_mappings].offset = mapping->offset;
 				vm_entries[num_mappings].flags = mapping->flags;
@@ -1128,7 +1129,8 @@ int amdgpu_gem_op_ioctl(struct drm_device *dev, void *data,
 
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




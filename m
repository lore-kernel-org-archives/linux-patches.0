Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53F5315E8B;
	Mon, 30 Dec 2024 15:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573986; cv=none; b=iAN6shBoKxzwqdVRK7Fyi0+qs8xUlGws5NubqsvcYXBHGLvYpBKuUE56I+IV87ejlS1tp+Ji5Dx05xEw7GVcuRxLE/1Z2XaG5LfL8fg++COFRv2Q5bJ3et4vMunqcNLCw2C5HOcNMZIAUv2AjSB3+3LIhvIt7EqVaOgfYJeIGbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573986; c=relaxed/simple;
	bh=9hB/CBMQY978mXaBBuCXBxxWP/gEJnvIX+A5baMpOc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eo2p1Jrn3tgyJruZr9JbsEWTLyT/TIhFvqt1fM0U9Z2SRh+uZxj4Kzdz5IBc5R4o6FywZ1JfiGcKvhTlsjNKKgH1VRrLm6RbWYdBlm96sq7u/Tf8mWfTF7uM+yEEvup4ER9fwzgEL5Uj93VfUPaZRuakkIXq7cGGXqoFMkWyYyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ylcg+bZC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ylcg+bZC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC0EEC4CED0;
	Mon, 30 Dec 2024 15:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573986;
	bh=9hB/CBMQY978mXaBBuCXBxxWP/gEJnvIX+A5baMpOc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ylcg+bZCsxA+ZSXxfOVeauKAnG7L78LTbGmJwJ3hTNOqOiA2uRYQ99kNSLkCZ0zD/
	 /TouGnBODFL7HXYVfPwSef1mVANxVbwSrp9PIpre/kst+PPAnXLR2+x6ZZ+aiPkFQz
	 VITkUGmaY/hcR2bpkveLYLylp8GtatvUlWFrZ5vQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 68/86] drm/amdkfd: reduce stack size in kfd_topology_add_device()
Date: Mon, 30 Dec 2024 16:43:16 +0100
Message-ID: <20241230154214.298519569@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154211.711515682@linuxfoundation.org>
References: <20241230154211.711515682@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 4ff91f218547bfc3d230c00e46725b71a625acbc ]

kfd_topology.c:2082:1: warning: the frame size of 1440 bytes is larger than 1024 bytes

Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2866
Cc: Arnd Bergmann <arnd@kernel.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 438b39ac74e2 ("drm/amdkfd: pause autosuspend when creating pdd")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_topology.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_topology.c b/drivers/gpu/drm/amd/amdkfd/kfd_topology.c
index 8362a71ab707..a51363e25624 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_topology.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_topology.c
@@ -1922,7 +1922,7 @@ int kfd_topology_add_device(struct kfd_node *gpu)
 {
 	uint32_t gpu_id;
 	struct kfd_topology_device *dev;
-	struct kfd_cu_info cu_info;
+	struct kfd_cu_info *cu_info;
 	int res = 0;
 	int i;
 	const char *asic_name = amdgpu_asic_name[gpu->adev->asic_type];
@@ -1963,8 +1963,11 @@ int kfd_topology_add_device(struct kfd_node *gpu)
 	/* Fill-in additional information that is not available in CRAT but
 	 * needed for the topology
 	 */
+	cu_info = kzalloc(sizeof(struct kfd_cu_info), GFP_KERNEL);
+	if (!cu_info)
+		return -ENOMEM;
 
-	amdgpu_amdkfd_get_cu_info(dev->gpu->adev, &cu_info);
+	amdgpu_amdkfd_get_cu_info(dev->gpu->adev, cu_info);
 
 	for (i = 0; i < KFD_TOPOLOGY_PUBLIC_NAME_SIZE-1; i++) {
 		dev->node_props.name[i] = __tolower(asic_name[i]);
@@ -1974,7 +1977,7 @@ int kfd_topology_add_device(struct kfd_node *gpu)
 	dev->node_props.name[i] = '\0';
 
 	dev->node_props.simd_arrays_per_engine =
-		cu_info.num_shader_arrays_per_engine;
+		cu_info->num_shader_arrays_per_engine;
 
 	dev->node_props.gfx_target_version =
 				gpu->kfd->device_info.gfx_target_version;
@@ -2055,7 +2058,7 @@ int kfd_topology_add_device(struct kfd_node *gpu)
 	 */
 	if (dev->gpu->adev->asic_type == CHIP_CARRIZO) {
 		dev->node_props.simd_count =
-			cu_info.simd_per_cu * cu_info.cu_active_number;
+			cu_info->simd_per_cu * cu_info->cu_active_number;
 		dev->node_props.max_waves_per_simd = 10;
 	}
 
@@ -2082,6 +2085,8 @@ int kfd_topology_add_device(struct kfd_node *gpu)
 
 	kfd_notify_gpu_change(gpu_id, 1);
 
+	kfree(cu_info);
+
 	return 0;
 }
 
-- 
2.39.5




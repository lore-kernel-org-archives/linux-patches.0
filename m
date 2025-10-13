Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 090733101D1;
	Mon, 13 Oct 2025 15:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369780; cv=none; b=CHSeiHOUEByRux1T7IfoMZ8ogTKNqn9aer2DDh0tjqUnT+9RYjsLv8QR1qpCqwr0vHbn0WQtdojHLBgRwP08Uvjc3REl7Uxjd73CYTCOrfQTbY5ZGgBQ/kFjKdNiJ6d6/+CEwzsxNJrg4DNCZxJwUNuorSd58TyKzWZ1a0nD7tU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369780; c=relaxed/simple;
	bh=PGInoFUG+GqGxFKCFofDAfrccHtmxjA4baR0y6UUvJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FtwYRpYmbZ+AlHCCkyRotBQ9JUAiniWGeWINjls8eq1CCLFSmXRh5l34LnDaGEYkLByuvEAVlCv1F4DVwJRmWHxHk6+w3LNRN4Pf4yLzuVoOG7+WkpEgF9xNHstS6gYH4iJqvRR/emq9cRUbPjtwPxwQ/BExYSDHncpJS6mDIlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f9dnk0HQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f9dnk0HQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29C65C116B1;
	Mon, 13 Oct 2025 15:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369779;
	bh=PGInoFUG+GqGxFKCFofDAfrccHtmxjA4baR0y6UUvJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f9dnk0HQiYh/+z6PSXUNot7yqC6BQhPJkQaJWC2ZDtL2TNRkEMh2CmU5yD22rCFGT
	 qaZHPSgWEupN2fgiOMpVKjhHYv9F6ZQ5vxIPOsXoMZrSuo0Bqc+WPCJc+evvNC1GFc
	 dy2CjC++Y7gqiigWZyV1y5bXa1GZiy1jUPaxBdbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 365/563] drm/amdgpu: Fix allocating extra dwords for rings (v2)
Date: Mon, 13 Oct 2025 16:43:46 +0200
Message-ID: <20251013144424.500592536@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit ae5c2bee1680436d9bf8bfaca7416496adff0ee0 ]

Rename extra_dw to extra_bytes and document what it's for.

The value is already used as if it were bytes in vcn_v4_0.c
and in amdgpu_ring_init. Just adjust the dword count in
jpeg_v1_0.c so that it becomes a byte count.

v2:
Rename extra_dw to extra_bytes as discussed during review.

Fixes: c8c1a1d2ef04 ("drm/amdgpu: define and add extra dword for jpeg ring")
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c |  3 ++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ring.h | 13 ++++++++++++-
 drivers/gpu/drm/amd/amdgpu/jpeg_v1_0.c   |  2 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c    |  2 +-
 4 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c
index 486c3646710cc..8f6ce948c6841 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c
@@ -364,7 +364,8 @@ int amdgpu_ring_init(struct amdgpu_device *adev, struct amdgpu_ring *ring,
 
 	/* Allocate ring buffer */
 	if (ring->ring_obj == NULL) {
-		r = amdgpu_bo_create_kernel(adev, ring->ring_size + ring->funcs->extra_dw, PAGE_SIZE,
+		r = amdgpu_bo_create_kernel(adev, ring->ring_size + ring->funcs->extra_bytes,
+					    PAGE_SIZE,
 					    AMDGPU_GEM_DOMAIN_GTT,
 					    &ring->ring_obj,
 					    &ring->gpu_addr,
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.h
index 7670f5d82b9e4..12783ea3ba0f1 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.h
@@ -211,7 +211,18 @@ struct amdgpu_ring_funcs {
 	bool			support_64bit_ptrs;
 	bool			no_user_fence;
 	bool			secure_submission_supported;
-	unsigned		extra_dw;
+
+	/**
+	 * @extra_bytes:
+	 *
+	 * Optional extra space in bytes that is added to the ring size
+	 * when allocating the BO that holds the contents of the ring.
+	 * This space isn't used for command submission to the ring,
+	 * but is just there to satisfy some hardware requirements or
+	 * implement workarounds. It's up to the implementation of each
+	 * specific ring to initialize this space.
+	 */
+	unsigned		extra_bytes;
 
 	/* ring read/write ptr handling */
 	u64 (*get_rptr)(struct amdgpu_ring *ring);
diff --git a/drivers/gpu/drm/amd/amdgpu/jpeg_v1_0.c b/drivers/gpu/drm/amd/amdgpu/jpeg_v1_0.c
index 9e428e669ada6..b5bb7f4d607c1 100644
--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v1_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v1_0.c
@@ -557,7 +557,7 @@ static const struct amdgpu_ring_funcs jpeg_v1_0_decode_ring_vm_funcs = {
 	.nop = PACKET0(0x81ff, 0),
 	.support_64bit_ptrs = false,
 	.no_user_fence = true,
-	.extra_dw = 64,
+	.extra_bytes = 256,
 	.get_rptr = jpeg_v1_0_decode_ring_get_rptr,
 	.get_wptr = jpeg_v1_0_decode_ring_get_wptr,
 	.set_wptr = jpeg_v1_0_decode_ring_set_wptr,
diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c
index 706f3b2f484f7..ac55549e20be6 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c
@@ -1984,7 +1984,7 @@ static struct amdgpu_ring_funcs vcn_v4_0_unified_ring_vm_funcs = {
 	.type = AMDGPU_RING_TYPE_VCN_ENC,
 	.align_mask = 0x3f,
 	.nop = VCN_ENC_CMD_NO_OP,
-	.extra_dw = sizeof(struct amdgpu_vcn_rb_metadata),
+	.extra_bytes = sizeof(struct amdgpu_vcn_rb_metadata),
 	.get_rptr = vcn_v4_0_unified_ring_get_rptr,
 	.get_wptr = vcn_v4_0_unified_ring_get_wptr,
 	.set_wptr = vcn_v4_0_unified_ring_set_wptr,
-- 
2.51.0




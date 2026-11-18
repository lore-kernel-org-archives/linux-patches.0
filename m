Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043893;
	b=x5naEk2TS2UZYIGwUvgnUCvOSrvcgzjsFl3mv2XOPHLcA/r3+mo7T35HmSp+/Dpl0bkQ
	 hgW0sMbmNRRWpv9wFQwD3mw+EPZc/yqcmIujbnK5jjCvnyujD3UhQPiAeKnkTijxpnfEO
	 4DnQ44ccfAiCIdhcwSQU8RMWHQaQMQXBOaT0v2jGWWCYbbUkdcM6HiMCel5jMtrjnVk9h
	 GLRfjKjUMgNj3ENPtbPaGrkDqhUkhcbcXFEyt3rxe8dZ8Og+MR/uWD+yf3RoEB1Xx+V1m
	 5qFMkcLv4WoPP0DWJewV+MW5q1ojQV6QcZt7g3ds0jdNWP8FJ/80ym29jKF07MDD4Rw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043893;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/RoYWnbNpQBdsyRb0Yi1S5Z1auMPW7j3luSB1/4oTyo=;
	b=CK6g34w0fIjmM9Ko3Bnz/zWNJI+WC6INeJiZXNl9S1oHEUeS/KBZnQTEjiXhET1L1fQz
	 v7u0vKF+A/dMgZsg9BMwx3Qvz7zTKL/zVzSwh66MN4qEQslKHyyh2JRO7GBSUETHfog6I
	 71jxpY+kfE4x4FqjFu28vSPgt6wgteoZhr7PqYJGxa2sCHAMUbDBhjvEmgE06aEpIhVR9
	 M+kbz80zfUWcgWRuV7SSeV0y7Ma2h4yXcelFdOWeXDiRQNsUdPDXv5PmQ5cAljXwwctPJ
	 SqIl/6KkaTT/yPkmPPEmj4YeGPSn7CRMvVRkUavVgrpqpduIUstnBqLeEyGhZE9Ubrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LnLfPr5g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39C45606A33B;
	Wed, 18 Nov 2026 23:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LnLfPr5g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3488E1F000C4;
	Wed, 18 Nov 2026 23:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043892;
	bh=/RoYWnbNpQBdsyRb0Yi1S5Z1auMPW7j3luSB1/4oTyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LnLfPr5gQqwjFDK3Cvlk8xdwz7TDA+SySPkwz1q3fhI5LM0EaY2sFpIQmT1YcpHCS
	 ihROAuruGzpQ62eR8PqI4pB7zTvXmV7h7uEF9c71q/VPEiVpDFBDZm6qZvvUKA1TIv
	 kpcwUy06t+9YBVAHc+iVe4FMVWhj7odln8lFDA0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sunday Clement <Sunday.Clement@amd.com>,
	Alex Deucher <Alexander.Deucher@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0374/2857] drm/amdkfd: Reject zero-sized AQL queue allocations after size halving
Date: Wed, 18 Nov 2026 15:23:28 +0100
Message-ID: <20261118150214.878629057@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sunday Clement <Sunday.Clement@amd.com>

[ Upstream commit 40ba09e11188d1b7f79d51fc28aca5ea45e0c138 ]

KFD_IOC_ALLOC_MEMORY_OF_GPU with flag
KFD_IOC_ALLOC_MEM_FLAGS_AQL_QUEUE_MEM and size=1 triggers the AQL
wraparound workaround (size >>= 1), reducing size to 0. The resulting
zero passes through PAGE_ALIGN(0) = 0 without validation, bypassing the
per-process VRAM quota check in reserve_mem_limit()
(vram_used + 0 > vram_available is always false).

The fix adds post-halving zero-size validation in the primary
allocation path (amdgpu_amdkfd_gpuvm.c). The check happens after size
halving but before reserve_mem_limit(), and uses err_alignment_size
error path to properly clean up the allocated kgd_mem structure and
mutex.

Cc: stable@vger.kernel.org
Signed-off-by: Sunday Clement <Sunday.Clement@amd.com>
Reviewed-by: Alex Deucher <Alexander.Deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[ sashal: Kept the existing WRITE_ONCE accounting for vram_usage instead of upstream's atomic64_add, while still applying the size = PAGE_ALIGN(size) refactor. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c | 7 +++++++
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c         | 3 ++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
index eabba7037b8ab..59ea50b0962e5 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -1711,6 +1711,12 @@ int amdgpu_amdkfd_gpuvm_alloc_memory_of_gpu(
 		size >>= 1;
 	aligned_size = PAGE_ALIGN(size);
 
+	/* reject AQL queue with size < 2 */
+	if (!aligned_size) {
+		ret = -EINVAL;
+		goto err_alignment_size;
+	}
+
 	(*mem)->alloc_flags = flags;
 
 	amdgpu_sync_create(&(*mem)->sync);
@@ -1784,6 +1790,7 @@ int amdgpu_amdkfd_gpuvm_alloc_memory_of_gpu(
 	amdgpu_amdkfd_unreserve_mem_limit(adev, aligned_size, flags);
 err_reserve_limit:
 	amdgpu_sync_free(&(*mem)->sync);
+err_alignment_size:
 	mutex_destroy(&(*mem)->lock);
 	if (gobj)
 		drm_gem_object_put(gobj);
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
index 0826f8a1da655..0bcbf4ac458ef 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -1151,7 +1151,8 @@ static int kfd_ioctl_alloc_memory_of_gpu(struct file *filep,
 
 		if (flags & KFD_IOC_ALLOC_MEM_FLAGS_AQL_QUEUE_MEM)
 			size >>= 1;
-		WRITE_ONCE(pdd->vram_usage, pdd->vram_usage + PAGE_ALIGN(size));
+		size = PAGE_ALIGN(size);
+		WRITE_ONCE(pdd->vram_usage, pdd->vram_usage + size);
 	}
 
 	mutex_unlock(&p->mutex);
-- 
2.53.0




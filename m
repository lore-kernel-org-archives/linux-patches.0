Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215015;
	b=cHA4uLCGmeM2tVAjtbEqgGHw1Yv3i283k3+X4hH2wQDRefgiz1OKwYK9aYqtWjEdp4mQ
	 Ynq5nirPOcmuoZC0yrqcSbSeQ22V+ItXM0yp5r5kK0z7g1KhHoRF3tnDqgRigKD9yZAyl
	 d3irqQx594SXVqs06Cg2RAagBNlq38B628ARKSZLcMX4XJwZ/AT3LNGUdfUER61GSQh1D
	 qucorV3e8Nq9OWtRYQwJXSehIj20ooI4Dpdd52kgmo7PB9XdrumnqLS28S0vOnxhKp2ny
	 ngr0WNUDIv181YpZBqW9+DhjN7TZlo29F+jZTiMYqi0JwApegbh0FdlOKDiuJtpI2mA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215015;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=gyJqKxlyUr6k0ko8lX+Hqm5hMNlB63LbckHSuQoHaaQ=;
	b=u69X5aoOMReJrzT94VECzdmQEM8bFFaRmT694DNL5Vxm0N75Ex+5IW9w/dDSExKORgfa
	 CxdeMG/m4dI3Awedvi9ytGQPUnRnK603/l9AxaXraJkpoPKmgN3G6iZBuB+F3FW8t25uj
	 wbeOapcLDtRb5oL1as5pJKloXyO+TGsa21dANchbwIpGPSBUHi4+4kWH5tEgGh5J1O9wL
	 58jX69yDDBTZrLAcnNL2TULGRPNhctj0j5DFw6OCzG2wclf7AITwQRxXHvETxjStsEL41
	 yX5jWTKD0fMvAJS1Y+wNlbEbov6735wt1r7vCEXUHHaKsVXCPZ4/2FDWskQLyveGmjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="heb/NFEc";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FD3E606A333;
	Wed, 28 Oct 2026 19:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=heb/NFEc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33A621F031E2;
	Wed, 28 Oct 2026 19:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215014;
	bh=gyJqKxlyUr6k0ko8lX+Hqm5hMNlB63LbckHSuQoHaaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=heb/NFEcSv9+Rk+WppaSpiLsimpkwt8QQBx2HD9GY+jx1KmvMsieBNfW+0RsKRCZm
	 Lqg5uBaurhhumzbR+EeVnWR7/KxOMgHKcS/PgSCnbEDjHmdcp23eLnVCmbCXQldXPi
	 JHyE1F1tlrEynGX7s1CQCySm0vwErIhhLIgiAX9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Shetaia <Amir.Shetaia@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1062/1887] drm/amdkfd: Clear VRAM on allocation to prevent stale data exposure
Date: Wed, 28 Oct 2026 17:52:38 +0100
Message-ID: <20261028170523.575174407@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amir Shetaia <Amir.Shetaia@amd.com>

[ Upstream commit ad52d61d82181dbdb7f05826de38352d5e550cc2 ]

KFD VRAM allocations set AMDGPU_GEM_CREATE_VRAM_WIPE_ON_RELEASE
but not AMDGPU_GEM_CREATE_VRAM_CLEARED, leaving freshly allocated
VRAM with stale data from prior use observable by compute kernels.

The GEM ioctl path already sets VRAM_CLEARED for all userspace
allocations via amdgpu_gem_create_ioctl() and
amdgpu_mode_dumb_create(). The KFD path was missing this flag,
allowing stale page table remnants to leak into user buffers.

This causes crashes in RCCL P2P transport where non-zero data in
ptrExchange/head/tail fields corrupts the protocol handshake.

Signed-off-by: Amir Shetaia <Amir.Shetaia@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
index aaeb915a776d0..eabba7037b8ab 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -1665,7 +1665,8 @@ int amdgpu_amdkfd_gpuvm_alloc_memory_of_gpu(
 	 */
 	if (flags & KFD_IOC_ALLOC_MEM_FLAGS_VRAM) {
 		domain = alloc_domain = AMDGPU_GEM_DOMAIN_VRAM;
-		alloc_flags = AMDGPU_GEM_CREATE_VRAM_WIPE_ON_RELEASE;
+		alloc_flags = AMDGPU_GEM_CREATE_VRAM_WIPE_ON_RELEASE |
+			AMDGPU_GEM_CREATE_VRAM_CLEARED;
 		alloc_flags |= (flags & KFD_IOC_ALLOC_MEM_FLAGS_PUBLIC) ?
 			AMDGPU_GEM_CREATE_CPU_ACCESS_REQUIRED : 0;
 	} else if (flags & KFD_IOC_ALLOC_MEM_FLAGS_GTT) {
-- 
2.53.0




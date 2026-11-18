Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050901;
	b=cP4c+5124mM0J1Nl4L/LRRzjA/ERWKwvFQH8gbl6wa0Xyix7O1ppp6jO/tGKoOBCgog4
	 wqLYdU9uAqQyZ41FjGC8KcurInwL3G9GNi7b7L0/ltnvI0AqEyyNW/8xdng8JgVkf1/Z7
	 VrX3G7s4fcB8T183sIxMiibhyEFG5lHIApS0nkRSUnCNRjKPtUe7yf9YhP8svhtlZeLZw
	 NSwD52DU7npbkk0zzTAtU3Av5j4O/lQMEdCFhR677mRWMaI1cFTj8R4R5ZW4bzlV9EQGF
	 4OmdUDYEbpYb/Zz7/JpsCmL1vT2X7wStHpWjlC9tj7AkJf6akKjCZjcQFVh+I8/89/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050901;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Ap8smpNkD6bhxaLcjuoH+3n/VahlT5bW233bLIO4lQE=;
	b=ri/71oJI2qSzEIw6PgIag0Lgxh1sqIe0RYPLNbR48dqhkJXmZJrskkWJ0SyKaecD+38K
	 6eOZ7+jqGP8q7dtV6v6LtZeiuvm+o627rsc9IBbL60rDIyth3/EADBE2ytD+Np84JEvTs
	 bQXLP2EP4wq/qOW06P6YEYclazQW2yD2dj87k2BJHDGWPhsVqMRRElQ8Sdnq1DGvtYUXa
	 fuadlUx1K+66aLYqflKsDiyQKiZncWEVUjBMZ6/SW/k2w0chXicRzxzbl9PYNYPJVikvR
	 vgv2UnXT3Ou3AeZ8yGYjnz8OKLwn6/ZpdxxyTvV3IjKQ3ufACOks4bVTVyk+AISC28g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="fa/ct3vH";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C022C606A320;
	Thu, 19 Nov 2026 01:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fa/ct3vH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16D3E1F000C4;
	Thu, 19 Nov 2026 01:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050901;
	bh=Ap8smpNkD6bhxaLcjuoH+3n/VahlT5bW233bLIO4lQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fa/ct3vHASyKpbExTIVRBQFrULhACkk8VtdEapkLS6M8dpAnhEglLQKsXpr4K4vtj
	 qmc+mixY21mz+LSXI9T2J754PotVl1kqne3wBzTXNFLZ53krcYtGqBa16X9ht3CpvD
	 9bO6sgFlFBFoplAhShFngH80+Yh/b5emL6vWi6Ow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Yinjie Yao <yinjie.yao@amd.com>,
	Roman Demidov <roman.demidov.nn@gmail.com>
Subject: [PATCH 5.15 0019/2214] drm/amdgpu/jpeg: set no_user_fence for JPEG v2.0 ring
Date: Wed, 18 Nov 2026 15:28:15 +0100
Message-ID: <20261118150010.909083052@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yinjie Yao <yinjie.yao@amd.com>

commit e5f612dc91650561fe2b5b76dd6d2898ec9ad480 upstream.

JPEG rings do not support 64-bit user fence writes, reject CS
submissions with user fences.

Fixes: 6ac27241106b ("drm/amdgpu: add JPEG v2.0 function supports")
Reviewed-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Yinjie Yao <yinjie.yao@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 96179da0c6b059eb31706a0abe8dd6381c533143)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Roman Demidov <roman.demidov.nn@gmail.com>
---
 drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c
@@ -778,6 +778,7 @@ static const struct amd_ip_funcs jpeg_v2
 static const struct amdgpu_ring_funcs jpeg_v2_0_dec_ring_vm_funcs = {
 	.type = AMDGPU_RING_TYPE_VCN_JPEG,
 	.align_mask = 0xf,
+	.no_user_fence = true,
 	.vmhub = AMDGPU_MMHUB_0,
 	.get_rptr = jpeg_v2_0_dec_ring_get_rptr,
 	.get_wptr = jpeg_v2_0_dec_ring_get_wptr,



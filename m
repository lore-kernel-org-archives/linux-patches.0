Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831184;
	b=ynLuoK3F87UfwLS06HROFcWc+mPr47OFPDTzRJn1qoIXQ422GnwTbW+BxEARZXcvwXbo
	 GN2wos5SAtF60+orUc+Q45C2rCvpetrzl+KzeUfXVLHhOZJKmTLGLvv9zBkMPKaUwR2Vs
	 09+K8W71Zj6bE4bLO7zC5XF/KlaBzsolQaNoRp0u3OAJiQ7Kgqvck7mwyvvkQV6NQz+iD
	 +FTTrpDTCJycLhni4ek4OzkYwkLjqY374+jLGHDpG56+HXyC3LtvQzGrruR3joEkAnbVl
	 9//hoqVuMa8gvUCfVfR7vVYCokDsld/4KQmcN/xJhXsroCTuLWMHunraeeTRimpUEPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831184;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0V0FlM1HunvfoFArwVzQInSCbuTYx2kmsSfXBl6ORFs=;
	b=wfYSB2zZ10CeuF6GJ39rLg4a9WZsy51WMDTxFdz7b/6W4hvgUAX+K6R+nXGWVujNbUui
	 mZg2XlGGFtm1IGMoiKkWEjUvDL8d1GbmbT0XcvDbOJAQQgrL44thjbgLIPohIRsJT/8os
	 UTqQcTR/i4o8jk10JGnV1rI2zedo75/6+RKUoC8Ysgj7UNO2uSM/dygL0KFmTAIBLlXqy
	 y76xf+vWq4lEDmM8CZ1NTpGDgRZqmg6MMH99QsmZmPvygfBMNmkc5SULCI64H3xrdWR8I
	 NJli3VTzHQzdA4D02j0z8rX6IwGclSFF+ZX36drLw2WYyXgLdRKYhoBJVXjlGJSb1lA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dOOgQgsj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0621606A332;
	Wed,  4 Nov 2026 22:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dOOgQgsj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D9B91F000C1;
	Wed,  4 Nov 2026 22:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831183;
	bh=0V0FlM1HunvfoFArwVzQInSCbuTYx2kmsSfXBl6ORFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dOOgQgsjxxMIOu6JDI1ZA6Hs0nyYUV4yNM1uRJ99d52trGcg1Dx1NavM37xQh+SR0
	 wQhUdOUnn3cqjZE8rCL4immozvRf7NuSIGT4LP/bmiNM3rLnnOjdR9HGNsbhZem311
	 pcZ0FTrluXi2Scw0sfQ1Ck6X3ltbvWgGCuaBVPY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0510/1005] drm/amdgpu/gfx11: set KMD_QUEUE for kernel gfx queues
Date: Wed,  4 Nov 2026 16:04:03 -0500
Message-ID: <20261104211058.221669559@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

[ Upstream commit 8228688eb40cc116127e80394cb8157417854c70 ]

Set KMD_QUEUE in the GFX MQD and kernel ring control registers so CP
preserves kernel IB VMIDs instead of replacing them with the queue VMID.
Use prop->kernel_queue to distinguish kernel and user MQDs.

Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 893642e0e3b2f5aa818e0ee4a49e2d401d541e3a)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
index a78e8f98f4d00..5ade48c8d43f8 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
@@ -3737,6 +3737,7 @@ static int gfx_v11_0_cp_gfx_resume(struct amdgpu_device *adev)
 	rb_bufsz = order_base_2(ring->ring_size / 8);
 	tmp = REG_SET_FIELD(0, CP_RB0_CNTL, RB_BUFSZ, rb_bufsz);
 	tmp = REG_SET_FIELD(tmp, CP_RB0_CNTL, RB_BLKSZ, rb_bufsz - 2);
+	tmp = REG_SET_FIELD(tmp, CP_RB0_CNTL, KMD_QUEUE, 1);
 	WREG32_SOC15(GC, 0, regCP_RB0_CNTL, tmp);
 
 	/* Initialize the ring buffer's write pointers */
@@ -4145,6 +4146,7 @@ static int gfx_v11_0_gfx_mqd_init(struct amdgpu_device *adev, void *m,
 	tmp = regCP_GFX_HQD_CNTL_DEFAULT;
 	tmp = REG_SET_FIELD(tmp, CP_GFX_HQD_CNTL, RB_BUFSZ, rb_bufsz);
 	tmp = REG_SET_FIELD(tmp, CP_GFX_HQD_CNTL, RB_BLKSZ, rb_bufsz - 2);
+	tmp = REG_SET_FIELD(tmp, CP_GFX_HQD_CNTL, KMD_QUEUE, prop->kernel_queue);
 #ifdef __BIG_ENDIAN
 	tmp = REG_SET_FIELD(tmp, CP_GFX_HQD_CNTL, BUF_SWAP, 1);
 #endif
-- 
2.53.0




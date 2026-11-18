Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038962;
	b=xIm2JyOGVOx5o4HwGP/R62RDhQeGfnAIxw+jVZeUM6Wq5vQePoS91YC3vgWeL5OY8m+F
	 fGHpbw/ZS14wwvloSTRWp3/0bZutuJoYafDtVl+QiTtjtXyJ4EgPXXFTChaVqMIRtRLKU
	 U8lYaB2bee3f9bRQhREOCCKs62mKxu3Wjw4d6mq1n98IwuCK02kCLxmciWCJ35z1e2D5v
	 7d4nCrnvMHJKWtMuKu/fEunD1BD0AktnDm8I+XMo+HPDdpfNdQW0deRwhUkdcnz4fHX/W
	 7hfVFDPTbuf3BawRMxe142+GF8PkOcDwMG0abaMtPMJl7Lhh1sWCn9+tFiYn6SwqEYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038962;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=IKvP/0cXryIzQ4Fth7khu5bL/An3Sdresaxscb7dfUA=;
	b=HlZIowZGJ4L2HMsKp1jKswJ3nFf2UUDfxB8LvXy2OUcmzEpbkKmnn5DNLoNIdiG/xdAO
	 VDFceBUhHdUFqK4MpmjBOMiqd2dEQRF7k18477rTeMu4v/4sqiuzwgXcZH20OD2uo8Lfx
	 Nhjlj3AaQMnMBYTx7HNHcOIE/cXNgZUIowcH9TPYM/68TMx5XCQtIAz9s/tf/1fVirRFL
	 OutFAzzwOLV1R1d79X9er3JOGYzltQNaqh1apPancoKoAqRoeTPoXJvX8o7MsumTHtdHO
	 HJWHGeU8bVW7mRCH5L9CfM5X2jFVNlKg2SfwB87Uzju8i2RHuJV3CaGKRZjdgtZcDwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LkbnRwyZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B0FE606A31C;
	Wed, 18 Nov 2026 21:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LkbnRwyZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB7DA1F000C4;
	Wed, 18 Nov 2026 21:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038962;
	bh=IKvP/0cXryIzQ4Fth7khu5bL/An3Sdresaxscb7dfUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LkbnRwyZYQrALGAAh4Z+KC2fhPaoh+gqvBmVk2lsUtWiHzgYCquDaxQk4IxWe3HN9
	 m/jL3n17XZTrfW1IQEZkNkjGTVEdpQ+Xi5ykmGQ1J/8lWt6/H0qz1KGpf5dRPSGlkY
	 JylWQ/QAEz0bmv/GnvPR40qjkFbgdS0UjU4I5zL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1931/3318] drm/amdgpu: dont walk the CS chunks when allocating them failed
Date: Wed, 18 Nov 2026 15:42:33 +0100
Message-ID: <20261118150419.963774963@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Zhang <Jesse.Zhang@amd.com>

[ Upstream commit ade92d50aad6799a5a9d7e73cd1604fd0576e656 ]

amdgpu_cs_pass1() sets p->nchunks before allocating p->chunks, and the
allocation failure path skips resetting it. amdgpu_cs_parser_fini() then
frees the kdata of nchunks chunks from a NULL array. On navi48 with the
chunk array allocation failed through failslab:

  Oops: general protection fault, probably for non-canonical address 0xdffffc0000000001: 0000 [#1] SMP KASAN NOPTI
  KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
  RIP: 0010:amdgpu_cs_parser_fini+0x35d/0x710 [amdgpu]
   amdgpu_cs_ioctl+0xcae/0x7a20 [amdgpu]
   drm_ioctl_kernel+0x180/0x320 [drm]

Set nchunks once the array exists.

Fixes: d38ceaf99ed0 ("drm/amdgpu: add core driver (v4)")
Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 0c828445757b86aaa3ed2638832d76f450022bdf)
Cc: stable@vger.kernel.org
[ sashal: adapted kvmalloc_objs() to kvmalloc_array() with explicit element size and GFP_KERNEL ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
index 99de46eda59be..6d42290d68fb3 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -214,13 +214,14 @@ static int amdgpu_cs_pass1(struct amdgpu_cs_parser *p,
 	if (IS_ERR(chunk_array))
 		return PTR_ERR(chunk_array);
 
-	p->nchunks = cs->in.num_chunks;
-	p->chunks = kvmalloc_array(p->nchunks, sizeof(struct amdgpu_cs_chunk),
+	/* parser_fini() walks nchunks chunks, set it once they exist */
+	p->chunks = kvmalloc_array(cs->in.num_chunks, sizeof(struct amdgpu_cs_chunk),
 			    GFP_KERNEL);
 	if (!p->chunks) {
 		ret = -ENOMEM;
 		goto free_chunk;
 	}
+	p->nchunks = cs->in.num_chunks;
 
 	for (i = 0; i < p->nchunks; i++) {
 		struct drm_amdgpu_cs_chunk __user *chunk_ptr = NULL;
-- 
2.53.0




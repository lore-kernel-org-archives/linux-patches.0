Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054433;
	b=eSTmOL3Er6NsayveZMVyPPXFzqcXXl/eXuY1nOLf3n1vcoTHcx4O/c0ryVed0S08skuK
	 Q7MulzCsys9cebExgNAW/QjkwN2c64x6PWNBnn7aLVlrWzeoI7sHu41CDfwdUyrNJWhNa
	 nvaEMMW8TRiNMj5DwDK1KmYYPQUbR/oW5CXW5mrrJt7C4rHMrEpNOCI7q/lsk2D80WkE/
	 Ju5kO+SSRjijOmHwFct0dYkAmFGmwlHmnwwNT8eoqXZEuMZ5UxxMtgL5s59TYIHPlB9P2
	 6U1kLiLORF37OJWbDXaNCWELjksHOb8m/zdKDf2S/KUH/FuswGTUqJ0W9tRq7wey2Vw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054433;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Sq/gxdiXkjmxlwzcKw2GWSWIFY7RQcv/vscETFnfsR0=;
	b=Wl/PTll43nN0fK7lqXpn3XHl7rd6Nl5FIuHFWTeyuPUEAVKQML39jXdUWYT4Zki/2hVI
	 3EpkWebn/FpECW3qRu4zDcrV7JDhbub3ceEkFDXSPLN35sQftbMo6Zkna1Bfdpgn/FzHD
	 XngQLHP3lHPCDFsINMciI9b0mN3wK/PKAuXU7YG0/NAYLKpbd03Ij2iYWOI1AlJOiuMPq
	 gseOEgKGt2YXW8D9vFIbik1u9F0LmLqAA3xHFdYEsvv38/JdBdXSkh6EaMUAAgIu/doqO
	 tLcqNRXz0DbCIffp1peGKwAV5TU04YS2Bz4eSSfPlM6z85Jdo8sHFXzAFSb8z6KHWSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N45NdSYj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6B54606A320;
	Thu, 19 Nov 2026 02:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N45NdSYj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E46341F000C4;
	Thu, 19 Nov 2026 02:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054432;
	bh=Sq/gxdiXkjmxlwzcKw2GWSWIFY7RQcv/vscETFnfsR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N45NdSYjo5aJYPjm3Hxp4IrOIL/V0H2fBm3Shteszgl/K3oH6CJe9SBhdlq2pphFa
	 DhAHaVzFSbO0av4z0zacEQn84we5fOPxQVAdqiMcl3madQoFRfqp4hJseFB5tptkTn
	 sJpWiMtSa/n/LwkzdcpGB5OCO/e3GXdWhdtIuNpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1272/2214] drm/amdgpu: dont walk the CS chunks when allocating them failed
Date: Wed, 18 Nov 2026 15:49:08 +0100
Message-ID: <20261118150102.481958435@linuxfoundation.org>
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
[ sashal: adapted kvmalloc_objs() to kvmalloc_array() in amdgpu_cs_parser_init() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
index b461e31b91c25..f2050d657dcd5 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -139,13 +139,14 @@ static int amdgpu_cs_parser_init(struct amdgpu_cs_parser *p, union drm_amdgpu_cs
 		goto free_chunk;
 	}
 
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




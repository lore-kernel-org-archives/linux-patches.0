Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028691;
	b=mS04clLG20LfeFw1e+SPVF+HQOGbLJq9Mcb/DeI90H6EY1D5TnzI3jcVav3kJqNMiuwP
	 wP5eQEyXSiD3Z0uvuklK56Kv2GGsfDsFbIAxA3xVhcRfFLeYkSyb5kG1AMy2QwSxU15F5
	 xV46LkfbttkjDgwnDwzhSzewU8fpGsAfpHmYQn3d6nXOmzcllTVwq7hV1OZyiodR3N1Ou
	 Ud1xnnNA1sJqcADmfI33f32QccoVZmyW5bd/HwqJqk7ONo27yNYZNljpFGGlCY3mgfZZ3
	 0iJ19jQhxZ2d6XjeYNUkpHNEMOfoAj52LLvBIXsxo3vjFZiayoQ8VYLtTFmwdnU3iyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028691;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=epW1BRxWEPl8n28av2JDhglAJjeQxyn0ZBAMfFwe2NM=;
	b=AVB8D93gmfjxeYgaDqyJhJp/Q1Te0f58ltOex4Hui2YeI9mv663mRNUDa+aIl1218PGo
	 5AaAqDdWbdWL1hmlSVhzxldn1cnW9gEP22kd10eqk17AWMu6iOOzQAGUt8Qp4FiO7JzNJ
	 cmR6ZiWd9xAcNQZj7h+5NOyP69vTb+kf3L52qoN7PfoS8Znoa68jqiG3clB+9wbu+Oec3
	 PNMlkROK8U9+j6dtB/RhEFv+1OqTQwop0Fg/LF5gwrSlYEZ44BskUPTEE4wEiq00+Y02y
	 56kbtc4OTGhOVkLqEZVsu7UYDJCGbETpgrl6hryKM4efQXTxijrvm3LCEiLkUrCkzjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IzMOyygc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BA76606A31C;
	Wed, 18 Nov 2026 19:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IzMOyygc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6345F1F000C4;
	Wed, 18 Nov 2026 19:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028690;
	bh=epW1BRxWEPl8n28av2JDhglAJjeQxyn0ZBAMfFwe2NM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IzMOyygcXe8EXcxo+FClDvEozDXLMnQbBs/nT9sHTks44Bt3IHXqbAQNnMADkcbVJ
	 0/9bY4fxKv0q/zCihHOMwY9NcleAn18qI0JFyQMovONq55eMyOClq2Y0/NQu0ZZUJ/
	 yJKugBI3dUwoxp8Jg9veodCbtKJmoZyIQifZ1t68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0085/1756] drm/amdgpu: dont walk the CS chunks when allocating them failed
Date: Wed, 18 Nov 2026 15:36:52 +0100
Message-ID: <20261118150011.650849650@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: used kvmalloc_array() with explicit element size and GFP_KERNEL instead of kvmalloc_objs() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
index c49aabb343a72..364fbaf4e0fa5 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -215,13 +215,14 @@ static int amdgpu_cs_pass1(struct amdgpu_cs_parser *p,
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




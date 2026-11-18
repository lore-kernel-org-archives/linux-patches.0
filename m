Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038495;
	b=aGyA8tZtJasKvFytMfDV9TCjwHJSJVS/35qPjffgbaR7XXlGlivEpphKj905zX2X2FSb
	 59v5fhwI1tOyoDJbkjA5RM//D4wuZQocgHuPCfWZWvGUlz3LnvPVi3mHHMIhfxVJbdvIn
	 plrbJv0UQ5K0cFa7ko6n1JpHqtyneDVLTSKA4FoE+8u1ksDszPgPJNPbSVT+vhnAtcUID
	 CeCACYYk8upWIphLUNhiEYS9mZzJ+ac9zX6w0S2pnHlQw2JKdmDvfDOvslEgfDchDM/+W
	 hgQ51cIZxJNyqzpw8tWhMfoUWXuhQs0BG+AK2EYnNXFql5E4s978idOK6qUmrAzSFnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038495;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ghtT99iCo5YQZU75PDGkM1EhvJFEPMGXfstP8/DOtI0=;
	b=KW0eFQec3f+cSrYM2pRkUf4HyvjnwV8ZZIvvj3QofUl6ReQE1UlhqPlglAUNGMaMMv+X
	 NXdqKz+lfrJdKJvU1EngVW1cFf1cT/c7/Y8koFQatNF0eLopBe0ykXRm0M2oqKUTu//wd
	 H7zBV6p2Zltr+TvNF3WbX+IBGI3V+EEvZHsRH9EjLW4MYP19uUIgeCrVy+mGiHF/qGn7P
	 96uY0OpCW4tNySsZVTEEMg9DI/Nh5C0qGUVdpk7qjrs8cj3iplcIx2xDmNJlwNRbjhwAI
	 nS2bZIFwgETZvms3cSA12jBYv96ZmK+vpjmFTAdtaUSgty+vumFyKVyW1Q10NFz4f1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KGw1w8ac;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 468B6606A31C;
	Wed, 18 Nov 2026 21:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KGw1w8ac
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CD9C1F000C4;
	Wed, 18 Nov 2026 21:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038495;
	bh=ghtT99iCo5YQZU75PDGkM1EhvJFEPMGXfstP8/DOtI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KGw1w8acJ27SAnAJIAd6pUK5Jsgj+pZNXBXlcBWqcITJdig7dtnX9a7oDVz+890gf
	 sK8PxD420OzT8vvQVE/IR5aNea18FaWRAT4W54DVMfOHAU2uITubbfQ3UAfRKYjG+q
	 YGwJPOObJV0d2Q/IrOJ813ORgK+Kx61wIsLz0C3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1763/3318] drm/amdgpu: Use (v)memdup_array_user in amdgpu_cs_pass1
Date: Wed, 18 Nov 2026 15:39:45 +0100
Message-ID: <20261118150414.743244577@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>

[ Upstream commit d4b6274cbf0b0ee92294d699f138b63aa4796ad0 ]

Replace k(v)malloc_array() + copy_from_user() with (v)memdup_array_user().

This shrinks the source code and improves separation between the kernel
and userspace slabs.

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: ba4c3c202919 ("drm/amdgpu: reject CS chunks too large for kvmalloc()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c | 33 ++++++++------------------
 1 file changed, 10 insertions(+), 23 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
index 12000996f7a45..d43bdd14ed4da 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -202,25 +202,17 @@ static int amdgpu_cs_pass1(struct amdgpu_cs_parser *p,
 	struct amdgpu_fpriv *fpriv = p->filp->driver_priv;
 	unsigned int num_ibs[AMDGPU_CS_GANG_SIZE] = { };
 	struct amdgpu_vm *vm = &fpriv->vm;
-	uint64_t *chunk_array_user;
 	uint64_t *chunk_array;
 	uint32_t uf_offset = 0;
 	size_t size;
 	int ret;
 	int i;
 
-	chunk_array = kvmalloc_array(cs->in.num_chunks, sizeof(uint64_t),
-				     GFP_KERNEL);
-	if (!chunk_array)
-		return -ENOMEM;
-
-	/* get chunks */
-	chunk_array_user = u64_to_user_ptr(cs->in.chunks);
-	if (copy_from_user(chunk_array, chunk_array_user,
-			   sizeof(uint64_t)*cs->in.num_chunks)) {
-		ret = -EFAULT;
-		goto free_chunk;
-	}
+	chunk_array = memdup_array_user(u64_to_user_ptr(cs->in.chunks),
+					cs->in.num_chunks,
+					sizeof(uint64_t));
+	if (IS_ERR(chunk_array))
+		return PTR_ERR(chunk_array);
 
 	p->nchunks = cs->in.num_chunks;
 	p->chunks = kvmalloc_array(p->nchunks, sizeof(struct amdgpu_cs_chunk),
@@ -233,7 +225,6 @@ static int amdgpu_cs_pass1(struct amdgpu_cs_parser *p,
 	for (i = 0; i < p->nchunks; i++) {
 		struct drm_amdgpu_cs_chunk __user *chunk_ptr = NULL;
 		struct drm_amdgpu_cs_chunk user_chunk;
-		uint32_t __user *cdata;
 
 		chunk_ptr = u64_to_user_ptr(chunk_array[i]);
 		if (copy_from_user(&user_chunk, chunk_ptr,
@@ -246,20 +237,16 @@ static int amdgpu_cs_pass1(struct amdgpu_cs_parser *p,
 		p->chunks[i].length_dw = user_chunk.length_dw;
 
 		size = p->chunks[i].length_dw;
-		cdata = u64_to_user_ptr(user_chunk.chunk_data);
 
-		p->chunks[i].kdata = kvmalloc_array(size, sizeof(uint32_t),
-						    GFP_KERNEL);
-		if (p->chunks[i].kdata == NULL) {
-			ret = -ENOMEM;
+		p->chunks[i].kdata = vmemdup_array_user(u64_to_user_ptr(user_chunk.chunk_data),
+							size,
+							sizeof(uint32_t));
+		if (IS_ERR(p->chunks[i].kdata)) {
+			ret = PTR_ERR(p->chunks[i].kdata);
 			i--;
 			goto free_partial_kdata;
 		}
 		size *= sizeof(uint32_t);
-		if (copy_from_user(p->chunks[i].kdata, cdata, size)) {
-			ret = -EFAULT;
-			goto free_partial_kdata;
-		}
 
 		/* Assume the worst on the following checks */
 		ret = -EINVAL;
-- 
2.53.0




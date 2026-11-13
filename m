Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591532;
	b=uMcoOvTlosuwQu5sQLx3K0DU2zot9/88bxLjIcMKmdLxJAU1CJ7QxLiHeFnYfeI9VCyd
	 BvO9FWqZWovsP79u0YClqJKlqm/9JmWpYtl2yGu59sg3ySqpzXHLAcLPwg+oVC/ow1tf8
	 GMsKj8xRK22dNkM2duq5io3Ti6KHfDI/+PM00kbeysJyEsvSfevtAC+rNxSBwz7NTAhc0
	 ZNT447Nd3rwI4zhkJFiwNdkcn7d9zWeBLuANFDDvtCRQr9QTxuQmpZfuOB7Dt6CzUb21v
	 VhqXWpNCTkUITtez+InLz6ak6pwNbXEEd+NBX0EzX5j6AdN1qXQ7JnMUitfIaUYki7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591532;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=w7O9qMHLu7wsJNz4+GZsvNEapK6L+CghvbJyIfEYYc4=;
	b=Coq09iEYeYJWTOaiThJqZKV9FN0ZF/ooayriO0qrV+t8Zmk4fBSxbPb7e0Yl1WwBe9gH
	 +Hb4IId6gxu28kRQmFgtnFuSpYVRXyW7WpeTQMRt0ZDB3epLneZixqAoQmVRhP2kKw6Fk
	 GVajZc2aWn6G0nwuWxg8cpCYothhvBFdLXTSoXRjgWUbGeNZuc9iAQcJEpL/upjWK+i6M
	 UoZGJD2vSv6MLI/I+mE6LVclrOA+af1rJhA4DNM9fEXB/IX3TTG8qp2xA0PL5ES2Xil2y
	 FUpE5OHtSgFca3xln9AaGAu2eslNtguhhhHTh35LVlWaQOxEnQbPZuAA9CxQ5VpcJGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oVmQze8C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCB25606D4B0;
	Fri, 13 Nov 2026 17:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oVmQze8C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 886761F000C6;
	Fri, 13 Nov 2026 17:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591532;
	bh=w7O9qMHLu7wsJNz4+GZsvNEapK6L+CghvbJyIfEYYc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oVmQze8CJyaGW5kbkxQrufy4pyXjulY2zttSmhmkJvzPeIpL7+8lqlZH9lOz3z5TJ
	 +vP+ihWsUhJccL4DO0/qoPJ3BW1lJWmxgpmXaHuAJwI8r8izRinfQHTZc7IZOXwmwT
	 AVW8PzxVO9RYcK496tLejRkYuODfuvDsP0WuhDRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 589/670] drm/amdgpu: Use (v)memdup_array_user in amdgpu_cs_pass1
Date: Fri, 13 Nov 2026 10:52:33 -0500
Message-ID: <20261113153831.802406171@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 502872bfde49c..bb207ba59e752 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -203,25 +203,17 @@ static int amdgpu_cs_pass1(struct amdgpu_cs_parser *p,
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
@@ -234,7 +226,6 @@ static int amdgpu_cs_pass1(struct amdgpu_cs_parser *p,
 	for (i = 0; i < p->nchunks; i++) {
 		struct drm_amdgpu_cs_chunk __user *chunk_ptr = NULL;
 		struct drm_amdgpu_cs_chunk user_chunk;
-		uint32_t __user *cdata;
 
 		chunk_ptr = u64_to_user_ptr(chunk_array[i]);
 		if (copy_from_user(&user_chunk, chunk_ptr,
@@ -247,20 +238,16 @@ static int amdgpu_cs_pass1(struct amdgpu_cs_parser *p,
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




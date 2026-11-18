Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047531;
	b=5LMZGQcY5AHP4tiFXZe+m5ALID1aerCpx439/DBRlaxOVKrbBVUNdPJDi1OfUca/1lg8
	 uQxesvn7F5iMBo8fHBKuSPOM31/USbldz3VjBF2oWiOZPskcs9Pg3p/UbSqn2Zu+LirQk
	 RnrjT0l8IzwCmJKhmmyJfsplZsMfA1jFCRNZvFjck2YL1v5GTIRbn+PIuoFXJdmO6LMjY
	 7nHb6io0HJvcY7vJdE3WsDfMYfjG0/kuP30VY1r7oYsQX+I+2QPtk2Bwtd6/hS0lj5fgM
	 OVdG13Ka1F+5+Y8lSguWzic6AYN6T0jZVD3D49v24AxcnTC7Ggord/bcbUb9/64sn/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047531;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=x6/bPuZI2e8clS5KKtjkTY6efTaWUS79omDAcPuml8o=;
	b=v3RwttEhKW8iAJb03ny31pt9p+OnnwKsKC5dR9PjNf4zUjZySUzMz6R7X1geAfonER+a
	 JTHfsuxUNUTgW+DBXWcQl+6tYVUBdSZbO05oQQseQPpLdeVVrFU2sHj6igpaPyKzk3PDI
	 oB1WPdmVb1AD8o/mLcoeNBer3pNOuRuWuMwKNEtTuW/+a132beP5VkxScupsKsVIt6mTU
	 r6nLIrCwaYxc1sLa/FiwHlIYxBl/x/ijcZH34gIi+8C44qWGefGpx5ttyQFHkIKUaPLNj
	 CqtEQFIdmaNciUqNcMZYXo9BUttmdBq5VaB0n6EUR0HBiEE6MkfGN/U+TCpIZM5pQQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TeAyQeKS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A694606A320;
	Thu, 19 Nov 2026 00:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TeAyQeKS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 831141F000C4;
	Thu, 19 Nov 2026 00:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047531;
	bh=x6/bPuZI2e8clS5KKtjkTY6efTaWUS79omDAcPuml8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TeAyQeKStTVwXPZM3n0HHNxcgSQ1b+bOf5pWcOFegjSnvNUtKNmGuZmFu74+0gwna
	 KaQdvOGt0XnwEo45twFkk4ta7hLWKH8M58K93LyCN3CitkUZwDyYHtwXYeM8heW0Cy
	 OcBqphEfUzILF7IwvR6marZjFvXvWNhsbvEtRcuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1671/2857] drm/amdgpu: dont walk the CS chunks when allocating them failed
Date: Wed, 18 Nov 2026 15:45:05 +0100
Message-ID: <20261118150301.496236519@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: replaced kvmalloc_objs() with kvmalloc_array() using an explicit element size and GFP_KERNEL ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
index cac55781798cd..710bf84e2ab48 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -208,13 +208,14 @@ static int amdgpu_cs_pass1(struct amdgpu_cs_parser *p,
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




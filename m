Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060196;
	b=W4jkKZIwy7l04FnOvaMrc+ip2uN8RNtJIPtXxYwHeVEGvn+eO4Ozp3vjLDDaoQSz+cOI
	 PS0Z/ICWYBc6XdoOwVGYcQSPvlGv/54GbZl+ukICPv0H4E8Ksu2cudB97NcM6js5v6+pA
	 HJUYfthH8sAi+mI/cibn+HMwi2Hs6OkcQh6XQgvSDGVVhbUbc9dsJdit0cqZkrrWrDgIM
	 l+4yGfEF93WE8ShdTsK3TQz25d//kb16WHHeAr0MaKW0+mgl3H++uEOuf+P59p+kOMFky
	 /x3r5YfphD+w9MRvHQ4ydUS862IHsuGaE6wmiirL5jNpsNF6+e24Hj0gmiLbMYbq/1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060196;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=viflzBAPb3TpdARDxbmnp85A1tE0w9+CM/5qufbWyyI=;
	b=Ddb6iqELnpNAWJsag66PiXCuOZstcsbtJK7lthUAvSTNWw2KQZGu6ed5VqvFuYMtuD0Z
	 23+Eu27Qnq65rLGBKszznFPDg/IoOJBmP/o+CnEJpdc2BiffMNyPXn3i4zj+G/eCtPLkK
	 Ll3WRAwW4XMJ3x+IQdgz6oKxOOodxtfXYHHVTSHEkhKPkl4zn0xCODnLNBtLJsN7JWdgF
	 MJ5airv7/D3V72Ev5ZnFitFi1Mn3ElkOgs8nfVqnqjm3AS0M8J0Dn7HLQ9+n4EopaxlmB
	 M7ndHyiEjsErj2ugXMQO3j1OoVK8CxCtvJ7hGDQcDjI+EoAnOE9sl1bSG1df8yBNMng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gtPbeMQh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A25A0606A325;
	Thu, 19 Nov 2026 03:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gtPbeMQh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03F861F000C5;
	Thu, 19 Nov 2026 03:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060196;
	bh=viflzBAPb3TpdARDxbmnp85A1tE0w9+CM/5qufbWyyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gtPbeMQhYGu/wTVA+ZTRDGZV9Fh1VU7Gy6Etx3QCffa75ji5xZSTbXzhK0dtQjic/
	 SxbM/3NSL7OgdyDS+xhDW6Vm6OdMz77qZn5zWS9eCAOdNK4aFkh7T4ahz+U0OMrvbr
	 efEiVwQD1Wjtvusup/atpbuBU0Ipf8TT3l3c18ek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1070/1848] drm/amdgpu: dont walk the CS chunks when allocating them failed
Date: Wed, 18 Nov 2026 15:51:48 +0100
Message-ID: <20261118150002.707223560@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Adapted the allocation change from amdgpu_cs_pass1() to amdgpu_cs_parser_init(), retaining kmalloc_array() instead of kvmalloc_objs(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
index 38491f05c9d39..601934f93098c 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -140,13 +140,14 @@ static int amdgpu_cs_parser_init(struct amdgpu_cs_parser *p, union drm_amdgpu_cs
 		goto free_chunk;
 	}
 
-	p->nchunks = cs->in.num_chunks;
-	p->chunks = kmalloc_array(p->nchunks, sizeof(struct amdgpu_cs_chunk),
+	/* parser_fini() walks nchunks chunks, set it once they exist */
+	p->chunks = kmalloc_array(cs->in.num_chunks, sizeof(struct amdgpu_cs_chunk),
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




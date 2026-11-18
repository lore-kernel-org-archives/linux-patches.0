Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022644;
	b=c92KmtWameaUQ7Fr+3BoQWK85jxb+2wDFQN2oFaq6ojn8Kxpl1I9Xrc+PEVLwBRqUCXj
	 z57Iav+h/WAQSW4+IfUvGJOWRvzOG6kg8oAAcQTMa58uWDXuj75+pYWwtSo5+uwtBFi6P
	 wS5LEsJ+ICVoE8ijgS/Z9Dc+iOAvgfZIrK82tE/gVRwDuEsVvfdyjtoIIz0t2mAiV0QD0
	 r/GjtgHAKci72LqZL8FBbDOyp7qiIS5CRj6A4B7LAnSbRaxoYR58NDWOYI1zYphumOd6B
	 gjr8lrMO0wt8IaH4SS4wdwqHEIsL9EjlB4rjx1cJuM791WUcXiFhDo4C3bFcrFIpD9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022644;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=sFM1CbJ36FU8WQiBlxk9i2TWs7TjBwlyyF18o9OHh3o=;
	b=evkbEs7xg4CLuD02619XaWoJJpAMltm6TqesJNujoaOU0K6MXK69z/I69IenN4NxS5bd
	 npRiknNKtdlWdydCPRDFaFBCVIjzs39i7RLdQ2NcdsMqCnk7kgd2cnQIdTqwuSfYGRjN9
	 SH5uNLJkmX8Mfzkq50dPNM455a4JzeHRk6NV83lfBTs0qhYhHwoMyxtCrziljBhDKXnZm
	 3w94YQ3icKb7+1yNJGZ8uyVSv7AYv5maV3OqA6PaQNsbTx+6YpfucyLsbk3d5/CXJHHxN
	 3uocBwxXG6HGw+Wa3o6QJoC90PQEXPz3D0IJk4mpfF5TUtvEk8b1a+0Eaxq+I5poiyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="kb/oNUxm";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8981A606A330;
	Wed, 18 Nov 2026 17:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kb/oNUxm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E416A1F000C4;
	Wed, 18 Nov 2026 17:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022644;
	bh=sFM1CbJ36FU8WQiBlxk9i2TWs7TjBwlyyF18o9OHh3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kb/oNUxmE69w0V5xxaOCy+yATU+qYztJws+Z0wT6dRYdCa7p+4lBNZQ51JXW9uAkq
	 W8JrPeFgZEbHLNv4yI0Wf47173d6MLPsZz108Iy2FYffE5gCLWGWC5PQlAeSo0g3zo
	 nsD6vLIOrIsA2570Sqpn71dFeXn0f5Ysdc2ju0mQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0085/2151] drm/amdgpu: dont walk the CS chunks when allocating them failed
Date: Wed, 18 Nov 2026 15:30:20 +0100
Message-ID: <20261118150124.884108493@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Retained kvmalloc_array() with explicit element size and GFP_KERNEL in place of kvmalloc_objs(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
index 0f6505d4c958b..5a4e7a6623748 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -219,13 +219,14 @@ static int amdgpu_cs_pass1(struct amdgpu_cs_parser *p,
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




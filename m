Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053955;
	b=3s1HlBnudjxLu4JHn4DILZdqaDOjOSI7CgrhVewWq6/+i3o14xhRrgfTamzHj1pU5OyA
	 7KpNHkr3hB6ycQt++8VKhHGCXxf4HNEkFUZPb2cRjltd5FJrodwdBU+8D6QQZ40A8LHLh
	 2fHWtoZEiGSEboZ4Tz+PPZe9TwvlHyxmSuaoG6lLvsfeboruCaAelXGPHXQVaiBveIPnU
	 s3UJ5+Qriq5FnHm8uR9xlElZXRi0TJfL07BzXFK/RBvNrwc8q26+VJRB8KT+rnx+v0he9
	 CU3fL8QaTciiQFHKK2vvSuP5PhkHpp3NCTJF2Z9TzS+t/op7zFyoOm8YEnrROZ5PpiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053955;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=DJY36+y6AT6m5Hm7OKRmeDnTFTd8gqEZFvRLgyVWQJc=;
	b=hvdruaTK5D2Y+8FXPCx43YbpTsWnSvc0HWBfPzLH0pcu8/8noN1zjh/22JcDmNMPlFuo
	 PB1RA7NqcyMYB7U8buwsWoYUeF7omKIuZgMtRXqwQYHUkYD5mgHypLYrGKK8p/+lNvDFn
	 fGdNDvGw6ZVym6+y0imobVO8vrSEoXl+jW3of75dhSNRkNeXBznJPi/MY0cN13CPo6+B8
	 7A9CFLoxlzVXEosmfF2KyMhC+B4JPFS6FAVEYp9JBNmRP7KMuz+C6TKJ2sEQCfLGZDZx9
	 THPj6FTg5cIZIhvRX5dSSXxwbHLRCyf7Lft/12tXzpsigAy4jf8q3P4hAxYFO8L0iLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o6eMgODC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14C7A606A325;
	Thu, 19 Nov 2026 02:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o6eMgODC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C3451F000C4;
	Thu, 19 Nov 2026 02:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053954;
	bh=DJY36+y6AT6m5Hm7OKRmeDnTFTd8gqEZFvRLgyVWQJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o6eMgODCje1sFYFhsk3ojxwqP+qeWHaGt2Ia1L7yVSnNE6cHMTBoGa5PLyF9W5ALm
	 70JkX+nZcf1jF1e0lZU7wwV9v5Si0SZQlguIjuSIk2HKRxNwB6FGvv0wtys2e2QRbZ
	 ekYKRb4/bBNcO2Q6eQbLZj4dc+vVH9NNB6wu8AYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1102/2214] drm/amdgpu: reject CS chunks too large for kvmalloc()
Date: Wed, 18 Nov 2026 15:46:18 +0100
Message-ID: <20261118150056.265911740@linuxfoundation.org>
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

[ Upstream commit ba4c3c202919405f461a393e823e4b72c8518494 ]

The CS ioctl copies every chunk with vmemdup_array_user() before it
looks at it, for whatever length_dw userspace gives. kvmalloc() warns
about allocations above INT_MAX when called without __GFP_NOWARN, so any
process with the render node can trigger a warning. On navi31, a CS with
a chunk of length_dw 0x20000000 returns -ENOMEM after:

  WARNING: mm/slub.c:6841 at __kvmalloc_node_noprof+0x5a5/0x7d0

Reject such chunks with -EINVAL before trying to copy them.

Fixes: 2098105ec65c ("drm: drop drm_[cm]alloc* helpers")
Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit dab5f5280406088591645f499f048dcfefab8d7d)
Cc: stable@vger.kernel.org
[ sashal: Adapted the guard placement from amdgpu_cs_pass1() to amdgpu_cs_parser_init() before the existing kvmalloc_array() call. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
index bb7c1b53c4fab..b28e98ab94ece 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -160,6 +160,12 @@ static int amdgpu_cs_parser_init(struct amdgpu_cs_parser *p, union drm_amdgpu_cs
 		size = p->chunks[i].length_dw;
 		cdata = u64_to_user_ptr(user_chunk.chunk_data);
 
+		if (size > INT_MAX / sizeof(uint32_t)) {
+			ret = -EINVAL;
+			i--;
+			goto free_partial_kdata;
+		}
+
 		p->chunks[i].kdata = kvmalloc_array(size, sizeof(uint32_t), GFP_KERNEL);
 		if (p->chunks[i].kdata == NULL) {
 			ret = -ENOMEM;
-- 
2.53.0




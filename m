Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585789;
	b=GM7siypoB95QkmYv26CQB/kdpYKYue5fosVNZkaQR7YaPatk08uU9Fcg7sAGadE1ftlt
	 aYiqEwcyjfckZ+FRaPwoL4eNoiy3bElhBTB14gb+3SFtvKnAK+smaLUbpYadKWXSH1s8r
	 4KnD6DH4VvhPUXCnNyRtI6Bxc8s1sVABRTgQtlhZGiIcYVDN1JFcSooxa1wbDs31PjlBm
	 APCGjgXi0wLKTi7rNc+NkjfzlI9DwPPBKJ2IQHTK33MjL+hgKkExneVsLfNsKsGp/cAeL
	 lDKla1Ubm3NYB+Ndq7QEjN8AmBnWpvqfZJABOv9Fp5jklsSyP2TNpFzCAa7VDSW+gkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585789;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=JvwFgIgwTlnLsnZgV+zBVbrT0VajcnfFrkhakic+AF4=;
	b=KI91UBosZ9rSzEz/yl4PBFq4PLJJxN9NY8J3navHqoIO02fgGFA7UA2UIzZKUC8Pzi8h
	 0W5c6rKIbPq2NXobF6pMBgOrN7XBVOmM1aoVvRSP4AQ22Xi+GW5Jq2o735FAtOwXWAcmX
	 uwqgLVVXjmhoVmZM/kU1rq2LUYfvLRxE7jPav+kyAtroHHsW0I8NJYed79lQrt6pGVIt+
	 tWYEHTmjNyQzLbBw4DDOB2Rtiz91Or+ot44R2SNn4yHAGPqLDyqeP600BsGqR+0Yx+C/r
	 cds8O7p6hX1aLhBFIYUJXnACDpSfNO3iZ5bhb0H+n60NotUDgdWvObzNqrS9p1YfQnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aFlYd0Ou;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 421D9606D479;
	Fri, 13 Nov 2026 16:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aFlYd0Ou
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1B441F000C7;
	Fri, 13 Nov 2026 16:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585789;
	bh=JvwFgIgwTlnLsnZgV+zBVbrT0VajcnfFrkhakic+AF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aFlYd0OuTgOUw/8bwdas9Hv+Nd0fSVcnlmk/CG0nwrA7Y58aSoquSCZbYlPE28hmQ
	 Dkh3xcFjCDY6U5WzkdJ3OuT5g2Y3NSsI07mesIcu488ufSo2aR2teV6Q2hc9EKRZTu
	 n05Qyg0q1eu86pF2X4mtHAOWL9DJCmCzCIZq6y3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 378/507] drm/amdgpu: dont walk the CS chunks when allocating them failed
Date: Fri, 13 Nov 2026 10:51:22 -0500
Message-ID: <20261113153809.111781154@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
index ba9c7dc084384..2739eab3e57ca 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -202,12 +202,13 @@ static int amdgpu_cs_pass1(struct amdgpu_cs_parser *p,
 	if (IS_ERR(chunk_array))
 		return PTR_ERR(chunk_array);
 
-	p->nchunks = cs->in.num_chunks;
-	p->chunks = kvmalloc_objs(struct amdgpu_cs_chunk, p->nchunks);
+	/* parser_fini() walks nchunks chunks, set it once they exist */
+	p->chunks = kvmalloc_objs(struct amdgpu_cs_chunk, cs->in.num_chunks);
 	if (!p->chunks) {
 		ret = -ENOMEM;
 		goto free_chunk;
 	}
+	p->nchunks = cs->in.num_chunks;
 
 	for (i = 0; i < p->nchunks; i++) {
 		struct drm_amdgpu_cs_chunk __user *chunk_ptr = NULL;
-- 
2.53.0




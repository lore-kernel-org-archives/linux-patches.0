Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036420;
	b=PLUSYrXeF3aOn1G7bm+QrR7Nu9VDPEqon7VRnHCmRzY+/fO3dD9V426q3x2HE3Xa6kQX
	 1iVOzRywQUXcOi4zC96kkgU3InsFozaMy4a2dkJsFNiVFNZ1jkWGNBN6aBEF6KGZqJJiX
	 EpYwqlEUa4pzYVHshZ5qkWEb/0SUVDIsbnFqlaoColNWUtgBAFxSt2ly+y/WcwN9vx70y
	 c9MjAVY/zSYhCfDRPM/Ne/WC9jnepGxLsA7cQLFp8BK7FWkUrL77T4N2dD/h9CUwGwLWb
	 c67Gc2yUjAtuY2gHbGJ+0Y57l7hlmRK/XV62eECC/zumLTXr/xm45oELvaBChoMP5WQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036420;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=6r0WGmUBNV2A+MwsasBGd7zckWrjjjVup4OIZfJTP0A=;
	b=yBGNiYnMiIPjhOtwFxTX0OdfhnfnuBYcItEkAFVbzLEgVDb+j4jE1kyB3MVvjB4vo1FT
	 kjIAdICy1k8NWv7IyypaV5G8zb+WAmTs+vY/MzcJmb9eEXijS282FoSX/lmMWELpV8ylP
	 HofEg1w+UcNIfpz7gyIc2StVzcz7oOgiCMXmu22lrwX1djD8qqjehVTd5aJSZQ8EZK0Dr
	 iEATsTsCpV1rvhkX59Y+YhXsQg5CHfb+/zfpuzd4hm6uHiBwn/poe8oooVaKENNE/TmXA
	 kEyEtXm5JP0aRehgVg0gf+37Qoi+NGWtOmGbCSAOTy+LMHdisMj5pmy4GbrFhD+cDiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DYA4n9He;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 075E4606A337;
	Wed, 18 Nov 2026 21:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DYA4n9He
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A2721F000C4;
	Wed, 18 Nov 2026 21:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036419;
	bh=6r0WGmUBNV2A+MwsasBGd7zckWrjjjVup4OIZfJTP0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DYA4n9HeC3b2EwXy3S5qDZhRkCos7qLR60xeCZM55DAh71W2a3zr+msxcjsCu/3SN
	 QH734s/nl/9KeVZ/pwXfjVPWfG4Tl3pkUQ7FEdnmwTuZZdeqZEOHBxJQe8ptp1ca1A
	 QZpVOx+q4i4hjqhJXHMbwpMnypZrJbGOvX3cAP14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1052/3318] drm/ttm: return an error when kmapping a BO without pages
Date: Wed, 18 Nov 2026 15:27:54 +0100
Message-ID: <20261118150351.488779442@linuxfoundation.org>
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

[ Upstream commit fd485d47437ba1700dd47205a63b9f389a00aa36 ]

ttm_tt objects for imported sg tables (ttm_bo_type_sg, set up by
ttm_sg_tt_init() with TTM_TT_FLAG_EXTERNAL) only have DMA addresses and
no pages array. ttm_bo_kmap() and ttm_bo_vmap() still dereference
ttm->pages for them, so a driver that tries to CPU map such a BO oopses
instead of getting an error:

  BUG: kernel NULL pointer dereference, address: 0000000000000000
  RIP: 0010:ttm_bo_kmap+0x26c/0x300 [ttm]
  Call Trace:
   amdgpu_bo_kmap+0x89/0xb0 [amdgpu]
   amdgpu_userq_fence_read_wptr+0x116/0x170 [amdgpu]
   amdgpu_userq_signal_ioctl+0x3fe/0xbb0 [amdgpu]

Return -EINVAL in that case, like ttm_bo_kmap_try_from_panic() already
checks for a missing pages array.

Fixes: 75a57669cbc8 ("drm/ttm: add ttm_sg_tt_init")
Cc: stable@vger.kernel.org
Suggested-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Signed-off-by: Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>
Link: https://patch.msgid.link/20261009103419.4122940-1-Jesse.Zhang@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/ttm/ttm_bo_util.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_bo_util.c b/drivers/gpu/drm/ttm/ttm_bo_util.c
index 64606104551cd..876af03b71edf 100644
--- a/drivers/gpu/drm/ttm/ttm_bo_util.c
+++ b/drivers/gpu/drm/ttm/ttm_bo_util.c
@@ -355,6 +355,10 @@ static int ttm_bo_kmap_ttm(struct ttm_buffer_object *bo,
 	if (ret)
 		return ret;
 
+	/* Imported sg tables only come with DMA addresses, no pages to map. */
+	if (!ttm->pages)
+		return -EINVAL;
+
 	if (num_pages == 1 && ttm->caching == ttm_cached &&
 	    !(man->use_tt && (ttm->page_flags & TTM_TT_FLAG_DECRYPTED))) {
 		/*
@@ -392,7 +396,7 @@ static int ttm_bo_kmap_ttm(struct ttm_buffer_object *bo,
  *
  * Returns
  * -ENOMEM: Out of memory.
- * -EINVAL: Invalid range.
+ * -EINVAL: Invalid range or the BO has no pages to map.
  */
 int ttm_bo_kmap(struct ttm_buffer_object *bo,
 		unsigned long start_page, unsigned long num_pages,
@@ -465,7 +469,7 @@ EXPORT_SYMBOL(ttm_bo_kunmap);
  *
  * Returns
  * -ENOMEM: Out of memory.
- * -EINVAL: Invalid range.
+ * -EINVAL: Invalid range or the BO has no pages to map.
  */
 int ttm_bo_vmap(struct ttm_buffer_object *bo, struct iosys_map *map)
 {
@@ -512,6 +516,9 @@ int ttm_bo_vmap(struct ttm_buffer_object *bo, struct iosys_map *map)
 		if (ret)
 			return ret;
 
+		if (!ttm->pages)
+			return -EINVAL;
+
 		/*
 		 * We need to use vmap to get the desired page protection
 		 * or to make the buffer object look contiguous.
-- 
2.53.0




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047325;
	b=ez0euZgAeOvamDKJ8WC+ujn15MmuNsszYyW4yS6go2xGSP0UH2vhu4r6uXMBP+LnTwAc
	 x2+M3bOsIdjp0Iq7WfUHK+5yehEv7Bw594qZf7ESkKNN+KfqgxAaybr9fgi6VNl1hV+uK
	 wadV0ZNvn/y9e3Faleeg75fltqq99bxL18+bp8Vhxnas4wsG5Ix/zn7W3eNtr4dtutUXC
	 qatLbHYXbHa/YTUYpHfbLWDhzQHEB8A6tzBjLByf+jGBNT3KAAc6TUMfMU8fHYOL6EymA
	 ooWtizhusaXmeJaBfBu3LLeVyNkkoPUf55TSEx6xRMZ1a/pC1VgiPVxm8zlTpV5qRwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047325;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=qS2zDCCyLU/ZxzIzVRe4o1biUooI8m4dpKw7dXmGQeY=;
	b=bW9FvIIFSYI1jXYEFsd5s2vw0U2J0e76CjeO71yFlGbqOpcnwJoWd+4s7QeEiokoBrIC
	 9rwJHlTU2rjvaIJ5n9x6U27ePDcSpIp+3LHcURskeMQH5AUPeDwTyvgbbVRjnF3zTFoep
	 CxdJL14+V6tPjqdeD+EAbnZax3wCv0jzy9gqDLMWB1ZXVZbQKX/UF1xf6UkRV66KjxhZw
	 QDyHcHOBjJi7QnolCFKEwKO7y1os5Ow2Qx0p12mRDdHHHr/2i4PERf7ReSXYZZk3smTEj
	 7/EbELjUTLr0kSl6gFLlGYIej49gW/XUk0AtT7LpfFW/LTx9bmCrHJAaW6tDX13zM0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=prFixPXg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49D08606A330;
	Thu, 19 Nov 2026 00:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=prFixPXg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 986D41F000C4;
	Thu, 19 Nov 2026 00:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047325;
	bh=qS2zDCCyLU/ZxzIzVRe4o1biUooI8m4dpKw7dXmGQeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=prFixPXgwlB4DkB/mKFAvyXlF+PeRGvVDLli/wGmR+svzTNNFBxrdpcv39OWBI0R5
	 DoN8imZ0hvOWCVEgUUg5GkMmu+yDQzdBteMnKFkD1R5u5B8eOLMZtQ7XI09QDmhG3K
	 A8Mgyv7fHKy+LUPuIyEfCe4pbVfjG+X2crhVsBgE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1557/2857] drm/ttm: return an error when kmapping a BO without pages
Date: Wed, 18 Nov 2026 15:43:11 +0100
Message-ID: <20261118150257.443500206@linuxfoundation.org>
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
[ sashal: Applied the return-value documentation changes to header comments instead of comments beside the implementations. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/ttm/ttm_bo_util.c | 7 +++++++
 include/drm/ttm/ttm_bo_api.h      | 4 ++--
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_bo_util.c b/drivers/gpu/drm/ttm/ttm_bo_util.c
index 7f97c97b49bd2..02d07f4c29b5c 100644
--- a/drivers/gpu/drm/ttm/ttm_bo_util.c
+++ b/drivers/gpu/drm/ttm/ttm_bo_util.c
@@ -335,6 +335,10 @@ static int ttm_bo_kmap_ttm(struct ttm_buffer_object *bo,
 	if (ret)
 		return ret;
 
+	/* Imported sg tables only come with DMA addresses, no pages to map. */
+	if (!ttm->pages)
+		return -EINVAL;
+
 	if (num_pages == 1 && ttm->caching == ttm_cached &&
 	    !(man->use_tt && (ttm->page_flags & TTM_TT_FLAG_DECRYPTED))) {
 		/*
@@ -455,6 +459,9 @@ int ttm_bo_vmap(struct ttm_buffer_object *bo, struct iosys_map *map)
 		if (ret)
 			return ret;
 
+		if (!ttm->pages)
+			return -EINVAL;
+
 		/*
 		 * We need to use vmap to get the desired page protection
 		 * or to make the buffer object look contiguous.
diff --git a/include/drm/ttm/ttm_bo_api.h b/include/drm/ttm/ttm_bo_api.h
index 44a538ee5e2a6..7da454640c991 100644
--- a/include/drm/ttm/ttm_bo_api.h
+++ b/include/drm/ttm/ttm_bo_api.h
@@ -360,7 +360,7 @@ static inline void *ttm_kmap_obj_virtual(struct ttm_bo_kmap_obj *map,
  *
  * Returns
  * -ENOMEM: Out of memory.
- * -EINVAL: Invalid range.
+ * -EINVAL: Invalid range or the BO has no pages to map.
  */
 int ttm_bo_kmap(struct ttm_buffer_object *bo, unsigned long start_page,
 		unsigned long num_pages, struct ttm_bo_kmap_obj *map);
@@ -386,7 +386,7 @@ void ttm_bo_kunmap(struct ttm_bo_kmap_obj *map);
  *
  * Returns
  * -ENOMEM: Out of memory.
- * -EINVAL: Invalid range.
+ * -EINVAL: Invalid range or the BO has no pages to map.
  */
 int ttm_bo_vmap(struct ttm_buffer_object *bo, struct iosys_map *map);
 
-- 
2.53.0




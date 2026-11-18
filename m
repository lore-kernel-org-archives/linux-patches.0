Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054125;
	b=2n0MPbaRvt3SNgrADcC/fusO+LoRD5juPKCZemhkzUYARaxNsJ1+dT27ApxOxQQifDfZ
	 NlnR5urDSsudLM6gJp4CVycLeWgy5SZCvzT/bUib8YTuQmT8EiLm4Zuq0k0a3419RcehU
	 cEhRNjGeGOUuOKfowXSOS6UJVttwHjj6O1nhD7QZx+VeWjsU8DvBJ1RkfXqbrGP+5qlfn
	 Y4/sdbfxdzFrMt5yuDK67aABN13QwHO3PhB8N6x7dcT3O2yheyOJGD809zrRslzlOHktg
	 s/IjLtw/8Na1RPS9K8SDvFNBiSts8B7ESGWIXZ4F5VVHHjE5HrWFF+s0PaebuNCU93Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054125;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=JwZQoXY0XARITKboBG333rvU5YpfD8cDd6OPwAuKXwg=;
	b=gKfRs1guJEubrVzLi4FiJyckTI+vQPBapTcpEZNq0gUEf9y5mukSrWRPGwOMrIbWkP0y
	 /tm315h0/MfdG7wJqyh5zvfnm4xnwVdTED57LaVoNXaw6ZplPcrMEx7EzNJrrg6iCAKhs
	 fCKTnQiUVv64RKhhpvylLBus9FtUFcCEh14+tDWqJicpJCreeyBqR7JxOwS8Z14VPEg5s
	 GpnkUrwHMU/3NJS9fe0uC5GO+bkAIcIaXBo/z5dboi9JPJ560ABXaFZD88vaSjxh+b3sn
	 OKxYjBKFCWlpqo1REx2VYlg9nd40rqZVH6sDk+JUj3D7k+JRMB32uo0+zMgujzAPbeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kqtY9EG3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 016BA606A31C;
	Thu, 19 Nov 2026 02:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kqtY9EG3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 572861F000C4;
	Thu, 19 Nov 2026 02:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054124;
	bh=JwZQoXY0XARITKboBG333rvU5YpfD8cDd6OPwAuKXwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kqtY9EG3uxRSUrl8PIe6aiaQei/fZLzOdRZ9Tqw7tPlNvtjzcNKXS8/Z598jrEGoT
	 Cgut3A5CQyTwCTXzb7lTLFb9OvXYmK6nBhQ7nMcgT6HYuRM3TLG7fgo6sPYuzrdcA1
	 5O2Cp031LUQCzijWJhFbCZDueito9WQdLMs60+fo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1156/2214] drm/ttm: return an error when kmapping a BO without pages
Date: Wed, 18 Nov 2026 15:47:12 +0100
Message-ID: <20261118150058.219282974@linuxfoundation.org>
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
[ sashal: Moved the API documentation updates to the existing header declarations. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/ttm/ttm_bo_util.c | 7 +++++++
 include/drm/ttm/ttm_bo_api.h      | 4 ++--
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_bo_util.c b/drivers/gpu/drm/ttm/ttm_bo_util.c
index abf2d7a4fdf1a..1c582e4824e6a 100644
--- a/drivers/gpu/drm/ttm/ttm_bo_util.c
+++ b/drivers/gpu/drm/ttm/ttm_bo_util.c
@@ -312,6 +312,10 @@ static int ttm_bo_kmap_ttm(struct ttm_buffer_object *bo,
 	if (ret)
 		return ret;
 
+	/* Imported sg tables only come with DMA addresses, no pages to map. */
+	if (!ttm->pages)
+		return -EINVAL;
+
 	if (num_pages == 1 && ttm->caching == ttm_cached) {
 		/*
 		 * We're mapping a single page, and the desired
@@ -429,6 +433,9 @@ int ttm_bo_vmap(struct ttm_buffer_object *bo, struct dma_buf_map *map)
 		if (ret)
 			return ret;
 
+		if (!ttm->pages)
+			return -EINVAL;
+
 		/*
 		 * We need to use vmap to get the desired page protection
 		 * or to make the buffer object look contiguous.
diff --git a/include/drm/ttm/ttm_bo_api.h b/include/drm/ttm/ttm_bo_api.h
index 36f7eb9d06639..ada4d625bf8f7 100644
--- a/include/drm/ttm/ttm_bo_api.h
+++ b/include/drm/ttm/ttm_bo_api.h
@@ -474,7 +474,7 @@ static inline void *ttm_kmap_obj_virtual(struct ttm_bo_kmap_obj *map,
  *
  * Returns
  * -ENOMEM: Out of memory.
- * -EINVAL: Invalid range.
+ * -EINVAL: Invalid range or the BO has no pages to map.
  */
 int ttm_bo_kmap(struct ttm_buffer_object *bo, unsigned long start_page,
 		unsigned long num_pages, struct ttm_bo_kmap_obj *map);
@@ -500,7 +500,7 @@ void ttm_bo_kunmap(struct ttm_bo_kmap_obj *map);
  *
  * Returns
  * -ENOMEM: Out of memory.
- * -EINVAL: Invalid range.
+ * -EINVAL: Invalid range or the BO has no pages to map.
  */
 int ttm_bo_vmap(struct ttm_buffer_object *bo, struct dma_buf_map *map);
 
-- 
2.53.0




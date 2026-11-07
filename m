Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063287;
	b=gG3e+XajCRRL00QDcT2zeR4ZjssTJx3lhJd+55XOsi8PjVOnNe5nWp3jHSK3sRHRo9V2
	 3Sk1aaimCjqYzLK8Bz4Ibxi1QAKKnD6BIx91JIQ6GiO4akAEZGgAYb6rxcMMLOBy3+gCg
	 0nh4WLfW3zxYzWOhXI2j7JtWfPg+DKAcgNVEH/H6C6YA3EJ1MTBwHhQzkDYqvIIK/KIBz
	 3F3ADh7FIgsvLFrvKmn7vioBisVpQiqSMT0zPHKUsv9y+H+Bm3blAuK5Sq0Jlqo62KAnD
	 JNmxbZKnxsmWsnHkSJIK+DjoO/vvilqOygJ8peTO7burFQcRHdcGaGK/q/+GTGhlUug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063287;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=KZEA37x4kLhkf6i2dYyakU8BHiX7mC1YYPDe5O8hu6Q=;
	b=kRahXNpakvb4/bQuUBa/ZGo3l4GOhk5+5h6H0V5fW1MVFyNEM4GeawFPd//KFd4ENlx1
	 gB4sMf+OtBRrSz4/asMSd0R2GyhtDq+Zf6V6ovHzOTzzKcPCHX8aXxCAwBxVBv/Te64u2
	 LGpQYg4py+S8RXNMxxXLdfbjg5hzWOLEfRL/UmjjPTcQ1G5qfy94cZ8yuz+vakFOlXzQJ
	 fBC6M2/6lPr60QgqapKVTI81Cgx9qThMHojOGRG3SvT3S8TCx6DiVQccBG+hPS3I4j26O
	 gKlBCBQLN5+OKlw6MYy7FM4kwRX+JORamuD8qoDnft6jwzdrSRRTrTRu3NHvydIXbKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fEypGPGA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5824606A334;
	Sat,  7 Nov 2026 14:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fEypGPGA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 918EB1F008A5;
	Sat,  7 Nov 2026 14:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063286;
	bh=KZEA37x4kLhkf6i2dYyakU8BHiX7mC1YYPDe5O8hu6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fEypGPGA4zFCp1ZyCQYibdcOsU858TAqi0Y8Q9UKkZWG4av6rmgK9HY/9D2ORpfwI
	 YBXvk7+2nuXPahBtOE6ndHLvmmo+jaywzBA+r59QFF6LUOrv+VWiSrAUNcqav+HYHB
	 NluaUN1jfBhNu3NE/vpRWdpPT+h4BsTsJ8+KynBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 442/869] drm/ttm: return an error when kmapping a BO without pages
Date: Sat,  7 Nov 2026 08:52:04 -0500
Message-ID: <20261107134908.747067063@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
index 7aa35899e33ce..7c1edf8c5c2df 100644
--- a/drivers/gpu/drm/ttm/ttm_bo_util.c
+++ b/drivers/gpu/drm/ttm/ttm_bo_util.c
@@ -359,6 +359,10 @@ static int ttm_bo_kmap_ttm(struct ttm_buffer_object *bo,
 	if (ret)
 		return ret;
 
+	/* Imported sg tables only come with DMA addresses, no pages to map. */
+	if (!ttm->pages)
+		return -EINVAL;
+
 	if (num_pages == 1 && ttm->caching == ttm_cached &&
 	    !(man->use_tt && (ttm->page_flags & TTM_TT_FLAG_DECRYPTED))) {
 		/*
@@ -422,7 +426,7 @@ EXPORT_SYMBOL(ttm_bo_kmap_try_from_panic);
  *
  * Returns
  * -ENOMEM: Out of memory.
- * -EINVAL: Invalid range.
+ * -EINVAL: Invalid range or the BO has no pages to map.
  */
 int ttm_bo_kmap(struct ttm_buffer_object *bo,
 		unsigned long start_page, unsigned long num_pages,
@@ -496,7 +500,7 @@ EXPORT_SYMBOL(ttm_bo_kunmap);
  *
  * Returns
  * -ENOMEM: Out of memory.
- * -EINVAL: Invalid range.
+ * -EINVAL: Invalid range or the BO has no pages to map.
  */
 int ttm_bo_vmap(struct ttm_buffer_object *bo, struct iosys_map *map)
 {
@@ -543,6 +547,9 @@ int ttm_bo_vmap(struct ttm_buffer_object *bo, struct iosys_map *map)
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




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059774;
	b=GXrZcp/kyMOMivthBz61Y7p8qZNbctz5chJk0EHIlyZsLrDMsMduO9BQeYkiWsNcmW7W
	 A+CD9bXzeZ8owNsd9tTuHjHzG1NcpN6UcKTibUG3soRWYPc0OCXDyAxRKCcAOay7j1slq
	 TJYOA0HMT24GyT4CNln4S0f071JMJjhDNp+hWWi19oAsaBae4JwAmrhOAmdb3IY0JTAyI
	 grZgtfXGWhBU52ZT0INW/71DRdHTFih3EoWq5QyJ1Zn9zUp5zTJ5kMz/dNVbxN1M8D1Ja
	 S/QJfVl/2KtgjOUocf2JZQBKlWaD7w9pMINJrbTEQaDyAP2Z2+ds3RyUjMARxOO0RSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059774;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=JMPyjqW+mGPwzA6aITmmZJ+ybcL3c8eWFxtSxLAEieY=;
	b=M7zg8xDfVRpT7AIV0t/qb7vphSuf16oWCNTTAyj2V9GKP4XcCoiSSbJ7onSyUuIDb/PU
	 Viqhv+ZvUwwK+B9sKDe73Jcb9ImByIUBrejlCtk4PdPX+jFJx47w5RrTdLUaEVKhIZ2bu
	 bnECB3/++tNM6LALbUo87TySM+AdtGv++0UQyEYINqWbrajAHddal/SabjDekvvNZENLX
	 n+UPMSKhdrdlVZwEgxRS54BaizjFF9mFS7gNqRGPPXbtCMANgdwf5LohAWpOsUgvE+WAH
	 qrS2Z9/eDG2TUSxbnl5r69aAiMceINsZl3zRziNj1m8DxSv72sZekofHpbx1NvawyOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="y69/19ao";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3BF9606A326;
	Thu, 19 Nov 2026 03:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y69/19ao
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 017441F000C4;
	Thu, 19 Nov 2026 03:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059774;
	bh=JMPyjqW+mGPwzA6aITmmZJ+ybcL3c8eWFxtSxLAEieY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y69/19aouIJjo6YsZ71b6/JUxPUzTsGvw4vJfQnyMYQ8zqvYtDG/m6mh89O8+h/jw
	 cKoUnsfcjRcETUe9tucCaTY6SN29sSe4c8nUqfEQxraqL+ygOn0DnYGmFo1pUO45jo
	 pYxS5wLajBIyh80i0lxMvcmCRe1FYpv0UyqTL8TE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0961/1848] drm/ttm: return an error when kmapping a BO without pages
Date: Wed, 18 Nov 2026 15:49:59 +0100
Message-ID: <20261118145957.214910220@linuxfoundation.org>
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
[ sashal: adapted the check to the existing ttm_tt_populate() mapping path. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/ttm/ttm_bo_util.c | 4 ++++
 include/drm/ttm/ttm_bo_api.h      | 2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/ttm/ttm_bo_util.c b/drivers/gpu/drm/ttm/ttm_bo_util.c
index 1968df9743fcb..d234200e939bd 100644
--- a/drivers/gpu/drm/ttm/ttm_bo_util.c
+++ b/drivers/gpu/drm/ttm/ttm_bo_util.c
@@ -452,6 +452,10 @@ static int ttm_bo_kmap_ttm(struct ttm_buffer_object *bo,
 	if (ret)
 		return ret;
 
+	/* Imported sg tables only come with DMA addresses, no pages to map. */
+	if (!ttm->pages)
+		return -EINVAL;
+
 	if (num_pages == 1 && (mem->placement & TTM_PL_FLAG_CACHED)) {
 		/*
 		 * We're mapping a single page, and the desired
diff --git a/include/drm/ttm/ttm_bo_api.h b/include/drm/ttm/ttm_bo_api.h
index 09ccfee48fb45..ff46de1dcf0b4 100644
--- a/include/drm/ttm/ttm_bo_api.h
+++ b/include/drm/ttm/ttm_bo_api.h
@@ -523,7 +523,7 @@ static inline void *ttm_kmap_obj_virtual(struct ttm_bo_kmap_obj *map,
  *
  * Returns
  * -ENOMEM: Out of memory.
- * -EINVAL: Invalid range.
+ * -EINVAL: Invalid range or the BO has no pages to map.
  */
 int ttm_bo_kmap(struct ttm_buffer_object *bo, unsigned long start_page,
 		unsigned long num_pages, struct ttm_bo_kmap_obj *map);
-- 
2.53.0




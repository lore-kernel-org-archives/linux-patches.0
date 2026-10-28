Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209188;
	b=Gq4kSr60MaA1ugE9H9aTbIbHIpar88UKM+PCwG8mgCVAVyRbwMO5WnKi+efutVZT1ABb
	 Z7mR5dGc6p9fMsCytEqrZe45dEO07Y6FxpNgZo8p2b0SELK8Vh9AECapFnyXLTg+/4gZ3
	 KAHuoTM+17RtTgMndjNpnjeT+CmZsm2YcRDNEMmpwSZy7WWuquV4wfvaWek6cn8vm/XZk
	 xGWR7E1WkuSNvRBk5QlXLga794WHFriC4D2mURjYaqFwDCGiR33wIMNaVkWj4qmvCG6qs
	 O3QGXX1SEm2G3dQtKzSE9FcSVunPTalkfMb20B8N58r2hYYnYuMIbqMw1aVQhpUHgHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209188;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NsoIKDoUYRBC764VElsEZLjMqiIh35aNn3aYpWZOCU8=;
	b=Qb6plh8ew8CJOnETwRb9p/v6qx1yJ9Gw1sUIGMismx7FtlVpVpqDGKlryPm5EhLMM9jC
	 xv0zd2+HBIZVs4n2lX7bkYxq7SIe+SgQhxw1sLmfjIzNna/TUSv2FL0B5SU2PFVSWY2CM
	 njOdjvZGrNBGmyDtu6CSPN3pda+qICUlexpzzlV4U1N/+FscSMpADLMX/l8nWEFiY2qxU
	 /knnXtlPutmVGHzOTM1zV4821UzWs6XuFpoUqhYTdlKYER9IuMeGpkvdRknFBhCfXHCiT
	 WJzfpoOPUK++SiJYFG4Muh10J45spD6u0wjuehs5scyjVCnIkeHk4smAOAOi7mxl2Mw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WjS+4x52;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7F20606A321;
	Wed, 28 Oct 2026 17:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WjS+4x52
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04E0E1F01825;
	Wed, 28 Oct 2026 17:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209187;
	bh=NsoIKDoUYRBC764VElsEZLjMqiIh35aNn3aYpWZOCU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WjS+4x52+4iMllNwsSGYHFaM+jW/jLLdsyG+AXHXbMN2G2FDTRRtU9LbSgD6a0xX9
	 rj+8w+nS9OM4OYbiJse7ekhxCFfq1wMCnHypo+ZZjzf5Cn33is/gWRsuk/hTIXZt3Q
	 w7KJ3psPIoMtR40h+9ZdMBCJBFNNZ3syG+C6SckA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Youness HFA <hfa.youness@gmail.com>,
	Zack Rusin <zack.rusin@broadcom.com>,
	Maaz Mombasawala <maaz.mombasawala@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 384/516] drm/vmwgfx: validate pitch coming from userspace
Date: Wed, 28 Oct 2026 17:58:56 +0100
Message-ID: <20261028170012.578552321@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zack Rusin <zack.rusin@broadcom.com>

[ Upstream commit 21bc51cb89ced74d6645a138cc2f21184bc75094 ]

Validate the pitch, alongside the box dimensions before trying
to copy data from the underlying surface. Fixes possible
out of bounds reads with cursor snooping.

Fixes: 2ac863719e51 ("vmwgfx: Snoop DMA transfers with non-covering sizes")
Cc: stable@vger.kernel.org
Reported-by: Youness HFA <hfa.youness@gmail.com>
Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
Reviewed-by: Maaz Mombasawala <maaz.mombasawala@broadcom.com>
Link: https://patch.msgid.link/20260809204515.211045-1-zack.rusin@broadcom.com
[ sashal: Adapted cursor calculations to existing hard-coded 64-pixel dimensions and 4-byte pixels. ]
[ sashal: Compare against bo->num_pages << PAGE_SHIFT, since bo->base.size is never set for vmwgfx buffer objects on 5.10. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
index 73cbb94ff456b..c7699ddaf042e 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
@@ -151,6 +151,7 @@ void vmw_kms_cursor_snoop(struct vmw_surface *srf,
 	unsigned long kmap_num;
 	SVGA3dCopyBox *box;
 	unsigned box_count;
+	u64 src_extent;
 	void *virtual;
 	bool dummy;
 	struct vmw_dma_cmd {
@@ -159,6 +160,8 @@ void vmw_kms_cursor_snoop(struct vmw_surface *srf,
 	} *cmd;
 	int i, ret;
 
+	BUILD_BUG_ON(sizeof(*srf->snooper.image) != 4);
+
 	cmd = container_of(header, struct vmw_dma_cmd, header);
 
 	/* No snooper installed */
@@ -196,8 +199,19 @@ void vmw_kms_cursor_snoop(struct vmw_surface *srf,
 		return;
 	}
 
+	if (box->w == 0 || box->h == 0)
+		return;
+
+	src_extent = (u64)(box->h - 1) * cmd->dma.guest.pitch +
+		     (u64)box->w * 4;
+	if (src_extent > ((size_t)bo->num_pages << PAGE_SHIFT)) {
+		DRM_ERROR("Cursor snoop source of %llu bytes exceeds the %zu byte buffer\n",
+			  src_extent, (size_t)bo->num_pages << PAGE_SHIFT);
+		return;
+	}
+
 	kmap_offset = cmd->dma.guest.ptr.offset >> PAGE_SHIFT;
-	kmap_num = (64*64*4) >> PAGE_SHIFT;
+	kmap_num = PFN_UP(src_extent);
 
 	ret = ttm_bo_reserve(bo, true, false, NULL);
 	if (unlikely(ret != 0)) {
@@ -211,13 +225,13 @@ void vmw_kms_cursor_snoop(struct vmw_surface *srf,
 
 	virtual = ttm_kmap_obj_virtual(&map, &dummy);
 
-	if (box->w == 64 && cmd->dma.guest.pitch == 64*4) {
+	if (box->w == 64 && box->h == 64 && cmd->dma.guest.pitch == 64*4) {
 		memcpy(srf->snooper.image, virtual, 64*64*4);
 	} else {
-		/* Image is unsigned pointer. */
+		/* The destination stride is in pixels. */
 		for (i = 0; i < box->h; i++)
 			memcpy(srf->snooper.image + i * 64,
-			       virtual + i * cmd->dma.guest.pitch,
+			       virtual + (size_t)i * cmd->dma.guest.pitch,
 			       box->w * 4);
 	}
 
-- 
2.53.0




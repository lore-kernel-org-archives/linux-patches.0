Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213501;
	b=ZQAoAt9/2x47xlfDJR+gOY8k1XdheuhbiyHvg9/cDbeS3Kdm/uW/+e7xbHXYWnnXBwrK
	 ug3nbVtgKt3MtgjvNtCltqfCAA//O7B5QOvNgaSrtU/Uz6JvmJ145xDQ/oxNMZST9cn97
	 OHItdw0oawiAsdlr7ZU2iKovmZN8llr8y/IzIV9oky0FcmKd/kEDsbChMFiVOYOsYedzi
	 9wd+ZUcrwfuanff0hyapUeSIzRaBrMlE02NnU33R8Ezq4+gPeDMVH7RnURM9Pzw2rk8aL
	 ghCkF+IGB0PTIaoACK7XAobao2e+CAGmq3XCnJN+jIYy8jZQrenrd9fUELfu2uMnSSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213501;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Du+nhwfAvdvXII62msEoXaGbmk8rZ4EmByCoMQ9ZShM=;
	b=3qVm49t1IsnUDPeiOV5h+RuDyTixkONyE9JmjbEjB6sV6OQUM/eP5bdY7IwAkxReUgD9
	 jg6g0BsCWkrxxnDkzlDMPWVo18Vq9+MGnm4Cg0oCs5DHsVlL+Qrvig3jmP2oJ5TEXt/Wi
	 WaBVvuIR5oSXIxhtfxwvhTrd0VUGyzWk4vAMcu5nAkUJfwEt8WzkXIBE2+T1kc992oJfy
	 +obhP8FWM+sKafx2k0rvqXYJ5EZ758Y7YjtAeKVGfvBvEp+3dRcsbscsY9dE8fJWsFX5d
	 z5BkXfVHmqW/A78gYgq/A1mNc4zICoTP0za7D1ZYq+EpDDJy/3xvi5OUEWAf/58w5NQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SvmD9EOF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38531606A31A;
	Wed, 28 Oct 2026 18:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SvmD9EOF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89C3B1F01825;
	Wed, 28 Oct 2026 18:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213501;
	bh=Du+nhwfAvdvXII62msEoXaGbmk8rZ4EmByCoMQ9ZShM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SvmD9EOF3fXU6bQUQgyO+Mf6ox05nUNXr44ZmEiMKpSbCTloxwr/Il5ekP1R8SVq1
	 73hAPXQMonLvomTgk+pvVjj0UqW04aiqMTiORE7n3hatWtwYp7AYR1SNNgix7QhiMz
	 5bY3ExT1BBCwI60MPTmreTpHi1BF4H0Tzr7zVuEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Youness HFA <hfa.youness@gmail.com>,
	Zack Rusin <zack.rusin@broadcom.com>,
	Maaz Mombasawala <maaz.mombasawala@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0526/1887] drm/vmwgfx: validate pitch coming from userspace
Date: Wed, 28 Oct 2026 17:43:42 +0100
Message-ID: <20261028170511.305051543@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
[ sashal: Adapted the changes to the existing cursor snooping function using fixed 64×64 dimensions and four-byte pixels. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
index 5210b8084217c..38abdaf663ff6 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
@@ -277,6 +277,7 @@ void vmw_kms_cursor_snoop(struct vmw_surface *srf,
 	unsigned long kmap_num;
 	SVGA3dCopyBox *box;
 	unsigned box_count;
+	u64 src_extent;
 	void *virtual;
 	bool dummy;
 	struct vmw_dma_cmd {
@@ -285,6 +286,8 @@ void vmw_kms_cursor_snoop(struct vmw_surface *srf,
 	} *cmd;
 	int i, ret;
 
+	BUILD_BUG_ON(sizeof(*srf->snooper.image) != 4);
+
 	cmd = container_of(header, struct vmw_dma_cmd, header);
 
 	/* No snooper installed */
@@ -322,8 +325,19 @@ void vmw_kms_cursor_snoop(struct vmw_surface *srf,
 		return;
 	}
 
+	if (box->w == 0 || box->h == 0)
+		return;
+
+	src_extent = (u64)(box->h - 1) * cmd->dma.guest.pitch +
+		     (u64)box->w * 4;
+	if (src_extent > bo->base.size) {
+		DRM_ERROR("Cursor snoop source of %llu bytes exceeds the %zu byte buffer\n",
+			  src_extent, bo->base.size);
+		return;
+	}
+
 	kmap_offset = cmd->dma.guest.ptr.offset >> PAGE_SHIFT;
-	kmap_num = (64*64*4) >> PAGE_SHIFT;
+	kmap_num = PFN_UP(src_extent);
 
 	ret = ttm_bo_reserve(bo, true, false, NULL);
 	if (unlikely(ret != 0)) {
@@ -337,13 +351,13 @@ void vmw_kms_cursor_snoop(struct vmw_surface *srf,
 
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




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212558;
	b=FfVcFq//71blaNnAS/ybQeJEGub0g8ejN2NvRBM5cCfE68lKHHSdmU/CJ/W6WdXgUMT5
	 mYWR2Ft83BITZ5bzlQfeU5hOrQBPGMU8ngDXixmS0hR9uipXQi0gCEy8SSMx6X2HgdAnR
	 ouCGoz+pPSrz0yOxxjCvoNIebR4xfGQN6Zx/aQMZWMZYfK62valcNdkyYnzneqHegu4xc
	 0PxyiE9epBTyg7G9s525hSzNJxsfmKV9BU6XdQ+A7/zBcpmOcPvjolgHWtxLd7mryrGf4
	 KZ6uemurrbh8zy+WnW1RIAQKrXQ/93Xa9m32YCr1VB2azO5Z/nbJz8R6FzzVBk25IQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212558;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dOhGbcgXyX6A4GvIReYBLSA8gMSZuH5+MRJXW+TXhVM=;
	b=regyinFlMiBxaFZilWcGRBoXblbczqyWhR/Hlao0fRxg8ddVt3Kn+9GpjOuNh9OiWowe
	 niri7MgO6D0Mf0ck5L/c6XsW7E2QK38e9G1tkMmmhv5tCJY2UgBYTWmjO9tYwX48Ss8J5
	 JFW9edbZazSzzF3A9vtpVKHy14AE5ZV+jaHjkCBBsEi/Js5KgrxeeWdKQM/8aPnu4Zx/Y
	 waV9VtY79wWYQKgDhAcd3aRuQv8+xFxpI1AV28wLEvEKH+PZ3UgP6O4WtnxykjpmLpP4p
	 e2tyYBDfmXSb4Sh5mwoL4VYnleZSw4fI8z8UOROa2ivq/jRZ/42IkdGeTnxB25Hx3vw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dC7xV9nu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BD2D606A31A;
	Wed, 28 Oct 2026 18:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dC7xV9nu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0F291F01825;
	Wed, 28 Oct 2026 18:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212558;
	bh=dOhGbcgXyX6A4GvIReYBLSA8gMSZuH5+MRJXW+TXhVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dC7xV9nuN3S0we1iYd5WfGjFF3Rle0ATZkhndf2mskutl5eUe5LIrKzLP9lliHeNC
	 WVigv/wXFQUPKYIf7ouceXIYsOVRAqoNv48IpyC3/49mr84TxiNULXtufxB4O8AgXk
	 XLR2yMUe0EFMf/gMbOKLrvchyAAVDk8uYR7B9rjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	CK Hu <ck.hu@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Artem Dinaburg <artem@trailofbits.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0194/1887] drm/mediatek: Fix potential NULL dereference in mtk_crtc_destroy()
Date: Wed, 28 Oct 2026 17:38:10 +0100
Message-ID: <20261028170503.650285570@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 4018651ba5c409034149f297d3dd3328b91561fd ]

In mtk_crtc_create(), if the call to mbox_request_channel() fails then we
set the "mtk_crtc->cmdq_client.chan" pointer to NULL.  In that situation,
we do not call cmdq_pkt_create().

During the cleanup, we need to check if the "mtk_crtc->cmdq_client.chan"
is NULL first before calling cmdq_pkt_destroy().  Calling
cmdq_pkt_destroy() is unnecessary if we didn't call cmdq_pkt_create() and
it will result in a NULL pointer dereference.

[ Backport to 6.1.y: used the older Mediatek CRTC file and helper names. ]

Fixes: 7627122fd1c0 ("drm/mediatek: Add cmdq_handle in mtk_crtc")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: CK Hu <ck.hu@mediatek.com>
Link: https://patchwork.kernel.org/project/dri-devel/patch/cc537bd6-837f-4c85-a37b-1a007e268310@stanley.mountain/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Assisted-by: LLM
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_drm_crtc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_drm_crtc.c b/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
index 59b310f7327c8..8e72b3bb51eb9 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
@@ -161,9 +161,8 @@ static void mtk_drm_crtc_destroy(struct drm_crtc *crtc)
 
 	mtk_mutex_put(mtk_crtc->mutex);
 #if IS_REACHABLE(CONFIG_MTK_CMDQ)
-	mtk_drm_cmdq_pkt_destroy(&mtk_crtc->cmdq_handle);
-
 	if (mtk_crtc->cmdq_client.chan) {
+		mtk_drm_cmdq_pkt_destroy(&mtk_crtc->cmdq_handle);
 		mbox_free_channel(mtk_crtc->cmdq_client.chan);
 		mtk_crtc->cmdq_client.chan = NULL;
 	}
-- 
2.53.0




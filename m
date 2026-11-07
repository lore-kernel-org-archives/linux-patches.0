Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062192;
	b=tmjuUKn3hTBWChtpJFc336L4h9njqRBAiBBjInNtP+Wk9Ppwn7/iXmvr18+MdBF1oBRH
	 R+uvg1KVB7zv0SVjBM0Ug0MXOqT6nclfuxC2Vpa+MGIWMiGcQWBmSA9rmfmDsWOE42TVY
	 6l8nPxJIjvxivqLgW1+sBCObejg2K0Y7J1i30V38hxGLdaxNDtJ3op2palwtDU4uZVGbu
	 2c/mK7CZr/MRmCqSB8+/YE29g6ploL4l8MQrZdw+wdTcsl3sdePL0dR6B2UEG7EIDvtMU
	 YiBOg5wO5Ea1kE4O+tZmfK3QKiJLjk3iwlHWk8Qnmzoi7ugYpAhUHYLp36Ok+172Ayw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062192;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PK+T5ndCels+cUyi8ln7aaSHGJmUP2bjhiLlI5zFipA=;
	b=QgqVkJvydV/8OxXDS9DPgv5H2rMkSXXK3Jhs6AloelFZoUxZD1/4yVcDQ5J64RY7olGr
	 qhngT2q6yfWE8nDUh26Ln41qFmwnddeGu2ORrA23UUr0OVxpeOanK5Jv0Y8PmPZOOEK0z
	 jguewC8/bGfSVv8DjNTPZxGTytBNFnTuLHFTCZ45Sv74utIflozD1ZxAOkok39vYHauox
	 UZF8n7caXTiN7gJBLfO/hh4bpvFXevOagIwTZDGcLsgUyZFVobGW8EYKKU8MVG45u+4Dm
	 P+QEx4L0XyvJMv/q2Vie2Sk73ThEB9bdiWBuF7MXPggTxZAzys4ElpTfvM66008HhsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FcwP1SlB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1072B606A326;
	Sat,  7 Nov 2026 14:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FcwP1SlB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0C171F008A1;
	Sat,  7 Nov 2026 14:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062191;
	bh=PK+T5ndCels+cUyi8ln7aaSHGJmUP2bjhiLlI5zFipA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FcwP1SlBb2bgknXxpEaZqTMcGUkieKfp30CJeia5plDtJL+1nXWjGUjVlMFNCrOw1
	 6FDt5vvRBSAd23u7vDtZoTOlitIdW8vgQge7z61Zps3gGLgLfuIKGlqCVUjAwQmqcb
	 LPPrk9ZcA8Kqy8xXpmj8W6Ny961v7KwO+JuPeVGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1148/1536] media: mediatek: vcodec: destroy core workqueue on remove
Date: Sat,  7 Nov 2026 08:52:44 -0500
Message-ID: <20261107135029.968272845@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit ceb6e96122e1013550f378c738e621a6e82d246b ]

The decoder probe allocates core_workqueue for architectures with a
LAT processor. The probe failure paths destroy the workqueues, but the
remove() function only destroys decode_workqueue.

As a result, removing a decoder on LAT architectures leaves core_workqueue
allocated after the device lifetime has ended.

Destroy core_workqueue during remove for latency-based decoder
architectures, matching the cleanup performed by the probe failure
paths.

This issue was found by manual code inspection.

Fixes: 365e4ba01df4 ("media: mtk-vcodec: Add work queue for core hardware decode")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../media/platform/mediatek/vcodec/decoder/mtk_vcodec_dec_drv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/mediatek/vcodec/decoder/mtk_vcodec_dec_drv.c b/drivers/media/platform/mediatek/vcodec/decoder/mtk_vcodec_dec_drv.c
index fc920c4d6181a..00a6a50e41350 100644
--- a/drivers/media/platform/mediatek/vcodec/decoder/mtk_vcodec_dec_drv.c
+++ b/drivers/media/platform/mediatek/vcodec/decoder/mtk_vcodec_dec_drv.c
@@ -571,6 +571,8 @@ static void mtk_vcodec_dec_remove(struct platform_device *pdev)
 	struct mtk_vcodec_dec_dev *dev = platform_get_drvdata(pdev);
 
 	destroy_workqueue(dev->decode_workqueue);
+	if (IS_VDEC_LAT_ARCH(dev->vdec_pdata->hw_arch))
+		destroy_workqueue(dev->core_workqueue);
 
 	if (media_devnode_is_registered(dev->mdev_dec.devnode)) {
 		media_device_unregister(&dev->mdev_dec);
-- 
2.53.0




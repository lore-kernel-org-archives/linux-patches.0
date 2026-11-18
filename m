Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036272;
	b=1oeStw99Psfs3S8DTnfCi/xjA5InWHyL99VkIfLEwqF58tRAk6+3v/0ZEz1pparP0J+L
	 PD7pKbOnM3c9oddM+fLA/MmwyZuERe+vzHmKw0lkvIfKIjR0Ec008Yv7I7/ozLG+u1W7o
	 BTQuiDCau/UYIwJBacRn/EyKwE2QlCSNPIWmuclC5FbcTta6szJ3tCYewRRbrajh9KPeL
	 bYhwRQrxgFXS/vtvotnglonOIUaR5PyQgok0bKejdpsRlSKbiR4clGkvCVuxahCLG+Bzf
	 i590jEC1wp65STmsBdxkjWOZ4kWquVWeDxZaLjWN/SfmsmJWzZXGac1niRkc8z5ppRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036272;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Wb3dBVZB3IeedYQ3Ctdl3WZW/NyX6n0fxRVZv6IVxL8=;
	b=VKR7NzYPepTbRCY31dOnFLZZdmIyv2X+6ORl91okYHG2ouJXjmCzrCnbYeb3Hj6chuKX
	 jd6gzvbLG83LVjlFi4rr6Cep2G54I4Gm4k3of/nuNlbTqns0Atutp252Q2hE/43jyESmZ
	 I5O+YfZyRsfU7r9eo6rZ+7FXrt7N1Mv93EWDJIq/XNG7w7kFQe1rX9aSpg777y7/LM3D5
	 rrGwzoEB0lY0KCuD5/mj/hJF8l4aHUv5WtD4atLMVLil6nRMHe3GLlyL/GQoNdq17YDgY
	 N215x0ScvIGjt+k0wKCersqquLzDCcYlxXunIlieFN6pmJdpCp8P2/oYwMYaBWNGy1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Pb0J+ZFg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99DD2606A325;
	Wed, 18 Nov 2026 21:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Pb0J+ZFg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E75A91F000C4;
	Wed, 18 Nov 2026 21:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036272;
	bh=Wb3dBVZB3IeedYQ3Ctdl3WZW/NyX6n0fxRVZv6IVxL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pb0J+ZFgYIefeOjNvJjXp71e5XChpc7Rm4mWS+9SlWYYFBti7Af8w3jxRzKBT+EBh
	 i/ShMPlMJxorotR7lz647twQHLFeex0N0Erp4Hs78Hj3JdanyC/qIJsTzYjnM0Ai2N
	 bf9x44sjxWAMjslxDUtSxjOGs9w4VcxpFIZTwUYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0999/3318] media: mtk-jpeg: Fix runtime PM leak in mtk_jpegdec_worker()
Date: Wed, 18 Nov 2026 15:27:01 +0100
Message-ID: <20261118150349.823321055@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit befd4506174addc5e85641b4ef304c9247b48c55 ]

pm_runtime_get_sync() leaves the device's runtime PM usage count
incremented even when it fails.  mtk_jpegdec_worker() jumps to
dec_end on that failure, which does not call pm_runtime_put(), so
the reference taken by the failed resume is leaked.

Use pm_runtime_resume_and_get() instead, which drops the reference
again when resuming the device fails.

Fixes: dedc21500334 ("media: mtk-jpegdec: add jpeg decode worker interface")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c b/drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c
index 077089e134506..ddc74a0da6522 100644
--- a/drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c
+++ b/drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c
@@ -1744,7 +1744,7 @@ static void mtk_jpegdec_worker(struct work_struct *work)
 	jpeg_dst_buf->frame_num = ctx->total_frame_num;
 
 	mtk_jpegdec_set_hw_param(ctx, hw_id, src_buf, dst_buf);
-	ret = pm_runtime_get_sync(comp_jpeg[hw_id]->dev);
+	ret = pm_runtime_resume_and_get(comp_jpeg[hw_id]->dev);
 	if (ret < 0) {
 		dev_err(jpeg->dev, "%s : %d, pm_runtime_get_sync fail !!!\n",
 			__func__, __LINE__);
-- 
2.53.0




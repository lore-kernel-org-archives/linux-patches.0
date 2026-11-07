Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064431;
	b=ACUXoxBYU/5+IoxYYHNLdiwVyZ1tX/1oXxNrVEMdS+zvvN25n2D4oLk2cDutPKmVT48W
	 8TbyYKOpdMOPls8OFcJPhk9Dyli7cN22dUnW+eiPNttZyMY36shlaoSCatYuWVwHKxPOa
	 KhmP6rrpzJkN30Mm8Xq0z7Ysxb4HG7yUuNPRjWd0TmtvXCJF+XrkxNjT7LccNe0ZjMjLX
	 4gUV7w5Ofw3KS5Y8IjfieT1YhbLQ58av1CB3MCn5/KOCS7PnyWWtSFqhV9YEf7wOnS8qN
	 SzJl0hvjOAViLoNpD/ZWuVZ8GdQsyTnckfoBhhMgA6jZy8pyUUYPL5g0WTaWSgLkHOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064431;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=F1NTfoq60vkYg/5KBtzC7c2pZ48xcwpRsQS6aRguSSk=;
	b=CiT26InipPJ4lZdf+PFcfYq3zLx0F/d7AS571i51EPiHvQeIzlTS77TjSznwELM6EBlU
	 jK1jqxolE10fEij/oYSF40gVWOXARqupxZsd0EMzzyeHGNof3ShpsD+2RBl72oRSsh36y
	 gjqwV2RgUMnLNa1bcafPE6lLD6UvINBgY32iUC017ETR+t9CJ+rcg80OY//CDftmDp81N
	 HHI9PJpu2CgVbP+8Qu+bdIaggtPrcAvhDLl8L/9FBNYbMnjBtn5dn6McvtO9bmKlhS3Cx
	 7WFZoXUUIN/zV2tWSl/TkKo/R8oimLbS6IjHuOq/JOPeFiKhS+Wd5/gNSZ2Lu/W4p7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xqbx7imJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9354B606A326;
	Sat,  7 Nov 2026 15:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xqbx7imJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 404621F0089F;
	Sat,  7 Nov 2026 15:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064431;
	bh=F1NTfoq60vkYg/5KBtzC7c2pZ48xcwpRsQS6aRguSSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xqbx7imJKH1O/gSNZvmDtWR7fr5VlVfbmIcbcLNb2sAuuaJpYx0MWg3scloy06Kjt
	 KXJNhGwEQFpMiWs0tCf3/daY/2YvwmPO84eceQfme8v0h9kAjZL/U7Wp7nWRD9Pljt
	 5v2zhRFAnvGrQSwD581/NNlpiD7FJZZB4VgPIEgE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kazuki Hanai <hnkz.64@gmail.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0462/1257] media: mediatek: jpeg: Avoid context access after job finish
Date: Sat,  7 Nov 2026 08:45:58 -0500
Message-ID: <20261107134952.225733186@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kazuki Hanai <hnkz.64@gmail.com>

[ Upstream commit 7c7f31405b76acd95a628c834ee8a2d6da439782 ]

v4l2_m2m_job_finish() publishes job completion and wakes waiters
before it returns. A concurrent file release can therefore finish
v4l2_m2m_ctx_release() and free the context while the single-core IRQ
handler continues with its tail.

Both handlers only need the device for the matching runtime PM put.
Use the IRQ-owned jpeg pointer instead of dereferencing ctx after
completion has been published. This preserves the get/put pairing and
removes the post-completion context access.

Fixes: 45f13a57d813 ("media: platform: Add jpeg enc feature")
Fixes: 5827e4b14ee7 ("media: platform: Improve power on and power off flow")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5
Signed-off-by: Kazuki Hanai <hnkz.64@gmail.com>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c b/drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c
index 906174302476c..bddd0a070d665 100644
--- a/drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c
+++ b/drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c
@@ -1574,7 +1574,7 @@ static irqreturn_t mtk_jpeg_enc_done(struct mtk_jpeg_dev *jpeg)
 	v4l2_m2m_buf_done(src_buf, buf_state);
 	v4l2_m2m_buf_done(dst_buf, buf_state);
 	v4l2_m2m_job_finish(jpeg->m2m_dev, ctx->fh.m2m_ctx);
-	pm_runtime_put(ctx->jpeg->dev);
+	pm_runtime_put(jpeg->dev);
 	return IRQ_HANDLED;
 }
 
@@ -1856,7 +1856,7 @@ static irqreturn_t mtk_jpeg_dec_irq(int irq, void *priv)
 	v4l2_m2m_buf_done(src_buf, buf_state);
 	v4l2_m2m_buf_done(dst_buf, buf_state);
 	v4l2_m2m_job_finish(jpeg->m2m_dev, ctx->fh.m2m_ctx);
-	pm_runtime_put(ctx->jpeg->dev);
+	pm_runtime_put(jpeg->dev);
 	return IRQ_HANDLED;
 }
 
-- 
2.53.0




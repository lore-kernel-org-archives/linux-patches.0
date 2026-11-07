Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064380;
	b=TNaaGkxJvrxDNkEi2p75Ycz+T1qQZwIACf+3FaUCnPyaX8nt+FHPQlb9Mkd/bn2dzhta
	 K/L2AH3RALkU5lX+nNj0XxZM6lyog0qYl3U4+OFnesdb4Fhep7oHV6DInxN8wHsfFYRaF
	 RQiOnNLkDqhx/yRe6qZkhoqjOwPXhGVrvrdWFC676dtr7BEgNcm7bcuhSOzwj4pVO6pib
	 zkEq3KfZHBUq0t+x5jzb4FaZbDtP+yFv32sY5nkyy/8B8gLgix7VjpTxCicN6yTD4ggov
	 d+CvBfuW9mNyJ3HnPuk40npC0cCT9hJ2GkLOitOzVmM1vP1olLTs7Jj1U7s1rdwernw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064380;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=niKhpQHs0KYs3Y4Y2JhNVwn/bmZQ24c/+ZqlYBcJcaY=;
	b=aYXTZ8CfNX2KWeBYMqY2UcWcYV7pY6lbJ+SWR/bZpAEbweuMYYJo/sUSoxr8L+dWGN7n
	 iCG86pzbWQtqI5L5VnMuMggfV1Ale29w0MXgVggTkKH0UkP6wTt1BpeskPCy3TgzbRfGg
	 l8ZL8d3EGwENMsRhNkfYtPokPlMy+Hw7AF0/UfAPM2hSl1cmiPbRZ7dVOWU6Qd2WvIqv2
	 mhuXSU7QVxbu+X1ADkraJAOQcaCV0QYwKX/NZMSfR+wGW1ycuJgTJo2/vaHfH7NSVAuEI
	 w+2ie257b8KHGikNIJUNZULaxakVWBQcKF2U0w3fRz9+J6kzBAO3OVfWdZXPmkejwog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FyXKUgFm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFEFA6083622;
	Sat,  7 Nov 2026 15:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FyXKUgFm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E1A91F008A2;
	Sat,  7 Nov 2026 15:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064379;
	bh=niKhpQHs0KYs3Y4Y2JhNVwn/bmZQ24c/+ZqlYBcJcaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FyXKUgFmCIaOpZkReyo2soH1bbuVF3MDdrsDJJXUSqIAkpm7kpOmB62IhbfE+Boon
	 /wDahA2d/40W56NV8iSU+WfQ0q7rALXHJUi79mKlOe9SA2Wev/iJucScku3Bj9nA1J
	 81N6wcxI5JUYJyPdTSbcwJXtB3WBrUsoWvzlHaDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0457/1257] media: mtk-jpeg: Fix runtime PM leak in mtk_jpegdec_worker()
Date: Sat,  7 Nov 2026 08:45:53 -0500
Message-ID: <20261107134952.093810403@linuxfoundation.org>
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
index d147ec4830811..af44d581e4980 100644
--- a/drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c
+++ b/drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c
@@ -1733,7 +1733,7 @@ static void mtk_jpegdec_worker(struct work_struct *work)
 	jpeg_dst_buf->frame_num = ctx->total_frame_num;
 
 	mtk_jpegdec_set_hw_param(ctx, hw_id, src_buf, dst_buf);
-	ret = pm_runtime_get_sync(comp_jpeg[hw_id]->dev);
+	ret = pm_runtime_resume_and_get(comp_jpeg[hw_id]->dev);
 	if (ret < 0) {
 		dev_err(jpeg->dev, "%s : %d, pm_runtime_get_sync fail !!!\n",
 			__func__, __LINE__);
-- 
2.53.0




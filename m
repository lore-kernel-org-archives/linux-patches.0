Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053167;
	b=5e22myGSgqzmpezm2uUwE92TBsot75tFwb6+sM+Kqi7zY2Zll+rAimnWI4jJrtbgBnYg
	 l6GlVj4Co7y7nJ2+UvuEp1b7nbLRVFN9klzTH3oGAEVKeTugKBYelHHtGLqBBiw9CFEcj
	 Gpy/ek7i5SPkXIyUAkzc6CK/Hx0A37CYK80ItExi5LTScJLxy//Bj3OQoRjzbf4DjBX1X
	 wz4/u6K474doz50F9P7I5TsHGS7uxTBXxf5Infs6ZKTvjCZj4+ho9KE1KmXrvCCvWoy1h
	 mBURzeScfirLsFCDpt94HNArrssGDqLTk+jaeX3i3R04XaJ84mG0io0vZOW0/c4E/IQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053167;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ulMQChogFk2j+SLM3l7M4aMfovTgB15M7iED+A9FK1c=;
	b=R4fdwLyhdoERKck7qWjNO8AqwPJcxrKXOHQsUJWhbgOls+l+IK/7bPLBTG+AWCKshAK2
	 SmX4P/5K+Nok7AaLWiBuxWEc3DR6qi+aYRIDcBFcfFm0Mt/BKNUzVkZUP3QE6U6rjwQWK
	 oit0sEjp7jWIWhj6PyLGnIAcAzNHVV1Ku3g0Zu60zHcl3L+3OEVpE3aQMgkQ2epWqf7J1
	 pDSxjAyD4BI+jHUdOei7bRZKFO+EqLGjIVGcB02/kAX3wRJ7aZatDKWYhfgXDtEKvWbQt
	 tlMbNOE3bYR3mFM7IE6B9W6MbP+GUdEBKz5QPh2fL3YG7uqsJOHB/apIFUBP1lhzMlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pjmmizTa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB6BC606A320;
	Thu, 19 Nov 2026 01:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pjmmizTa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DD571F000C4;
	Thu, 19 Nov 2026 01:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053167;
	bh=ulMQChogFk2j+SLM3l7M4aMfovTgB15M7iED+A9FK1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pjmmizTapoqn7U2K4XQesAldI/M5TqH2697TiKzDYqjm2AEM5P5peQg9etFKlOCGi
	 mzjX6rxd6Ykx/YGZ2U5GsHR6qIhS7P120UWvk9EtnrzMOzIBuI9GJpqKj4/bcOIEAK
	 MRL9Ba9H8Kxt2TATQ2R/IyKLLikEMDD83M19zCHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kazuki Hanai <hnkz.64@gmail.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0822/2214] media: mediatek: jpeg: Avoid context access after job finish
Date: Wed, 18 Nov 2026 15:41:38 +0100
Message-ID: <20261118150044.570485630@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c b/drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c
index ba490b06ff703..5840c0eb0dc0d 100644
--- a/drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c
+++ b/drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c
@@ -1096,7 +1096,7 @@ static irqreturn_t mtk_jpeg_enc_done(struct mtk_jpeg_dev *jpeg)
 	v4l2_m2m_buf_done(src_buf, buf_state);
 	v4l2_m2m_buf_done(dst_buf, buf_state);
 	v4l2_m2m_job_finish(jpeg->m2m_dev, ctx->fh.m2m_ctx);
-	pm_runtime_put(ctx->jpeg->dev);
+	pm_runtime_put(jpeg->dev);
 	return IRQ_HANDLED;
 }
 
@@ -1163,7 +1163,7 @@ static irqreturn_t mtk_jpeg_dec_irq(int irq, void *priv)
 	v4l2_m2m_buf_done(src_buf, buf_state);
 	v4l2_m2m_buf_done(dst_buf, buf_state);
 	v4l2_m2m_job_finish(jpeg->m2m_dev, ctx->fh.m2m_ctx);
-	pm_runtime_put(ctx->jpeg->dev);
+	pm_runtime_put(jpeg->dev);
 	return IRQ_HANDLED;
 }
 
-- 
2.53.0




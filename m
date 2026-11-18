Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059065;
	b=cv1ulY9sy92pBPjDJ4TJC/VhP2ndsluhmwlv6dgT1RiQh0t4Bmlet89lG1At/9M4R63w
	 IrzUIVRfon8oqvPzAwl0MxLusi+BNG7bEB0sDmF1eM/JGCFxYlkeaLFO+eOsKMs0kJLuN
	 Nm2NBDriT4bKiU6Vrzg1afmBvA2ml+aWxm+IYLUxesvyKQlxdB6DarQx8C8dbXNMrhrRX
	 brkyNw4crlgDWLmnBSsx+JtJIHt/mJJuQgREokZOmwfNT8GPS5UEdIuwo6jHHTe6JUOP6
	 vQgYuULlqGXa2w5VJ+ZCA3IMHk8sxAL0t5/3/c84ATC3G8iYJ07fsOiVATPaO9UZiqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059065;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=w2wcI4Zsa6BLmlI7YChjvs7JdG3gsV11ZDDMaHsO6LQ=;
	b=jJv+YN5us2NkEzhslhgImYls9sURUVrjT5ishBHCgl91krPlWMvZvFn4p46vL7X9QQbE
	 YWaCaNjNE4J6AUaACFIOA60IcI0OzxibiFQYpnfskkeWJGoR292rG7RhQGfFxQMOu729i
	 8u+JoMBf+WYL8XDeXb5d4vh0UNlLbmAUJGYPIN+KXNHz462t0p8YdyHsCS8D3a0+66NfY
	 KXas9ow0dHCuJoWbfhGzKrGAO4ZN1xaWYHjapFyPX7f7cQdxq4vXEWqDLhwuDieWPXjc1
	 6XJe+gyF52PIXiwBpLAXzeTbuKV93WdkaOucvDf94VOMz8VuJ6ukAk8xxkIL6b9JmuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kmtQnXKS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA34F606A31C;
	Thu, 19 Nov 2026 03:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kmtQnXKS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B5711F000C4;
	Thu, 19 Nov 2026 03:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059065;
	bh=w2wcI4Zsa6BLmlI7YChjvs7JdG3gsV11ZDDMaHsO6LQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kmtQnXKSTS1NisuGfib9L2OfLE9j04nzz5GFogsf8xHTl8NUoGUiF5POQ0AcqcHQm
	 hQBp1e9TEFX3lL6D0FWffqJ1I0EaCHgOoSX2dqabD3ylxQwJBRw6CcN2zcGXLNHo8X
	 uFCPXWrVrLxHiMMePRfm5ePH4g5KtTwqlFSs/8IQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kazuki Hanai <hnkz.64@gmail.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0667/1848] media: mediatek: jpeg: Avoid context access after job finish
Date: Wed, 18 Nov 2026 15:45:05 +0100
Message-ID: <20261118145943.809962076@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 3519c2252ae88..22de897ea30d6 100644
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




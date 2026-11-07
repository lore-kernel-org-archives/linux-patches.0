Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063916;
	b=ANrPsPXpb+lsIzm7Jfti0FQ8LKpbi4P6S1TNpZa2d7LjZwCVOJHFjBC29GAvAzWLT6CX
	 JO717hqUHZ6+5XEBM1fov1C7LXJi5tH/o8BKc3kW5N0lyc6RdzYZ/9N6E+yPQZ4ZKaAUB
	 Dgw83hNg2cBixSmd0X1XZu5FerxhgmomaHk69RK7j5AjQVxoGrZVyjdabStVozaqaODO1
	 P5aCO/djhgK4oGyAmin7neuWMWJsLtaYXwvr2FOsMEmHQGj7wa+hBHEtOcG6Kmd+F4mc7
	 +JYAZ/PU+eNC6ByXuO+xo72IkVLREKJt44OqXDhy5HJGcxGW7b0Y/7Gec2ybubgnF2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063916;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qJkEtoaKV1P3hZOh09ql5SjFnq8Wsg4YhEOGrMu2310=;
	b=u12XQR9iDl0tSgznSvUZaaBr8toge0vxilUttxBQxDzsgA3gSD+yduemYA5G/CQhXjsy
	 mmRI4WBTSeJ4QctjWwpVFGvgQjcZVidt1Vb/CU8B0R+LbIKubPoinxYL+1udBlS5FtP7M
	 QiYAjYM4IkFIKGq5mIBUyyO3wHlG1euCZorUA3lhsLSgJo5IQiR4CRGGJEWi/B0BhJkA8
	 NB/C3YxzVzMYvu7lPQksWsIU69dQJPXwMBylCJgl2WdVL5WDvzEeYkvrM9yUbJzy5ROXC
	 w3FmwglV5wRUb3ZxamxPCRlBph3QBm28wIn6PfR1gMH1gBo53MpIuUfEwg2DvVE3dBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KwqZNFPf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B5E2606E8E9;
	Sat,  7 Nov 2026 15:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KwqZNFPf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADCB01F0089F;
	Sat,  7 Nov 2026 15:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063915;
	bh=qJkEtoaKV1P3hZOh09ql5SjFnq8Wsg4YhEOGrMu2310=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KwqZNFPfxfLs2vEfy8LbmVwWzB9jYsP+BAGDcUwkyLYiOWsZCMx7YaGfwAiK8Bduu
	 CnglP0FhTScZRGtBsoR8Bw1oWNCH4DI30/vNqBFeJovEd2K7Vk5U1I7sSvWtVZIKol
	 QOjTNPWNKtit/7NpL77QnPCuFEsgpbLoidmV6s7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao-Qun Huang <alvinhuang0603@gmail.com>,
	Ben Hoff <hoff.benjamin.k@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0086/1257] media: hws: Wait for IRQ handler before returning buffers
Date: Sat,  7 Nov 2026 08:39:42 -0500
Message-ID: <20261107134941.742025895@linuxfoundation.org>
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

From: Hao-Qun Huang <alvinhuang0603@gmail.com>

[ Upstream commit 1ba17b5a54187e8bb251ff9636ed65c84719b013 ]

hws_stop_streaming() disables capture and then collects the active and
queued buffers straight away. Clearing cap_active and setting
stop_requested only stops a VDONE handler that has not checked them
yet; one already running on another CPU has passed those checks and
cannot be recalled.

That handler snapshots v->active into a local pointer and drops
irq_lock before it touches the buffer, so stop_streaming can run in
between. Without a next_prepared buffer both paths complete the same
buffer, and the second vb2_buffer_done() hits the WARN_ON for a buffer
that is no longer active. With a next_prepared buffer the snapshot is
the only remaining reference to the old active buffer, so
stop_streaming returns without it and vb2 reports "stop_streaming
operation is leaving buffer %u in active state" before completing it
with an error.

Either way the driver breaks the vb2 rule that stop_streaming has to
give back every buffer it owns before it returns.

Wait for the handler once the hardware is disabled and before the
buffers are collected. The live mode change and the channel cleanup
paths already do this around the same collect helper.

Fixes: ba07fd2f5742 ("media: pci: add AVMatrix HWS capture driver")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5
Signed-off-by: Hao-Qun Huang <alvinhuang0603@gmail.com>
Reviewed-by: Ben Hoff <hoff.benjamin.k@gmail.com>
Tested-by: Ben Hoff <hoff.benjamin.k@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/hws/hws_video.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/pci/hws/hws_video.c b/drivers/media/pci/hws/hws_video.c
index 09cfb5a909f9c..dbe0fc2a66b57 100644
--- a/drivers/media/pci/hws/hws_video.c
+++ b/drivers/media/pci/hws/hws_video.c
@@ -1294,6 +1294,8 @@ static void hws_stop_streaming(struct vb2_queue *q)
 	WRITE_ONCE(v->stop_requested, true);
 
 	hws_enable_video_capture(v->parent, v->channel_index, false);
+	if (hws->irq >= 0)
+		synchronize_irq(hws->irq);
 
 	/* 2) Collect in-flight + queued under the IRQ lock */
 	spin_lock_irqsave(&v->irq_lock, flags);
-- 
2.53.0




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591421;
	b=YmXcNmlsK38F5+gC1SdleaRZY6fMHsPTYHXcKVQ4urRXMORXHyPcd17nEkba/VKUsPpl
	 QwNxQ81yYcmUvcNVk/nwqV4soIhjy7/ChXc80/QJQm6UQI/ZwJXHlQyWVMu0kBOAoYnRu
	 JVkaguK4G9sLjju6dIkgC0i1aASU9v3bpA8iP+92ozaE/KMb3T7zsY60B5yYKEEKuQA6D
	 08DNcTH38IVG1LwfPQ1wUS5tfmTr7Tm9IJO942RWwSwP4C5k9RLCaQFS+6SwWYRLn9BYO
	 ZRbdGJ46dXG57algbC8ya6BL6sRucihP8tNinSf6Qh6E4pJrtwBdxEyZ0z2DMVSxE7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591421;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yCRIiNZXtoR9bwpyp1tgSgOWqZ0Su5RDsQfZg6lpTMM=;
	b=3N9zEy0rW+IwxG6C1t8CibdfdwD4c3i3RpVT1CzsWoQXpcIWqNp70D6swglYIVFeo+/T
	 7RNuXzR6+fa209qp3DZdvVp0VVLc1nQFsnj1ZYNEeH68qyDibwU8jEOfwD0/cQSPxPFWa
	 qxSDHLZgeMaUFzlbfl0uu1XbY7Fu9CBJAXHC9BOQWWwikjS7mj1Vqa+zvrqA+LTTVTDiE
	 TPWeV3N6g9JeZXFri2F1eYBTxgd0WxkRf1321gFgtOgcK/cq/tbqDzdVj/5M6gf03qSWK
	 UQe9SP8CHvM7RJZbSS2GwEqM37h8ewjTVAd1hHK78UPUwX7mApuq60HXU1AgRBXiS8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rUtGzmWK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BB17607B596;
	Fri, 13 Nov 2026 17:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rUtGzmWK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07B361F000C4;
	Fri, 13 Nov 2026 17:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591421;
	bh=yCRIiNZXtoR9bwpyp1tgSgOWqZ0Su5RDsQfZg6lpTMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rUtGzmWK1AQju1F76fX7VeOdvAIZOPjJ6gqXeKuiNJCGd7ZfmbbZu/E7ASuSYJGTW
	 Ihn7C/0dxowQrATRlPlCQ2Qkl8mziEaKZvg7DRGwzD0Htf1yqnhf6N8wvLiGBYxxwl
	 29Igza4YoPx2epxF2RSfaLZZQdNNV3sv6CKbb5i4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 513/670] media: chips-media: wave5: Handle polling IRQ thread failure
Date: Fri, 13 Nov 2026 10:51:17 -0500
Message-ID: <20261113153829.327530230@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

From: Linmao Li <lilinmao@kylinos.cn>

[ Upstream commit 1d563e3d718a1c7c16355843374fbdd4c798ac66 ]

When falling back to polling mode, wave5_vpu_probe() does not check the
return value of kthread_run().  On failure, dev->irq_thread holds an
error pointer instead of a valid task pointer.

Both the probe error path and the remove path only check
dev->irq_thread against NULL before calling kthread_stop() on it, so an
error pointer passes the check and kthread_stop() crashes on it.

Check the kthread_run() result, clear dev->irq_thread and unwind the
probe on failure.

Fixes: e66ff2b08e4e ("media: chips-media: wave5: Fix Null reference while testing fluster")
Cc: stable@vger.kernel.org
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
[ sashal: Adjusted context to preserve hrtimer_init() with separate callback assignment and kthread_create_worker(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/chips-media/wave5/wave5-vpu.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/media/platform/chips-media/wave5/wave5-vpu.c b/drivers/media/platform/chips-media/wave5/wave5-vpu.c
index 5ec14a7c70c7c..d38be4761d4e9 100644
--- a/drivers/media/platform/chips-media/wave5/wave5-vpu.c
+++ b/drivers/media/platform/chips-media/wave5/wave5-vpu.c
@@ -300,6 +300,13 @@ static int wave5_vpu_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "failed to get irq resource, falling back to polling\n");
 		sema_init(&dev->irq_sem, 1);
 		dev->irq_thread = kthread_run(irq_thread, dev, "irq thread");
+		if (IS_ERR(dev->irq_thread)) {
+			ret = PTR_ERR(dev->irq_thread);
+			dev_err(&pdev->dev, "failed to create irq thread\n");
+			dev->irq_thread = NULL;
+			goto err_vdi_release;
+		}
+
 		hrtimer_init(&dev->hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL_PINNED);
 		dev->hrtimer.function = &wave5_vpu_timer_callback;
 		dev->worker = kthread_create_worker(0, "vpu_irq_thread");
-- 
2.53.0




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015284;
	b=llkvvnmshHJVtH5Astw/e25Vt7oIixpBQZMpILHbS87Ob78bm8KaXuNte+q8WOyUyIKg
	 9mE5QMQxegkgOAD17I6K2+7Ggw5BZxtSoKtPMcwlOdaF3H7y6bwvc+DWEcr6TlLvvnc7X
	 b15ZvWSogupotOpZD+rUbaV2Xo+nio4aHZw7MKAZuN7E/dsaPcye4ilm7aJXyPx1imRF5
	 wnRax+71RTR/r+obgk6vrhJghZHnjdjxey+b5UJgEIVQriIsvoGf+8iD1ZrFfuIDQ0jz6
	 lbGO/lyuH1+kvPu229c9gSrwwIKtPfYDtlNNciAsdQv1Qh1n93guIUgRMAhfFFhgGVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015284;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wT7/Eu4LoSoDJ6y1ctukcYZEZcF/IZWim7J67IPKaTU=;
	b=FgbI3CkzRTr9C9uzRcwdFOAZKd6sNus9rOQmcY74iZggJeaDwSQthcoj3p7KxhzDVwja
	 H9hluu1hGB/pYE8j7bxRtdrN6kU+ypCensihiKOUulfNwRWk85+cFnfD6UCs2pU8rlj1J
	 dnjyqGs0LZ7OfmfGNR9vWqwkMYyrmeduE066KOLCkVsrbjF0P/xYaozd+o9zMLBxcVNkc
	 gJWpfOHPBzitl47JzKgOnajtnX5Dug1U0p82rrgWXOU+UGBxK2PQZvPxGvUooRYidHP0k
	 5rcTiW+vwdpnTfBno6nw1lGHqpZeumVPD6Qwx8HPO5nGCqC4OvIK+ILn6VObytl0Mdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OSgEqpDm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05580606A325;
	Wed, 18 Nov 2026 15:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OSgEqpDm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C37F1F000C5;
	Wed, 18 Nov 2026 15:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015283;
	bh=wT7/Eu4LoSoDJ6y1ctukcYZEZcF/IZWim7J67IPKaTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OSgEqpDm9EqXM7jp7MtXrqvmYS0juk/ZyLXgvPSAO9czixN+RIcUu5Rs/PalrFL9E
	 q25GbAzm4cgN9qsDg3pO9CXvAeHs7h3vEmKgZ69hAkA9Er/2MJJr3aISqQAzPql3HF
	 hh51Uz91p+qecEccnU7z5FLT3WXBjnb4ERbYBfwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Nicolas Frattaroli <nicolas.frattaroli@collabora.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0076/2651] drm/panthor: Revisit reqs_lock handling in flush/reset paths
Date: Wed, 18 Nov 2026 15:21:56 +0100
Message-ID: <20261118150250.664468014@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

[ Upstream commit 4fd08b3d1da78e33cb5939f0086e61f9d660cd6c ]

panthor_gpu_flush_caches() and panthor_gpu_soft_reset() acquire their
reqs_lock spinlock with the IRQ-disabling variants of the spinlocking
functions. This isn't necessary, as the lock is never taken from an
atomic context, as Panthor uses threaded interrupt handlers. The result
of this overly strict locking is that IRQs may be disabled more
frequently and for longer than they should be, resulting in increased
system latency.

Switch the locking to use non-IRQ-disabling scoped_guard statements for
locking. The wait_event_timeout read of pending_reqs outside of the
spinlock is fine as wait_event_timeout is a memory barrier according to
the Linux Memory Model.

Fixes: 5cd894e258c4 ("drm/panthor: Add the GPU logical block")
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Signed-off-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://patch.msgid.link/20260812-panthor-cache-flush-fix-v4-2-751e32901898@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_gpu.c | 72 ++++++++++++---------------
 1 file changed, 33 insertions(+), 39 deletions(-)

diff --git a/drivers/gpu/drm/panthor/panthor_gpu.c b/drivers/gpu/drm/panthor/panthor_gpu.c
index 7088371c6d648..110ca6cd3d098 100644
--- a/drivers/gpu/drm/panthor/panthor_gpu.c
+++ b/drivers/gpu/drm/panthor/panthor_gpu.c
@@ -345,41 +345,36 @@ int panthor_gpu_flush_caches(struct panthor_device *ptdev,
 			     u32 l2, u32 lsc, u32 other)
 {
 	struct panthor_gpu *gpu = ptdev->gpu;
-	unsigned long flags;
 	u64 start = 0;
 	int ret = 0;
 
 	/* Serialize cache flush operations. */
 	guard(mutex)(&ptdev->gpu->cache_flush_lock);
 
-	spin_lock_irqsave(&ptdev->gpu->reqs_lock, flags);
-
-	if (tracepoint_enabled(gpu_cache_flush))
-		start = ktime_get_ns();
-
-	if (!(ptdev->gpu->pending_reqs & GPU_IRQ_CLEAN_CACHES_COMPLETED)) {
-		ptdev->gpu->pending_reqs |= GPU_IRQ_CLEAN_CACHES_COMPLETED;
-		gpu_write(gpu->iomem, GPU_CMD, GPU_FLUSH_CACHES(l2, lsc, other));
-	} else {
-		ret = -EIO;
-	}
-	spin_unlock_irqrestore(&ptdev->gpu->reqs_lock, flags);
-
-	if (ret) {
-		panthor_gpu_emit_flush_caches_tp(ptdev, start, l2, lsc, other, ret);
-		return ret;
+	scoped_guard(spinlock, &ptdev->gpu->reqs_lock) {
+		if (tracepoint_enabled(gpu_cache_flush))
+			start = ktime_get_ns();
+
+		if (!(ptdev->gpu->pending_reqs & GPU_IRQ_CLEAN_CACHES_COMPLETED)) {
+			ptdev->gpu->pending_reqs |= GPU_IRQ_CLEAN_CACHES_COMPLETED;
+			gpu_write(gpu->iomem, GPU_CMD, GPU_FLUSH_CACHES(l2, lsc, other));
+		} else {
+			panthor_gpu_emit_flush_caches_tp(ptdev, start, l2, lsc,
+							 other, -EIO);
+			return -EIO;
+		}
 	}
 
 	if (!wait_event_timeout(ptdev->gpu->reqs_acked,
 				!(ptdev->gpu->pending_reqs & GPU_IRQ_CLEAN_CACHES_COMPLETED),
 				msecs_to_jiffies(100))) {
-		spin_lock_irqsave(&ptdev->gpu->reqs_lock, flags);
-		if ((ptdev->gpu->pending_reqs & GPU_IRQ_CLEAN_CACHES_COMPLETED) != 0 &&
-		    !(gpu_read(gpu->irq.iomem, INT_RAWSTAT) & GPU_IRQ_CLEAN_CACHES_COMPLETED))
-			ret = -ETIMEDOUT;
-		else
-			ptdev->gpu->pending_reqs &= ~GPU_IRQ_CLEAN_CACHES_COMPLETED;
-		spin_unlock_irqrestore(&ptdev->gpu->reqs_lock, flags);
+		scoped_guard(spinlock, &ptdev->gpu->reqs_lock) {
+			if ((ptdev->gpu->pending_reqs & GPU_IRQ_CLEAN_CACHES_COMPLETED) != 0 &&
+			    !(gpu_read(gpu->irq.iomem, INT_RAWSTAT) & GPU_IRQ_CLEAN_CACHES_COMPLETED))
+				ret = -ETIMEDOUT;
+			else
+				ptdev->gpu->pending_reqs &= ~GPU_IRQ_CLEAN_CACHES_COMPLETED;
+		}
 	}
 
 	panthor_gpu_emit_flush_caches_tp(ptdev, start, l2, lsc, other, ret);
@@ -402,27 +397,26 @@ int panthor_gpu_soft_reset(struct panthor_device *ptdev)
 {
 	struct panthor_gpu *gpu = ptdev->gpu;
 	bool timedout = false;
-	unsigned long flags;
 
-	spin_lock_irqsave(&ptdev->gpu->reqs_lock, flags);
-	if (!drm_WARN_ON(&ptdev->base,
-			 ptdev->gpu->pending_reqs & GPU_IRQ_RESET_COMPLETED)) {
-		ptdev->gpu->pending_reqs |= GPU_IRQ_RESET_COMPLETED;
-		gpu_write(gpu->irq.iomem, INT_CLEAR, GPU_IRQ_RESET_COMPLETED);
-		gpu_write(gpu->iomem, GPU_CMD, GPU_SOFT_RESET);
+	scoped_guard(spinlock, &ptdev->gpu->reqs_lock) {
+		if (!drm_WARN_ON(&ptdev->base,
+				ptdev->gpu->pending_reqs & GPU_IRQ_RESET_COMPLETED)) {
+			ptdev->gpu->pending_reqs |= GPU_IRQ_RESET_COMPLETED;
+			gpu_write(gpu->irq.iomem, INT_CLEAR, GPU_IRQ_RESET_COMPLETED);
+			gpu_write(gpu->iomem, GPU_CMD, GPU_SOFT_RESET);
+		}
 	}
-	spin_unlock_irqrestore(&ptdev->gpu->reqs_lock, flags);
 
 	if (!wait_event_timeout(ptdev->gpu->reqs_acked,
 				!(ptdev->gpu->pending_reqs & GPU_IRQ_RESET_COMPLETED),
 				msecs_to_jiffies(100))) {
-		spin_lock_irqsave(&ptdev->gpu->reqs_lock, flags);
-		if ((ptdev->gpu->pending_reqs & GPU_IRQ_RESET_COMPLETED) != 0 &&
-		    !(gpu_read(gpu->irq.iomem, INT_RAWSTAT) & GPU_IRQ_RESET_COMPLETED))
-			timedout = true;
-		else
-			ptdev->gpu->pending_reqs &= ~GPU_IRQ_RESET_COMPLETED;
-		spin_unlock_irqrestore(&ptdev->gpu->reqs_lock, flags);
+		scoped_guard(spinlock, &ptdev->gpu->reqs_lock) {
+			if ((ptdev->gpu->pending_reqs & GPU_IRQ_RESET_COMPLETED) != 0 &&
+			    !(gpu_read(gpu->irq.iomem, INT_RAWSTAT) & GPU_IRQ_RESET_COMPLETED))
+				timedout = true;
+			else
+				ptdev->gpu->pending_reqs &= ~GPU_IRQ_RESET_COMPLETED;
+		}
 	}
 
 	if (timedout) {
-- 
2.53.0




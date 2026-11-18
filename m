Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015280;
	b=M2hZOejl9Jukvb8I9VwbGgb7DvGd+3fQPSRIalUp1/cXUFXDNdsUoxcxw3tX5I6GN0za
	 yETiUdoT4IqGmf7cm1zJrdoOFjw+TEpsmmagc7LBUkH8WS6OuW+hyM5DMM7oXmqZq9T2j
	 ZSYVpjPLriMLwfw6gGam/MKWmj28BdHnZyxN7DVXMFQrNZHNFw1fMr/73WIyBROzKR9dK
	 G3L+vi0d/Tg9/3HT612GyrC2FYojUJfYxf33cBhMyQ3P9NX0kKdP/tGQIy4vp8k5itpFw
	 Ik/YsxFp7XF/UpseN9YIyl64RLl9OUOjhG4Z2G5pZz6ZH1nVcNB7rfi6AOTvxHKCTYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015280;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8IRDkhzT9vF8u8PUXb0zVnoAKuHksU7+qBWddMCzATQ=;
	b=T2hbB1b3t4W61yCXtoPZEjvPddRabUdi193OAZ0zTR3CgBHdLUgyROzAqOP40Ati12Fb
	 h/xMRMqlSY3QfSD1nDnD2ujkBDvDyCOLKjl7k+Qpyt6O/jfSd9V0ucHeixDp11onGG9IZ
	 FWxgalmdc4h6008KLe4vQN6Vv+0Rf5TqUy45KEW84+Wk3Q6e6FRgA6KIpxjtUAjUQ0ELm
	 otd+XLEQNIRWIo6v9dabL5R0DNVXEjYlqK7POSbZrxVxynn1JfFy1VamG5DKnolzGPr1Y
	 kLbBXUOKCCViiU1jmVxQlesDZUPjVvARHmUfsahhx4sNCu3sTbliM1arFyPFDr17f+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oRFIksRM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89862606A325;
	Wed, 18 Nov 2026 15:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oRFIksRM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A296B1F000C5;
	Wed, 18 Nov 2026 15:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015280;
	bh=8IRDkhzT9vF8u8PUXb0zVnoAKuHksU7+qBWddMCzATQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oRFIksRMnh1ard/2YKOqil09F13xsJLiRJl7IRn5IuX4j4XNikY9AXrUPFslJ1DJ3
	 0C2ScVi2KfME8ywAPbb7Jdhq97+93JMNFqlVLzXwPACcLdyP7wHSmEX88peVRpHsau
	 s+VYxL0hbu2zIjm+aRSBIKxe4XQf2L9j/2XVL5TA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Frattaroli <nicolas.frattaroli@collabora.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Steven Price <steven.price@arm.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0075/2651] drm/panthor: Add tracepoint for cache flushing
Date: Wed, 18 Nov 2026 15:21:55 +0100
Message-ID: <20261118150250.628901999@linuxfoundation.org>
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

[ Upstream commit 3fc4721629c40bb5f7bc7696875a9df633e6a35a ]

Add a new event tracepoint: gpu_cache_flush to be emitted after a GPU
cache flush completes, with duration and return status arguments.

This allows debugging the duration a flush takes irrespective of initial
function entry lock contention, and communicates information about
whether the flush timed out or errored out in other ways, and which
caches were flushed.

Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Signed-off-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://patch.msgid.link/20260812-panthor-cache-flush-fix-v4-1-751e32901898@collabora.com
Stable-dep-of: 4fd08b3d1da7 ("drm/panthor: Revisit reqs_lock handling in flush/reset paths")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_gpu.c   | 26 ++++++++++++++++-
 drivers/gpu/drm/panthor/panthor_trace.h | 38 +++++++++++++++++++++++++
 2 files changed, 63 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panthor/panthor_gpu.c b/drivers/gpu/drm/panthor/panthor_gpu.c
index c013d6bf9a599..7088371c6d648 100644
--- a/drivers/gpu/drm/panthor/panthor_gpu.c
+++ b/drivers/gpu/drm/panthor/panthor_gpu.c
@@ -317,6 +317,21 @@ int panthor_gpu_l2_power_on(struct panthor_device *ptdev)
 	return panthor_gpu_power_on(ptdev, L2, 1, 20000);
 }
 
+static inline void panthor_gpu_emit_flush_caches_tp(struct panthor_device *ptdev,
+						    u64 start, u32 l2, u32 lsc,
+						    u32 other, int ret)
+{
+	u32 duration;
+
+	if (!tracepoint_enabled(gpu_cache_flush) || !start)
+		return;
+
+	if (check_sub_overflow(ktime_get_ns(), start, &duration))
+		duration = U32_MAX;
+
+	trace_gpu_cache_flush(ptdev->base.dev, l2, lsc, other, duration, ret);
+}
+
 /**
  * panthor_gpu_flush_caches() - Flush caches
  * @ptdev: Device.
@@ -331,12 +346,17 @@ int panthor_gpu_flush_caches(struct panthor_device *ptdev,
 {
 	struct panthor_gpu *gpu = ptdev->gpu;
 	unsigned long flags;
+	u64 start = 0;
 	int ret = 0;
 
 	/* Serialize cache flush operations. */
 	guard(mutex)(&ptdev->gpu->cache_flush_lock);
 
 	spin_lock_irqsave(&ptdev->gpu->reqs_lock, flags);
+
+	if (tracepoint_enabled(gpu_cache_flush))
+		start = ktime_get_ns();
+
 	if (!(ptdev->gpu->pending_reqs & GPU_IRQ_CLEAN_CACHES_COMPLETED)) {
 		ptdev->gpu->pending_reqs |= GPU_IRQ_CLEAN_CACHES_COMPLETED;
 		gpu_write(gpu->iomem, GPU_CMD, GPU_FLUSH_CACHES(l2, lsc, other));
@@ -345,8 +365,10 @@ int panthor_gpu_flush_caches(struct panthor_device *ptdev,
 	}
 	spin_unlock_irqrestore(&ptdev->gpu->reqs_lock, flags);
 
-	if (ret)
+	if (ret) {
+		panthor_gpu_emit_flush_caches_tp(ptdev, start, l2, lsc, other, ret);
 		return ret;
+	}
 
 	if (!wait_event_timeout(ptdev->gpu->reqs_acked,
 				!(ptdev->gpu->pending_reqs & GPU_IRQ_CLEAN_CACHES_COMPLETED),
@@ -360,6 +382,8 @@ int panthor_gpu_flush_caches(struct panthor_device *ptdev,
 		spin_unlock_irqrestore(&ptdev->gpu->reqs_lock, flags);
 	}
 
+	panthor_gpu_emit_flush_caches_tp(ptdev, start, l2, lsc, other, ret);
+
 	if (ret) {
 		panthor_device_schedule_reset(ptdev);
 		drm_err(&ptdev->base, "Flush caches timeout");
diff --git a/drivers/gpu/drm/panthor/panthor_trace.h b/drivers/gpu/drm/panthor/panthor_trace.h
index 6ffeb4fe65992..bd8652549ab46 100644
--- a/drivers/gpu/drm/panthor/panthor_trace.h
+++ b/drivers/gpu/drm/panthor/panthor_trace.h
@@ -76,6 +76,44 @@ TRACE_EVENT(gpu_job_irq,
 		  __entry->events, __entry->duration_ns)
 );
 
+/**
+ * gpu_cache_flush - emitted after cache flush completes
+ * @dev: pointer to the &struct device, for printing the device name
+ * @l2: "l2" flush flags
+ * @lsc: "lsc" flush flags
+ * @other: "other" flush flags
+ * @duration_ns: how long the cache flush operation took, in nanoseconds
+ * @ret: return status, 0 == success, negative errno on error
+ *
+ * Begins measuring after any initial lock contention around the locks needed
+ * for flushing caches, but before the actual cache flush is requested. Stops
+ * measuring and is emitted after flush operation is over.
+ */
+TRACE_EVENT(gpu_cache_flush,
+	    TP_PROTO(const struct device *dev, u32 l2, u32 lsc, u32 other,
+		     u32 duration_ns, int ret),
+	    TP_ARGS(dev, l2, lsc, other, duration_ns, ret),
+	    TP_STRUCT__entry(
+		    __string(dev_name, dev_name(dev))
+		    __field(u32, l2)
+		    __field(u32, lsc)
+		    __field(u32, other)
+		    __field(u32, duration_ns)
+		    __field(int, ret)
+	    ),
+	    TP_fast_assign(
+		    __assign_str(dev_name);
+		    __entry->l2          = l2;
+		    __entry->lsc         = lsc;
+		    __entry->other       = other;
+		    __entry->duration_ns = duration_ns;
+		    __entry->ret         = ret;
+	    ),
+	    TP_printk("%s: l2=0x%x lsc=0x%x other=0x%x duration_ns=%u ret=%d",
+		      __get_str(dev_name), __entry->l2, __entry->lsc,
+		      __entry->other, __entry->duration_ns, __entry->ret)
+);
+
 #endif /* __PANTHOR_TRACE_H__ */
 
 #undef TRACE_INCLUDE_PATH
-- 
2.53.0




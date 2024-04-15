Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 743C71E4B1;
	Mon, 15 Apr 2024 14:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191610; cv=none; b=TFofEHT9bczC2dfgrzM5sDnWvN+qh15OjKFkLAyOul+nGfq09zw0WOx2xBLAR1+RjMqymXz4zdJ7M122/13yK+70/Fv/NEsTMymECZnJPfACk8Gp1bs9Wf1KOQV2wd0Wm1aiQpt30UtSlsm2ckZYE66301RVPkjoeND0XE2T2kY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191610; c=relaxed/simple;
	bh=HyJWV/t4PWni2qmBUQw7InKm+zABGxpkwdYE0zqq/Tg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zl5PwRiiMPn3qGH6gbmSdedW3RPCD4gRkHhgpLy36jKy8O6LzQoEZeC2kKt1H0Xs7rdiuvnVsJI/9FjOkbrpGnE9V9WSsEedL0J0tKPWp6kcFKZq2OSfdsqRd/inqbriwhu77Yvj1xy8na7XZ8JxDAhclPlnbl9q2Zww+v4/j3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vyrB9qSl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vyrB9qSl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA1CEC113CC;
	Mon, 15 Apr 2024 14:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191610;
	bh=HyJWV/t4PWni2qmBUQw7InKm+zABGxpkwdYE0zqq/Tg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vyrB9qSlQqjhUCIeE8gekPkK79vkVKcJod9NlFHzl0kss00eQxZ0IiP1PKqU8p/wu
	 djzTXVZKMJdhtjz+lHJUmqIWxsKDFH0lWyn0DfQNAN3j2hTAU3fdxSiF8qIis1nT2b
	 Wr9ZjbtH4jyw2yh+nbfrpZxQh6wci9Ov48Lv77hI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Timo Lindfors <timo.lindfors@iki.fi>,
	Alex Constantino <dreaming.about.electric.sheep@gmail.com>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 027/122] Revert "drm/qxl: simplify qxl_fence_wait"
Date: Mon, 15 Apr 2024 16:19:52 +0200
Message-ID: <20240415141954.187201496@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141953.365222063@linuxfoundation.org>
References: <20240415141953.365222063@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Constantino <dreaming.about.electric.sheep@gmail.com>

[ Upstream commit 07ed11afb68d94eadd4ffc082b97c2331307c5ea ]

This reverts commit 5a838e5d5825c85556011478abde708251cc0776.

Changes from commit 5a838e5d5825 ("drm/qxl: simplify qxl_fence_wait") would
result in a '[TTM] Buffer eviction failed' exception whenever it reached a
timeout.
Due to a dependency to DMA_FENCE_WARN this also restores some code deleted
by commit d72277b6c37d ("dma-buf: nuke DMA_FENCE_TRACE macros v2").

Fixes: 5a838e5d5825 ("drm/qxl: simplify qxl_fence_wait")
Link: https://lore.kernel.org/regressions/ZTgydqRlK6WX_b29@eldamar.lan/
Reported-by: Timo Lindfors <timo.lindfors@iki.fi>
Closes: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1054514
Signed-off-by: Alex Constantino <dreaming.about.electric.sheep@gmail.com>
Signed-off-by: Maxime Ripard <mripard@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240404181448.1643-2-dreaming.about.electric.sheep@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/qxl/qxl_release.c | 50 +++++++++++++++++++++++++++----
 include/linux/dma-fence.h         |  7 +++++
 2 files changed, 52 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/qxl/qxl_release.c b/drivers/gpu/drm/qxl/qxl_release.c
index 368d26da0d6a2..9febc8b73f09e 100644
--- a/drivers/gpu/drm/qxl/qxl_release.c
+++ b/drivers/gpu/drm/qxl/qxl_release.c
@@ -58,16 +58,56 @@ static long qxl_fence_wait(struct dma_fence *fence, bool intr,
 			   signed long timeout)
 {
 	struct qxl_device *qdev;
+	struct qxl_release *release;
+	int count = 0, sc = 0;
+	bool have_drawable_releases;
 	unsigned long cur, end = jiffies + timeout;
 
 	qdev = container_of(fence->lock, struct qxl_device, release_lock);
+	release = container_of(fence, struct qxl_release, base);
+	have_drawable_releases = release->type == QXL_RELEASE_DRAWABLE;
 
-	if (!wait_event_timeout(qdev->release_event,
-				(dma_fence_is_signaled(fence) ||
-				 (qxl_io_notify_oom(qdev), 0)),
-				timeout))
-		return 0;
+retry:
+	sc++;
+
+	if (dma_fence_is_signaled(fence))
+		goto signaled;
+
+	qxl_io_notify_oom(qdev);
+
+	for (count = 0; count < 11; count++) {
+		if (!qxl_queue_garbage_collect(qdev, true))
+			break;
+
+		if (dma_fence_is_signaled(fence))
+			goto signaled;
+	}
+
+	if (dma_fence_is_signaled(fence))
+		goto signaled;
+
+	if (have_drawable_releases || sc < 4) {
+		if (sc > 2)
+			/* back off */
+			usleep_range(500, 1000);
+
+		if (time_after(jiffies, end))
+			return 0;
+
+		if (have_drawable_releases && sc > 300) {
+			DMA_FENCE_WARN(fence,
+				       "failed to wait on release %llu after spincount %d\n",
+				       fence->context & ~0xf0000000, sc);
+			goto signaled;
+		}
+		goto retry;
+	}
+	/*
+	 * yeah, original sync_obj_wait gave up after 3 spins when
+	 * have_drawable_releases is not set.
+	 */
 
+signaled:
 	cur = jiffies;
 	if (time_after(cur, end))
 		return 0;
diff --git a/include/linux/dma-fence.h b/include/linux/dma-fence.h
index b3772edca2e6e..fd4a823ce3cdb 100644
--- a/include/linux/dma-fence.h
+++ b/include/linux/dma-fence.h
@@ -681,4 +681,11 @@ static inline bool dma_fence_is_container(struct dma_fence *fence)
 	return dma_fence_is_array(fence) || dma_fence_is_chain(fence);
 }
 
+#define DMA_FENCE_WARN(f, fmt, args...) \
+	do {								\
+		struct dma_fence *__ff = (f);				\
+		pr_warn("f %llu#%llu: " fmt, __ff->context, __ff->seqno,\
+			 ##args);					\
+	} while (0)
+
 #endif /* __LINUX_DMA_FENCE_H */
-- 
2.43.0




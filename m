Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3DBD3839B2;
	Sat, 17 Oct 2026 17:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259818; cv=none; b=qLxDz+kV40gkwuRNvV1sg3C7hpuG9ODsPV1FVSOp1NXHYeeSR7h240b7MMmxbrHSG1qrrCNJ8q8l1FBoplvdfW0I9Fx1dAdPyCvkK7qRHiJvEiKG8tjhLkgSOerWIuejW3uMdRg2b3ZHXAxodwxQowC0+aWOyMNZSjqZxv0jSxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259818; c=relaxed/simple;
	bh=ZHibrDdEjF69WrvvPkYuLVAWXMvzDaFI+QwVgHnlL1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=miFDaXVCyOmI9iPUdmM+MfK63KiaakyAo4I2guZOezItag59HKFEuody32ynSn5xE916r6N6oBvqgLqnZgkykvt8+0MVlKSctbim+ksuGVoHg0tWAQoasF6KhuKnLhdgLo3t+5tx5++JS6/U3dZvoDwdt/6IsvsRjvPAyK8YuGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NBCYNU+T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NBCYNU+T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5785E1F000C4;
	Sat, 17 Oct 2026 17:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259816;
	bh=uSlw8n88GrjQfyz0BGXy3bvnHI9ZAyuJPqYmyfU9VWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NBCYNU+T2rpddFkKJnwJ2VjfN0zRtrvo5v4c7SYGVaJVBbTBPF+OVAo2GgoHEeV60
	 fVloV41rfea+yxYKBG+vZO/3BpwsFYt4cQaFQzrewUddR738vubY8K6+dIg7XaVNzQ
	 RL/An6zpzuOXWHsWnFkuqZ1QsMWXKawOYKN0+3kg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Skeggs <bskeggs@nvidia.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1340/1674] drm/nouveau: remove chan->drm
Date: Sat, 17 Oct 2026 18:00:12 +0200
Message-ID: <20261017160505.542454046@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Ben Skeggs <bskeggs@nvidia.com>

[ Upstream commit 3543e84e20fbd60e02264f757c77c7dbdfd1ee4a ]

The nouveau_cli that owns the channel is now stored in nouveau_chan, and
it has a pointer to the drm device already.

Signed-off-by: Ben Skeggs <bskeggs@nvidia.com>
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240726043828.58966-34-bskeggs@nvidia.com
Stable-dep-of: 511585987d27 ("drm/nouveau: unsubscribe the channel-kill event before the fence context")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/dispnv04/crtc.c  |  4 ++--
 drivers/gpu/drm/nouveau/nouveau_bo0039.c |  2 +-
 drivers/gpu/drm/nouveau/nouveau_bo5039.c |  2 +-
 drivers/gpu/drm/nouveau/nouveau_chan.c   | 23 +++++++++--------------
 drivers/gpu/drm/nouveau/nouveau_chan.h   |  1 -
 drivers/gpu/drm/nouveau/nouveau_dma.c    |  2 +-
 drivers/gpu/drm/nouveau/nouveau_fence.c  | 15 ++++++++-------
 drivers/gpu/drm/nouveau/nouveau_gem.c    |  7 ++++---
 drivers/gpu/drm/nouveau/nv17_fence.c     |  6 +++---
 drivers/gpu/drm/nouveau/nv50_fence.c     |  2 +-
 drivers/gpu/drm/nouveau/nv84_fence.c     |  8 ++++----
 11 files changed, 34 insertions(+), 38 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/dispnv04/crtc.c b/drivers/gpu/drm/nouveau/dispnv04/crtc.c
index 8c7fff19c97bb..4c846276814c5 100644
--- a/drivers/gpu/drm/nouveau/dispnv04/crtc.c
+++ b/drivers/gpu/drm/nouveau/dispnv04/crtc.c
@@ -1042,7 +1042,7 @@ nv04_finish_page_flip(struct nouveau_channel *chan,
 		      struct nv04_page_flip_state *ps)
 {
 	struct nouveau_fence_chan *fctx = chan->fence;
-	struct nouveau_drm *drm = chan->drm;
+	struct nouveau_drm *drm = chan->cli->drm;
 	struct drm_device *dev = drm->dev;
 	struct nv04_page_flip_state *s;
 	unsigned long flags;
@@ -1098,7 +1098,7 @@ nv04_page_flip_emit(struct nouveau_channel *chan,
 		    struct nouveau_fence **pfence)
 {
 	struct nouveau_fence_chan *fctx = chan->fence;
-	struct nouveau_drm *drm = chan->drm;
+	struct nouveau_drm *drm = chan->cli->drm;
 	struct drm_device *dev = drm->dev;
 	struct nvif_push *push = chan->chan.push;
 	unsigned long flags;
diff --git a/drivers/gpu/drm/nouveau/nouveau_bo0039.c b/drivers/gpu/drm/nouveau/nouveau_bo0039.c
index e2ce44adaa5c4..2babc6c47241b 100644
--- a/drivers/gpu/drm/nouveau/nouveau_bo0039.c
+++ b/drivers/gpu/drm/nouveau/nouveau_bo0039.c
@@ -104,6 +104,6 @@ nv04_bo_move_init(struct nouveau_channel *chan, u32 handle)
 		return ret;
 
 	PUSH_MTHD(push, NV039, SET_OBJECT, handle);
-	PUSH_MTHD(push, NV039, SET_CONTEXT_DMA_NOTIFIES, chan->drm->ntfy.handle);
+	PUSH_MTHD(push, NV039, SET_CONTEXT_DMA_NOTIFIES, chan->cli->drm->ntfy.handle);
 	return 0;
 }
diff --git a/drivers/gpu/drm/nouveau/nouveau_bo5039.c b/drivers/gpu/drm/nouveau/nouveau_bo5039.c
index c6cf3629a9f93..0a6b1fce11084 100644
--- a/drivers/gpu/drm/nouveau/nouveau_bo5039.c
+++ b/drivers/gpu/drm/nouveau/nouveau_bo5039.c
@@ -144,7 +144,7 @@ nv50_bo_move_init(struct nouveau_channel *chan, u32 handle)
 		return ret;
 
 	PUSH_MTHD(push, NV5039, SET_OBJECT, handle);
-	PUSH_MTHD(push, NV5039, SET_CONTEXT_DMA_NOTIFY, chan->drm->ntfy.handle,
+	PUSH_MTHD(push, NV5039, SET_CONTEXT_DMA_NOTIFY, chan->cli->drm->ntfy.handle,
 				SET_CONTEXT_DMA_BUFFER_IN, chan->vram.handle,
 				SET_CONTEXT_DMA_BUFFER_OUT, chan->vram.handle);
 	return 0;
diff --git a/drivers/gpu/drm/nouveau/nouveau_chan.c b/drivers/gpu/drm/nouveau/nouveau_chan.c
index db2d01d013138..b706b6dd9a88b 100644
--- a/drivers/gpu/drm/nouveau/nouveau_chan.c
+++ b/drivers/gpu/drm/nouveau/nouveau_chan.c
@@ -90,12 +90,10 @@ nouveau_channel_del(struct nouveau_channel **pchan)
 {
 	struct nouveau_channel *chan = *pchan;
 	if (chan) {
-		struct nouveau_cli *cli = (void *)chan->user.client;
-
 		if (chan->fence)
-			nouveau_fence(chan->drm)->context_del(chan);
+			nouveau_fence(chan->cli->drm)->context_del(chan);
 
-		if (cli)
+		if (nvif_object_constructed(&chan->user))
 			nouveau_svmm_part(chan->vmm->svmm, chan->inst);
 
 		nvif_object_dtor(&chan->blit);
@@ -157,7 +155,6 @@ nouveau_channel_prep(struct nouveau_cli *cli,
 		return -ENOMEM;
 
 	chan->cli = cli;
-	chan->drm = drm;
 	chan->vmm = nouveau_cli_vmm(cli);
 	atomic_set(&chan->killed, 0);
 
@@ -229,12 +226,11 @@ nouveau_channel_prep(struct nouveau_cli *cli,
 			args.limit = device->info.ram_user - 1;
 		}
 	} else {
-		if (chan->drm->agp.bridge) {
+		if (drm->agp.bridge) {
 			args.target = NV_DMA_V0_TARGET_AGP;
 			args.access = NV_DMA_V0_ACCESS_RDWR;
-			args.start = chan->drm->agp.base;
-			args.limit = chan->drm->agp.base +
-				     chan->drm->agp.size - 1;
+			args.start = drm->agp.base;
+			args.limit = drm->agp.base + drm->agp.size - 1;
 		} else {
 			args.target = NV_DMA_V0_TARGET_VM;
 			args.access = NV_DMA_V0_ACCESS_RDWR;
@@ -421,12 +417,11 @@ nouveau_channel_init(struct nouveau_channel *chan, u32 vram, u32 gart)
 			args.start = 0;
 			args.limit = chan->vmm->vmm.limit - 1;
 		} else
-		if (chan->drm->agp.bridge) {
+		if (drm->agp.bridge) {
 			args.target = NV_DMA_V0_TARGET_AGP;
 			args.access = NV_DMA_V0_ACCESS_RDWR;
-			args.start = chan->drm->agp.base;
-			args.limit = chan->drm->agp.base +
-				     chan->drm->agp.size - 1;
+			args.start = drm->agp.base;
+			args.limit = drm->agp.base + drm->agp.size - 1;
 		} else {
 			args.target = NV_DMA_V0_TARGET_VM;
 			args.access = NV_DMA_V0_ACCESS_RDWR;
@@ -491,7 +486,7 @@ nouveau_channel_init(struct nouveau_channel *chan, u32 vram, u32 gart)
 	}
 
 	/* initialise synchronisation */
-	return nouveau_fence(chan->drm)->context_new(chan);
+	return nouveau_fence(drm)->context_new(chan);
 }
 
 int
diff --git a/drivers/gpu/drm/nouveau/nouveau_chan.h b/drivers/gpu/drm/nouveau/nouveau_chan.h
index 18a9cbfef8ca3..3ce9832c9528b 100644
--- a/drivers/gpu/drm/nouveau/nouveau_chan.h
+++ b/drivers/gpu/drm/nouveau/nouveau_chan.h
@@ -13,7 +13,6 @@ struct nouveau_channel {
 	} chan;
 
 	struct nouveau_cli *cli;
-	struct nouveau_drm *drm;
 	struct nouveau_vmm *vmm;
 
 	struct nvif_mem mem_userd;
diff --git a/drivers/gpu/drm/nouveau/nouveau_dma.c b/drivers/gpu/drm/nouveau/nouveau_dma.c
index b01c029f3a903..a1f329ef0641e 100644
--- a/drivers/gpu/drm/nouveau/nouveau_dma.c
+++ b/drivers/gpu/drm/nouveau/nouveau_dma.c
@@ -72,7 +72,7 @@ void
 nv50_dma_push(struct nouveau_channel *chan, u64 offset, u32 length,
 	      bool no_prefetch)
 {
-	struct nvif_user *user = &chan->drm->client.device.user;
+	struct nvif_user *user = &chan->cli->drm->client.device.user;
 	struct nouveau_bo *pb = chan->push.buffer;
 	int ip = (chan->dma.ib_put * 2) + chan->dma.ib_base;
 
diff --git a/drivers/gpu/drm/nouveau/nouveau_fence.c b/drivers/gpu/drm/nouveau/nouveau_fence.c
index 1bfa312d6fb85..ee43a36f17bd7 100644
--- a/drivers/gpu/drm/nouveau/nouveau_fence.c
+++ b/drivers/gpu/drm/nouveau/nouveau_fence.c
@@ -181,8 +181,9 @@ nouveau_fence_wait_uevent_handler(struct nvif_event *event, void *repv, u32 repc
 void
 nouveau_fence_context_new(struct nouveau_channel *chan, struct nouveau_fence_chan *fctx)
 {
-	struct nouveau_fence_priv *priv = (void*)chan->drm->fence;
-	struct nouveau_cli *cli = (void *)chan->user.client;
+	struct nouveau_cli *cli = chan->cli;
+	struct nouveau_drm *drm = cli->drm;
+	struct nouveau_fence_priv *priv = (void*)drm->fence;
 	struct {
 		struct nvif_event_v0 base;
 		struct nvif_chan_event_v0 host;
@@ -193,11 +194,11 @@ nouveau_fence_context_new(struct nouveau_channel *chan, struct nouveau_fence_cha
 	INIT_LIST_HEAD(&fctx->flip);
 	INIT_LIST_HEAD(&fctx->pending);
 	spin_lock_init(&fctx->lock);
-	fctx->context = chan->drm->runl[chan->runlist].context_base + chan->chid;
+	fctx->context = drm->runl[chan->runlist].context_base + chan->chid;
 
-	if (chan == chan->drm->cechan)
+	if (chan == drm->cechan)
 		strcpy(fctx->name, "copy engine channel");
-	else if (chan == chan->drm->channel)
+	else if (chan == drm->channel)
 		strcpy(fctx->name, "generic kernel channel");
 	else
 		strcpy(fctx->name, nvxx_client(&cli->base)->name);
@@ -221,7 +222,7 @@ nouveau_fence_emit(struct nouveau_fence *fence)
 {
 	struct nouveau_channel *chan = unrcu_pointer(fence->channel);
 	struct nouveau_fence_chan *fctx = chan->fence;
-	struct nouveau_fence_priv *priv = (void*)chan->drm->fence;
+	struct nouveau_fence_priv *priv = (void*)chan->cli->drm->fence;
 	int ret;
 
 	fence->timeout  = jiffies + (15 * HZ);
@@ -382,7 +383,7 @@ nouveau_fence_sync(struct nouveau_bo *nvbo, struct nouveau_channel *chan,
 			if (i == 0 && usage == DMA_RESV_USAGE_WRITE)
 				continue;
 
-			f = nouveau_local_fence(fence, chan->drm);
+			f = nouveau_local_fence(fence, chan->cli->drm);
 			if (f) {
 				struct nouveau_channel *prev;
 				bool must_wait = true;
diff --git a/drivers/gpu/drm/nouveau/nouveau_gem.c b/drivers/gpu/drm/nouveau/nouveau_gem.c
index 29b0884ff419c..c0efbb6085fe1 100644
--- a/drivers/gpu/drm/nouveau/nouveau_gem.c
+++ b/drivers/gpu/drm/nouveau/nouveau_gem.c
@@ -569,10 +569,11 @@ validate_init(struct nouveau_channel *chan, struct drm_file *file_priv,
 }
 
 static int
-validate_list(struct nouveau_channel *chan, struct nouveau_cli *cli,
+validate_list(struct nouveau_channel *chan,
 	      struct list_head *list, struct drm_nouveau_gem_pushbuf_bo *pbbo)
 {
-	struct nouveau_drm *drm = chan->drm;
+	struct nouveau_cli *cli = chan->cli;
+	struct nouveau_drm *drm = cli->drm;
 	struct nouveau_bo *nvbo;
 	int ret, relocs = 0;
 
@@ -644,7 +645,7 @@ nouveau_gem_pushbuf_validate(struct nouveau_channel *chan,
 		return ret;
 	}
 
-	ret = validate_list(chan, cli, &op->list, pbbo);
+	ret = validate_list(chan, &op->list, pbbo);
 	if (unlikely(ret < 0)) {
 		if (ret != -ERESTARTSYS)
 			NV_PRINTK(err, cli, "validating bo list\n");
diff --git a/drivers/gpu/drm/nouveau/nv17_fence.c b/drivers/gpu/drm/nouveau/nv17_fence.c
index 07c2e0878c244..7fa52ec61b30d 100644
--- a/drivers/gpu/drm/nouveau/nv17_fence.c
+++ b/drivers/gpu/drm/nouveau/nv17_fence.c
@@ -36,8 +36,8 @@ int
 nv17_fence_sync(struct nouveau_fence *fence,
 		struct nouveau_channel *prev, struct nouveau_channel *chan)
 {
-	struct nouveau_cli *cli = (void *)prev->user.client;
-	struct nv10_fence_priv *priv = chan->drm->fence;
+	struct nouveau_cli *cli = prev->cli;
+	struct nv10_fence_priv *priv = cli->drm->fence;
 	struct nv10_fence_chan *fctx = chan->fence;
 	struct nvif_push *ppush = prev->chan.push;
 	struct nvif_push *npush = chan->chan.push;
@@ -76,7 +76,7 @@ nv17_fence_sync(struct nouveau_fence *fence,
 static int
 nv17_fence_context_new(struct nouveau_channel *chan)
 {
-	struct nv10_fence_priv *priv = chan->drm->fence;
+	struct nv10_fence_priv *priv = chan->cli->drm->fence;
 	struct ttm_resource *reg = priv->bo->bo.resource;
 	struct nv10_fence_chan *fctx;
 	u32 start = reg->start * PAGE_SIZE;
diff --git a/drivers/gpu/drm/nouveau/nv50_fence.c b/drivers/gpu/drm/nouveau/nv50_fence.c
index ea1e1f480bfeb..8b76cb227f555 100644
--- a/drivers/gpu/drm/nouveau/nv50_fence.c
+++ b/drivers/gpu/drm/nouveau/nv50_fence.c
@@ -35,7 +35,7 @@
 static int
 nv50_fence_context_new(struct nouveau_channel *chan)
 {
-	struct nv10_fence_priv *priv = chan->drm->fence;
+	struct nv10_fence_priv *priv = chan->cli->drm->fence;
 	struct nv10_fence_chan *fctx;
 	struct ttm_resource *reg = priv->bo->bo.resource;
 	u32 start = reg->start * PAGE_SIZE;
diff --git a/drivers/gpu/drm/nouveau/nv84_fence.c b/drivers/gpu/drm/nouveau/nv84_fence.c
index 812b8c62eeba1..7f62089dc9400 100644
--- a/drivers/gpu/drm/nouveau/nv84_fence.c
+++ b/drivers/gpu/drm/nouveau/nv84_fence.c
@@ -79,7 +79,7 @@ nv84_fence_sync32(struct nouveau_channel *chan, u64 virtual, u32 sequence)
 static inline u32
 nv84_fence_chid(struct nouveau_channel *chan)
 {
-	return chan->drm->runl[chan->runlist].chan_id_base + chan->chid;
+	return chan->cli->drm->runl[chan->runlist].chan_id_base + chan->chid;
 }
 
 static int
@@ -105,14 +105,14 @@ nv84_fence_sync(struct nouveau_fence *fence,
 static u32
 nv84_fence_read(struct nouveau_channel *chan)
 {
-	struct nv84_fence_priv *priv = chan->drm->fence;
+	struct nv84_fence_priv *priv = chan->cli->drm->fence;
 	return nouveau_bo_rd32(priv->bo, nv84_fence_chid(chan) * 16/4);
 }
 
 static void
 nv84_fence_context_del(struct nouveau_channel *chan)
 {
-	struct nv84_fence_priv *priv = chan->drm->fence;
+	struct nv84_fence_priv *priv = chan->cli->drm->fence;
 	struct nv84_fence_chan *fctx = chan->fence;
 
 	nouveau_bo_wr32(priv->bo, nv84_fence_chid(chan) * 16 / 4, fctx->base.sequence);
@@ -127,7 +127,7 @@ nv84_fence_context_del(struct nouveau_channel *chan)
 int
 nv84_fence_context_new(struct nouveau_channel *chan)
 {
-	struct nv84_fence_priv *priv = chan->drm->fence;
+	struct nv84_fence_priv *priv = chan->cli->drm->fence;
 	struct nv84_fence_chan *fctx;
 	int ret;
 
-- 
2.53.0




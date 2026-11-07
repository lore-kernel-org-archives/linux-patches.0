Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062698;
	b=f+f5MI1Gy/6TUdwxA3gMtH55HCKfww+Or0eTif1HJX/o6nUpg56pIlhrQbVK04Llpx8u
	 /GhvJZBO7tg1QDDujJSTniL/0qoBFATaeCEvfXfONwEc8DOzBImKfuCDerKEMLXvu8+wf
	 EX1pxiwibio+9308WOSkOWbLgS9UjKgBGmhv+B3lYWJbOZxUpps7Ychu0XDjLFB9/QKri
	 hhbqhJUWj4vrE/2HlmbP2Md0FhhwefUC5r5zZnj8xIxmRdb8dspZQhHDewHu17JJvOf19
	 1GCAGGNrNGSsJ+XFoR/63hN9ox7jbYA89JO2soTrwJxDbMYRHKO9PQ6I94cYWO2tXJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062698;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QF2VF1A6hrrxIB6iteSdZ2FvdisYvxTm4hImNL7Iei8=;
	b=f2wWMObtNHc6210384ZjlTQTDX3ijfNLj3CvqeYkzGSD444PbS4IE4JtWdHUZ0dmogaT
	 ZRRusTN2t+tTQTGoAYO+uuVLpFnARJl/9En1eInkNCx7nisSXmYb/tYxu4xmuY9O6kK63
	 fctrrJy2LObk4f8+KDQtZdAokrsCyo4RXVqIR0WMO7+zNGnX1GPmVFnBau3A1HCf9hDeK
	 ks8hUjAclmokwr1QuxEZU/dufcIRE5hQX3D503pDuyiOtNIS4s+umzUv+ErsFZyLuxWGG
	 M5lRQJ57hw266pFMINNW8HBVcK5PBpILQ70Xq4A6l1EQITfAmDSKfa214ck0ALdmORA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i+lAmcB8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D90606A326;
	Sat,  7 Nov 2026 14:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i+lAmcB8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F3AE1F0089F;
	Sat,  7 Nov 2026 14:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062698;
	bh=QF2VF1A6hrrxIB6iteSdZ2FvdisYvxTm4hImNL7Iei8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i+lAmcB8DdQ3NCy+e8Kg0ofqDEXe9w0GUDUCRNZEmEryu7N+TZKGNEsVhcTSxlrpJ
	 zy652T/mdKcsdBbLKOBIUmzG3fnNt5RaiezSPqkjcxDonT/rTt6JOoNe/wXXZJlav1
	 kjI88qFj97/Unk54xDsHC3Gl/HQixOYL69I6aeKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Marek Czernohous <marek@czernohous.de>,
	Lyude Paul <lyude@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 024/869] drm/nouveau: disable the fence uevent work instead of just cancelling it
Date: Sat,  7 Nov 2026 08:45:06 -0500
Message-ID: <20261107134852.884805074@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Czernohous <marek@czernohous.de>

[ Upstream commit 827eb9328eaed831d7cc426ac2705038a40835b6 ]

nouveau_fence_context_del() drains the uevent work while the event that
feeds it is still armed:

	cancel_work_sync(&fctx->uevent_work);
	nouveau_fence_context_kill(fctx, 0);
	nvif_event_dtor(&fctx->event);

nouveau_fence_wait_uevent_handler() queues the work unconditionally:

	schedule_work(&fctx->uevent_work);
	return NVIF_EVENT_KEEP;

so a non-stall interrupt arriving after cancel_work_sync() has returned
re-arms the work that was just drained.  The window closes in two steps,
neither of which is the drain.  The kill blocks the event when the last
fence holding a notify_ref is signalled, which reaches
atomic_xchg(&ntfy->allowed, 0) (nvkm/core/event.c:104), and
nvkm_event_ntfy() skips a ntfy that is not allowed (:183).  That stops
further handlers from starting, but not one that is already inside
nvkm_event_ntfy(): the event is created with wait = false
(nouveau_fence.c:201), so nvkm_event_ntfy_block_() leaves it on the list
and never takes event->list_lock.  Only nvif_event_dtor() waits that one
out: nvkm_event_ntfy_del() (:141) goes through nvkm_event_ntfy_remove(),
which takes write_lock_irq() on that same list_lock (:84).

Either way the re-arm happens after the drain, and the caller drops its
reference immediately afterwards, for example nv84_fence_context_del():

	nouveau_fence_context_del(&fctx->base);
	chan->fence = NULL;
	nouveau_fence_context_free(&fctx->base);

That is a kref_put() on fctx->fence_ref, so the context outlives the
teardown only while emitted fences still hold a reference of their own.
That is no safety net: whenever none do, the count reaches zero right
there and nouveau_fence_context_put() kfree()s fctx while the work is
still queued.  &fctx->uevent_work is embedded in that allocation, so the
workqueue already dereferences freed memory when it picks the item up,
and nouveau_fence_uevent_work() can then take fctx->lock on it.  With
CONFIG_DEBUG_OBJECTS_WORK and CONFIG_DEBUG_OBJECTS_FREE, kfree() of a
still-queued work item is reported as the free of an active object.

On live memory the re-armed work has nothing left to do:
nouveau_fence_context_kill() empties fctx->pending and sets fctx->killed
under fctx->lock, nouveau_fence_emit() then returns -ENODEV rather than
queueing anything new, and nouveau_fence_update() only reaches
nvif_event_block() if it signalled something off that list.  The defect
is the access to freed memory, not what the work would have found.

Only chips from G84 on can reach this at all: nouveau_fence_context_new()
returns before nvif_event_ctor() when priv->uevent is clear, and
nv84_fence_create() is the only place that sets it.
nv84_fence_context_del() is the context_del for all of those, because
nvc0_fence_create() and gv100_fence_create() build on nv84_fence_create()
and override only context_new.

Use disable_work_sync() instead.  It drains the work exactly like
cancel_work_sync() does, and additionally increments the work item's
disable count, after which "any attempt to queue @work will fail and
return %false" (kernel/workqueue.c, disable_work()).  The handler's
schedule_work() then has nothing to re-arm, and the teardown order stays
as it is.

Draining a second time after nvif_event_dtor() would close the window as
well, and without the newer API: once nvkm_event_ntfy_remove() has
returned, no handler can start or still be running, so nothing re-arms
the work past that point.  disable_work_sync() is preferred here because
it needs one synchronisation point instead of two, it keeps the work
from being queued at all rather than cleaning up after it, and it is
what drm has settled on for this (drm/xe, drm/panthor, drm_pagemap).
Blocking the event rather than the work is not an option: fctx->event is
created with wait = false, so a handler already inside nvkm_event_ntfy()
can still queue the work.

Note for backports: disable_work_sync() arrived in v6.10 with
commit 86898fa6b8cd ("workqueue: Implement disable/enable for (delayed)
work items"), while the fix being corrected here reached 6.6.18 and
6.7.6.  linux-6.6.y therefore carries this bug without the API, and this
patch would apply there and then fail to build.  A 6.6.y backport wants
the second drain described above instead, as its own patch.

Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/20260812233022.159301F000E9@smtp.kernel.org/
Fixes: 39126abc5e20 ("nouveau: offload fence uevents work to workqueue")
Cc: <stable@vger.kernel.org> # 6.10.x
Assisted-by: Claude:claude-opus-5
Signed-off-by: Marek Czernohous <marek@czernohous.de>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patch.msgid.link/178688513268.513871.3468844663561639695@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nouveau_fence.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_fence.c b/drivers/gpu/drm/nouveau/nouveau_fence.c
index 4a193b7d6d9e4..7acf241c4daf3 100644
--- a/drivers/gpu/drm/nouveau/nouveau_fence.c
+++ b/drivers/gpu/drm/nouveau/nouveau_fence.c
@@ -95,7 +95,7 @@ nouveau_fence_context_kill(struct nouveau_fence_chan *fctx, int error)
 void
 nouveau_fence_context_del(struct nouveau_fence_chan *fctx)
 {
-	cancel_work_sync(&fctx->uevent_work);
+	disable_work_sync(&fctx->uevent_work);
 	nouveau_fence_context_kill(fctx, 0);
 	nvif_event_dtor(&fctx->event);
 	fctx->dead = 1;
-- 
2.53.0




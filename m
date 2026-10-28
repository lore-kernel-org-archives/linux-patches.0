Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216211;
	b=fhnZTLehESiggacG1nez3987AZcM5vmzLiEHSlGSo/7XHaJ+CQ+e4Aeo4V3bMB7qOBrq
	 bVptAU6eOgLKuX+bMGrWfne8HlT6JFb93yXknEMe2gKHZMppUInLUb04kc0jf50NQJnQ+
	 rHz4CbIVLGIBItew6gMsIKQRHXTxpIM7HIPQ3d4uu7oaUjmV8gN+0X9Z0UEcyjtCkuYz/
	 dVQHeGA4Jd6KMUoUOdjIJahG8z+/+TSDJsIcZA9fvz/+3N+49jtvC35J+mbs+Tm07/RNC
	 /ks0R2OIP9p6N3mW1zjNyAtw4iF2jhwHG1HcqXLVI+ObPLY0Rylc2ll7eY0jV/rrOJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216211;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=T2GKgDoyDZgOZOA4vWmhvnaR4gZMzfnLuaym/8c7aIk=;
	b=FcYksJyR0a01czcF1Q1Pf+kUlirGslvRrU95CF0DgoCr6+FMuT1EAs65B3LuERkaTKo3
	 RGnCstOuxXGLpXKKVYeVDOFaZp+wgJ9XIoAAm2LyKbcFU+sDpndX6slBOQO7OHKaCDf7n
	 JOFIfTgvUsFd/IIt60OL4Y/lxOvWmuBxlx1G0wH36Alf225dM854+V5I7/tROZ5HgMKGe
	 kYFyZVbPud3F9xmozy8jQGD6Dl4IJ75dDFDdJrCX64NwQAB0HL/qM1plIUoofbp++Jz4o
	 PFm8MIutfwM8g54g2GI/YnxqUYTC4+ZCVFaRC4MegUmFy6UoDh/8srbpxI8RWodPk2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oaLwgwly;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10BFA606A31A;
	Wed, 28 Oct 2026 19:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oaLwgwly
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33B191F01825;
	Wed, 28 Oct 2026 19:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216210;
	bh=T2GKgDoyDZgOZOA4vWmhvnaR4gZMzfnLuaym/8c7aIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oaLwgwlyTqp8vE9/X5ZPaIuqIXJZT4WaSPN8752IWCbe0q/zWwbFcjHy+dZEdfStE
	 MH8sngxG7OPNwbCtLy0bAWoiIqfbThekbzrWbNtDQ0Sd/H3GzAgdqnbHhreeX2aQJN
	 R3gxC7r/LwqBPw75rscAnmZwG5wZUHrvEb0IT5LA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Czernohous <marek@czernohous.de>,
	Lyude Paul <lyude@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1479/1887] drm/nouveau: unsubscribe the channel-kill event before the fence context
Date: Wed, 28 Oct 2026 17:59:35 +0100
Message-ID: <20261028170533.109543431@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Czernohous <marek@czernohous.de>

[ Upstream commit 511585987d27d8cb668acebd399fc4deda23404c ]

nouveau_channel_del() tears the fence context down first and only drops
the channel-kill subscription later, in the middle of the nvif object
teardown:

	if (chan->fence)
		nouveau_fence(chan->cli->drm)->context_del(chan);
	...
	nvif_object_dtor(&chan->vram);
	nvif_event_dtor(&chan->kill);

The subscribed handler is nouveau_channel_killed(), which calls
nouveau_channel_kill() and from there nouveau_fence_context_kill() on
chan->fence. A kill event delivered in that window takes fctx->lock and
walks fctx->pending on a fence context that context_del() has already
freed.

Nothing reaches this below Fermi today, because the subscription is
gated on FERMI_CHANNEL_GPFIFO and nothing kills a channel there. On
Fermi and newer the window is real but narrow, since a kill has to land
exactly while the channel is being destroyed. That is reason enough on
its own, which is why this carries a Fixes: tag. The last patch in this
series subscribes Tesla channels as well; nothing kills those today, so
it does not widen the exposure now, but it is the groundwork for a
recovery path that would, and the ordering is better fixed before that
lands than alongside it.

Drop the subscription before anything it depends on is torn down.

Fixes: ea13e5abf807 ("drm/nouveau: signal pending fences when channel has been killed")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5
Signed-off-by: Marek Czernohous <marek@czernohous.de>
Fixes: ea13e5abf807 ("drm/nouveau: signal pending fences when channel has been killed")
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patch.msgid.link/20260812231330.705425-2-mczernohous@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nouveau_chan.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_chan.c b/drivers/gpu/drm/nouveau/nouveau_chan.c
index 48dea5d0c580f..5b62959320b43 100644
--- a/drivers/gpu/drm/nouveau/nouveau_chan.c
+++ b/drivers/gpu/drm/nouveau/nouveau_chan.c
@@ -87,6 +87,14 @@ nouveau_channel_del(struct nouveau_channel **pchan)
 	if (chan) {
 		struct nouveau_cli *cli = (void *)chan->user.client;
 
+		/*
+		 * Drop the kill-event subscription first.  Its handler
+		 * dereferences chan->fence, which the fence context teardown
+		 * below frees, so leaving it armed across the teardown leaves
+		 * a window for a use-after-free.
+		 */
+		nvif_notify_dtor(&chan->kill);
+
 		if (chan->fence)
 			nouveau_fence(chan->drm)->context_del(chan);
 
@@ -96,7 +104,6 @@ nouveau_channel_del(struct nouveau_channel **pchan)
 		nvif_object_dtor(&chan->nvsw);
 		nvif_object_dtor(&chan->gart);
 		nvif_object_dtor(&chan->vram);
-		nvif_notify_dtor(&chan->kill);
 		nvif_object_dtor(&chan->user);
 		nvif_object_dtor(&chan->push.ctxdma);
 		nouveau_vma_del(&chan->push.vma);
-- 
2.53.0




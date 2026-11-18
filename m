Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054264;
	b=KggFosmPZT20uO4oRw073+0TYKoLDSqpd1tevZLTXwTcxezGqKE2hRGs9eAnS/5H+ycZ
	 j3GVZ3LA6hf8SffvChtw+kfx7LESOP9OzDHUtCgl7cngt02PDVwsyHg7R730A+TGW1E+2
	 8BZtseMto6YKhVTa/mOmXY0hlntqskxx7Mv6xMyvpTxS8mEHI2+sfc6WZE1TqchooL36Q
	 O0H12EGREi8cFxRHOQN2w+s1onvYuzRaL71g7K4nod2gqwhJePOLqg/Ewa2vMoetZe9Eh
	 IGTIJcLLOvFMxC8YzKKUxFGdPoGDmJcWf/zwM/XuFrvQbd4txXLojdswL/xZucvPDbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054264;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+aKNDr3NA1oYxQHh3B4ob5VJQAAj6cb8Sr5pOs6TJZM=;
	b=gO9gcvRNsNV0INfJj+lbP2o3PqqSl0Qwaaqyyb+6HGVbQB3kfA+J87t3mHWt48oixi0e
	 hIGNxwVC20SDQVVvkcuzQFqqsqC3ED71qiAOs42R2opyNZM9XwCA3+/46MXpb9vBFLDlE
	 v5NcvRH4bhjXZM8EUpjkrm7+/5f88dMaED2BACyqcroGdGWO2IIFk+A3vB4qNJWG4ORJ7
	 jNsRsyThMsnBUCsWe7zSLpQS4Otf7r7zwc79Wbgjg6lMVGsFldDLy0icsle6Blon+tiI/
	 GU7R4v8hBLzKAKCFhAiCyaiL8eJITD2h4rGssiPBNaCoMSXE4ONhmqd3NJLPrdAxVRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="j/2GKQu/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 146BE606A31C;
	Thu, 19 Nov 2026 02:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j/2GKQu/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DD9E1F000C4;
	Thu, 19 Nov 2026 02:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054263;
	bh=+aKNDr3NA1oYxQHh3B4ob5VJQAAj6cb8Sr5pOs6TJZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j/2GKQu/lw5vEpvFxZtqWFCPNEH5mMxTCIjabPTzq2SXBBTqpC62ouQCz+uxZeb8l
	 aenjwVObbHb28phzeJ09ewLC9Qwa+t2x5ef8xudKx1YHHUxgDZeczR5Bo6RrC7s2Ug
	 vDOqF++E3pF6X135Je7ULiWwV+/XotbkFQvuUc/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>,
	Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>,
	Ao Wang <wangao@seu.edu.cn>,
	Xuewei Feng <fengxw06@126.com>,
	Qi Li <qli01@tsinghua.edu.cn>,
	Ke Xu <xuke@tsinghua.edu.cn>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1214/2214] 9p/xen: drain response work after unbinding IRQ
Date: Wed, 18 Nov 2026 15:48:10 +0100
Message-ID: <20261118150100.361528895@linuxfoundation.org>
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

From: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>

[ Upstream commit 7b6f2e3c29fb4d76f1e4973280792eabbd526602 ]

commit ea4f1009408e ("9p/xen : Fix use after free bug in
xen_9pfs_front_remove due to race condition") added cancel_work_sync()
to keep xen_9pfs_front_free() from freeing a ring while
p9_xen_response() is still running.

The work is currently drained before the event channel IRQ is unbound.
That leaves a race window where xen_9pfs_front_event_handler() can run
after cancel_work_sync() returns and queue p9_xen_response() again.  The
following unbind_from_irqhandler() synchronizes with the IRQ handler, but
it does not cancel work that the handler already queued.  The teardown
can then free the ring and private data while the response work remains
pending, and the worker later dereferences ring->priv and priv->client.

Unbind the event channel IRQ before draining the work.  Once the IRQ is
unbound, no new response work can be queued by the backend event channel,
and cancel_work_sync() waits for any work that was queued before or
during the unbind.  It is then safe to release the ring resources.

Fixes: ea4f1009408e ("9p/xen : Fix use after free bug in xen_9pfs_front_remove due to race condition")
Cc: stable@vger.kernel.org
Reported-by: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
Reported-by: Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>
Reported-by: Ao Wang <wangao@seu.edu.cn>
Reported-by: Xuewei Feng <fengxw06@126.com>
Reported-by: Qi Li <qli01@tsinghua.edu.cn>
Reported-by: Ke Xu <xuke@tsinghua.edu.cn>
Assisted-by: GLM:GLM-5.1
Signed-off-by: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
Message-ID: <20260609155202.1706-1-zhaoyz24@mails.tsinghua.edu.cn>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
[ sashal: adjusted context for older IRQ cleanup that leaves the IRQ number unchanged after unbinding instead of resetting it to -1 ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/trans_xen.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/9p/trans_xen.c b/net/9p/trans_xen.c
index d07377e5a62b7..49efcd8f8fe55 100644
--- a/net/9p/trans_xen.c
+++ b/net/9p/trans_xen.c
@@ -312,12 +312,12 @@ static void xen_9pfs_front_free(struct xen_9pfs_front_priv *priv)
 	for (i = 0; i < priv->num_rings; i++) {
 		struct xen_9pfs_dataring *ring = &priv->rings[i];
 
-		cancel_work_sync(&ring->work);
-
 		if (!priv->rings[i].intf)
 			break;
 		if (priv->rings[i].irq > 0)
 			unbind_from_irqhandler(priv->rings[i].irq, ring);
+		cancel_work_sync(&ring->work);
+
 		if (priv->rings[i].data.in) {
 			for (j = 0;
 			     j < (1 << priv->rings[i].intf->ring_order);
-- 
2.53.0




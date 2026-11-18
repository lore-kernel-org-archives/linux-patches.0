Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028483;
	b=Lo9Kk2QscWgocgVUbF4NN7gxFuCG7q/HAytHqkGO+GRIipWRYc1UBvZLNgZv9dhkFvZg
	 TOuthRjq6ujkwp0rVGqdV2LSdyfvjWX73iUD2IGsuHxk4fFhPZr9qwNTX/XTTv7nwpDYr
	 YnvmjaHQSgnZRKDxqfJC7/zm/wppYlZvx7lX1tNd6rEYC0bAL7OL3R8wTMNGqwes7Tluc
	 cRwgDalxfpLCF6Nx3Ix93V1yE3EeJz1yr17wC90ovrJTwG7bOICgP8hlqHCx76Alok5pu
	 MytNHe+rqfZGKB/nlspM27P1TgUp5GwlA3TGeUx6CVFvj+SkdjhfEyH0ykpYkK9IFJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028483;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ef6JNx6a3Y6wAZMh8grM+uXTQjz2uIelbzqcedKwaqQ=;
	b=cGGqh+Os9FLw4qXIAHC+dGsvYAhdJBAFFDucV0rF1Xm2nIP1e6w91B1cNyKB2KiDxndb
	 m4uXcCnsHpqI5Q5VOxfexFf0RT9ZKFJxX21DxqdnwtF6ukhjbB2U4LY/jIoQFLCmWs9TB
	 NOT6SoDB8kKOukCFyBefcP/QLrKwC9QAkrrN4OgeCszASLFcR4VkNV386NzdF/82xVcAH
	 3p71xlPQUiW85qhHTeGeMWvvu82GP6jYHeXYnepLVi0Hf9qC3dN15xRJvzjHaf42jeI7b
	 BJYsWDWDq4vwB5iBGnLO0bhywl7hIDTs41pFZDpqex5hHjokeZCsMjGZysel3NNJxJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HHD8MuQy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63A73606A33D;
	Wed, 18 Nov 2026 19:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HHD8MuQy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFB2D1F000C5;
	Wed, 18 Nov 2026 19:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028483;
	bh=ef6JNx6a3Y6wAZMh8grM+uXTQjz2uIelbzqcedKwaqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HHD8MuQyQqaZ2MWlE/fi58egyDS0Q9AnO+F4swUDHJgqvJpXSBOWloCluD4ji8K/x
	 1bODi9quLBwWOPrHxl3ypwhAm6bg780nX5qUkia5uxT6Ks9oMQew0D/N6bXlG47U7h
	 2invwZcnLbB9xKpQW1ufk+DaeA8VJT4av6TJb/yM=
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
Subject: [PATCH 6.12 0004/1756] 9p/xen: drain response work after unbinding IRQ
Date: Wed, 18 Nov 2026 15:35:31 +0100
Message-ID: <20261118150008.160267015@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/trans_xen.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/9p/trans_xen.c b/net/9p/trans_xen.c
index 67f464acf6171..ef9bac5f4a24a 100644
--- a/net/9p/trans_xen.c
+++ b/net/9p/trans_xen.c
@@ -288,12 +288,12 @@ static void xen_9pfs_front_free(struct xen_9pfs_front_priv *priv)
 		for (i = 0; i < XEN_9PFS_NUM_RINGS; i++) {
 			struct xen_9pfs_dataring *ring = &priv->rings[i];
 
-			cancel_work_sync(&ring->work);
-
 			if (!priv->rings[i].intf)
 				break;
 			if (priv->rings[i].irq > 0)
 				unbind_from_irqhandler(priv->rings[i].irq, ring);
+			cancel_work_sync(&ring->work);
+
 			if (priv->rings[i].data.in) {
 				for (j = 0;
 				     j < (1 << priv->rings[i].intf->ring_order);
-- 
2.53.0




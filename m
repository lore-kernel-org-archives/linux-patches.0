Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047375;
	b=CWg4sszg9OVKjZ5fxynF34+zDLl7y6SpUbuMTa5iai3+eXv7vEGkl3PYxM376nDAxt4J
	 y5KWzcA1qiBrrLGYn4VXpaUh7tv3Qrg3jq4okvi9cX/X0z8CGqKPvlJZt3eTCT8wy0hYG
	 11EuNGCeB1bp2wzBMkb+FVCxufR1gQBB3jev2k+9x/uYrtvTtqQjsNq9xWhDcH5pCpdRO
	 ii8wOML2VynHMa6XVnbDTNZAjbmtQ+OMq+HsqkZ6+/1VrsDurT7gP1CDWHkMjj2yFjRlI
	 qczZJ77lIbp/pXjHZ0O0SkywTBN5PJ1eB41p6h4r8G85gp39coegv8UgITSbdFUIaTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047375;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cjB/pZAVOzSpF6nO0hKLm1mmVpVWUAPIfU3V2xOzn5o=;
	b=znRkMhOc5ErpJOpDkaMJh8tggtvJXlPVejhNF9IJCJ7IWZ4HyvaGXMtvnSqk3s5QX9Ov
	 DLHM5BdGDNr+OAdKAXZ9Ckj/lpUAK8QxT+z0Aj3LMJRrbdA1n2zx05KF8kr7WJwyyWrjB
	 FbrvSDZI0DwySMIeiO9s0TfI6AluxM4W8KAO4mgVJNQZKn08Hh+9tfbj35aFU3K84GFr4
	 6nZ+xaV/3KWxLbREp0xPKA+kkvZyFEBhC22wFuJblqC0LoBQjjJDJ95mkn4dkQPA9osHN
	 xFFF74gup3lnkYBlmOvw86vW/piS3lCeK9aL52oA5sbUZhD2pXgylzPrd2YUkFt9+dg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fbhEXI1P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 336B8606A33B;
	Thu, 19 Nov 2026 00:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fbhEXI1P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49E1B1F000C4;
	Thu, 19 Nov 2026 00:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047374;
	bh=cjB/pZAVOzSpF6nO0hKLm1mmVpVWUAPIfU3V2xOzn5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fbhEXI1PFbRGM6EE89cMFmDQ0BFb437Gx9Xb4mfts6BJ8PxRmSUIJp8RmizgCdL3L
	 l1HnCFtKiUORdbsUKqqh+IFCSbb5YxUj4eQuMiRuuyfsHcEqZu8b9wQggfht33b9W1
	 JKfMNnOYHVqie+W+oMetgZxaoRVUg34HSvfYfFJw=
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
Subject: [PATCH 6.1 1616/2857] 9p/xen: drain response work after unbinding IRQ
Date: Wed, 18 Nov 2026 15:44:10 +0100
Message-ID: <20261118150259.536744456@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
index 48a412f6242d1..00448c1896400 100644
--- a/net/9p/trans_xen.c
+++ b/net/9p/trans_xen.c
@@ -287,12 +287,12 @@ static void xen_9pfs_front_free(struct xen_9pfs_front_priv *priv)
 		for (i = 0; i < priv->num_rings; i++) {
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




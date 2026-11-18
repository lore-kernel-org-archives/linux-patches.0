Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015044;
	b=HOKahbWNzUtvlmkyjgxeWcCG0x/MYdxcATU+dfimFAQVZb5pY0Vd3KHRDbJrwCYK7sr0
	 SHzMN/GnXA0UGyZnB46XazADdRmsizQCWCAOC+7KykJEDXHlNuxfBteBT72/aDhDpPwg0
	 9GzbzZmojjj+xFj1/lMTqUH8Gpq1Jztk2m5Rkt53QdDrCqUZgi3iQyCSHi6MEYAixkWrK
	 L97egO1r+yKPvLElxEt8hATrwywqYniZImlP77XMBzbt25dgB1+Pa8EmnPYDxnVQxZOsm
	 Bgb3ZNrWQtxoj+Lq0VK9sfCpNXa5q1DPG2AlUz3moK/Sysm3aLy/XHZz6+wN61SZoxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015044;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XSGrJizvG4/+RpbIXEbUj0xnWR26c0PaE5jVu48F+EY=;
	b=fr7K7GB8OyiF1cZXjbhauo6uZ1HBNMC1Ue3jBSl45v5l7mqmbv1wUsx+DWI5tgaWfZ+r
	 t1ygDeBG8y2GLisdIX/6Dgyi6joDp76uC1cRmsMWJWSoJ+toJYJXnNw8447sxtAeBztxr
	 wzWudxhxcWH+768XkuHc2Zw2QsKmc4N4vADslJqpvEgwk+l4MBa/fJW1ewq2QispQhybZ
	 AXgpSQqwWBdRKHEYHHAhRXcZ8K62v0OU4eiVKcM7dNeAcVCKnetOpeCzK0Awk4ERv4gLN
	 v+WHebq+PMXVyEPx2lHFhOGRl1KhYAOYr74xKcND6BYtKb9J9W1GiY39uUnYbFZS4aQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BGSmSsi6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49EBB606A31C;
	Wed, 18 Nov 2026 15:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BGSmSsi6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 690151F000C4;
	Wed, 18 Nov 2026 15:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015043;
	bh=XSGrJizvG4/+RpbIXEbUj0xnWR26c0PaE5jVu48F+EY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BGSmSsi61nsXzXuq/a9cy9g0JDxuKTMIqnTDuEMqnHvskrBNZlA2Yy11OZ0yms4i7
	 qnnxybX6Z0/84wpdybpaIfpc7+ikWICEp+pSIetoIx44JCcc1UodLEwiFHU7MWzW3h
	 Pf8BSZMCZ/CAmArNj5wpl+erLi7Sc16TbanL34Sg=
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
Subject: [PATCH 7.3 0003/2651] 9p/xen: drain response work after unbinding IRQ
Date: Wed, 18 Nov 2026 15:20:43 +0100
Message-ID: <20261118150248.127449208@linuxfoundation.org>
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
[ sashal: Adjusted indentation to fit the existing if (priv->rings) cleanup wrapper for separately allocated rings. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/trans_xen.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/9p/trans_xen.c b/net/9p/trans_xen.c
index 71a4d276321e2..69a5129a9b64a 100644
--- a/net/9p/trans_xen.c
+++ b/net/9p/trans_xen.c
@@ -291,14 +291,14 @@ static void xen_9pfs_front_free(struct xen_9pfs_front_priv *priv)
 		for (i = 0; i < XEN_9PFS_NUM_RINGS; i++) {
 			struct xen_9pfs_dataring *ring = &priv->rings[i];
 
-			cancel_work_sync(&ring->work);
-
 			if (!ring->intf)
 				break;
 			if (ring->irq >= 0) {
 				unbind_from_irqhandler(ring->irq, ring);
 				ring->irq = -1;
 			}
+			cancel_work_sync(&ring->work);
+
 			if (ring->data.in) {
 				for (j = 0; j < (1 << ring->intf->ring_order);
 				     j++) {
-- 
2.53.0




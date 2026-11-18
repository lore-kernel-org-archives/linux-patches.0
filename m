Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038776;
	b=crpr81bG8OY90W6SkeQLcMoBmtGerJTKsnERqUw8hrWEsxv9Df6zftphwOT3RhbQoY2d
	 vw1uNfHiXZ90cEj5I7QoBKymeVRoV6YK1Nfrkn9d/hjAnYwQph3D2TYZW9HglmmMe8ucC
	 UoAIVnbMGkL9b+ALO/oHj++Z/YGgDwnEyBlfnGQUrfcu8CuMQdNttNRQGg9nPDNagwCPF
	 1OrnFpIkJmUTPfPzCfcYj35N+hsbzdTAy3ZrW4VKKYJnv/7t+jnXMZH6jiOX2k6GqDwMe
	 pla1Zl+BC5qpQ0+TlrOJw56ITVPJkc6yPjDtvYZGQCz6akr44eGjkgSdoQ5xRKuwVDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038776;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JUJyXUYXBFUwfTaqdNByhH3/PIGicCor0OOPLVD9NHM=;
	b=W/xK7zcfIZYcC91zr9kH84puW1+STMXd2B9muKN4/fRPyrrtj65qef0sLQewyBdyaBrV
	 AUfVrFHe/J6ZjHWt0aaac7GU5ipPO/USvR4VK9CPOMVUzMFcnMfhmlP9B+4zZgBwsyUWC
	 0wc55Ya7L8ffdUOtg1oknkSDtW+++l/lR8zfTtjVN/VofnvB/Li62X/uzViWZFTIDHueN
	 3gfUJPGkEIYCFbzrj/spPtRlF5G9SGf6hSd6ex/pjKwKYhlJoF5ASZNA+Pi7fVXYqQLJx
	 Q5RJGQUtGz9pyczVx2FaIfB1CsBiKvmXgcF6vOJl5a3zLsVSofRXQU/w2THGUrvHUlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BbhT7cBm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 649EE606A31C;
	Wed, 18 Nov 2026 21:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BbhT7cBm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1A281F000C4;
	Wed, 18 Nov 2026 21:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038776;
	bh=JUJyXUYXBFUwfTaqdNByhH3/PIGicCor0OOPLVD9NHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BbhT7cBmcffSE9sGqTy4GerRO0YDrUnh5lrYUvydKBxL8dDZAaYJxZGrcPOoSq9G7
	 lubXV99ncgBH1qBEGDAuU+Nz12i9EF5l0pw+hIvNC2pai22G/4Q0zJKzGeCZP9svJ5
	 w6y4zhmkgnqkzjGyUBIjd76Remj25WROFRPcKqQc=
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
Subject: [PATCH 6.6 1862/3318] 9p/xen: drain response work after unbinding IRQ
Date: Wed, 18 Nov 2026 15:41:24 +0100
Message-ID: <20261118150417.773478068@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ee5bbdf7dec25..fbf8e6598f273 100644
--- a/net/9p/trans_xen.c
+++ b/net/9p/trans_xen.c
@@ -289,12 +289,12 @@ static void xen_9pfs_front_free(struct xen_9pfs_front_priv *priv)
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




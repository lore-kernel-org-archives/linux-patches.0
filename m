Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047578;
	b=TyYu/QQ6LA3PMUUAbISIkDq9H65TgN1GXllndHm3NXorKdA+1AJMCR1B3NKGdmpli3mW
	 F8C2YLx9TM2zRqROXLKXQ6ubi4oisR0JTD0nrZ/lXWOJHCg5Uy4pW28NRDHV4VeTnxSQW
	 wRDrGHuTUXSf/6Jx0B8BHJTYNPBdvZCAUGzvDiXNjAIzQIFwG86TxYqviW9JFt0VN2/A2
	 Pxi8D7s//u4E7epQrFIK6YWRFC45P90XXtaalVJR9gYGC9BMoBziAPFiFtk+Rsj4SZhPL
	 9PtNpPnPCgG9XJoEehAtlStJZy0hxWLROUpxIqfV7OER1CE2GRjuYPgP4fup5DBToKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047578;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=c6IfWcO6QQo4laWRthLgngxT36TIx8qZRUNuzUtn5DA=;
	b=FodB8kHUjHvAuX6QU+NwAfr55PzjJ1SAdMi1NkSAjlucyBCaL9R81IjsyrbJk9l3q/Ic
	 7gNwOTBky8UCrNNLX25HZWf9Xpn0hpmAlLLX0XxXBu4vqLE2KzVo3O7XJhfQyl13UZhzG
	 PV1KVGDb1nDnnQ1BkYKVGN+/MFVZy6l9oniY6jbmADLUIEwlCmszNU/Lx+0dWCbKyZi2a
	 mX97FunyvhPxHfBPjVGv6LbZmeoufdiGLpmZuPoxdXdZuy86BLyM+RfJJ0m4e+iZ21G+/
	 xvolE6iWG6JcyRqhcA8pFvKuSju6HNGApmt+BxSfwBThF1Q5vP1YmQMe25BAtaI9rAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gjr59uWB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD3B0606A325;
	Thu, 19 Nov 2026 00:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gjr59uWB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B08B1F000C4;
	Thu, 19 Nov 2026 00:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047578;
	bh=c6IfWcO6QQo4laWRthLgngxT36TIx8qZRUNuzUtn5DA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gjr59uWBaCS2YFYlrVO5hrfG7C2iS4fymh+LI+KPE6zDp0YKIfzkkFIsk90NXohpq
	 +xcW8baczwzUwVL5/i4GtJvdmkJrAtO4ZZ0M1uAm7olQmwXZo0iNt/HA7yvMM4C2/x
	 AzIWaLZJEAyDeB5dmudrKzjweB8u2r238puvMMD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Wang <jasowangio@gmail.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Cong Zhang <cong.zhang@oss.qualcomm.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1682/2857] virtio_blk: use synchronous quiesce in virtblk_freeze_priv()
Date: Wed, 18 Nov 2026 15:45:16 +0100
Message-ID: <20261118150301.893506552@linuxfoundation.org>
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

From: Cong Zhang <cong.zhang@oss.qualcomm.com>

[ Upstream commit 6c6dec7883f8eb10b326bc9d109a4990c885d949 ]

blk_mq_run_work_fn() can call blk_mq_sched_dispatch_requests() through
blk_mq_run_dispatch_ops(). The dispatcher checks QUEUE_FLAG_QUIESCED
while the flag is clear. It can then be preempted before it gets a
request. At that time, it has no queue usage reference, so
blk_mq_freeze_queue() does not wait for it.

virtblk_freeze_priv() then calls blk_mq_quiesce_queue_nowait() and
blk_mq_unfreeze_queue(). A new request can enter the queue. The old
dispatcher can run again, use its old flag check, get the new request,
and call virtio_queue_rq(). At the same time, virtblk_freeze_priv() can
reset the device, delete the virtqueues, and free vblk->vqs. The old
dispatcher can then use a deleted virtqueue or a NULL vblk->vqs, and the
kernel can crash.

Fix this by using blk_mq_quiesce_queue(), which waits for dispatch code
that was already running. Keep the existing freeze and unfreeze order.
The queue remains quiesced until virtblk_restore_priv() calls
blk_mq_unquiesce_queue().

Fixes: 7678abee0867 ("virtio-blk: don't keep queue frozen during system suspend")
Cc: stable@vger.kernel.org
Acked-by: Jason Wang <jasowangio@gmail.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Cong Zhang <cong.zhang@oss.qualcomm.com>
Link: https://lore.kernel.org/20260911-virtblk_sync_quiesce-v1-1-a883f8f31258@oss.qualcomm.com
Link: https://patch.msgid.link/20261103-virtblk_sync_quiesce-v3-1-f40233f9bdd9@oss.qualcomm.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[ sashal: adjusted context to virtblk_freeze(), where freeze/unfreeze calls do not use memflags ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/virtio_blk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 0ba56caa41eff..4e43de5724108 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -1205,7 +1205,7 @@ static int virtblk_freeze(struct virtio_device *vdev)
 
 	/* Ensure no requests in virtqueues before deleting vqs. */
 	blk_mq_freeze_queue(q);
-	blk_mq_quiesce_queue_nowait(q);
+	blk_mq_quiesce_queue(q);
 	blk_mq_unfreeze_queue(q);
 
 	/* Ensure we don't receive any more interrupts */
-- 
2.53.0




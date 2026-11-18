Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028733;
	b=wTvLfdMbTjAMt/Mny5O/T7Uypqa5ruGdS2a5YhUUGkZRtxui4bhgu1Aeso+kk31WDUOx
	 c7ccJklIH9/K2jWQDujLcG+vWp0d7kUiUXiG4t7O8eL/3DAKW43FkVDJv3nIhXB092QrM
	 +eY/GivgjclxXfZQQUsES3DvIbAUXNhc10zQlnODT7nqdBNg6FkKY+ON3XjnPxA/fhJwO
	 jh7a/nQ4600u66UNRqrFl3SSrXHivhCsudTag9wHqrUa4LUqIjyz6fw5dZR2gg3B2Qn4q
	 /Qv2dqSiGXPN65WFEvySEcH6s0A9a8CzxqZ4PesAsx8BgWt4DrBBBFHHKw74P6UIQsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028733;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ETWknMUyWrPw857osDMJNqvlD3o9BRzHGr1tFPxhWxQ=;
	b=zQB735MbIIhYZ+WUUF8NVpgQwztgBUx/1bdIYah9dY1JqzknOX6rihfaWdfFWkxNM4Wl
	 OkECzr8GSVKimumAcv8LHW3ifL9ViEY7Nm6bqWKPq53gkxarXTe0AwWfVcC4tZekRGJXm
	 VxFkSrClbuQnAEO4u4hUJS6g6H6uNZj0OiAiRmqPRB0t//LA6aqRZDnWs/yxHpBCzwvak
	 3Q1A71uUJxqBCQW4V1A0E3duHfndsrdw8TzzUqqkVtO6x9Pe1yrdnASss4lisahlDxhcy
	 3BDFLBmF9H7sFUc/vGvdXhisH8UVlTFE2IjYK8DjX0hLTQH85qi6cktpJKjQztAXbeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QMSdLori;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C46B606A33B;
	Wed, 18 Nov 2026 19:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QMSdLori
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F8681F000C4;
	Wed, 18 Nov 2026 19:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028732;
	bh=ETWknMUyWrPw857osDMJNqvlD3o9BRzHGr1tFPxhWxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QMSdLoriXFSG4bvV88JnByoJFGgCJdN4u19U/JH5gzkJuazLwBhznI98dHSQlRBDA
	 GwnN6ntOZNGNmjtO4eYu+Rx46Ux+ltxxJNVhIVM3azLQse7roMiUzPhmcLeyevmiO5
	 euvtUuHD5QcX4v9Nfgyc1Z4VpL8XvftcJDS98Ovg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Wang <jasowangio@gmail.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Cong Zhang <cong.zhang@oss.qualcomm.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0099/1756] virtio_blk: use synchronous quiesce in virtblk_freeze_priv()
Date: Wed, 18 Nov 2026 15:37:06 +0100
Message-ID: <20261118150012.181146543@linuxfoundation.org>
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
[ sashal: Adjusted context from virtblk_freeze_priv() to virtblk_freeze() with older freeze/unfreeze signatures lacking memflags. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/virtio_blk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 789890f3c5ff4..43884773dc3a8 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -1590,7 +1590,7 @@ static int virtblk_freeze(struct virtio_device *vdev)
 
 	/* Ensure no requests in virtqueues before deleting vqs. */
 	blk_mq_freeze_queue(q);
-	blk_mq_quiesce_queue_nowait(q);
+	blk_mq_quiesce_queue(q);
 	blk_mq_unfreeze_queue(q);
 
 	/* Ensure we don't receive any more interrupts */
-- 
2.53.0




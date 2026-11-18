Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054466;
	b=Hf14YXFxtYq1FE+bmhAbNEfFJl7HED71MMgL//m3KOq0yoiBdDGrRjfa7Za2hG5hbPDe
	 X2nNm+llgdY/45kn8EJSJU9kgeVc1vsufMxjDQOQNP8Ye2Zt0Tq2Y/jvNGmpGM3676/s2
	 AUzUY7UWhoCsnWmhc3DtT5RGOOJ9YO+9DrhdriC22xVjQpw4KEM3nli1CuOA2rmHKcB2f
	 bOipWvgaoKihL1L/fQnQoZBPvcqySjzhr9tB6zLVoC9jvQamiGhCq+mxGzyMU2oQuA4p4
	 +DITDXXrxERiwjdHfM8Au/nzqjz4/6DJoQy6RkfoLZiUSSuu+RtUg+Jc/b3V085LrDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054466;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RMNGbwZA/s7oVkxbHv9fUdWxKkR179okS5bzMB/ckIw=;
	b=zV0MPtsKRrkvn/EpWeG29TgC5a5F+NCYP4lHI0CnQ/kcPIENwYkXW4Gb9Q/rG4735HS1
	 nV4EsAYEi8DBb5WUcx4nVsSoV7LyJOSj51zTiYL1eIzsoBja57bD7XsKt2tccXJbmOYbH
	 mHqPnkqfb3MGwafCDz5qvEUOorSYbL1JtY8rNnRoNTKlS9oIlly4RE9qyuH1Ka6Cs2hOv
	 ffjKsCbo0H26PishNC23vKUtf7xK8ZtHmPVi3t8zJ5lgegqPWy/wdmnZSPp0r6MVzsMFM
	 fmVSBVxTBe3dSz8e0AV8Y60EKPhWqB5yIOZ62mM+LM98ZSuNmbnKIJLOTQSybO6mX9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2Q0AZdBd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E6C9606A325;
	Thu, 19 Nov 2026 02:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2Q0AZdBd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFCAF1F000C4;
	Thu, 19 Nov 2026 02:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054466;
	bh=RMNGbwZA/s7oVkxbHv9fUdWxKkR179okS5bzMB/ckIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2Q0AZdBdXu3xL78rg/Ih14+Dezkhemg2HpnYOCjVtpNlChPgwDBm35rAvcTG1tdl2
	 2VbX7IUHt/9DebGZc+n6c7tBfE9CepmyVqnwgjG4Szy0TrzvVhgzyhYisMjw8botD9
	 xlGwbvpv3jhitMJvovEdbmUUAhJ1KM4D3TRzHAEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Wang <jasowangio@gmail.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Cong Zhang <cong.zhang@oss.qualcomm.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1283/2214] virtio_blk: use synchronous quiesce in virtblk_freeze_priv()
Date: Wed, 18 Nov 2026 15:49:19 +0100
Message-ID: <20261118150102.914384638@linuxfoundation.org>
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
[ sashal: adjusted context to virtblk_freeze() with queue freeze/unfreeze calls that do not use memflags ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/virtio_blk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index c1087dfa332e6..9fb35af3f9fc9 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -992,7 +992,7 @@ static int virtblk_freeze(struct virtio_device *vdev)
 
 	/* Ensure no requests in virtqueues before deleting vqs. */
 	blk_mq_freeze_queue(q);
-	blk_mq_quiesce_queue_nowait(q);
+	blk_mq_quiesce_queue(q);
 	blk_mq_unfreeze_queue(q);
 
 	/* Ensure we don't receive any more interrupts */
-- 
2.53.0




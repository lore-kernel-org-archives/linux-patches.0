Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039009;
	b=CwQVelGpm500SqK7WebssD4Xjvrn883OIKCrl19845vHikwhP1yPHiO2w/w0XwMKdll3
	 4XrpxMUErZlbfdZdXNi5+LGSIQkusAjkkSW9dBm8XdT2IkWzSHiuG8B6SxQHHFB0TX6QL
	 Q/ZlRE+NMtQHzq5I1XGKivYsiRqdXQQ1cp+miBgH+JVZmmoZHwCdk4Ja4U/VTcRmlKDAs
	 dtSHkPEVo7+O4k4rMTgP2AVP1+YEG1dckOAJVo87IJAbDKeof4YZ1QG0YIkm4wpJtVP5m
	 8b3EfXT+Ps8N6FoplOc1fab8D6ozZ7+BqMVT5joUVX7ENYhWRwB0kp5ph0oRLgykhmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039009;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VBhJ3yfEPMK3s98LjOHgTNic6UVsbiRslqbUyJUNeDs=;
	b=QpHOvEGa3TYz1fiaDyU7jyoBBWOK1kpB02aVC0NAJWuohtXIlwdmoKSdIPfT1cuNBwpe
	 NVhV9Eg31Dk1qxacEaf4UYoGMD4CLzHl0dHGTM6WWru0IF6N/0zn3MGCUd4ThCiybxQMt
	 zt1cvwgRSfKjn6GcWHBpyU1yw8lkBEPh+RPXc3aojF8XbOflK5Fv4Hw7EBNv2o9FIBng6
	 eodWD6xlAtTH0XWKMAqS2zAgMJysge7Plb65IIA/JWCN2JVS02dWdCNfHaPk4cens4OVD
	 4PMU7YLxhFEHGl2omx0GK/zQrofWXygfkBb2cbPhfko6Eh6EeZcrurgsV0gvToMRmAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Nm6WKiFo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4D52606A332;
	Wed, 18 Nov 2026 21:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Nm6WKiFo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22D361F000C7;
	Wed, 18 Nov 2026 21:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039009;
	bh=VBhJ3yfEPMK3s98LjOHgTNic6UVsbiRslqbUyJUNeDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nm6WKiFoPoumF8p4srT+iVa3tbKBt04cRY0mv6KJ7PsDVY24KSDJPKJ/6hzZvvJgH
	 jwxFTWeEC2M19xVFRRWDTuNPEYu2l+9KTuJ8Zhh42on7qmbAYStjHZH6qs5Jq/sUJI
	 ZhwGNYzAZE/ClM1iVFbIRiF50T5QiEDsmS8fefD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Wang <jasowangio@gmail.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Cong Zhang <cong.zhang@oss.qualcomm.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1946/3318] virtio_blk: use synchronous quiesce in virtblk_freeze_priv()
Date: Wed, 18 Nov 2026 15:42:48 +0100
Message-ID: <20261118150420.436695056@linuxfoundation.org>
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
[ sashal: adapted the change to virtblk_freeze(), where queue freeze/unfreeze calls do not use memflags ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/virtio_blk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 65a1f1576e55f..1aeb44304f37a 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -1628,7 +1628,7 @@ static int virtblk_freeze(struct virtio_device *vdev)
 
 	/* Ensure no requests in virtqueues before deleting vqs. */
 	blk_mq_freeze_queue(q);
-	blk_mq_quiesce_queue_nowait(q);
+	blk_mq_quiesce_queue(q);
 	blk_mq_unfreeze_queue(q);
 
 	/* Ensure we don't receive any more interrupts */
-- 
2.53.0




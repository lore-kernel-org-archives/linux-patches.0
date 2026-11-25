Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618368;
	b=kAgWVQQgKTmzfB/FIrCEh8VsS6b1o+iIjU/KB8AkZuF7W+gbo1K6p/zLbQUDbnXuRZKf
	 UIqsWPaIFGSXLWodp1ho+o7QqGkk/YcLy9jx3tK1pHkJkdacSjBPjarcl2qxVY4iyuBm/
	 iLh5GgmwGkqxoCAsNXLHBQt2Dh61Ox9lK7Da6uxvCF/djj0meOtdiaBfdTgmt8tfLFxqy
	 N/xLZ79Hi6Ji82/HEjeb0aNg4jL4B6KvxVBkOzKhYyTkAcPQmKz/UcQZt83dmCVkwVie8
	 pau1QBQPxInrGRFI7XGZBAjTq6DviET9ib3ZgNxwCluH7oGZ09NRQuOg++uLLu3a8cg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618368;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GzT3XDz070Uw9QUKqYhhA29CHF24YwwHCXmBAe7KPIA=;
	b=BC7MxPBq7yLNQU5ys08wDH9ZhrUwnPuaUYQkoh8VeHGiYE10p+UGsPSSFsdOFFf7Qn4X
	 1cmu1leMH4kcvUBMNQQj7TyB/T+iqhiMpxMuW8bbNvRg9qSpY0sJSawdE+Mp6AClts9pH
	 vbFgkgXyKnAJoifPJceND2nDWmb4wXW82g5zXoHgukh2KbvJD4itJkESKwQnP03yxADuc
	 bNlmfv++NwUeuYG7sNE7FTbe2Zi4sQsd+uAzB/uoSEr5eomMx3vHVEKRMg+S/+/i/1YFa
	 sMSlEWBVc0lyeFXeS75Frqu2eyyl7XTgfBH2WFVEQc5aNPu7SbruB7Z9f5JY9+SYfUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RkvNk6hQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15C77606A323;
	Wed, 25 Nov 2026 14:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RkvNk6hQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BDF41F000D1;
	Wed, 25 Nov 2026 14:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618367;
	bh=GzT3XDz070Uw9QUKqYhhA29CHF24YwwHCXmBAe7KPIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RkvNk6hQExSuMVDHjW3NHNBXl6ePaW/Ta2iPX2qBmWnQ9G7FJx1vT/Xfo8gtEatTc
	 8a08euU/zP07WYFzkO5gu1SI+dhN+sL2UvMt1DKZhLBuxW70dpy6Cn+0tp62gZgcjP
	 brqXBEdEQ+f3wtH+78lf+eBfHdHk72qI3p8ADypk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Hannes Reinecke <hare@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0256/1005] nvmet-tcp: ask for the TLS record type on every receive
Date: Wed, 25 Nov 2026 15:26:34 +0100
Message-ID: <20261125143827.736362748@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 77f72de389e3774dc95d7cd03a98a73e47013abd ]

nvmet_tcp_alloc_cmd() points recv_msg.msg_control at recv_cbuf once.
The first receive that stores a record type there advances msg_control
and leaves msg_controllen at 0 for the lifetime of the command. From
then on nvmet_tcp_try_recv_data() sees the record type of that first
receive: if it was an alert, all later data is dropped as alerts and the
queue stalls, if it was data, a later alert can't be reported and
tls_sw_recvmsg() fails with -EIO.

Set up the control buffer before each receive, like the other receive
paths do.

Fixes: a1c5dd8355b1 ("nvmet-tcp: control messages for recvmsg()")
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/tcp.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index 85a10679d0a93..8287f19741e80 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -1302,6 +1302,11 @@ static int nvmet_tcp_try_recv_data(struct nvmet_tcp_queue *queue)
 	int len, ret;
 
 	while (msg_data_left(&cmd->recv_msg)) {
+		if (queue->tls_pskid) {
+			/* The last receive has used it up */
+			cmd->recv_msg.msg_control = cmd->recv_cbuf;
+			cmd->recv_msg.msg_controllen = sizeof(cmd->recv_cbuf);
+		}
 		len = sock_recvmsg(cmd->queue->sock, &cmd->recv_msg,
 			cmd->recv_msg.msg_flags);
 		if (len <= 0)
-- 
2.53.0




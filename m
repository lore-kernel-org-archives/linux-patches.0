Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624458;
	b=B+niVl6XciBBNdUNZkUUqpG+LQ2zhm6jk0JTvU1PzYaHf5JL3J1CvKoMeXhUEYLzbBId
	 lgDNtC26aY6aBJYC+JQLqWW/ObkWlT4rnn8Yy1Mw5A2MHsFAUJVlWPjYS46G4KS+ss8x1
	 oDd9WpKB3IFjBk+bmtbx/3CPQGE0QsHXNxi+USmNrNDKdh8BIbRbMixVbQdQtQTaBoDPj
	 Qd94fi66E6LrHpJfhM5CzlOhFLTmQhsBP5I1qv5HhnH0z2a+FC1VR0U/lz/xLbeF9yB1j
	 5GtQiSS38ZJgQZ9UUBai8EXIRa+ZpisSX/l5cRI9egX4bU5D6iYuTAQXX4LfaZdy+tg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624458;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UFuL5I+u7upz5JOcm4e2F3fddf0JHbttEoqwREmA32g=;
	b=FcpZmcflhoR+wJM03DXBbMMEdHpuZJeQ0cEWS9iaxjmP97DbipYOxt4EgzcZv4sGtlhs
	 DywirMnzkNcjyZeuOhtxQ8zWQ/yx5ky7uiRvs2+4MGVq9j76+wSbDZfycBooUhPQDCzaM
	 CTvA7eTroybD2aK2Pz8KEuAXEZ5XlcDlnc7bYEss6ZdMkuBdb8TGsmwnY2ru/rQ9T+r0D
	 8bMCDZlaxUYrxIzazcH8vwFhbzI/I2WSIfkl7F0vQXuo+avnuFBk348+nTMHAENP5fq6D
	 FMRB6zYnorODsz2qCTcU9nTt6CsOr7hhazh/Wuc5kDJkV4wP2G2uDZVxV+yfFQmA/Vw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LKPWCLtn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 583A2606A33C;
	Wed, 25 Nov 2026 16:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LKPWCLtn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF0DA1F000C4;
	Wed, 25 Nov 2026 16:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624458;
	bh=UFuL5I+u7upz5JOcm4e2F3fddf0JHbttEoqwREmA32g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LKPWCLtnw1R8VdfU99m0B1H3SL6uCRtIwHk+71A5W5GN7EAJ2788mysskYYDt1qOF
	 QJ+E45QxH/xpRgV0RY3xC2y2PyAwF4HYeYIN6twfIMov28D2x+QhFpG3SMExHYU6XU
	 DKgyBnddnfUvQ/njNeakvuIMUf0LKDZ3VfopdcfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Chris Mason <mason@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 199/816] nvmet-rdma: disconnect a queue on device removal
Date: Wed, 25 Nov 2026 15:29:07 +0100
Message-ID: <20261125143853.799128291@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Chris Mason <mason@kernel.org>

[ Upstream commit a4387799d4228866dc1746b466cd17e1c638d050 ]

cma_remove_one() sends DEVICE_REMOVAL to the owner of every cm_id on
the device and then waits, without timeout, until they're all
destroyed. nvmet_rdma_device_removal() does nothing for a queue cm_id
and leaves the queues to nvmet_rdma_remove_one(), which only works if
that runs first. As a module it does, nvmet-rdma registers after
rdma_cm. Built in, both register at the same initcall level and
drivers/Makefile lists nvme/ ahead of infiniband/, so cma_remove_one()
runs first and waits for cm_ids that only the later callback would
destroy. Since the RDMA CM drops all later events for a cm_id once it
has sent DEVICE_REMOVAL, a peer closing its connection doesn't help
either. One connection from anyone who can reach the port hangs "rdma
link delete" until something else ends the queue.

Call nvmet_rdma_queue_disconnect() for the queue. It unlists the queue
and queues the release work, which destroys the cm_id. Don't wait for
it, rdma_destroy_id() waits for the handler to return, which was the
deadlock before commit f1d4ef7d8883.

Fixes: f1d4ef7d8883 ("nvmet-rdma: register ib_client to not deadlock in device removal")
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/rdma.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
index 970452397b5d5..079342828173a 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -1777,10 +1777,13 @@ static void nvmet_rdma_queue_connect_fail(struct rdma_cm_id *cm_id,
  * queue cm_id and/or a device bound listener cm_id (where in this
  * case queue will be null).
  *
- * We registered an ib_client to handle device removal for queues,
- * so we only need to handle the listening port cm_ids. In this case
- * we nullify the priv to prevent double cm_id destruction and destroying
- * the cm_id implicitly by returning a non-zero rc to the callout.
+ * The RDMA CM waits until each cm_id of the device is destroyed, so a queue
+ * has to go now. Our ib_client also removes the queues, but it cannot be
+ * relied on here: built in, it is called after the RDMA CM's client.
+ *
+ * For a listening port cm_id we nullify the priv to prevent double cm_id
+ * destruction and destroying the cm_id implicitly by returning a non-zero
+ * rc to the callout.
  */
 static int nvmet_rdma_device_removal(struct rdma_cm_id *cm_id,
 		struct nvmet_rdma_queue *queue)
@@ -1788,11 +1791,7 @@ static int nvmet_rdma_device_removal(struct rdma_cm_id *cm_id,
 	struct nvmet_rdma_port *port;
 
 	if (queue) {
-		/*
-		 * This is a queue cm_id. we have registered
-		 * an ib_client to handle queues removal
-		 * so don't interfere and just return.
-		 */
+		nvmet_rdma_queue_disconnect(queue);
 		return 0;
 	}
 
-- 
2.53.0




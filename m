Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705230;
	b=gp1+FS3i0rq/sB5/gTEIt2puSGGHfHMG84LHBQoLLoQ9/D1P/+vNVgMsbIkMzo6SObDF
	 b+Im5quO2+c4P5QpbgdmVMwv9R9VUjZIy0Zf4ORIS5eAJ8giy5L9RfRFlEtVfOlumJS6N
	 aBi11cmRZU+Wre77pGoLAY8se/YHhTFwNa2uhJRKxf5pQ8r6hJKFcJ2HXXSmSMNQZ8P05
	 gY3IkqXZCrV3B1BfM8erBCdmQ2xeuxtaU4X5DWcjQYcYiyQmvX991pb5k9Ab7IvWq4c6y
	 YJ2rblgRSU600B2aAHaqhK9dOm3qPe8bWpw1d0oR3/uS7MTkRxc6C/682xzDsGGNQUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705230;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vxXu2W3Ga9bxphVaiXcHWtGcUhBZvNixZKHcExxm2i4=;
	b=awvosPNU4Bk8tywitlfsAp+Hyx61lS4s7OLdd+rG1h3U/GrtUdRzZXqFiBf1V64VnoVX
	 XGbaKLXf9BOERY2AV3FsR7SNAnnoQnGxZRgPypH+z3Ki2p3RUVg5tweeP5fzqd6Tc7pX4
	 3Ss1YxN37jD9xYatVidZosBZPB40jJ0NZ0iIFI2mYEu/prELInj+moyCk4MfNzPcp/9UN
	 flGw+K5qJETskWQaS9HLg/UQQ3sdWlV6w+eq3hYYbV/Qm/NWsWdcyKl3DDeuTGQMBUIly
	 q0ckFCzYiyYZiti6eItro1j3etWu9plg6WJOTl25mT6w+8NOR6aXOQmx9KXQivOdN4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EArBdQgK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3996D606A32E;
	Thu, 26 Nov 2026 15:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EArBdQgK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9794F1F000C0;
	Thu, 26 Nov 2026 15:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705230;
	bh=vxXu2W3Ga9bxphVaiXcHWtGcUhBZvNixZKHcExxm2i4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EArBdQgKrST8AezXF7V5Wzuj2uhGAGnuO0R/CdjdWkm7xqja7vUa6h3Mmxv2NXUfZ
	 4Cmr7crz3/BwVKPycGTv13Q1GhAM/g/54lVZRx7hIrP+10tgcvymQaslmLCnJDX62r
	 m8pkQEr+4s68WzPr8P7qaJ4j08WmMvAZQTGrZDDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Wagner <dwagner@suse.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 083/319] nvme-tcp: handle number of queue changes
Date: Thu, 26 Nov 2026 15:37:31 +0100
Message-ID: <20261126144008.616317336@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

From: Daniel Wagner <dwagner@suse.de>

[ Upstream commit 09035f86496d8dea7a05a07f6dcb8083c0a3d885 ]

On reconnect, the number of queues might have changed.

In the case where we have more queues available than previously we try
to access queues which are not initialized yet.

The other case where we have less queues than previously, the
connection attempt will fail because the target doesn't support the
old number of queues and we end up in a reconnect loop.

Thus, only start queues which are currently present in the tagset
limited by the number of available queues. Then we update the tagset
and we can start any new queue.

Signed-off-by: Daniel Wagner <dwagner@suse.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Stable-dep-of: a4387799d422 ("nvmet-rdma: disconnect a queue on device removal")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/tcp.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 6a5d21d3e14f7..145318b7f5846 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -1794,11 +1794,12 @@ static void nvme_tcp_stop_io_queues(struct nvme_ctrl *ctrl)
 		nvme_tcp_wait_queue(ctrl, i);
 }
 
-static int nvme_tcp_start_io_queues(struct nvme_ctrl *ctrl)
+static int nvme_tcp_start_io_queues(struct nvme_ctrl *ctrl,
+				    int first, int last)
 {
 	int i, ret = 0;
 
-	for (i = 1; i < ctrl->queue_count; i++) {
+	for (i = first; i < last; i++) {
 		ret = nvme_tcp_start_queue(ctrl, i);
 		if (ret)
 			goto out_stop_queues;
@@ -1807,7 +1808,7 @@ static int nvme_tcp_start_io_queues(struct nvme_ctrl *ctrl)
 	return 0;
 
 out_stop_queues:
-	for (i--; i >= 1; i--)
+	for (i--; i >= first; i--)
 		nvme_tcp_stop_queue(ctrl, i);
 	return ret;
 }
@@ -1934,7 +1935,7 @@ static void nvme_tcp_destroy_io_queues(struct nvme_ctrl *ctrl, bool remove)
 
 static int nvme_tcp_configure_io_queues(struct nvme_ctrl *ctrl, bool new)
 {
-	int ret;
+	int ret, nr_queues;
 
 	ret = nvme_tcp_alloc_io_queues(ctrl);
 	if (ret)
@@ -1954,7 +1955,13 @@ static int nvme_tcp_configure_io_queues(struct nvme_ctrl *ctrl, bool new)
 		}
 	}
 
-	ret = nvme_tcp_start_io_queues(ctrl);
+	/*
+	 * Only start IO queues for which we have allocated the tagset
+	 * and limitted it to the available queues. On reconnects, the
+	 * queue number might have changed.
+	 */
+	nr_queues = min(ctrl->tagset->nr_hw_queues + 1, ctrl->queue_count);
+	ret = nvme_tcp_start_io_queues(ctrl, 1, nr_queues);
 	if (ret)
 		goto out_cleanup_connect_q;
 
@@ -1976,6 +1983,15 @@ static int nvme_tcp_configure_io_queues(struct nvme_ctrl *ctrl, bool new)
 		nvme_unfreeze(ctrl);
 	}
 
+	/*
+	 * If the number of queues has increased (reconnect case)
+	 * start all new queues now.
+	 */
+	ret = nvme_tcp_start_io_queues(ctrl, nr_queues,
+				       ctrl->tagset->nr_hw_queues + 1);
+	if (ret)
+		goto out_wait_freeze_timed_out;
+
 	return 0;
 
 out_wait_freeze_timed_out:
-- 
2.53.0




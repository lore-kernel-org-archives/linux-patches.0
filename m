Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618378;
	b=o11woP1+oK0Sr6bBn7Bh3Nr6+GAw8VJpsMJFeLY0qmoF3Kr1t1LQ4G/ZPzffZN21Hylq
	 1mCasCdL+SjEI2xe98cavWN8G3s1hpQLlzi68WBFr0P63ayMvGcwQJ6fSpmRNHA0qterV
	 vNbfgbQwKt4rs7M7p8+EdCbvVfwQUr65PA5Lr9pCJ3b5ujKJe8jLEDHIhBgUzAyEZ9uEA
	 u0aopikGyGIVTCgg7v65Nt74qO9Qt53KjKPZs4jn4vneRoiCAcUumgC7kQm0RGcr1yLj5
	 24SfCQuI6BYiss5sKqkelLJc9pVvN3ItyUuKPppZdscCctxGZFJc4CAy+xAxwLF0Dag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618378;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=B6ueqrnDWNZYiN70AH+FVnQPaGdmZ0RqDj5qUJ+sK+k=;
	b=um/CyehmZLIX+y9nWitWToMH5ifZbM0PNxNIfDF4usBzEcrdOFA30637GxvGo+2uil1r
	 yiv3L7nwfMrvgW+NfYngtdi5Y2HCy/NHiB41M3gwHcoqGGApVTmBUOHWJGlNQlbYUMewr
	 X9YytNrgramSkeGlaA/3ABZY+Qofzu6AQQLwD4d1kx1BddJBmFt7kCBF5Qqmg9NlHxiPM
	 SFsPlJ0zG+J0WDiT1mW/iJTXI13BXAKJu3UFh29y4QuGs4GOQoMHRQdO11E5fMTwsXV0E
	 aQ7iRynTpwcWNBrmTN4+hPrDUZDrE4A2sXgKkhWUod0GgayBIcE5nXXvrGfb48BRBkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ey8XD0QU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E4A0606A335;
	Wed, 25 Nov 2026 14:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ey8XD0QU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F9B51F000D2;
	Wed, 25 Nov 2026 14:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618377;
	bh=B6ueqrnDWNZYiN70AH+FVnQPaGdmZ0RqDj5qUJ+sK+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ey8XD0QUbXDptZ7CQt53URw2essNOPz5wjmNLT+I5UJhpf8nHTbTIbHWSZAgx4UbL
	 uq8MBwAmryrMXD72XwYIY8whsW6bn1g6Le4kSxt/wyV8/21wlk2Vt2PF0tFGuzaU6Y
	 +/fZO6h/RLf8VbwLYgsDMVuBWykjvtRA6M0UMy7g=
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
Subject: [PATCH 7.3 0259/1005] nvmet-tcp: limit the connections accepted per work run
Date: Wed, 25 Nov 2026 15:26:37 +0100
Message-ID: <20261125143827.806887133@linuxfoundation.org>
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

[ Upstream commit a029f1b2fb13e6ac6e1c2f27fba1d80b6e7cac51 ]

nvmet_tcp_accept_work() loops until there's nothing left to accept, and
anyone opening and closing connections fast enough keeps it running
indefinitely, since tearing down a dead connection takes long enough for
more to arrive. Whoever flushes nvmet_wq waits for it: removing any
other port of the target does in nvmet_port_release(), and so does
unloading the rdma and fc modules.

Accept a bounded number of connections per run and requeue the work. A
flush doesn't wait for work queued behind it.

Fixes: 872d26a391da ("nvmet-tcp: add NVMe over TCP target driver")
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/tcp.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index 8287f19741e80..8788cfd813b8f 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -102,6 +102,7 @@ MODULE_PARM_DESC(tls_handshake_timeout,
 #define NVMET_TCP_RECV_BUDGET		8
 #define NVMET_TCP_SEND_BUDGET		8
 #define NVMET_TCP_IO_WORK_BUDGET	64
+#define NVMET_TCP_ACCEPT_BUDGET		16
 
 enum nvmet_tcp_send_state {
 	NVMET_TCP_SEND_DATA_PDU,
@@ -2073,9 +2074,9 @@ static void nvmet_tcp_accept_work(struct work_struct *w)
 	struct nvmet_tcp_port *port =
 		container_of(w, struct nvmet_tcp_port, accept_work);
 	struct socket *newsock;
-	int ret;
+	int ret, i;
 
-	while (true) {
+	for (i = 0; i < NVMET_TCP_ACCEPT_BUDGET; i++) {
 		ret = kernel_accept(port->sock, &newsock, O_NONBLOCK);
 		if (ret < 0) {
 			if (ret != -EAGAIN)
@@ -2084,6 +2085,9 @@ static void nvmet_tcp_accept_work(struct work_struct *w)
 		}
 		nvmet_tcp_alloc_queue(port, newsock);
 	}
+
+	/* There may be more. Come to an end for those who flush nvmet_wq. */
+	queue_work(nvmet_wq, &port->accept_work);
 }
 
 static void nvmet_tcp_listen_data_ready(struct sock *sk)
-- 
2.53.0




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062132;
	b=pOqf0OpDqcXXL1Wp58IDCWmahvp0K80x3a3lfeiXLAu8Q+8DE7h53P7Qhwm6rn+VOVOy
	 BEn9/QTpBRRYDBD6r975pDm8iOgWWnIYuJ1bqYWbeY1OFxFAtPvrMU4t1YvLbyuya2OzE
	 j0C3ogi+ueKIYVdIZ1byGk7L1F3lp0KxSyAVuU/XVxQWN8QfxFFbMIKmZP6sWPMBwgkSS
	 YSrlOXf0nz3PrgQOpVPqFwEEfhKJNXvcvxXqrKp2iLiF8ZyOqyd3S3g77y599i4Z7jyGE
	 7fGKFiYChpX7Xg9qE0guKQtJWJmqYrYRlH0akr284XvUpFEg0oL1AHWtT3HwVED64SA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062132;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mwMmnN9/UdyIV3AQKWt0vzwudEerYiHtjPl51r1r17c=;
	b=cOC0qV3tsTPC9SPq9f3L72+1Ke25KipESp3VNR4f7ZHdOFBEkwnACKyXW3Rd3+JFTxok
	 1y5YMQ208tKoUFHzYol2T8MieRxK2+dDtEQQSydRk5f0XUcHILe7M/wq8OQqvbWV6HHFL
	 IkNv4m2z6SbJz6oBKaLkVKBM6WsYjZ04WqkH3M5AshmN/lBCMFAC7kIrwBloxqPlOl2g1
	 C4u+1y1Eeh+CW4qnyG8koYQx8/aFQdPlLWFY4JtOobiR2O98TLxP58OHuSxHtoTvkgn98
	 Icp9zNMDWrKqeWGAJVdFHv2IE2o/KyGRu8YdOrDf3kH7N23wX7NLgr124JDHXMb3FTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="iFyhu/6G";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5E2A606A320;
	Thu, 19 Nov 2026 04:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iFyhu/6G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3708A1F000C4;
	Thu, 19 Nov 2026 04:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062132;
	bh=mwMmnN9/UdyIV3AQKWt0vzwudEerYiHtjPl51r1r17c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iFyhu/6Gfb/aOxnaiVQ5bhHoaMcPWn4IOwuPpNxJUuenfvZ1k1pAt/w7paNmwzSDX
	 lMuyEgZ6ADa54sZHHDKGD8YQ5Wk4wgZBt+obBTr4iNKLF3RECVhUOJt3JPTpG9/ZHb
	 0LZBI5vwMHbN4ZLIf43ALg23BU+b0s/rwda+i4n4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1801/1848] nvmet-tcp: stop listening when a port is removed
Date: Wed, 18 Nov 2026 16:03:59 +0100
Message-ID: <20261118150034.692760894@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit ece0f4e67f08792c8572080fb0fcc231554f08ca ]

nvmet_tcp_accept_work() accepts until there's nothing left. A
connection that is already dead when accepted is torn down right there,
which takes a few ms, and more can arrive meanwhile.
nvmet_tcp_remove_port() waits for the work with cancel_work_sync(), so
someone opening and closing connections in a loop keeps the removal from
finishing. It holds nvmet_config_sem for writing, so nothing can be
configured and no port answers a Connect until the flood stops. No
secret needed, just an admin removing the port at the wrong time.

Shut the listening socket down first. Pending connections are dropped,
as they were on release, and the next kernel_accept() fails and ends the
work.

Fixes: 872d26a391da ("nvmet-tcp: add NVMe over TCP target driver")
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/tcp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index 871aa40adf355..05a599f6c8d59 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -1827,6 +1827,8 @@ static void nvmet_tcp_remove_port(struct nvmet_port *nport)
 	port->sock->sk->sk_data_ready = port->data_ready;
 	port->sock->sk->sk_user_data = NULL;
 	write_unlock_bh(&port->sock->sk->sk_callback_lock);
+	/* The accept work goes on for as long as there is something to accept */
+	kernel_sock_shutdown(port->sock, SHUT_RDWR);
 	cancel_work_sync(&port->accept_work);
 	/*
 	 * Destroy the remaining queues, which are not belong to any
-- 
2.53.0




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033056;
	b=CQrQbToko+h4weOlwQ725REQX3TckpDEpr+g8eMBNX513f5btXDMBmFvOFP2PilNTRRq
	 3kLNgJTuE1s262UTNlPsyNJYjLt4CgAM1RBMV1n28ahgbRnY+Wv4eei8dju+kkSQsZHpm
	 sTSU7Y4pmdlpnzaQ51kr2pnqxfiUUOUQ/b0ZDZx/Zampp4EZ1TZ8ozpOyF0yCu9kEzDAv
	 ep4LoX+NTVpTntFhMJstkCXKEVrE1XaK5CYoCGk6NACtAAJeIh+ounSrUD9egJe6QfyOU
	 YW4FgxRCfTDilYqoxOb+SxCwti3a9e3Hwh+EKtIOofVw89kuL7ZC0vbzJL5GaS2l2sg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033056;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5/YYUVEjyHQ0f/LddWUZvfHALbrr7GbpyIFazjsi60o=;
	b=FovNLzCh7Svq1U+OvQWVs7lJCz8p3Zk8mflOSSX3Glg6i/gUmE/pIExhnnxJYWsn5WP6
	 urHhbi2bBNIlkgv54GHdGjqy8EqOU6I8oClwXYy0EPuAa8HxcYWTBBFw7l9QvxuRRMdO7
	 YOAoIapslkAnjRfcs8JvchTR0BE4hFQoUbf0MLPdFKS1qgTOQSqBCaZlbI9Z87ZkPWYas
	 snbxjijRfwf9OXXnVDmqaSyRn9CXGSqf2PKFTedwidp3esovQMVnkK7PbG+mZqx621+Qa
	 83AfBn68RWzk3pKBh5e0zpgCKHjWWd0pqOMDK60KOa2Wh4l0lpKxDj2SZ10ilPuWgzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tbZJLfAu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B852606A331;
	Wed, 18 Nov 2026 20:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tbZJLfAu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B19A71F000C5;
	Wed, 18 Nov 2026 20:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033056;
	bh=5/YYUVEjyHQ0f/LddWUZvfHALbrr7GbpyIFazjsi60o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tbZJLfAurhhXEbVb/kAB7E3dArqlT0SuqKur237tDQ+z9rkozuEVeqDc9kOHhucmq
	 xq0kUDCLDLpWMZj7mLb9idCf9SX9Ilu3yk5E+//eR9S1SrwLtYCsXTQCy/ahFq3jkq
	 4OvbjfuJc1JB1w9nwF4XKLzorVrUa0/aQn9ON7Cc=
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
Subject: [PATCH 6.12 1631/1756] nvmet-tcp: stop listening when a port is removed
Date: Wed, 18 Nov 2026 16:02:38 +0100
Message-ID: <20261118150114.722818845@linuxfoundation.org>
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
index fcb1a3dbff011..3c38646d97e44 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -2208,6 +2208,8 @@ static void nvmet_tcp_remove_port(struct nvmet_port *nport)
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




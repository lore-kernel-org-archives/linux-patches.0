Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050624;
	b=apR28svqQkpLL6TNjiRF8/Ph8aEX7DINeTATS7BP06I3DDpdkrmVV6MMc7og1JhX/1ir
	 ra0U501n1P9m+MA+/FVqROIN3cVLBQVGsaquREpUcg/Et8xrNI0OddsUFkx/mWGCZaiTq
	 yeKk/Q2gUsS41fSd7Fv2JnHRqiqQtwdgt04HcjiPnMF4XoGtrVnJ+ntL8D1EyaiokNNK4
	 ZrLrWZQG4bE4QmYXY3MfDLU0IJGkrqrXpRe/oxkOYAUYecZlMqrXQiUFvhQtx2StNMB9i
	 gILkm2Fk5qkV/MI0wpcnwoQzHc3xXQf3yhhcVM9ntwIxMhhY1f6vNI57e7bM/jHFJZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050624;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7xso5clcwdEqGhd/VCMeilXLQiCbdZzZCIbLcgrRatk=;
	b=rnfSZwdulxSuGWxFHGaP3QoSptLxNizNDVovOuwhGhR3O17XzptvciUVUYqy27c1gNTK
	 ndHeiZ5o9hpO4wN0+buP4RiQ1eSmI6OFVjFZAanFt8kYN3pPcfVbwxFQtnzMy3DjkdBR0
	 13XM7stu0yMGPpw+hXymyqjJ2po1gAZY+JM6JnGpVeWeuekb2wdSzdOiplB6ZMXHU4TgC
	 Hwg3Use3N0Iuq68nk/Gi2Rl06DUKJQU6DcPYHj/x00aEjuAIII1ZQejSbg/D7KHQ2avlJ
	 zytt2TG7abhuyjLtjbnwYvOJ5z2rIiWi1KgzmryG6hswjsAvmuK41FhF2S1PGm9ZjdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DGYSp4dm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75875606A325;
	Thu, 19 Nov 2026 01:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DGYSp4dm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D718E1F000C5;
	Thu, 19 Nov 2026 01:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050624;
	bh=7xso5clcwdEqGhd/VCMeilXLQiCbdZzZCIbLcgrRatk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DGYSp4dmoUWWOvrkxq2YugmF4aPfaWs4r2uhHiyeFr+7Z4qdnWnQHuRKB5QbdbCDU
	 nNLnhD/ZaEzWRH2chHFvEdGPxYqSxcNdbqGzdB+9SJEH3PfLUZdaINU7cMXZ3x5oL1
	 XLDXcwZMK1W9Ct/1RiHGKFdtj42dS/B3wK2qUnZ0=
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
Subject: [PATCH 6.1 2774/2857] nvmet-tcp: stop listening when a port is removed
Date: Wed, 18 Nov 2026 16:03:28 +0100
Message-ID: <20261118150341.482032326@linuxfoundation.org>
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
index 6ae2402327601..ae654bccfbd11 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -1891,6 +1891,8 @@ static void nvmet_tcp_remove_port(struct nvmet_port *nport)
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




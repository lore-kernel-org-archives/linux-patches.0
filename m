Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042571;
	b=QBTBR0/uR2k2MWpi9SHiAeEwuTa9bVJcCd2lKtIsnPZ/KcPV4cgI6khyetFOH3ii0X+d
	 TMdu8UTSsjYsSuBvZynW4uioNKtajm8M63e3n+aVaSKtG+8P43xfhZGpTD1QmJVKYQ651
	 ahAs4drfiq1RXSuUL6MePiGiYH+lLyEJq/xJR2aAOnumtoaQKC/vI1KGMXYSPJe+g0//g
	 RIfkPiVKGNQggqVSSIYSvquA+B3APpGvXCeZ9fV1hdm/dh6lw6WhLg2N4mbJdXUoyCPr7
	 PXQ2kC08SfLQTJe/b5fQlp7Qx2cCNzQjNpjpKGsC/UHmiE8FaraGd+CksW31QzSQUuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042571;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HnNUAZ66XH9anxzcJSTQD50/sIGi6XD7hawIxL/eOsg=;
	b=UdKzO74BfBVn5QgU+nmGhlSpYpV63IS3cfUqzfiwJe7fGDxZmcdpVbHuJncXq6pZ2l8t
	 KU8qvngGG0k9XnBGXF8Y1ut7EFPykTjLixyDsev+acFeAvFJaZr1JQ9/DT3yzNn9eB5g+
	 x/e2AmUYCCnHdr0ebw7XSAmYOxguyg2l1eA0sZV6iECnePWDY7zvxu1m6CssIhR/DCfYt
	 /u6oWMqpiCgsGcMdDtVSZwzuCH21tWcGViYwnAzuLIUh+/jx2yhAz4GXrY/XmvaW19iWu
	 QjPlKaMd9ypvxWbweqOvKj6z2IZCxHn+QmBXqAZi13/tV/arv62OwluLc6t2Q1zgHhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=msSqPIyy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F454606A320;
	Wed, 18 Nov 2026 22:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=msSqPIyy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E878E1F000C4;
	Wed, 18 Nov 2026 22:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042571;
	bh=HnNUAZ66XH9anxzcJSTQD50/sIGi6XD7hawIxL/eOsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=msSqPIyyKaT3nytUuSkxh1nFLVcKjdZfWA62hhZb/CxWEhZ/PQbjkQafXvl2WYu4m
	 ubvsFf1lTsqX9wAMtRtOAjqMGb+fWoK43Qp7nlHkkKnJXlyeNZBUmQgNQrcZ9SmycA
	 gei1lOLIY4DK8nDuN90kuuz/9BO1qjx9URqapxik=
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
Subject: [PATCH 6.6 3218/3318] nvmet-tcp: stop listening when a port is removed
Date: Wed, 18 Nov 2026 16:04:00 +0100
Message-ID: <20261118150456.277939420@linuxfoundation.org>
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
index 52a435499f9cb..8421768dbccc4 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -1939,6 +1939,8 @@ static void nvmet_tcp_remove_port(struct nvmet_port *nport)
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




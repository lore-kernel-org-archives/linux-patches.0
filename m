Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056911;
	b=dXJzyWCf+X4AMjF1TeSPZYHkJ6ahP0B72L17bEBLND9O4bOcanZq+GDUAUV6SbJaqZ85
	 idiHGxzE9aceTfoTv5aMVEtVbQK//fmG4ZOCrxWjQrwJ4I2hGr/16sNYQcO06uv//UleF
	 Cr/p7tXK8d0BpxKxn3PAx//c74IpT5Zab1cvw2UDZSijf3r0dHqciCFLyzL087XYdFJqX
	 x3HDpHEZeRnOKRiZUCnvh4dLzZkbFyX9M3csGFcjautZcXNW/9yeQbTz97jXt359DjP/A
	 i8Ss1zaI0laynqBLLO7pF8lRLsclboBOUwn7rNWUdHcdCDZ+4zhyIO70j562WcsU6gg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056911;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=srXYLPMiD/i9KdYkOUSk6o2LVOdIhBPQIqqAJEdLAsk=;
	b=vM3wB/BAMlVPKJsr4vFc3iKekWLzjiBMefzzv6B/dcjmRjxIroHtmusnQpM7FZoil3FF
	 bMdV2sQiaxLnQRfp0561e4yhePL3EXl8WkOPHB/9RlZ1z0jNK4s7oa7iuYl4FF4Y5t25e
	 LQM3R9TjR8CJqslbq1R/p4swzLj8FkO4qxVN0oAYyH0FXmWwpyqvWi+BuUtIWhDs+xZwg
	 SeGN9rtDTTjsghGqQaEB1i+H1fX1xS+VxlFeKzxgIr/42f+UwiB6ejEn7cjiwiZ1S3Jbx
	 VogSCqd22+mn6a5ndAoFy4C9C0qXCzkbUtXoqztkyfYMUwsqprsjxKsCvDwo762TiRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F9BGne16;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 063AE606A31C;
	Thu, 19 Nov 2026 02:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F9BGne16
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F2E31F000C4;
	Thu, 19 Nov 2026 02:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056910;
	bh=srXYLPMiD/i9KdYkOUSk6o2LVOdIhBPQIqqAJEdLAsk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F9BGne16YXpEosSiwEKZ1h/9tT5+6acyunHVlBHpLrmFCsjdOCavX23Lsuj28M+fP
	 J7QRH6+pQ9rDQeOUTMaZcJ71cTEHf3nk/10V2zem241CNpiR3bJ65VigvnkdHz8kOM
	 rQWQTJCfBfKZdiR2pJC2uO0QcqgAmlwmhwBhG/qw=
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
Subject: [PATCH 5.15 2155/2214] nvmet-tcp: stop listening when a port is removed
Date: Wed, 18 Nov 2026 16:03:51 +0100
Message-ID: <20261118150136.669343256@linuxfoundation.org>
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
index baabba09d0551..458f679b10532 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -1859,6 +1859,8 @@ static void nvmet_tcp_remove_port(struct nvmet_port *nport)
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




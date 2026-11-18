Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028117;
	b=sZWqlOvWW05TGZHTdzLb1Z+cn8qlcJym3biSndiZKi8VbqoaJGd2JMNf4/4pnWdqlm5D
	 H/uunipILGmuzHSM6PVcmsDbVAbzWPO4rHlwfSyoV+CNZZr1hJqX4AtpffCtv2Dzh6LRs
	 jbiMoCF2hXAvQprZw8XPywW7K0Jww1jfaM25zmNi9ZzJ6p4rWj7gXWYT4vybjVNrkU9f9
	 itt4z2dYSPT/5Uo0XkLVhPKVjYpLRmlQzqQJZM4QBwVPgFPsd5NJTdRTpcynLqHdfYT0I
	 IW4wyQo1g8Gcswvhc91rLtcRuRS1MSU6O0aWTwwZ5gXHzIBPsOxaNphV+yk42Pe9j7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028117;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3ZtmbCalnV2XHvXpcMGqPjM0ah1VG2cVwkA1iVENT9o=;
	b=P1WjMROQNrUJhb+QBEKilVILRzvUG/AsZSgVVAeJkAxn3a/4HTOtyTdjRfsZhqNwQ6tl
	 nuoB+JRGEry0CSKgWEc+8t9bTD7ShF7IZyrwXvQtZolxVee/XlqaTlMcqaLctOJjtdKOn
	 RaWkcbF68ERwujIBdvZ4KEe4qDsd7VBFUr9Jg31jyFgqyxgsextsb/Ks0Oq3fopXRkutQ
	 NY5CId07LuyUyhP2g2g+1QclUwSWwiNNHbOndaNwszXkh4s4YsEGox5Lw9zYn5G4orK8g
	 6cosuwtsd4IXOgBkOOVVR8eq1c6jsm2v6f1z4azVJtrULEVqT/nm6krrOFDvBSzAbFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CTMKmVV6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B70C560A2603;
	Wed, 18 Nov 2026 18:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CTMKmVV6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 208FD1F000C7;
	Wed, 18 Nov 2026 18:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028117;
	bh=3ZtmbCalnV2XHvXpcMGqPjM0ah1VG2cVwkA1iVENT9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CTMKmVV6aipQHq593ddes9gFjUyyM4cqTayt2ZIf5Kem2q8Cagz2xz+SASlUP1CfP
	 x4iWNja+FMyvdSzA5ATdr42KYAHZj5xnt3aZS3cb+1hTlzDoGLdDsGcIGnYNaeXkN7
	 DTno7fqDM25ltB5P5soryMW1AAwaIzmSJRiIpm7c=
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
Subject: [PATCH 6.18 2030/2151] nvmet-tcp: stop listening when a port is removed
Date: Wed, 18 Nov 2026 16:02:45 +0100
Message-ID: <20261118150235.688086676@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index f478f226e29fd..1e7e68e008c71 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -2213,6 +2213,8 @@ static void nvmet_tcp_remove_port(struct nvmet_port *nport)
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




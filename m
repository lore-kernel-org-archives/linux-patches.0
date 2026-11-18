Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022162;
	b=4uOQT2BKMW3YW4Mgcu0FWs725q30Be8CTxhaiyrLVjei6XE3TpLRWTQxiW7pau//aML4
	 IGP3s+QSXHl1hNeC1i8pSWwRkOdS+dJI8vqXUD36C8uAP/DQ0dpEdnLtEnV7IF1Fsq38d
	 qDHPouOz3UbO5L1q8BzchGtL6xqlkxvW4YuhlCkFAuvB5mvi9pU3oZXW9XwEazirbBARq
	 Ja2DGiKJ+INkCIm9C2LyeqEj690lGlXsEtKp5cWmV92lP8vBZMO0zkZjn7lsslVG3rCr7
	 EkD2rdpJaEhBLAT4CUxucpxniuFdlKw2yuYdP+bSzphVnrg6LNEu/D+U1omuNBav2xg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022162;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=a0YPyNvxuSs5QzAcwdhiBMAkfkkPEWtXlwL0e2Cdopo=;
	b=vwaX4CsvDIMH0cI0zyVo6n5rA/UzwZCHFvscou+ZaCn4I7iU06t/dVYttHW4/wU8B/Qk
	 yDy2Bs+zat1l6CKtxDQ4vPOH/gojGIrkFJPsVHmWnOOmedOI3jXxEpoNOU+hnMIeybhfz
	 vup/jO4fm9npWNpAAdSv/+RWt8gyIW4zaTInaXeZ3PtIVQfO14X6UIGNZA4LR6emuzO/v
	 z4YrTcSmOakkd7lBFKurgGZokOxCkPx+3/PZj5deeRQOUBAccDvBsp/hOeQA1eGar5exb
	 LohYS3ROcvCqUyDEP4Flq2HXwk9HAqcfY8P/DfcreeY219RLEtKT74q41FA8LdRpy9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TsiNlF+M;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F970606A32A;
	Wed, 18 Nov 2026 17:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TsiNlF+M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E61461F000C4;
	Wed, 18 Nov 2026 17:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022162;
	bh=a0YPyNvxuSs5QzAcwdhiBMAkfkkPEWtXlwL0e2Cdopo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TsiNlF+M0gSzf6vYekPo3VFZBZeUX0Q/eBNbXtYl6viLJsJ80uS0988EFHLYKxZlK
	 ASE+9E3QgQSiNJbfPZ8Mpor8ZRqA9RBHizvyJwTZCr2yZSWKGge942wwV0zomXUiJD
	 qsNUXmfVRRw5sI+wAP3oX2RHdP7CGfZz6IPwhYI4=
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
Subject: [PATCH 7.3 2537/2651] nvmet-tcp: stop listening when a port is removed
Date: Wed, 18 Nov 2026 16:02:57 +0100
Message-ID: <20261118150415.915004346@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 7937377436d3b..84af7d1bc588b 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -2191,6 +2191,8 @@ static void nvmet_tcp_remove_port(struct nvmet_port *nport)
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




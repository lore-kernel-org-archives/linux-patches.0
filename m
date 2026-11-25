Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621452;
	b=TZ2XjUp3hULaFkQeKeGW5jO/RvhKrRe6ci3fTntE7OZdsxj6QOvMKQokshns9fN8b4hy
	 povXmqiLj/+nHTf2fQiV4PugosqttPQahJeBR1p4xMG3hcP0Mju78cDxMb1/2g/RJ8V1k
	 SmtUtTGn0oLzxTgZBFL80B+9TlbMkVQ+6rzn+8HUynsZNqbuy+gTKS5oXzlRdPW6fcwFW
	 5GqQcYuWQiCfjNS9CmssnL58iwDWNkjBX7QH8YkgE/cyx2IX3x0HRbsOE9Ggsxe1qo+2l
	 K0+zb95GjcjS0t78Hr2LTQ6KkjEfcU57E7LcmPDdt7/lJENGPkVg6d/UK4d1qJz1S1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621452;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OoZVQmwiIc8JFpQr7vpaUDqtqmyr+7YBoTwTiJw2mPI=;
	b=dws4VKbOCa8l68Acqc6eUmbdhIacTzE2BDIAblSBOl6Gxc0UGmSP7aBhq5Qpr0LGritu
	 BpKx+vV1nZqqY+zlXCpSaEalAcU/85Z49TtP6wXf8j5vcv/Iub9i+OwnnbqWUvmuvBq6m
	 sV4sCQ0ReuOO5E3SvfLUANL4Jx7y84thlEgGWYZbsNtp2LgwMNOQD/c2stCIpR8jD1fAj
	 Kz4ixD1QYJUiYlncjsN96FWyGsPEIMMYXnJro/smXfr3a8MxpSRD6K1XPsnFzy32sawC8
	 Uk2YcsjXDIvLBovKsu2sc+lFzJtXdwY5wRIeDEAoNlxHS4O/lI8V/Avc6MJ6dytQRhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Rvh2nvN4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1178C606A321;
	Wed, 25 Nov 2026 15:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Rvh2nvN4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEE191F000C4;
	Wed, 25 Nov 2026 15:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621451;
	bh=OoZVQmwiIc8JFpQr7vpaUDqtqmyr+7YBoTwTiJw2mPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rvh2nvN4DzzkCjBO9WIoZR+Z/PgmPyHCQL6SfQXmZE+YbR+XGyyO6NNgX/bF9sisK
	 khnlvVuv1H0Y8RSnItLogztv1u8RTb0u4gNejZC5Abp2hUArRMeMDmzOtqPpih8PP7
	 49Yf3MUlJOLJD9y7idzonEYT/iRW4eKWJAhVoj6k=
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
Subject: [PATCH 6.18 229/990] nvmet-tcp: ask for the TLS record type on every receive
Date: Wed, 25 Nov 2026 15:26:36 +0100
Message-ID: <20261125143827.453970196@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

[ Upstream commit 77f72de389e3774dc95d7cd03a98a73e47013abd ]

nvmet_tcp_alloc_cmd() points recv_msg.msg_control at recv_cbuf once.
The first receive that stores a record type there advances msg_control
and leaves msg_controllen at 0 for the lifetime of the command. From
then on nvmet_tcp_try_recv_data() sees the record type of that first
receive: if it was an alert, all later data is dropped as alerts and the
queue stalls, if it was data, a later alert can't be reported and
tls_sw_recvmsg() fails with -EIO.

Set up the control buffer before each receive, like the other receive
paths do.

Fixes: a1c5dd8355b1 ("nvmet-tcp: control messages for recvmsg()")
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/tcp.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index 6f8d5c268a221..c059a671a1d59 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -1324,6 +1324,11 @@ static int nvmet_tcp_try_recv_data(struct nvmet_tcp_queue *queue)
 	int len, ret;
 
 	while (msg_data_left(&cmd->recv_msg)) {
+		if (queue->tls_pskid) {
+			/* The last receive has used it up */
+			cmd->recv_msg.msg_control = cmd->recv_cbuf;
+			cmd->recv_msg.msg_controllen = sizeof(cmd->recv_cbuf);
+		}
 		len = sock_recvmsg(cmd->queue->sock, &cmd->recv_msg,
 			cmd->recv_msg.msg_flags);
 		if (len <= 0)
-- 
2.53.0




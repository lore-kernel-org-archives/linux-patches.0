Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624438;
	b=sl4PZndX4i7TTj7MGM0wlKqMc0+ta0N6a+Hv82hgZBx7o2m/1dXAMmw47+bX87OUuKbz
	 twuafG10lyFBvmcxpkUjsME16bH+Y03DGseOcFOcz7Cn178fW6eLfKiWKguBLiaoIsWng
	 U3M2yEYfrtCztthgQ8H5zI/X72T8GUw9emFzBCSxGhPQeY2bAgFa9zCI89dvZYqyf7+td
	 W+WyLFgMRsp48QED+kiE0Nt0oKJLSAsYHMCUKuuvzEdLa/0jUa4WzH1B7TNnARpf3+ZFV
	 P3ajg14ySEXzIwoIHv8rB06jtkCCE/gW6wM8h7SlI1bhD9thkDskgP0nuJBP2K/nRHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624438;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EAL7Vx8O9L9aNJX47BDrkGWzE+gevqc2NJcj8GNep7I=;
	b=UE3DBgxFnPbHvyVjyCkYgQLXvtNJg43Qoy/uGjLsN1X+0ou/imqPNlF/7e+5gHqiqtWG
	 17rRMuw4hNvCUeno1Tnyr1LRsp4oiDq+SSie085JpI18f4iU8SeN05xUBQpqeyofu6+YJ
	 HGFc6Ox09jopmVTzQu5hHgc/WbEUXb1Xd/ZQUalqBy0nsnwd9VOGhNU1eFyss4YmhY8o1
	 bzsTlS8ikMVGS5QBVQcNyMImX2WHKSoQ66aFBQFMALsLm5RskR+C+6FF4tyfiFNL2MnQh
	 y4a3lUqXbwO4+X5ktmUCWeuGhxmOwu5gVUc3Uo9YYWht/IBekhpa3pAcyNCtTm4Og3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hn7v8DBF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3DAF606A33A;
	Wed, 25 Nov 2026 16:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hn7v8DBF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E838B1F000C0;
	Wed, 25 Nov 2026 16:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624438;
	bh=EAL7Vx8O9L9aNJX47BDrkGWzE+gevqc2NJcj8GNep7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hn7v8DBFYpZkf0DtLtk/3ZYZr//Z0+CMbJPja0NbLdIeQdbPECJ1IdP674mwWqTbK
	 qlgf8MRalT4jT64juFa+TVFmntR/oL0VqXbl8pZhPXzuxoHXBolPPIZxXkoSqOE/0m
	 oEuX6PwAwH1bxr97T/AgQEy8HiuAS8aSLLitemRM=
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
Subject: [PATCH 6.12 193/816] nvmet-tcp: ask for the TLS record type on every receive
Date: Wed, 25 Nov 2026 15:29:01 +0100
Message-ID: <20261125143853.662573012@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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
index afcc55d5af661..d61b1efbddfa0 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -1346,6 +1346,11 @@ static int nvmet_tcp_try_recv_data(struct nvmet_tcp_queue *queue)
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




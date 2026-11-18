Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028120;
	b=SLMCMQEJFzyXUKTSSNxsvVolosnE+40iL8UwMDfTg4joDtpAyyH4uwww86Ot3hyreMuP
	 wtOxyv7N70tNxRrS4ZMp2vGi3KQoE8RtSwg68Qq2i1/kMC5LTGE17jI/dTKacMTjmny7p
	 HFHqK/wXiqMoYm9Wuq33YwGFnKnWr8wpjwszXA3+NX/gKRsotb/Q18tmzJ8Lk9+oi4c52
	 h1nkPsLK+uVZ6p2ef3laQUVgh54nLnSZ2aPHvVgfrlaKRO69ubj0UMX6XaOgEGQG4S/Rs
	 tOEpfNTPG9Zu96mE4KiQfjUhyEDyf2+sLxj60OqN/ef8lNjvIQOWOP90FTEXR//lkbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028120;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PfdfpGxzPyIgqaMXfoVQ0TfyMLn/JhyCj9dMH7Al67k=;
	b=0/aH/89ZcEn9FS7Ip4EkStq3BWliMbOFnj+jdtnJFLRYFQPxNUf2nk7r+5Jkz2DAHIru
	 apUpmtveUc70iAaGtO6Ard39Tgk6tdRvqricYnmLHAOh+rwIdxpFcujvV79fcHOZcp2fb
	 f56ykrvttEQ7Jwc3UuujsZhYtX8vNZH9kzTHVK+4U61OSvTM3XUsorELAbUT0OkzPdXVP
	 3Q9onoif7nLxaf4GZCh8rjCO+hQ5w6agIWbihUsxFjUXvVtOEVWUyZ0MmpPg2/ODvylHg
	 JR3ogzg/FvALqSF9NAOwhK2542Rvbi6RntU1JGvWpIJwIQ63s2LLBE6nbl1LFzYDoMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="iih85Z/P";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7168C606A337;
	Wed, 18 Nov 2026 18:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iih85Z/P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C970C1F000C8;
	Wed, 18 Nov 2026 18:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028120;
	bh=PfdfpGxzPyIgqaMXfoVQ0TfyMLn/JhyCj9dMH7Al67k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iih85Z/PQeGnysZL5n4GmRIB1dgL/AL3amcHIkGJtb9yqb9c1dWdnVMJyH4teUNfR
	 bioa70JbOTJoU/8J5EGsyzdCVUct8rnhjtElbewgIA9MUGqrVu/6mpYDXmPJNi51Ym
	 z9+vwWrCb2XETSfhLAk0cgszfN7mfpDmlcIQ2xyI=
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
Subject: [PATCH 6.18 2031/2151] nvmet: fix NULL dereference in debugfs host_traddr
Date: Wed, 18 Nov 2026 16:02:46 +0100
Message-ID: <20261118150235.723188780@linuxfoundation.org>
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

[ Upstream commit 81ce4d9bbe8cf47d4b023e932ee29b22367545e6 ]

The host_traddr callbacks of tcp, rdma and fc take the host address from
the transport queue around ctrl->sqs[0], which nvmet_sq_destroy() clears
when the admin queue goes away while the controller lives on with its
I/O queues. A host that closes the admin connection and keeps an I/O
queue leaves such a controller behind, and reading its host_traddr in
debugfs dereferences a near-NULL pointer:

  BUG: kernel NULL pointer dereference, address: 00000000000002e0
  RIP: 0010:nvmet_tcp_host_port_addr+0x19/0x50 [nvmet_tcp]

Don't ask the transport if there's no admin queue. Nothing holds the
queue for debugfs, so a reader that's past the check when the queue
goes away is still on its own.

Fixes: 7e5c3de3f2f2 ("nvmet: add 'host_traddr' callback for debugfs")
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index 7cae1543c3a51..90acbb5636f06 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -1802,6 +1802,9 @@ ssize_t nvmet_ctrl_host_traddr(struct nvmet_ctrl *ctrl,
 {
 	if (!ctrl->ops->host_traddr)
 		return -EOPNOTSUPP;
+	/* They all take the address from the admin queue */
+	if (!ctrl->sqs[0])
+		return -ENOTCONN;
 	return ctrl->ops->host_traddr(ctrl, traddr, traddr_len);
 }
 
-- 
2.53.0




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042566;
	b=Efx44PbVqStEZHwpO5/udRh+8XSkQRJoJUmEJv1bsU3huKnBU5H304VaMn9osqGhNTKu
	 ZlWeKyHAmM2AwKVJTYTOglHkHvFzrijcCkz6X4OccvFXGlUY3tJb5agpf8WamSxFwnASD
	 /SI0wS1sjn2HW4G59qKCE6vx2nEEGFY69/nO95GzfpUO/lKtJSm4IvDIs4WcpAd5hTAzX
	 KGcEPOGoeP9Y508SKOaU77PiCJxu1ubgshC3e36EJQ7QyQcIDRiuk7AzO/D88nAQUrvFw
	 6u8umWSbhF+SJ5T+k82X26JsmZogSG+GEhJ7wAqQ3puxFra/J3jicCGPL/HxgkcIRpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042566;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RBTGc5nahxkC+Jat2MPb8Qysm+bq8fmon3IWSlMXLpk=;
	b=PtRLTgAGuJTsvsLBH9lVSBdwwLChFpYVgngQ83jMfM7YLVkws3m9euOLCeuBX0KnUhHD
	 dLxJJq1XKaLnSrdN4R/SMAfVsLd50lG5gGS63ToPaVy28ItqCAjdRFryD/trtIqOwt8Jz
	 1wrDjDO7ciQGjz99LdROEOyHX5MBE7wgffzU4HZZ9vmxmsB+DAwAauJXrrn1TdqqT8ouK
	 80SoIhsF3+j8rNgMzsY5WG9HBBEqJg0sUeeAMygsnuqpAn4qwJMKJjr7mQMYBba8I9owM
	 gP9fxZJUnKfN2y0gdksm22wsoTyQOjJMETkSKr1YTE9NaptDoCLgzWwHW+uXcnKH8xA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eTJOR9S7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29968606A32A;
	Wed, 18 Nov 2026 22:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eTJOR9S7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 811461F000C4;
	Wed, 18 Nov 2026 22:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042566;
	bh=RBTGc5nahxkC+Jat2MPb8Qysm+bq8fmon3IWSlMXLpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eTJOR9S73Xv4MUwxsKujJawB+CECyU+RB20FP6XjE+vUTAUp8oYZnVffMo5Q1JqCa
	 zps9HVCKeb2e1IU+FSu+OM5tl5Pf4L73TeQJu4mEzSp8rbdsC7D67dY8Q17TkQA8zd
	 +ajWlBuxGPgZvq0cxAd2cLuguFxMt8wM0wChIguI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3217/3318] nvmet-auth: take only AUTH_Negotiate for a negotiation
Date: Wed, 18 Nov 2026 16:03:59 +0100
Message-ID: <20261118150456.252112151@linuxfoundation.org>
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

[ Upstream commit 7dd1d31e2e3124f331056d68af9a48c501b37e02 ]

nvmet_execute_auth_send() hands a common-type message to
nvmet_auth_negotiate() if its ID is AUTH_Negotiate or matches the step
the queue is in. The second case is wrong: the only other common-type
message a host sends is AUTH_Failure2, and no queue waits in that step.
A host can name the step on purpose though, and its message is then
treated as a new AUTH_Negotiate without the work that goes with a new
transaction, like reloading the keys on the admin queue.

Fail every other common-type message, as AUTH_Failure2 already is.

Fixes: db1312dd9548 ("nvmet: implement basic In-Band Authentication")
Cc: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/fabrics-cmd-auth.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/target/fabrics-cmd-auth.c b/drivers/nvme/target/fabrics-cmd-auth.c
index 14379fbe42961..33b420c861b1c 100644
--- a/drivers/nvme/target/fabrics-cmd-auth.c
+++ b/drivers/nvme/target/fabrics-cmd-auth.c
@@ -299,8 +299,9 @@ void nvmet_execute_auth_send(struct nvmet_req *req)
 			}
 			req->sq->dhchap_step =
 				NVME_AUTH_DHCHAP_MESSAGE_NEGOTIATE;
-		} else if (data->auth_id != req->sq->dhchap_step)
+		} else {
 			goto done_failure1;
+		}
 		/* Validate negotiation parameters */
 		dhchap_status = nvmet_auth_negotiate(req, d, tl);
 		if (dhchap_status == 0)
-- 
2.53.0




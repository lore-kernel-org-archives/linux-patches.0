Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022101;
	b=Rz7DLJtbizhykj5JilKGge7Qwsi4XUcJNN4vJRtcx4orIdxed03lm83dAt7LzySB/k6t
	 nZSskIBp17iz5GpHEsgjvaN45HJBjYMFRNyR+ichpXWyZLtOu7sWNTXlGAUOaAA6a8viZ
	 2GAU6MBLdkPg+UgjdaeA4bBKMTOFJMcSdm8ox43FlsfG67jK9ouKecu4/o9zAOeFileuo
	 /pgEqAklkMausGt9f4xfTc7dYtcyrUKt0PzBKwBtwVtgtLQ6fS3T0Udw0a6b7TGpBxVHK
	 WBCF/MoopDX7PgP3nh2FE6R2UUTz1EhtNDH9IccFmuYGDcbKq9TL0bBAVM9VoXpjCNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022101;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=H8cioA1U+esna49kkpVMouGdpp/vWfVjbXCO10U19nc=;
	b=UpMN/yJhbHEG3sFkcKiRJQBOidUJGqm269Ey0bKVHIdEkupP/ABIjLDTlR+yAK1d+opZ
	 aIVBp0iPQLNY2aRndf3hj7rIaN7vwxV791Eee/VIu2b0z6g/T9EuLSOIVi7NZr0SilbFj
	 Oo/opiT7curFQJNudH5+hxKSwOMmVoqJojL5svCy1DGQEqnp/DK/l9ht2QJb4NwbIaBDN
	 fqLGulS74imBuyYAHj0C4j9YIgXEIPl3jMiCpn3w3R4M2nhjeufLJSaPMo32A3WsfAFWI
	 W+VeK06slSnpmQD/D6sb/ujCIIlRPsmIY2dV8h0P0tKHmRW1MfzHU9g0brnhD2dTf5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=te54MCwY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C4EF60A2608;
	Wed, 18 Nov 2026 17:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=te54MCwY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1EBA1F000CE;
	Wed, 18 Nov 2026 17:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022101;
	bh=H8cioA1U+esna49kkpVMouGdpp/vWfVjbXCO10U19nc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=te54MCwYsJ7iwjQ07+/5cx3uRXoJ2MaYHr6h0w/ILyUS1MvKe+jom3kPw7qCxingd
	 /GTNjOZ6nfYkU3Kw9zD3quTK8NNOY1Zu0v5k8+pTZBxUbSMnKcykc43orv9FMh12QR
	 OSEvSoLUFXgjKIXtr2bKqZlS7ZZ3Tjqy71TuiboQ=
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
Subject: [PATCH 7.3 2535/2651] nvmet-auth: take only AUTH_Negotiate for a negotiation
Date: Wed, 18 Nov 2026 16:02:55 +0100
Message-ID: <20261118150415.856245214@linuxfoundation.org>
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
index edff0eed18884..70136f6c22e8c 100644
--- a/drivers/nvme/target/fabrics-cmd-auth.c
+++ b/drivers/nvme/target/fabrics-cmd-auth.c
@@ -345,8 +345,9 @@ void nvmet_execute_auth_send(struct nvmet_req *req)
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




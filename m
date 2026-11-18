Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033053;
	b=VEsJPZ6tMTGlB/sGi6/HjbG0K4A8CjMpj51atpWDbNLV67AaDdxCxf0AKJ3qLNTwKNTO
	 d5EoSu8FqgUWInmpCLcXQUrIhuZLLdyW/0AsLs5g66RgwWOWvTWDjq/2uozi2O2l08W3F
	 Cw62JNJBDGEBf+YXhC99mnWd7yO0PlH7tqsgqRwZlunZYkRauvQPkPHHPJD/+6a5ffr1G
	 8QuW9G8t7Yp9icPGebAoSH/OrofJuBSCvhsibgFO1KKKIzyMBgd7pAKWOKj3bA5VUeC72
	 HD8NHiiWQWDkznyoG5O3H8t4Fxiz14AUSkxH8NvbSmqfO23y7l/usHHATzuTitwF6mg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033053;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xov44gpb8GNPcIohF80o8UXWCriCRpKWsPaQYoiK+RU=;
	b=oYvoF2qZPw4J0/+8/V1rR4Q3DcVIPGSQkMJuG2u/6RvS+LvLpny8ZW1elSbuow+bUW6/
	 KMN9Rp2hOKU5eiX3ON5skuo2+t2OojRIPaH25aXCMWcOZhTPlPkZk3niXyAoKIeLOR/0M
	 i5neRfsapDK2Z2L5JTnp0SUbKjvFF0zBDjrpowL2DPwnzzQRQWzKj6T6wKHTP29jJ9QLq
	 ifkS4N4Ty9hR98pGNnuYXQPz6tz6IAE7bmaFJJ6XXbmuDqfBZ2RmfqqSR+E7lcm+YSkul
	 LZOMjqXJTCaj8u0FReccqNcViHQr+mUNRc6AsWz29zvJVMraWqpz7zz4wRw5LXfz7zA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HBr+aY+v;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F8B5606A332;
	Wed, 18 Nov 2026 20:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HBr+aY+v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD4A61F000C4;
	Wed, 18 Nov 2026 20:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033053;
	bh=xov44gpb8GNPcIohF80o8UXWCriCRpKWsPaQYoiK+RU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HBr+aY+vu1XPjEGaoUa7l822FB89HR5jLWSBJ8CQclbecVPNN8DsZM2IkRQyeiGuG
	 c7UHmpeTwSKxVtBeDGfv+1S0ULOMNT/mEBkSwdrP36Tbhrm5X3iQoLCY5cb50z6aGF
	 nW91x3SIF5GxeUIJ+X6iuXx3ymBD0HUg4dwD5opo=
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
Subject: [PATCH 6.12 1630/1756] nvmet-auth: take only AUTH_Negotiate for a negotiation
Date: Wed, 18 Nov 2026 16:02:37 +0100
Message-ID: <20261118150114.686143351@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index 0569f0e120c75..fbf445ddb077a 100644
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




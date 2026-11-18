Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028112;
	b=U/ae+1Zbakqi9H168C6W4bXwgiJUdV0E7zEA8glrIRRDsX92piC6YbMME7XC02Ta1fdA
	 wOxAuAab7wbKOADDXSIHak7SXcDqfE4JEs9dkPL6QxgrhUNq+timdZViwYmJPr0Yn3WOv
	 tCC1z2MsPDXUTUzHMQNkMp6iiGRnrxiWNKA2FXTlol6MQFpuXNrxHSLC/t9fdzawEYN94
	 OobloLDIFoYhCgWy2T6CHXtXDdJLuYZlQsRwPnxnfi4r/x/TkeVGbTPp3ic+y2LCs801L
	 Cigv7itfN6kNDOlipKUGx4gH1zEBigP7hXoitugC6OsDYrc1GlAP/cjpVvm79aKk/6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028112;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DTTaXxPJexio/845M56KGHawPJIGhy+pD9uvZBOSU1Y=;
	b=aMyPtP4nelokvNw2xeEbQy0nrZzpQUUX0WfdVL5qFTbQnD2rfhLgZoAQAfKRnBl84zr5
	 EFiqJvplNd/+qrTNq+IqEyxES/ZHtrpPa3Whq65jkZLP8JmIx1Zv9bq3r+kZ6XbJjZBqG
	 7qYkajUyrBhROc34UXu92Vp7SZJGJSrkYYuOV8rAnGjSxONwqjK0ttVLJaTyv4IYH4kl8
	 C2iF69OmH4zSmXfE9gy8K5L6P3yf0EoN3qoG0pjsFXwLpkXLKG3OhDSJ7VTkMK4RCuCEf
	 Y0B8Ln+dhjjocPhbNjpozan+lHF4uG5XRg7fx0CBvgHI4WJCYOLdQrmzvv5Q7bzc0WA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UVVVDrUM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BED61606A320;
	Wed, 18 Nov 2026 18:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UVVVDrUM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB7861F000C4;
	Wed, 18 Nov 2026 18:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028112;
	bh=DTTaXxPJexio/845M56KGHawPJIGhy+pD9uvZBOSU1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UVVVDrUMpgMfAZcLgHVXOfENF+83M04bK2ytlXfEaGVkMpvCKYpL1RnLOidyGo0FX
	 s8Bu95nYhVFe5VwDv+Joo+Dvxzolog/QGTpSDST6r+XARn/6vR+uQ/hErNsau6Axk9
	 gqXfeWtfIczQVg77m+ARKxcGo0WrJCwtnbzAxXRI=
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
Subject: [PATCH 6.18 2028/2151] nvmet-auth: take only AUTH_Negotiate for a negotiation
Date: Wed, 18 Nov 2026 16:02:43 +0100
Message-ID: <20261118150235.614392134@linuxfoundation.org>
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
index 846ba4c8ec249..72b42fc872385 100644
--- a/drivers/nvme/target/fabrics-cmd-auth.c
+++ b/drivers/nvme/target/fabrics-cmd-auth.c
@@ -347,8 +347,9 @@ void nvmet_execute_auth_send(struct nvmet_req *req)
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




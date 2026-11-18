Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048361;
	b=mc6HojaJ52S5oY5ntRQfX8eIK3YrELijoRqgc4mEyu+w85GvDK66okn6fgmKe3xJ44Dz
	 /3jFl6gbcx/yQzZBCwOnKXPYDFokbsjlz8PikPT8wTMsyLmpByemTMSXT4RzJZKzFPmt+
	 vcqW0NiABzY6KsbRY1x9YFV3xY+/glCQfLZ7Zr5ECZPiEO3ES0OqiESzfwWTNB1GKO4yZ
	 AA849AZs1PFN2wq6PpFlG4gz9gUivoIQtuT6qFcFWNQM+AILOddTOLbSq0Tbi+8WcVQ1X
	 AVPwnJMtKw5rXzh+BC9/xuLfB8yiri8+UDiuGwZ0kq7raOnhmLRDjYpJ3cTwBtbsTZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048361;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0Pv9fQXc1SOCR51a1RiHtfl2d5+6HARmZUlEE+yaIAE=;
	b=PX4K5xZ88IFvEbx+JYjMhx4CVfapHd9nWe7qKEt4ZcyDVL3QNvA3Xyu8qvyH6kpmVc/I
	 eeOA7Gt7WPq+hXKzzxR1Up5GuVdu2AD85YIZfsSwIS/PBz17P1oHK24kA3oZaP1M+67/K
	 Ul6EigpBd0PpaOiL1gBfFk6EKQNLj00E6LKRBqROR3OFdbmeJqLO9SdDtSU0nHPoNc/OX
	 8dfUlRhS7qDhuQgq9rUiqlDIK/UVvbF0CSsDc6hBsSS/BjZL75VovNWCf1k17+QLo/9yi
	 1MgqMyR65F1JYNBhcIRiI2bRWmwmAtBW0WHRUrtYxx4I7V4hU36TUkP/onlReRXSRzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v6lxUKXu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF3E2606A320;
	Thu, 19 Nov 2026 00:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v6lxUKXu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4156C1F000C4;
	Thu, 19 Nov 2026 00:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048361;
	bh=0Pv9fQXc1SOCR51a1RiHtfl2d5+6HARmZUlEE+yaIAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v6lxUKXuLZZJl7HvmsHXTOf1dAKre04bVaI1fsahE550F92mi9rGr/RQFHQjFwIt7
	 TRFYrbozGyHrUm3tEwchdNjFXhDMBE5Oh5/loaNYNhxXUdzZA+4Oryncb9tfiF2BM6
	 Hp+gDVQMC8i7Qph/F9jgC5xWkz26OyIj/Ta+cb8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Slavin Liu <bolin.liu@seu.edu.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1967/2857] crypto: atmel-sha - reject initialization without a device
Date: Wed, 18 Nov 2026 15:50:01 +0100
Message-ID: <20261118150312.228334992@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Slavin Liu <bolin.liu@seu.edu.cn>

[ Upstream commit a9a2152d292fd0bc73814eb4a127278ee7dd3f6a ]

A transform may be initialized for the first time after the last
device has been removed from the driver list. Return -ENODEV when the
lookup is empty, before the debug message reads dd->dev.

Detected by static analysis and reviewed with AI-assisted source auditing.

Fixes: ebc82efa1cd6 ("crypto: atmel - add Atmel SHA1/SHA256 driver")
Assisted-by: LLM
Signed-off-by: Slavin Liu <bolin.liu@seu.edu.cn>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/atmel-sha.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index ca4b01926d1b1..2596ec2dd2dbb 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -430,6 +430,9 @@ static int atmel_sha_init(struct ahash_request *req)
 	struct atmel_sha_reqctx *ctx = ahash_request_ctx(req);
 	struct atmel_sha_dev *dd = atmel_sha_find_dev(tctx);
 
+	if (!dd)
+		return -ENODEV;
+
 	ctx->dd = dd;
 
 	ctx->flags = 0;
-- 
2.53.0




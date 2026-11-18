Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023977;
	b=WWKVaYVqA4KWapjaT6Lwcw1lRGGTspR7GTi7sRr0NwamJKANvjIMyZCn1TFCRlgv9U8q
	 6o7zfq8mD5mGWZEhf4HCrl066bVWYR9DsybKWNVi0lquK37Q5KV0NPDsDdu5KIOcbwR0i
	 Usl88a6RkxxK3wluBkIZo8IwNSAiLOK097bPyUoeu5xk4Q65gnFMe0GLT/Z5AfpnGKtX+
	 T+LJxA0uDo3vSIGwElMsxh4mgrozXgYmUJsXuO5DbDhv5XD+vnthY6dSG7rGz2LXGPjuA
	 lWSqTIMem3Slo0nBSp7vPXddEyCysrThDZaaRNRv0CXsq7zja+muynHRNGd7RZPdqCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023977;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bfICzW3HD2Wc7lAgbdFgxLP2AGDEkxrtHH7hBeJ6Y/g=;
	b=Ma1hpQiu8wA6bnKHmcbaC3p5s7Q2cYgNRyc/wt5hD+51btb8Tz3W8K/C85GdsZX5R250
	 0OQuFY4uXSkUqWEvw46x2fMQux6xF6A8N3YIsyyAMYd+icWFXeo+2OQxyfbuWw5joX+OV
	 odi3yS89aHo6pKQvcqFIvSY9vs/55G3olkR65GgvfI5t+wZS0/UGA3ub0PU/GUfIilBG0
	 CuymE03wkXvcF3JgMB6hsFX0Ca0+Tn5HUvBySI9hXySH69P9ttpHfd3V8Y4APQFK9G2C3
	 plR8/N/NzxaWfJ+ViJWqsFSFZB3Z49Q5jfsgvoy5zap8i7NLUHy0IYqCNgFTU5Xz5tg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=he21proJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DAD0606A338;
	Wed, 18 Nov 2026 17:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=he21proJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 916491F000C7;
	Wed, 18 Nov 2026 17:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023977;
	bh=bfICzW3HD2Wc7lAgbdFgxLP2AGDEkxrtHH7hBeJ6Y/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=he21proJ7rOvMrzuWOs8dzUWFQm2LkmVQfmbMpFl55jyP9AROwAheUYJMM94GKxvN
	 D9du5wycDY5jBwIKkZgwBv4j1gMVtPueEg1NebsL0MUQNeYjDhA+6p+6tkWdvkEJMw
	 DgY560qy1s5UzI9lwNJOztNydIBdFgmE1kjD1+xQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Slavin Liu <bolin.liu@seu.edu.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0520/2151] crypto: atmel-sha - reject initialization without a device
Date: Wed, 18 Nov 2026 15:37:35 +0100
Message-ID: <20261118150140.986260242@linuxfoundation.org>
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
index b02a71061708c..f8281a175a779 100644
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




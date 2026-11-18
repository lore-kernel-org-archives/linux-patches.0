Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029749;
	b=dCzAP3/gx/OTLUBNhBdbM9/NlHlDc09gFurILIAmXYyveWaFWMyf0gd/YK9yq4cvim84
	 L8tbhZhYsDBL4I6cQxY6TRBpjMwYqTl50o88twujI2tSFIoM9LvHY5GQHnE1A7a0LZT+z
	 Yiyb4ECoPtCLbvHip9VxX8xE76ZeM5yQTORV2ClNjxaQF3JFH4HMU2dh0WA9wspMEfjBx
	 6sSgQm6OaWTYy1tyx9WcURQ4x/fC0zvrFuMjxzL7pdgolIgioLbdftqC/YerahB6z7KVh
	 iPDoD3qO5qaI05CqAxrzid6nQiVHepnXTgeAuWmIwBPbsnvHU54pYMedGhfomSaSW4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029749;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3qTRqEikiF29ES8jrT8HsSXQraLWwWuszQ+jknDjqzs=;
	b=G2I27oWeIF29HlcY8WasRQsWELFmiLIZw6qXsTCr8uayWUzyMu+nhjVos/UTaYGQksxl
	 r5rIdQrMCxOrIEWyozGb5G3O2F7nh4PRLLezImk20k4ZQCaG6ZHIlJVkGG79K8eNrWlWY
	 dH09n2JWgSAYtVlHpPchbjpXpTtdvoE2byfse7F2lXmFgVFtBxjLksqOISPp7l0lSoo3p
	 H42KHkEViz0Lt6FnJm66zw5sWV55XfrUCh7VrSl0UnXXxKYL0TbefMQe+gZRA+QNjybNn
	 bndYERRN9vLVLiC6FD9FseRa5XMLWOzch34V2yctMtZp5+dOn+tj8Q1o3lboXNXy/LQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WZ+xsKcg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E67FC606A32A;
	Wed, 18 Nov 2026 19:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WZ+xsKcg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D07021F000C6;
	Wed, 18 Nov 2026 19:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029748;
	bh=3qTRqEikiF29ES8jrT8HsSXQraLWwWuszQ+jknDjqzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WZ+xsKcg3afx0K2F0yPpKK96yLmqi2POtKtZo5wMYA3WmuuUkZ6ykXPI9wpBCyFFE
	 fgjy6g4gBUJznGdNtYbfG5oHCRjNdLLeI9GuChcMo8972pccXHrUw8EoLfeXVEYHPO
	 QVSJpGtvVhuZ8XaIy6lYiavyIBvkk+G4LirXL9ZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Slavin Liu <bolin.liu@seu.edu.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0459/1756] crypto: atmel-sha - reject initialization without a device
Date: Wed, 18 Nov 2026 15:43:06 +0100
Message-ID: <20261118150027.051959094@linuxfoundation.org>
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
index 4f2f57bc3bb67..06c91b0bbf22d 100644
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




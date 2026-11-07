Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062935;
	b=de/47doAsr7ltpUFEAZ6LqykGohjUBBtgo5jBD4SZ5GQDnGew/ojU4yqCLmNYA3cUIsN
	 jt/stusiYVv6WyPQsdsRl8nQkFGchbJ0WGC+fqcNahBXqqeyofr4PTR7U+ewfOJ1SDE38
	 frX00iUPk7NYGXDFCQankMhQn0F4GJkEV+Yo16FD/01UwPKMZ7lY0i4wDy9T/fTOD0SAN
	 eO1TKi6mtteb7t7qmFPeOcV1w83punMX8mokmbdZZcikQT6mvdxOnRz/0OpyxP0US+/yM
	 n5LK4TFx1GhQ1mxL4jgdAfnR5EepCX46fjR0oNuP6tBiDnHsnSWTjARQXcNtamXr8+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062935;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZePwCG/UFM1Jn1WKmAZNddr8NBsI0jI2TRBE6g09f1I=;
	b=DGbEq1XRde7iwgkzgjHFSO7YuqeJhqvdNyJCBMM8mw0lqyM67EIMyBoz5cVu/NibNQ2q
	 lHrLbyX+b7PcC0eA8iOM12P5Ry3sdBQdLHCJ7c4w1Vo8ai9GxVxPrn7iVAv6ynR6Q7rPU
	 Sy6MUlpnqFCmzER17whbMBHzsiTXfdF/NFXQoADeUQTZV95pipC6UEPm1M6PIJHAr5N/t
	 4G96dL5C5pkQP6wbF/EQ01MkZVACug5GPUrcHS7KdUYW/rktY+TAxKKmnTFG6Uyax8m+u
	 aF/6/YgqMuIg3+doYwHTIFfsn+A7MQl/lnh4BTFLuh3st2mrffz5+EVXJ2vCRvbC3lw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1ndXuwFM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A54B606A326;
	Sat,  7 Nov 2026 14:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1ndXuwFM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4CCD1F0089F;
	Sat,  7 Nov 2026 14:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062934;
	bh=ZePwCG/UFM1Jn1WKmAZNddr8NBsI0jI2TRBE6g09f1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1ndXuwFMLNY9QjMsphGNsZRzRwMc23KAGQXQgJZ6y7Lds6ockH7Sdm8OpYkX7jcfl
	 GcyoyBJwvn1lIzG6RdkCb/RH7yT6ME2jaL96/+AZbqlSvQCfS0TKbP6ro/flRzNVVZ
	 A5iwtmJfoYzqgLubZ/j0TLo7JDO0eXAuzkXBM+cA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weili Qian <qianweili@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 204/869] crypto: hisilicon/hpre - return -EOVERFLOW for small ECDH output buffer
Date: Sat,  7 Nov 2026 08:48:06 -0500
Message-ID: <20261107134858.923414382@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Weili Qian <qianweili@huawei.com>

[ Upstream commit 232804a5ed70a8ace32c46d341d438aeba54bc67 ]

hpre_ecdh_msg_request_set() returns -EINVAL when the output buffer
is too small, after setting req->dst_len to the required size.
-EINVAL is misleading because the caller can retry with a larger
buffer. Return -EOVERFLOW as other kpp implementations do.

Fixes: 05e7b906aa7c ("crypto: hisilicon/hpre - add 'ECDH' algorithm")
Cc: stable@vger.kernel.org
Signed-off-by: Weili Qian <qianweili@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/hpre/hpre_crypto.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
index 37d5f12e0ef1c..870b296d45b45 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -1460,7 +1460,7 @@ static int hpre_ecdh_msg_request_set(struct hpre_ctx *ctx,
 
 	if (req->dst_len < ctx->key_sz << 1) {
 		req->dst_len = ctx->key_sz << 1;
-		return -EINVAL;
+		return -EOVERFLOW;
 	}
 
 	tmp = kpp_request_ctx(req);
-- 
2.53.0




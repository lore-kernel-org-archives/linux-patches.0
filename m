Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039885;
	b=W7bB1R+rYGXod7WSNZIFLAW4n8H49pF6iC1rJbwYXfIB8t8xUhKNfpAs3g2SZprgaUEa
	 fbDnAFzxXtXOXG+sk+G2g3KW2DPUbv1PD1Ban+D1EMMJG4h+e45rwdHNOjK8dSFBF6jzN
	 EHgd1lgmxfqwNl2nbTKn48KSN7bmkaUeStS15fXvlxA0zFzm5orjBMNbXvpmB6UQHxQrT
	 U1fGW3/1swL70ckNzmxwa5z++nGlYbdKavhBApMIdt0OyPFwOAv+wsfAn8tUdA+Yqr7YU
	 Ap9yoWjWgNVYzgyjST49fQV9UA0ZD5qpsY/EanAvUPAuuDoYCesmxaU5m9rIOpNf8Rg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039885;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rdQqgdciZWEsIKPR0uCwKgOqcTNSY7tstjg/ylIXsFM=;
	b=k3aQbOPfHuUioL35aFbc7vLNNU4+xYJsY2QTMuHfhlbnyB+4jORxgTRSyQB4w0TDn/Yk
	 QMJsOKqS0jMuw3mFADCnMFkyisYptFR95Q657J6Irkv7yM8kMC+O0WSFAPtE7hgJ5Jv3K
	 hRwSdipDjvocxPuG7f+/Zb3d+4s1ZroY6PSmAJAG2NXcU1Zn1ZhILK2eru2hfgt74T/32
	 5QbneqVc/ORQEaMqJNZZ/9Qh7LMTEO98MAvt00jyQkEkcMyC6XqJJP9PvDfAEBvTp8N7s
	 Ec9ldCCEkXpMXpVZJSC7ePbczSD7inZwbdSxXAGYBBTEzo5WHZblyHwUrN9FPMnS+IA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fCQuxYil;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6DCF606A320;
	Wed, 18 Nov 2026 22:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fCQuxYil
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4138D1F000C4;
	Wed, 18 Nov 2026 22:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039884;
	bh=rdQqgdciZWEsIKPR0uCwKgOqcTNSY7tstjg/ylIXsFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fCQuxYilg8rf91kvmmrSOSuftaDO0x4/idgF2OxzLkqTWmfrFrvgmgq7P+/JvpbOt
	 uP5Er/+sVtwaepbKYGqdMxQXrz9fxg9Xg2oGb5nGpT4/GBkSkLDdsRdFkasSv4IZh/
	 1BQCiCBnBSAT9VKt+nQnItbA+sQxds8gbTwvqU8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Slavin Liu <bolin.liu@seu.edu.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2259/3318] crypto: atmel-sha - reject initialization without a device
Date: Wed, 18 Nov 2026 15:48:01 +0100
Message-ID: <20261118150429.590647780@linuxfoundation.org>
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
index d32fb4e770119..1aecd175eb77b 100644
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




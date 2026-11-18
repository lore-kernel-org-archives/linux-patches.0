Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023526;
	b=g2QhanHJs3oTCzW8sZ4bN0LvCH6f/9CNsrDfHS6PljCffQlPSLEvOiP6dRk/k7+xuzpd
	 pSQDYC0+r7mQWL7AJZCjTgDvM/DwnxflG5aejKsKqOlNKhN/X6Cdab14LQQbrO9vEzy30
	 2gXhXK1RsDNbkkXmbuNvxorcf4Elp8MZF2TcMvsaMtp0i8Jw2Dp8lXBYA5hWGP7udURei
	 zW+OoY62w/bjwd71lBKbmPuDhrgSfsIPbTm/qR/5G/xOiaEh+b3gRFNSDAIo7x1sLyz6N
	 vCDcbXY06sXw7SLD5ZDZRXXwYqREd3trhJc5z0MdqGCdDislngeRNTv4V+lNkUVYjGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023526;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=BRt47phaDlJNd/nREShc+oDV2PU7TRq1AVn+xGpkM9U=;
	b=f8Cc20tEnA5dAPS6QVOAnr2HXvZKZYx6WHL+QhErSB0q9xeKP8KStveIWtQOY80W+/oP
	 eER6UCDce4+gZhSNJoDoh5v389xwVIkuo5H2OHTHulXy5nEYQSjle6fHFM6R/XuSi/mvr
	 2MkertG2iDY6TIInOUVH8g6jUpC9zfGF83FD7K9v6Kfeig/d4Brkc4nXv38vmawzb1gME
	 0npKSZmG5L7qAv+E/BXuCS+DDZFnvzqVbkfIFq3yh+gj5mwNLRykbZ2sQeD7ttqw8vix8
	 qlwhz+oZ6MGGEFCAyawS4E5jZNOjwSXDrpdvaSEDSTJ5vpVSweRd4qhgj2biZWDMrjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EyL3c4Dd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D667F606A31C;
	Wed, 18 Nov 2026 17:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EyL3c4Dd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35AA61F000C4;
	Wed, 18 Nov 2026 17:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023526;
	bh=BRt47phaDlJNd/nREShc+oDV2PU7TRq1AVn+xGpkM9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EyL3c4DdibgVFcDNFWVgQFSRO//lYy3hQ69Lbg9QeZH/B1Ws9YC1S4TfQvcNxoq46
	 fXumVHE45c7ctjsFbhoN68YWdPMOrBeJa8fPhUMuA1b+W6PEBfIUubx8rvQeOHq197
	 AqSvPsl67epo0YrqQh2hIunaRtgl2BKgZOQz6dcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Sudhakar Kuppusamy <sudhakar@linux.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0384/2151] crypto: rsassa-pkcs1 - reject undersized keys when signing
Date: Wed, 18 Nov 2026 15:35:19 +0100
Message-ID: <20261118150136.063604178@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>

[ Upstream commit 4cf50332b5384ea13f6f896d5cf84e05b5b6484a ]

rsassa_pkcs1_sign() subtracts 11 from the unsigned key size before
checking that the key is large enough for PKCS#1 v1.5 padding:

	if (slen + hash_prefix->size > ctx->key_size - 11)
		return -EOVERFLOW;

If the RSA modulus is shorter than 11 bytes, the subtraction wraps.
With a one-byte key and hash=none, the padding memset() writes past
the output buffer.

KASAN reports:

    BUG: KASAN: slab-out-of-bounds in rsassa_pkcs1_sign+0x1ad/0x3b0
    Write of size 4294967294 at addr ...
    The buggy address is located 0 bytes to the right of
     allocated 1-byte region [...]

Reject keys shorter than the minimum encoded message size.

Fixes: 3d5b1ecdea6f ("crypto: rsa - RSA padding algorithm")
Assisted-by: Codex:gpt-5
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Reviewed-by: Sudhakar Kuppusamy <sudhakar@linux.ibm.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/rsassa-pkcs1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/rsassa-pkcs1.c b/crypto/rsassa-pkcs1.c
index 94fa5e9600e79..d0e4a885397f4 100644
--- a/crypto/rsassa-pkcs1.c
+++ b/crypto/rsassa-pkcs1.c
@@ -169,7 +169,7 @@ static int rsassa_pkcs1_sign(struct crypto_sig *tfm,
 	u8 *in_buf;
 	int err;
 
-	if (!ctx->key_size)
+	if (ctx->key_size < 11)
 		return -EINVAL;
 
 	if (dlen < ctx->key_size)
-- 
2.53.0




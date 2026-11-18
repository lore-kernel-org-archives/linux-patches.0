Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019372;
	b=M6dEeOa9YLa31xhjlx7iCiJFmSOKAjGWcq9JbVUG4hVLxTOJZJI4v1ZoodkioniGCvjr
	 4mInyr41Xl4BwaIc1JJfZYwMvP4ve+wYA0K+xVz9VetFttvm113g20lyc5M/jqWSjvr/d
	 BMYDRe/NwoT+59WEelRYOeuExRObl/wL1Ddirh5S02cWWWhT3+OblcLWwd2rBb7BEYp+j
	 zabEGmIINp7diEcDj1QSIeYE/hW1qEzoXVzEHMJUjgnA69Fd/FbposLpVIE6qzPW8SYJm
	 z0HeNG4Dts/dXUIYSTQSp0KjwLEJK/eH9r/9UPI1ZZxCTcutYQoX2Q8dQ3jeJwGhXQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019372;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=J/QXjkemFpbHJg6t9umPlHdCRl0rXdV7W+hoy3+PMgM=;
	b=h2jxgo/mlbaQHuQ7+3Ni1OU3JY+JZM4quLGCM1iiHh6CWY159vB4mRiDy6mF23BtEVps
	 vHM4qkCGx9lfweNFRpi9pASj4svjfmVWfV+w3gpVfoT9cRJ1Lv4PbfpnZ2a6QZhaAXbQj
	 VxhLM4wog8yjLTN7t0sVvwT2T39Wjn2QxG9tadOZqOZXvFS6HmVCWq0DZQKfTo2ny+IjJ
	 YJCKEHs9KWuRuPe1X5472UrsIea/Cou0rEUvbJfaa7RBKNZGxyr8J5cvc5k/73PG0lPJ9
	 saHx90gLj3hjo3swv4YEsUgBNpjpq4K1VlklbGBxG2EcHD5j9vfyxOjuMRHgWVBHx1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s+iu+zF1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20A9F60A2602;
	Wed, 18 Nov 2026 16:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s+iu+zF1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 748141F000C4;
	Wed, 18 Nov 2026 16:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019372;
	bh=J/QXjkemFpbHJg6t9umPlHdCRl0rXdV7W+hoy3+PMgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s+iu+zF1WP3Jp8fhgZZ5vXO20WSpKsAnX6y91k26zSm2asfFhAhGEgaF00g6Qko1d
	 w8jeHw+o8aBunpORMWayCHIB4SdkdiYNjNXrdi54hJ6nD7Niv2CzDTLe/jjsQ0AaGB
	 wuietLwOz0PZ9uLxnxpR7ER6gV4z6mDdPIbEaQD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Jardin <vjardin@free.fr>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1531/2651] crypto: caam/qi,qi2 - set plain_keylen for skcipher descriptors
Date: Wed, 18 Nov 2026 15:46:11 +0100
Message-ID: <20261118150343.095290569@linuxfoundation.org>
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

From: Vincent Jardin <vjardin@free.fr>

[ Upstream commit b566ebd52eeb661337ef5f52a000528af59479df ]

Since the commit 66b9a095f7f9
  ("crypto: caam - Add support of paes algorithm")

The shared descriptor then loads a zero-length key and the SEC decodes
the inlined key bytes as commands.

Test: with CONFIG_CRYPTO_SELFTESTS on LX2160A every skcipher but xts fails:

  dpaa2_caam dpseci.0: 40000307: DECO: desc idx 3: Invalid LOAD Command
  alg: skcipher: ctr-aes-caam-qi2 encryption failed on test vector 0; expected_error=0, actual_error=-22, cfg="in-place (one sglist)"

caamalg_qi.c is compile-tested only.

Fixes: 66b9a095f7f9 ("crypto: caam - Add support of paes algorithm")
Signed-off-by: Vincent Jardin <vjardin@free.fr>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/caam/caamalg_qi.c  | 2 ++
 drivers/crypto/caam/caamalg_qi2.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/crypto/caam/caamalg_qi.c b/drivers/crypto/caam/caamalg_qi.c
index aa779caacfe59..2f2682c8bcd81 100644
--- a/drivers/crypto/caam/caamalg_qi.c
+++ b/drivers/crypto/caam/caamalg_qi.c
@@ -637,6 +637,8 @@ static int skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 	ctx->cdata.keylen = keylen;
 	ctx->cdata.key_virt = key;
 	ctx->cdata.key_inline = true;
+	ctx->cdata.plain_keylen = keylen;
+	ctx->cdata.key_cmd_opt = 0;
 
 	/* skcipher encrypt, decrypt shared descriptors */
 	cnstr_shdsc_skcipher_encap(ctx->sh_desc_enc, &ctx->cdata, ivsize,
diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index 6b47bcc16a506..d527069312851 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -961,6 +961,8 @@ static int skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 	ctx->cdata.keylen = keylen;
 	ctx->cdata.key_virt = key;
 	ctx->cdata.key_inline = true;
+	ctx->cdata.plain_keylen = keylen;
+	ctx->cdata.key_cmd_opt = 0;
 
 	/* skcipher_encrypt shared descriptor */
 	flc = &ctx->flc[ENCRYPT];
-- 
2.53.0




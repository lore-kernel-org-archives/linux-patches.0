Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016056;
	b=XYjeY600efBqoW3DNeTkyjZJmH4btN1KdZHCvgEjAyLGV+dHPlgVqhIg4tWy7xt6SKY9
	 Aeth4m8/kcpMUBC12+qPQnB4qBo/8CSc/clDMls7mL2l09IOti5BqZJxjPywPmOw0EJ4r
	 VTIdyN7dunUWBSFfRrra8py89dQOTJDYJpBTdOmcEFuspShev1ssf5xUagcWKBABjDuEO
	 vN5pH+yRFRLyJUX9odYmIigDwpvYfM/scP/s05a6/4imFBxOp5u4YNwtG+SHmDRQtXxYi
	 Zf0zahIkLKjfqSZ+HmFgITrSgAwOotAkCl9uXHzV+l9+v0tnChlVqpd1GkQzpkW8dpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016056;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=El9xHnt92zs/ZRbuocuVCFQjhGJ7Dgz0nN/P1KLND9M=;
	b=L2ehmu9OpBvbp/Jz87R/T7L8TO/QMWbu30q1pg53FZlOZcP31Q6Uw3psozjYYcscK8FR
	 LDNPk2GSG6U39dnRTla/CO5oOyCHxrHl43z73g0IOVW8ub+75CF7dm5dv2Tcc80YtRSXe
	 Nb54Ne01CwtUaMoCtpgVo80gB31DyeXRBPiNPF5LUtO32k/8kKHV5X0LB8hCQqu9Ozhoh
	 vEL1HesdWDKWsVjgfy7kO+tUuuoXYLcVV6nwxCQ3X72bB1Pnk130rc3Te4ikTTGYfHqMy
	 kEIfifW0RELXQ6B8n/z/EqLZeamnLtWuI5hX05db/DX1roGZNX7a/rcBVc95SzZdeMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YkHB8eOS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2772D606A334;
	Wed, 18 Nov 2026 15:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YkHB8eOS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77B341F000C9;
	Wed, 18 Nov 2026 15:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016056;
	bh=El9xHnt92zs/ZRbuocuVCFQjhGJ7Dgz0nN/P1KLND9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YkHB8eOSCO+Ywwd9Z85OEMtKh0Sf8aY0NVbUs0LG36/UsXT/02GrbtnjkYmaxJzqS
	 u5wFlaRv4GR89Igy9v2Sn7tWWA6DGuZTuQAwKayTwUVDTMFuUnOEjZaT6j1hpdT5TR
	 caxWfiug3cDHCXbxCQKSZ2vApc+GnX3Rpn2JZblQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Sudhakar Kuppusamy <sudhakar@linux.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0394/2651] crypto: rsassa-pkcs1 - reject undersized keys when signing
Date: Wed, 18 Nov 2026 15:27:14 +0100
Message-ID: <20261118150302.020758594@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

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




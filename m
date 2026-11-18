Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016059;
	b=GwGtR1jxvykqXnylQP6zcMYl9jChhEuAece+9QSayeVJrkyaXweHih2f5zsarSEy9X5Y
	 y5TyBICuIjoY3WQIUwHAkEf7e0uLI5qvOvG5NPA65vj22XuKuKVsVFmJKkURFjcwDg9yj
	 cuLNWkfFOcghhtMdWbmuP+v90z1OimCzB95jr5WsbBKNXw9OtoYAB+cTwho/vpBifX8gd
	 RAOC7UW/Zom6qJafzIHcZI++DN03OVDu4+uxZn6CjYE5x3CGIG4LD+Nynn6I0JPdXX7fQ
	 78JxNNgyj8OxEWjVscJJ29cNc4lWMptjn/NdXNnPMP94HRF80tQCbowPejGLwUCMyYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016059;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=TbPfgEKuBUgYp3m2tIT0c3rpTJWTPvp+mILAAD1m1S0=;
	b=Z8iioF5CMb/aziYot55+/8dRpdXjqL4rdO+8M1LSKCyzq7FIKj6IFnvfs/HR/GHb9QXP
	 bvuxS1nLY1FRC8zhI7AU4+wt4Pzb47K6tJi1Wzqxs1dECJqzzhVZ3bAA6tQ3ZBw9w9jFO
	 G/FgxOydEIGydOuHAUFosx7WMXYHQX3r4dGUSQWQy1CReXaK6yJg/jSYwzAJ5ga0vVCNQ
	 z1nR7XtufKqUsPhUL9ZyXiwfvhtciRuOUue05TT0n0YlNiMmonCcxFwVmYURLnycFZLuk
	 zqSn6KwFtfb7dlAZGVVa8S7bypcGKz8jN8ReRpHQdwOcjkWbFp9ZzWolEMPSUqTePjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sLG7CRay;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0753606A320;
	Wed, 18 Nov 2026 15:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sLG7CRay
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42E541F000C9;
	Wed, 18 Nov 2026 15:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016058;
	bh=TbPfgEKuBUgYp3m2tIT0c3rpTJWTPvp+mILAAD1m1S0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sLG7CRayyTcLXk6AWyz3vGzwdyQwfZF6iZTeKabzjokjSQYnc5+1ze+bwhz5iRDM2
	 3MROKGmrICA2/mn6l0DH2JhmW969fQLJwpUMkzpi5wTo3+EqoQsWH+x1gHsUBcy1FF
	 n8+eEbowpUQx0O3eB/2bYk3VmsDzwtfAvcmpyHY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Sudhakar Kuppusamy <sudhakar@linux.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0395/2651] crypto: rsassa-pkcs1 - reject undersized keys when verifying
Date: Wed, 18 Nov 2026 15:27:15 +0100
Message-ID: <20261118150302.057018154@linuxfoundation.org>
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

[ Upstream commit 364e520095b26fa551a8e92f52119d0f38a4177b ]

rsassa_pkcs1_verify() accepts any nonzero key size.

With a one-byte key and a zero RSA result, the leading-zero handling
decrements dst_len to zero and advances out_buf past the allocation.
The next out_buf[0] access reads out of bounds.

KASAN reports:

    BUG: KASAN: slab-out-of-bounds in rsassa_pkcs1_verify+0x79d/0x900
    Read of size 1 at addr ...
    The buggy address is located 0 bytes to the right of
     allocated 73-byte region [...]

Reject keys shorter than the minimum PKCS#1 v1.5 encoded message size.

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
index d0e4a885397f4..39137476ce818 100644
--- a/crypto/rsassa-pkcs1.c
+++ b/crypto/rsassa-pkcs1.c
@@ -231,7 +231,7 @@ static int rsassa_pkcs1_verify(struct crypto_sig *tfm,
 	int err;
 
 	/* RFC 8017 sec 8.2.2 step 1 - length checking */
-	if (!ctx->key_size ||
+	if (ctx->key_size < 11 ||
 	    slen != ctx->key_size ||
 	    rsassa_pkcs1_invalid_hash_len(dlen, hash_prefix))
 		return -EINVAL;
-- 
2.53.0




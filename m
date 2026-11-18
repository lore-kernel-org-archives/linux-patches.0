Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023558;
	b=zeGC9sCUVImXiRUaBcyzaiwhGiGXiyui1nkAcGnN93cll+5vYL1gFWPSFJ2BUWi4IWW8
	 A5AAaEGraITL3aOCtuZp1DeWc27j2mAtF+6ITLvh+4OzecI9wzt2EM5BnWvsakADFIvqa
	 NWJ5CUfm120K/Fn8CsdAavO/vppjTyphT61g0cziZorjKmMzqqeGXTpDI5JcREV41htZq
	 K4lFEk+oNSIPsvhDLsTGuxMOgFRAyPstCyMQTaclHBiPcXYrfGhVGuI7DbkXmwqm6H57T
	 QrwHwIoe9S9Xey7+7gv4z88EYsjGwqL4LI9zrNNjxTkL0LBBuNXZS8K2y7R0bUrnXng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023558;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=5aKBuJLNbgjMwSWuS9cmmNWZEI4z0hROuX5JrwO6PyA=;
	b=ZJpdDh3dHiq0Myc057rqF1M5LrZ2xyAOF+VCTT36n+TxqX432j47ryNtxJCSDuupPNYN
	 C465Q5NW9PAjqoytAQuKoKvqNEfJGKC5PC+6v9YbUR0U8NmPwcNc03115nxmkbs/0aVJ8
	 zklkHVaai5MSkVKLGXaoJ4ibUEjxjQsod8JBsWITmBYyWHZBh+HgL/9/kuxXPAqQorkim
	 91a7DpWh1FDPqRVlQ2/zxvm2KKTRncPF2ATecHMvL3J6Zgx5WvDnbgUXF+kj0ywWXNhAl
	 9dssEUJsjOhCQh9SS7g0jEKgc8yjBYW+ACobIhlAOUUPkn2odGxIIclFHJPnMtygs0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n2BKTeWN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25CF3606A334;
	Wed, 18 Nov 2026 17:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n2BKTeWN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 431201F000C4;
	Wed, 18 Nov 2026 17:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023558;
	bh=5aKBuJLNbgjMwSWuS9cmmNWZEI4z0hROuX5JrwO6PyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n2BKTeWN9xVdIAJzJqwMFgulwt1EvOpgH/q7U0+MO5uOsy0aOprhTRcBHoHhdQtfd
	 7moh0VTQwTFsu6JiLafJsh6l6Bu6E2NNq/8fYRvUEQ6cUGwa+f5OmcI/VQvcq59iA7
	 WuYyEPcuEz1mK/m4EXOzuN9/J7uVb09nsDQZsCBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Sudhakar Kuppusamy <sudhakar@linux.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0385/2151] crypto: rsassa-pkcs1 - reject undersized keys when verifying
Date: Wed, 18 Nov 2026 15:35:20 +0100
Message-ID: <20261118150136.099781594@linuxfoundation.org>
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




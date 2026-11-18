Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023603;
	b=G2wQBuBELLGSZuo6EbC22K6t4p8hYbyT6FlaXSnn84hSQ0l1jNZqPcXp6LuqcF3vlxnE
	 jIpvDxb6zg93dNPn0E5UFI8/sXmzr9F30xHr7F2KCn4AyW/0LZzaEVLWB3MQMJ/v6FCeT
	 AIp6cDTSxx/8oW6vQ8eHFWK3TeqBqIz3gekr8KsgRGkD2DGnN+ou0w6aRBN+fb9GlQnI4
	 ExLCW5YWuWb4VQ/IZAakiUVFxHHAdYAFiTGyOeqWLhzDWzZsksz7OvuFKRklXEBk9b5HI
	 vKGPqjhI3EpnuDcwr7Uzwu+5Wvt50C22R3j3luhxEp2KgFv1Jd6+EDZw3JRLou2FRBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023603;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Vr1SyBp79DVThLPX3QVrKuqOKR7N0BcrsanHARbp+DA=;
	b=bN5azT22rOcdkU+BsyJhYgDoowPu/03TWLl+/znsoCm6/Gq5gc9UEtx3dYDg9D3dA1x+
	 XqtkMdrFRZoGWbjhLqz8wwpCiF088phcX+Mrfd3Ll9+Jr+NTun9edl7fxNCPVgxS6KJTR
	 foCMGtyCRYu7z0nueSD8SU4J0E/+HkpiCn5DN09tl8R39C34Fw1yr7vbpMhvsq4UW1267
	 q8FlMAGKS/vZXFyTtPLR6ppuoc6Z9XPf00Pby9+qEHNvqIYtlezI/KHFIqzD5JMmN+2LP
	 /SL6P00CPri7kdpYjfwmOBWxyBE/oh+UYCw4URfDKUpqws+3MEVI5ayFELg9T5s+/gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qIpXAe0v;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9186D606A31C;
	Wed, 18 Nov 2026 17:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qIpXAe0v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7E131F000C4;
	Wed, 18 Nov 2026 17:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023603;
	bh=Vr1SyBp79DVThLPX3QVrKuqOKR7N0BcrsanHARbp+DA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qIpXAe0vHCru04a419rOp+6vAF0xrrIYSnbA5Rx6A7ViHKSrSmA0FFJ1hUxoVSIaQ
	 02aJ4OBBj5xElrzcTRqQjt88IFsPaS6ZjHnt962RIZPsLOHygvzcc3lO3v2O1ihFWu
	 s9Sqpqgyq5NNEvRbVPR9hKGr7uJICACacunUiDGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0387/2151] crypto: lskcipher - preserve state across unaligned chunks
Date: Wed, 18 Nov 2026 15:35:22 +0100
Message-ID: <20261118150136.169731325@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit ba871255f796d1f599ba710f03e1803d1b374a75 ]

crypto_lskcipher_crypt_unaligned() splits a request into page-sized
chunks but never sets CRYPTO_LSKCIPHER_FLAG_CONT, so a stateful algorithm
restarts from its keyed state at every page boundary. It also marks every
chunk CRYPTO_LSKCIPHER_FLAG_FINAL, which is wrong but harmless: chunks are
trimmed to a multiple of the chunk size, so the trailing partial block that
FINAL guards against is caught after the loop instead.

ARC4 is the only lskcipher with internal state, and cbc, the other
in-tree user of the direct API, never passes more than one block, so
this went unnoticed. bpf_crypto_crypt() however hands
__bpf_dynptr_data() to crypto_lskcipher_encrypt() unchecked, leaving
both alignment and length to the BPF program. An 8192-byte ARC4 request
offset by one byte comes back with its second page identical to its
first: the keystream is reused.

Set FINAL only on the last chunk and CONT after the first, mirroring the
progression used by crypto_lskcipher_crypt_sg().

Fixes: 0ae4dcc1ebf6 ("crypto: skcipher - Add internal state support")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/lskcipher.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/crypto/lskcipher.c b/crypto/lskcipher.c
index 091761d6ca0bf..b78522212ad53 100644
--- a/crypto/lskcipher.c
+++ b/crypto/lskcipher.c
@@ -75,6 +75,7 @@ static int crypto_lskcipher_crypt_unaligned(
 	unsigned ivsize = crypto_lskcipher_ivsize(tfm);
 	unsigned bs = crypto_lskcipher_blocksize(tfm);
 	unsigned cs = crypto_lskcipher_chunksize(tfm);
+	u32 flags = 0;
 	int err;
 	u8 *tiv;
 	u8 *p;
@@ -98,13 +99,16 @@ static int crypto_lskcipher_crypt_unaligned(
 
 		if (chunk > cs)
 			chunk &= ~(cs - 1);
+		if (chunk == len)
+			flags |= CRYPTO_LSKCIPHER_FLAG_FINAL;
 
 		memcpy(p, src, chunk);
-		err = crypt(tfm, p, p, chunk, tiv, CRYPTO_LSKCIPHER_FLAG_FINAL);
+		err = crypt(tfm, p, p, chunk, tiv, flags);
 		if (err)
 			goto out;
 
 		memcpy(dst, p, chunk);
+		flags |= CRYPTO_LSKCIPHER_FLAG_CONT;
 		src += chunk;
 		dst += chunk;
 		len -= chunk;
-- 
2.53.0




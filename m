Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016064;
	b=JrEqWHGcWVnk8HoIjr6znTsRnxt0ilDIHlzE6/r0ABnh2RhTEHJJcc6Q2CMVppUbtKmG
	 rzREbA4IsmMsa7E6H1TCEUo6DhD/gBMT1eV2qyM78OjMcWiPVmIqIYS+EKNKvTqcEBUdP
	 1BPtaK5nk69I1ejGbnB1TPq1Ubo3FchJa6iLMeEKv7Uc8yJK+ZAZfoPw3x1H0WwRz/2QU
	 uvQ3fZZobQqdz1Ur2hp/ITUbI/goWM/pIsh3nD6beOsLQDv7F4M3iCx1oCnYqH3h0z4wb
	 dF6JZ03UCRhDGd8ChyxyAdJItFXECpwpbSQ5AEmJxNUn8FGZ6F1+P2ncuuKjVltGs7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016064;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OeWsqBn5muqXnmjhzO7W0i9bV16JrWugs4zlRTrJMPM=;
	b=XYdeXx3l4OJoMOq0hCD0qByieIdSygzE1t8Ut5f9Ki3LUjD+TyOMAiKN412gPqKxz1MU
	 ZnOMDdZ6McnDwRFhXA4RW4REWus24BHR0evTv1E42ZMEMPGVTlsDmFBadHsm3fRWUane0
	 Wlqt3qw5tW/TvJCGRUS0UcobSdSqtvkg2bUMfIH9OI2d+nKjYfRbRJx9GgxjiJBXx4Rz+
	 vjdP7moO54eNQLNt9P8yHvE3IytNxUPJK3NAwFZm3iv7GJ0884LzcRFPRfakY3WVY8cZp
	 zVlfdugYfrfwvnRohNU0p/b7seRvVjbjVUe9AeTnBE+72TXYJAeelH2yvbX5YCO5dMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VfkPfCYf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB03A606A32A;
	Wed, 18 Nov 2026 15:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VfkPfCYf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECF7A1F000C4;
	Wed, 18 Nov 2026 15:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016064;
	bh=OeWsqBn5muqXnmjhzO7W0i9bV16JrWugs4zlRTrJMPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VfkPfCYffp+2byhVgkujNh6F4cjWrRIGU9kCdp2MhQe0IVIUEnW99ERvaOOa0KSFd
	 /U2MaS/Par0w2qKNY1YxAdTCh0WyVP4RMgRW7qK+hf+3Bd0tdWXUSqmCAf+HPiZtxG
	 EoJZfLB+w5zF+LNrx1ST/Ebbjk7sWihciBy60NcA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0397/2651] crypto: lskcipher - preserve state across unaligned chunks
Date: Wed, 18 Nov 2026 15:27:17 +0100
Message-ID: <20261118150302.129838601@linuxfoundation.org>
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
index a8b07594005db..6c30436a11354 100644
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




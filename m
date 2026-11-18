Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016892;
	b=AQROTRFcL4/uyOQ8Zxkp/JRPnlnevQNJ/fZbZzDLzUVgLR7WISfnZLHlAdyd3kvAFgan
	 iAFOe8LasSvE8fB8w1JE46tV2lut9dvPYFNmAF9fTtnllv/7w0fOMROSJki9s9UH8vdkA
	 bUa1/Mrj7lBzZmAiJ3fgMk2tqkFqP2oNbgESi2jX3blFdAyUqNcOyZ5Hou4vp5/dRR0CT
	 J0uBkn4W/6FtySpgbNOarrWZxIg6quraSmatVIDexFH3ADvtgYo0YPnLDb90rBBibafA5
	 j4FN9kLj1r91OtWbFvRUEaetRaetxcjtHc74yca+VBaT1DZ0bE8ipHOr5CjNEuS8SCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016892;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=wOayBHYz97Ksu5FFHfyN7m0VekMvHcraZkTgJfWkZP4=;
	b=1/q0e08AZ1kCSOL6hNFCYWz+H98LsukT3KfM0xkx5riXBt3rNq6GgNCAc+MdZS/ccgCY
	 4Jgy0o3CpCEjAthaeCnW9cnjViPdBB4iD0IXYfNh54dIaw8Hsscn92VKISXlrzqQVxzBO
	 MAVIc2QPvTM3gAF9QrC/kErZ3K2BdHZRmHLQkdhRNMmIp3ew6zquVnmkOM8fL7f/2i0/F
	 HMuv/iLu9cmYMZqjVlAEZDp3xkPmw19CwhyyuUfGF/IEpRX4p5VYbJRz8ongKtMaBnYWN
	 +szAQqBFzoCrccWta5BlhqbDR4ul4N15txhZwC75S3G8iBkij6OrWZzTOl0G4bY+GYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jfofmQvp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFC97606A320;
	Wed, 18 Nov 2026 15:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jfofmQvp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3303B1F000C4;
	Wed, 18 Nov 2026 15:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016892;
	bh=wOayBHYz97Ksu5FFHfyN7m0VekMvHcraZkTgJfWkZP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jfofmQvp36T/ftBckBn+31wP+U/ZiSujAO/Q48Ysog9ZIGx9v9UYfa7mZUaRkq8OG
	 3no45Lvmxy+wqf7plBt1Vipxqqt/ReEcxEXBQkijhk83XI/EMeo+U9dpWrd7CuZlit
	 AgJ95wxu7REGk640AF6+RMsYsmAEaHA1pqxK9m40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0688/2651] crypto: asymmetric_keys/x509 - copy X.509 TBS for data signature algorithms
Date: Wed, 18 Nov 2026 15:32:08 +0100
Message-ID: <20261118150312.622033807@linuxfoundation.org>
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

[ Upstream commit 2618f76b277cef3df8ebdff403b05705f5f8a36d ]

For signature algorithms operating on a message rather than a digest,
x509_get_sig_params() points sig->m directly into cert->tbs.
cert->tbs is the preparsed add_key() payload.  The syscall wipes and frees
it on return, while the instantiated key retains public_key_signature.

A later KEYCTL_LINK into an asymmetric restricted keyring therefore passes
a dangling message pointer to ML-DSA.  KASAN reports a slab-use-after-free
in mldsa_verify(), with allocation and free provenance both leading to
__do_sys_add_key().  Reuse is also an integrity issue: bytes occupying the
freed object become the authenticated message instead of the certificate's
own TBSCertificate.

Give the signature object its own copy of the TBS, as is already done for
a precomputed digest, and release it through the existing m_free contract.

Fixes: f3eccecd782d ("pkcs7: Allow the signing algo to do whatever digestion it wants itself")
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Assisted-by: Codex:gpt-5
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/asymmetric_keys/x509_public_key.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetric_keys/x509_public_key.c
index 25cf8ac7f2579..5c9165a83f914 100644
--- a/crypto/asymmetric_keys/x509_public_key.c
+++ b/crypto/asymmetric_keys/x509_public_key.c
@@ -53,9 +53,11 @@ int x509_get_sig_params(struct x509_certificate *cert)
 
 	if (sig->algo_takes_data) {
 		/* The signature algorithm does whatever passes for hashing. */
-		sig->m = (u8 *)cert->tbs;
+		sig->m = kmemdup(cert->tbs, cert->tbs_size, GFP_KERNEL);
+		if (!sig->m)
+			return -ENOMEM;
 		sig->m_size = cert->tbs_size;
-		sig->m_free = false;
+		sig->m_free = true;
 		goto out;
 	}
 
-- 
2.53.0




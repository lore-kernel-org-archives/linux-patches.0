Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619853;
	b=ue7lJvGgu/D9qY5CeqAOe5ofItfi6x9nKpsnSAPZu4zmucq2s40O/cjf0ul1uFUQpxTf
	 7lSdgz295NAK04xFcJIl8VO7g1fL5gya1TdVqnSYirmGjWqkNO9UyWCWkPnNlQKX/EGJ3
	 /HsAK2s3UCnQAyxRjCSDJJTiC/JNNU+vdLnhEe4vjf07aSRYz8N0Owcm9EzGdGA1Rjqbo
	 R47i2krYyFLsZK8m5lXMkn2GgCYkMPCSrZuqLF3RS4trsLh5EqgwUYz43wZmkKoWLh2q2
	 ROW1qeghDN67g7jl0SdXGYDoB1SFVF1md1v6zH3+mFj2nLp5xeKd14bNoLgFF/cSHAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619853;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yJ7hwhF/+/zcZ+SqT/OKB4SFTJegHm2jwq+dpyyHHpM=;
	b=Ptu8ctMisHd5tC6GUcGt1S4QYQHi/uLhymUm4QrIQLc3bi1VKiJEstCCXFx6sfMAfyEM
	 dcoj9qCVqzO+O++oVPDemeQAMR15P00rjJ+gC2VuOVPjhtsQOVb89Z9mwwHosoMKJj060
	 pP5aw/ttaZvaP5XvvQ7KFZtQid7ZXEEHBTN4aua5tfsU++hR56Tju1jTYTuqtHP5gebND
	 RCNg6sSs7Ys0vyyTx0L40dLTsM0FZrJShT6bNiNcTLw4lY5SScgZdanzWSNLgRuMNHHRk
	 oaX+LrA1nNVKge9Y3VbQT+8cZu4rM4aEGJXSt0Yh4L8mGqLnEmLryqeZKaJ/24VJYCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aXANIdrA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01890606A326;
	Wed, 25 Nov 2026 15:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aXANIdrA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D5861F000CF;
	Wed, 25 Nov 2026 15:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619852;
	bh=yJ7hwhF/+/zcZ+SqT/OKB4SFTJegHm2jwq+dpyyHHpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aXANIdrATQgGLwngAHKy8iCq3MfubPhxEGjHcnl3/o2M74qFN36yLDiuhAnN0j82D
	 xe7ofizPnHzJLWCpIT2W05U02NR9JZuU9fqCBJsgbmUeYjFlgND7vQ+FqnovR+W1TS
	 jLDwq9DlPQU9/C2sWBcRwMN1/8lx/WfXyFTXBlp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 7.3 0727/1005] tpm: Check return value of crypto_kpp_set_secret()
Date: Wed, 25 Nov 2026 15:34:25 +0100
Message-ID: <20261125143838.792303297@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Eric Biggers <ebiggers@kernel.org>

commit 8cff8f1c89d33e55c9af82177b14f6f9f6a899fe upstream.

crypto_kpp_set_secret() can fail, for example if the kernel is booted
with fips=1 and the broken-by-design FIPS RNG used for ECC private key
generation doesn't feel like generating random bytes at the moment.
Check for error, cancelling the TPM session creation rather than
proceeding with a zero or uninitialized private key.

Fixes: 699e3efd6c64 ("tpm: Add HMAC session start and end functions")
Cc: stable@vger.kernel.org # v6.12+
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Link: https://lore.kernel.org/r/20261025211119.138277-1-ebiggers@kernel.org
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/tpm2-sessions.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/char/tpm/tpm2-sessions.c
+++ b/drivers/char/tpm/tpm2-sessions.c
@@ -527,7 +527,9 @@ static int tpm_buf_append_salt(struct tp
 	}
 	crypto_ecdh_encode_key(encoded_key, buf_len, &p);
 	/* this generates a random private key */
-	crypto_kpp_set_secret(kpp, encoded_key, buf_len);
+	rc = crypto_kpp_set_secret(kpp, encoded_key, buf_len);
+	if (rc)
+		goto err_free_kpp;
 
 	/* salt is now the public point of this private key */
 	req = kpp_request_alloc(kpp, GFP_KERNEL);



Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030574;
	b=aAZVoi3+hbTmokgNkB5qddFXDTdbDocIMSz2ZWKIRjs+p1dkxgHyr7GmAjDluyjhqmHb
	 xTQduwvszmN61dKAsAGCGNOG2/75e05jP0LZlzJtY6LZlzZkxq+YHlBrrIHdwbiz3S8EM
	 QDuCPbK04IHaK0wmhnvT37M26g1qsED2IDRJc0ocsvh16TqOKbIP5+DotUVHxoMBUa7bW
	 rMxKfI0vmGLWMIRwBJ++BTGd5/iz/SW5CdN+hD/kVI/gr4+XJIC6L7tmL9nAQ3SLm911z
	 9BoBgLNCcLEBu3BwFbXN0nPgDCZeiKDO9coeExTN5nXPmXfxbkt77Pw1inNVePE2jAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030574;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aUbzB7dIwItDyKwaS7kPjUhNAENaGi3J6QfVPHp8p68=;
	b=PpNHigqPljyugl/ZJfv401d8vsICeo8cS5thrAxkmMMColizixTDFbPoRUxHgRieKvpR
	 4Se28wmRH4XTbqUS6URXCEiC4LrhfCB8rXh7m7Jiwwc6XenT9KYfd3alDe/XCyXr6ZAyk
	 piKwBA1MBJFBnkMYimXRhyx+Fkuq/ruCAnrxNEdf2ZJ0P+dex3vttpUgE3QK+Riv7b84o
	 oS4WiVo2mjFVNZSmUO9H+bUTxap2AT4sUe5uBt9O5UvqImetzkPDWSoKNRPKCaHFXmAZl
	 JzpoQmRqYwYOO1cOJbS0x+CqLuK8yQLdqiUfj3/l1oFtIQJ/NmdQINSygvmnb3uMfwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iXFOASKb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD76C606E7F1;
	Wed, 18 Nov 2026 19:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iXFOASKb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D71811F000C9;
	Wed, 18 Nov 2026 19:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030574;
	bh=aUbzB7dIwItDyKwaS7kPjUhNAENaGi3J6QfVPHp8p68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iXFOASKbZJEqLPLnza/GscXJYtLKaLdzlb7LpF6miT+E9LI1mwcHtEzUhFnPoIJnk
	 PSKzRwTMeK4dKRhxZ72trH3tDliEpcWBvYobSs+bFMrsT5mRviBhcMIx831sKy7q72
	 Ba4eZeeW4lwGxDCp4akNfT8hctQGgXlCApZ75xzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0754/1756] crypto: atmel - handle authenc requests without plaintext
Date: Wed, 18 Nov 2026 15:48:01 +0100
Message-ID: <20261118150039.670467429@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit ccbd95b3efbc0580b6abde2a905823417ca56022 ]

Authenc permits a nonempty associated-data string with no plaintext.  The
Atmel driver accepts such a request, has SHA process the associated data,
and then unconditionally asks AES DMA to transfer zero bytes.  The Atmel
DMA engines reject the zero-length descriptor, so the valid request fails,
normally with -ENOMEM.

Skip the AES transfer when textlen is zero and proceed directly to SHA
finalization.

Once an HMAC transform has cached its inner and outer states, SHA can
complete this path synchronously.  The forced ahash completion callback
then invokes the AES finalizer through a void function and discards its
return value.  This loses -EBADMSG for a mismatched tag and reports
successful decryption.

For synchronous SHA completion, release the SHA device without invoking
the ahash callback and call the AES finalizer directly.  Its result then
propagates through the synchronous call chain.  Keep the existing callback
path for asynchronous completion.

On a SAM9X75, the unpatched driver failed valid AAD-only requests and
returned success for a bad tag after the transform had been used once. With
this change, bad tags return -EBADMSG for both fresh and reused transforms.

Fixes: 89a82ef87e01 ("crypto: atmel-authenc - add support to authenc(hmac(shaX), Y(aes)) modes")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/atmel-aes.c |  2 ++
 drivers/crypto/atmel-sha.c | 14 ++++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index 6a29656f3951f..5b6f594a3086d 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -1830,6 +1830,8 @@ static int atmel_aes_authenc_transfer(struct atmel_aes_dev *dd, int err,
 		dd->is_async = true;
 	if (err)
 		return atmel_aes_complete(dd, err);
+	if (!rctx->textlen)
+		return atmel_aes_authenc_digest(dd);
 
 	/* Prepare src and dst scatter-lists to transfer cipher/plain texts. */
 	src = scatterwalk_ffwd(rctx->src, req->src, req->assoclen);
diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index 06c91b0bbf22d..2494a58b437a6 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -2393,11 +2393,25 @@ static int atmel_sha_authenc_final_done(struct atmel_sha_dev *dd)
 {
 	struct ahash_request *req = dd->req;
 	struct atmel_sha_authenc_reqctx *authctx = ahash_request_ctx(req);
+	atmel_aes_authenc_fn_t cb;
+	struct atmel_aes_dev *aes_dev;
 	size_t i, num_words = authctx->digestlen / sizeof(u32);
 
 	for (i = 0; i < num_words; ++i)
 		authctx->digest[i] = atmel_sha_read(dd, SHA_REG_DIGEST(i));
 
+	if (!dd->is_async) {
+		/*
+		 * Return the AES finalizer's status directly for synchronous requests.
+		 * The ahash callback cannot propagate it.
+		 */
+		cb = authctx->cb;
+		aes_dev = authctx->aes_dev;
+		dd->force_complete = false;
+		(void)atmel_sha_complete(dd, 0);
+		return cb(aes_dev, 0, false);
+	}
+
 	return atmel_sha_complete(dd, 0);
 }
 
-- 
2.53.0




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018193;
	b=Lj0fqRWp7dMLsCWmE3ScjOTcTE1yIR4rENLmrJn5/N7fpbXvzaWve4q7xS+Exx3QIffG
	 q543QV6dnfkUvofK/NrYghB1U57ogs5HhzDNjAU5WWIdgxWesqw/7JdE5GHgreFJzIxdv
	 ZygdwyvezM6Qn2hdBPkxv9KmAcuxs4Hce0F9z2fsw16WyXceSV+RusiWVv2ghOUyox4kH
	 bn0j3aW16LWYt22Nykewq+sV7rzwDdVMB9qjd02lYkqyDtz4PBmx5Nv+lAXVwdU6kvP0v
	 qDDZ8R4uT5y9/x/+dmijBWtMJYX9TvK9fq5CsPEhMJRFgXGCkW9xppyzSpQohHDccQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018193;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zbSnCNeI6Xt/qcQT1OWkbIGu2GFFEWXP2+ycw3n2pgM=;
	b=g1wz0KB8805jH5WkBmNB1UdnSGHPMCVMzCRomU6e8Kdf60A1bj3iJZro4sL6DiR/hyTQ
	 /HguV1F6DnY4hMFsGcjYPokKODsxKL4tZaaC5ewvpkLwnP5+Z7nGNzUcPC8vAf+9G+sMQ
	 hHMGpevTqA7xwYfYOZnqHFr3w9kTlvF0CEgDSgCme7zHqq3FBCDDyoPuQb5JOyyyThOv1
	 eny8Agk14iyq2yBN5Y5t53VRjUvsOkxkf6WsWc5jbaADfBOrc0nP0P/4VpFMOlOfiuORJ
	 wuzeNIf4jWVc+/8Iq8PywOleLduQYssdx/sGmHoOqb9htUXeO8zLrzvGadfqGQxurMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="XO7b/9hx";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C154C606A31C;
	Wed, 18 Nov 2026 16:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XO7b/9hx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E78E1F000C4;
	Wed, 18 Nov 2026 16:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018193;
	bh=zbSnCNeI6Xt/qcQT1OWkbIGu2GFFEWXP2+ycw3n2pgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XO7b/9hxICaDXdNTy9F0UgYDXCh5QGzT6uhpddnpHzufvSpKftks1INitXUQCA+qv
	 N1yf0gRymdUFuSW3qmaSEaC/r1cUV0mN2EjxfU3oyBWx9Em6rm3QOVmRHnHFX5gRLy
	 loL1jqOoK9M6b2txrnErN9m7fFK8jUG9+OjWNLQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1153/2651] crypto: atmel - handle authenc requests without plaintext
Date: Wed, 18 Nov 2026 15:39:53 +0100
Message-ID: <20261118150329.517662383@linuxfoundation.org>
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
index 8e4de859cadc0..84392411b98d8 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -1826,6 +1826,8 @@ static int atmel_aes_authenc_transfer(struct atmel_aes_dev *dd, int err,
 		dd->is_async = true;
 	if (err)
 		return atmel_aes_complete(dd, err);
+	if (!rctx->textlen)
+		return atmel_aes_authenc_digest(dd);
 
 	/* Prepare src and dst scatter-lists to transfer cipher/plain texts. */
 	src = scatterwalk_ffwd(rctx->src, req->src, req->assoclen);
diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index d2338e731d566..0e16609321f18 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -2386,11 +2386,25 @@ static int atmel_sha_authenc_final_done(struct atmel_sha_dev *dd)
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




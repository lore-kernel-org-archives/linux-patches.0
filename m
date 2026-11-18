Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055639;
	b=Fbu5JM0q4oJgPbb4+c/sd88DxQNgr4oG6j9zofJKid2V3SJ3ZEp/SEgro5I9aQvDeNGM
	 lWCwrFiCOQUzyS6MJxNqGZznQ30oE1xLdz522hpJGq9EwJEhQnTi2imoy/Cppu3rjKKlM
	 ugl8REc5n8/1B0hRPDbPqoAtRX8blgYdVzgCojiqRb3Zjo/Qoi2mhKZISo/r4/7kJ3gcI
	 vFKQPOkOe9m7pMhsxmDJsrmWG9pCHdOGUHpvLdYh+5Riu/36v3s2PVrJth3PKRG/WPV8+
	 zaOq1CBbBpdzqyXR9oYk38Uy0vjsWW/T3Nl132ZpMZjJLJlmxcCgGnQu0UEmdiGZOEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055639;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=r5WsUvFNYoHLLTAT0bpNDaeH+YM8EAJhhCPLZqqBq4k=;
	b=uHMoTeGuQzc+qJkR/lS2F2aA93cqThxGRChl/YtK/a2hKXJf7Zudp8XBxoxBYWA0HYG0
	 uaHPRDItgr6LrjHQ+TDYPNksfxbJOAkxCS7U4QlTFpuNVuhIVgpWtJiDcshjD1QbPcP42
	 oQQ2L8O9hJkw3oDuLmKeW4ly2wH9e4t7Uh4vQG7+g4Yhf1ptoxlolDNA5KdShCWHaohpJ
	 2QGxGdpqup9dR370m55ZHKNK6V0ON6f9LH27opiMEk1guv3677DPzSoMb37SOCwXFidIj
	 kkOYA/g4G7PlgPKexA4J6dVMBG6pu7EhJmsXr2hLcLaXNEGmTo6PygxifHglRumvkhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T0w+h+q6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 831D1606A31C;
	Thu, 19 Nov 2026 02:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T0w+h+q6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D45E71F000C4;
	Thu, 19 Nov 2026 02:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055639;
	bh=r5WsUvFNYoHLLTAT0bpNDaeH+YM8EAJhhCPLZqqBq4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T0w+h+q64WGAr0WKfSoFPgR2f+oeFKLmkdeS5A9eI4wa29bckip7/i4+YwQX0wk+2
	 7O2lsRnZO3FEkama8bCJ0eyX9nlv51w0N4k1b2TZN552TEx/zHSQAHN38KKh7SKLgJ
	 Q+0gf4KA1Ak7MCwOUHdu9HWu+D5qH7kcw1T7fgpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1703/2214] crypto: atmel - handle authenc requests without plaintext
Date: Wed, 18 Nov 2026 15:56:19 +0100
Message-ID: <20261118150119.920337672@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index d18fbb401375b..afb4f21f6ab0f 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -2029,6 +2029,8 @@ static int atmel_aes_authenc_transfer(struct atmel_aes_dev *dd, int err,
 		dd->is_async = true;
 	if (err)
 		return atmel_aes_complete(dd, err);
+	if (!rctx->textlen)
+		return atmel_aes_authenc_digest(dd);
 
 	/* Prepare src and dst scatter-lists to transfer cipher/plain texts. */
 	src = scatterwalk_ffwd(rctx->src, req->src, req->assoclen);
diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index 6eea72ed92669..652d5d0c9fe08 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -2369,11 +2369,25 @@ static int atmel_sha_authenc_final_done(struct atmel_sha_dev *dd)
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




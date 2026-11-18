Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016044;
	b=nIW+oR2MsZwCbJaTsmf+cfPQ+UgPVRFfTCcjxBXGLK0TL7RqyDL7DLeFTsdOXva0y7rP
	 giXagW3PDyibT/O12xmTJUQgZt2YuRyY1c95nZYqYFNglnwauZu0T4Zs+scHblcb9k/Q0
	 kapFilLSIipq9WQ9siFvQDcVRVzpR6wHO96EVdpVofLDxsSwBV2Nr3txLhJ8z4rF8t7/R
	 73np2SXSkJoJaizat3VVH5fOb7NY3iT5+qbz9MuW66dtNpnMGQQJRO2HwM+xsUanU3XFH
	 WAJn27rELt76P8XNsCtQhnqCBRp43iGGhGJzL88NvpB2I9YykXVbquVrOAFSfqGSjxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016044;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=I0zZGKFZBAQlfJ5slgnQdkcsz97+p+P0L109uPVgRK0=;
	b=ipV7nr/RHwyeh4J73E/21+f99r+sWC0aawxMnpmdICljuhioGd/E87t8rIuteZ34maXK
	 mb80xaWURd87gmh72DWcuYt3OeQk2ShFfCvGTfE2wNDgkhbAYlMMArJgmjJLTwhPlGRSv
	 zqtaxaz6cUEG8wJZdFX3BOsmA6MMqZytZaFSUbvX+NeKfCJc6Zx+dm98OR2xPPAlYmMCW
	 BWSiqiQty82RB4CvPkTcX1NfIbzV4gJlYFZXsbT8a9Zf3FCz1nPSAuGf90hnr91QJBecN
	 SRENhq9DAxiN+qAW3oEJUWMlarJYyAdTQUCO7QGlQBVBxA9X1aMCnpJTHy+QDraRCHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="U8RjG/kD";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B55BB606A31C;
	Wed, 18 Nov 2026 15:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U8RjG/kD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15FBF1F000C5;
	Wed, 18 Nov 2026 15:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016044;
	bh=I0zZGKFZBAQlfJ5slgnQdkcsz97+p+P0L109uPVgRK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U8RjG/kDytdKL3v2a87XMc60IyH/i19PRaZyY2txYpMl2Ardfg6Zju/FhLvPT1G2k
	 XrNiihmWUWJBMZyJWEf3SmkQbAFjzyK2HcaPRA8lDEzJUlGu7K6zlbo2Rnnjxj4R/0
	 AL1VmdnnF1GRa5Iftu0xBRInCc/ZL0M/C3Hljx8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Antoine Tenart <atenart@kernel.org>,
	Thomas Huth <thuth@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0390/2651] crypto: inside-secure - Zeroize temporary arrays on stack with sensitive data
Date: Wed, 18 Nov 2026 15:27:10 +0100
Message-ID: <20261118150301.876835369@linuxfoundation.org>
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

From: Thomas Huth <thuth@redhat.com>

[ Upstream commit 5c87bcb2f98dbfe08efa016af037b0f9701ba381 ]

key_tmp[] in safexcel_xcbcmac_setkey() and consts[] / _const[] in
safexcel_cmac_setkey() contain crypto key material that should not
get exposed to the outside once the function is done. Scrub the
arrays with memzero_explicit() to avoid that the data could leak
via the stack.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20260813134953.979481-1-thuth%40redhat.com
Fixes: 38f21b4bab11f ("crypto: inside-secure - Added support for the AES XCBC ahash")
Fixes: 7a627db9cafdb ("crypto: inside-secure - Added support for the AES-CMAC ahash")
Acked-by: Antoine Tenart <atenart@kernel.org>
Signed-off-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/inside-secure/safexcel_hash.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index 3402e570d045c..7c68118fbb05c 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -1993,6 +1993,7 @@ static int safexcel_xcbcmac_setkey(struct crypto_ahash *tfm, const u8 *key,
 	ret = aes_prepareenckey(ctx->aes,
 				(u8 *)key_tmp + 2 * AES_BLOCK_SIZE,
 				AES_MIN_KEY_SIZE);
+	memzero_explicit(key_tmp, sizeof(key_tmp));
 	if (ret)
 		return ret;
 
@@ -2104,6 +2105,8 @@ static int safexcel_cmac_setkey(struct crypto_ahash *tfm, const u8 *key,
 	}
 	ctx->cbcmac = false;
 
+	memzero_explicit(consts, sizeof(consts));
+	memzero_explicit(_const, sizeof(_const));
 	return 0;
 }
 
-- 
2.53.0




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622358;
	b=uLmBHeRZbO8b8aG2/65/5OK8QDU70wvNpUIXAecKMCwjGqPF92oVw/sZYk0NGpGiWnfy
	 84GlaqGjv7c+8zgoyLL0ITOLYp6pW1dFPJwfDU1IWXWZQjCao4bA938igpLOSwu+70xcK
	 B/Vymd0pIxH8Yo0RFfoP5L993zxyCYxq7GjRNjV16Lzfg4L4Y3idgDYurYop9LHOItSL0
	 6+rTBCYVUwM1aj+caUi92+HI1U7HCdKov7iO8ZbdhZmkalvheMJ2a8TJIoP5TfqvL8mAQ
	 +d7jH2epc7AQ0kUH9vwYL2/t5e7kbwPI5ntTTLzkh8vArneQvRcTlRmP4dXaJgWJZnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622358;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KUL185YRmOVGCmge8HThYDsvrRcpyRv6fmf7rg8m3Pc=;
	b=ohSVt6Htpns0HD8gsxL9tKspoOMwd8+uzfP+jNSIZ+/o1uoRKf78jd5Z9cLnlE8QtFBK
	 2TCLVgi1j9Iq2K/207z6iOPN6NvsHF8xTay8aEG8fe1i5zqi49HyZgvCbQs7+rIjpvxv5
	 KXccv9QJ/sinXpwF3BRKNUq7NrtT0pWRw5tAJCWXC+P8cxegpa3DkIqIU+FiWUizWSTaE
	 Wv/AorjPx4mACiESPBjDKtUctCGvklA8nCsgUij1jiICGtPh7fnPeq+qoMR+Y8IvxFomZ
	 OpM1hXkUDZoi3O0emUhtPpagGRt2zIY8p/+J6iF2O4PPihdmSuXd2Hn1xuZlbwh4+zw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Nl0aMGfG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B6AD606A31E;
	Wed, 25 Nov 2026 15:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Nl0aMGfG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 841281F000EC;
	Wed, 25 Nov 2026 15:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622358;
	bh=KUL185YRmOVGCmge8HThYDsvrRcpyRv6fmf7rg8m3Pc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nl0aMGfGeG1b4aDTIZF1DiZ37/o2JA2tSbBJ9322yWaqnMitOz/gI1evDlS7PX/4P
	 5c4mFT77zjWDUQ0kyMD1nO8NjEWKDFSnKrnyNj55xyOs8dogESaDBdO/QmPWygxhWl
	 W+f9SitU47E0G4BO3pdL4ghqt6e7i17h7ediXfXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Antoine Tenart <atenart@kernel.org>,
	Thomas Huth <thuth@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 513/990] crypto: inside-secure - Zeroize temporary arrays on stack with sensitive data
Date: Wed, 25 Nov 2026 15:31:20 +0100
Message-ID: <20261125143834.115067632@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
[ sashal: Context line uses aes_expandkey() instead of upstream's aes_prepareenckey(), since the AES library rename isn't in this tree; the added memzero_explicit() calls are identical. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/inside-secure/safexcel_hash.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index ef0ba48329281..7231e9773bde8 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -1993,6 +1993,7 @@ static int safexcel_xcbcmac_setkey(struct crypto_ahash *tfm, const u8 *key,
 	ret = aes_expandkey(ctx->aes,
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




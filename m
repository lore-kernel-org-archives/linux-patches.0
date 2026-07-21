Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AECA46EF88;
	Tue, 21 Jul 2026 20:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665391; cv=none; b=rZS/UTjboCkyP+JttqAxRvVLBMWe86G1XU2md0hloDEm2Ek/dl9TbfYxuM/5+Z4XbcKIUvwF4cdk+273psk0OBQaxonGIe5h053cKcgttdX4lVC+32Ke9kyWN4f1/G0KgUvfiqvuJfSVeM5DrBZpH82Ft0K3gCDsW2QNRoxRtV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665391; c=relaxed/simple;
	bh=rfW2SPTsc73AlkkwgsCWPkQGHe+QzpwWv+Aa5wiR6Nw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eFdwpGWdSxQZjIRSm+TWAuvvU/rPWMjCnqh+C0OD7Hp+DMYcuw2DlkOH5p97VD3rVyUn1OVg5juptFFG6B9Pk271NCtkf9kk8A/jje9Nc7O7gm7eF8oxBvnMI2f16nM1LFrnH2VgBtpCJMWWeNPmQs5OfyjTdjICWnjqKlhRTlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XMqPe6Mg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XMqPe6Mg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0CE11F000E9;
	Tue, 21 Jul 2026 20:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665390;
	bh=0pXRXhNGP85XUHSW1uPAiOPOQX55uL8qHrAy2w7giNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XMqPe6MghzbrtL8Acc4o2S32rveIllALV47F40HMbkd+/FX6r6CZ24R4443Ugwj1o
	 zAu2sCyfkeEdlvR3MvmFY9AlB2RaKlljUo61yZn0NmBIHfgxqhhK1M7H+uQQQJjtzd
	 ORL8Qfx8Cxgu6VA9AO+LLu3M1GWl8QdOhS/IuFaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Louvel <paul.louvel@bootlin.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.6 0287/1266] crypto: talitos/hash - remove useless wrapper
Date: Tue, 21 Jul 2026 17:12:04 +0200
Message-ID: <20260721152448.247667441@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Louvel <paul.louvel@bootlin.com>

commit 907ae6088c82c9abae2d26477fddd60df6ad003b upstream.

ahash_process_req() was a wrapper used in commit 655ef638a2bc ("crypto:
talitos - fix SEC1 32k ahash request limitation"). Rename
ahash_process_req_one() to ahash_process_req() and remove the wrapper.

Cc: stable@vger.kernel.org
Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/talitos.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -2003,7 +2003,7 @@ ahash_process_req_prepare(struct ahash_r
 	return first;
 }
 
-static int ahash_process_req_one(struct ahash_request *areq, unsigned int nbytes)
+static int ahash_process_req(struct ahash_request *areq, unsigned int nbytes)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
 	struct talitos_ctx *ctx = crypto_ahash_ctx(tfm);
@@ -2084,11 +2084,6 @@ static int ahash_process_req_one(struct
 	return ret;
 }
 
-static int ahash_process_req(struct ahash_request *areq, unsigned int nbytes)
-{
-	return ahash_process_req_one(areq, nbytes);
-}
-
 static int ahash_init(struct ahash_request *areq)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);



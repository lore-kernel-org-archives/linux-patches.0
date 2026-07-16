Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD9884248CD;
	Thu, 16 Jul 2026 14:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211310; cv=none; b=peO9e3wpn9vttLOHIs3WxM11lLRkA1o2SmnE1Cu7infJ1uTP28Qx93lin3h5uCzHhpfXweCrhUq7xcOLpyZ8jNBDbrCiiS/O7SUr6npC+Hjeu3m1abPaK3EAe0Cy6mY++8/rab1l6FLtBPVy2ibFcklxYDUCAwIxyILr9R9wxVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211310; c=relaxed/simple;
	bh=03LITth/UgrLhZPFxYA0B7DIpHAgU7T/hnfZkv2c0Vs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DLoHAPBU2oYvb438TUOiOASG0hE4ZqXP+H3CxUZ5ViAobYtCwHod2ewM10ONPc1Toc8+o0+mGV55b+zjt5vl8EDkdHTK0BTVZHIiMv7RW8mNgbPGvQbLe9lzCuBUNeRKHh6VAXZ9t7hHzw2ZLj/fy0bwOnJ9FbAVI83TPmmJUDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1arBl7Vs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1arBl7Vs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E6FE1F000E9;
	Thu, 16 Jul 2026 14:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211309;
	bh=Lw6av8c12yMthtdBTgk5hK/hbPADb4a5yGjX9hhqjaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1arBl7Vs/yIakNmrs7xESyYQagx0k6ESU4Z0nA98PMOBGr6hdFg85viytAIXRxZ1Z
	 fjXTegZ6yhRNMeVegofYcNhuDQTtUihOiiIwIAV8ve7u88xJlOKriTPj/v9LIBQVss
	 q/4cAwt64VxfZ27wc7qt37Gyk2RRAEUyTNjRyayU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Louvel <paul.louvel@bootlin.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.18 380/480] crypto: talitos/hash - remove useless wrapper
Date: Thu, 16 Jul 2026 15:32:07 +0200
Message-ID: <20260716133053.024759463@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



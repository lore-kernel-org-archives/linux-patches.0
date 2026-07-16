Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C69263F0774;
	Thu, 16 Jul 2026 13:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210015; cv=none; b=XPu/XDVfEsmYkghUOFyRkxUzETNFeMcCAbGzPLBCcg99GKtjcNksalKImlNC/oW+kjY2LzGkl21/aonEg73G8EXjhRlrSJ0oVnrsSc3cqdi7STKqYLOpK09/cMUQMm/UOZ/gsLqyrspl+QpYoi1Vpy/NLDYsRF1dWm0SPDDYVMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210015; c=relaxed/simple;
	bh=JkWOyWfAU2gOC09+2qfYxl6wQd+HW4Z+qXe4wUtyf7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VMu+IXSG+eErexzW7HVMfp5/qWgVcJxUdwjdf+bWwBrKzMjNGRQQFR4dUmL38I/tp8HiKW+S2ZQhYtkcMJ9mpZEPyRLbj9QQlqxAp1hCVOENvHNquc7CuJlojLMwtAOt3y9NxdJq2Qo7aTYHLIM6TIAg1c4FXIH9eI9Ot1oveOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uJofJ/2J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uJofJ/2J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 377D81F000E9;
	Thu, 16 Jul 2026 13:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210014;
	bh=tEjmZF7txEaR13wEMstVBIUiuEL9fp84Bt81c0sWsu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uJofJ/2JxLdIOw7NMqCDt3/jlKU5BvfmIMm8eP8lDunqr8ObjYmwwPBE1m5TFxzCI
	 W7AgC2QyQTTeEk1SQ64cC772LJjjI/+9anDsCE2YqJ6oyMLSblPDEXUiE6mrQB0w5H
	 Xm0WNG5R10opX4Z5i3mt7QxyMKNlovK66bjub3iQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Louvel <paul.louvel@bootlin.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 7.1 398/518] crypto: talitos/hash - remove useless wrapper
Date: Thu, 16 Jul 2026 15:31:06 +0200
Message-ID: <20260716133056.544543669@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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



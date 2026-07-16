Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B39CF424D79;
	Thu, 16 Jul 2026 14:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212351; cv=none; b=U99s9InDvhgYZ0FwnCKAmE5V2tSGuGp3uhKNjIZ4ITC8CCp353vZJSd9nBAJWxlvloQ4mhrXIf+w5LZCTWwA4pZD4WKYStsdnD/l8gjGaCWM95agOsUlbHKgucfI9gPA1ZBhHA16PF9LGBBhm9nJ/8rlEY5Kcr2dLV1dykEuDTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212351; c=relaxed/simple;
	bh=OdUnrS8tP5iQ5gkfi4v1i7DT6lUs69l4b8ZnDmZIl4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AbATNyoeKKaFcErNlsM44ZVj4QlqNzcA/loz3DWB8JVcQrV+1mQqUZonMDw/C1XXBdx7Ep9fsdo8VXyJT5O9mrh95s55yX3bfIRHDb2N5I34Tp80wd62Tr2ql1bAVkDLpsLrMdAXWxwdV2L7myyFz60Hju/Xjdn5eja2bPB/xrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bG4GJvwd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bG4GJvwd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 249861F000E9;
	Thu, 16 Jul 2026 14:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212350;
	bh=868izeg8jBPYZffK2L2PnIdLt+jrb8xfGd7Akn7HKec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bG4GJvwdUIKTIQxg+vn6a6EQwDIvIDX5xX9U1XOXrWxlM0qHLbv3VoCaD31Ywb0co
	 J53bBzpLgsM7KpMftm/b59iI2fi1iy5enr1Z5AKUdefTcq+xiymIe/2vz4vebTreUg
	 3iNz0OzkKgeAzy7K5iQCwE0LG+EOwqHybNYgrGVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Louvel <paul.louvel@bootlin.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.12 295/349] crypto: talitos/hash - remove useless wrapper
Date: Thu, 16 Jul 2026 15:33:49 +0200
Message-ID: <20260716133039.925060038@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



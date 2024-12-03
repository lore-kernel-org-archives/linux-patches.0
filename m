Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25C5D1F76B0;
	Tue,  3 Dec 2024 15:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240252; cv=none; b=FhFonZmm3U939G4GLXlVcD99f0yW5eKUMssBhQFRDKW5JZpPf+ifgtsAQwYbIFW8NrIO7rNh17qbfJrsvIwTMcTCbWnIEUI9reucLJqDqdDtyOm23rM2UeWMm3UZzc0Ylo3rJpBEL+9H9C+65a4WOF/9q08Jqz9lW6ZnREQcWWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240252; c=relaxed/simple;
	bh=QnGtHT0vSrZP09lkM37ZP+X3HI1ADRn16q1AUYfY1YI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ienZ5pYPDCpaszw9VL2ERpEEiSHQDFi1pA1rebhEGorTsnzrHXqJHZv/tWa97oc3s/7+PUdEHR4JEO+mUSGm7IulmuvY4PUjBZ6s3FX3wpotJLv/KL+KMU4kwG20kSzfx+DRwO9FJmroUbBTSqbWppQFzARoiQW2bsvnCrEeXZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IfLXzSb0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IfLXzSb0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A27D6C4CECF;
	Tue,  3 Dec 2024 15:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240252;
	bh=QnGtHT0vSrZP09lkM37ZP+X3HI1ADRn16q1AUYfY1YI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IfLXzSb0eAy75hCMGmxTfJHqIUVP1SrWvezb+2ynQYC/M6GKWlK+FpdSrf1nVLeFB
	 6yx5AjZsUkwY4ln0a+uBRYiLI5nJ59iQW7B/qVcy+BovPsbX0h1dtM4UP4TCiqW2yb
	 dmUoxxvXWffqhensgp4askPmQaASFjbGf1v2Ki14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ridong <chenridong@huawei.com>,
	Gaurav Jain <gaurav.jain@nxp.com>,
	=?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 076/826] crypto: caam - add error check to caam_rsa_set_priv_key_form
Date: Tue,  3 Dec 2024 15:36:43 +0100
Message-ID: <20241203144746.435739384@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ridong <chenridong@huawei.com>

[ Upstream commit b64140c74e954f1db6eae5548ca3a1f41b6fad79 ]

The caam_rsa_set_priv_key_form did not check for memory allocation errors.
Add the checks to the caam_rsa_set_priv_key_form functions.

Fixes: 52e26d77b8b3 ("crypto: caam - add support for RSA key form 2")
Signed-off-by: Chen Ridong <chenridong@huawei.com>
Reviewed-by: Gaurav Jain <gaurav.jain@nxp.com>
Reviewed-by: Horia Geantă <horia.geanta@nxp.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/caam/caampkc.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/caam/caampkc.c b/drivers/crypto/caam/caampkc.c
index 887a5f2fb9279..cb001aa1de661 100644
--- a/drivers/crypto/caam/caampkc.c
+++ b/drivers/crypto/caam/caampkc.c
@@ -984,7 +984,7 @@ static int caam_rsa_set_pub_key(struct crypto_akcipher *tfm, const void *key,
 	return -ENOMEM;
 }
 
-static void caam_rsa_set_priv_key_form(struct caam_rsa_ctx *ctx,
+static int caam_rsa_set_priv_key_form(struct caam_rsa_ctx *ctx,
 				       struct rsa_key *raw_key)
 {
 	struct caam_rsa_key *rsa_key = &ctx->key;
@@ -994,7 +994,7 @@ static void caam_rsa_set_priv_key_form(struct caam_rsa_ctx *ctx,
 
 	rsa_key->p = caam_read_raw_data(raw_key->p, &p_sz);
 	if (!rsa_key->p)
-		return;
+		return -ENOMEM;
 	rsa_key->p_sz = p_sz;
 
 	rsa_key->q = caam_read_raw_data(raw_key->q, &q_sz);
@@ -1029,7 +1029,7 @@ static void caam_rsa_set_priv_key_form(struct caam_rsa_ctx *ctx,
 
 	rsa_key->priv_form = FORM3;
 
-	return;
+	return 0;
 
 free_dq:
 	kfree_sensitive(rsa_key->dq);
@@ -1043,6 +1043,7 @@ static void caam_rsa_set_priv_key_form(struct caam_rsa_ctx *ctx,
 	kfree_sensitive(rsa_key->q);
 free_p:
 	kfree_sensitive(rsa_key->p);
+	return -ENOMEM;
 }
 
 static int caam_rsa_set_priv_key(struct crypto_akcipher *tfm, const void *key,
@@ -1088,7 +1089,9 @@ static int caam_rsa_set_priv_key(struct crypto_akcipher *tfm, const void *key,
 	rsa_key->e_sz = raw_key.e_sz;
 	rsa_key->n_sz = raw_key.n_sz;
 
-	caam_rsa_set_priv_key_form(ctx, &raw_key);
+	ret = caam_rsa_set_priv_key_form(ctx, &raw_key);
+	if (ret)
+		goto err;
 
 	return 0;
 
-- 
2.43.0




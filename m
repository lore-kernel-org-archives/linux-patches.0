Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C4DA1F6696;
	Tue,  3 Dec 2024 14:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237975; cv=none; b=Ea5r2vsf7CH/DKYPJWcxtMmqb/yN1V135mbakZz+lkJs6J0RJTFVUQy9aUZNLSc8mePjQJUWBif7sjdNyiGEP68Z+VqP/1holUoTj98RkxFMpPnLA2f8AuYZgdrCF0+ijeQpjIk5yVdQSeU3vwo2ZglKbcaCfYAX4mpnVyiMfe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237975; c=relaxed/simple;
	bh=bS1oUJ4NtlT9DwopA1wErnwREQAEWeyQOePtmZNV/LE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AVlgDTa+n37UjFpnPLG33b0ArAa7uK/kn9qklfBVHkv5X1Cp/+GW87QDV5RsqCx3YNW/w3lyEZ8ILcG1Z3XdiwlHe4CASqMlIIq3Cr6eNyIiSl2oD1mL1A5UsYlswf45XkFi7shvb2KukM9aydUdAlPcBhHreqBVbd5wnR9K4Q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lQl1Wv65; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lQl1Wv65"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 121ADC4CECF;
	Tue,  3 Dec 2024 14:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733237975;
	bh=bS1oUJ4NtlT9DwopA1wErnwREQAEWeyQOePtmZNV/LE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lQl1Wv65KSHIGCX86HjjgQiZvsscYqDn3+KN868qJKmdfYxz5Nca1araER8XgEPdL
	 Z9DjE5denMNcVupTrNTaLNtMbK79ybkewTcURS4IdzIwijv/eiEjuL+Wg7tVWFk/HV
	 hbJOp7fPlZavmUfcWAi1v4qLahPGUPrz+JN+/P+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ridong <chenridong@huawei.com>,
	Gaurav Jain <gaurav.jain@nxp.com>,
	=?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 122/817] crypto: caam - add error check to caam_rsa_set_priv_key_form
Date: Tue,  3 Dec 2024 15:34:54 +0100
Message-ID: <20241203144000.476792841@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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




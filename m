Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03AA323BD;
	Tue, 23 Jan 2024 01:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972187; cv=none; b=qPh23m1Oz0G5X1xz4oQ3ouJKzwVa77/U63ENasSeIMaHfztMjQdsiaNXYBfZRKj3nH65G39w5Y3Qax/YFs5MxkLaUAgTsz0SMjK/Fu//+RTD5bLmJUhw23Ii4MKagA+Arat18bM//Qj11fNasSXLbi5w4dmPIY9CXblTOj5iKMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972187; c=relaxed/simple;
	bh=LljUtltOBkx5qO9TJa7+rhRGDCHLOB73xeP5UIMp2+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l7fONPiRkO6ykw4HS2Z/pLgzGhFJXVprizSfwgaZ/PuOsTydFL9/5VeoTHcLxP51et/rtXuhMgkQxxNq/TBt/DmqSscT+82EvJS/a+oCciwcT8o6GJl4N5Qqrfo7KsryckQem5rZerqBfNigL6HciI4Q+i3+VdfjhF3J3qCr5kY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qqv3akea; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qqv3akea"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB21CC43394;
	Tue, 23 Jan 2024 01:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972186;
	bh=LljUtltOBkx5qO9TJa7+rhRGDCHLOB73xeP5UIMp2+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qqv3akeaolUFWvCekI1CZp9oTkAQDFKKwXTxk8lNDhePrDZ3GKcRvGYNDPlGbbNTb
	 2L8JJ7F/3UrNrzbgOEiGZRIcoIiZjmfgL2fmSKWAIOK3ggPeZxQtoUHi/qOJ5XCZSz
	 /ba9jRVljPVv3wNJVPFgFmultdBLiGo0dLh8ZAaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait@windriver.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 109/374] crypto: sahara - fix ahash reqsize
Date: Mon, 22 Jan 2024 15:56:05 -0800
Message-ID: <20240122235748.410418764@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ovidiu Panait <ovidiu.panait@windriver.com>

[ Upstream commit efcb50f41740ac55e6ccc4986c1a7740e21c62b4 ]

Set the reqsize for sha algorithms to sizeof(struct sahara_sha_reqctx), the
extra space is not needed.

Fixes: 5a2bb93f5992 ("crypto: sahara - add support for SHA1/256")
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/sahara.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index 3229dd180d0c..d31ccaffebb8 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -1163,8 +1163,7 @@ static int sahara_sha_import(struct ahash_request *req, const void *in)
 static int sahara_sha_cra_init(struct crypto_tfm *tfm)
 {
 	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
-				 sizeof(struct sahara_sha_reqctx) +
-				 SHA_BUFFER_LEN + SHA256_BLOCK_SIZE);
+				 sizeof(struct sahara_sha_reqctx));
 
 	return 0;
 }
-- 
2.43.0




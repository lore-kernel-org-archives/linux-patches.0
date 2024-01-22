Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9B715243;
	Tue, 23 Jan 2024 00:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968242; cv=none; b=MmscR66WsDtWclAcRebC6pWTIqQ9s/xJ7C9zM0VhoJMr1rEGEyNlcGgVjpOCQE+t+Ebe5gCCcDwKuUjeA9U1zoDf+dNz/B7tq4pXX/pnYWnxaydUaBMAd0Fp6kjCy8FAb9HzH2h5ACHdaWLGLH222nH1s5ZpUIbZ/247zJlyIY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968242; c=relaxed/simple;
	bh=BSH6X3Rm1UfPLWV5UaWgNOI1vPtPhC5XXZ4T15n+UOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c9I9P2t3kQGkPQAZVtdgLkPxP7LhgdF4byhdjiYD4w2UGNH7ldfJ0gQ1+XO+tIKuP1KPzSlehDd5L5zdW+Rymglb7Xjxe6ebEjZhiCSJueah0v21kn/nMpdQhKssalvxJZk6nCoksJFK+mboDx99ewwYDscb6k+nenzeDs6slKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ztR1ag97; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ztR1ag97"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4961FC433F1;
	Tue, 23 Jan 2024 00:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968242;
	bh=BSH6X3Rm1UfPLWV5UaWgNOI1vPtPhC5XXZ4T15n+UOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ztR1ag97mJ2iW2WMvS2dmCZxLfMaFxfRB2P8QE/ZgeefiUGBOALYZrY+7kaKcdp0B
	 IT3SBAYLkN/ibK5j9M7mxWdhBtnbUf3mXucvJcGvoMJcMXXNJVIGAovS/hrjCZylMW
	 QThWLdVa1pwJCULBlcF4vYvTxFTKW9EUmouiwGCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait@windriver.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 054/148] crypto: sahara - fix ahash reqsize
Date: Mon, 22 Jan 2024 15:56:50 -0800
Message-ID: <20240122235714.609009451@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235712.442097787@linuxfoundation.org>
References: <20240122235712.442097787@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 011789df3590..a9359b0ed045 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -1182,8 +1182,7 @@ static int sahara_sha_import(struct ahash_request *req, const void *in)
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




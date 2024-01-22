Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 905E25579C;
	Tue, 23 Jan 2024 00:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970498; cv=none; b=c537xgpaknTEP+XRnCj21Dkenjc0awosiq+kg5Rb19CtHGnARBuOBGDL17+7b8FXp9LeSiQv0BW7jn9AHqEbyNG+YGxLoK0JjVlbdQKfUBHLeoN9ZoM0ypkksxLHkhAvfzenJtESgiYGR09kyuEtUkTFq2BOlY5WisFzlnkxzMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970498; c=relaxed/simple;
	bh=Yil6hZuKy/n66FFxnb3ZIPkg/NSW8YapRjTpodSNsQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P8e8t5Vyuq2GLrA8qtTGRzXZxwQRooWl4pRxGZYjMSu1SlRBirbwa20Q5tPKF6BLZ97IFrFXDvgQzB7vU0UvjEGAc5jYdNZbvueAYkIFoXgthomiiGHTE6axYrtlO6cuFTt8OS9vUo7dOL4TrX3AMJrg2AQByIXwzEohJnQKth0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fLB6GzEg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fLB6GzEg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15153C433C7;
	Tue, 23 Jan 2024 00:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970498;
	bh=Yil6hZuKy/n66FFxnb3ZIPkg/NSW8YapRjTpodSNsQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fLB6GzEgkmHj67YCKBOW3AzEMTsVA2+9yh7Gew9TOPYwMYf0mm6EB/g015mz6TKUo
	 CWHYueTvLwQ3BknNKYiuRLCJ9dnZTBoJzX9E5YAux2XG36lhmstw8vjvLi9u1y3upN
	 WFDQV+PAvjLQjWOryXjy1vv5IrYLmn1uuQ6pGQ54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 035/417] crypto: sa2ul - Return crypto_aead_setkey to transfer the error
Date: Mon, 22 Jan 2024 15:53:23 -0800
Message-ID: <20240122235752.825906035@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit ce852f1308ac738e61c5b2502517deea593a1554 ]

Return crypto_aead_setkey() in order to transfer the error if
it fails.

Fixes: d2c8ac187fc9 ("crypto: sa2ul - Add AEAD algorithm support")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/sa2ul.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index f4bc06c24ad8..e7efebf8127f 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -1868,9 +1868,8 @@ static int sa_aead_setkey(struct crypto_aead *authenc,
 	crypto_aead_set_flags(ctx->fallback.aead,
 			      crypto_aead_get_flags(authenc) &
 			      CRYPTO_TFM_REQ_MASK);
-	crypto_aead_setkey(ctx->fallback.aead, key, keylen);
 
-	return 0;
+	return crypto_aead_setkey(ctx->fallback.aead, key, keylen);
 }
 
 static int sa_aead_setauthsize(struct crypto_aead *tfm, unsigned int authsize)
-- 
2.43.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 006241863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:15:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 792E5C433F0;
	Wed, 28 Dec 2022 15:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672240515;
	bh=YmkOPXgso4NlDny3+jokPW6WVAkZNQwjslb3dQq3VVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ArDWdRhlfpUgGaaNX3d0xgwpAovwmgeYcLhFmAEVUUJpW4/j35KFKIb5gS2FYbRVM
	 5mPBHqnM8MhnDNBRij6FRkAb83S3yPTnnwsrSZhL8sCkJQDtNKKk3G2NCeBCXiBPHy
	 M5WxyS3Re/wZO8LP+vJG727TwGSI1kjWNvE10TB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Corentin Labbe <clabbe@baylibre.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 362/731] crypto: sun8i-ss - use dma_addr instead u32
Date: Wed, 28 Dec 2022 15:37:49 +0100
Message-Id: <20221228144307.054642699@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Corentin Labbe <clabbe@baylibre.com>

[ Upstream commit 839b8ae2fc10f205317bcc32c9de18456756e1f5 ]

The DMA address need to be stored in a dma_addr_t

Fixes: 359e893e8af4 ("crypto: sun8i-ss - rework handling of IV")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
index 3c46ad8c3a1c..005eefecfdf5 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
@@ -105,7 +105,7 @@ static int sun8i_ss_setup_ivs(struct skcipher_request *areq)
 	unsigned int ivsize = crypto_skcipher_ivsize(tfm);
 	struct sun8i_ss_flow *sf = &ss->flows[rctx->flow];
 	int i = 0;
-	u32 a;
+	dma_addr_t a;
 	int err;
 
 	rctx->ivlen = ivsize;
-- 
2.35.1




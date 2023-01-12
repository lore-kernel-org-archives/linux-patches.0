Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15889749E
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:14:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69E65C433F1;
	Thu, 12 Jan 2023 14:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673532843;
	bh=rYZAp4ORtD+xn22CNPHNGVpnsgHVzZ9CDFk+ObP1uVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QbCFQ4yYwxlwjq8E+VBaCIYkNBmMUJpqTG3N1Br3MiQQ60cZ8JqlP4dkVcxGv4Sv0
	 qZSxrOFlHCh/00Hd6OZDGAnm7Omz1oc211rxH3vAE9WTsypXSSI8ChYypG28DmyZKh
	 8t/fk0wCeUpjg60RWzAhmn3aEhqQr5ntCNZqRJug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai Ye <yekai13@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 294/783] crypto: rockchip - delete unneeded variable initialization
Date: Thu, 12 Jan 2023 14:50:10 +0100
Message-Id: <20230112135537.959975867@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kai Ye <yekai13@huawei.com>

[ Upstream commit 3d8c5f5a08c39835a365c69d1a6d9518722ed19e ]

Delete unneeded variable initialization

Signed-off-by: Kai Ye <yekai13@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: 57d67c6e8219 ("crypto: rockchip - rework by using crypto_engine")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/rockchip/rk3288_crypto_ahash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/rockchip/rk3288_crypto_ahash.c b/drivers/crypto/rockchip/rk3288_crypto_ahash.c
index f1d482ecc195..c762e462eb57 100644
--- a/drivers/crypto/rockchip/rk3288_crypto_ahash.c
+++ b/drivers/crypto/rockchip/rk3288_crypto_ahash.c
@@ -82,7 +82,7 @@ static void rk_ahash_reg_init(struct rk_crypto_info *dev)
 {
 	struct ahash_request *req = ahash_request_cast(dev->async_req);
 	struct rk_ahash_rctx *rctx = ahash_request_ctx(req);
-	int reg_status = 0;
+	int reg_status;
 
 	reg_status = CRYPTO_READ(dev, RK_CRYPTO_CTRL) |
 		     RK_CRYPTO_HASH_FLUSH | _SBF(0xffff, 16);
-- 
2.35.1




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7255B36C9E2
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302319; cv=none; b=iucd61AakGXI/Vlj6yHUh2QiRqvP7DAw2ptAqNk1npjz1OONE2nUsHyRxwRQ5YdpMa5p0PTntRMk7zaihER23hXo6LJOIvFtZ0QrfAbgQXu0iHYVbcfEdGXhlgnTg1GNcUSxlGT+UaT9BlZzk5UoxExGXFifnttYOt8hewjDccE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302319; c=relaxed/simple;
	bh=HiHhlEvaaI4qY6El36Q09R+YbneNwYK4VCYa/87ZSA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IaMOPdbYl8SO+hEaWQ+AOMPMr0X9969yX2VUuZ8eA1y3u5DgVNxvuaTUuKhsdOOXR7sdHY442FDETNgBfek2q0r3x8Uv1s+J8bzQqJ+OTHqJHZa26rMviA1OpiJxV9fRc0HRsP3eLvF/Tqfc+dNgbhj+Gj9EUbhqgegcb0ya2bU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jBL44UDU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jBL44UDU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C87BC116D0;
	Sat, 28 Feb 2026 18:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302319;
	bh=HiHhlEvaaI4qY6El36Q09R+YbneNwYK4VCYa/87ZSA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jBL44UDUi60TBBpzvI07f7JXih7fck9lI9TyzidgRUwXz+Dqnif7iLlyFsh8Iy46N
	 4PelJFjjOe3QuFqsfKZXLvmQCvuv5dAsC1DzSgSZ3+EGWJKDy69Frq7MdCbCp5zL/k
	 2maHhDolDBsY1ba5MZPuWfM8ihkzFzjc0W7JFEDFO0PvB9w4IsxkUQQaHe6o70ucJQ
	 UNhkLirDUe3tGS/JhYNRzFNRSYkBjO6hxaUZ8YmcCfh42WuBGHJrdwveBC/7nAT8iM
	 Xn9npaiJ9UQV2lNOzU7zKx7hcQ8CHaES035M+acu18KlviQOx+ABUzZDY+qe1y+dYU
	 VZdzSkuLWkmCQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Kai Ye <yekai13@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 037/232] crypto: hisilicon/sec - fix spelling mistake 'ckeck' -> 'check'
Date: Sat, 28 Feb 2026 13:08:10 -0500
Message-ID: <20260228181127.1592657-37-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Kai Ye <yekai13@huawei.com>

[ Upstream commit 2132d4efaa66388f1f79c79a920908a22464686b ]

There are a couple of spelling mistakes in sec2. Fix them.

Signed-off-by: Kai Ye <yekai13@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: e75074396280 ("crypto: hisilicon/sec2 - support skcipher/aead fallback for hardware queue unavailable")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index 292ab0ff2b07c..fe34e17b44424 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -2002,7 +2002,7 @@ static int sec_aead_sha512_ctx_init(struct crypto_aead *tfm)
 	return sec_aead_ctx_init(tfm, "sha512");
 }
 
-static int sec_skcipher_cryptlen_ckeck(struct sec_ctx *ctx,
+static int sec_skcipher_cryptlen_check(struct sec_ctx *ctx,
 	struct sec_req *sreq)
 {
 	u32 cryptlen = sreq->c_req.sk_req->cryptlen;
@@ -2064,7 +2064,7 @@ static int sec_skcipher_param_check(struct sec_ctx *ctx, struct sec_req *sreq)
 		}
 		return 0;
 	} else if (c_alg == SEC_CALG_AES || c_alg == SEC_CALG_SM4) {
-		return sec_skcipher_cryptlen_ckeck(ctx, sreq);
+		return sec_skcipher_cryptlen_check(ctx, sreq);
 	}
 
 	dev_err(dev, "skcipher algorithm error!\n");
-- 
2.51.0


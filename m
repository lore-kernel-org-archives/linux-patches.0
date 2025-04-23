Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAF0327D76E;
	Wed, 23 Apr 2025 14:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419690; cv=none; b=UH35tfA9FgsMcd7Ie/Owc0cnUbjv0LgcMwSjk4Wofx69OqkUrEd9jl8ZASjMZS5WKyNClgsGhu7AMrVkxITtfyYr7o1mVf/h4s/L+agX6rv189N6KkAPZxMvFHSz/DUnuoeKvtGkWfIjeWTNal8qlrG/d9Kz2PTv/xna8qKkVB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419690; c=relaxed/simple;
	bh=DbXnRRuzUtTHYkyvqGM79BR+cX3eDEVctRBzV2zGiL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F65d+SgqDxNqp6iIKj1K783amusWI2f7ip9+FuFT2G8c5RQKo4ThMGO/b43GGNEVrkp3/AQCgijJpTyfhFj5wzKJKjI+6AVpaKpjdlYR61qIinZsxl6etqAd9ISMFAbGopfJ3rcyJu1ffeKirEdr01EjmBk3s4GJxGE9vKgFe/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2heig+kg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2heig+kg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DC87C4CEE8;
	Wed, 23 Apr 2025 14:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419689;
	bh=DbXnRRuzUtTHYkyvqGM79BR+cX3eDEVctRBzV2zGiL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2heig+kg0P7OY/75Z59u6iAG8I9Ru566betyKvhRfukPrpf6/zYnW0CxPm1dnYplI
	 XihYxxLhJkjliAb55lIGu4P2j+I3D3GpaqIROTTQ2QqrX7n6EQ0EW3oUCmpLHle9hK
	 1VGvuFFpIYxf2md/y9zMGiIMaDcLwdern2oupDEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Akhil R <akhilrajeev@nvidia.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 015/223] crypto: tegra - remove redundant error check on ret
Date: Wed, 23 Apr 2025 16:41:27 +0200
Message-ID: <20250423142617.740037902@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Colin Ian King <colin.i.king@gmail.com>

[ Upstream commit 7b90df78184de90fe5afcc45393c8ad83b5b18a1 ]

Currently there is an unnecessary error check on ret without a proceeding
assignment to ret that needs checking. The check is redundant and can be
removed.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Acked-by: Akhil R <akhilrajeev@nvidia.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: 1ddaff40c08a ("crypto: tegra - Fix IV usage for AES ECB")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/tegra/tegra-se-aes.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/crypto/tegra/tegra-se-aes.c b/drivers/crypto/tegra/tegra-se-aes.c
index 0ed0515e1ed54..9ab832bee81a2 100644
--- a/drivers/crypto/tegra/tegra-se-aes.c
+++ b/drivers/crypto/tegra/tegra-se-aes.c
@@ -1183,8 +1183,6 @@ static int tegra_ccm_do_one_req(struct crypto_engine *engine, void *areq)
 			goto out;
 	} else {
 		rctx->cryptlen = req->cryptlen - ctx->authsize;
-		if (ret)
-			goto out;
 
 		/* CTR operation */
 		ret = tegra_ccm_do_ctr(ctx, rctx);
-- 
2.39.5




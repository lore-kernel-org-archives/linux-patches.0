Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEFC9FBEA
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:05:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7590C433EF;
	Mon, 15 May 2023 17:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684170335;
	bh=hQZJNFV9wR2W1eG7dCxga04grQ8fiae9q7llo2dHJtQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Hp1aDiAI96W852W2TV68e7dGm/9a/VBXiYpQ+aVQMU0sBsFuKRX1bGJHIV38A6ez
	 XInmP+F+Km6z8a+IhqYoM0zP7hDz+OIKdkdv8QwJf1+mPMwAH+/Ijw+0lelUp8vn9m
	 V96ldX5L7UNLmXMRfAg5ICGp1VnEKc5L5uwzAYUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 099/239] crypto: sun8i-ss - Fix a test in sun8i_ss_setup_ivs()
Date: Mon, 15 May 2023 18:26:02 +0200
Message-Id: <20230515161724.655521235@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.545370111@linuxfoundation.org>
References: <20230515161721.545370111@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 8fd91151ebcb21b3f2f2bf158ac6092192550b2b ]

SS_ENCRYPTION is (0 << 7 = 0), so the test can never be true.
Use a direct comparison to SS_ENCRYPTION instead.

The same king of test is already done the same way in sun8i_ss_run_task().

Fixes: 359e893e8af4 ("crypto: sun8i-ss - rework handling of IV")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
index 902f6be057ec6..e97fb203690ae 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
@@ -151,7 +151,7 @@ static int sun8i_ss_setup_ivs(struct skcipher_request *areq)
 		}
 		rctx->p_iv[i] = a;
 		/* we need to setup all others IVs only in the decrypt way */
-		if (rctx->op_dir & SS_ENCRYPTION)
+		if (rctx->op_dir == SS_ENCRYPTION)
 			return 0;
 		todo = min(len, sg_dma_len(sg));
 		len -= todo;
-- 
2.39.2




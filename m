Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9562168CF
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:12:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FA02C433EF;
	Mon,  8 May 2023 11:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683544340;
	bh=QA79zaj9/KIbS996uAbrURXLXgRybr6BcGmlw4jTVLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nyYE99UkBQo5vgj8iqZR5glkHTUNR1eX8UM2fFCIDQaJzKqFUhPWpFOSV5M+LWNC/
	 elmbB2xGtbd7d2NKmrHmpKAGkOf6WCrvctnA9xPQM8px9IKNTSYXqzR0RGlBd+VeUg
	 A2Y/co6B3Q7zDssyjXPIdIGPuGnbZjQO0dBZ9BZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suman Anna <s-anna@ti.com>,
	Jayesh Choudhary <j-choudhary@ti.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 377/694] crypto: sa2ul - Select CRYPTO_DES
Date: Mon,  8 May 2023 11:43:32 +0200
Message-Id: <20230508094445.114209556@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Suman Anna <s-anna@ti.com>

[ Upstream commit 8832023efd20966e29944dac92118dfbf1fa1bc0 ]

The SA2UL Crypto driver provides support for couple of
DES3 algos "cbc(des3_ede)" and "ecb(des3_ede)", and enabling
the crypto selftest throws the following errors (as seen on
K3 J721E SoCs):
  saul-crypto 4e00000.crypto: Error allocating fallback algo cbc(des3_ede)
  alg: skcipher: failed to allocate transform for cbc-des3-sa2ul: -2
  saul-crypto 4e00000.crypto: Error allocating fallback algo ecb(des3_ede)
  alg: skcipher: failed to allocate transform for ecb-des3-sa2ul: -2

Fix this by selecting CRYPTO_DES which was missed while
adding base driver support.

Fixes: 7694b6ca649f ("crypto: sa2ul - Add crypto driver")
Signed-off-by: Suman Anna <s-anna@ti.com>
Signed-off-by: Jayesh Choudhary <j-choudhary@ti.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 3b2516d1433f7..20222e321a436 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -810,6 +810,7 @@ config CRYPTO_DEV_SA2UL
 	select CRYPTO_AES
 	select CRYPTO_ALGAPI
 	select CRYPTO_AUTHENC
+	select CRYPTO_DES
 	select CRYPTO_SHA1
 	select CRYPTO_SHA256
 	select CRYPTO_SHA512
-- 
2.39.2




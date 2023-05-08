Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2F8B168A7
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:34:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 491BDC433EF;
	Mon,  8 May 2023 10:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683542091;
	bh=XmpxggohnG/FVmLqMQ41/HnESUYbUt1npoRGx4Nmrk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rdYHED6h7mXVXQMrD/F9CMecN3v6M9uoEJvHGCCadWgfo65AVE21FsDITJW2yXh3q
	 y59LU30DKa6QNW6skqfmH1xi8X0g8cgYlV+ZXb/+vY7T5jdySvWIdTbXJC7ml2/Tju
	 Pgk7QsEgL9/8rqCVPLwKsEyy8rseKmAwnijf58HQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suman Anna <s-anna@ti.com>,
	Jayesh Choudhary <j-choudhary@ti.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 324/663] crypto: sa2ul - Select CRYPTO_DES
Date: Mon,  8 May 2023 11:42:30 +0200
Message-Id: <20230508094438.704286759@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
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
index dfb103f81a64b..8d06bc30eadeb 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -820,6 +820,7 @@ config CRYPTO_DEV_SA2UL
 	select CRYPTO_AES
 	select CRYPTO_ALGAPI
 	select CRYPTO_AUTHENC
+	select CRYPTO_DES
 	select CRYPTO_SHA1
 	select CRYPTO_SHA256
 	select CRYPTO_SHA512
-- 
2.39.2




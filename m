Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA5B0BA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:15:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3017BC433D2;
	Tue,  7 Mar 2023 17:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209303;
	bh=HA0Z9NQJmlhgaNpdXkmO6fiN1ugLqryGxCVie8jE0Ew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cXv2GvS1FGjNOzD9FtZOjM5MId34IUZQrUAC7I4VUYjB5YYYqpci8JzBTH/db4WhG
	 AimMOgbFLsaTpdyFdiT/9jQMKGG89oEXnl8G8ouBDp7DygcprmXJIV2n+wnxLIcDsZ
	 ByGT6hgx/wzwE0VDRPlunAzK9NBhX5Q5m6ek9KwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Bulwahn <lukas.bulwahn@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0175/1001] crypto: ux500 - update debug config after ux500 cryp driver removal
Date: Tue,  7 Mar 2023 17:49:07 +0100
Message-Id: <20230307170029.529170871@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lukas Bulwahn <lukas.bulwahn@gmail.com>

[ Upstream commit 49bc6a7786b7d03eab6912a88d09a7991a32174e ]

Commit 453de3eb08c4 ("crypto: ux500/cryp - delete driver") removes the
config CRYPTO_DEV_UX500_CRYP, but leaves an obsolete reference in the
dependencies of config CRYPTO_DEV_UX500_DEBUG.

Remove that obsolete reference, and adjust the description while at it.

Fixes: 453de3eb08c4 ("crypto: ux500/cryp - delete driver")
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ux500/Kconfig | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/ux500/Kconfig b/drivers/crypto/ux500/Kconfig
index dcbd7404768f1..ac89cd2de12a1 100644
--- a/drivers/crypto/ux500/Kconfig
+++ b/drivers/crypto/ux500/Kconfig
@@ -15,8 +15,7 @@ config CRYPTO_DEV_UX500_HASH
 	  Depends on UX500/STM DMA if running in DMA mode.
 
 config CRYPTO_DEV_UX500_DEBUG
-	bool "Activate ux500 platform debug-mode for crypto and hash block"
-	depends on CRYPTO_DEV_UX500_CRYP || CRYPTO_DEV_UX500_HASH
+	bool "Activate debug-mode for UX500 crypto driver for HASH block"
+	depends on CRYPTO_DEV_UX500_HASH
 	help
-	  Say Y if you want to add debug prints to ux500_hash and
-	  ux500_cryp devices.
+	  Say Y if you want to add debug prints to ux500_hash devices.
-- 
2.39.2




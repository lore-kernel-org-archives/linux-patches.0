Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB64879C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:36:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37EADC433C1;
	Wed, 30 Nov 2022 18:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833415;
	bh=mJuRtBlSOSH9V4fn1nbAYqKgbkqKXm4/LiTyyqj1Mok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=frQNsZYkLk3cVGcZFa8MPN4A5vvkUflTVVCvXHUuKEcat3pNcbk06ItDfNRl88WSi
	 RcOW8K+wnQV5GSxfltW0YDU1cUnVWZjn0E7oDIkl8CLvYGfhnF3cjE4vqTLpEMVZxT
	 Ck5FRUt3nKURVgv3p30aj3iJTPfJSmdcvsT+qUZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	YueHaibing <yuehaibing@huawei.com>,
	Saeed Mahameed <saeed@kernel.org>,
	Antoine Tenart <atenart@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 097/206] macsec: Fix invalid error code set
Date: Wed, 30 Nov 2022 19:22:29 +0100
Message-Id: <20221130180535.503005200@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 7cef6b73fba96abef731a53501924fc3c4a0f947 ]

'ret' is defined twice in macsec_changelink(), when it is set in macsec_is_offloaded
case, it will be invalid before return.

Fixes: 3cf3227a21d1 ("net: macsec: hardware offloading infrastructure")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Reviewed-by: Saeed Mahameed <saeed@kernel.org>
Reviewed-by: Antoine Tenart <atenart@kernel.org>
Link: https://lore.kernel.org/r/20221118011249.48112-1-yuehaibing@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/macsec.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index f1961d7f9db2..aa9d0dfeda5a 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -3808,7 +3808,6 @@ static int macsec_changelink(struct net_device *dev, struct nlattr *tb[],
 	if (macsec_is_offloaded(macsec)) {
 		const struct macsec_ops *ops;
 		struct macsec_context ctx;
-		int ret;
 
 		ops = macsec_get_ops(netdev_priv(dev), &ctx);
 		if (!ops) {
-- 
2.35.1




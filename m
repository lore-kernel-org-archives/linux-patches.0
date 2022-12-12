Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D712228ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:52:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 422D5C433EF;
	Mon, 12 Dec 2022 13:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670853145;
	bh=BbWl/gWdbeEM4bKbfp2plZpqI/1nVudHB2Y7ONZt5Lo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p8TlWz3nJVJGMOiXPlGLVWH/0D7SCwxreWfR5q9SKxfrsjaKEDMCwOAIlQOiLs9IG
	 B6l/MlJVfFuQuZgwv7jWml1TEO8ElyVZ0OdQtlx9TnXaUSNJRY2MwYGlODFc6MYPQR
	 mlf52oAUdHHmPeOd+dnwFrO4nXxPF7wmomieBl5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ziyang Xuan <william.xuanziyang@huawei.com>,
	Stefan Schmidt <stefan@datenfreihafen.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 19/38] ieee802154: cc2520: Fix error return code in cc2520_hw_init()
Date: Mon, 12 Dec 2022 14:19:20 +0100
Message-Id: <20221212130913.078107928@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130912.069170932@linuxfoundation.org>
References: <20221212130912.069170932@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ziyang Xuan <william.xuanziyang@huawei.com>

[ Upstream commit 4d002d6a2a00ac1c433899bd7625c6400a74cfba ]

In cc2520_hw_init(), if oscillator start failed, the error code
should be returned.

Fixes: 0da6bc8cc341 ("ieee802154: cc2520: adds driver for TI CC2520 radio")
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
Link: https://lore.kernel.org/r/20221120075046.2213633-1-william.xuanziyang@huawei.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ieee802154/cc2520.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ieee802154/cc2520.c b/drivers/net/ieee802154/cc2520.c
index 436cf2007138..92aefaf8ea19 100644
--- a/drivers/net/ieee802154/cc2520.c
+++ b/drivers/net/ieee802154/cc2520.c
@@ -979,7 +979,7 @@ static int cc2520_hw_init(struct cc2520_private *priv)
 
 		if (timeout-- <= 0) {
 			dev_err(&priv->spi->dev, "oscillator start failed!\n");
-			return ret;
+			return -ETIMEDOUT;
 		}
 		udelay(1);
 	} while (!(status & CC2520_STATUS_XOSC32M_STABLE));
-- 
2.35.1




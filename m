Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FCB26FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:47:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB422C433D2;
	Mon,  3 Apr 2023 14:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680533253;
	bh=TwjAGmQyaL72zUmNQ2AO6XRnCVJzTD/CIfzCShG5lic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U9zLJwKjE0E5i7W3Mi2uxKoIgERj4kO+h/P8paaBfs2C/WnToATNT+mATjzA43G5A
	 aXbGqIk9EX+7UHRD8DD9yfCxrc/v8QjzmRgjLwSi2okNQX5bGNpnfBjYJuHcXGKKKq
	 fAyt8qWh4gD9Kx8/VnABUhyS1CGbOOJFJLqSs0W8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Arun Ramadoss <arun.ramadoss@microchip.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 085/187] net: dsa: microchip: ksz8: fix offset for the timestamp filed
Date: Mon,  3 Apr 2023 16:08:50 +0200
Message-Id: <20230403140418.756707220@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Oleksij Rempel <o.rempel@pengutronix.de>

[ Upstream commit b3177aab89be540dc50d2328427b073361093e38 ]

We are using wrong offset, so we will get not a timestamp.

Fixes: 4b20a07e103f ("net: dsa: microchip: ksz8795: add support for ksz88xx chips")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Acked-by: Arun Ramadoss <arun.ramadoss@microchip.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/microchip/ksz_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 725a868b76f7e..9da2b3afce26e 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -414,7 +414,7 @@ static u8 ksz8863_shifts[] = {
 	[DYNAMIC_MAC_ENTRIES_H]		= 8,
 	[DYNAMIC_MAC_ENTRIES]		= 24,
 	[DYNAMIC_MAC_FID]		= 16,
-	[DYNAMIC_MAC_TIMESTAMP]		= 24,
+	[DYNAMIC_MAC_TIMESTAMP]		= 22,
 	[DYNAMIC_MAC_SRC_PORT]		= 20,
 };
 
-- 
2.39.2




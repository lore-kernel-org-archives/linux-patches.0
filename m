Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FA7F28ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:43:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC56AC433EF;
	Mon, 12 Dec 2022 13:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670852596;
	bh=XVSMrtTaqFbA/yO6OdWKo6Jh6ZBJN0hHGsgDWIUgntI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Of2Ul9CNlkDGsFwqYKD4PoTzjSKteQkX0t2jehSm1WEcop9p7Ss2cGmvBv+lH5ans
	 kWO67Rk84PuAZwkgkQG/2+am1z1rT/EwZWSW7ntTUBaleEY56/nNjg5xqB95J2XkL3
	 wRnjO1VYoXU3setcWsXSDfI1Gs8/OK2ltvIxj7m8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Artem Chernyshev <artem.chernyshev@red-soft.ru>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Kurt Kanzenbach <kurt@linutronix.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 112/157] net: dsa: hellcreek: Check return value
Date: Mon, 12 Dec 2022 14:17:40 +0100
Message-Id: <20221212130939.348982886@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Artem Chernyshev <artem.chernyshev@red-soft.ru>

[ Upstream commit d4edb50688652eb10be270bc515da63815de428f ]

Return NULL if we got unexpected value from skb_trim_rcsum()
in hellcreek_rcv()

Fixes: 01ef09caad66 ("net: dsa: Add tag handling for Hirschmann Hellcreek switches")
Signed-off-by: Artem Chernyshev <artem.chernyshev@red-soft.ru>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>
Link: https://lore.kernel.org/r/20221201140032.26746-2-artem.chernyshev@red-soft.ru
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/tag_hellcreek.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/dsa/tag_hellcreek.c b/net/dsa/tag_hellcreek.c
index 846588c0070a..53a206d11685 100644
--- a/net/dsa/tag_hellcreek.c
+++ b/net/dsa/tag_hellcreek.c
@@ -49,7 +49,8 @@ static struct sk_buff *hellcreek_rcv(struct sk_buff *skb,
 		return NULL;
 	}
 
-	pskb_trim_rcsum(skb, skb->len - HELLCREEK_TAG_LEN);
+	if (pskb_trim_rcsum(skb, skb->len - HELLCREEK_TAG_LEN))
+		return NULL;
 
 	dsa_default_offload_fwd_mark(skb);
 
-- 
2.35.1




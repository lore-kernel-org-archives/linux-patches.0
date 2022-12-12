Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1E8B28ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:43:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E549BC433EF;
	Mon, 12 Dec 2022 13:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670852591;
	bh=AzJSGGLEjQ20cC65AI47DBuf7qOlNwQK1SBMY8LXiS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nQZwbzH1a55ZYrOzddFqlWu6TqQjgKRUkBDqaUc1zsSKUsToZ0uIavIlTLIRAukyg
	 7TLcJFyc5C4x43uBfkGaqQz0NGNO5HNAOslE7m6JMVQ/T6nqe2fJPefhdaQ3CrW8p0
	 7OJpaqB6zqJTdkacJp26J84hofyvSPB44luUqMoA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Artem Chernyshev <artem.chernyshev@red-soft.ru>,
	Vladimir Oltean <olteanv@gmail.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 111/157] net: dsa: ksz: Check return value
Date: Mon, 12 Dec 2022 14:17:39 +0100
Message-Id: <20221212130939.307149855@linuxfoundation.org>
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

[ Upstream commit 3d8fdcbf1f42e2bb9ae8b8c0b6f202278c788a22 ]

Return NULL if we got unexpected value from skb_trim_rcsum()
in ksz_common_rcv()

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: bafe9ba7d908 ("net: dsa: ksz: Factor out common tag code")
Signed-off-by: Artem Chernyshev <artem.chernyshev@red-soft.ru>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20221201140032.26746-1-artem.chernyshev@red-soft.ru
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/tag_ksz.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/dsa/tag_ksz.c b/net/dsa/tag_ksz.c
index 38fa19c1e2d5..429250298ac4 100644
--- a/net/dsa/tag_ksz.c
+++ b/net/dsa/tag_ksz.c
@@ -21,7 +21,8 @@ static struct sk_buff *ksz_common_rcv(struct sk_buff *skb,
 	if (!skb->dev)
 		return NULL;
 
-	pskb_trim_rcsum(skb, skb->len - len);
+	if (pskb_trim_rcsum(skb, skb->len - len))
+		return NULL;
 
 	dsa_default_offload_fwd_mark(skb);
 
-- 
2.35.1




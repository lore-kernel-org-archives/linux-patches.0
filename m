Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 043FA17AA6
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:12:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C016C433CC;
	Wed,  9 Aug 2023 11:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691579551;
	bh=BERjZwm106RrVCLMzj/8nuLcBRI6IHNOUHL41UYo7EQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dGaaSON/mw0rLt4lnv7H02lCyF72o3te5Xa5GoLlaOKCcM6AdJbbpSost2QfQLIj9
	 eaRGoYMqMluXVUFeUTDqAtQjDtSeqGn0kjfJ2ilkBfNOrfFk18IYaW6QwsZpOeVvky
	 SsIJVWEZCoRE733ya+koKRthCYHLq9eoU69niW6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Dewar <alex.dewar90@gmail.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 031/323] wl3501_cs: Remove unnecessary NULL check
Date: Wed,  9 Aug 2023 12:37:49 +0200
Message-ID: <20230809103659.553536629@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103658.104386911@linuxfoundation.org>
References: <20230809103658.104386911@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alex Dewar <alex.dewar90@gmail.com>

[ Upstream commit 1d2a85382282e7c77cbde5650335c3ffc6073fa1 ]

In wl3501_detach(), link->priv is checked for a NULL value before being
passed to free_netdev(). However, it cannot be NULL at this point as it
has already been passed to other functions, so just remove the check.

Addresses-Coverity: CID 710499: Null pointer dereferences (REVERSE_INULL)
Signed-off-by: Alex Dewar <alex.dewar90@gmail.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200926174558.9436-1-alex.dewar90@gmail.com
Stable-dep-of: 391af06a02e7 ("wifi: wl3501_cs: Fix an error handling path in wl3501_probe()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/wl3501_cs.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/wl3501_cs.c b/drivers/net/wireless/wl3501_cs.c
index 78c89e6421f97..5b2383270627c 100644
--- a/drivers/net/wireless/wl3501_cs.c
+++ b/drivers/net/wireless/wl3501_cs.c
@@ -1438,9 +1438,7 @@ static void wl3501_detach(struct pcmcia_device *link)
 	wl3501_release(link);
 
 	unregister_netdev(dev);
-
-	if (link->priv)
-		free_netdev(link->priv);
+	free_netdev(dev);
 }
 
 static int wl3501_get_name(struct net_device *dev, struct iw_request_info *info,
-- 
2.39.2




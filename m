Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB9B217744
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:12:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B060C433C7;
	Wed,  9 Aug 2023 11:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691579560;
	bh=+VCZI36NglCDwUm2eB5PKHmrF32D8qKV8fDdqkFpHLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U16ZzYjIW2y6/F8RCwRm5WP4CYb1hwyN+f1FfgktnJxJqvXcPfzB78pevoMGl2pNd
	 bLizDerYS9PmMDIad+7nj6xWyyU7dbc/JCgrvH2elePNWC3rqpdc6L/jL25gUY9Pmo
	 XPkdz7BYsKUow0DUq+z/+6MEY8a/c+lQhvYM7Ffk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Kalle Valo <kvalo@codeaurora.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 034/323] wl3501_cs: use eth_hw_addr_set()
Date: Wed,  9 Aug 2023 12:37:52 +0200
Message-ID: <20230809103659.669176325@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 18774612246d036c04ce9fee7f67192f96f48725 ]

Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
of VLANs...") introduced a rbtree for faster Ethernet address look
up. To maintain netdev->dev_addr in this tree we need to make all
the writes to it got through appropriate helpers.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20211018235021.1279697-15-kuba@kernel.org
Stable-dep-of: 391af06a02e7 ("wifi: wl3501_cs: Fix an error handling path in wl3501_probe()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/wl3501_cs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl3501_cs.c b/drivers/net/wireless/wl3501_cs.c
index c6d1a320e244f..46188a83d8be8 100644
--- a/drivers/net/wireless/wl3501_cs.c
+++ b/drivers/net/wireless/wl3501_cs.c
@@ -1946,8 +1946,7 @@ static int wl3501_config(struct pcmcia_device *link)
 		goto failed;
 	}
 
-	for (i = 0; i < 6; i++)
-		dev->dev_addr[i] = ((char *)&this->mac_addr)[i];
+	eth_hw_addr_set(dev, this->mac_addr);
 
 	/* print probe information */
 	printk(KERN_INFO "%s: wl3501 @ 0x%3.3x, IRQ %d, "
-- 
2.39.2




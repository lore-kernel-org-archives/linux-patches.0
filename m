Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 541AF1ED38
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:36:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3CF4C433CD;
	Tue, 25 Jul 2023 11:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690284980;
	bh=ry/yoa4ge2tw6XcEMV2M9mMlgluVEOFdhrP51A8ozVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iwzH7NUtdD1Tnbq1K2rcjusXUMIDZ/hUmY4K0cP3iEjXSV6ns+wY/7gWtJXyWyUed
	 PXLVzN5oYC+DJBrdS+8yrAL0lVT7kbuVky0tvbhVrWbIydvKOq3arwkC8WmvBzM97B
	 45nGEoEPBBzJpRim4G4t8OWZgt3AUhUiNlYOmRbQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Dewar <alex.dewar90@gmail.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 041/313] wl3501_cs: Remove unnecessary NULL check
Date: Tue, 25 Jul 2023 12:43:14 +0200
Message-ID: <20230725104522.851710014@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104521.167250627@linuxfoundation.org>
References: <20230725104521.167250627@linuxfoundation.org>
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
index b66c7d4798977..cf67ea13dd8dc 100644
--- a/drivers/net/wireless/wl3501_cs.c
+++ b/drivers/net/wireless/wl3501_cs.c
@@ -1437,9 +1437,7 @@ static void wl3501_detach(struct pcmcia_device *link)
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




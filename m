Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5971F1ED41
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 18:53:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3692C433C7;
	Fri, 21 Jul 2023 18:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689965613;
	bh=H9OmMpBErT2Gl4fLi1Rtj80DVab04AVwEVjebRsCOEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P4tozMJpEoH3z4T1narHrVFBa7ImaV1STPiBO97SVHmG+pXEm/0YLyIFDn11H4Spy
	 yT1lGZbrl/quIw0e7FMSl57J7zi+fPMoN90KPYf97BIAJD9NTa079WZPVVf7/a2PA+
	 cSXjkyqJaViA3+qmo+IcdaT8w1S9Y+lauZWzlWEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Kalle Valo <kvalo@codeaurora.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 053/532] wl3501_cs: use eth_hw_addr_set()
Date: Fri, 21 Jul 2023 17:59:17 +0200
Message-ID: <20230721160617.516979208@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
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
index cb71b73853f4e..7351a2c127adc 100644
--- a/drivers/net/wireless/wl3501_cs.c
+++ b/drivers/net/wireless/wl3501_cs.c
@@ -1945,8 +1945,7 @@ static int wl3501_config(struct pcmcia_device *link)
 		goto failed;
 	}
 
-	for (i = 0; i < 6; i++)
-		dev->dev_addr[i] = ((char *)&this->mac_addr)[i];
+	eth_hw_addr_set(dev, this->mac_addr);
 
 	/* print probe information */
 	printk(KERN_INFO "%s: wl3501 @ 0x%3.3x, IRQ %d, "
-- 
2.39.2




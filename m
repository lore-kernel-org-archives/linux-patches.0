Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8D0C168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:07:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C5D0C433EF;
	Mon,  8 May 2023 10:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683540445;
	bh=WnQG9QahQZcXdqiwHabAorCJ6vwWkb516RGBqHCi98w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EFWwL1y/rqIyrjLhxKodPcZC1L8kg1BJJMLTFjCc2ftnSuNVfgzGIY9TDcSpQ7r48
	 pa9tSGU3cBYEiE7knjjLrS6c3Iaeju4aDVDfe0dtm+QgsG9YBHqsnTwB+KZuvIQx7S
	 MrDLoyVgGS4KN2/CX8pg2zlDwz+6VlELeToIIBk4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiefeng Li <jiefeng_li@hust.edu.cn>,
	Dongliang Mu <dzm91@hust.edu.cn>,
	Sridhar Samudrala <sridhar.samudrala@intel.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 367/611] wifi: mt76: mt7921: fix missing unwind goto in `mt7921u_probe`
Date: Mon,  8 May 2023 11:43:29 +0200
Message-Id: <20230508094434.302676084@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jiefeng Li <jiefeng_li@hust.edu.cn>

[ Upstream commit 5c47cdebbaeb7724df6f9f46917c93e53f791547 ]

`mt7921u_dma_init` can only return zero or negative number according to its
definition. When it returns non-zero number, there exists an error and this
function should handle this error rather than return directly.

Fixes: 0d2afe09fad5 ("mt76: mt7921: add mt7921u driver")
Signed-off-by: Jiefeng Li <jiefeng_li@hust.edu.cn>
Reviewed-by: Dongliang Mu <dzm91@hust.edu.cn>
Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/usb.c b/drivers/net/wireless/mediatek/mt76/mt7921/usb.c
index 29c0ee330dbed..521bcd577640c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/usb.c
@@ -252,7 +252,7 @@ static int mt7921u_probe(struct usb_interface *usb_intf,
 
 	ret = mt7921u_dma_init(dev, false);
 	if (ret)
-		return ret;
+		goto error;
 
 	hw = mt76_hw(dev);
 	/* check hw sg support in order to enable AMSDU */
-- 
2.39.2




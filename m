Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96906BA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:18:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE163C433D2;
	Tue,  7 Mar 2023 17:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209520;
	bh=bnsJzPUpSXIZCzh0Rg9jQSjAKnyAM+T5QrW/clb2z5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AtkAhogZ5XPmp5bjmKW7vuZfe9u1wxgxHvOjBvU4c77S0EXaossB7A86Z8B99K9vB
	 li1d6ExKnkiXKFDMsAShP6nW6QptrWx0k1IsaktkB7zvuT85Xsohkt7qNWiEIDQqM2
	 mODk/PGUA/P3z/ws5M6mUnqTH8yhwLjF8M5DTnhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Deren Wu <deren.wu@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0245/1001] wifi: mt76: mt7921: fix invalid remain_on_channel duration
Date: Tue,  7 Mar 2023 17:50:17 +0100
Message-Id: <20230307170032.431051121@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Deren Wu <deren.wu@mediatek.com>

[ Upstream commit c36457a8f34d1e0fc55fbbd7b8b2d716af3f6289 ]

round_jiffies_up() may change the duration reported from chip. We should
take the real timeout for current channel privilege.

Fixes: 034ae28b56f1 ("wifi: mt76: mt7921: introduce remain_on_channel support")
Signed-off-by: Deren Wu <deren.wu@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
index bd929b5f2504f..7253ce90234ef 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -174,7 +174,7 @@ mt7921_mcu_uni_roc_event(struct mt7921_dev *dev, struct sk_buff *skb)
 	wake_up(&dev->phy.roc_wait);
 	duration = le32_to_cpu(grant->max_interval);
 	mod_timer(&dev->phy.roc_timer,
-		  round_jiffies_up(jiffies + msecs_to_jiffies(duration)));
+		  jiffies + msecs_to_jiffies(duration));
 }
 
 static void
-- 
2.39.2




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C964F9E1
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:33:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E066AC433C7;
	Mon, 11 Sep 2023 14:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442818;
	bh=5USf60H8sS//ybTsHoFqh7rymLThQMBzuA/lN/U123Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IDOSy71/AE7qJJfm1UQ+rlY7nJSRRiyIHgrPs42Gz5d7cM6ZbnY0v5IjHX40KNbZn
	 p9QuaNbODerlMzr5rpoeBwvMPsh2R3fnrd2aA2bxONcZw9Y1w88GRqnuhEX1eqOtbN
	 139pXGLzhxgEhjiGhpLzOTRl4nVWLLRdtnpjO8dc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	StanleyYP Wang <StanleyYP.Wang@mediatek.com>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 159/737] wifi: mt76: mt7915: fix background radar event being blocked
Date: Mon, 11 Sep 2023 15:40:18 +0200
Message-ID: <20230911134654.935920730@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: StanleyYP Wang <StanleyYP.Wang@mediatek.com>

[ Upstream commit 9a3994077d170ec9ac75e800932b5671d9940cd2 ]

The background radar uses MT_RX_SEL2 as its band indication, so fix it.

Fixes: 7a53eecd5c87 (wifi: mt76: mt7915: check the correctness of event data)
Signed-off-by: StanleyYP Wang <StanleyYP.Wang@mediatek.com>
Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index 9fcb22fa1f97e..088a065e37d5d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -274,7 +274,7 @@ mt7915_mcu_rx_radar_detected(struct mt7915_dev *dev, struct sk_buff *skb)
 
 	r = (struct mt7915_mcu_rdd_report *)skb->data;
 
-	if (r->band_idx > MT_BAND1)
+	if (r->band_idx > MT_RX_SEL2)
 		return;
 
 	if ((r->band_idx && !dev->phy.mt76->band_idx) &&
-- 
2.40.1




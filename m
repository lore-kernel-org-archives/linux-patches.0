Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C91C0433C1
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ScYFCDoG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 791D6C433C8;
	Wed, 15 Nov 2023 19:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077052;
	bh=+Kcq2xDFG7GMnqQcDgpa7iqGZNNZbgbDPqnYvPZwzWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ScYFCDoG2JArMe3PbDI6oxmO2UDyOCQ51o9zGzer212WXox83XYo48uSQw8d6NMIA
	 5QKqTXkA42lVNwg+LbaydJp+q6+1la66R6Ei5rIzkOahVpW/HNIX8vJg5jtG7L02I6
	 q7VOyA9q0cmowqzAjHjOgg4nexA52gheARDLvKoY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Chiu <chui-hao.chiu@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 087/603] wifi: mt76: mt7996: fix rx rate report for CBW320-2
Date: Wed, 15 Nov 2023 14:10:32 -0500
Message-ID: <20231115191619.154950882@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Chiu <chui-hao.chiu@mediatek.com>

[ Upstream commit 0197923ecf5eb4dbd785f5576040d49611f591a4 ]

RX vector reports channel bandwidth 320-1 and 320-2 with different
values. Fix it to correctly report rx rate when using CBW320-2.

Fixes: 80f5a31d2856 ("wifi: mt76: mt7996: add support for EHT rate report")
Signed-off-by: Peter Chiu <chui-hao.chiu@mediatek.com>
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index 269e023e43113..c43839a205088 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -433,7 +433,9 @@ mt7996_mac_fill_rx_rate(struct mt7996_dev *dev,
 	case IEEE80211_STA_RX_BW_160:
 		status->bw = RATE_INFO_BW_160;
 		break;
+	/* rxv reports bw 320-1 and 320-2 separately */
 	case IEEE80211_STA_RX_BW_320:
+	case IEEE80211_STA_RX_BW_320 + 1:
 		status->bw = RATE_INFO_BW_320;
 		break;
 	default:
-- 
2.42.0




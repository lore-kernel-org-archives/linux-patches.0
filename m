Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA5F71170F
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 13:55:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 649D6C433C8;
	Mon, 11 Sep 2023 13:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694440531;
	bh=JT9XJyziMxWMBHAWenGQqLEnNdmjAN5eOaCcBzizCZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RDAabyDC/YPxDyU8Hh62IIIqYMcNZdW1k84w6nkim2FiDGRW2icSm2aH8nhKwly2M
	 gyfJhPl+L58etga46CueNAVrvY+z7r5ZnhbmXO0TyDV1aV0tKklbsvBGwTpVHEpGi6
	 nbs1b6lZqvPaxTCVSve6rqh7vNPZC2xfBDRAG7Gw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 095/739] wifi: mt76: mt7915: remove VHT160 capability on MT7915
Date: Mon, 11 Sep 2023 15:38:14 +0200
Message-ID: <20230911134653.758315805@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 3ec5ac12ac8a4e6b1e085374325a5fbd1b650fd5 ]

The IEEE80211_VHT_CAP_EXT_NSS_BW value already indicates support for half-NSS
160 MHz support, so it is wrong to also advertise full 160 MHz support.

Fixes: c2f73eacee3b ("wifi: mt76: mt7915: add back 160MHz channel width support for MT7915")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/init.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/init.c b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
index 927a98a315ae8..9defd2b3c2f8d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
@@ -414,7 +414,6 @@ mt7915_init_wiphy(struct mt7915_phy *phy)
 			if (!dev->dbdc_support)
 				vht_cap->cap |=
 					IEEE80211_VHT_CAP_SHORT_GI_160 |
-					IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160MHZ |
 					FIELD_PREP(IEEE80211_VHT_CAP_EXT_NSS_BW_MASK, 1);
 		} else {
 			vht_cap->cap |=
-- 
2.40.1




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FE91BA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:13:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77DE4C433EF;
	Tue,  7 Mar 2023 17:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209201;
	bh=DYkx6xxsXAvRB8kI4LphUC1la9WpglVDAM7yBb/pazM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LUWxovUMjfJjJ/XTq2HVPuwsfYIpBlkxd3dgmG6UbZpXB75wYcRRmG4b507aTR8uB
	 ZrQ3fcNu+Ph304CbB9TtgTdIoGVpUBDCF5gGb/1gmvA60xEuqyBCogrCpcc+uAufMs
	 c5/B2vGw/rBR/krs0T6A7CDTBPhnXrQto0XLSBJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0142/1001] wifi: mt76: mt7996: fix endianness warning in mt7996_mcu_sta_he_tlv
Date: Tue,  7 Mar 2023 17:48:34 +0100
Message-Id: <20230307170028.216225996@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 54ccb836ffb28eacba51b674cbe94cb5613f8441 ]

Fix the following sparse warnings in mt7996_mcu_sta_he_tlv routine:

warning: incorrect type in assignment (different base types)
   expected unsigned char
   got restricted __le16 [usertype]
warning: incorrect type in assignment (different base types)
   expected unsigned char
   got restricted __le16 [usertype]

Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index da72684e43083..a88fc7680b1a9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -909,8 +909,8 @@ mt7996_mcu_sta_he_tlv(struct sk_buff *skb, struct ieee80211_sta *sta)
 	he = (struct sta_rec_he_v2 *)tlv;
 	for (i = 0; i < 11; i++) {
 		if (i < 6)
-			he->he_mac_cap[i] = cpu_to_le16(elem->mac_cap_info[i]);
-		he->he_phy_cap[i] = cpu_to_le16(elem->phy_cap_info[i]);
+			he->he_mac_cap[i] = elem->mac_cap_info[i];
+		he->he_phy_cap[i] = elem->phy_cap_info[i];
 	}
 
 	mcs_map = sta->deflink.he_cap.he_mcs_nss_supp;
-- 
2.39.2




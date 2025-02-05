Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B85F1459F6;
	Wed,  5 Feb 2025 14:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765305; cv=none; b=LYHgYVbV5Xxhbh71EZLgH1IH1majEeb/loeoOg35E2iwwV/eAJVUJzjIP3TK+kbhL60hAblKiGc14/nx9Cvkvd5WR2q+VK+pFLY5sdhi+yqYIlMjyvZNqaIApKHrSlSvEjiDVVrJes9qengSVQu61vBshpfTWdxLpnKUhYpZtvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765305; c=relaxed/simple;
	bh=NY7TNak3BcL689FgxuikWxDpjuVmlR7wWKJTgP/xQEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GTZAjcziU66aM+3rpTU4d9vTyUSfuuoxv76niLGCyEjp9w8oqmR2zgUVA42zRuKH1kYzTkRsjmx3qD0U1x2nnHuvsTTuKYAE7VkkUo6/202JBKRDiz4Sn50V2ANBOZZvJHBQy1mE9ygOfXmVsVz90tfGaM0ZfQxDGOpYda+P+b4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PQY5hfZs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PQY5hfZs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A758C4CED1;
	Wed,  5 Feb 2025 14:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765305;
	bh=NY7TNak3BcL689FgxuikWxDpjuVmlR7wWKJTgP/xQEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PQY5hfZslIk/9MxKnhUrcvtRGUtZPvD1O6wEeumdiK0xt+5mkq7IpKbhUrBbladeh
	 K5DtR1gCd8h2iVn/CRAZf4gf9EtSYNFZY7VYbwBR2E82B2F7rzDiY0GmMOQ47W3GRf
	 Ibjpduvl3BnZZkeMPlKkTyFfwZkynvVi2FGD/cho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Chiu <chui-hao.chiu@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 208/590] wifi: mt76: mt7996: fix ldpc setting
Date: Wed,  5 Feb 2025 14:39:23 +0100
Message-ID: <20250205134503.240773700@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Chiu <chui-hao.chiu@mediatek.com>

[ Upstream commit da8352da1e4f476fdbf549a4efce4f3c618fde3b ]

The non-AP interfaces would not use conf->vht_ldpc so they never set
STA_CAP_VHT_LDPC even if peer-station support LDPC.
Check conf->vht_ldpc only for AP interface.

Without this patch, station only uses BCC to transmit packet in VHT mode.

Fixes: dda423dd65c3 ("wifi: mt76: mt7996: remove mt7996_mcu_beacon_check_caps()")
Signed-off-by: Peter Chiu <chui-hao.chiu@mediatek.com>
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Link: https://patch.msgid.link/20250114101026.3587702-7-shayne.chen@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index d6d80b1b2d697..265958f7b7871 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -2070,7 +2070,7 @@ mt7996_mcu_sta_rate_ctrl_tlv(struct sk_buff *skb, struct mt7996_dev *dev,
 			cap |= STA_CAP_VHT_TX_STBC;
 		if (sta->deflink.vht_cap.cap & IEEE80211_VHT_CAP_RXSTBC_1)
 			cap |= STA_CAP_VHT_RX_STBC;
-		if (vif->bss_conf.vht_ldpc &&
+		if ((vif->type != NL80211_IFTYPE_AP || vif->bss_conf.vht_ldpc) &&
 		    (sta->deflink.vht_cap.cap & IEEE80211_VHT_CAP_RXLDPC))
 			cap |= STA_CAP_VHT_LDPC;
 
-- 
2.39.5




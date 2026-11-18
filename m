Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058431;
	b=JpgnWFh1Jso82O1698m7/7iEHeI+QehyqZFQC3at5s7+OmuhpC0pTEbgKP3olkuE1vtc
	 hhBj3t/az0MWPnIMfehOfqukwfoioLlaW0rZLCqs0VYqlV9MLHXVBvC4s0o01A7617XPz
	 EizeX6nVJDv6HpDwhJtrIViIfpVMaS4gTZplYUjIpyXX7YmYla0+hsYwyIrx3rZzE+Wr+
	 NxdIfsZinaxRDBTPwSpIQx7IAEW/tWl/99gndpoJULRjVVVWOLmjOibOJKHbIj52ZxOsk
	 INsk45siJRuiudWrjhv8vOLNT3biIKKj3XkQiJjUcNaNUxlzt01Hawdfx9vzTS+bpfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058431;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PPwqx3gyAuK9AmusAkBlLDuJ01GZqeqylu5+7OqH0pc=;
	b=UFkId89Qbpl8oo7WPabiXwCHM6CGl0HMO/vcpHrTYNqHiDDQY8nH3Qtcy8HQlTVkbpFh
	 LHRI6hxsgNcYg+DVwLDj/KBrzH2kbIJ/jF8sZqmmHxh1qQz1le9UrXVscxUdZLdCGU6H1
	 RTyFFi3dEJr9nVFQl5FWR9gZixCDGoTVTXIdy1KLYjmWGKeXyMIyKrDpTpJfUdGEwWVuU
	 dzSjdzm+Nl4FDK8uXntfhjgbn1l2CHAButQVlXKVqjb79ZPG4j+XGUDH7W9bG/3w7SQpf
	 o8WsLXoNEPx+AfrgOdcTQR0YnoNECEjJzPjscATEteG7QWCAdrIndqhRcFUHezRZKMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sMVnX9HZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77421606A31C;
	Thu, 19 Nov 2026 03:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sMVnX9HZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3C511F000C4;
	Thu, 19 Nov 2026 03:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058431;
	bh=PPwqx3gyAuK9AmusAkBlLDuJ01GZqeqylu5+7OqH0pc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sMVnX9HZv0uBMvzNVSSTB+wfEVPh1GBeoAq/eGTVs5FlKOWoalm0ViiJ9EBK+tfbQ
	 9rrWnfO4zI9oU6wz8c+wWbslMd1zfSqbiOq562fYdJ4QhmTnZIxVjv+aKg1tq3xHkO
	 BP6/RnEjqDiAHhYxmS93HLmLHqx5Rcx+OuIRkSt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Mark Anthony Agarro <markanthonyagarro@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0481/1848] wifi: mt76: mt76x02: validate TX-status rate index before mac80211 handoff
Date: Wed, 18 Nov 2026 15:41:59 +0100
Message-ID: <20261118145934.358517044@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Anthony Agarro <markanthonyagarro@gmail.com>

[ Upstream commit fbd12e8dabc8a9d2e81f427906749b4cff85d641 ]

mt76x02_mac_process_tx_rate() extracts the rate index straight from
the hardware's raw TX-status word with no bounds check for the
HT/HT_GF/VHT cases, and mt76x02_mac_fill_tx_status() ignores its
return value. A stale or corrupt hardware index reaches mac80211's
minstrel_ht rate control, whose per-group rate array is a fixed 10
entries (MCS_GROUP_RATES), causing an out-of-bounds write.

Validate the index in mt76x02_mac_process_tx_rate() (HT: 0-31,
VHT: MCS nibble 0-9) and have mt76x02_mac_fill_tx_status() bail out
cleanly on failure instead of passing an invalid index through.

Fixes: 7c1f88812690 ("mt76: unify send_tx_status and related helpers")
Cc: stable@vger.kernel.org
Tested-by: Devin Wittmayer <lucid_duck@justthetip.ca>
Signed-off-by: Mark Anthony Agarro <markanthonyagarro@gmail.com>
Link: https://patch.msgid.link/20260826092755.480190-1-markanthonyagarro@gmail.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt76x02_mac.c  | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index c5d3bb1d04b04..cf050ce03c538 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -302,10 +302,14 @@ mt76x02_mac_process_tx_rate(struct ieee80211_tx_rate *txrate, u16 rate,
 		txrate->flags |= IEEE80211_TX_RC_GREEN_FIELD;
 		fallthrough;
 	case MT_PHY_TYPE_HT:
+		if (idx > 31)
+			return -EINVAL;
 		txrate->flags |= IEEE80211_TX_RC_MCS;
 		txrate->idx = idx;
 		break;
 	case MT_PHY_TYPE_VHT:
+		if ((idx & 0xf) > 9)
+			return -EINVAL;
 		txrate->flags |= IEEE80211_TX_RC_VHT_MCS;
 		txrate->idx = idx;
 		break;
@@ -493,18 +497,21 @@ mt76x02_mac_fill_tx_status(struct mt76x02_dev *dev, struct mt76x02_sta *msta,
 		first_rate = st->rate & ~MT_PKTID_RATE;
 		first_rate |= st->pktid & MT_PKTID_RATE;
 
-		mt76x02_mac_process_tx_rate(&rate[0], first_rate,
-					    dev->mphy.chandef.chan->band);
+		if (mt76x02_mac_process_tx_rate(&rate[0], first_rate,
+						dev->mphy.chandef.chan->band))
+			return;
 	} else if (rate[0].idx < 0) {
 		if (!msta)
 			return;
 
-		mt76x02_mac_process_tx_rate(&rate[0], msta->wcid.tx_info,
-					    dev->mphy.chandef.chan->band);
+		if (mt76x02_mac_process_tx_rate(&rate[0], msta->wcid.tx_info,
+						dev->mphy.chandef.chan->band))
+			return;
 	}
 
-	mt76x02_mac_process_tx_rate(&last_rate, st->rate,
-				    dev->mphy.chandef.chan->band);
+	if (mt76x02_mac_process_tx_rate(&last_rate, st->rate,
+					dev->mphy.chandef.chan->band))
+		return;
 
 	for (i = 0; i < ARRAY_SIZE(info->status.rates); i++) {
 		retry--;
-- 
2.53.0




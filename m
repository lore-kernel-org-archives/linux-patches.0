Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052502;
	b=K67gKycq9zrXBxV0SqyoDoPnNj22c9LaiTwILevvm3EUsol/vbMaTapcO0qeuu9OZEe7
	 tyjqJRagqy/p/oCAeeX69p8Q+7ZyurlxDUI/y8Li4Is5xkAEUojlE75GsWIRdkheHKATt
	 mT/QLdw+jy3rurojOr+Lh30ci/24h9Pg0aBr1FUFVGzVZT1GJqDtBDqXqjugNnHi5ypJF
	 RjGjgdX5esXBhfW+2qsAwGJy/nq4eLTI37BFwjNXxJeEKO26EBcMtSJcd7xgdrdSBtgsh
	 y6VyZcV3XoxZ+Xz8IMGvaAxuSK/OQaIzebsya53SnqozGm3XXt4ivUcQIMp4w2MJvVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052502;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vJAsEZ8VL4iHo7wMZXzlxe1snWwIWBCbtBplnPsc/Mc=;
	b=TAGy7OQLKlASIa7617vQHSUNNe5R3NPV1VUthPV5DfFiL/AKfu+hUe6nLBk21VEJ0fe2
	 EiMcUWyfRdqCtFdSAbxZnFhZ8hv0UohEOZtwLA/FsLs2OiVb8qCK9ASq63POCFFafSt1d
	 0XWSLQKvBhgibjzwxEKse6xHNgZtHNod7k9YmkW84kSyBIUpoy8ejRumWDjX1+KXdysdK
	 N2pJ4eRfX8g0v860M3JZSqTcp1X3RFHbqtj/5I1IdIKGn9154qj9UA0MTjP7P753sxq/f
	 VUzph1MBMpdMXBcXEOq68iH1pulzc2Fp/9Qq13T60Rr058rvr+xwyGapjdtNbt8maBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JEk59xlU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B8E1606A336;
	Thu, 19 Nov 2026 01:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JEk59xlU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D44F01F000C7;
	Thu, 19 Nov 2026 01:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052502;
	bh=vJAsEZ8VL4iHo7wMZXzlxe1snWwIWBCbtBplnPsc/Mc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JEk59xlUbWk51iPhr1bXepnVRTyIT9MQYOmpxbglGp2XNI6bw8YjJbE1A5fe2ApPl
	 r79ie/qWi2HgadvE9Sgfgk+ghNt1ZtNpg32MhRDSNHwMaw+VU47vOYQG9QwsEecFDQ
	 ASh5wY28hUXMliP/kKB7OI55DARWylPHrWLvf14U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Mark Anthony Agarro <markanthonyagarro@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0588/2214] wifi: mt76: mt76x02: validate TX-status rate index before mac80211 handoff
Date: Wed, 18 Nov 2026 15:37:44 +0100
Message-ID: <20261118150034.427729639@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index b0f8e29e3cc4d..d277dc1db8ef3 100644
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




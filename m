Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036344;
	b=qHQmDfcZPE3oe2fcOymkhmQWS1xSBhKpBSzGuwnBuZEkpOcym8V9g6DO1bL987IJmPYv
	 7RRgbR4+msOM3hF6jk1t6DjjV2iMnJ/JdGN16JeAAkUqvlRfl/h/cMPfakhFADsU22q+2
	 BZKTj+M8ivLKgZEesBHWFepH0BA+xZaujF0mxmbv2fW/hasMzNbUc1brG/smcM7WbBwy5
	 K8S6l1NvKPi1OhDBCCDtc4hTPvxvOKMPh/1ymr1DZenzawm0rQXKebVeLTTQpBLkLbpUp
	 3At0DqSmQvwh3jyUr3/KpIbJPbmec6HJ5jRXqogXrNcoVqi4cwOHW20jw/WfHZeIxvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036344;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6jIsf8WqSTLFT/t9PLiAk/kgR/VqDFBpWRXqnlveHmY=;
	b=KVCfIsQ8XlRB4AcAUM4iY8/Do9z1OPPkspot0JcwdeMUKv4avUxYznQG9Z69bDbuKWv/
	 co6LKoKxLcy8z0NIlnu8q8XJvv4Jtbfov3EoCAF1KOqEB852zUN1HdotbZ0yaP7L/tpZr
	 hV8XoTusT6qmEgasIB8IjhMedZjv2oDk1wuMEiesXTtPbsLI/OZPXyNVBq64DxpG+jUNI
	 mMpeXkUcRaNChWsurbNdtY7XrHJk6cKSAsyIJTZ1otQ5qgCdgw6XjU3goILWW6bDD8MwD
	 /olkP2Lz0HETUWrclEqFoRQiMljZUKkNdJvQcHjQkcJE2sLeinoEHarseL0V9VYQG2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="wBnj4/jb";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0F1A606A325;
	Wed, 18 Nov 2026 21:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wBnj4/jb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25B361F000C4;
	Wed, 18 Nov 2026 21:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036344;
	bh=6jIsf8WqSTLFT/t9PLiAk/kgR/VqDFBpWRXqnlveHmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wBnj4/jbDWt0Ffy62TP8oMyjl331lb0BPV9YTcFi3Q3dHdrYLEu1zTSZxyln0/BfI
	 xQGRw3dfE9LhQpDvVCP2dSDOz+ZId3Lzi9Bx8ePGDDLGCKxsHxqG6QJflM+/6zbmgZ
	 BjJv15Og8U2b2JVe/tVgfbayspWT5vLT563u3ThQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Mark Anthony Agarro <markanthonyagarro@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1027/3318] wifi: mt76: mt76x02: validate TX-status rate index before mac80211 handoff
Date: Wed, 18 Nov 2026 15:27:29 +0100
Message-ID: <20261118150350.694272820@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 14cfa597fb622..d5ee2bb6f679b 100644
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




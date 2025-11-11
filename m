Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB0C733437F;
	Tue, 11 Nov 2025 01:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823952; cv=none; b=I17ev6UCwbp0Z17S9nbk88MptxNRjF21KZd3dCr0Gg39DMQKL3/wQr/XhbOZd2i+o5pReflC4d074ZdrfXH82A6vqWEjMQtfJNyri+oj+iilGY1M5l/C0Ynrqkeg8y+IKPzqLeaV9ehw7V+WjKRPneUWIedK9E5J/Q7mvruD+7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823952; c=relaxed/simple;
	bh=8Wc3QLhdX2cICQ1cg5aDggJC8W9ehMj4QuKcIkpEtGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EgbqQG/yZ3IB/EgouO+61xuYrgO6G/x4Gmu2Wdi22G3RIW2i7hTEu5NZFcWyrvi9S6E97Z6ysz4fH9KeIgnWmBCM5RwUsDoaezLTYWANYXwgt9K5IU7cR93kBHygBP/N3/b3LbN+pIc0FmXldBqB/U1ytyYX1qJRKvojDiMeWzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TCnmKDgv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TCnmKDgv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 747BAC4CEFB;
	Tue, 11 Nov 2025 01:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823951;
	bh=8Wc3QLhdX2cICQ1cg5aDggJC8W9ehMj4QuKcIkpEtGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TCnmKDgvybFQeZzuRDnhI3XilnyzyTL16U6LYz8FKxDGWSKfuBf+k8S2rqdmRZHSx
	 ZKejvM3WhFurwKBEDKyN3cqBYGhpIMhkZF8vgFgJuNde2+eCD8KnsW8iFxQ+8XG9Qb
	 IAXIP3RarJ3Gx3K3T1asCGcC90vACyxZQKWkCZTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Lin <benjamin-jw.lin@mediatek.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 356/565] wifi: mt76: mt7996: Temporarily disable EPCS
Date: Tue, 11 Nov 2025 09:43:32 +0900
Message-ID: <20251111004534.880093481@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Benjamin Lin <benjamin-jw.lin@mediatek.com>

[ Upstream commit e6291bb7a5935b2f1d337fd7a58eab7ada6678ad ]

EPCS is not yet ready, so do not claim to support it.

Signed-off-by: Benjamin Lin <benjamin-jw.lin@mediatek.com>
Co-developed-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20250904-mt7996-mlo-more-fixes-v1-4-89d8fed67f20@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/init.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/init.c b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
index 91b7d35bdb431..65bd9c32d42c1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
@@ -1190,7 +1190,6 @@ mt7996_init_eht_caps(struct mt7996_phy *phy, enum nl80211_band band,
 	eht_cap->has_eht = true;
 
 	eht_cap_elem->mac_cap_info[0] =
-		IEEE80211_EHT_MAC_CAP0_EPCS_PRIO_ACCESS |
 		IEEE80211_EHT_MAC_CAP0_OM_CONTROL |
 		u8_encode_bits(IEEE80211_EHT_MAC_CAP0_MAX_MPDU_LEN_11454,
 			       IEEE80211_EHT_MAC_CAP0_MAX_MPDU_LEN_MASK);
-- 
2.51.0




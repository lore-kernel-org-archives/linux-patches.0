Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06AE9156F44;
	Wed,  5 Feb 2025 14:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765801; cv=none; b=H0In/+Dn9vv5gfXj2UVQEiRAgI0vF1mzF13hRNOD2e+QMe2s6i6Iql47eND5un99BtpjY+ANVNh0n56OGjUTtRMMoSM9nQ9L9CHMmTgD3BRNBldfyY7VcAEPHqZgbYYFqNLeaL6gNwUfMW9x6hJ7qiyAloYMxcBK8ZFcoCaQb3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765801; c=relaxed/simple;
	bh=lZ6r0qB1oUwYvrhrz19KzVlL8s0xoraQComtMX7D+xQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fLVFwkontBhQW9fRV5c6ijfCBVWDbl6176WW9Fi/VzBl1c4s2emCsMY9ImNZgh9IGmySFi3hbX7YRDY9fCaKoyTjdTrp1oANiObxhXuqnOmqZyr/60pT72bm3htn8EDMZDFdOEpHIiw2CKP/MNQrynSHxvt3L/9aRwg8FCFx/Pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kF/q9Uom; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kF/q9Uom"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DCEAC4CEDD;
	Wed,  5 Feb 2025 14:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765800;
	bh=lZ6r0qB1oUwYvrhrz19KzVlL8s0xoraQComtMX7D+xQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kF/q9UomlMAiJw40sxxDy6blUb28UDiV/zsCWVCVrGg03dCVxmKaO3OOV3uYpCKm7
	 N+2WQyxHF4N96A+l7NfVJQrAXKJo0a/GWGqTk45msV2y3bhVTPuS5R36H2DHQ7hqTa
	 ZfJqaxUFO1oobY5Le2ppRSgNVsQjCxbSqP9+T2kw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"allan.wang" <allan.wang@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 190/623] wifi: mt76: mt7925: Fix incorrect WCID phy_idx assignment
Date: Wed,  5 Feb 2025 14:38:52 +0100
Message-ID: <20250205134503.505748200@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: allan.wang <allan.wang@mediatek.com>

[ Upstream commit 4f741a2378b27a6be5e63b829cae4eb9cf2484e7 ]

Fix incorrect WCID phy_idx assignment.

Fixes: 86c051f2c418 ("wifi: mt76: mt7925: enabling MLO when the firmware supports it")
Signed-off-by: allan.wang <allan.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Link: https://patch.msgid.link/20241211011926.5002-5-sean.wang@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/main.c b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
index cbc7a50810256..268d216f09e20 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -384,7 +384,7 @@ static int mt7925_mac_link_bss_add(struct mt792x_dev *dev,
 
 	INIT_LIST_HEAD(&mlink->wcid.poll_list);
 	mlink->wcid.idx = idx;
-	mlink->wcid.phy_idx = mconf->mt76.band_idx;
+	mlink->wcid.phy_idx = 0;
 	mlink->wcid.hw_key_idx = -1;
 	mlink->wcid.tx_info |= MT_WCID_TX_INFO_SET;
 	mt76_wcid_init(&mlink->wcid);
@@ -851,7 +851,7 @@ static int mt7925_mac_link_sta_add(struct mt76_dev *mdev,
 	INIT_LIST_HEAD(&mlink->wcid.poll_list);
 	mlink->wcid.sta = 1;
 	mlink->wcid.idx = idx;
-	mlink->wcid.phy_idx = mconf->mt76.band_idx;
+	mlink->wcid.phy_idx = 0;
 	mlink->wcid.tx_info |= MT_WCID_TX_INFO_SET;
 	mlink->last_txs = jiffies;
 	mlink->wcid.link_id = link_sta->link_id;
-- 
2.39.5




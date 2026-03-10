Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BF54387361;
	Tue, 10 Mar 2026 11:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142167; cv=none; b=MHgwrJY4W3PNu4wD1TaQzg52o/FDRSBX6c81AbMO+Pv6sMkrrhli2Sh/cf2cndXAvi8HOGFaQPOGrrUQ8pyWKe5oJ1iys3WytgjOUoG+kIj4DYwQVsg2xmMOrQmoSkre9B0ZzP3JgwRfpgG/GUyA1GS2nbG/CR4HjIC9KhaX3v8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142167; c=relaxed/simple;
	bh=XZH1CbhL97Oyfwq8el4XzjFxflWez7lSM3SUl7bjOp0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=omjnQ0Uw8VyIHhWA+OsilZ/OCpywXKIjK5FmbutEE16XO573btw8pC4YYy/ARGXFpU8K7ucwbUkllq1X0yDM8+NFjaWC0usDZlgcS1FgFRL9VjgExNeAWIbiJItQUbVynYnFLUE2wR0jr2hhl0LstZpYYDxzgq/iuNdXoKT2HEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z4zUx34C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z4zUx34C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83A1FC2BC9E;
	Tue, 10 Mar 2026 11:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142167;
	bh=XZH1CbhL97Oyfwq8el4XzjFxflWez7lSM3SUl7bjOp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z4zUx34CR9nUauVohrayiD4iZixk4ZRaWCUmgbah8u1XsgKPCGyqIDth6W2QaiimE
	 h5nhncjvgcG+Y+TxaYAdRLNhQE7uPNDRY2rSI/JBz5zEPLLV3jFpc39uJLseUW7K2e
	 wXaEAkG4QVCPDEdsAqEnYRFptj/V+KoMgYefYg6XMsV1Xpr+MT53yzX1ms7+Uxh9iI
	 T3zizgCvbhAwl5SOs3LmhBYAzf9ba8YuKO+N3tj6V1SFElN4aYSRcQCivQ+Vhl0Ko1
	 S4DKtWp6BDphMWP94MnlvpqYFPl+uaOJEJM+3EEgQ6UZg+VtUIZueNwOA5sbz6O4Nw
	 hmeIOz32dBqrQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo@kernel.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 255/314] wifi: mt76: mt7996: Fix possible oob access in mt7996_mac_write_txwi_80211()
Date: Tue, 10 Mar 2026 07:18:34 -0400
Message-ID: <775b53de11b63281cd5e3159619f166286a7db1a.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 60862846308627e9e15546bb647a00de44deb27b ]

Check frame length before accessing the mgmt fields in
mt7996_mac_write_txwi_80211 in order to avoid a possible oob access.

Fixes: 98686cd21624c ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20260226-mt76-addba-req-oob-access-v1-1-b0f6d1ad4850@kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index 502136691a69e..0958961d2758e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -799,6 +799,7 @@ mt7996_mac_write_txwi_80211(struct mt7996_dev *dev, __le32 *txwi,
 	u32 val;
 
 	if (ieee80211_is_action(fc) &&
+	    skb->len >= IEEE80211_MIN_ACTION_SIZE + 1 &&
 	    mgmt->u.action.category == WLAN_CATEGORY_BACK &&
 	    mgmt->u.action.u.addba_req.action_code == WLAN_ACTION_ADDBA_REQ) {
 		if (is_mt7990(&dev->mt76))
-- 
2.51.0


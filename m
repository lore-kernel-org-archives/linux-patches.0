Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 867CF3876CD;
	Tue, 10 Mar 2026 11:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141240; cv=none; b=eNMCT+czdDm0Es9S3Kr6F9MUaOHFsuTx0dqbTZHTnYq5GO/rkzMR5msL4h43CMN2clJCVIF1qspWvKZigAFP5d0cPNw4lv7v1nJwKssdv7zrWG1VNoXYAVUPdmSnWBVNDyHxALLtVQsnxN58mlEyHhsCp3S+w0U3vcrGKxxeQEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141240; c=relaxed/simple;
	bh=NTP097G4gOropTkbcSR7bAOtWhSH/7uKWpZQLQPr9f4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h0bCAaSxX/MIu36CSeG/wFKhwCDr+TnzUHyzIhtvzI6HWs0cTTrdtb9FiUVRt+oxAEoVXlH1lRShKduhNZeqHfKqxC09mOVP+2IvoKSAOIwlLFINjbiJhECJavJ/OpToiTNf3z/H60kY5FGBrAcLM5kf3qYR2AbahO2AF3UgG4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D+sPP43A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D+sPP43A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50F0BC2BC9E;
	Tue, 10 Mar 2026 11:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141239;
	bh=NTP097G4gOropTkbcSR7bAOtWhSH/7uKWpZQLQPr9f4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D+sPP43A4fhq9IlHRPJQwsUcypvwqUtHIshpsvZ0KDqhStAMxxS4bvyWFZOE3GpaV
	 v+qsDSz02mLr/3+7Bao9OckI75nDIhV67dc23EnR8pxZmlOpaeuVSrZC/1VzM1jdYU
	 rjIBW6zjlrKzuyjfe/lb1BdaRUD1F1cu+qwvsVOO0K9tVqkL41wXzf2RqtU3I0+Gfm
	 ewOzH/E6YtFG2tHUkIzEEDIZoqN0hHQUbRiV05a9eK0I/mVqxQyWkPky5VJfnjX4/E
	 zZYeFGXhlGST6jQAgJdiQZQhVWOm4q548Jxok1Hag0Dtt4t+2tqnVHjt8LXUhrnQ8j
	 7xjBN5rTR07Qw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo@kernel.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 242/311] wifi: mt76: Fix possible oob access in mt76_connac2_mac_write_txwi_80211()
Date: Tue, 10 Mar 2026 07:04:49 -0400
Message-ID: <c74cc8fd3689ce119d1d2292b43bfefc7b2992f8.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
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

[ Upstream commit 4e10a730d1b511ff49723371ed6d694dd1b2c785 ]

Check frame length before accessing the mgmt fields in
mt76_connac2_mac_write_txwi_80211 in order to avoid a possible oob
access.

Fixes: 577dbc6c656d ("mt76: mt7915: enable offloading of sequence number assignment")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20260226-mt76-addba-req-oob-access-v1-3-b0f6d1ad4850@kernel.org
[fix check to also cover mgmt->u.action.u.addba_req.capab,
correct Fixes tag]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c b/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c
index 3304b5971be09..b41ca1410da92 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c
@@ -413,6 +413,7 @@ mt76_connac2_mac_write_txwi_80211(struct mt76_dev *dev, __le32 *txwi,
 	u32 val;
 
 	if (ieee80211_is_action(fc) &&
+	    skb->len >= IEEE80211_MIN_ACTION_SIZE + 1 + 1 + 2 &&
 	    mgmt->u.action.category == WLAN_CATEGORY_BACK &&
 	    mgmt->u.action.u.addba_req.action_code == WLAN_ACTION_ADDBA_REQ) {
 		u16 capab = le16_to_cpu(mgmt->u.action.u.addba_req.capab);
-- 
2.51.0


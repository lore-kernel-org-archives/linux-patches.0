Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C033876CD;
	Tue, 10 Mar 2026 11:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141238; cv=none; b=FO+z+IHRsQ5NsCmz8orNpKbqQ7hxeKipvQZJSO19ixzkJc37rC5h5RAW8x/L3EeMFoX8NRa2gKz+tqGIk22kka87rR+WbLaFElMpU4hWQVO5tO8y5IvoeTLHTl7ywyT42wKla7Yxukkd/7ucSNlTk0eHJRs/avJFXpD0ZqrC0LA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141238; c=relaxed/simple;
	bh=V+jk6Vcox9tUYano4f0UUwOC8BbXFEuKO5puMu1d6eo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b6tb72rvceoP3Tb0MjxPiWgy5yf9oC7Q4ayXrCeuwLOsm1vhWP/ZRNwGdfiG046JU2FqmOrggkXq8xEydQHUMIUTmkLECH8oMu8S0rOO78Qv246WRRLEQIBBQth+ow1Hu1JSfhbkoFF2jJsnV0qMlz6cmn6xSeselmlh/tp7DIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZqJYf5hR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZqJYf5hR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1FE2C2BC9E;
	Tue, 10 Mar 2026 11:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141238;
	bh=V+jk6Vcox9tUYano4f0UUwOC8BbXFEuKO5puMu1d6eo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZqJYf5hRMLOP29ZTJIuJ2u+Eo6RK/nvDSpiDeXsKU8rPopzK452OwCaQ9xbkDQgdi
	 zVfp1HWFzCdKunkvI3MZUWA09i8Yt4UZ0Rk4FFRRRTb9EidJy9hhdGvfCdRSDExqEn
	 +ycWQILE3mF4dcaGViuac/RhwtswAJGiXVDj4rVd8gXreIMWFZBbClyCLYOsAACWxn
	 47L10HdieDwodmy77iAHkEibImQ6lNrgu55qTsq8sudMwdjrtK/kTSgT7C/6fyTDRo
	 B4N06riiD3ssnaIvLhftBhC1IjdUctRuyeGkLRqaZjAVANCiB67mKyki2Ge7v8RMIx
	 R1rwvX9dIBR7g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo@kernel.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 240/311] wifi: mt76: mt7996: Fix possible oob access in mt7996_mac_write_txwi_80211()
Date: Tue, 10 Mar 2026 07:04:47 -0400
Message-ID: <f229967596d157008e48441781c2593ae1dfaf66.1773140655.git.sashal@kernel.org>
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
index 2560e2f46e89a..d4f3ee943b472 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -800,6 +800,7 @@ mt7996_mac_write_txwi_80211(struct mt7996_dev *dev, __le32 *txwi,
 	u32 val;
 
 	if (ieee80211_is_action(fc) &&
+	    skb->len >= IEEE80211_MIN_ACTION_SIZE + 1 &&
 	    mgmt->u.action.category == WLAN_CATEGORY_BACK &&
 	    mgmt->u.action.u.addba_req.action_code == WLAN_ACTION_ADDBA_REQ) {
 		if (is_mt7990(&dev->mt76))
-- 
2.51.0


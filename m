Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07102126C02;
	Tue, 16 Dec 2025 11:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886062; cv=none; b=ZUY3fGl5to+AGbezFNJk/OzsktAKioAzhhTjuSiadhyV45zGDgVvr3LndzvdyyT8yiCY0RnVzxtWi/3O5qOGkZgWpzad4dJ4DUszjiN10Q5NKpNmABVs0P2PAmAqm8sb5Gz+EtdXw1KFgXxhRQNMDAKxeRlVC0J+FBYavz1IHTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886062; c=relaxed/simple;
	bh=TrZUAQBXpNSrqH/E7A2jSEDUjK9NVrrKHLY72z1pgnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oyA1wyzOD7YWmqXeWIybmbOOxKQzdRyQ0PfKJx0yd1xeOWCh4yqELTmOthbWxlt30kZLq80CLHHN1eQ/xFQxOdnPMRKfIA2fnfNUbIidfmyi/b8lFOLS/wY7EUZv0eG7JT6gXHTkeSKc0FDbJTmhefgZk6W0acZMAdbtzXJY6qI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j5XIOYJ8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j5XIOYJ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A8B5C4CEF1;
	Tue, 16 Dec 2025 11:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886061;
	bh=TrZUAQBXpNSrqH/E7A2jSEDUjK9NVrrKHLY72z1pgnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j5XIOYJ8yaYqzz4KVnU5mJFj7+luYtuihCSAE1lcQ3wVKxsbzEiV90SVmGW25+b+a
	 N1LrNN4B4SxCeWqUxey5Ed85znB4rPyGwi3frbiQlb+zhkBOAfbS5lz98oS9IeG9R3
	 9ADRwtrjxdliMalUn+glt3WV+0WXL8LLtIy3G2+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	StanleyYP Wang <StanleyYP.Wang@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 327/507] wifi: mt76: mt7996: fix max nss value when getting rx chainmask
Date: Tue, 16 Dec 2025 12:12:48 +0100
Message-ID: <20251216111357.312493870@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: StanleyYP Wang <StanleyYP.Wang@mediatek.com>

[ Upstream commit 361b59b6be7c33c43b619d5cada394efc0f3b398 ]

Since wiphy->available_antennas_tx now accumulates the chainmask of all
the radios of a wiphy, use phy->orig_antenna_mask to get the original
max nss for comparison.

Fixes: 69d54ce7491d ("wifi: mt76: mt7996: switch to single multi-radio wiphy")
Signed-off-by: StanleyYP Wang <StanleyYP.Wang@mediatek.com>
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Link: https://patch.msgid.link/20251106064203.1000505-1-shayne.chen@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
index 498a2eefd7a8a..5a415424291f8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
@@ -720,7 +720,7 @@ void mt7996_memcpy_fromio(struct mt7996_dev *dev, void *buf, u32 offset,
 
 static inline u16 mt7996_rx_chainmask(struct mt7996_phy *phy)
 {
-	int max_nss = hweight8(phy->mt76->hw->wiphy->available_antennas_tx);
+	int max_nss = hweight16(phy->orig_antenna_mask);
 	int cur_nss = hweight8(phy->mt76->antenna_mask);
 	u16 tx_chainmask = phy->mt76->chainmask;
 
-- 
2.51.0




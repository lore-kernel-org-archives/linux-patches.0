Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84B7214D42C;
	Tue, 23 Jan 2024 00:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969285; cv=none; b=Jo1C5FAoTfrAnG33HJW+m+FNdoSQMpITX11kVpXXU0uCTu0ib/bsCAmIwM4j+Z8s05W4aOnCXyjTcAKOxpRoUtpMHopVY3ZjfuBIfXGbrkmSjbBfMJnNdlEaBs45UYUXQcg//eRIkwtD+T9Pp1bYwuRTG9XQ1Uw6CT2FOzZw8b4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969285; c=relaxed/simple;
	bh=PTB120Hxrj+WeRBOyqWooWwfG7uQFj26PKF9E2LuDNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rs+Wgvu5qbWgXY3nZyONh9xv+WL/kt1Ab05UwSw8XUSYLrnAKo282SQgiw+W4RxAjPX4oToA0qwEgbs+jJBDj3+FXeN+XfaydMrG+q/pWOVBk+/YopceHjqXdelgVzFg+1l5HVKUu6qf31dhTdb/1wH+PVwWtkdNdLXn9YvCwew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G9BNK0R6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G9BNK0R6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0500DC43601;
	Tue, 23 Jan 2024 00:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969285;
	bh=PTB120Hxrj+WeRBOyqWooWwfG7uQFj26PKF9E2LuDNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G9BNK0R6J/fwSgPiHMLmFzKaIBA3sqbmshuYBMN4IGMyK8wPMj4M2MEwoz7Gj78KR
	 8Gv/h7LdYQvIJ5t2QkORLGQ+lKZtdxYbxi6LhBP3lvkYK6LoheCwMUwpiSv8b50rc7
	 HYHllMdkKZKgzKmsFR/7vswr484xgZhioyZzAjr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi-Chia Hsieh <yi-chia.hsieh@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 146/641] wifi: mt76: mt7996: fix uninitialized variable in parsing txfree
Date: Mon, 22 Jan 2024 15:50:50 -0800
Message-ID: <20240122235822.616524952@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yi-Chia Hsieh <yi-chia.hsieh@mediatek.com>

[ Upstream commit 706e83b33103fc5dc945765ddbf6a3e879d21275 ]

Fix the uninitialized variable warning in mt7996_mac_tx_free.

Fixes: 2461599f835e ("wifi: mt76: mt7996: get tx_retries and tx_failed from txfree")
Signed-off-by: Yi-Chia Hsieh <yi-chia.hsieh@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index 04540833485f..59ab07b89087 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -1074,7 +1074,7 @@ mt7996_mac_tx_free(struct mt7996_dev *dev, void *data, int len)
 	struct mt76_phy *phy3 = mdev->phys[MT_BAND2];
 	struct mt76_txwi_cache *txwi;
 	struct ieee80211_sta *sta = NULL;
-	struct mt76_wcid *wcid;
+	struct mt76_wcid *wcid = NULL;
 	LIST_HEAD(free_list);
 	struct sk_buff *skb, *tmp;
 	void *end = data + len;
-- 
2.43.0




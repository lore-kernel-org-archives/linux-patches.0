Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D40C3876CD;
	Tue, 10 Mar 2026 11:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141239; cv=none; b=uavpaNyWpgAMARX4zsL7C43Lqo9RLp/77ZkQfKQtxE8D/GeYq/nv3URZ/IS/iZusvXOu5iER3tGYnYrp7sMaNumdTNswtRmxCQYed5Oh82Po3isFG0Rh1FRkrREgW9bFSffDZRl0Rj/n9t2krOrUHGUWpI7L8VJ8R4VyNtnl6nA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141239; c=relaxed/simple;
	bh=KvsGxxdI6kkO1wiapVx44LC2U/o5xkW6A+EPiZm4i34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M2klFFJfDENevg4zE09kRFbXPufhELIjhwcDqkzM1SYd4oJfd8dlvmtE7Ctpb6AFyBH1z0WpGcFWKXhCou2upC/BSs9oD6fl0Qjfvd8mvTo0vG3336zT0Xo4NtKLP44VKgrG0X4aBSkzMo9uwde6stI3m+6vuRT/GrXe3bEE55E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V4B2/bXF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V4B2/bXF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78137C19423;
	Tue, 10 Mar 2026 11:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141239;
	bh=KvsGxxdI6kkO1wiapVx44LC2U/o5xkW6A+EPiZm4i34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V4B2/bXFA3gY3BPxhtnEkWlTbOmE046K6F3o9R+QkW9BwpXQPKhkzq279onPGViWT
	 PbwfP7A3Eh3FbEUpwA8Auf75w0+fnNVgilrfELjDQc+v9W4Vist1oLFFCNcQhBx0pl
	 fHwqRTUFRklw5shxNUtJNzUOMF+jYubcj05+f3/prV0hDWSJh7i2nzYF6QtYfUqV5M
	 H8n0Jt36+Jk/lmM0POcTghHItmXTGypFV3r+TX4eq12OAe8aTTSNWVQoeIjQyx1DDr
	 8oM2F4vy0I/1e5k8Xgvy04d6pASf9ZOcoF0/vZ83ym7ybkFYX2Mdy/Xa4ry5Eyu2Vf
	 JWWCALkF5dFQw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo@kernel.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 241/311] wifi: mt76: mt7925: Fix possible oob access in mt7925_mac_write_txwi_80211()
Date: Tue, 10 Mar 2026 07:04:48 -0400
Message-ID: <f606ef47eba2636bcc88b3c80dd0806e362d5a22.1773140655.git.sashal@kernel.org>
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

[ Upstream commit c41a9abd6ae31d130e8f332e7c8800c4c866234b ]

Check frame length before accessing the mgmt fields in
mt7925_mac_write_txwi_80211 in order to avoid a possible oob access.

Fixes: c948b5da6bbec ("wifi: mt76: mt7925: add Mediatek Wi-Fi7 driver for mt7925 chips")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20260226-mt76-addba-req-oob-access-v1-2-b0f6d1ad4850@kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/mac.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c b/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
index 871b67101976a..0d94359004233 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
@@ -668,6 +668,7 @@ mt7925_mac_write_txwi_80211(struct mt76_dev *dev, __le32 *txwi,
 	u32 val;
 
 	if (ieee80211_is_action(fc) &&
+	    skb->len >= IEEE80211_MIN_ACTION_SIZE + 1 &&
 	    mgmt->u.action.category == WLAN_CATEGORY_BACK &&
 	    mgmt->u.action.u.addba_req.action_code == WLAN_ACTION_ADDBA_REQ)
 		tid = MT_TX_ADDBA;
-- 
2.51.0


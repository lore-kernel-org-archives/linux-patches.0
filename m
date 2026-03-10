Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17BA938A709;
	Tue, 10 Mar 2026 11:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142168; cv=none; b=RFJwsIrWEfo5ABjggvPtRHpKtbW8qs2alhok3X1ONXtH/weA4aaTwK+ku3ll39iduhLgu+fqIC54/0Mw3TogBCnfhfnQImpy8kK1y764L1KiYePEbZxYwJD9VsQ/YC62wrtLbrVmP5TM6Z4dkR+6EkmLrZy1w4OHrbDXvZOnkq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142168; c=relaxed/simple;
	bh=H47E48822URMtUs/Wh6txbF02Sp4OSS57wMajdf9adk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lQOl7ouvb6dxfsQ7rvIlIonQtPonkcl7bOPnUMW973DptoLl5IDGgSmNY4ToE0iP0uffTGotbOE7nShCXds1J5sg9HapZIFsfRvaALX1EdmZ2ujP2xt1h1kqoFWhRlAWh/I5v+Nf/FL5TP6Dfatth1G0gB8N9SnnnxrZNLEOAzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bQO7xY+I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bQO7xY+I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60D28C2BC86;
	Tue, 10 Mar 2026 11:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142168;
	bh=H47E48822URMtUs/Wh6txbF02Sp4OSS57wMajdf9adk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bQO7xY+If13V2gsoaJtTnNqYLL2oR9QnAs0xItzDbfXUtJimBqVcIOjShNzEcN1iZ
	 WVw5T5F8FL/CrW0jU6QSuImYUNNCnIIeD+5Q2R12TufhRc76V+4+vibAEvt9G1hNFT
	 L+GsgBRPDFaWle2UzKF6ngWoPtAxwMNwuh2G9FGfehcjrZK11lz7nPRJn3T8Giu7fZ
	 1tWpL6boLKY3v3LlerF5h6ZIA4F8uDb5AAZlISijFsRY2ceTwmk1+6rV2lY/L7ujkb
	 2VQh2CU8HDyXSkmkRKHhOz/quhtPb4I/rGAo7hOb6z7EBrUEq92FZ2/1EiOxrtJ2sy
	 Q+o7EzRPW1wyQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo@kernel.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 256/314] wifi: mt76: mt7925: Fix possible oob access in mt7925_mac_write_txwi_80211()
Date: Tue, 10 Mar 2026 07:18:35 -0400
Message-ID: <5856ab0354fc4cfb1f89538c3856cd3539085453.1773141555.git.sashal@kernel.org>
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
index 1e44e96f034e9..e880f3820a1ad 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
@@ -667,6 +667,7 @@ mt7925_mac_write_txwi_80211(struct mt76_dev *dev, __le32 *txwi,
 	u32 val;
 
 	if (ieee80211_is_action(fc) &&
+	    skb->len >= IEEE80211_MIN_ACTION_SIZE + 1 &&
 	    mgmt->u.action.category == WLAN_CATEGORY_BACK &&
 	    mgmt->u.action.u.addba_req.action_code == WLAN_ACTION_ADDBA_REQ)
 		tid = MT_TX_ADDBA;
-- 
2.51.0


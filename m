Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D8BC285049;
	Tue, 17 Jun 2025 16:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177392; cv=none; b=i3w/LtrwXi/pBvv3fgUSy2hVY7W5Ii7UaTYVNw3qs6cJisibK45bXyG+sfYXhhSWB4GKiWojXZA7mjjVi+Wvf9GTedtfBumL+g8SFoCAvoUEEtz6+nyT0J/0eOmZie06aDGIrTfiJb8A2dAU5IULb4dh9sB9UNYU7BzBctYr42k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177392; c=relaxed/simple;
	bh=9H4wQEBqSEguu9SMKiTIYemS0Q07eRiHgRLGPoyuDfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PtmjGQCbIXOofYtMkhmgvokC4Jdkc2pDJ15Ey4bzmpwPZT9oWA0vdvDEg62+2Z16+wXyTSWBC7YZu8Icp3Zj27PJa2NQlDcJayQ5AojhlVsJkdcuKG2SYSTkAvW/88rcZYheXOgrlBEAb4UxN/wzaOc+qWi5sZcTyqay9Ed2YY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iLSz99rx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iLSz99rx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2D0EC4CEE3;
	Tue, 17 Jun 2025 16:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177392;
	bh=9H4wQEBqSEguu9SMKiTIYemS0Q07eRiHgRLGPoyuDfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iLSz99rxdZSgjS49xRwXN8TN258XsL8q4Poeh7W0c+C+XpVYTJ4Y+SF/gIYNZ5jEr
	 djqtgwkun85qub+dWN+DNPOeR6/K+XmbBhpV/2g9KBx2XEkKJEuPfWD3kRMwvH8vwb
	 KkzcOGOShCqo43D1oTarY0srNRMX7rZcVu1Ruo2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 299/780] wifi: mt76: mt7925: refine the sniffer commnad
Date: Tue, 17 Jun 2025 17:20:07 +0200
Message-ID: <20250617152503.640872985@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>

[ Upstream commit bd02eebfc0b3502fe8322cf229b4c801416d1007 ]

Remove a duplicate call to `mt76_mcu_send_msg` to fix redundant operations
in the sniffer command handling.

Fixes: c948b5da6bbe ("wifi: mt76: mt7925: add Mediatek Wi-Fi7 driver for mt7925 chips")
Signed-off-by: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
Link: https://patch.msgid.link/20250414013954.1151774-2-mingyen.hsieh@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index 8eaba8c07a62a..2bd9fc38a27f4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -2046,8 +2046,6 @@ int mt7925_mcu_set_sniffer(struct mt792x_dev *dev, struct ieee80211_vif *vif,
 		},
 	};
 
-	mt76_mcu_send_msg(&dev->mt76, MCU_UNI_CMD(SNIFFER), &req, sizeof(req), true);
-
 	return mt76_mcu_send_msg(&dev->mt76, MCU_UNI_CMD(SNIFFER), &req, sizeof(req),
 				 true);
 }
-- 
2.39.5




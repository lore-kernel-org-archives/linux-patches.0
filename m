Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019102;
	b=xOCt+1z+tBNbGsw7DgQMntm++l2Mdarlvm1ERgfd5IRaXpXq4fyhClmOvvNfshdJ/Rqt
	 0d/fiX0c2NZiSQ3pGwunl5cpbclndo3Z4EY4tN99TjBqluLe1PsEWaH81k269YwVHhX56
	 eA2j68/0YKCzrQY7Sf0PU1P291pVgXuV+qPnM6uy4lEuhIoJwwIHfDa0IfLmHF61Q7ljj
	 Nfc7lFnkZBlwGBduf5EispFulYkmQ7CWd+o3due+P9JNZFnpdIUkNb+YBfcxIoqfzFON4
	 HaTbRpQQPC1LmE7vD4fB7+5duf8JK5kH8VRxkmM1JKoGRAA4jCtR1q87obXZNTYeIhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019102;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GK5BZpfSt7hQbrbOFmptkUZ2W7pPiPK/lZOAv7/itcA=;
	b=kcostTawaj0o3GMEUy5fTfxN1hPC/KJ3h98Iil2GyHyjsBIqlWwmtDI2rEwfnBt8XUu8
	 M2+6beztBDaF8t1OoV/JRmNgegvl1yKuwiWaQr96uyy8TzqdJ+faRyTjJ8njPuoqlVeYG
	 suTuvGtFiGBW3ttOWm135EgLQSHERpzKie+fTMS0+qIiPz9lHyWgojXmdWS7luSVirZf1
	 WnLEMFEGgV/QM6hDmRQJcG1WecW3FDUOeCZaVHVx49MI479Q6EgjY3EWeTloxraHjwiqW
	 zsVbS15PnbpErKJblsP8XZGNn0w6GCFMv6nrVNKFGZhlsH9RAn3Tkgg6Y9KzC3SKrFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TK5fAuBh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07C7C606A334;
	Wed, 18 Nov 2026 16:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TK5fAuBh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B7271F000C7;
	Wed, 18 Nov 2026 16:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019101;
	bh=GK5BZpfSt7hQbrbOFmptkUZ2W7pPiPK/lZOAv7/itcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TK5fAuBhoPt6R7Vw/XEdp8gvufqWQ37ZhzCb6A0fq1M+2Uu3lVnhBHof+eRwRwi71
	 N4j37V/TmLst6nXMo2HRvWkb5hAs6Ze27GxjhYy8z5p9+VrAZ1vDWkzPSht+sC320j
	 XsFNys07PcYeuCdEkpqf5owjj0typk4J9r9pDbvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1475/2651] wifi: mt76: mt7996: free the WTBL index if a link allocation fails
Date: Wed, 18 Nov 2026 15:45:15 +0100
Message-ID: <20261118150341.127317126@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 36f1934a2bf04f355e748c68ba7f7cbb5e6950fc ]

mt7996_mac_sta_init_link() takes a WTBL index from wcid_mask before it
allocates the msta_link of a link other than the first one. If that
allocation fails, the function returns -ENOMEM and the index stays set
in wcid_mask, so no later station can use it.

Return the index to wcid_mask on that error.

Fixes: dd82a9e02c05 ("wifi: mt76: mt7996: Rely on mt7996_sta_link in sta_add/sta_remove callbacks")
Link: https://patch.msgid.link/20261006205936.669125-11-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index 3b50457955978..6ef399b7f72e1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -1166,8 +1166,10 @@ mt7996_mac_sta_init_link(struct mt7996_dev *dev,
 		mt7996_sta_init_txq_wcid(sta, idx);
 	} else {
 		msta_link = kzalloc_obj(*msta_link);
-		if (!msta_link)
+		if (!msta_link) {
+			mt76_wcid_mask_clear(dev->mt76.wcid_mask, idx);
 			return -ENOMEM;
+		}
 
 		if (msta->seclink_id == msta->deflink_id &&
 		    (sta->valid_links & ~BIT(msta->deflink_id)))
-- 
2.53.0




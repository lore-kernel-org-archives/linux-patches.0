Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4058376BDD;
	Tue, 16 Dec 2025 12:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888065; cv=none; b=nXis059EfuC+VhCYY2DcBWwYnhNmXBnf++cYLEcuxWOvXfpsYtoSeW+zuSdZadg3IYdcQEgtQNkkIJzn2rG71p2y9g2O/0gm6E6bZ7Iw7RwztSoYgk7B+SawmJAfw1sMhF4X0VLrCPYjHqRXalT3HHzBiHVF864HOGi1z6gPJqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888065; c=relaxed/simple;
	bh=5pc4P7OI0eGK5zPdrAZzdyqY2BbzZXRiKbCoCgJeCGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UXm9ofwzunLiT0O3u26eW+rYwDWiQ3w1KOb3EqijUdem8+1NPSKhmQNr3HRzjnuTRIlIHxc6Nou068irSIehmLmhhwLGoBxvd6vgFAY7cLtQvH+z33JDd6FxOjB9rpXM6OGvjqjzeGkl2pr7EXFpOCw5ukiAOH4Pew/loAeqe8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yUXhMjEg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yUXhMjEg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B366FC4CEF1;
	Tue, 16 Dec 2025 12:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888065;
	bh=5pc4P7OI0eGK5zPdrAZzdyqY2BbzZXRiKbCoCgJeCGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yUXhMjEgeTFdLMm/JQREN2fQJLnB3929eP/ZsVHFOodmJh+wHCfW3QSHzrzWCbdGX
	 sWRhonAYFJ0MBGnU74TR5ZxYMdkKkvDTckEy7F7uN92kdylMJ8cmMIhfZwKFEzCdSn
	 lwGpEiVW43QuocXvsb0yvI6WLeaDouNBxzzNW7NU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Howard Hsu <howard-yh.hsu@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 389/614] wifi: mt76: mt7996: fix implicit beamforming support for mt7992
Date: Tue, 16 Dec 2025 12:12:36 +0100
Message-ID: <20251216111415.466373685@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Howard Hsu <howard-yh.hsu@mediatek.com>

[ Upstream commit 5d86765828b47444908a8689f2625872e8dac48f ]

Fix the ibf_timeout field for mt7996, mt7992 and mt7990 chipsets. For
the mt7992, this value shall be set as 0xff, while the others shall be
set as 0x18.

Fixes: ad4c9a8a9803 ("wifi: mt76: mt7996: add implicit beamforming support for mt7992")
Signed-off-by: Howard Hsu <howard-yh.hsu@mediatek.com>
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Link: https://patch.msgid.link/20251106064203.1000505-3-shayne.chen@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index afa6a43bd51e5..9af3c48707ab7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -1822,8 +1822,8 @@ mt7996_mcu_sta_bfer_tlv(struct mt7996_dev *dev, struct sk_buff *skb,
 	bf->ibf_nrow = tx_ant;
 
 	if (link_sta->eht_cap.has_eht || link_sta->he_cap.has_he)
-		bf->ibf_timeout = is_mt7996(&dev->mt76) ? MT7996_IBF_TIMEOUT :
-							  MT7992_IBF_TIMEOUT;
+		bf->ibf_timeout = is_mt7992(&dev->mt76) ? MT7992_IBF_TIMEOUT :
+							  MT7996_IBF_TIMEOUT;
 	else if (!ebf && link_sta->bandwidth <= IEEE80211_STA_RX_BW_40 && !bf->ncol)
 		bf->ibf_timeout = MT7996_IBF_TIMEOUT_LEGACY;
 	else
-- 
2.51.0




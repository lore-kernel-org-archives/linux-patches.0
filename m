Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9397314B6D;
	Tue, 16 Dec 2025 11:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886066; cv=none; b=ewhmPGnPe+sz5E9Ec5R95TlW5TG9YfIlbeZYuitB1zHLhNhr44cNRIL2McWP6s8BXyPdtbEOneI73eG25t7VfUaE9zacM+uIQTPsKVPGNdrc2ItPV5UqVDy9R189ctwyzEGggIyCalj8IpSyFsznYeQSjEBQsbnGWfJCoLIgZ+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886066; c=relaxed/simple;
	bh=q1sQbGULWlyPD8UOwNSMKpGd+SumnzHrwcRTvnDK+Qg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EjNNAhMotfpaxryMQwN+WLpvXLgUs4IjI8yeYruBnCdPT2WESrbk4A5FWM04qu6wi+iT7sSl28oyP2CSleXIS+pUiqoY/z+Eop7wXqtGV6SflHRfK+BV1dTGt38ilmfHdzQ8x75PCG9SO+dtGKCatIocGW6N4my3guCc386WnEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FYRvFbrH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FYRvFbrH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADCA9C4CEF1;
	Tue, 16 Dec 2025 11:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886065;
	bh=q1sQbGULWlyPD8UOwNSMKpGd+SumnzHrwcRTvnDK+Qg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FYRvFbrHpvidNqd5uowjazLdOfzE11WL1FiHpJjTsPa9T/dzNAJA2WKyHoSKosZoU
	 h06cC1qhx6o9bDs03s4Vjnpbhg1oCCntfGD27vrqbqfnPzxIwNIPqcV+LLMUZ+Ircm
	 gbQlNw7h30Eur5zSvTW/T0wgydoqyqCVFqrELrrg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Howard Hsu <howard-yh.hsu@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 328/507] wifi: mt76: mt7996: fix implicit beamforming support for mt7992
Date: Tue, 16 Dec 2025 12:12:49 +0100
Message-ID: <20251216111357.348381615@linuxfoundation.org>
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
index 07b962e235850..f337e3267c6f0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -1754,8 +1754,8 @@ mt7996_mcu_sta_bfer_tlv(struct mt7996_dev *dev, struct sk_buff *skb,
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




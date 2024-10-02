Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDFCF1CFEB3;
	Wed,  2 Oct 2024 14:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879227; cv=none; b=EP8ykE7se2K0wkpXbWzltjgr1ufvb9RxblBnqf65SDziq25cvsQrKJPFZlvJa5htC3PMOxCiASA7VJIUhe5ZVkT4c7DCZkpGZeZolkF/OsmnWJYe1wRNpKvt3etelcO+DRWs7SCBsan53enCuyL/vcrjpCI96iINyQbQuer2R38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879227; c=relaxed/simple;
	bh=CpuMJesop6N8bC7hd3XE0c0Wu5G7f+oNcn1cyvpj4tE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YO6ix38rFKJBx1hK/ybSCoY/QmI1NlGtgKN1CV8LB6NapkO7IqxO2fUc/tZdsC0a+vCzlAZEGdnO1x6dKhCgL+BxC/LMaaDXDJfWk18LM/mK164ydUAPFQlh0Erq/A7Mgl8tkF3Dg4Xggw/pKp53bNZgWWYtud7R6k7ZGlm/dQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zChg+qEj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zChg+qEj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76BFBC4CECD;
	Wed,  2 Oct 2024 14:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879226;
	bh=CpuMJesop6N8bC7hd3XE0c0Wu5G7f+oNcn1cyvpj4tE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zChg+qEjYQjziSlgIEkFedyWSlKCYX7jysWaYAgwH95IaMsj2EUlWYRgEszqR7ZRQ
	 7FHEcEizVeEz2EES/Pd7+3QECLoKMp2HeZ0Q3vhSQ7+uOAvycYCi88Fq6n1m2bCd2K
	 zCLOxLC9NKnmDAV6D9ngEpRUytpDKoc7uTDrbCfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Chiu <chui-hao.chiu@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 046/538] wifi: mt76: mt7996: fix wmm set of station interface to 3
Date: Wed,  2 Oct 2024 14:54:45 +0200
Message-ID: <20241002125753.846671680@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Chiu <chui-hao.chiu@mediatek.com>

[ Upstream commit 9265397caacf5c0c2d10c40b2958a474664ebd9e ]

According to connac3 HW design, the WMM index of AP and STA interface
should be 0 and 3, respectively.

Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Signed-off-by: Peter Chiu <chui-hao.chiu@mediatek.com>
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Link: https://patch.msgid.link/20240816094635.2391-3-shayne.chen@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index 85f6a9f4f188c..0e69f0a508616 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -190,7 +190,7 @@ static int mt7996_add_interface(struct ieee80211_hw *hw,
 	mvif->mt76.omac_idx = idx;
 	mvif->phy = phy;
 	mvif->mt76.band_idx = band_idx;
-	mvif->mt76.wmm_idx = vif->type != NL80211_IFTYPE_AP;
+	mvif->mt76.wmm_idx = vif->type == NL80211_IFTYPE_AP ? 0 : 3;
 
 	ret = mt7996_mcu_add_dev_info(phy, vif, true);
 	if (ret)
-- 
2.43.0




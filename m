Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F90D1D04BE;
	Wed,  2 Oct 2024 13:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877497; cv=none; b=q/7ructnr5a7HO4QcLQvUDkdMqWuNAO1AQG0hvoW6MViY3Ku5Rv2ncSvob30X+XluPtk5pnB0XQpAxK1GCmtzVDDEcWLUc99pnYcHilfuBCFzd7pHwlgvokav/NYpzIesgGPdrgCur3O/X6cRe+9KIg2bKtsLHhq0YVuaJYDMA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877497; c=relaxed/simple;
	bh=98cl1fIcAdQjQEpUQmUUUYM2cjGZqqBDD1ab9YMph54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=en56J4MLcP3ukOH6wgtveSwQY31qpqehLvbkZmkQWGSOni8mmaREDBpLwkUGls+l2CVlCObAn9NdPUZp6HWLqpJkkCX4Vs71HZ3iUWHCxgHjYfdET1tj8JSiNdJWC6ChzyUGZ9/CgS++Ak4JwOEfc4ymEW6+XO/9f8J6hsoTmR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O3OWTprS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O3OWTprS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08741C4CEC2;
	Wed,  2 Oct 2024 13:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877497;
	bh=98cl1fIcAdQjQEpUQmUUUYM2cjGZqqBDD1ab9YMph54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O3OWTprS2ShmgERwZcCSI9Xhp0PQ2GPD9aE3klTHK0RuLgDA3ES/wybF6A8GJ4zem
	 g+m5817JQn4oThbl6BubjvoQAM+FQR0K8mcdtG2vEwDcMyrP4Rbr+eem+N/OoJ9d2j
	 mhfJkbjyokn/C+rhhZOOP9IC560u0SYNs8xWozLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Chiu <chui-hao.chiu@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 067/634] wifi: mt76: mt7996: fix wmm set of station interface to 3
Date: Wed,  2 Oct 2024 14:52:47 +0200
Message-ID: <20241002125813.751520685@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 15d880ef0d922..2b094b33ba31a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -206,7 +206,7 @@ static int mt7996_add_interface(struct ieee80211_hw *hw,
 	mvif->mt76.omac_idx = idx;
 	mvif->phy = phy;
 	mvif->mt76.band_idx = band_idx;
-	mvif->mt76.wmm_idx = vif->type != NL80211_IFTYPE_AP;
+	mvif->mt76.wmm_idx = vif->type == NL80211_IFTYPE_AP ? 0 : 3;
 
 	ret = mt7996_mcu_add_dev_info(phy, vif, true);
 	if (ret)
-- 
2.43.0




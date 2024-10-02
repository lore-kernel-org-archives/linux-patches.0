Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7DE31CF28B;
	Wed,  2 Oct 2024 13:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875365; cv=none; b=jk60FaAPQlaLthEYPGHwjtL31vzrKqFuwrT3g50w8YWfTypqtMIdeh9a14EbvtQDajO9+iMRqk52W+8Wjrx8J1wqLiQeqTIT6ZBip1OZV79keo/SKu7sILX55nW+5S7N7T/zw07Z6aOo0GQcY9LkY+Pp0W5oXb9Me8ZtHe0B9ZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875365; c=relaxed/simple;
	bh=1xuKYr8yAiKW1Wl7yUr7sHemChWHWDLz42F/NU9Hzcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uhk95QF8NgkPt5OCSiUHz+35Oub7oDzz1xzeQYxoqpFwGbVhjHpEPT2r076v+9OSXI6fmHskXjEB3NwVcXUfuLry2ITNyVYTAyUJR0Bj7UFolE5M0jdw7C7HMyF/CZjWv9SVWZXi73sfbvX6/Jcg71jYgKYrASCHK8GRs5GUZVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IAsdzNY8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IAsdzNY8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DA2BC4CEC5;
	Wed,  2 Oct 2024 13:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875364;
	bh=1xuKYr8yAiKW1Wl7yUr7sHemChWHWDLz42F/NU9Hzcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IAsdzNY8LdCxbNkHlms2t9vjKsf/fj2K81d4O6BosvqTyWF9+DqhnsgrIKnVXos72
	 YoUoNl+1tVGjsfzpoNIYsCgYcAwjPpOa+z7MyczjIBv2JxkLIbQvc2qhPIX4IOpmDE
	 6J44pbvpwEQTzkkWInZm2lU6AeBOYWZd3/iOrdfE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Chiu <chui-hao.chiu@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 077/695] wifi: mt76: mt7996: fix wmm set of station interface to 3
Date: Wed,  2 Oct 2024 14:51:15 +0200
Message-ID: <20241002125825.556297696@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index f3f78e11a65f2..1ab2fb2922662 100644
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




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 242B213C3F6;
	Wed,  5 Feb 2025 14:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765178; cv=none; b=GuV8zAKiZza4luIxDg+8goNZ7e74XqiWxLgEnMuNjOP626qqJRMrt0OdzgZ+XBZiCZtB7mgXdOSWtfiILSR11cDFrrqveobzwsOjQ5XuKbOMyZ7tLv86m6TODG4r7fENnrYQXutEICDCG/73DtS/Jllau2blGrVCyUvBYsltcBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765178; c=relaxed/simple;
	bh=jWLYp06lBvZVeS35R/pojlY9TqMeBYJS7J3b+kLGDvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mUWnvDeiteAqQl8YE8CD3tKRzMXMxyIwFE6CBPJuaGgBwlAsdRFtYQXlHitww+YVjy0+AJn7zj4Gp0pG8QfM4BhcApAjqXJL1NdpshrkAOXakSkyCICJFqMT6i0nfC+8gtkOYTMmvZV2C4KinDYIncks1IKI+obf9+OTGXET6PM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QLDYrtnh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QLDYrtnh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24566C4CEDD;
	Wed,  5 Feb 2025 14:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765177;
	bh=jWLYp06lBvZVeS35R/pojlY9TqMeBYJS7J3b+kLGDvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QLDYrtnhRzH6ZDTvCbRhDHJ8cVpMEabqyCvSbkpisudKrpSGVJseoIASE+1cHeudy
	 BlvgtYRmxLsCX6y2l4ERQd0FDq3MhVksJT9+GLobhQufnGEfqlhxw96Vmo/l1911iJ
	 12A9mnbEU6j1I61FI/Hn0yPqbiPEyF2ix/OHrxaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 197/590] wifi: mt76: mt7996: fix rx filter setting for bfee functionality
Date: Wed,  5 Feb 2025 14:39:12 +0100
Message-ID: <20250205134502.816330772@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 858fd2a53877b2e8b1d991a5a861ac34a0f55ef8 ]

Fix rx filter setting to prevent dropping NDPA frames. Without this
change, bfee functionality may behave abnormally.

Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Link: https://patch.msgid.link/20241230194202.95065-5-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index 39f071ece35e6..4d11083b86c09 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -496,8 +496,7 @@ static void mt7996_configure_filter(struct ieee80211_hw *hw,
 
 	MT76_FILTER(CONTROL, MT_WF_RFCR_DROP_CTS |
 			     MT_WF_RFCR_DROP_RTS |
-			     MT_WF_RFCR_DROP_CTL_RSV |
-			     MT_WF_RFCR_DROP_NDPA);
+			     MT_WF_RFCR_DROP_CTL_RSV);
 
 	*total_flags = flags;
 	mt76_wr(dev, MT_WF_RFCR(phy->mt76->band_idx), phy->rxfilter);
-- 
2.39.5




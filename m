Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45F861494DF;
	Wed,  5 Feb 2025 14:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764642; cv=none; b=mpE/QEVe+TJtUkmy3jMV9V0aDhLpL2g0/sgLEN5hcXoa44ySXzPSDmcMFJfCy8hSp63dKc1Itj/uuaUjP3t6216ypbsxxGZevVj51dkUm1GTr5aABkyUG86jeeYXaOCTYC3qCcJYFox7FiA9qJyfuBaUqX7zz3umUJE+R5bqzHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764642; c=relaxed/simple;
	bh=O99W7OaJT3333xtdHJKRQsTlogWRUR2dlCqbJdM8fhk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=osIQTs710ExbNvt3Vg2LAnC0jOHkcPPQraCwwmk7yf4BGF5z3DbNOjJw49ommqSNDBS2c1M11ezYZHxNDfPN+rBE7GGWXlKRP67ZjLFyiGIXlUz12KBcj4BnfBVp3RNHD1vFkRDun3M7UJmng47FTJIkmERTm6c5deXUZrKa5lE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JmTwrlRO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JmTwrlRO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB3DFC4CED6;
	Wed,  5 Feb 2025 14:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764642;
	bh=O99W7OaJT3333xtdHJKRQsTlogWRUR2dlCqbJdM8fhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JmTwrlRO7PpMxxocDT0gizQjjLkxI0+9N7G+Ud/HS6+wvFZkJqikuskGWKEPBjfHq
	 TOcpczSvsZwqiQ173JHbiX/AodmrwzCj8BaR3Cy+vxFv+OupWY8tK9mXIz0tFJRoFl
	 t6nRrPDt5Y8EHfNvQ9sD6hxglMhzyPTEBIfYCCk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Wunderlich <frank-w@public-files.de>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 145/590] wifi: mt76: mt7996: fix invalid interface combinations
Date: Wed,  5 Feb 2025 14:38:20 +0100
Message-ID: <20250205134500.822924617@linuxfoundation.org>
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

From: Shayne Chen <shayne.chen@mediatek.com>

[ Upstream commit 89aca45f26879dfbbf8374c425c4811f69cfc2df ]

Setting beacon_int_min_gcd and NL80211_IFTYPE_ADHOC in the same interface
combination is invalid, which will trigger the following warning trace
and get error returned from wiphy_register().

[   10.080325] Call trace:
[   10.082761]  wiphy_register+0xc4/0x76c [cfg80211]
[   10.087465]  ieee80211_register_hw+0x800/0xac4 [mac80211]
[   10.092868]  mt76_register_device+0x16c/0x2c0 [mt76]
[   10.097829]  mt7996_register_device+0x740/0x844 [mt7996e]

Fix this by removing unused adhoc iftype.

Fixes: 948f65249868 ("wifi: mt76: mt7996: advertize beacon_int_min_gcd")
Reported-by: Frank Wunderlich <frank-w@public-files.de>
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Tested-By: Frank Wunderlich <frank-w@public-files.de>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://patch.msgid.link/20241007135133.5336-1-shayne.chen@mediatek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/init.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/init.c b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
index 5e96973226bbb..efa7b0697a406 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
@@ -16,9 +16,6 @@
 
 static const struct ieee80211_iface_limit if_limits[] = {
 	{
-		.max = 1,
-		.types = BIT(NL80211_IFTYPE_ADHOC)
-	}, {
 		.max = 16,
 		.types = BIT(NL80211_IFTYPE_AP)
 #ifdef CONFIG_MAC80211_MESH
-- 
2.39.5




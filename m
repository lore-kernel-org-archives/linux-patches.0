Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 813F686348;
	Wed,  5 Feb 2025 14:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765153; cv=none; b=C8U9LFNWFRodQZ7cxTk/PNcR4aTK7kyLMkPTawXZqL3OOUXMdlejTT0dGYh58YWGz89v1kE9eYWrdK0j9RMH2lXyQsAvuyhzLf3JKeeq4Lse0zgrljnPP5yyNfTdKPPRdyv/QADzUmgBf9Ii/I4UQakdqTweW25L9TZCJHBJPho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765153; c=relaxed/simple;
	bh=hJ4iLKUGH1tCXV338NVCobMjE6HVoSqtVnaaac0nFOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jJ1L4zdM8SEv48NZeLjbHOE2SehHuhrgmAqUQQoJmjydgaTsQaMdvrrrTmbXEItP9YE8Z4do6S++E87Htd9mLXStOCmmnDFn2NFwBYGU/yyq8nf7A54etDDBsjR9iqvWzP1L+0tKg/m0/FPxoi9W6TDJp3+1xq8DYOk1bypmuJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AfVZxiLR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AfVZxiLR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CFDFC4CED1;
	Wed,  5 Feb 2025 14:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765153;
	bh=hJ4iLKUGH1tCXV338NVCobMjE6HVoSqtVnaaac0nFOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AfVZxiLR8aJzXpoNTy9TXnVcodI3Be1n8G20wSG4L+93lef5R5mDjhHjtrq4UH1Gi
	 NNSZn/han8/5oCtFsGgq3+6udQDkBbfdSmXJS+zHnmIo2VE2Vm0FWvCi30+9FAe9/v
	 rtJIndQ84aVn6/w7fGD7pz+ioxnbY1Nf9+Ahhffc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Wunderlich <frank-w@public-files.de>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 151/623] wifi: mt76: mt7996: fix invalid interface combinations
Date: Wed,  5 Feb 2025 14:38:13 +0100
Message-ID: <20250205134502.012461483@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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




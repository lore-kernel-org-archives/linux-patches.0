Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 306C74AF68F;
	Mon, 31 Aug 2026 13:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184168; cv=none; b=QBTQDxyrNv0lNnF2iRUf47QjzByOzgU6GMq4WKdX4Vurvxcbfv3z2JUhvLa3dANXJ63OsUoscs42NzDG4VKN7I99+H/SscD5H5Ut7hofdaygXn2Evkuo1F9P4KYUyBNXyNrX7G77m1JWDWZssifsDA4rAaxSRz2otz9uWlXm2sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184168; c=relaxed/simple;
	bh=Fktpoa+rHuodAX69lPbwecMbEI02Tc37kNfJWPKcr7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s5XGsyWOlNGuQafhyZpOSZYMhSvIZAqXEwQCaBTJrJjUyFzqR4PQ1gAcA6P+ggkRv3MTFn/XYafH1o6YTr7xY9tGGk7yE7fdUu4VHXtw+mAvgLavFq9NMRj38tRhuyGxQKAdip6iRb62fo0G0NIKJIWHdv5oeO6DAqkwhJsoyLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RR76AlF0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RR76AlF0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EA551F000E9;
	Mon, 31 Aug 2026 13:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184167;
	bh=2OFXdO2l633BQG1/737ziFQxGuAzwEgWTVFtIE0sk3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RR76AlF0mF6I2cVbuAqzpS+srHJSJ4H22LtnPRvRWHLpzsazr2QDX60aPzlhsRpdj
	 GObMRbgFBLEGc1qLRNPM/LJsgLhGshO4viKuhQDF4j1E/AK5g2Z/WnyukQOC3hCM5y
	 MDBu1RRNmqTpY1hUGXq+fawReNAz1JB5XDsCZC7IUTt4AyC+ZDU31JW2XEr+7EiK6+
	 1Gi62bfrtZkiJwqlBBxtvyJz1S3GILKyqFbxDYWHRnfq3SBa+0bnZgSgEUT3MPHwLp
	 vGnNpE7cOYKt/XQdL1pGlkjef8ZTVzdAciB5AVmTEsUrZZ+UcTw9jJ7PD++twoEr0F
	 aKgPyY8OAUH2A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Kuan-Chung Chen <damon.chen@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] wifi: rtw89: mlo: rearrange MLSR link decision flow
Date: Mon, 31 Aug 2026 09:29:19 -0400
Message-ID: <20260831133314.4125787-531-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kuan-Chung Chen <damon.chen@realtek.com>

[ Upstream commit 7284f5be5d298c901be1fc9fda6a2476f5ffdbaf ]

The original MLSR link decision refers to RSSI, but it should be
based on the premise of an existing link. Otherwise, make a link
decision to select a new link from any available band.

Signed-off-by: Kuan-Chung Chen <damon.chen@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260429132625.1659182-2-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Two background git history lookups were interrupted (one had used `git
log --all`, which is too slow in this repo).

The follow-up without `--all` completed: `rtw89_core_mlo_track` first
appears in this 6.18.43 tree at `5d324e5159d9e` (v6.18-rc8 era), so the
MLSR code the patch fixes is present here. That matches the earlier
analysis — **YES** for backport.

 drivers/net/wireless/realtek/rtw89/core.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/core.c b/drivers/net/wireless/realtek/rtw89/core.c
index 989c6b09b2706..c2bf839fd82a9 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -4276,13 +4276,19 @@ static void rtw89_core_mlsr_link_decision(struct rtw89_dev *rtwdev,
 {
 	unsigned int sel_link_id = IEEE80211_MLD_MAX_NUM_LINKS;
 	struct ieee80211_vif *vif = rtwvif_to_vif(rtwvif);
+	u8 decided_bands = BIT(RTW89_BAND_NUM) - 1;
 	struct rtw89_vif_link *rtwvif_link;
 	const struct rtw89_chan *chan;
 	unsigned long usable_links;
 	unsigned int link_id;
-	u8 decided_bands;
 	u8 rssi;
 
+	usable_links = ieee80211_vif_usable_links(vif);
+
+	rtwvif_link = rtw89_get_designated_link(rtwvif);
+	if (unlikely(!rtwvif_link))
+		goto select;
+
 	rssi = ewma_rssi_read(&rtwdev->phystat.bcn_rssi);
 	if (unlikely(!rssi))
 		return;
@@ -4294,12 +4300,6 @@ static void rtw89_core_mlsr_link_decision(struct rtw89_dev *rtwdev,
 	else
 		return;
 
-	usable_links = ieee80211_vif_usable_links(vif);
-
-	rtwvif_link = rtw89_get_designated_link(rtwvif);
-	if (unlikely(!rtwvif_link))
-		goto select;
-
 	chan = rtw89_chan_get(rtwdev, rtwvif_link->chanctx_idx);
 	if (decided_bands & BIT(chan->band_type))
 		return;
-- 
2.53.0


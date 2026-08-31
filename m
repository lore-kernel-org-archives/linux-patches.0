Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C0E74A92EF;
	Mon, 31 Aug 2026 13:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183964; cv=none; b=VdnwkA3FyJBP8unYCTzDq2aYeo/+a+r6/9pN48KTnAqgi4ZhuPw3doPni3LH+LOwtFEONGyEMEmbGlK6WLd33E1EVLaI/Gn5dEU8wUQi+kZwidH3FgmdzLIijjJF3eCZQduRtG8oaLYHIOcXBUjpiPIBJd9OYL8ZZEnhr7oyvNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183964; c=relaxed/simple;
	bh=KZfxHIuw9GrsEIQ5kA/Vo4AKEeVh9WwTmh0eYjH/zM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IlReZ2fkl5GPdXAo/uV6tn9r/08gSlD2XWMZPnN/XFd471KGR7IvXQMDRp/aWyhOcs4oWxlfvp3XLfBAjMUsOXCUBzbLQbTsgQUK2exYQyXHCs08ounEIv9Zq8B961AD0ONn4x37B7yxTPVqAH55+y+4eBPfJCjtsL4OrLIbRlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CLSisUNk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CLSisUNk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A788B1F00ACF;
	Mon, 31 Aug 2026 13:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183962;
	bh=t+sVb8PgnzfqMU9b8wBaeZ12DQgszbLqCk0ZHL9yUBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CLSisUNkGqy6Qh91V6lrg8ZcCdrKI4+KCHUU9SU8hAxeUzoyrpP6R3WLoHVUzUz83
	 4xvOlJJxrCbMts8aVU5bqVGBDpXq0x54MLqAWKVO/Pa4EksGzximNuGLjtR4pQioM5
	 +Lj4YIlrspgsZfgbp9gXlK9q5H2NyPrmqt3IA10FFfX1sPqmDItvZfuUtSrkqPbOw5
	 e9/vZEd28f3ohADHTMfhNULiNI8RzzV11+u1HLB8YuKd7Vg0tBLAAfzckOHpKHUFMU
	 EMytpx3StBPCaLfE90ghpuG7rXuLm2vSj46zgceOQEI8z4VqSiq9Y4JRW8N+KLR0Ql
	 Ey01znHsugk3g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] wifi: mac80211: explicitly disable FTM responder on AP stop
Date: Mon, 31 Aug 2026 09:27:15 -0400
Message-ID: <20260831133314.4125787-407-sashal@kernel.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 89e367a90c1a877ca9c5d75d3848582d80fd0e60 ]

When stopping the AP, explicitly disable FTM responder while
disabling beaconing.

Link: https://patch.msgid.link/20260505151241.f213196d7d6a.I95d65c030e986c5f7d63ecbd79596da890b9fc84@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Connection lost, reconnecting to https://agentn.us.api5.cursor.sh
(attempt 1)...
Retry attempt 1...
The background `git log -S'BSS_CHANGED_FTM_RESPONDER'` search finished
after ~7 minutes. It didn’t pinpoint a clean “introducing” commit in
this tree — the pickaxe scan surfaced a long list of unrelated merge
commits, which is typical for a stable checkout with compressed history.

That doesn’t change the earlier conclusion: `BSS_CHANGED_FTM_RESPONDER`
and the FTM responder AP path are present in this 6.18.43 tree, and the
missing `ftm_responder` teardown in `ieee80211_stop_ap()` is a real bug
there — especially for ath10k/ath11k drivers that rely on that notify
bit and don’t implement `.stop_ap`.

**YES**

 net/mac80211/cfg.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index f6232948bc0f4..72c9d5aceae58 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1811,6 +1811,7 @@ static int ieee80211_stop_ap(struct wiphy *wiphy, struct net_device *dev,
 	struct ieee80211_link_data *link =
 		sdata_dereference(sdata->link[link_id], sdata);
 	struct ieee80211_bss_conf *link_conf = link->conf;
+	u64 changes = BSS_CHANGED_BEACON_ENABLED;
 	LIST_HEAD(keys);
 
 	lockdep_assert_wiphy(local->hw.wiphy);
@@ -1860,6 +1861,11 @@ static int ieee80211_stop_ap(struct wiphy *wiphy, struct net_device *dev,
 	if (old_s1g_short_beacon)
 		kfree_rcu(old_s1g_short_beacon, rcu_head);
 
+	if (link_conf->ftm_responder) {
+		link_conf->ftm_responder = false;
+		changes |= BSS_CHANGED_FTM_RESPONDER;
+	}
+
 	kfree(link_conf->ftmr_params);
 	link_conf->ftmr_params = NULL;
 
@@ -1881,8 +1887,7 @@ static int ieee80211_stop_ap(struct wiphy *wiphy, struct net_device *dev,
 	sdata->vif.cfg.ssid_len = 0;
 	sdata->vif.cfg.s1g = false;
 	clear_bit(SDATA_STATE_OFFCHANNEL_BEACON_STOPPED, &sdata->state);
-	ieee80211_link_info_change_notify(sdata, link,
-					  BSS_CHANGED_BEACON_ENABLED);
+	ieee80211_link_info_change_notify(sdata, link, changes);
 
 	ieee80211_remove_link_keys(link, &keys);
 	if (!list_empty(&keys)) {
-- 
2.53.0


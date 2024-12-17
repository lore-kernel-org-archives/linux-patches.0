Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C57C01F429B;
	Tue, 17 Dec 2024 17:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455772; cv=none; b=NIZ6zVWjzpj/0Q3KcPmb93RGf1HzMY+2gc8tRJMC7fqr2/WkOwQOW/qwow0Jq8pLIsOaMqi66uy2zlkWDvcFWpyTjtwekVlzFwEBIvDwILzePERpB+F5253spLXDlVFiYpzkW7YSvpkFU2sP9FHaWwPTZKsbww+v6k7qhpUHLPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455772; c=relaxed/simple;
	bh=4il20ni1N1kg0/g0aOirNNJsx5jOc3JwVvk0hG48+BI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VPKqg1AVYQgOx/y76rli1oHzqCj39acowQVKfmt+qrwMlN9kTFSYyOBsDAOxUfnHHTpC/5SGEwoU6Rrw3NxMFITQ+FPPh64caLGesRd+WU9o2QjTXRCpG/BSa0uiTvXHqKOdlJqiztxNyHYF0dX09QXJpvI9eWzfOTHuKpXE5Yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=auz4JxWB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="auz4JxWB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D6B7C4CED3;
	Tue, 17 Dec 2024 17:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455772;
	bh=4il20ni1N1kg0/g0aOirNNJsx5jOc3JwVvk0hG48+BI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=auz4JxWBO6ohrT8lJ8NIMSSdDW6hPV5oPGg51wyLDtjzPdFtXzirGtPDZdGrEKIJe
	 qD08tYD92oDNxI6CSgB+Gq/i5/FyAUbYz2us06qz1SRZtI6BIGt0iiEKxQqlrGvTh7
	 7UTC6lEIwJOEAxLOWlTOih+4TIa8VS7oYyJG5KYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 28/76] wifi: mac80211: clean up ret in sta_link_apply_parameters()
Date: Tue, 17 Dec 2024 18:07:08 +0100
Message-ID: <20241217170527.430760898@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170526.232803729@linuxfoundation.org>
References: <20241217170526.232803729@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 642508a42f74d7467aae7c56dff3016db64a25bd ]

There's no need to have the always-zero ret variable in
the function scope, move it into the inner scope only.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240605135233.eb7a24632d98.I72d7fe1da89d4b89bcfd0f5fb9057e3e69355cfe@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: 819e0f1e58e0 ("wifi: mac80211: fix station NSS capability initialization order")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/cfg.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index c0dccaceb05e..aa5daa2fad11 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1683,7 +1683,6 @@ static int sta_link_apply_parameters(struct ieee80211_local *local,
 				     struct sta_info *sta, bool new_link,
 				     struct link_station_parameters *params)
 {
-	int ret = 0;
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	u32 link_id = params->link_id < 0 ? 0 : params->link_id;
@@ -1725,6 +1724,8 @@ static int sta_link_apply_parameters(struct ieee80211_local *local,
 	}
 
 	if (params->txpwr_set) {
+		int ret;
+
 		link_sta->pub->txpwr.type = params->txpwr.type;
 		if (params->txpwr.type == NL80211_TX_POWER_LIMITED)
 			link_sta->pub->txpwr.power = params->txpwr.power;
@@ -1777,7 +1778,7 @@ static int sta_link_apply_parameters(struct ieee80211_local *local,
 
 	ieee80211_sta_init_nss(link_sta);
 
-	return ret;
+	return 0;
 }
 
 static int sta_apply_parameters(struct ieee80211_local *local,
-- 
2.39.5




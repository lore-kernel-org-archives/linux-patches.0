Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E1A0387368;
	Tue, 10 Mar 2026 11:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142153; cv=none; b=sTofOJN/+qbuFDQINociXO+a2J9lZrujzofSE+XtLfZ3zLDK2h9AsTXfBt6kPMP/xBY1c3apiZ5WoEjvf1q3lti62xB41U8qIoHjww+Gdh0MDZLXs7QxWnSwcuuWQ5zOI3DACYyz4DovSvC/SWp35/ON8cUe79536IV0wUEXhHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142153; c=relaxed/simple;
	bh=SMidLc9Tfva4X8YsSIgugrA4Ulq9vBbcND4pl0/0pr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LTxy4aTJzH/qo930201mqJttTuwK9o7TEE1zB4fcaHdw9tZfKgE3yB/EOUZeAUmJvjrG0/9G066uH4lAbCXR2vI/xzRzwyeUIyHL+u0R/JAJDitzuKAfBByeWQRRfeArFllUhxejaWrfghaUQDMEQcxR9VwR42kRc6eMaoe4Jd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rxmky5b7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rxmky5b7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9682C2BCB0;
	Tue, 10 Mar 2026 11:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142153;
	bh=SMidLc9Tfva4X8YsSIgugrA4Ulq9vBbcND4pl0/0pr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rxmky5b7G5VDZUQSKDyI4hloZuK+ooi6MbN+LpTHQ98D+YIH1+yJZ3yY1atuTwxrB
	 uhsFow1hySuS/z2+0+KzN2/QiOrnhXNsG20iSXA8bOzPwOa+467v9uh8t1RvkcBD0M
	 nyUKq/J67/gMyjxy01YVsFM5jEoJdEIRTR6dSu9HcKpkWQm0b3m54O+0Q9XJ23QOUY
	 0FuVxg6raO6n1LMBxnhDknMYZIYL1IFAxWDxF1HqEQ8bwoHHX5R/zOwmiNv4XtgxYA
	 zGw8RDMTfiP0cGCqc+HK44QFQ5Z7a/MyI9PfxUWWs5z4w8ow4e/2KCYGfj7PaD2hUI
	 njJzk+/szxssg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 241/314] wifi: rsi: Don't default to -EOPNOTSUPP in rsi_mac80211_config
Date: Tue, 10 Mar 2026 07:18:20 -0400
Message-ID: <748d9f3305605dbb63fe9a9cdacc5f7c7f3e8b10.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>

[ Upstream commit d973b1039ccde6b241b438d53297edce4de45b5c ]

This triggers a WARN_ON in ieee80211_hw_conf_init and isn't the expected
behavior from the driver - other drivers default to 0 too.

Fixes: 0a44dfc07074 ("wifi: mac80211: simplify non-chanctx drivers")
Signed-off-by: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
Link: https://patch.msgid.link/20260221-rsi-config-ret-v1-1-9a8f805e2f31@puri.sm
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index 8c8e074a3a705..c7ae8031436ae 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -668,7 +668,7 @@ static int rsi_mac80211_config(struct ieee80211_hw *hw,
 	struct rsi_hw *adapter = hw->priv;
 	struct rsi_common *common = adapter->priv;
 	struct ieee80211_conf *conf = &hw->conf;
-	int status = -EOPNOTSUPP;
+	int status = 0;
 
 	mutex_lock(&common->mutex);
 
-- 
2.51.0


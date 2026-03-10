Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46B7A389456;
	Tue, 10 Mar 2026 11:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141220; cv=none; b=oQ0RInVXH0LIXnM2/uduJT18ce0rXCyw4cSDoQTDGTPfiU7xAedsaeGm74lQVLbp5yzUj8MctvMWUR3vfKRKZHaOm7QBagceb1TyMftoVIa1B2rJth99CEteQnugrY4z/AL5BXeUAkUjZS6Wtw0HQO8+MVrGsVqqgJCKPNMLBXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141220; c=relaxed/simple;
	bh=SMidLc9Tfva4X8YsSIgugrA4Ulq9vBbcND4pl0/0pr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HioXAaS9B1D1xGtBcmhMwsKam5z2sAgajjru2eb6gNXa9mfGpwTEtrHG3LgzwmRl7XN8HI61ta/LhS57zHmpW+pXiFM9x+X1aqCrPBerY1HIcp1jMZR0Xffiy6ck4oP953PARtUXI4WnM3Z+qaAJEB5PV3uPbJU9LuiTPof+uDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ElWYfRTD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ElWYfRTD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F830C19423;
	Tue, 10 Mar 2026 11:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141219;
	bh=SMidLc9Tfva4X8YsSIgugrA4Ulq9vBbcND4pl0/0pr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ElWYfRTD+hhA4vG1c/Rf3eHtFToYooIx3/kvd4OrkXgc2ruR2uI7Pstci7qpQlE+I
	 as5LfaARY+Ouy+1ceyUT/xAEOjLSVaZRN6dxTrnH91r+uQ+af2U5i/P8wFXnWxjyhZ
	 iBNNXnXaYAMDMS36UKZ2zSMO8gt8lS+gyyei4ORg5jHwdAXh4dAnnmaNcJszRD7PpO
	 bqxipXMIv0V8NJuL4VSmp61W5RIqrb6Qv+IwO4bz72/hg54aIGmtOz6syhIz2rVNPL
	 7WrWUYRUfCk4YoiG9302EM6id7zaff738VfMHeR0EpCrYQFH1nsWmEU34piKSPSizo
	 O5GBHOCemC0bA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 221/311] wifi: rsi: Don't default to -EOPNOTSUPP in rsi_mac80211_config
Date: Tue, 10 Mar 2026 07:04:28 -0400
Message-ID: <7e4e2f850854eb23c84368f0dbd8627af8837339.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
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


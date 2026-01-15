Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CF0B3A7F43;
	Thu, 15 Jan 2026 16:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496398; cv=none; b=TfG/E1hqgpJ6LnyIFJS8yWonfG1zY5SpWOAVwsRYHFFpp8wMieqo6qRnqM5Co9ov0p4T1eRX+8qT+eZf1v2on4edHEarZRUGNq56/zaUBmoa8yXuZAhsmwGs+hUZZ0E9hNljVx9GI48othh+AmTJdN1cGHBRrROwfoEoo7/5dGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496398; c=relaxed/simple;
	bh=+3Sn9ja5GE7NWTap0cqbWhs8/CM1Rk8UW2IDbGI7O44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=atBZj6KLd64HJnbmi27suA2lheasT+zrVcRtvsYshB0KQGWNYAI6uoO7TI5+D+H3F/nmMNvOznaHW3Yg/RfThwz+wHj/1XFKnfsmmXaJYfYWKqWc/U3rA87ChJh5T++4fehnuG+FWoMMllZc8qqRTQSCCsHtese+TkrMQYGX128=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y/OvmthA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y/OvmthA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B996C116D0;
	Thu, 15 Jan 2026 16:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496397;
	bh=+3Sn9ja5GE7NWTap0cqbWhs8/CM1Rk8UW2IDbGI7O44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y/OvmthAyEe6AtVTmOJLfNOaocRLn78dGA0UKL/UoFUXA/GOnQmdMAZRFXPj4mikI
	 4FUmZwcvZhGUcMjvYA0uHPfXjKK20dTwj67TzgNmrtAJtuLl/4PsJTDRaWAQoiTWyI
	 +Uw7hpWNh6oBGqzA6Jc/aCNVoEze4Pe07aUrlZMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	Ilan Peer <ilan.peer@intel.com>,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 148/181] wifi: mac80211_hwsim: fix typo in frequency notification
Date: Thu, 15 Jan 2026 17:48:05 +0100
Message-ID: <20260115164207.657457443@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Berg <benjamin.berg@intel.com>

[ Upstream commit 333418872bfecf4843f1ded7a4151685dfcf07d5 ]

The NAN notification is for 5745 MHz which corresponds to channel 149
and not 5475 which is not actually a valid channel. This could result in
a NULL pointer dereference in cfg80211_next_nan_dw_notif.

Fixes: a37a6f54439b ("wifi: mac80211_hwsim: Add simulation support for NAN device")
Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
Reviewed-by: Ilan Peer <ilan.peer@intel.com>
Reviewed-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20260107143652.7dab2035836f.Iacbaf7bb94ed5c14a0928a625827e4137d8bfede@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/virtual/mac80211_hwsim.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/virtual/mac80211_hwsim.c b/drivers/net/wireless/virtual/mac80211_hwsim.c
index 5903d82e1ab1e..2f263d89d2d69 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim.c
@@ -4040,7 +4040,7 @@ mac80211_hwsim_nan_dw_start(struct hrtimer *timer)
 			ieee80211_vif_to_wdev(data->nan_device_vif);
 
 		if (data->nan_curr_dw_band == NL80211_BAND_5GHZ)
-			ch = ieee80211_get_channel(hw->wiphy, 5475);
+			ch = ieee80211_get_channel(hw->wiphy, 5745);
 		else
 			ch = ieee80211_get_channel(hw->wiphy, 2437);
 
-- 
2.51.0




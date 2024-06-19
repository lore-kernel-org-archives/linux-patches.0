Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3057112FB27;
	Wed, 19 Jun 2024 13:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803302; cv=none; b=oYjR+JxMp95xl5HFIY662uv+uhFnKNwdZivyT1nFJg1Q7M8Gqyr1hOmCoNGk32WZUKOAdC6bkufDZfVJoL46I7o3hwdk1T+hT2VBm6snYQ25rlDX5HbkkzPvgzI1IGACCc5eokI8Ugndq+75W3cIdvqfzad1VHPrW2pP8Le8ImQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803302; c=relaxed/simple;
	bh=7aT0NYE467mPvgsAyRtYefUBN70d7uEl7Qp7hXIm5G0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oRoY987kkTOZgjQNfIW7UkVwFlqr4bHFjI1U7M9F9hQfycSX4BDKh7HTnXmja2xILn5AvI1+hH7ky2u8QfxsielJ1QZ+tXw5yGsOnBdhsl+HniGa4AyKbaIqO4veOuBEEi3xiWSvIza1kr871JHuPdvq1Ukhkvlm2Ii+hJySxdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sPzSMtCH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sPzSMtCH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0B04C2BBFC;
	Wed, 19 Jun 2024 13:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803302;
	bh=7aT0NYE467mPvgsAyRtYefUBN70d7uEl7Qp7hXIm5G0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sPzSMtCHSf2P9HhBWkBD3khaa10oaeM7ATIPR8OW36PD8darylAlrX/SN4kQ3RMpS
	 KwBv7voIhXX3RstzFgTdtUdZ+6OHUHezKuW/8TnK+ToTM6z01fAzJYxCjL9CzqJnSa
	 BbGyvyg/o1UvU2XAhuCf2y7hT+8Ob4HOwTI8Ah7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rene Petersen <renepetersen@posteo.de>,
	Johannes Berg <johannes.berg@intel.com>,
	Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 6.9 222/281] wifi: mt76: mt7615: add missing chanctx ops
Date: Wed, 19 Jun 2024 14:56:21 +0200
Message-ID: <20240619125618.502855253@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 40cecacabc460f5074398753feb9ed7d43e8dfa6 upstream.

Here's another one I missed during the initial conversion,
fix that.

Cc: stable@vger.kernel.org
Reported-by: Rene Petersen <renepetersen@posteo.de>
Fixes: 0a44dfc07074 ("wifi: mac80211: simplify non-chanctx drivers")
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218895
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://msgid.link/20240528142308.3f7db1821e68.I531135d7ad76331a50244d6d5288e14aa9668390@changeid
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/main.c b/drivers/net/wireless/mediatek/mt76/mt7615/main.c
index 0971c164b57e..c27acaf0eb1c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/main.c
@@ -1326,6 +1326,10 @@ static void mt7615_set_rekey_data(struct ieee80211_hw *hw,
 #endif /* CONFIG_PM */
 
 const struct ieee80211_ops mt7615_ops = {
+	.add_chanctx = ieee80211_emulate_add_chanctx,
+	.remove_chanctx = ieee80211_emulate_remove_chanctx,
+	.change_chanctx = ieee80211_emulate_change_chanctx,
+	.switch_vif_chanctx = ieee80211_emulate_switch_vif_chanctx,
 	.tx = mt7615_tx,
 	.start = mt7615_start,
 	.stop = mt7615_stop,
-- 
2.45.2




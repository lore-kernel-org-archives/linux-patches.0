Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30A1B1459F2;
	Wed, 19 Jun 2024 13:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803299; cv=none; b=fu4kJMJUQ2Oi6r8JnuhFaI96zElOTF9/PAcfJOtYWo393d6PX1KJSO3M4SyuIB1qF974U/1Z+ROUxUGOBGQR8xItwkcpb+ILDuqzBYANs2qPVwyepCOU0WNPYDUQVqi//Akx28O7XbVoII5jHNJ8RP2tMN3z6PJhpElPmGW1t7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803299; c=relaxed/simple;
	bh=Mb+Ktpq58VVsyxzBErwhNCDUVvKxZmuE+GpuaftHn8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mC6nr21cHSKhPze3S232+Ff7JFkem7rHg9Ja9RlVzj7kvykHRdLQL9vFIcKegSVXmrXLjlo78t1TjNvuQfZaVksaNN0KwoqQtKfDWVUmTSSaO8nep0e9EHMo+fvOPaKIDx8eEJlPVNaWYOC2Gwa69xoGxLP/ectHm+nfo076l1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tArV7L7O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tArV7L7O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8DA8C2BBFC;
	Wed, 19 Jun 2024 13:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803299;
	bh=Mb+Ktpq58VVsyxzBErwhNCDUVvKxZmuE+GpuaftHn8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tArV7L7OpPkG/YNlopMYo15NGMRSvhxD3LhGZeak+pIGiSdsnQ4g2BCqSmAz/FZyo
	 ibIh8QD4c1yByAJvUc82ngbiTLG6ZXnXlrHx3pv7MxNnq2b6bV7TKBNxRAoNihhUHw
	 YAJ0VE9t5cwDghJA9su9vzUNRgVhtUVMFcWXrBcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 6.9 221/281] wifi: rtlwifi: Ignore IEEE80211_CONF_CHANGE_RETRY_LIMITS
Date: Wed, 19 Jun 2024 14:56:20 +0200
Message-ID: <20240619125618.463804102@linuxfoundation.org>
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

From: Bitterblue Smith <rtl8821cerfe2@gmail.com>

commit 819bda58e77bb67974f94dc1aa11b0556b6f6889 upstream.

Since commit 0a44dfc07074 ("wifi: mac80211: simplify non-chanctx
drivers") ieee80211_hw_config() is no longer called with changed = ~0.
rtlwifi relied on ~0 in order to ignore the default retry limits of
4/7, preferring 48/48 in station mode and 7/7 in AP/IBSS.

RTL8192DU has a lot of packet loss with the default limits from
mac80211. Fix it by ignoring IEEE80211_CONF_CHANGE_RETRY_LIMITS
completely, because it's the simplest solution.

Link: https://lore.kernel.org/linux-wireless/cedd13d7691f4692b2a2fa5a24d44a22@realtek.com/
Cc: stable@vger.kernel.org # 6.9.x
Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://msgid.link/1fabb8e4-adf3-47ae-8462-8aea963bc2a5@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtlwifi/core.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/core.c b/drivers/net/wireless/realtek/rtlwifi/core.c
index 2e60a6991ca1..42b7db12b1bd 100644
--- a/drivers/net/wireless/realtek/rtlwifi/core.c
+++ b/drivers/net/wireless/realtek/rtlwifi/core.c
@@ -633,21 +633,6 @@ static int rtl_op_config(struct ieee80211_hw *hw, u32 changed)
 		}
 	}
 
-	if (changed & IEEE80211_CONF_CHANGE_RETRY_LIMITS) {
-		rtl_dbg(rtlpriv, COMP_MAC80211, DBG_LOUD,
-			"IEEE80211_CONF_CHANGE_RETRY_LIMITS %x\n",
-			hw->conf.long_frame_max_tx_count);
-		/* brought up everything changes (changed == ~0) indicates first
-		 * open, so use our default value instead of that of wiphy.
-		 */
-		if (changed != ~0) {
-			mac->retry_long = hw->conf.long_frame_max_tx_count;
-			mac->retry_short = hw->conf.long_frame_max_tx_count;
-			rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_RETRY_LIMIT,
-				(u8 *)(&hw->conf.long_frame_max_tx_count));
-		}
-	}
-
 	if (changed & IEEE80211_CONF_CHANGE_CHANNEL &&
 	    !rtlpriv->proximity.proxim_on) {
 		struct ieee80211_channel *channel = hw->conf.chandef.chan;
-- 
2.45.2




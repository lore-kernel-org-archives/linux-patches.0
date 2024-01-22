Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 301B82C1A7;
	Tue, 23 Jan 2024 00:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968313; cv=none; b=gfQ2fZDu5F2akMTGFwS5+DQkjoM/2YNlXiL6Q8k9zzpH8/4zsS8UE71INiYnSHVTW/DFpNsmJL9pTwol0mc3gmBp8gFZiJv5eyZByt627Q3a1MZ8iJDfWJJWnmEondHERr+h+U9h5qs7aE2cJwBeldDkLPkHmHp3KLKpNpWoAb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968313; c=relaxed/simple;
	bh=tz78pgMR6i+q8XYG8UJMcGu4RVnY5fBvNucqMJNZpbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FKoVrlPFRVwRM9OcM9kNBmRkM7UsguUqicaZJMluKnQ3ni+cZWtzQQrRom9KsviJ8f7aKcOTHjJeCafaMVMWDBt0SX0jG2Y2Nl95jRojqJK1/BJT8tkRCJI4Xflaw+C6T5FzeX5BfBFnTF+BADb81Ci0nO+4W2TL0Wcm3NYsl3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lZRnth70; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lZRnth70"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE54AC43394;
	Tue, 23 Jan 2024 00:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968313;
	bh=tz78pgMR6i+q8XYG8UJMcGu4RVnY5fBvNucqMJNZpbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lZRnth70svDDY/AoU+ibdykvK3RUzllMFtSDWT6WeYNnERP00LI5yXqvFebAjGGB0
	 sHon3UXHJGw74cI33mdwm85zd8oKtHQr4iywMJHeQgF/QbUZfEPDsHQSLJVRBXQHD6
	 2tyiDtIjIuptJ8LRipnA3pD7114tZBftu0Uioz+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 077/148] wifi: rtlwifi: rtl8192cu: using calculate_bit_shift()
Date: Mon, 22 Jan 2024 15:57:13 -0800
Message-ID: <20240122235715.512403216@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235712.442097787@linuxfoundation.org>
References: <20240122235712.442097787@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Su Hui <suhui@nfschina.com>

[ Upstream commit f4088c8fcbabadad9dd17d17ae9ba24e9e3221ec ]

Using calculate_bit_shift() to replace _rtl92c_phy_calculate_bit_shift().
And fix an undefined bitwise shift behavior problem.

Fixes: f0a39ae738d6 ("rtlwifi: rtl8192cu: Add routine phy")
Signed-off-by: Su Hui <suhui@nfschina.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://msgid.link/20231219065739.1895666-6-suhui@nfschina.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/phy.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/phy.c
index f068dd5317a7..5a5476a2dc2f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/phy.c
@@ -54,7 +54,7 @@ u32 rtl92cu_phy_query_rf_reg(struct ieee80211_hw *hw,
 		original_value = _rtl92c_phy_fw_rf_serial_read(hw,
 							       rfpath, regaddr);
 	}
-	bitshift = _rtl92c_phy_calculate_bit_shift(bitmask);
+	bitshift = calculate_bit_shift(bitmask);
 	readback_value = (original_value & bitmask) >> bitshift;
 	RT_TRACE(rtlpriv, COMP_RF, DBG_TRACE,
 		 "regaddr(%#x), rfpath(%#x), bitmask(%#x), original_value(%#x)\n",
@@ -78,7 +78,7 @@ void rtl92cu_phy_set_rf_reg(struct ieee80211_hw *hw,
 			original_value = _rtl92c_phy_rf_serial_read(hw,
 								    rfpath,
 								    regaddr);
-			bitshift = _rtl92c_phy_calculate_bit_shift(bitmask);
+			bitshift = calculate_bit_shift(bitmask);
 			data =
 			    ((original_value & (~bitmask)) |
 			     (data << bitshift));
@@ -89,7 +89,7 @@ void rtl92cu_phy_set_rf_reg(struct ieee80211_hw *hw,
 			original_value = _rtl92c_phy_fw_rf_serial_read(hw,
 								       rfpath,
 								       regaddr);
-			bitshift = _rtl92c_phy_calculate_bit_shift(bitmask);
+			bitshift = calculate_bit_shift(bitmask);
 			data =
 			    ((original_value & (~bitmask)) |
 			     (data << bitshift));
-- 
2.43.0




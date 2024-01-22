Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1539B154441;
	Tue, 23 Jan 2024 00:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969382; cv=none; b=c0cJSK6JSCM7u2y+6EQvOdivkjcP0xE5Hx8zC2cQ+zitGr+wRQSgo8u4uWWp8omtkO7KHS49NFRE1ijc8DY44ObEdXzEW0gmJ/TXI7FTNZrxXr/5Z8FsdVm+ey+zP+sBLR2MMpE3YnjY+E8Nf05Sp2pvElV29jbhAeiCBLdb/yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969382; c=relaxed/simple;
	bh=+R3VTlMJm3JCBY/c+sgpTNhr3YyolD/QUQMv3fZTmec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S9dDKHv3F9yBOKNP6AAuhmDZtJlVVi79cbJqYSFhP8RGOlMlFd6GxqkCI232QIwsan0eDrYpJPpDXH8sDZ51IMryDNH2tHAAtrEXnop7KRwhaPI2D0oKLTD5OJ+frm39lwOdTw5CyQQknDYcfKvavWyf60EjxpMN4yc5WMTkf5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sWdGhRmC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sWdGhRmC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFDD5C433F1;
	Tue, 23 Jan 2024 00:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969381;
	bh=+R3VTlMJm3JCBY/c+sgpTNhr3YyolD/QUQMv3fZTmec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sWdGhRmCIgi3pYX/Cgqi382L2fOdbCYuM8u/hYyBYbUOrLLAQZXUofHf4P4qN2yY8
	 wxOJp/y6GJxAAX2hIhFq/8FNknuN+eoU5NO8dG+oMDHbxyPFg/gjsRMkrPm2CKZ5iU
	 Ybv7uuWzSYcrmdlLP+ADMzClUHESiSv9VJRNgblU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 207/641] wifi: rtlwifi: add calculate_bit_shift()
Date: Mon, 22 Jan 2024 15:51:51 -0800
Message-ID: <20240122235824.429802447@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Su Hui <suhui@nfschina.com>

[ Upstream commit 52221dfddbbfb5b4e029bb2efe9bb7da33ec1e46 ]

There are many same functions like _rtl88e_phy_calculate_bit_shift(),
_rtl92c_phy_calculate_bit_shift() and so on. And these functions can
cause undefined bitwise shift behavior. Add calculate_bit_shift() to
replace them and fix undefined behavior in subsequent patches.

Signed-off-by: Su Hui <suhui@nfschina.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://msgid.link/20231219065739.1895666-2-suhui@nfschina.com
Stable-dep-of: 969bc926f04b ("wifi: rtlwifi: rtl8188ee: phy: using calculate_bit_shift()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtlwifi/wifi.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
index 31a481f43a07..5d842cc394aa 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -3069,4 +3069,11 @@ static inline struct ieee80211_sta *rtl_find_sta(struct ieee80211_hw *hw,
 	return ieee80211_find_sta(mac->vif, mac_addr);
 }
 
+static inline u32 calculate_bit_shift(u32 bitmask)
+{
+	if (WARN_ON_ONCE(!bitmask))
+		return 0;
+
+	return __ffs(bitmask);
+}
 #endif
-- 
2.43.0




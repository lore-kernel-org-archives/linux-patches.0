Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F338359B78;
	Tue, 23 Jan 2024 01:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974087; cv=none; b=LKAu8paOTTCqo0d7XMoGqTtRoRvDqi+0EUjA4PsxyWmHnChD7x+52B0x1sHVXw6ELpk1eooxYJhFXdt6y8c9uPSEnArUcnLeVVR4iH34GuV8PLVeA1NbKlVzTY0BtdoDpAyc2cx2J3j06jJDLAvxj64wrkuGAgbgK84oYpKlNKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974087; c=relaxed/simple;
	bh=/mxLaEAUbaNnKsbfl6or7es4PTwkiazKzZQzTM6GpCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q2MvihXS+V/a3ehl8G8A0eEJuw247HVhRnI3DIjgqvH+5JR15jNBSf3wZwCThIui4SyE9iWuhu3Dch1tpDHW3GOerD8WBEpJvsWfyefTKaO8X1AB+sJ2H8uTvrfYoQdvLD+XlYgcT/gs0wYf6WlLSbyCQrvEP1eUpolJKnrjspk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iJnCtM8h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iJnCtM8h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38755C43390;
	Tue, 23 Jan 2024 01:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974086;
	bh=/mxLaEAUbaNnKsbfl6or7es4PTwkiazKzZQzTM6GpCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iJnCtM8hgmJ4n9vPQSfCDAOI+4zXs8cCQ09CFIb/E5g1zOxSkFH5qY/DXIVDqQhiY
	 Fwv6yv6hmKgkjUwW1jew9xTDH0/Dk8YT+BqVpqlwEfpCgi+JhlC0wGX2Ad0Cjlik3C
	 /XLZXchK7IV4tYhzqyGNhbDRGqn9RCEQnK2nNymc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 158/374] wifi: rtlwifi: rtl8192cu: using calculate_bit_shift()
Date: Mon, 22 Jan 2024 15:56:54 -0800
Message-ID: <20240122235750.104579171@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a8d9fe269f31..0b8cb7e61fd8 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/phy.c
@@ -32,7 +32,7 @@ u32 rtl92cu_phy_query_rf_reg(struct ieee80211_hw *hw,
 		original_value = _rtl92c_phy_fw_rf_serial_read(hw,
 							       rfpath, regaddr);
 	}
-	bitshift = _rtl92c_phy_calculate_bit_shift(bitmask);
+	bitshift = calculate_bit_shift(bitmask);
 	readback_value = (original_value & bitmask) >> bitshift;
 	rtl_dbg(rtlpriv, COMP_RF, DBG_TRACE,
 		"regaddr(%#x), rfpath(%#x), bitmask(%#x), original_value(%#x)\n",
@@ -56,7 +56,7 @@ void rtl92cu_phy_set_rf_reg(struct ieee80211_hw *hw,
 			original_value = _rtl92c_phy_rf_serial_read(hw,
 								    rfpath,
 								    regaddr);
-			bitshift = _rtl92c_phy_calculate_bit_shift(bitmask);
+			bitshift = calculate_bit_shift(bitmask);
 			data =
 			    ((original_value & (~bitmask)) |
 			     (data << bitshift));
@@ -67,7 +67,7 @@ void rtl92cu_phy_set_rf_reg(struct ieee80211_hw *hw,
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




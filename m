Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 447BD6F074;
	Wed, 21 Feb 2024 13:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522588; cv=none; b=QnsYXLG6+fsTAI0hd24efGqkO+A7TWyWLQejgVHlPfOjwP61Tv1PLCVJe2hSTvqbRLtFrP9j6RInQbtU8IvFGC9SUSoL1t6bPG8sEMfALLp7Q5ELRK1evBuI8Aem5HasDJJ9a7fpELPLvz3yTCslGrzKWRsaR8noaJVe20jT+9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522588; c=relaxed/simple;
	bh=2SckYSpan7PnItNgVrtbL009Z1mF8DibdoMZ/k2IsDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bOzqkNF52WkxOrzQZjkADSO8T1qAneGsP9RDwDCXQTOU8hMHanUqdLUogY6e4IVx0qniqZmcxLhT/HMFF1Fh6Dk7m4vPlb/j9OmA3NfybAIdYm17aNy8TZ7LRh0TqLTCgwmOspCqjJeDUwlZ4gS7EjCc5upE20l1fMXmAKmy9jA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mRaVbgHw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mRaVbgHw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6483C433F1;
	Wed, 21 Feb 2024 13:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522588;
	bh=2SckYSpan7PnItNgVrtbL009Z1mF8DibdoMZ/k2IsDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mRaVbgHwK/aT0PnjwoYKSBWF4gcOMfW+gEuRq44ZAADGI6vkyMYFg6pSKCReoEXdE
	 GRwxEtZtyQ1o5ZViU+DjAC+i0qiaY9iscp6J/SIIdQpgkMUHn0BjhBcCPPw2l20M85
	 vSO9cbA+PaBMLVHMycdTJBnPH7meuvHtS2fTTj7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 201/476] wifi: rtlwifi: rtl8723{be,ae}: using calculate_bit_shift()
Date: Wed, 21 Feb 2024 14:04:12 +0100
Message-ID: <20240221130015.346633797@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

[ Upstream commit 5c16618bc06a41ad68fd8499a21d35ef57ca06c2 ]

Using calculate_bit_shift() to replace rtl8723_phy_calculate_bit_shift().
And fix an undefined bitwise shift behavior problem.

Signed-off-by: Su Hui <suhui@nfschina.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://msgid.link/20231219065739.1895666-12-suhui@nfschina.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.c | 6 +++---
 drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c | 4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.c
index fe9b407dc2af..71e29b103da5 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.c
@@ -49,7 +49,7 @@ u32 rtl8723e_phy_query_rf_reg(struct ieee80211_hw *hw,
 							    rfpath, regaddr);
 	}
 
-	bitshift = rtl8723_phy_calculate_bit_shift(bitmask);
+	bitshift = calculate_bit_shift(bitmask);
 	readback_value = (original_value & bitmask) >> bitshift;
 
 	spin_unlock(&rtlpriv->locks.rf_lock);
@@ -80,7 +80,7 @@ void rtl8723e_phy_set_rf_reg(struct ieee80211_hw *hw,
 			original_value = rtl8723_phy_rf_serial_read(hw,
 								    rfpath,
 								    regaddr);
-			bitshift = rtl8723_phy_calculate_bit_shift(bitmask);
+			bitshift = calculate_bit_shift(bitmask);
 			data =
 			    ((original_value & (~bitmask)) |
 			     (data << bitshift));
@@ -89,7 +89,7 @@ void rtl8723e_phy_set_rf_reg(struct ieee80211_hw *hw,
 		rtl8723_phy_rf_serial_write(hw, rfpath, regaddr, data);
 	} else {
 		if (bitmask != RFREG_OFFSET_MASK) {
-			bitshift = rtl8723_phy_calculate_bit_shift(bitmask);
+			bitshift = calculate_bit_shift(bitmask);
 			data =
 			    ((original_value & (~bitmask)) |
 			     (data << bitshift));
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c
index 2b9313cb93db..094cb36153f5 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c
@@ -41,7 +41,7 @@ u32 rtl8723be_phy_query_rf_reg(struct ieee80211_hw *hw, enum radio_path rfpath,
 	spin_lock(&rtlpriv->locks.rf_lock);
 
 	original_value = rtl8723_phy_rf_serial_read(hw, rfpath, regaddr);
-	bitshift = rtl8723_phy_calculate_bit_shift(bitmask);
+	bitshift = calculate_bit_shift(bitmask);
 	readback_value = (original_value & bitmask) >> bitshift;
 
 	spin_unlock(&rtlpriv->locks.rf_lock);
@@ -68,7 +68,7 @@ void rtl8723be_phy_set_rf_reg(struct ieee80211_hw *hw, enum radio_path path,
 	if (bitmask != RFREG_OFFSET_MASK) {
 			original_value = rtl8723_phy_rf_serial_read(hw, path,
 								    regaddr);
-			bitshift = rtl8723_phy_calculate_bit_shift(bitmask);
+			bitshift = calculate_bit_shift(bitmask);
 			data = ((original_value & (~bitmask)) |
 				(data << bitshift));
 		}
-- 
2.43.0




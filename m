Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6E0C69D33;
	Wed, 21 Feb 2024 13:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521364; cv=none; b=HPBYNmXWdY+LMZKFuq7aWQ7fyUpHbxOProyqohcQXjoyq5CR/heq+I2l/BuT4tfDsLs/8iEpsPO0z6B+sCwMaxBpI1lzCUHGEu1/YkYu6QcZ/MwB7wYQZsu6B+ikev12VDbAIx83XyiwpycWIRFZW9bfI7BPsnB5ABpdztp3nWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521364; c=relaxed/simple;
	bh=XG+cNPBiFdx2qFkul6b2It4G57xAM65G0d6YP1an+IE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r98u/sCJAIul7HVXX8ZTop6cyzw2ippzYJrC4kaxkgLa/YIkQy564BNNLtsUPhNJDdI181/6YS9VKXRU4xfothB1EEFxxSghWqNoOzJjnCXj8R+L0YSOPyM6lSoiXbhczgiwpJCyWGttdccx2GrTD/m/MW20QnyXY4N1G2+vc7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t8t1k7af; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t8t1k7af"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18A92C433C7;
	Wed, 21 Feb 2024 13:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521363;
	bh=XG+cNPBiFdx2qFkul6b2It4G57xAM65G0d6YP1an+IE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t8t1k7afGDTQwaFMgRqZQvhHHlFYIPhY/XBzH8BXym4PLZOEfQIn0QFKrfPoG+Ryi
	 edVhpF1smI2hmRTxUwRSFT6M+Jdhw6m/+XAcMPDfTkFU01OwzpeNYbkE6lEJ1j60CZ
	 4F19dyWMIicMYJFEnTMh6MggC6Bluo1nx3Yv3JME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 094/202] wifi: rtlwifi: rtl8723{be,ae}: using calculate_bit_shift()
Date: Wed, 21 Feb 2024 14:06:35 +0100
Message-ID: <20240221125934.822932532@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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
index 5cf29f5a4b54..e6ac496e898e 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.c
@@ -72,7 +72,7 @@ u32 rtl8723e_phy_query_rf_reg(struct ieee80211_hw *hw,
 							    rfpath, regaddr);
 	}
 
-	bitshift = rtl8723_phy_calculate_bit_shift(bitmask);
+	bitshift = calculate_bit_shift(bitmask);
 	readback_value = (original_value & bitmask) >> bitshift;
 
 	spin_unlock_irqrestore(&rtlpriv->locks.rf_lock, flags);
@@ -104,7 +104,7 @@ void rtl8723e_phy_set_rf_reg(struct ieee80211_hw *hw,
 			original_value = rtl8723_phy_rf_serial_read(hw,
 								    rfpath,
 								    regaddr);
-			bitshift = rtl8723_phy_calculate_bit_shift(bitmask);
+			bitshift = calculate_bit_shift(bitmask);
 			data =
 			    ((original_value & (~bitmask)) |
 			     (data << bitshift));
@@ -113,7 +113,7 @@ void rtl8723e_phy_set_rf_reg(struct ieee80211_hw *hw,
 		rtl8723_phy_rf_serial_write(hw, rfpath, regaddr, data);
 	} else {
 		if (bitmask != RFREG_OFFSET_MASK) {
-			bitshift = rtl8723_phy_calculate_bit_shift(bitmask);
+			bitshift = calculate_bit_shift(bitmask);
 			data =
 			    ((original_value & (~bitmask)) |
 			     (data << bitshift));
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c
index 1263b12db5dc..bbbbf61d7bcf 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c
@@ -64,7 +64,7 @@ u32 rtl8723be_phy_query_rf_reg(struct ieee80211_hw *hw, enum radio_path rfpath,
 	spin_lock_irqsave(&rtlpriv->locks.rf_lock, flags);
 
 	original_value = rtl8723_phy_rf_serial_read(hw, rfpath, regaddr);
-	bitshift = rtl8723_phy_calculate_bit_shift(bitmask);
+	bitshift = calculate_bit_shift(bitmask);
 	readback_value = (original_value & bitmask) >> bitshift;
 
 	spin_unlock_irqrestore(&rtlpriv->locks.rf_lock, flags);
@@ -92,7 +92,7 @@ void rtl8723be_phy_set_rf_reg(struct ieee80211_hw *hw, enum radio_path path,
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




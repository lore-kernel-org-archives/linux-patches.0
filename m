Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 923F342A97;
	Tue, 23 Jan 2024 01:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974092; cv=none; b=MvYLyqcnw7pwgvkGmEvdl6CEGnFs+CQuayx6U57LwxdGys6BrEMOVMFej+QQst5QefHOXtDCBuxxLAzv79HvTGi2wIZCF3qCN6F6FqBqHuUiVyQzfNJv4t3klppt2XKh1hLxTL7VV6jN9m4s4VDi6ne2pSnr/Yjnr/ktFSvgfTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974092; c=relaxed/simple;
	bh=nyIHBGaIYwANy8N5gqEqRjv642EBBkhnjktzdV8F4eA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T/EVK3068kPj+1/6cbooSSc24Tom42vyUcMHfr4PN3FCBZtihunn/Ef9zrJCZFKjb65wJZzzm7Bsfd2U0np12OQtGTA29XiXBRIV4KHHM0Z3U+ir5ECpGrVNfix1KYv92TRL00d4eHQENVwXh3Mw6XriCtJ6p29Xs7kaUVwPLpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ivLhKcS5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ivLhKcS5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77CA1C43390;
	Tue, 23 Jan 2024 01:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974091;
	bh=nyIHBGaIYwANy8N5gqEqRjv642EBBkhnjktzdV8F4eA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ivLhKcS5ul/K4ouTN8C5GJzxpufzAMeU1TC6MM1m1y//JaBo4n4RKOnMbhzZZGiuM
	 WpfcD4HWDeRV3IUrcKh+6Ynx4KJe3ReKeM4l7yrSNgfItpzdO6tXbT5P1/kdoDlvVT
	 MxneW1g4kM0Bgp+HCZetukRfgJDOQZ/SZn7RHye0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 159/374] wifi: rtlwifi: rtl8192ce: using calculate_bit_shift()
Date: Mon, 22 Jan 2024 15:56:55 -0800
Message-ID: <20240122235750.140041166@linuxfoundation.org>
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

[ Upstream commit 3d03e8231031bcc65a48cd88ef9c71b6524ce70b ]

Using calculate_bit_shift() to replace _rtl92c_phy_calculate_bit_shift().
And fix the undefined bitwise shift behavior problem.

Fixes: 0c8173385e54 ("rtl8192ce: Add new driver")
Signed-off-by: Su Hui <suhui@nfschina.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://msgid.link/20231219065739.1895666-7-suhui@nfschina.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192ce/phy.c | 6 +++---
 drivers/net/wireless/realtek/rtlwifi/rtl8192ce/phy.h | 1 -
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/phy.c
index 04735da11168..6b98e77768e9 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/phy.c
@@ -39,7 +39,7 @@ u32 rtl92c_phy_query_rf_reg(struct ieee80211_hw *hw,
 							       rfpath, regaddr);
 	}
 
-	bitshift = _rtl92c_phy_calculate_bit_shift(bitmask);
+	bitshift = calculate_bit_shift(bitmask);
 	readback_value = (original_value & bitmask) >> bitshift;
 
 	spin_unlock(&rtlpriv->locks.rf_lock);
@@ -110,7 +110,7 @@ void rtl92ce_phy_set_rf_reg(struct ieee80211_hw *hw,
 			original_value = _rtl92c_phy_rf_serial_read(hw,
 								    rfpath,
 								    regaddr);
-			bitshift = _rtl92c_phy_calculate_bit_shift(bitmask);
+			bitshift = calculate_bit_shift(bitmask);
 			data =
 			    ((original_value & (~bitmask)) |
 			     (data << bitshift));
@@ -122,7 +122,7 @@ void rtl92ce_phy_set_rf_reg(struct ieee80211_hw *hw,
 			original_value = _rtl92c_phy_fw_rf_serial_read(hw,
 								       rfpath,
 								       regaddr);
-			bitshift = _rtl92c_phy_calculate_bit_shift(bitmask);
+			bitshift = calculate_bit_shift(bitmask);
 			data =
 			    ((original_value & (~bitmask)) |
 			     (data << bitshift));
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/phy.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/phy.h
index 7582a162bd11..c7a0d4c776f0 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/phy.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/phy.h
@@ -94,7 +94,6 @@ u32 _rtl92c_phy_rf_serial_read(struct ieee80211_hw *hw, enum radio_path rfpath,
 			       u32 offset);
 u32 _rtl92c_phy_fw_rf_serial_read(struct ieee80211_hw *hw,
 				  enum radio_path rfpath, u32 offset);
-u32 _rtl92c_phy_calculate_bit_shift(u32 bitmask);
 void _rtl92c_phy_rf_serial_write(struct ieee80211_hw *hw,
 				 enum radio_path rfpath, u32 offset, u32 data);
 void _rtl92c_phy_fw_rf_serial_write(struct ieee80211_hw *hw,
-- 
2.43.0




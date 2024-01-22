Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF7C52C1A7;
	Tue, 23 Jan 2024 00:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968317; cv=none; b=gdAhDfX8+o8FpfunYxlxXBNnrz6DX5w7d1gdeDjXJ5gbHHi84U3E9SJZixXU22V8dKJLyk6+c6Wmsn0dmorXlhF9dUtU+4mpV9xm1AUL1QpZIHdrUGJZZcmh9iKwNuHmJCr1IuL0FPbjHBxDQlTSOMafWed5+ptEYmKB9u5Yvgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968317; c=relaxed/simple;
	bh=xYqTHrniqfLURHdPji1HIMiLr66XOIfXfWEfqPjw3C0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XY2O3BYOAzIVQ47muNkCWcroOoVXJfQT0hrbz338PMGLtIYYZ0yL24u2s0O3PoBQPbcPeep7tlRNszJMs7FuuesewXQ22PUQttuWJeL0ymi1IUggFaDsOY71CoDvAvx5UwNPoHfuhaZkETRTHPG3hcQ+WQLlW+A0eIlTQZ4/zJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UGKxdRTb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UGKxdRTb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C94EBC433B1;
	Tue, 23 Jan 2024 00:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968317;
	bh=xYqTHrniqfLURHdPji1HIMiLr66XOIfXfWEfqPjw3C0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UGKxdRTbVMd8uEc29Z3VlWlIJeqD86krrXhphYROQdyHMc0ehbcjw8YA4Hr2GmYAI
	 9tbQCmY3VLFm85nHyzDJ5zKmEaIBOpHrRdXdYmfTOBi/0rl0gbb8Iln5gPWOWoOA6Z
	 6wBsr9YRuiT7GxxG/AmnitMGnsTGpMhpG6fvZvYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 078/148] wifi: rtlwifi: rtl8192ce: using calculate_bit_shift()
Date: Mon, 22 Jan 2024 15:57:14 -0800
Message-ID: <20240122235715.562353187@linuxfoundation.org>
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
index 7c6d7fc1ef9a..9f478d8af804 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/phy.c
@@ -61,7 +61,7 @@ u32 rtl92c_phy_query_rf_reg(struct ieee80211_hw *hw,
 							       rfpath, regaddr);
 	}
 
-	bitshift = _rtl92c_phy_calculate_bit_shift(bitmask);
+	bitshift = calculate_bit_shift(bitmask);
 	readback_value = (original_value & bitmask) >> bitshift;
 
 	spin_unlock(&rtlpriv->locks.rf_lock);
@@ -132,7 +132,7 @@ void rtl92ce_phy_set_rf_reg(struct ieee80211_hw *hw,
 			original_value = _rtl92c_phy_rf_serial_read(hw,
 								    rfpath,
 								    regaddr);
-			bitshift = _rtl92c_phy_calculate_bit_shift(bitmask);
+			bitshift = calculate_bit_shift(bitmask);
 			data =
 			    ((original_value & (~bitmask)) |
 			     (data << bitshift));
@@ -144,7 +144,7 @@ void rtl92ce_phy_set_rf_reg(struct ieee80211_hw *hw,
 			original_value = _rtl92c_phy_fw_rf_serial_read(hw,
 								       rfpath,
 								       regaddr);
-			bitshift = _rtl92c_phy_calculate_bit_shift(bitmask);
+			bitshift = calculate_bit_shift(bitmask);
 			data =
 			    ((original_value & (~bitmask)) |
 			     (data << bitshift));
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/phy.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/phy.h
index 93f3bc0197b4..e084a91e26d9 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/phy.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/phy.h
@@ -116,7 +116,6 @@ u32 _rtl92c_phy_rf_serial_read(struct ieee80211_hw *hw, enum radio_path rfpath,
 			       u32 offset);
 u32 _rtl92c_phy_fw_rf_serial_read(struct ieee80211_hw *hw,
 				  enum radio_path rfpath, u32 offset);
-u32 _rtl92c_phy_calculate_bit_shift(u32 bitmask);
 void _rtl92c_phy_rf_serial_write(struct ieee80211_hw *hw,
 				 enum radio_path rfpath, u32 offset, u32 data);
 void _rtl92c_phy_fw_rf_serial_write(struct ieee80211_hw *hw,
-- 
2.43.0



